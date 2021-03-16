#ifndef TOUCHMANAGER_H
#define TOUCHMANAGER_H

#include "touch.h"
#include "hidapi.h"
#include "commandthread.h"
#include "fireware.h"
#include "utils/tdebug.h"

#include "touch_global.h"
#include <QSemaphore>
#define MAX_TOUCH_COUNT 9


typedef enum {
    Standard_Factory = STE_FACTORY_TEST,
    Standard_Client = STE_END_USER_TEST,
    Standard_RD = STE_DEV_TEST,
    Standard_PCBA = STE_PCBA_CUSTOMER_TEST,
    Standard_Client_Factory = STE_END_USER_FACTORY_TEST
}StandardType;
typedef struct _onboard_test_data_result
{
    QVariantList downLampState;
    QVariantList leftLampState;
    QVariantList upLampState;
    QVariantList rightLampState;
    QVariantList downBoardState;
    QVariantList leftBoardState;
    QVariantList upBoardState;
    QVariantList rightBoardState;
}onboard_test_data_result;
class TouchTestData {
public:
    TouchTestData(){}
    ~TouchTestData(){ datas.clear();}
    QVariantList datas;
    qint32 count;
    qint32 f_min;
    qint32 f_max;
    qint32 c_min;
    qint32 c_max;
    qint32 number;
};

struct CalibrationSettings {
    qint8 mode;
    qint8 pointCount;
    qint8 defMode;
    qint8 defPointCount;
};

struct CalibrationData {
    qint32 targetX;
    qint32 targetY;
    qint32 collectX;
    qint32 collectY;
    qint32 maxX;
    qint32 maxY;
};
struct CalibrationCapture {
    qint8 index;
    qint16 finished;
    qint16 count;
};
struct BatchUpgradeThreadList;
struct InitDeviceThreadlist;
struct BatchUpgradeDeviceList;
typedef void (*touch_hotplug_func)(touch_device *, const int attached, const void *value);
class TouchManager : public CommandThread::CommandListener
{
public:
    class Trans
    {
    public:
        virtual QString getTr(QString str) = 0;
    };
//    static bool commandFinshedFlag;
    class HotplugListener {
    public:
        virtual void onTouchHotplug(touch_device* dev, const int attached, int val) = 0;
    };
    class SendCallback {
    public:
        virtual void onSendCallback(touch_device* dev, touch_package *reply) = 0;
    };
    class TestListener {
    public:
        virtual void inProgress(int progress, QString message) = 0;
        virtual void onTestDone(bool result, QString message,bool stop,bool isSupport) = 0;
        virtual void setNewWindowVisable() = 0;
        virtual void changeOnboardtestString(QString info) = 0;
        virtual void showTestMessageDialog(QString title,QString message,int type = 0) = 0;
        virtual void destroyDialog() = 0;
        virtual void refreshOnboardTestData(QVariantMap map) = 0;
        virtual void showOnboardFailItem(QString message) = 0;
        virtual void showFirewareInfo(touch_device *dev, int type) = 0;
    };
    class UpgradeListener {
    public:
        virtual void inProgress(int progress) = 0;
        virtual void onUpgradeDone(bool result, QString message) = 0;
        virtual void showUpdateMessageDialog(QString title,QString message,int type = 0) = 0;
        virtual void destroyDialog() = 0;
    };

    class HotplugThread : public QThread
    {
    public:
        HotplugThread(TouchManager *manager) : manager(manager), mStop(false) {}
        void stopThread() {
            mStop = true;
            manager->hotplugSem.release();
        }
        bool getHotplugMstop(){return mStop;}
        void triggerHotplugEvent() {manager->hotplugSem.release();}
        bool getHotPlugThread(){return finshed;}

    protected:
        void run();
    private:
        TouchManager *manager;
        bool mStop;
        bool finshed = false;
    };
    class InitDeviceInfoThread :public QThread
    {
    public:
        InitDeviceInfoThread(TouchManager *manager,touch_device *device)
        {
            this->manager = manager;
            this->device = device;
        }
    protected:
        void run();
    private:
        TouchManager *manager;
        touch_device *device;
    };


    class UpgradeThread : public QThread
    {
    public:
        UpgradeThread(TouchManager *manager);
        QString path;

