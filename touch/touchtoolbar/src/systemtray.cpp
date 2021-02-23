#include "systemtray.h"
#include "sdk/tdebug.h"
#include <QHBoxLayout>
#include <QVBoxLayout>


SystemTray::SystemTray(SystemTray::Trans *translator ,ActionSignal *actionsSignal,QWidget *parent)
{
    this->translator = translator;
    this->actionsSignal = actionsSignal;
    initAction();
    initTopAction();
    initMidAction();
    initBottomAction();
    addActions();
    initConnect();
    trayIcon->show();
}

SystemTray::~SystemTray()
{
}

void SystemTray::initTopAction()
{
    //顶层菜单项初始化
   m_topWidget = new QWidget();
   m_topWidgetAction = new QWidgetAction(trayMenu);
   m_topLabelIcon = new QLabel();
   m_topLabelIcon->setPixmap(QPixmap(":/dialog/images/smallicon.png"));
   m_topLabelIcon->setFixedSize(30,30);
   QPalette pal(m_topWidget->palette());
   pal.setColor(QPalette::Background,"#3278d7");
   m_topWidget->setAutoFillBackground(true);
   m_topWidget->setPalette(pal);

   m_topLabel = new QLabel(translator->getTr("TouchAssistant"));
   QPalette pe;
   pe.setColor(QPalette::WindowText,Qt::white);
   m_topLabel->setPalette(pe);

   m_topLabel->setObjectName(QString("WhiteLabel"));
   m_topLabel->setFont(QFont("Times", 11));
   QHBoxLayout* m_topLayout = new QHBoxLayout();
   m_topLayout->addWidget(m_topLabelIcon);
   m_topLayout->addWidget(m_topLabel,1,Qt::AlignHCenter | Qt::AlignVCenter);
   m_topLayout->setContentsMargins(20,0,20,0);
   m_topWidget->setLayout(m_topLayout);
   m_topWidget->setMinimumHeight(60);
   m_topWidget->setMinimumWidth(150);
   m_topWidget->installEventFilter(this);
   m_topWidgetAction->setDefaultWidget(m_topWidget);

}

void SystemTray::initMidAction()
{
    m_midTbnWidget = new QWidget();
    m_midTbnWidgetAction = new QWidgetAction(trayMenu);

    upgradeTBtn = new QToolButton();
    upgradeTBtn->setIcon(QIcon(":/dialog/images/upgradeAction.png"));
    upgradeTBtn->setIconSize(QSize(50,50));
    upgradeTBtn->setText(translator->getTr("Upgrade"));
    upgradeTBtn->setAutoRaise(true);
    upgradeTBtn->setToolButtonStyle(Qt::ToolButtonTextUnderIcon);

    testTBtn = new QToolButton();
    testTBtn->setIcon(QIcon(":/dialog/images/testAction.png"));
    testTBtn->setIconSize(QSize(50,50));
    testTBtn->setText(translator->getTr("Test"));
    testTBtn->setAutoRaise(true);
    testTBtn->setToolButtonStyle(Qt::ToolButtonTextUnderIcon);
    QHBoxLayout *layout1 = new QHBoxLayout();
    layout1->setSpacing(10);
    layout1->addWidget(upgradeTBtn);
    layout1->addWidget(testTBtn);
    layout1->setContentsMargins(5,0,5,10);

    chartBtn = new QToolButton();
    chartBtn->setIcon(QIcon(":/dialog/images/mode.png"));
    chartBtn->setIconSize(QSize(50,50));
    chartBtn->setText(translator->getTr("Chart"));
    chartBtn->setAutoRaise(true);
    chartBtn->setToolButtonStyle(Qt::ToolButtonTextUnderIcon);

    settingTBtn = new QToolButton();
    settingTBtn->setIcon(QIcon(":/dialog/images/setting.png"));
    settingTBtn->setIconSize(QSize(50,50));
    settingTBtn->setText(translator->getTr("Settings"));
    settingTBtn->setAutoRaise(true);
    settingTBtn->setToolButtonStyle(Qt::ToolButtonTextUnderIcon);
    QHBoxLayout *layout2 = new QHBoxLayout();
    layout2->setSpacing(10);
    layout2->addWidget(chartBtn);
    layout2->addWidget(settingTBtn);
    layout2->setContentsMargins(5,0,5,10);

    calibrateTBtn = new QToolButton();
    calibrateTBtn->setIcon(QIcon(":/dialog/images/calibrate.png"));
    calibrateTBtn->setIconSize(QSize(50,50));
    calibrateTBtn->setText(translator->getTr("Calibrate"));
    calibrateTBtn->setAutoRaise(true);
    calibrateTBtn->setToolButtonStyle(Qt::ToolButtonTextUnderIcon);

    aboutTBtn = new QToolButton();
    aboutTBtn->setIcon(QIcon(":/dialog/images/about.png"));
    aboutTBtn->setIconSize(QSize(50,50));
    aboutTBtn->setText(translator->getTr("About"));
    aboutTBtn->setAutoRaise(true);
    aboutTBtn->setToolButtonStyle(Qt::ToolButtonTextUnderIcon);


    QHBoxLayout *layout3 = new QHBoxLayout();
    layout3->setSpacing(10);
    layout3->addWidget(calibrateTBtn);
    layout3->addWidget(aboutTBtn);
    layout3->setContentsMargins(5,0,5,10);

    QVBoxLayout *mainLout = new QVBoxLayout();
    mainLout->addLayout(layout1);
    mainLout->addLayout(layout2);
    mainLout->addLayout(layout3);
    mainLout->setContentsMargins(0,0,0,0);
    m_midTbnWidget->setLayout(mainLout);
    m_midTbnWidgetAction->setDefaultWidget(m_midTbnWidget);

}

