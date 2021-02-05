#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include "stdio.h"
#include "TouchTools.h"
#include "presenter/touchpresenter.h"

#include <QtWidgets/QApplication>
#include <QtCore/QDir>
#include <QtQuick/QQuickView>
#include <QtQml/QQmlEngine>
#include <QtQml>
#include <QLocale>

#include <QJsonDocument>
#include <QTextCodec>
#include <QJsonObject>
#include <QJsonArray>
#include <QFile>

#include <tusbevent.h>

#include <QSysInfo>
using namespace Touch;
#include "sdk/tdebug.h"

#include "include/drawpanel.h"
#include "systemtray.h"

#define zh_CN 1
#define en_US 0


void SetProcessAutoRunSelf(const QString &appPath);
void AutoRun(bool isAutoRun);

//分析设备，然后将设备添加到设备链表struct _touch_vendor_list
void parseDevices(QFile &loadFile)
{
    QByteArray saveData = loadFile.readAll();
    QJsonDocument loadDoc(QJsonDocument::fromJson(saveData));
    QJsonArray vendors = loadDoc.object()["devices"].toArray();

    for (int i = 0; i < vendors.size(); ++i) {
        QJsonObject device = vendors[i].toObject();
        bool ok;
        //通过判断厂商的pid和vid等信息
        touch_vendor_info info;
        info.vid = device["vid"].toString().toInt(&ok, 16);
        info.pid = device["pid"].toString().toInt(&ok, 16);
        const char *str = device["path"].toString().toStdString().c_str();
        int length = sizeof(info.path);
        int slen = strlen(str);
        length = length > slen ? slen : length;
        memcpy(&info.path, str, length);
        if (length >= sizeof(info.path))
            length--;
        info.path[length] = '\0';
        info.rid = device["report_id"].toString().toInt(&ok, 16);
        info.bootloader = device["bootloader"].toInt();
        TDEBUG("vid=0x%04x, pid=0x%04x, path=%s, rid=0x%02x, bootloader=%d",
               info.vid, info.pid, info.path, info.rid, info.bootloader);
        TouchManager::addTouchDeviceInfo(&info);
    }
}

#include "singleapp.h"
void testNetWork()
{
    SingleApp *app = new SingleApp;
    app->test();
}
bool isAlreadyRunning(SingleApp **a)
{
    SingleApp *app = new SingleApp;
    bool r = app->run();
    if (r) {
        *a = app;
    } else {
        delete app;
    }
//    TINFO("run server: %d, a=%p", (r ? 1 : 0), a);
    return !r;
}

