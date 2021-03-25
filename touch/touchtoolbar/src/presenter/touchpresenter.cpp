#include "presenter/touchpresenter.h"


//#include <stdio.h>
#include "sdk/tdebug.h"
#include "sdk/tPrintf.h"
#include <QTime>
#include <QQmlProperty>
#include <QSysInfo>
#include "sdk/TouchManager.h"
#include <windows.h>


#define UPGRADE_FILE_DIR  "config/"
#define MODE_SETTING_FILE "modeSetting.json"
#define BATCH_FINISH_SUCCESS    2
#define BATCH_FINISH_ERROR      3
#define BATCH_CANCEL            5

int TouchPresenter::currentTab = 0;
TouchPresenter::TouchPresenter(QObject *parent, QObject *component) : QObject(parent),
    signalThread(this), sem(0), settings("newskyer", "TouchAssistant"),paintSem(0),touchManager(NULL),
    initSdkDone(false),batchCancel(true), calibrationMode(false)
{

    this->component = component;
    if (component != NULL) {

        QObject::connect(component, SIGNAL(agingFinished(int)),
                         this, SIGNAL(agingFinished(int)));
        QObject::connect(this, SIGNAL(setUpgradeProgress(QVariant)),
                         component, SLOT(updateUpgradeProgress(QVariant)));
        QObject::connect(this, SIGNAL(setTestProgress(QVariant)),
                         component, SLOT(updateTestProgress(QVariant)));
        QObject::connect(this, SIGNAL(setMessageText(QVariant)),
                         component, SLOT(setText(QVariant)));
        QObject::connect(this, SIGNAL(appendMessageText(QVariant, QVariant)),
                         component, SLOT(appendText(QVariant, QVariant)));
        QObject::connect(this, SIGNAL(hotplug(QVariant)),
                         component, SLOT(onHotplug(QVariant)));
    }
}

QVariantMap TouchPresenter::getSignalItems()
{
    QVariantMap map;
    if (touch == NULL) {
        map.insert("result", 1);
        return map;
    }

    return touch->getSignalItems();
}

void TouchPresenter::startGetSignalDataBg(QVariant index)
{
    signalThread.running = true;
    signalThread.start();
}

QVariantMap TouchPresenter::getBoardAndLampData()
{
    return touch->getBoardAndLampData();
}

void TouchPresenter::debug(QVariant msg)
{
    TDebug::debug(msg.toString());
}

void TouchPresenter::error(QVariant msg)
{
    TDebug::error(msg.toString());
}

void TouchPresenter::GetSignalThread::run()
{
//    presenter->paintDefaultLock();
    TDEBUG("GetSignalThread thread start running");
    int index;
    int count = 0;
    bool ok;
#define FIXED_PERIOD (16) // 60Fps
    long period = FIXED_PERIOD;
    while (running) {

        QTime time;
        time.start();
        //TDEBUG("run start");
//        presenter->paintLock();
        QVariantList list = presenter->signalList;
//        TDEBUG("################################:list.length = %d",list.length());
        foreach (QVariant const &value, list) {
            index = value.toInt(&ok);
            if (!ok)
                continue;
            if (!running)
                break;
//            TDEBUG("get signal data");

//            presenter->signalDataMap.clear();
             QVariantMap map = presenter->getSignalData(index, count);

            QMetaObject::invokeMethod(presenter->component, "updateSignalData",
                Q_ARG(QVariant, QVariant::fromValue(map)));
        }
//        TDEBUG("@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@:list.length = %d",list.length());
        QThread::msleep(1);
//        long delay = period - time.elapsed();
//        if (delay > 0) {
//            // excess
//            if (!running)
//                break;
//            QThread::msleep(delay);
//            period = FIXED_PERIOD;
//        } else {
//            // insufficient, need add this overtime
//            period = FIXED_PERIOD + delay;
//        }
    }
    finshed = true;
    TDEBUG("GetSignalThread thread end");
}
QVariantMap TouchPresenter::getSignalDataMap()
{
    return this->signalDataMap;
}