    protected:
        void run();
    private:
        TouchManager *manager;
    };

    class TestThread : public QThread
    {
    public:
        TestThread(TouchManager *manager);
        void setStandardType(StandardType st = Standard_Factory) { standardType = st; }
        StandardType standardType;

    protected:
        void run();
    private:
        TouchManager *manager;

    };
    class BathchTestThread : public QThread
    {
    public:
        BathchTestThread(TouchManager *manager);
        void setStandardType(StandardType st = Standard_Factory) { standardType = st; }
        StandardType standardType;
        int testIndex;
        touch_device *testDevice;
        void setTestDevice(touch_device *dev){this->testDevice = dev;}
        void setTestIndex(int index){this->testIndex = index;}
    protected:
        void run();
    private:
        TouchManager *manager;
    };
    class BatchTestListener {
    public:
        virtual void inProgress(int index,int progress) = 0;
        virtual void onTestDone(int index,bool result, QString message) = 0;
    };

    class BatchUpgradeThread : public QThread
    {
    public:
        BatchUpgradeThread(TouchManager *manager){this->manager = manager;}
        QString path;
        void setManager(TouchManager *manager){this->manager = manager;}
        void setBatchUpgradeIndex(int index){this->upgradeIndex = index;}
        void setBatchUpgradeDevice(touch_device *dev){this->upgradeDev = dev;}
    protected:
        void run();
    private:
        TouchManager *manager;
        int upgradeIndex;
        touch_device *upgradeDev;
    };
    class BatchUpgradeListener {
    public:
        virtual void inProgress(int index,int progress) = 0;
        virtual void onUpgradeDone(int index,bool result, QString message) = 0;
        virtual void setDeviceIfo(int index,QString msg) = 0;
        virtual void batchUpradeFinished() = 0;
    };
    //边缘拉伸
    TOUCHSHARED_EXPORT void getEdgeStrechVal();

private:
    TouchManager();
    QMutex randomMutex;
    volatile int randomArray[256];
    static int instanceCount;
    static TouchManager* mTouchManager;
public:
    TOUCHSHARED_EXPORT static TouchManager* getInstance();
    TOUCHSHARED_EXPORT static void freeInstance();
    TOUCHSHARED_EXPORT virtual ~TouchManager();
    TOUCHSHARED_EXPORT void setTr(Trans *translator);
    TOUCHSHARED_EXPORT int registerHotplug(HotplugListener *listener);

    TOUCHSHARED_EXPORT void setHotplugByEvent(bool b);
    TOUCHSHARED_EXPORT void triggerHotplugEvent(void);


    /**
     * @brief sendPackage
     * @param package
     * @param reply NULL, if don't need reply, but also can get reply in *listener->onCommandDone scope
     * @param device
     * @param async
     * @param listener
     * @return
     */
    TOUCHSHARED_EXPORT int sendPackage(touch_package *package,touch_package *reply = NULL,
                    touch_device *device = NULL,int async = 0, CommandThread::CommandListener *listener = NULL);

    static int sendPackageToDevice(touch_package *package,touch_package *reply = NULL,
                            touch_device *device = NULL);
    static int wait_time_out(hid_device *dev, unsigned char *reply, size_t length, int milliseconds);


    TOUCHSHARED_EXPORT int startUpgrade(QString path, UpgradeListener *listener = NULL);
    TOUCHSHARED_EXPORT void doUpgrade(QString path);

    void onCommandDone(touch_device *dev, touch_package *require, touch_package *reply);

    TOUCHSHARED_EXPORT bool startTest(touch_device *device, TestListener *listener,
                                      StandardType st = Standard_Factory);

    TOUCHSHARED_EXPORT bool startBatchTest(int index,touch_device *device, BatchTestListener *listener,
                                           StandardType st = Standard_Factory);

    TOUCHSHARED_EXPORT void doTest();
    TOUCHSHARED_EXPORT void checkOnboardtestDataAbnormal(onboard_test_data_result *onboardTestData,
                                                         unsigned char *onboardTestItem,int count);

    TOUCHSHARED_EXPORT int getDeviceCount();
    TOUCHSHARED_EXPORT touch_device *getDevices() { return mDevices;}