void SystemTray::initBottomAction()
{
    m_bottomWidget = new QWidget();
    m_bottomWidgetAction = new QWidgetAction(trayMenu);

    m_openBtn = new QPushButton(QIcon(":/image/mainMenu/update.png"), translator->getTr("Open"));
    m_openBtn->setObjectName(QString("TrayButton"));
//    m_openBtn->setFixedSize(80, 25);

    m_exitBtn = new QPushButton(QIcon(":/image/mainMenu/quit.png"), translator->getTr("Exit"));
    m_exitBtn->setObjectName(QString("TrayButton"));
//    m_exitBtn->setFixedSize(80, 25);

    QHBoxLayout* m_bottomLayout = new QHBoxLayout();
    m_bottomLayout->addWidget(m_openBtn, 0, Qt::AlignCenter);
    m_bottomLayout->addWidget(m_exitBtn, 0, Qt::AlignCenter);

    m_bottomLayout->setSpacing(5);
    m_bottomLayout->setContentsMargins(5,5,5,5);

    m_bottomWidget->setLayout(m_bottomLayout);
    m_bottomWidgetAction->setDefaultWidget(m_bottomWidget);

}

void SystemTray::addActions()
{
    trayMenu->addAction(m_topWidgetAction);
//    trayMenu->addSeparator();
    trayMenu->addAction(m_midTbnWidgetAction);
//    trayMenu->addSeparator();
    trayMenu->addAction(m_bottomWidgetAction);
}

void SystemTray::initConnect()
{
    connect(trayIcon,SIGNAL(activated(QSystemTrayIcon::ActivationReason)),this,SLOT(ActivationReason(QSystemTrayIcon::ActivationReason)));
    connect(m_exitBtn,SIGNAL(clicked(bool)),this,SIGNAL(signal_close()));
    connect(m_openBtn,SIGNAL(clicked(bool)),this,SLOT(openProgress()));
    connect(upgradeTBtn,SIGNAL(clicked(bool)),this,SLOT(changeUpgradePage()));
    connect(testTBtn,SIGNAL(clicked(bool)),this,SLOT(changeTestPage()));
    connect(calibrateTBtn,SIGNAL(clicked(bool)),this,SLOT(enterCalibratePage()));
    connect(settingTBtn,SIGNAL(clicked(bool)),this,SLOT(changeSettingPage()));
    connect(aboutTBtn,SIGNAL(clicked(bool)),this,SLOT(changeAboutPage()));
    connect(chartBtn,SIGNAL(clicked(bool)),this,SLOT(changeSignalChartPage()));

}

void SystemTray::ActivationReason(QSystemTrayIcon::ActivationReason activityAction)
{

    switch(activityAction)
    {
    case QSystemTrayIcon::Context:
//        TDEBUG("托盘触发鼠标右键");
        break;
    case QSystemTrayIcon::Trigger:
//        TDEBUG("托盘触发鼠标左键");
        openProgress();
        break;
    }

}

void SystemTray::closeWidget()
{
    trayIcon->hide();
}

void SystemTray::openProgress()
{
    actionsSignal->openProgress(true);
}

void SystemTray::changeUpgradePage()
{
    actionsSignal->setPageIndex(mTAB_Upgrade);
}

void SystemTray::changeTestPage()
{
    actionsSignal->setPageIndex(mTAB_Test);
}

void SystemTray::enterCalibratePage()
{
    actionsSignal->enterCalibratePage();
}

void SystemTray::changeSettingPage()
{
    actionsSignal->setPageIndex(mTAB_Settings);
}

void SystemTray::changeAboutPage()
{
    actionsSignal->setPageIndex(mTAB_Info);
}

void SystemTray::changeSignalChartPage()
{
    actionsSignal->setPageIndex(mTAB_Signal);
}

void SystemTray::initAction()
{
    trayIcon = new QSystemTrayIcon(this);
    trayIcon->setToolTip(tr("TouchAssistant"));
    trayIcon->setIcon(QIcon(":/dialog/images/smallicon.png"));
    trayMenu = new QMenu(this);
    trayIcon->setContextMenu(trayMenu);
}