QVariantMap TouchPresenter::getSettingsInfos()
{
    QVariantMap map;
    qint8 val;
    int ret;
    touch_device *dev = touchManager->firstConnectedDevice();
    if (dev == NULL)
        return map;
    bool isXP = (int)QSysInfo::WindowsVersion == (int)QSysInfo::WV_XP;
    if (isXP) {
        map.insert("usbMode", 1);
        touchManager->setCoordsMode(dev, COORDS_CHANNEL_USB, COORDS_USB_MODE_MOUSE);
    } else {
        val = -1;
        ret = touchManager->getCoordsMode(dev, COORDS_CHANNEL_USB, &val);
        map.insert("usbMode", val);
        TVERBOSE("usbMode:%d", val);
    }

    val = -1;
    ret = touchManager->getCoordsMode(dev, COORDS_CHANNEL_SERIAL, &val);
    map.insert("serialMode", val);
    TVERBOSE("serial mode: %d", val);

    //获取旋转参数
    qint8 values[2] = {-1, -1}, defs[2];
    touchManager->getRotation(dev, values, defs);
    map.insert("touchRotation", values[0]);
    map.insert("screenRotation", values[1]);
    TVERBOSE("touch rotation: %d", values[0]);
    TVERBOSE("screen rotation: %d", values[1]);

    //获取触摸框坐标翻转参数
    values[0] = values[1] = -1;
    touchManager->getMirror(dev, values, defs);
    map.insert("xMirror", values[0]);
    map.insert("yMirror", values[1]);
    TVERBOSE("xMirror: %d", values[0]);
    TVERBOSE("yMirror: %d", values[1]);

    //获取MAC OS坐标模式的设定
    values[0] = -1;
    touchManager->getMacOSMode(dev, values, defs);
    map.insert("mac", values[0]);
    TVERBOSE("mac: %d", values[0]);

    //获取坐标通道是否已经使能
    qint8 enabled = 0;
    touchManager->getCoordsEnabled(dev, COORDS_CHANNEL_USB, &enabled);
    map.insert("usbEnabled", enabled);
    TVERBOSE("usb enabled: %d", enabled);

    touchManager->getCoordsEnabled(dev, COORDS_CHANNEL_SERIAL, &enabled);
    map.insert("serialEnabled", enabled);
    TVERBOSE("serial enabled: %d", enabled);

    //获取AGC锁定状态
    enabled = touchManager->isLockAGC(dev);
    map.insert("lockAGC", enabled);
    TINFO("LockAGC: %d", enabled);

    return map;
}

QVariant TouchPresenter::setSettings(QVariant key, QVariant value)
{
    const QString k = key.toString();
    touch_device *dev = touchManager->firstConnectedDevice();
    if (dev == NULL || !dev->touch.connected)
        return QVariant::fromValue(false);
    int ret;
    if (k == "usbMode") {
        ret = touchManager->setCoordsMode(dev, COORDS_CHANNEL_USB, (qint8)value.toInt());
        TVERBOSE("set usbMode %d, %d", value.toInt(), ret);
    } else if (k == "serialMode") {
        ret = touchManager->setCoordsMode(dev, COORDS_CHANNEL_SERIAL, (qint8)value.toInt());
        TVERBOSE("set serialMode %d, %d", value.toInt(), ret);
    } else if (k == "touchRotation") {
        qint8 values[2], defs[2];
        touchManager->getRotation(dev, values, defs);
        values[0] = value.toInt();
        ret = touchManager->setRotation(dev, values);
        TVERBOSE("set touch rotation %d, %d", value.toInt(), ret);
    } else if (k == "screenRotation") {
        qint8 values[2], defs[2];
        touchManager->getRotation(dev, values, defs);
        values[1] = value.toInt();
        ret = touchManager->setRotation(dev, values);
        TVERBOSE("set screen rotation %d, %d", value.toInt(), ret);
    } else if (k == "xMirror") {
        qint8 values[2], defs[2];
        touchManager->getMirror(dev, values, defs);
        values[0] = value.toInt();
        ret = touchManager->setMirror(dev, values);
        TVERBOSE("set x mirror%d, %d", value.toInt(), ret);
    } else if (k == "yMirror") {
        qint8 values[2], defs[2];
        touchManager->getMirror(dev, values, defs);
        values[1] = value.toInt();
        ret = touchManager->setMirror(dev, values);
        TVERBOSE("set y mirror%d, %d", value.toInt(), ret);
    } else if (k == "lockAGC") {
        int en = value.toInt();
        touchManager->setLockAGC(dev, en != 0 ? 1 : 0);
        TINFO("set lock: %d", en);
        TVERBOSE("set LockAGC %d", en);
    } else if (k == "mac") {
        ret = touchManager->setMacOSMode(dev, (qint8)value.toInt());
        TVERBOSE("set mac os %d, %d", value.toInt(), ret);
    }
    return QVariant::fromValue(ret == 0);
}

QVariantMap TouchPresenter::getSignalData(QVariant index, int count)
{
    if (touch == NULL) {
        QVariantMap map;
        map.insert("result", 1);
        return map;
    }
    return touch->getSignalData(index, count);
}

