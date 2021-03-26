#ifndef MANAGER_H
#define MANAGER_H

#include <QThread>
#include "sdk/TouchManager.h"

#define REMOVE_DRIVER   0
#define REFRESH_DRIVER  1


//命名管道
#define PIPE_NAME "\\\\.\\Pipe\\UninstallDdriver"
#define PIPE_SIZE 1024

class Manager
{

public:
    Manager();

    TouchManager *mTouchManager;

    //卸载驱动
    class UninstallDriver :public QThread
    {
    public:
        UninstallDriver(Manager *manager)
        {
            this->myManager = manager;
        }

    protected:
        void run();

    private:
        Manager *myManager;

    };
    UninstallDriver *uninstallDriver;
    void uninstall_driver();

    class RefreshDriver :public QThread
    {
    public:
        RefreshDriver(Manager *manager)
        {
            this->myManager = manager;
        }

    protected:
        void run();


    private:
        Manager *myManager;
    };
    RefreshDriver *refreshDriverThread;
    void refresh_driver();


public:

    HANDLE m_hPipe;
    BOOL m_bConnected;

    /*type 取值：
     * REMOVE_DRIVER   ----> 卸载驱动
     * REFRESH_DRIVER  ----> 刷新驱动
    */
    int type;
    int vid;
    int pid;


    //WriteFile会阻塞，等待客户端读取完毕
    void PipeWrite(bool result);
    //会阻塞等待有数据读取
    int PipeRead(char *data,int maxLength);

    void resultAndExit();

public:
    static bool result;


};

#endif // MANAGER_H
