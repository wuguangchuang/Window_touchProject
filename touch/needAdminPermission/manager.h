#ifndef MANAGER_H
#define MANAGER_H

#include <QThread>
#include "sdk/TouchManager.h"

class Manager
{

public:
    Manager(int type,int vid,int pid);

    TouchManager *mTouchManager;

    //卸载驱动
    class UninstallDriver :public QThread
    {
    public:
        UninstallDriver(Manager *manager){this->myManager = manager;}

    protected:
        void run();

    private:
        Manager *myManager;

    };
    UninstallDriver *uninstallDriver;
    void uninstall_driver();



public:
    /*type 取值：
     * 1  ----> 卸载驱动
     * 2  ----> 刷新驱动
    */
    int type;
    int vid;
    int pid;

public:
    static bool result;


};

#endif // MANAGER_H