void TouchPresenter::updateFireware(QVariant path)
{
    //printf("update Fireware: %s\n", path.toString().toStdString().c_str());
    TDebug::info(path.toString());
    emit upgradeFireware(path.toString());
}

void TouchPresenter::showDialog(QString title, QString message, int type)
{
    if (component == NULL) {
        TDebug::warning("component is NULL");
        return;
    }
    QVariant returnedValue;
    QMetaObject::invokeMethod(component, "showDialog",
    Q_RETURN_ARG(QVariant, returnedValue),
    Q_ARG(QVariant, title),
    Q_ARG(QVariant, message),
    Q_ARG(QVariant, type));
}

void TouchPresenter::setUpgradeButtonText(QString text)
{
    if (component == NULL) {
        TDebug::warning("component is NULL");
        return;
    }
    QMetaObject::invokeMethod(component, "setUpgradeButtonText",
    Q_ARG(QVariant, text));
}
void TouchPresenter::setTextButtonText(int status)
{
    if (component == NULL) {
        TDebug::warning("component is NULL");
        return;
    }
    QMetaObject::invokeMethod(component, "setTextButtonText",
    Q_ARG(QVariant, status));
}

void TouchPresenter::setTestButtonEnable(bool enable)
{
    if (component == NULL) {
        TDebug::warning("component is NULL");
        return;
    }
    QMetaObject::invokeMethod(component, "setTestButtonEnable",
    Q_ARG(QVariant, enable));
}
void TouchPresenter::setTestButtonCheck(bool check)
{
    if (component == NULL) {
        TDebug::warning("component is NULL");
        return;
    }
    QMetaObject::invokeMethod(component, "setTestButtonCheck",
                              Q_ARG(QVariant, check));
}

void TouchPresenter::setVisibleValue()
{
    if (component == NULL) {
        TDebug::warning("component is NULL");
        return;
    }
    QMetaObject::invokeMethod(component, "setVisibleValue");
}

void TouchPresenter::changeOnboardtestString(QString info)
{
    if (component == NULL) {
        TDebug::warning("component is NULL");
        return;
    }
    QMetaObject::invokeMethod(component, "changeOnboardtestString",
                              Q_ARG(QVariant, info));
}

    void setUpgrading(bool u);
    void setTesting(bool t);
void TouchPresenter::setUpgrading(bool u)
{
    if (component == NULL) {
        TDebug::warning("component is NULL");
        return;
    }
    QMetaObject::invokeMethod(component, "setUpgrading",
    Q_ARG(QVariant, u));
}
void TouchPresenter::setTesting(bool t)
{
    if (component == NULL) {
        TDebug::warning("component is NULL");
        return;
    }
    QMetaObject::invokeMethod(component, "setTesting",
                              Q_ARG(QVariant, t));
}

void TouchPresenter::autoTestConnect()
{
    if (component == NULL) {
        TDebug::warning("component is NULL");
        return;
    }
    QMetaObject::invokeMethod(component, "autoTestConnect");
}

void TouchPresenter::clearTestInfo()
{
    if (component == NULL) {
        TDebug::warning("component is NULL");
        return;
    }
    QMetaObject::invokeMethod(component, "clearTestInfo");
}
void TouchPresenter::setUpgradeButtonEnable(bool enable)
{
    if (component == NULL) {
        TDebug::warning("component is NULL");
        return;
    }
    QMetaObject::invokeMethod(component, "setUpgradeButtonEnable",
                              Q_ARG(QVariant, enable));
}

void TouchPresenter::refreshOnboardTestData(QVariantMap map)
{
    if (component == NULL) {
        TDebug::warning("component is NULL");
        return;
    }
    QMetaObject::invokeMethod(component, "refreshOnboardTestData",
                              Q_ARG(QVariant, map));
}


void TouchPresenter::setFileText(QString path)
{
    if (component == NULL) {
        TDebug::warning("component is NULL");
        return;
    }
    QMetaObject::invokeMethod(component, "setUpgradeFile",
                              Q_ARG(QVariant, path),
                              Q_ARG(QVariant, 0));
}

void TouchPresenter::setAutoUpgradeFile(QString path)
{
    if (component == NULL) {
        TDebug::warning("component is NULL");
        return;
    }
    QMetaObject::invokeMethod(component, "setUpgradeFile",
                              Q_ARG(QVariant, path),
                              Q_ARG(QVariant, 0));
}

