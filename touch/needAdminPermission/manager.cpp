#include "manager.h"



bool Manager::result = false;
Manager::Manager(int type,int vid, int pid)
{
    this->type =type;
    this->vid = vid;
    this->pid = pid;

    if(mTouchManager == NULL)
    {
        mTouchManager = TouchManager::getInstance();
    }
}

void Manager::uninstall_driver()
{
    int res = 0;
    mTouchManager->uninstallDriver(vid,pid,&res);
    if(res == 1)
    {
        Manager::result = true;

    }
    else
    {
        Manager::result = false;
    }
}


void Manager::UninstallDriver::run()
{

    myManager->uninstall_driver();

}
