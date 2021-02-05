#ifndef TouchTools_H
#define TouchTools_H
#include "sdk/hidapi.h"

#include <QTimer>
#include <QDateTime>
#include <QThread>
#include "presenter/touchpresenter.h"
#include "sdk/TouchManager.h"
#include "touchaging.h"
#include <QTranslator>
#include "systemtray.h"
#include "src/jsonFile/json.h"

namespace Touch {

#define en_US 0
#define zh_CN 1

struct TouchData {
    unsigned char report_id;
    unsigned char data[HID_REPORT_DATA_LENGTH];
};

#define APP_VERSION_NAME ("v2.1.0")
#define APP_VERSION_CODE (15)

//#define THIS_APP_TYPE (APP_FACTORY)
//#define THIS_APP_TYPE (APP_CLIENT)
#define THIS_APP_TYPE (APP_RD)
//#define THIS_APP_TYPE (APP_CLIENT_FACTORY)
//#define THIS_APP_TYPE (APP_PCBA)
// see also: main.qml(appFactory...)
typedef enum {
    APP_FACTORY = 0,
    APP_CLIENT,
    APP_RD,
    APP_PCBA,
    APP_CLIENT_FACTORY
}AppType;



class TouchTools : public QObject, public CommandThread::CommandListener,
        public TouchManager::HotplugListener, public TouchInterface,public TouchManager::Trans,
        public SystemTray::Trans,public SystemTray::ActionSignal
{
    Q_OBJECT
public:
    int argc;
    char **argv;
    QTimer *argcTimer;

    explicit TouchTools(QObject *parent = 0, TouchPresenter *p = 0,int argc = 0,
                        char *argv[] = 0,QString appPath = "");
    ~TouchTools();
    bool stopTestIsFinished;
    touch_device *getDevices();
    void addTouchManagerTr();
    void setUpgradeProgess(int progess);
    void setTestProgess(int progess) {emit presenter->setTestProgress(progess);}
    void doUpgradeFireware();
    void doTest();
    static void setAutoTestSwitch(bool autoTestSwitch);
    void autoTestConnect(touch_device *dev);
    void clearTestInfo();
    AppType getAppType() { return appType; }
    void setAppType(AppType type) { appType = type; if (presenter) presenter->setAppType((int)appType);}

    void setAgingTime(int time) { touchAging.setAgingTime(time);}
    TouchPresenter *getTouchPresenter() {
        return presenter;
    }

    void onCommandDone(touch_device *dev, touch_package *require, touch_package *reply);
    QString getTr(QString str);
    //批处理
    QVariantMap getConnectDeviceInfo();
    touch_device *getDevice(int index);
    void startBatchTest(int testIndex);
    void startBatchUpgrade(int upgradeIndex,QString path);
    void setBatchCancel(bool batchCancel);
    //托盘
    void openProgress(bool isOpen);
    void setPageIndex(int index);
    void enterCalibratePage();

    bool isUpgrading();
    bool isTesting();


    void onTouchHotplug(touch_device* dev, const int attached, const void *val);
    void setHotplugInterval(unsigned int interval) {
        hotplugInterval = interval;
    }

    QVariantMap getSignalData(QVariant index, int count = 0);
    QVariantMap getSignalItems();
    QVariant getRelativeInfo();
    bool whetherDeviceConnect();
    QVariant getDeviceInfoName();
    QVariant getDeviceInfo();
    QVariant getDeviceMainInfo();
    QVariant getSoftwareInfoName();
    QVariant getSoftwareInfo();
    bool getTestIsFinished();
    //onboard
    QVariantMap map;
    QVariantMap getBoardAttribyteData();
    QVariantMap getBoardAndLampData()
    {
        return map;
    }
    void showFirewareInfo(int type);
    signals:
    void showMessage(QString title, QString message, int type = 0);
public slots:
    void upgradeFireware(QString path);
    void startUpgrade();
    void setUpdatePath(QString path);
    void setUpgradeFile(QString path);
    void clearComboBoxData();
    void showMessageDialog(QString title, QString message, int type = 0);

    void triggerUsbHotplug();

    void startTest();
    void onStopAll();
    void onSetTestThreadStop(bool stop);
    void setTestThreadCancel(bool t);
    void timeoutWorking();
    void exitProject();

private:
    touch_device *mCurDevice;
    int mDeviceCount;
    TouchManager *mTouchManager;
    SystemTray *tray;
    AppType appType;
    unsigned int hotplugInterval;

    QString upgradePath;

    class InitSdkThread : public QThread {
    public:
        InitSdkThread(TouchTools *tool);
    protected:
        void run();
        TouchTools *touchTool;
    };
//    class AutoUpdateThread:public QThread{
//    public:
//        AutoUpdateThread(TouchTools *tool){
//            touchTool = tool;
//        }
//    protected:
//        void run();
//        TouchTools *touchTool;
//    };

    class UpgradeThread : public QThread {
    public:
        bool running;
        UpgradeThread(TouchTools *tool) : touchTool(tool), running(false), waiting(false){}
        bool isWaiting() { return waiting; }
        void setWaiting(bool wait) { waiting = wait; }
        void setCancel() { cancel = true;}
        bool isCanceled() { return cancel;}
    protected:
        void run();
        TouchTools *touchTool;
    private:
        bool waiting;
        bool cancel;
    };
    class TestThread : public QThread {
    public:
        bool running;
        TestThread(TouchTools *tool) : running(false),touchTool(tool),cancel(false){}
        void setCancel(bool t) { cancel = t;}
        bool isCanceled() { return cancel;}
    protected:
        void run();
        TouchTools *touchTool;
    private:
        bool cancel;
    };

    class TestListener : public TouchManager::TestListener{
    public:
        TestListener(TouchTools *manager) { this->manager = manager;}
        void inProgress(int progress, QString message);
        void onTestDone(bool result, QString message,bool stop,bool isSupport);
        void setNewWindowVisable();
        void changeOnboardtestString(QString info);
        void showTestMessageDialog(QString title,QString message,int type = 0);
        void destroyDialog();
        void refreshOnboardTestData(QVariantMap map);
        void showOnboardFailItem(QString message);
        void showFirewareInfo(int type);

    private:
        TouchTools *manager;
    };
    class BatchTestListener:public TouchManager::BatchTestListener{
    public:
        BatchTestListener(TouchTools *manager) { this->manager = manager;}
        void inProgress(int index,int progress);
        void onTestDone(int index,bool result, QString message);
    private:
        TouchTools *manager;

    };

    class UpgradeListener : public TouchManager::UpgradeListener {
    public:
        UpgradeListener(TouchTools *manager) { this->manager = manager;}
        void inProgress(int progress);
        void onUpgradeDone(bool result, QString message);
        void showUpdateMessageDialog(QString title,QString message,int type = 0);
        void destroyDialog();
    private:
        TouchTools *manager;
    };
    class BatchUpgradeListener:public TouchManager::BatchUpgradeListener{
    public:
        BatchUpgradeListener(TouchTools *manager) { this->manager = manager;}
        void inProgress(int index,int progress);
        void onUpgradeDone(int index,bool result, QString message) ;
    private:
        TouchTools *manager;
    };


    TestListener mTestLstener;
    BatchTestListener batchTestListener;
    UpgradeListener mUpgradeListener;
    BatchUpgradeListener batchUpgradeListener;
    InitSdkThread initSdkThread;
    UpgradeThread upgradeThread;
    TestThread testThread;

    TouchPresenter *presenter;
    TouchAging touchAging;
    CommandThread *command;
    QTimer *timer;
//    AutoUpdateThread autoUpdateThread;

    void appendMessageText(QString message = "", int type = 0)
    {
        presenter->appendMessageText(
                    QDateTime::currentDateTime().toString("yyyy-MM-dd hh:mm:ss") + ": " +
                    message.toStdString().c_str(), type);
    }
    void hotplug(bool plugin) {

    }

    void setMessageText(QString message) {presenter->setMessageText(message);}
    void setTestThreadRunning(bool isRunning){
            testThread.running = isRunning;
        }
public:
    void AutoRun(bool isAutoRun);
//    void SetProcessAutoRunSelf(const QString &appPath)
    QString getAppPath(){return appPath;}

    //静态变量与方法
public:
    static bool upgrading;
    static bool testing;
    static bool autoTestSwitch;
    static int language;
    static void setLanguage(int lu);
    static QString polishingString(int length,QString str);
    static int gbk_strlen(const char* str);
private :
    QList<QString> autoUpdatePath;
     bool firstTimeUpdate;
     QString appPath;


};

} // namespace


#endif // TouchTools_H