    // after add touch device info, you need to free there after unused by manually
    static TOUCHSHARED_EXPORT bool addTouchDeviceInfo(touch_vendor_info *info);
    static TOUCHSHARED_EXPORT void freeAllTouchDeviceInfo();

    static TOUCHSHARED_EXPORT bool isSameDeviceInPort(touch_device *a, touch_device *b);

    //批处理升级部分
    TOUCHSHARED_EXPORT void doBatchUpgrade(QString path,BatchUpgradeListener *batchUpgradeListener);
    TOUCHSHARED_EXPORT int startBatchUpgrade(int upgradeIndex,touch_device *device,QString path, BatchUpgradeListener *listener = NULL);
    TOUCHSHARED_EXPORT void setBatchUpgradeStatus(int index,int status);
    TOUCHSHARED_EXPORT void addBatchDeveice(touch_device *device,int index);

    /**
     * @brief device get the default(first) device
     * @return
     */
    TOUCHSHARED_EXPORT touch_device *device() { return mDevices;}
    // compatible device()
    TOUCHSHARED_EXPORT touch_device *devices() { return mDevices;}
    TOUCHSHARED_EXPORT touch_device *setDevices(touch_device *dev) {
        mDevices = dev;
    }

    TOUCHSHARED_EXPORT touch_device *firstConnectedDevice();
    TOUCHSHARED_EXPORT QVariantMap getBatchDevicesInfo();
    TOUCHSHARED_EXPORT touch_device * getDevice(int index);

    /**
     * @brief deviceByPath get device byt path
     * @param path
     * @return
     */
    TOUCHSHARED_EXPORT touch_device *deviceByPath(const char *path);

    /**
     * @brief deviceBySerial not work now
     * @param serial
     * @return
     */
    TOUCHSHARED_EXPORT touch_device *deviceBySerial(const char *serial);

    // commands wrap
    TOUCHSHARED_EXPORT int reset(touch_device *device, int dst = RESET_DST_APP, int delay = 0, int async = 0);

    TOUCHSHARED_EXPORT int getFirewareInfo(touch_device *device, touch_fireware_info *info);
    TOUCHSHARED_EXPORT int getStringInfo(touch_device *device, int type, char *str, int max);
    TOUCHSHARED_EXPORT int getSignalTestItems(touch_device *device, unsigned char *items,
                                              int max, uint32_t mode = STE_ALL_ITEMS);

    TOUCHSHARED_EXPORT int getSignalTestStandard(touch_device *device, unsigned char index,
                    touch_test_standard *standard, uint32_t mode = STE_ALL_ITEMS);
    TOUCHSHARED_EXPORT int getSignalTestData(touch_device *device, unsigned char testIndex, unsigned char *data, int count,
                                             int *actualCount);

    TOUCHSHARED_EXPORT int getMcuInfo(touch_device *device, mcu_info *info);

    TOUCHSHARED_EXPORT int setTLed(touch_device *device, int on = 1);
    TOUCHSHARED_EXPORT int isTLedOn(touch_device *device);

    TOUCHSHARED_EXPORT int setTesting(touch_device *device, int on = 1);
    TOUCHSHARED_EXPORT int isTesting(touch_device *device);

    TOUCHSHARED_EXPORT int setLockAGC(touch_device *device, int on = 1);
    TOUCHSHARED_EXPORT int isLockAGC(touch_device *device);

    TOUCHSHARED_EXPORT int setIndicatorLed(touch_device *device, int mode);

    TOUCHSHARED_EXPORT int setAging(touch_device *device, bool on);
    TOUCHSHARED_EXPORT int isAging(touch_device *device);

    TOUCHSHARED_EXPORT int signalInit(touch_device *device, qint8 mode);

    TOUCHSHARED_EXPORT int enableCoords(touch_device *device, bool enable);

    //onboard
    TOUCHSHARED_EXPORT bool setOnboardTeststatus(touch_device *device,unsigned char *buffer);
    TOUCHSHARED_EXPORT int getOnboardTestboardCount(touch_device *device,unsigned char *items);
    TOUCHSHARED_EXPORT int getOnboardTestBoardAttribute(touch_device *device,unsigned char index,
                                                        get_board_attribute *boardAttribute);