void TouchPresenter::showToast(QString str)
{
    if (component == NULL) {
        TDebug::warning("component is NULL");
        return;
    }
    QMetaObject::invokeMethod(component, "showToast",
                              Q_ARG(QVariant, str));
}


QVariant TouchPresenter::getRelativeInfo()
{
    return QVariant::fromValue(touch->getRelativeInfo());
}

bool TouchPresenter::whetherDeviceConnect()
{
    return touch->whetherDeviceConnect();
}

QVariant TouchPresenter::getDeviceInfoName()
{
    return QVariant::fromValue(touch->getDeviceInfoName());
}

QVariant TouchPresenter::getDeviceInfo()
{
    return QVariant::fromValue(touch->getDeviceInfo());
}

QVariant TouchPresenter::getDeviceMainInfo()
{
    return QVariant::fromValue(touch->getDeviceMainInfo());
}
QVariant TouchPresenter::getSoftwareInfoName()
{
    return QVariant::fromValue(touch->getSoftwareInfoName());
}
QVariant TouchPresenter::getSoftwareInfo()
{
    return QVariant::fromValue(touch->getSoftwareInfo());
}


void TouchPresenter::setInfo(QString info)
{
    if (component == NULL) {
        TDebug::warning("component is NULL");
        return;
    }
    QMetaObject::invokeMethod(component, "setDeviceInfo",
                              Q_ARG(QVariant, info));
}

void TouchPresenter::onboardTestFinish(QString title, QString message, int type)
{
    if (component == NULL) {
        TDebug::warning("component is NULL");
        return;
    }
    QMetaObject::invokeMethod(component, "onboardTestFinish",
                              Q_ARG(QVariant, title),Q_ARG(QVariant, message),Q_ARG(QVariant, type));
}

void TouchPresenter::onboardShowDialog(QString title, QString message, int type)
{
    if (component == NULL) {
        TDebug::warning("component is NULL");
        return;
    }
     QMetaObject::invokeMethod(component, "onboardShowDialog",Q_ARG(QVariant, title),
                               Q_ARG(QVariant, message),Q_ARG(QVariant, type));
}

void TouchPresenter::setCurrentIndex(int index)
{
    if (component == NULL) {
        TDebug::warning("component is NULL");
        return;
    }
    QMetaObject::invokeMethod(component, "setCurrentIndex",Q_ARG(QVariant, index));
}

void TouchPresenter::setWindowHidden(bool visibled)
{
    if (component == NULL) {
        TDebug::warning("component is NULL");
        return;
    }
    QMetaObject::invokeMethod(component, "setCurrentIndex",Q_ARG(QVariant, visibled));
}

void TouchPresenter::setBatchResult(int index, int result)
{
    if (component == NULL) {
        TDebug::warning("component is NULL");
        return;
    }
    QMetaObject::invokeMethod(component, "refreshBatchResult",Q_ARG(QVariant, index),Q_ARG(QVariant, result));
}

void TouchPresenter::setDeviceInfo(int index, QString msg)
{
    if (component == NULL) {
        TDebug::warning("component is NULL");
        return;
    }
    QMetaObject::invokeMethod(component, "refreshBatchInfo",Q_ARG(QVariant, index),Q_ARG(QVariant, msg));
}

void TouchPresenter::startBatchTest(int index)
{
    touch->startBatchTest(index);
}

void TouchPresenter::startBatchUpgrade(QString batchUpgradeFile)
{
    touch->startBatchUpgrade(batchUpgradeFile);
}

void TouchPresenter::setBatchCancel(bool batchCancel)
{
    TDEBUG("设置批量升级的状态：%s",batchCancel ? "取消批量升级":"开始批量升级");
    this->batchCancel = batchCancel;
    touch->setBatchCancel(batchCancel);
}

void TouchPresenter::setBatchLock(bool enable)
{
    touch->setBatchLock(enable);
}

void TouchPresenter::batchFinished(int functionIndex)
{
    touch->batchFinished(functionIndex);
}

QVariantMap TouchPresenter::getBatchUpgradeData()
{
    return touch->getBatchUpgradeData();
}

void TouchPresenter::startVolienceTest(int volienceMode)
{
    touch->startVolienceTest(volienceMode);
}

void TouchPresenter::setCancelVolienceTest(bool cancelVolienceTest)
{
    touch->setCancelVolienceTest(cancelVolienceTest);
}

void TouchPresenter::saveUpgradeResultNum(bool result, QString info)
{
    if (component == NULL) {
        TDebug::warning("component is NULL");
        return;
    }
    QMetaObject::invokeMethod(component, "saveUpgradeResultNum",
                              Q_ARG(QVariant, result),
                              Q_ARG(QVariant, info));
}

