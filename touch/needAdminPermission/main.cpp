#include <QCoreApplication>
#include <cstdio>
#include <cstdlib>
#include <Windows.h>
#include <iostream>
#include <QThread>
#include <tdebug.h>
#include <QProcess>
#include <manager.h>
#include <QTextCodec>
#include <stdlib.h>



int main(int argc, char *argv[])
{

    QCoreApplication app(argc, argv);
    //设置编码格式为 utf-8
    QTextCodec::setCodecForLocale(QTextCodec::codecForName("utf-8"));
    if(argc == 1)
    {
        TDEBUG("argc == 1");
        return 0;
    }
    TDEBUG("argv[1] = %s",argv[1]);



    Manager *manager = new Manager();
    if(strcmp(argv[1],"uninstallDriver") == 0)
    {
        manager->type = REFRESH_DRIVER;
        bool ok;
        char buf[64] = {0};
        if(manager->PipeRead(buf,sizeof(buf)))
        {
            manager->vid = QString("%1").arg(buf).toInt(&ok,16);
        }
        if(manager->PipeRead(buf,sizeof(buf)))
        {
            manager->pid = QString("%1").arg(buf).toInt(&ok,16);
        }
        TDEBUG("type = %0X,VID = %0X,PID = %0X",manager->type,manager->vid,manager->pid);

        TDEBUG("Start uninstall driver");
        manager->uninstallDriver = new Manager::UninstallDriver(manager);
        manager->uninstallDriver->start();
//        manager->uninstallDriver->wait(60 * 1000);
    }
    else if(strcmp(argv[1],"refreshDriver") == 0)
    {
        manager->refreshDriverThread = new Manager::RefreshDriver(manager);
        manager->refreshDriverThread->start();
//        manager->refreshDriverThread->wait(60 * 1000);
    }


   return app.exec();
}

