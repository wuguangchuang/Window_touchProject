#include "manager.h"



bool Manager::result = false;
Manager::Manager()
{

    if(mTouchManager == NULL)
    {
        mTouchManager = TouchManager::getInstance();
    }

    if(WaitNamedPipe(L"\\\\.\\Pipe\\UninstallDriver", 30 * 1000) == 0)
    {
        TDEBUG("WaitNamedPipe failed,error = %d",GetLastError());
        return ;
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
    resultAndExit();
}

void Manager::refresh_driver()
{
    Manager::result =  mTouchManager->RefreshDriver();
    resultAndExit();
}

void Manager::PipeWrite(bool result)
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

int Manager::PipeRead(char *data, int maxLength)
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

void Manager::resultAndExit()
{
    //将结果发送给父进程
    PipeWrite(Manager::result);

    if (m_hPipe!=NULL && m_hPipe != INVALID_HANDLE_VALUE)
    {
        CloseHandle(m_hPipe);
        m_hPipe=NULL;
    }
    exit(0);
}


void Manager::UninstallDriver::run()
{

    myManager->uninstall_driver();

}

void Manager::RefreshDriver::run()
{
    myManager->refresh_driver();
}