#ifdef TEST_SDK
int main(int argc, char *argv[])
{
    extern void doTouchTest();
    TDebug::logToConsole(true);
    doTouchTest();
}
#else
int main(int argc, char *argv[])
{

//    libusb_context *ctx;
//    libusb_init(&ctx);

//    QCoreApplication::setAttribute(Qt::AA_UseDesktopOpenGL, true);
    QString defLang = QLocale().name().toStdString().c_str();
    TINFO(QLocale().name().toStdString().c_str());
//    QLocale curLocale(QLocale("zh_CN"));
//    QLocale::setDefault(curLocale);

    //设置编码格式为 utf-8
    QTextCodec::setCodecForLocale(QTextCodec::codecForName("utf-8"));
    qmlRegisterType<TouchPresenter>(
                "TouchPresenter",
                1, 0,
                "touch");
    qmlRegisterType<QDrawPanel>("QDrawPanel", 1, 0, "QDrawPanel");
    //AA_EnableHighDpiScaling设置
    QGuiApplication::setAttribute(Qt::AA_EnableHighDpiScaling);
    QApplication app(argc, argv);
    QTranslator translator;
    //bool ok = translator.load(":lang/zh_CN.qm");
    bool ok = false;
    TINFO("start %s: %s, %d", __DATE__, APP_VERSION_NAME, APP_VERSION_CODE);
    SingleApp *singleApp = NULL;
    if (isAlreadyRunning(&singleApp)) {
        return 0;
    }

    QQmlApplicationEngine engine;
//    TDebug::setLogLevel(TLOG_INFO);

//    QQmlComponent configQml(&engine, QUrl(QStringLiteral("qrc:config/touch.qml")));
    //读取配置文件中的qml文件
    QString appPath = QCoreApplication::applicationDirPath();
    TDEBUG("软件路径：%s",appPath.toStdString().c_str());
    QQmlComponent configQml(&engine, appPath + "/config/touch.qml");
    QObject *config = configQml.create();
    if (configQml.isError())
        TDebug::debug(configQml.errorString());

    bool proOk = false;
    //QQmlProperty类对从QML创建的对象的访问属性进行抽象
    //read返回对象的lang（语言）属性值
    QVariant v = QQmlProperty::read(config, "lang");
    QString lang = "";
    if (v.canConvert<QString>()) {
        lang = v.toString();
        TDebug::info("read lang: " + lang);
        //判断翻译是否成功加载
        ok = translator.load(":lang/" + lang + ".qm");
    }
    TDebug::info("lang = " + lang);
//    if (lang == "")
//        ok = false;
    if (lang == "")
        TDEBUG("lang false");
    if(lang == "zh_CN")
    {
        if (!ok) {
            ok = translator.load(":lang/" + lang + ".qm");
        }
        TINFO("load translator %s %s", lang.toStdString().c_str(), ok ? "success" : "fail");
        if (ok) {
            app.installTranslator(&translator);
        } else {
            ok = translator.load(":lang/zh_CN.qm");
            lang = "zh_CN";
            app.installTranslator(&translator);
        }
    }
    else
    {
        if(lang != "en_US")
        {
            lang = defLang;
        }
        if(lang != "en_US" && lang != "zh_CN")
        {
            lang = "en_US";
        }
        if (!ok) {
            //        ok = translator.load(":lang/" + QLocale().name() + ".qm");
            ok = translator.load(":lang/" + lang + ".qm");
        }
        TINFO("load translator %s %s", lang.toStdString().c_str(), ok ? "success" : "fail");
        if (ok) {
            app.installTranslator(&translator);
        } else {
            ok = translator.load(":lang/en_US.qm");
            lang = "en_US";
            app.installTranslator(&translator);
        }
    }
//    if (lang != "en_US") {
//        if (!ok) {
//            lang = "zh_CN";
//            //        ok = translator.load(":lang/" + QLocale().name() + ".qm");
//            ok = translator.load(":lang/" + lang + ".qm");
//        }
//        TINFO("load translator %s %s", lang.toStdString().c_str(), ok ? "success" : "fail");
//        if (ok) {
//            app.installTranslator(&translator);
//        } else {
//            ok = translator.load(":lang/zh_CN.qm");
//            lang = "zh_CN";
//            app.installTranslator(&translator);
//        }
//    }else
//    {
//        if (!ok) {
//            lang = "en_US";
//            //        ok = translator.load(":lang/" + QLocale().name() + ".qm");
//            ok = translator.load(":lang/" + lang + ".qm");
//        }
//        TINFO("load translator %s %s", lang.toStdString().c_str(), ok ? "success" : "fail");
//        if (ok) {
//            app.installTranslator(&translator);
//        } else {
//            ok = translator.load(":lang/en_US.qm");
//            lang = "en_US";
//            app.installTranslator(&translator);
//        }
//    }
    //用于语言之间的转换
    QLocale curLocale(lang);
    QLocale::setDefault(curLocale);

    bool hardware = QQmlProperty::read(config, "hardwareAcceleration").toBool();
    if (!hardware) {
        TINFO("software openGL");
        QCoreApplication::setAttribute(Qt::AA_UseSoftwareOpenGL, true);
    } else {
        TINFO("hardware acceleration");
    }
    //从配置文件中读取数据
    bool showTestData = QQmlProperty::read(config, "showTestData").toBool();

    bool ignoreFailedTestItem = QQmlProperty::read(config, "ignoreFailedTestItem").toBool();


    unsigned int hotplugInterval = QQmlProperty::read(config, "hotplugInterval").toInt(&proOk);
    if (!proOk) {
        hotplugInterval = 0;
    }
    int logLevel = QQmlProperty::read(config, "logLevel").toInt(&ok);
    if (ok) {
        TDebug::setLogLevel((TLOG_LEVEL)logLevel);
    }


    // 校准时间

    int calAutoCancelTime = QQmlProperty::read(config, "calAutoCancelTime").toInt(&ok);
    if (ok) {
        //将从配置文件中的数据设置为qml的环境变量
        engine.rootContext()->setContextProperty("calAutoCancelTime", calAutoCancelTime);
    } else {
        engine.rootContext()->setContextProperty("calAutoCancelTime", 60 * 1000);
    }

    int calFinishExitTime = QQmlProperty::read(config, "calFinishExitTime").toInt(&ok);
    if (ok) {
        engine.rootContext()->setContextProperty("calFinishExitTime", calFinishExitTime);
    } else {
        engine.rootContext()->setContextProperty("calFinishExitTime", 3 * 1000);
    }

    engine.rootContext()->setContextProperty("defaultTestItems", QQmlProperty::read(config, "defaultTestItems"));
    bool setTest = QQmlProperty::read(config, "setTest").toBool();
    engine.rootContext()->setContextProperty("defaultSetTest", setTest);


    //读取文件中的displaySeparateModel 信号堆叠显示还是分开显示
    bool displaySeparateModel = QQmlProperty::read(config, "displaySeparateModel").toBool();
    engine.rootContext()->setContextProperty("displaySeparateModel", displaySeparateModel);

    //读取配置文件touch.qml文件中的testCount中的值
    int testCount = QQmlProperty::read(config, "testCount").toInt(&ok);
    if (ok) {
        //设置环境变量
        engine.rootContext()->setContextProperty("testCount", testCount);
    } else {
        engine.rootContext()->setContextProperty("testCount", 4);
    }
    int histogram = QQmlProperty::read(config, "histogram").toBool();
    engine.rootContext()->setContextProperty("histogram", histogram);

    int currentIndex = QQmlProperty::read(config, "currentIndex").toInt(&ok);

    bool switchOnboardTest = QQmlProperty::read(config, "switchOnboardTest").toBool();

    bool continueOnboardTest = QQmlProperty::read(config, "continueOnboardTest").toBool();

    bool autoTestSwitch = QQmlProperty::read(config, "autoTestSwitch").toBool();


    //ui界面控件大小
    QQmlComponent configUiQml(&engine, appPath + "/config/ui.qml");
    QObject *uiConfig = configUiQml.create();
    if (configUiQml.isError())
    {
        TDebug::debug(configUiQml.errorString());
        TDEBUG("######################");
    }


    float tabWidth = QQmlProperty::read(uiConfig, "tabWidth").toFloat(&ok);
    if (ok) {
        TDEBUG("@@@@@@@@@ tabWidth = %.1f",tabWidth);
        engine.rootContext()->setContextProperty("tabWidth", tabWidth);
    } else {
        TDEBUG("#########");
        engine.rootContext()->setContextProperty("tabWidth", 0);
    }
    float tabHeight = QQmlProperty::read(uiConfig, "tabHeight").toFloat(&ok);
    if (ok) {
        engine.rootContext()->setContextProperty("tabHeight", tabHeight);
    } else {
        engine.rootContext()->setContextProperty("tabHeight", 0);
    }
    float upgradeTestWidth = QQmlProperty::read(uiConfig, "upgradeTestWidth").toFloat(&ok);
    if (ok) {
        engine.rootContext()->setContextProperty("upgradeTestWidth", upgradeTestWidth);
    } else {
        engine.rootContext()->setContextProperty("upgradeTestWidth", 0);
    }
    float upgradeTestHeight = QQmlProperty::read(uiConfig, "upgradeTestHeight").toFloat(&ok);
    if (ok) {

        engine.rootContext()->setContextProperty("upgradeTestHeight", upgradeTestHeight);
    } else {
        engine.rootContext()->setContextProperty("upgradeTestHeight", 0);
    }

    float signalItemWidth = QQmlProperty::read(uiConfig, "signalItemWidth").toFloat(&ok);
    if (ok) {
        engine.rootContext()->setContextProperty("signalItemWidth", signalItemWidth);
    } else {
        engine.rootContext()->setContextProperty("signalItemWidth", 0);
    }
    float signalItemHeight = QQmlProperty::read(uiConfig, "signalItemHeight").toFloat(&ok);
    if (ok) {
        engine.rootContext()->setContextProperty("signalItemHeight", signalItemHeight);
    } else {
        engine.rootContext()->setContextProperty("signalItemHeight", 0);
    }

    //销毁组件实例
    configQml.destroyed(config);
    configUiQml.destroyed(uiConfig);
    TINFO("Property ignoreFailedTestItem value: %d", ignoreFailedTestItem);
    TINFO("Property showTestData value: %d", showTestData);
    TouchManager::setIgnoreFailedTestItem(ignoreFailedTestItem);
    TouchManager::setShowTestData(showTestData);
    TouchManager::setSwitchOnboardTest(switchOnboardTest);
    TouchManager::setContinueOnboardTest(continueOnboardTest);
    TouchTools::setAutoTestSwitch(autoTestSwitch);
    if(lang.compare("en_US") == 0)
    {
        TDEBUG("设置为英文");
        TouchTools::setLanguage(en_US);
    }
    else
    {
        TDEBUG("设置为中文");
        TouchTools::setLanguage(zh_CN);
    }

    // get config veondor touch devices
    int len = strlen(appPath.toStdString().c_str()) + sizeof("/config/devices.json");
    char deviceJson[len];
    sprintf(deviceJson,"%s/config/devices.json",appPath.toStdString().c_str());
//    TDEBUG("len = %d,路径 = %s",len, deviceJson);
    QFile loadFile(deviceJson);

    if (loadFile.open(QIODevice::ReadOnly)) {
        TINFO("devices device json");
        //解析设备信息，然后将信息写入到触摸设备信息中
        parseDevices(loadFile);

    } else {
        TINFO("No devices.json");
        QFile defaultDevices(":/text/devices.json");
        if (!defaultDevices.open(QIODevice::ReadOnly))
            TERROR("open text/devices.json failed");
        else {
            parseDevices(defaultDevices);
            TINFO("copy device %s", defaultDevices.copy("config/devices.json") ? "done" : "failed");
        }
    }

    TouchPresenter *touch = new TouchPresenter(NULL, NULL);
    engine.rootContext()->setContextProperty("touch", (QObject*)touch);

    engine.rootContext()->setContextProperty("winVersion", (int)QSysInfo::WindowsVersion);
    engine.rootContext()->setContextProperty("winXPVersion", (int)QSysInfo::WV_XP);

    //读取对象的自动屏蔽坐标的属性值
    int autoDisableCoordinate = QQmlProperty::read(config, "autoDisableCoordinate").toInt(&ok);
    if (!ok) {
        autoDisableCoordinate = 1;
    } else {
        autoDisableCoordinate = !!autoDisableCoordinate;
    }

    engine.rootContext()->setContextProperty("autoDisableCoordinate", autoDisableCoordinate == 1);
    TINFO("autoDisableCoordinate=%d", autoDisableCoordinate);
    QObject *object = NULL;

    if(argc > 1 && strncmp(argv[1],"-changeCoordsMode",sizeof("-changeCoordsMode")) == 0)
    {

    }
    else
    {
        QQmlComponent component(&engine, QUrl(QStringLiteral("qrc:/main.qml")));
        if (component.isError())
            TDebug::debug("main.qml error:" + component.errorString());
        object = component.create();
        touch->setComponent(object);
    }
    if(argc > 1 && (strncmp(argv[1],"-selfStarting",sizeof("-selfStarting")) == 0 ||
            strncmp(argv[1],"-cal",sizeof("-cal")) == 0))
    {
        TDEBUG(" 有两个参数");
        touch->openProgress(false);
    }
    else
    {
        touch->openProgress(true);
    }


    //该函数就是调用object对象中的setAppType方法，如果调用成功则返回true，调用失败则返回false，
    QMetaObject::invokeMethod(object, "setAppType",
        Q_ARG(QVariant, (int)THIS_APP_TYPE));
    TouchTools manager(NULL, touch,argc,argv,appPath);
    TINFO("singleApp=%p", singleApp);
    if (singleApp) {
        QObject::connect(singleApp, SIGNAL(newRunner()), manager.getTouchPresenter(), SLOT(newRunner()));
        TINFO("connect newRunner");
    } else {

    }


    QQmlComponent configAgingQml(&engine, appPath + "/config/aging.qml");
    config = configAgingQml.create();
    if (configAgingQml.isError()) {
        TDebug::debug(configAgingQml.errorString());
    } else {
        bool ok = true;
        int agingTime = QQmlProperty::read(config, "agingTime").toInt(&ok);
        TINFO("set aging time: %d", agingTime);
        manager.setAgingTime(agingTime);
    }
    manager.setAppType(THIS_APP_TYPE);

    if (hotplugInterval > 0) {
        TINFO("set hotplug interval %d", hotplugInterval);
        manager.setHotplugInterval(hotplugInterval);
    }
    TINFO(QLocale().name().toStdString().c_str());

    configAgingQml.destroyed(config);

    engine.addImportPath(QStringLiteral("qml/ui/"));
    engine.addImportPath(QStringLiteral("qml"));

    // for usb event, 需要在main里的qmainwindow
#if 0
    TUsbEvent ue;
    ue.showMinimized();
    ue.close();
    QObject::connect(&ue, SIGNAL(usbDeviceRemove()), &manager, SLOT(triggerUsbHotplug()));
    QObject::connect(&ue, SIGNAL(usbDeviceAdd()), &manager, SLOT(triggerUsbHotplug()));
#endif

    if(currentIndex > 6 || currentIndex < 0)
    {
        currentIndex = 0;
    }
    while(1)
    {
        if(touch->initSdkDone)
        {
            touch->setCurrentIndex(currentIndex);
            break;
        }
        QThread::msleep(20);
    }


    //开机自启动
//    manager.AutoRun(false);
//    touch->SetProcessAutoRunSelf(qApp->applicationFilePath());

//    ue.show();

    //engine.load();

//    testNetWork();
    return app.exec();
}
#endif