    TOUCHSHARED_EXPORT int getOnboardTestItems(touch_device *device, unsigned char *items,int max, uint32_t mode = STE_ALL_ITEMS);
    TOUCHSHARED_EXPORT int getOnboardTestItemStandard(touch_device *device, unsigned char item,onboard_test_standard *itemStandard, uint32_t mode = STE_ALL_ITEMS);
    TOUCHSHARED_EXPORT bool touchOnboardTest(touch_device *device, unsigned char item,onboard_test_data_result *onboardTestData,uint32_t mode = STE_ALL_ITEMS);
    TOUCHSHARED_EXPORT int getOnboardTestData(touch_device *device,unsigned char item,unsigned char *itemData,unsigned short max);
    TOUCHSHARED_EXPORT bool checkOnboardTestResult(touch_device *device,unsigned char *buffer);
    TOUCHSHARED_EXPORT int sendOnboardTestDataToQML(onboard_test_data_result *onboardTestData);
    //    TOUCHSHARED_EXPORT int

    // V_02
    TOUCHSHARED_EXPORT int getCoordsEnabled(touch_device *device, qint8 channel, qint8 *mode);
    TOUCHSHARED_EXPORT int setCoordsEnabled(touch_device *device, qint8 channel, qint8 enable);
    TOUCHSHARED_EXPORT int getCoordsMode(touch_device *device, qint8 channel, qint8 *mode);
    TOUCHSHARED_EXPORT int setCoordsMode(touch_device *device, qint8 channel, qint8 mode);
    TOUCHSHARED_EXPORT int getRotation(touch_device *device, qint8 *current, qint8 *def);
    TOUCHSHARED_EXPORT int setRotation(touch_device *device, qint8 *values);
    TOUCHSHARED_EXPORT int getMirror(touch_device *device, qint8 *cur, qint8 *def);
    TOUCHSHARED_EXPORT int setMirror(touch_device *device, qint8 *values);
    TOUCHSHARED_EXPORT int getMacOSMode(touch_device *device, qint8 *cur, qint8 *def);
    TOUCHSHARED_EXPORT int setMacOSMode(touch_device *device, qint8 mode);

    // V_03
    TOUCHSHARED_EXPORT int getCalibrationMode(touch_device *device, qint8 *mode);
    TOUCHSHARED_EXPORT int setCalibrationMode(touch_device *device, qint8 mode);
    TOUCHSHARED_EXPORT int getCalibrationSettings(touch_device *device, struct CalibrationSettings *data);
    TOUCHSHARED_EXPORT int setCalibrationSettings(touch_device *device, struct CalibrationSettings *data);
    TOUCHSHARED_EXPORT int getCalibrationPointData(touch_device *device,
                                qint8 where, qint8 index, struct CalibrationData *data);
    TOUCHSHARED_EXPORT int setCalibrationPointData(touch_device *device,
                                qint8 index, struct CalibrationData *data);
    TOUCHSHARED_EXPORT int startCalibrationCapture(touch_device *device, qint8 index);
    TOUCHSHARED_EXPORT int getCalibrationCapture(touch_device *device, struct CalibrationCapture *data);
    TOUCHSHARED_EXPORT int saveCalibrationData(touch_device *device);

    TOUCHSHARED_EXPORT TouchTestData *getSignalDatas(touch_device *device, qint32 index,
                            int dataCount = 0, bool useOldData = false);

    TOUCHSHARED_EXPORT int testSinglePointDraw(touch_device *device, qint8 delay = 5);
    TOUCHSHARED_EXPORT int testMultiPointDraw(touch_device *device, qint8 delay = 5);
    TOUCHSHARED_EXPORT int testCalibrationCapture(touch_device *device, qint32 time = 2000);

    //config
    TOUCHSHARED_EXPORT static void setShowTestData(bool show);
    TOUCHSHARED_EXPORT static void setIgnoreFailedTestItem(bool ignore);
    TOUCHSHARED_EXPORT static void setIgnoreFailedOnboardTestItem(bool ignore);
    TOUCHSHARED_EXPORT static void setSwitchOnboardTest(bool enable);
    TOUCHSHARED_EXPORT static void setContinueOnboardTest(bool _continueOnboardTest);
    TOUCHSHARED_EXPORT void setHutplugCheckInterval(unsigned int interval);

    TOUCHSHARED_EXPORT static void test(void);

private:

