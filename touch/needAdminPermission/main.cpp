#include <QCoreApplication>
#include <cstdio>
#include <cstdlib>
#include <Windows.h>
#include <iostream>
#include <QThread>
#include <tdebug.h>
#include <QProcess>

//命名管道
#define PIPE_NAME "\\\\.\\Pipe\\UninstallDdriver"
#define PIPE_SIZE 1024

//WriteFile会阻塞，等待客户端读取完毕
void PipeWrite();

HANDLE m_hPipe;
BOOL m_bConnected;
int main(int argc, char *argv[])
{

//    QCoreApplication app(argc, argv);

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

    PipeWrite();

    if (m_hPipe!=NULL && m_hPipe != INVALID_HANDLE_VALUE)
    {
        CloseHandle(m_hPipe);
        m_hPipe=NULL;
    }


   return 1;
}
//WriteFile会阻塞，等待客户端读取完毕
void PipeWrite()
{
    DWORD   dwWritten;
    TCHAR   buffer[PIPE_SIZE];
    int n = sizeof(buffer);

    strcpy((char *)buffer,"uninstall_driver_1");

    if (!WriteFile(m_hPipe, buffer, n, &dwWritten, NULL))
    {
        TDEBUG("PIPE send ok! data = %s",buffer);
    }
    else
    {
        TDEBUG("%s send error,error = %d",buffer,GetLastError());
    }
}