void TouchPresenter::resetNum(int count)
{
    if (component == NULL) {
        TDebug::warning("component is NULL");
        return;
    }
    QMetaObject::invokeMethod(component, "resetNum",
                              Q_ARG(QVariant, count));
}

void TouchPresenter::startEdgeStrech()
{
    touch->startEdgeStrech();
}

void TouchPresenter::setEdgeStrechMode(bool flag)
{
    touch->setEdgeStrechMode(flag);
}

QVariantMap TouchPresenter::getEdgeStrechVal(int initVal)
{
    return touch->getEdgeStrechVal(initVal);
}

void TouchPresenter::setNextActivityEdge(int activityEdge)
{
    touch->setNextActivityEdge(activityEdge);
}

void TouchPresenter::refreshEdgeStrechProgress(QVariantMap map)
{
    if (component == NULL) {
        return;
    }
    QMetaObject::invokeMethod(component, "refreshEdgeStrechProgress",
                              Q_ARG(QVariant, map));
}

void TouchPresenter::edgeStrechFinish(int activityEdge)
{
    if (component == NULL) {
        return;
    }
    QMetaObject::invokeMethod(component, "edgeStrechFinish",
                              Q_ARG(QVariant, activityEdge));
}

void TouchPresenter::setCancelEdgeStrech(bool cancelEdgeStrech)
{
    touch->setCancelEdgeStrech(cancelEdgeStrech);
}

void TouchPresenter::setEdgeStrechVal(QVariantList edgeStrechVal)
{
    touch->setEdgeStrechVal(edgeStrechVal);
}

void TouchPresenter::updateSignalList(QVariant list)
{
    if (!list.canConvert<QVariantList>()) {
        TWARNING("%s invalid list", __func__);
    }
    signalMutex.lock();
    signalList = list.value<QVariantList>();
//    foreach (QVariant const &index, signalList) {
//    }
    signalMutex.unlock();
}

void TouchPresenter::modeSetting(bool startup)
{
    modeSettingFile = new JSON();
    QString appPath = touch->getAppPath();
    //保存启动项数据到本地文件中
    QString path = QString().sprintf("%s/%s%s",appPath.toStdString().c_str(),UPGRADE_FILE_DIR, MODE_SETTING_FILE);

    modeSettingFile->writeJson("startup",startup);
    touch->AutoRun(startup);


    modeSettingFile->saveJson(path);

}

QVariantMap TouchPresenter::refreshModeSetting()
{
    QVariantMap map;
    QVariantMap jsonMap;
    bool startup;
    QString appPath = touch->getAppPath();
    //保存启动项数据到本地文件中
    QString path = QString().sprintf("%s/%s%s",appPath.toStdString().c_str(),UPGRADE_FILE_DIR, MODE_SETTING_FILE);
    JSON *json = new JSON();
    QJsonObject jsonObject = json->loadJson(path);
    if(jsonObject.isEmpty())
    {
        touch->AutoRun(true);
        startup = true;
    }
    else
    {
        jsonMap = jsonObject.toVariantMap();
        startup = jsonMap["startup"].toBool();
//        TDEBUG("startup = %d",startup ? 1 : 0);
    }


    map.insert("startup",startup);
    return map;
}

void TouchPresenter::removeDriver()
{
    touch->removeDriver();
}

void TouchPresenter::refreshDriver()
{
    touch->refreshDriver();
}

void TouchPresenter::setRemoveDriverBtnEnable(bool enable)
{
    if (component == NULL) {
        return;
    }
    QMetaObject::invokeMethod(component, "setRemoveDriverBtnEnable",
        Q_ARG(QVariant, enable));
    return;
}

void TouchPresenter::showShutDownMessage(QString title, QString Message,int type)
{
    if (component == NULL) {
        return;
    }
    QMetaObject::invokeMethod(component, "showShutDownMessage",
        Q_ARG(QVariant, title),
        Q_ARG(QVariant, Message),
        Q_ARG(QVariant, type));
    return;
}

void TouchPresenter::shutDown(bool flag)
{
    touch->shutDown(flag);
}

void TouchPresenter::removeDriverResult(bool result)
{
    if (component == NULL) {
        return;
    }
    QMetaObject::invokeMethod(component, "removeDriverResult",
        Q_ARG(QVariant, result));
    return;
}

