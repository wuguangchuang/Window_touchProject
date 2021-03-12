#include "CommandThread.h"
#include "utils/tdebug.h"

#include "TouchManager.h"
#include <QTime>
#include "hidapi.h"


int CommandThread::stop = false;
QList<touch_device *> CommandThread::deviceList;
QReadWriteLock CommandThread::deviceListRWLock;
CommandThread::CommandThread() : sem(0)
{
}
void CommandThread::run()
{
    int ret;
    int tryCount = 3;
    int i = 0;
    TDEBUG("command thread running");

    while(!stop)
    {
        if(!sem.tryAcquire(1,1))
            continue;
        CommandItem *item = NULL;
        readWriteLock.lockForRead();
        for(i = 0;i < mCommandItem.length() && !stop;i++)
        {
            if(!mCommandItem.at(i)->written)
            {
                item = mCommandItem.at(i);
            }
            else
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
//                    TDEBUG("发送命令：dev = %s,主命令 = %0x,从命令 = %0x,随机数 = %d,command Length = %d",item->dev->touch.id_str,
//                           item->require->master_cmd,item->require->sub_cmd,item->require->magic,mCommandItem.length());
                }
                if(stop)
                    break;
                tryCount--;

            }while(ret <= 0 && tryCount > 0 && !stop);
        }
        readWriteLock.unlock();
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
    int count = 0;
    TDEBUG("DeviceCommunicationRead thread running");
    //一直读取设备数据
    touch_package reply;
    touch_device *device = NULL;
    while (!CommandThread::stop)
    {
        if(commandThread->mCommandItem.length() == 0)
        {
            QThread::msleep(1);
            continue;
        }

        CommandThread::deviceListRWLock.lockForRead();
        if(CommandThread::deviceList.length() == 0)
        {
            CommandThread::deviceListRWLock.unlock();
            QThread::msleep(1);
            continue;
        }
        if(j >= CommandThread::deviceList.length())
        {
            j = 0;
        }
        count++;
        if(count % 100 == 0)
        {
            QThread::msleep(1);
            count = 0;
        }
//        TDEBUG("命令线程检测到设备个数：length =  %d,正在读取的设备序号 j = %d",CommandThread::deviceList.length(),j);
        device = CommandThread::deviceList.at(j++);
        memset((void *)&reply,0,sizeof(touch_package));
        ret = TouchManager::wait_time_out(device->hid, (unsigned char *)&reply,HID_REPORT_DATA_LENGTH,0);
        CommandThread::deviceListRWLock.unlock();
        if(ret > 0)
        {
            commandThread->readWriteLock.lockForRead();
            for(i = 0;i < commandThread->mCommandItem.length();i++)
            {
                CommandItem *item = commandThread->mCommandItem.at(i);
                if(item->require->report_id != reply.report_id)
                {
                    break;
                }
//                TDEBUG("读取数据：dev = %s,主命令 = %0x,从命令 = %0x,随机数 = %d,command Length = %d",item->dev->touch.id_str,
//                       reply.master_cmd,reply.sub_cmd,reply.magic,commandThread->mCommandItem.length());
                if(reply.magic == item->require->magic)
                {
                    if(item->reply == NULL)
                    {
                        touch_package tp;
                         item->reply = &tp;
                    }
                    commandThread->copyTouchPackage(item->reply,&reply);
                    item->sem->release(1);
                    break;
                }
            }
            commandThread->readWriteLock.unlock();
        }
        else
        {
//            TDEBUG("read not");
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

//    TDEBUG("增加命令：主命令 = %0x,从命令 = %0x,随机数 = %d,command Length = %d",item->require->master_cmd,item->require->sub_cmd,
//           item->require->magic,mCommandItem.length());
    mCommandItem.append(item);

    sem.release();
    int tryCouny = 30 * 1000;
    for(int i = 0;i < tryCouny;i++)
    {
        if(!item->dev->touch.connected)
        {
            break;
        }
        if(item->sem->tryAcquire(1,1))
        {
            break;
        }

    }
//    item->sem->tryAcquire(1,30000);
    readWriteLock.lockForWrite();
//    TDEBUG("删除命令：主命令 = %0x,从命令 = %0x,随机数 = %d,command Length = %d",item->require->master_cmd,item->require->sub_cmd,
//           item->require->magic,mCommandItem.length());
    mCommandItem.removeOne(item); 
    readWriteLock.unlock();
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
