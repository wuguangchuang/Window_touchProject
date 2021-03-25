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

//命名管道
#define PIPE_NAME "\\\\.\\Pipe\\UninstallDdriver"
#define PIPE_SIZE 1024

//WriteFile会阻塞，等待客户端读取完毕
void PipeWrite(bool result);
int PipeRead(char *data,int maxLength);

HANDLE m_hPipe;
BOOL m_bConnected;
int main(int argc, char *argv[])
{

//    QCoreApplication app(argc, argv);
    //设置编码格式为 utf-8
    QTextCodec::setCodecForLocale(QTextCodec::codecForName("utf-8"));
    if(argc == 1)
    {
        TDEBUG("argc == 1");
        return 0;
    }
    TDEBUG("argv[1] = %s",argv[1]);


    if(WaitNamedPipe(L"\\\\.\\Pipe\\UninstallDriver", 30 * 1000) == 0)
    {
        TDEBUG("WaitNamedPipe failed,error = %d",GetLastError());
        return 0;
    }

    m_hPipe = CreateFile(L"\\\\.\\Pipe\\UninstallDriver",
            GENERIC_READ | GENERIC_WRITE,
            0,
            NULL, OPEN_EXISTING,
            FILE_ATTRIBUTE_NORMAL,
            NULL);

    if (m_hPipe == INVALID_HANDLE_VALUE)
    {
       m_bConnected = FALSE;
       TDEBUG("CreateFile Error");
    }
    else
    {
       m_bConnected = TRUE;
       TDEBUG("CreateFile OK");
    }
    int type = 0,vid = 0,pid = 0;

    if(strcmp(argv[1],"uninstallDriver") == 0)
    {
        type = 1;
        bool ok;
        char buf[64] = {0};
        if(PipeRead(buf,sizeof(buf)))
        {
            vid = QString("%1").arg(buf).toInt(&ok,16);
        }
        if(PipeRead(buf,sizeof(buf)))
        {
            pid = QString("%1").arg(buf).toInt(&ok,16);
        }
    }



   TDEBUG("type = %0X,VID = %0X,PID = %0X",type,vid,pid);
   Manager *manager = new Manager(type,vid,pid);

   if(type == 1)
   {
       TDEBUG("Start uninstall driver");
       manager->uninstallDriver = new Manager::UninstallDriver(manager);
       manager->uninstallDriver->start();
       manager->uninstallDriver->wait(60 * 1000);
   }

    //将结果发送给父进程
    PipeWrite(Manager::result);

    if (m_hPipe!=NULL && m_hPipe != INVALID_HANDLE_VALUE)
    {
        CloseHandle(m_hPipe);
        m_hPipe=NULL;
    }


   return 1;
}
//WriteFile会阻塞，等待客户端读取完毕
void PipeWrite(bool result)
{
    DWORD   dwWritten;
    TCHAR   buffer[PIPE_SIZE];
    int n = sizeof(buffer);

    strcpy((char *)buffer,result ? "true" : "false");

    if (!WriteFile(m_hPipe, buffer, n, &dwWritten, NULL))
    {
        TDEBUG("%s send error,error = %d",buffer,GetLastError());

    }
    else
    {
        TDEBUG("PIPE send ok! data = %s",buffer);
    }
}
//会阻塞等待有数据读取
int PipeRead(char *data,int maxLength)
{
    DWORD   dwBytesRead;

    memset(data, 0x00, maxLength);
    if (m_bConnected)
    {
        if (ReadFile(m_hPipe, data, maxLength, &dwBytesRead, NULL))
        {
            TDEBUG("读取数据为length = %d,buffer = %s",dwBytesRead,data);
            return 1;
        }
        else
        {
            TDEBUG("读取数据失败,erroe = %d",GetLastError());
            return 0;
        }
    }
    return 0;
}