void TouchPresenter::batchProgress(int batchIndex, int progress)
{
    if (component == NULL) {
        return;
    }
    QMetaObject::invokeMethod(component, "refreshBatchProgress",
        Q_ARG(QVariant, batchIndex),
        Q_ARG(QVariant, progress));
    return;

}


void TouchPresenter::onBatchFinish(int index, bool result, QString message)
{
    if (component == NULL) {
        return;
    }
//    TDEBUG("序号%d升级结束,升级结果 = %d",index,batchCancel ? BATCH_CANCEL : (result ? BATCH_FINISH_SUCCESS : BATCH_FINISH_ERROR));
//    QMetaObject::invokeMethod(component, "refreshBatchResult",
//        Q_ARG(QVariant, index),
//        Q_ARG(QVariant, batchCancel ? BATCH_CANCEL : (result ? BATCH_FINISH_SUCCESS : BATCH_FINISH_ERROR)));
    QMetaObject::invokeMethod(component, "refreshBatchResult",
        Q_ARG(QVariant, index),
        Q_ARG(QVariant, result ? BATCH_FINISH_SUCCESS : BATCH_FINISH_ERROR));
    QMetaObject::invokeMethod(component, "refreshBatchInfo",
        Q_ARG(QVariant, index),
        Q_ARG(QVariant, message));
    return;
}

void TouchPresenter::addBatchDevice(QVariantMap deviceMap)
{
    if (component == NULL) {
        return;
    }
    QMetaObject::invokeMethod(component, "addBatchDevice",
                              Q_ARG(QVariant, deviceMap));
}

void TouchPresenter::batchUpradeFinished()
{
    if (component == NULL) {
        return;
    }
    QMetaObject::invokeMethod(component, "batchDone");
}



int TouchPresenter::getDeviceCount()
{
    if (component == NULL) {
        return 0;
    }
    QVariant returnedValue;
    QMetaObject::invokeMethod(component, "getDeviceCount",
        Q_RETURN_ARG(QVariant, returnedValue));
    return returnedValue.toInt();
}

void TouchPresenter::setAgingTime(int time)
{
    QMetaObject::invokeMethod(component, "setAgingTime",
        Q_ARG(QVariant, time));
//    QQmlProperty(component, "passAgingTime").write(time);
}

void TouchPresenter::setDeviceStatus(int index, int status)
{
//    if(status != 1)
//    {
//        TDEBUG("改变设备的状态status = %d",status);
//    }

    //setDeviceStatus
    if (component == NULL) {
        return;
    }
    QMetaObject::invokeMethod(component, "setDeviceStatus",
        Q_ARG(QVariant, index),
        Q_ARG(QVariant, status));
    return;
}

void TouchPresenter::startAgingTest()
{
    if (component == NULL) {
        return;
    }
    QMetaObject::invokeMethod(component, "startAging");
    return;
}
void TouchPresenter::stopAgingTest()
{
    if (component == NULL) {
        return;
    }
    QMetaObject::invokeMethod(component, "stopAging");
    return;
}

void TouchPresenter::refreshSettings()
{
    if (component == NULL) {
        return;
    }
    QMetaObject::invokeMethod(component, "refreshSettings");
    return;
}

void TouchPresenter::calibration()
{
    if (component == NULL) {
        return;
    }
    QMetaObject::invokeMethod(component, "calibration");
    return;
}

void TouchPresenter::newRunner()
{
    if (component == NULL) {
        return;
    }
    QMetaObject::invokeMethod(component, "newRunner");
    return;
}



void TouchPresenter::destroyQml()
{
    if (component == NULL) {
        return;
    }
    QMetaObject::invokeMethod(component, "onDestroyed");
    return;
}

void TouchPresenter::destroyDialog()
{
    if (component == NULL) {
        return;
    }
    QMetaObject::invokeMethod(component, "destroyDialog");
    return;
}

QVariant TouchPresenter::setCalibrationDatas(QVariantMap datas)
{
    if (touchManager == NULL) {
        TWARNING("%s: TouchManager is NULL", __func__);
        return QVariant::fromValue(false);
    }
    int ret;
    CalibrationData data;
    QVariantList list = datas.value("points").value<QVariantList>();
    for (int i = 0; i < datas.value("count", 0).toInt(); i++) {
        QVariantMap point = list.at(i).value<QVariantMap>();
        int index = point.value("index", -1).toInt();
        if (index == -1)
            return QVariant::fromValue(false);
        data.targetX = point.value("targetX", 0).toInt();
        data.targetY = point.value("targetY", 0).toInt();
        data.collectX = point.value("collectX", 0).toInt();
        data.collectY = point.value("collectY", 0).toInt();
        data.maxX = point.value("maxX", 0).toInt();
        data.maxY = point.value("maxY", 0).toInt();
        ret = touchManager->setCalibrationPointData(NULL,
                index, &data);
        if (ret != 0)
            return QVariant::fromValue(false);
    }
    return QVariant::fromValue(true);
}

