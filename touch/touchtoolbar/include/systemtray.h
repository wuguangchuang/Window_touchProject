#ifndef SYSTEMTRAY_H
#define SYSTEMTRAY_H

#include <QWidget>
#include <QSystemTrayIcon>
#include <QAction>
#include <QMenu>
#include <QWidgetAction>
#include <QLabel>
#include <QToolButton>
#include <QPushButton>

#define mTAB_Upgrade 0
#define mTAB_Test 1
#define mTAB_Signal 2
#define mTAB_Aging 3
#define mTAB_Palette 4
#define mTAB_Settings 5
#define mTAB_Info 6

class SystemTray : public QWidget
{
    Q_OBJECT
public:
    class Trans
    {
    public:
        virtual QString getTr(QString str) = 0;
    };
    class ActionSignal{
    public:
        virtual void openProgress(bool isOpen) = 0;
        virtual void setPageIndex(int index) = 0;
        virtual void enterCalibratePage() = 0;
    };

    explicit SystemTray(Trans *translator,ActionSignal *actionsSignal,QWidget *parent = 0);
    ~SystemTray();

    QWidget *m_topWidget;
    QWidgetAction *m_topWidgetAction;
    QLabel *m_topLabelIcon;
    QLabel *m_topLabel;


    QWidget *m_midTbnWidget;                   //中间菜单
    QWidgetAction *m_midTbnWidgetAction;       //中间界面action
    QToolButton *upgradeTBtn;
    QToolButton *testTBtn;
    QToolButton *calibrateTBtn;
    QToolButton *settingTBtn;
    QToolButton *aboutTBtn;
    QToolButton *chartBtn;

    QWidget* m_bottomWidget;                //底部菜单
    QWidgetAction* m_bottomWidgetAction;    //底部界面action
    QPushButton* m_openBtn;
    QPushButton* m_exitBtn;

    //系统托盘显示的图标
    QSystemTrayIcon *trayIcon;

    QMenu *trayMenu;

    void closeWidget();
private:
    Trans *translator;
    ActionSignal *actionsSignal;

    void initAction();                      //初始化Action
    void initTopAction();                   //初始化顶部菜单
    void initMidAction();                   //初始化中间菜单
    void initBottomAction();                //初始化底部菜单
    void addActions();                      //将Action添加到Qmenu上
    void initConnect();                     //初始化信号和槽的连接



signals:
    void signal_close();                    //关闭信号

public slots:
    void ActivationReason(QSystemTrayIcon::ActivationReason activityAction);
    void openProgress();
    void changeUpgradePage();
    void changeTestPage();
    void enterCalibratePage();
    void changeSettingPage();
    void changeAboutPage();
    void changeSignalChartPage();

};

#endif // SYSTEMTRAY_H
