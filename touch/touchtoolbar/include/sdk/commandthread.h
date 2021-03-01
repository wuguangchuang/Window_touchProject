#ifndef COMMANDTHREAD_H
#define COMMANDTHREAD_H
#include <QThread>
#include <QSemaphore>
#include <QMutex>
#include <QMutexLocker>
#include <QQueue>
#include <QReadWriteLock>

#include "touch.h"

typedef void (*commandCallBack)(touch_device *, touch_package *);
struct CommandItem;

class CommandThread : public QThread
{
public:
    CommandThread();
    class CommandListener {
    public:
        /**
         * @brief onCommandDone
         * @param dev
         * @param require
         * @param reply if reply is NULL by addCommandToQueue, reply only valid in *listener->onCommandDone scope
         */
        virtual void onCommandDone(touch_device *dev, touch_package *require, touch_package *reply) = 0;
    };

public:
    void run();
    void stopRun(void) { stop = 1; sem.release(10);}
    void setStopValue(void){stop = 1;}
    int addCommandToQueue(touch_device *dev, touch_package *require,
            touch_package *reply,int async = 0, CommandListener *listener = NULL);
    bool getCommandThreadFinshed(){return finshed;}

public:
    class DeviceCommunicationRead : public QThread{
    public:
        DeviceCommunicationRead(CommandThread *commandThread,touch_device *device):stop(false){this->device = device;}
        touch_device *device;
        bool stop;
    protected:
        void run();
    private:
        CommandThread *commandThread;

    };
    QList<CommandItem*> mCommandItem;
    void copyTouchPackage(touch_package *dst,touch_package *src);
    static QList<touch_device *> deviceList;
    static QReadWriteLock deviceListRWLock;
private:
    QSemaphore sem;
    QReadWriteLock readWriteLock;
    int stop;
    bool finshed = false;
};

struct CommandItem {
    touch_device *dev;
    int async;
    bool written;
    QSemaphore *sem;
    CommandThread::CommandListener *listener;
    touch_package *require;
    touch_package *reply;
};

#endif // COMMANDTHREAD_H