QVariantMap TouchPresenter::getCalibrationDatas(QVariant where)
{
    QVariantMap map;
    if (touchManager == NULL) {
        TWARNING("%s: TouchManager is NULL", __func__);
        return map;
    }
    int ret;
    bool ok;
    int w = where.toInt(&ok);
    if (ok == false) {
        TWARNING("%s: where is bad", __func__);
        return map;
    }
    CalibrationSettings settings;
    ret = touchManager->getCalibrationSettings(NULL, &settings);
    if (ret != 0) {
        TWARNING("%s: get settings failed", __func__);
        return map;
    }
    CalibrationData data;
    TDEBUG("校准模式 = %d",settings.mode);
    TDEBUG("校准点的个数 = %d",settings.pointCount);
    TDEBUG("默认校准模式 = %d",settings.defMode);
    TDEBUG("默认校准点个数 = %d",settings.defPointCount);
    map.insert("mode", settings.mode);
    map.insert("count", settings.pointCount);
    QVariantList points;
    for (int i = 0; i < settings.pointCount; i++) {
        ret = touchManager->getCalibrationPointData(NULL,
                    w, i, &data);
        QVariantMap point;
        point.insert("index", i);
        point.insert("targetX", data.targetX);
        point.insert("targetY", data.targetY);
        point.insert("collectX", data.collectX);
        point.insert("collectY", data.collectY);
        point.insert("maxX", data.maxX);
        point.insert("maxY", data.maxY);
        points.append(point);
    }
    map.insert("points", points);
    return map;
}


QVariant TouchPresenter::enterCalibrationMode()
{
    if (touchManager == NULL)
        return QVariant::fromValue(false);
    int ret;
    ret = touchManager->setCalibrationMode(NULL, CALIBRATION_MODE_COLLECT);
    if (ret != 0)
        return QVariant::fromValue(false);
    ret = touchManager->setCoordsEnabled(NULL, COORDS_CHANNEL_SERIAL, COORDS_CHANNEL_DISABLE);
    if (ret != 0)
        return QVariant::fromValue(false);
    ret = touchManager->setCoordsEnabled(NULL, COORDS_CHANNEL_USB, COORDS_CHANNEL_DISABLE);
    if (ret != 0)
        return QVariant::fromValue(false);

    return QVariant::fromValue(true);
}

QVariant TouchPresenter::exitCalibrationMode()
{
    TPRINTF("退出校准模式:");
    if (touchManager == NULL)
        return QVariant::fromValue(false);
    int ret;
    ret = touchManager->setCalibrationMode(NULL, CALIBRATION_MODE_CALIBRATION);
    if (ret != 0)
        return QVariant::fromValue(false);
    ret = touchManager->setCoordsEnabled(NULL, COORDS_CHANNEL_SERIAL, COORDS_CHANNEL_ENABLE);
    if (ret != 0)
        return QVariant::fromValue(false);
    ret = touchManager->setCoordsEnabled(NULL, COORDS_CHANNEL_USB, COORDS_CHANNEL_ENABLE);
    if (ret != 0)
        return QVariant::fromValue(false);

    if (calibrationMode) {
        exit(0);
    }
    return QVariant::fromValue(true);
}

QVariant TouchPresenter::enableCoords(bool enable)
{
    int ret;
    if(enable)
    {
        ret = touchManager->setCoordsEnabled(NULL, COORDS_CHANNEL_USB, COORDS_CHANNEL_ENABLE);
        ret = touchManager->setCoordsEnabled(NULL, COORDS_CHANNEL_SERIAL, COORDS_CHANNEL_ENABLE);
    }
    else
    {
        ret = touchManager->setCoordsEnabled(NULL, COORDS_CHANNEL_USB, COORDS_CHANNEL_DISABLE);
        ret = touchManager->setCoordsEnabled(NULL, COORDS_CHANNEL_SERIAL, COORDS_CHANNEL_DISABLE);
    }
   return QVariant::fromValue(ret);
}

