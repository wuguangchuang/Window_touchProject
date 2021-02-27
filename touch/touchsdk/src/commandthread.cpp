#include "CommandThread.h"
#include "utils/tdebug.h"

#include "TouchManager.h"
#include <QTime>
#include "hidapi.h"


int CommandThread::stop = false;
//touch_device *CommandThread::deviceList = NULL;
QList<touch_device *> CommandThread::deviceList;
QMutex CommandThread::deviceListMutex;
CommandThread::CommandThread() : sem(0)
{
}
/*
void CommandThread::run()
{
#if 1
    stop = 0;
    int ret;
    int tryCount = 3;
    int i = 0;
    int milliseconds = 30000;
    TDEBUG("command thread running");
    while (!stop) {
//        sem.acquire();
        if(!sem.tryAcquire(1,10))
            continue;

        mutex.lock();
        if (mCommandItem.isEmpty()) {
            mutex.unlock();
            continue;
        }
        //出队
        CommandItem *item = mCommandItem.dequeue();
        mutex.unlock();
        // TODO: deal with command
        item->require->report_id = item->dev->touch.report_id;
        touch_package tp;
        if (item->reply == NULL)
            item->reply = &tp;
//#define _SHOW_TIME
#ifdef _SHOW_TIME
        QTime time;
        time.start();
#endif
        item->dev->mutex.lock();
        tryCount = 3;
        do {
                ret = TouchManager::sendPackageToDevice(item->require, item->reply, item->dev);

                if(ret > 0)
                    break;

                for(i = 0;i < milliseconds / 5 && !stop;i++)
                {
                    ret = TouchManager::wait_time_out(item->dev->hid, (unsigned char *)(item->reply),HID_REPORT_DATA_LENGTH,5);

                    if(ret > 0)
                        break;
                }
                if(stop)
                    break;
                tryCount--;


        } while (ret <= 0 && tryCount > 0 && !stop);

        item->dev->mutex.unlock();
#ifdef _SHOW_TIME
        qDebug("command consume: %u[%d, %d], %d", time.elapsed(),
               item->require->master_cmd, item->require->sub_cmd,
               QTime::currentTime().msecsSinceStartOfDay());
#endif
//        hid_send_data(item->dev->hid, (hid_report_data*)item->require, (hid_report_data*)reply);
        if (item->async) {
            if (item->listener) {
                item->listener->onCommandDone(item->dev, item->require, item->reply);
            }
            delete item->sem;
            free(item);
        } else {
            item->sem->release(1);
        }
    }
#endif

    finshed = true;
    TDEBUG("command thread end");
    exit(0);
}
*/
void CommandThread::run()
{
    int ret;
    int tryCount = 3;
    int i = 0;
    bool canWrite = false;
    TDEBUG("command thread running");

    while(!stop)
    {
        if(!sem.tryAcquire(1,10))
            continue;
        if (mCommandItem.isEmpty())
        {
            continue;
        }
        //判断是否有数据可写
        CommandItem *item = NULL;
        canWrite = false;
        for(i = 0;i < mCommandItem.length() && !stop;i++)
        {
            if(!mCommandItem.at(i)->written)
            {
                item = mCommandItem.at(i);
                canWrite = true;
                break;
            }
        }
        if(!canWrite)
        {
            continue;
        }

        item->require->report_id = item->dev->touch.report_id;

        touch_package tp;
        if (item->reply == NULL)
            item->reply = &tp;

        tryCount = 3;
        do
        {
            ret = TouchManager::sendPackageToDevice(item->require, item->reply, item->dev);
            if(ret > 0)
            {
                item->written = true;
//                TDEBUG("发送命令：主命令 = %0x,从命令 = %0x,随机数 = %d",item->require->master_cmd,item->require->sub_cmd,
//                       item->require->magic);
            }
            if(stop)
                break;
            tryCount--;

        }while(ret <= 0 && tryCount > 0 && !stop);

    }
    finshed = true;
    TDEBUG("command thread end");
//    exit(0);
}
void CommandThread::DeviceCommunicationRead::run()
{
    int ret = 0;
    int i = 0;
    int j = 0;
    TDEBUG("DeviceCommunicationRead thread running");
    //一直读取设备数据
    touch_package reply;
    touch_device *device = NULL;
    int deviceLength = 0;
    while (!CommandThread::stop)
    {
        if(commandThread->mCommandItem.isEmpty())
        {
            QThread::msleep(2);
            continue;
        }
        if(deviceList.isEmpty())
        {
            QThread::msleep(2);
            continue;
        }
        deviceListMutex.lock();
        deviceLength = deviceList.length();
        deviceListMutex.unlock();
        for(j = 0;j < deviceLength;j++)
        {
            deviceListMutex.lock();
            if(j >= deviceList.length())
            {
                deviceLength = deviceList.length();
                device = deviceList.at(deviceLength - 1);
            }
            else
            {
                device = deviceList.at(j);
            }
            deviceListMutex.unlock();
            memset((void *)&reply,0,sizeof(touch_package));
            ret = TouchManager::wait_time_out(device->hid, (unsigned char *)&reply,HID_REPORT_DATA_LENGTH,0);
            if(ret > 0)
            {

                for(i = 0;i < commandThread->mCommandItem.length();i++)
                {
                    CommandItem *item = commandThread->mCommandItem.at(i);
                    if(item->require->report_id != reply.report_id)
                    {
                        break;
                    }
    //                TDEBUG("11读取数据：主命令 = %0x,从命令 = %0x,随机数 = %d",reply.master_cmd,reply.sub_cmd,reply.magic);
                    if(reply.magic == item->require->magic)
                    {
                        if(item->reply == NULL)
                        {
                            touch_package tp;
                             item->reply = &tp;
                        }
    //                    memcpy(item->reply,&reply,sizeof(item->reply));
                        commandThread->copyTouchPackage(item->reply,&reply);
//                        TDEBUG("22读取数据：主命令 = %0x,从命令 = %0x,随机数 = %d",item->reply->master_cmd,item->reply->sub_cmd,
//                               item->reply->magic);
                        item->sem->release(1);
                        break;
                    }
                }
            }
        }

    }
    TDEBUG("DeviceCommunicationRead thread end");
}
int CommandThread::addCommandToQueue(touch_device *dev, touch_package *require,
                                     touch_package *reply,int async, CommandListener *listener)
{
    if (dev == NULL && !dev->touch.connected) {
        TWARNING("%s: device is not ready", __func__);
        return -1;
    }
    if (require == NULL) {
        TWARNING("%s: require is NULL", __func__);
        return -2;
    }

    CommandItem *item = (CommandItem*)malloc(sizeof(struct CommandItem));
    memset(item, 0, sizeof(CommandItem));

    item->dev = dev;
    item->require = require;
    item->reply = reply;
    item->async = async;
    item->written = false;

    item->sem = new QSemaphore(0);
    mutex.lock();
    mCommandItem.append(item);
    mutex.unlock();
    sem.release();
    int tryCouny = 30 * 1000 / 5;
    for(int i = 0;i < tryCouny;i++)
    {
        if(!item->dev->touch.connected)
        {
            break;
        }
        if(item->sem->tryAcquire(1,5))
        {
            break;
        }

    }
//    item->sem->tryAcquire(1,30000);
    mutex.lock();
    mCommandItem.removeOne(item);
    mutex.unlock();
    delete item->sem;
    free(item);
    return 0;
}




void CommandThread::copyTouchPackage(touch_package *dst, touch_package *src)
{
    dst->report_id = src->report_id;
    dst->version = src->version ;
    dst->magic = src->magic;
    dst->flow = src->flow;
    dst->reserved1 = src->reserved1;
    dst->master_cmd = src->master_cmd;
    dst->sub_cmd = src->sub_cmd;
    dst->reserved2 = src->reserved2;
    dst->data_length = src->data_length;
    for(int i = 0;i < src->data_length && i < HID_REPORT_DATA_LENGTH;i++)
    {
        dst->data[i] = src->data[i];
    }
}