    int addPackageToQueue(touch_package *require, touch_package *reply, touch_device *device,
                          int async, CommandThread::CommandListener *listener);
    int startHotplugService();

    int compareTouchDevice(touch_device *tda, touch_device *tdb);

    void freeHidDevice(touch_device *dev);

    int checkCommandReply(touch_package *require, touch_package *reply);
    int isCommandReplySuccessful(touch_package *require, touch_package *reply, int ret = 0, const char *func = "");

    int initDeviceInfo(touch_device *dev);
    void deepCloneDevice(touch_device *dst, touch_device *src);
    bool checkDevice(touch_device *dev);


    // IAP: In Application Program
    int startIAP(touch_device *dev, const struct FirewareHeader *header);
    int IAPDownload(touch_device *dev, qint32 index, const unsigned char *data, int count);
    int IAPVerify(touch_device *dev, qint32 dataLength, qint8 verifyLength, const unsigned char *verifyData);
    int IAPSetFinished(touch_device *dev);

    bool isBootloaderDevice(touch_device *dev);

    bool testSignal(touch_device *device, int testNo, StandardType st = Standard_Factory);
protected:

    unsigned int hotplugInterval;
    bool hotplugEvent;
private:

    int mCount;
    bool mPauseHotplug;
    hid_device_info *mRoot;


    HotplugListener *mHotplugListener;


    UpgradeThread *upgradeThread;

    TestListener *mTestListener;

    touch_device *mTestDevice;
    bool mTesting;

    QSemaphore hotplugSem;

    UpgradeListener *mUpgradeListener;
    bool mUpgrading;

    typedef struct _untData {
        unsigned char *buf;
        unsigned char index;
        struct _untData *next;
    }UntData;

    // for old signal data, UNT signal
    UntData *untDataBuf;

public:
    touch_device *mDevices;
    // config
    static bool mShowTestData;
    static bool mIgnoreFailedTestItem;
    static bool mIgnoreFailedOnboardTestItem;
    static bool switchOnboardTest;
    static bool continueOnboardTest;
public:

    Trans *translator;
    HotplugThread mHotplugThread;
    QMutex initDeviceMutex;
    CommandThread *commandThread;
    CommandThread::DeviceCommunicationRead *deviceCommunication;
    TOUCHSHARED_EXPORT void removeInitFailedDev(touch_device *dev);
    TOUCHSHARED_EXPORT void setBatchUpgradeInfo(int index,int progress = 0,bool result = true,QString info = "");
    TOUCHSHARED_EXPORT QVariantMap getBatchUpgradeData();

    struct BatchUpgradeDeviceList *batchUpgradeDevList;
    volatile bool batchFirstUpgrade;
    struct BatchUpgradeThreadList *batchUpgradeList;
    struct InitDeviceThreadlist *initDeviceThreadList;
    TOUCHSHARED_EXPORT void freeBatchUpgradeList();
    TOUCHSHARED_EXPORT void freeInieDeveicThreadList();
    TestThread *testThread;
    BatchTestListener *batchTestListenter;
    BatchUpgradeListener *batchUpgradeListenter;

    QMutex batchMutex;
    TOUCHSHARED_EXPORT void setBatchLock(bool enable);
    bool mtestStop;
    TOUCHSHARED_EXPORT void setStop(bool _stop);
    bool batchCancal;
    TOUCHSHARED_EXPORT void setBatchCancal(bool cancel);

    QMutex batchDelayMutex;
    //onboard
    int boardCount = 0;
    unsigned char boardIndexBuf[128];

};
struct BatchUpgradeThreadList{
  TouchManager::BatchUpgradeThread *batchUpgradeThread  ;
  int upgradeIndex;
  struct BatchUpgradeThreadList *next;
};
struct InitDeviceThreadlist{
    TouchManager::InitDeviceInfoThread *initDeviceInfoThread;
    touch_device *device;
    struct InitDeviceThreadlist *next;
};
struct BatchUpgradeDeviceList{
  touch_device *dev;
  int upgradeIndex;
  int progress;
  /*
   *  upgradeStatus:升级状态
   *
   *  0   初始化状态
   *  1   升级中状态
   *  2   升级完成状态
   *
  */
  int upgradeStatus;
  struct BatchUpgradeDeviceList *next;
};


#endif // TOUCHMANAGER_H