QVariant TouchPresenter::setCalibrationPointData(QVariant index, QVariantMap data)
{
    bool result = false;
    int ret;
    if (touchManager == NULL)
        goto _set_cali_point_data_out;
    CalibrationData point;
    point.targetX = data.value("targetX", 0).toInt();
    point.targetY = data.value("targetY", 0).toInt();
    point.collectX = data.value("collectX", 0).toInt();
    point.collectY = data.value("collectY", 0).toInt();
    point.maxX = data.value("maxX", 0).toInt();
    point.maxY = data.value("maxY", 0).toInt();
    TDEBUG("%s: index: %d, tx:%d,ty:%d,cx:%d,cy:%d,mx:%d,my:%d",
           __func__, index.toInt(),
           point.targetX, point.targetY, point.collectX, point.collectY,
           point.maxX, point.maxY);
    ret = touchManager->setCalibrationPointData(NULL, index.toInt(), &point);
    result = ret == 0;
_set_cali_point_data_out:
    return QVariant::fromValue(result);
}

QVariant TouchPresenter::saveCalibration()
{
    if (touchManager == NULL)
        return QVariant::fromValue(false);
    int ret = touchManager->saveCalibrationData(NULL);
    if (ret != 0)
        return QVariant::fromValue(false);
    return QVariant::fromValue(true);
}

QVariant TouchPresenter::captureCalibrationIndex(QVariant index)
{
    if (touchManager == NULL)
        return QVariant::fromValue(false);
    int ret = touchManager->startCalibrationCapture(NULL, index.toInt());
    if (ret != 0)
        return QVariant::fromValue(false);
    return QVariant::fromValue(true);
}

QVariantMap TouchPresenter::getCalibrationCapture()
{
    QVariantMap map;
    if (touchManager == NULL) {
        TWARNING("%s: TouchManager is NULL", __func__);
        return map;
    }
    CalibrationCapture data;
    int ret = touchManager->getCalibrationCapture(NULL, &data);
    if (ret != 0)
        return map;
    map.insert("index", data.index);
    map.insert("finished", data.finished);
    map.insert("count", data.count);
    return map;
}

QVariant TouchPresenter::testCaliCapture(QVariant time)
{
    QVariantMap map;
    if (touchManager == NULL) {
        TWARNING("%s: TouchManager is NULL", __func__);
        return map;
    }
    touchManager->testCalibrationCapture(NULL, time.toInt());
    return QVariant::fromValue(true);
}
//响应托盘
void TouchPresenter::openProgress(bool isOpen)
{
    if (component == NULL) {
        return;
    }
    QMetaObject::invokeMethod(component, "setWindowHidden",
                              Q_ARG(QVariant, isOpen));
    return;
}

void TouchPresenter::changeTabIndex(int index)
{
    if (component == NULL) {
        return;
    }
    QMetaObject::invokeMethod(component, "setWindowHidden",
                              Q_ARG(QVariant, true));

    QMetaObject::invokeMethod(component, "setCurrentIndex",
                              Q_ARG(QVariant, index));
}

void TouchPresenter::enterCalibratePage()
{
    if (component == NULL) {
        return;
    }
    if(touchManager->firstConnectedDevice()==NULL)
    {
        QMetaObject::invokeMethod(component, "showToast",
                                  Q_ARG(QVariant, touch->getTr("No connected devices!")));
        return;
    }
    QMetaObject::invokeMethod(component, "enterCalibrate");
}
//获取屏幕方向
int TouchPresenter::getScreenOrientation(){
    int systemScreenDirection = 0;
    DEVMODE dm;
    // initialize the DEVMODE structure
    ZeroMemory(&dm, sizeof(dm));
    dm.dmSize = sizeof(dm);
    if(EnumDisplaySettings(NULL,ENUM_CURRENT_SETTINGS,&dm))
    {
        switch(dm.dmDisplayOrientation)
        {
        case DMDO_DEFAULT:
            TDEBUG("当前系统屏幕旋转0度");
            systemScreenDirection = 0;
            break;
        case DMDO_90:
            TDEBUG("当前系统屏幕旋转90度");
            systemScreenDirection = 1;
            break;
        case DMDO_180:
            TDEBUG("当前系统屏幕旋转180度");
            systemScreenDirection = 2;
            break;
        case DMDO_270:
            TDEBUG("当前系统屏幕旋转270度");
            systemScreenDirection = 3;
            break;
        default:
            TDEBUG("获取屏幕旋转方向失败");
//            appendMessageText("获取屏幕旋转方向失败",0);
            systemScreenDirection = -1;
        }
    }
    else
    {
        TDEBUG("枚举设备设置出错");
        appendMessageText("枚举设备设置出错",0);
    }
    return systemScreenDirection;
}






