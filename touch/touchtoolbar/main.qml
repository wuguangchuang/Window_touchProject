import QtQuick 2.0
import QtQuick 2.7 as Quick2
import QtQuick.Window 2.2
import QtQuick.Controls 1.4
import QtQuick.Controls 2.0 as Cont2
import QtQuick.Controls.Styles 1.4
import QtQuick.Dialogs 1.1
import QtQuick.Layouts 1.3

import TouchPresenter 1.0
import QDrawPanel 1.0
import "qml/ui"


Window {
    property int buttonMinWidth: 180
    property int buttonMinHeight:60
    property int fontSize: 12
    property int marginWidth: 20
    property int defaultMargin: 10
    property int minMargin: 5

    property int chart_width: 300;
    property int chart_height: 300;
    property int chart_spacing: 20;
    property int text_height: 80;
    property int row_height: 8;

    property int mWidth: 980;
    property int mHeight: 680;
    property int passAgingTime: 10
    property bool setTest: defaultSetTest

    id: mainPage
    visible:false
    width: mWidth
    height: mHeight
//    visibility: Window.Maximized

    // see also TouchTool.h
    property int mAPP_Factory: 0
    property int mAPP_Client: 1
    property int mAPP_RD: 2
    property int mAPP_PCBA: 3

    property int mTAB_Upgrade: 0
    property int mTAB_Test: 1
    property int mTAB_Signal: 2
    property int mTAB_Aging: 3
    property int mTAB_Palette: 4
    property int mTAB_Settings: 5
    property int mTAB_Info: 6
    property int deviceCount: 0

    property int currenttab : 0

    title: qsTr("TouchAssistant")

    property var confirmStopAging: qsTr("sure to stop aging?")

    property string messageTextStringUpdate: ""
    property string messageTextStringTest: ""
    property string messageTextString: ""

    property real windowWidth: mWidth
    property real windowHeight: mHeight

    property string deviceInfoString: ""
    property string deviceInfoName:""
    property string softwareInfoName:""
    property string softwareInfo:""
    property int deviceHeight:0
    property int deviceWidth:0
    property int deviceInfoHeight:50

    property alias updateComBoxId:updatePage.updateComBoxId
    property var messageBox: (mainTabView.currentIndex === 0 || testPage === null ) ? updatePage.messageBox : testPage.messageBox
    property var messageView: (mainTabView.currentIndex === 0 || testPage === null) ? updatePage.messageView : testPage.messageView

    property int lastTabIndex: 0
    function onDestroyed() {
        signalPageTab.restoreCoordsOrNot();
    }
    property bool updatingFw: false
    property bool testingFw: false
    property string testBtnName: qsTr("Test")
    property bool isSupportOnboardtest:false
//    property var testMessage : ""
    property int testMessagLength : 0
    property var testMessage : []
    property int maxMessageLeng:15000
    property var testStr:""

//    property var updateMessage:""
    property var updateMessage:[]
    property int updateMessageLength:0
    property var upgradeShowStr:""
    property int tabViewHeight:Math.max(Math.min(windowHeight / 5.0,tabHeight),20)

    property var lockImage:"qrc:/dialog/images/unlock.png"
    property bool lockCheck:false

    property var deviceMainInfo:qsTr("No connected devices!")
    property var deviceConnectImage:"qrc:/dialog/images/error.png"

    //批处理
    property bool batchFlag:true
    property var batchConnectDeviceInfoList:[]
    property string batchUpgradeFile:""


    //calibration
    property int calibrateMode:1
    property int calibrationPoints : 4


    signal sendOnboardTestFinish(var title,var message,var type);
    signal sendRefreshOnboardTestData(var map);
    signal sendOnboardTestShowDialog(var title,var msg,var type);
    signal sendCloseOnboardTestWindow();
    signal sendDestroyDialog();



    Rectangle {
        anchors.fill: parent
        Keys.enabled: true
        focus: true
        Keys.onPressed: {
        }
        Keys.forwardTo: [calibrationUi]
        TabView {//一个可以切换界面的窗口
            id: mainTabView
            anchors.fill: parent
            anchors.margins: (mainPage.visibility === 5) ? 0 : defaultMargin
            tabsVisible: (mainPage.visibility === 5 || updatingFw || testingFw ) ? false : true
            Keys.enabled: false
            KeyNavigation.tab: null
//            onFocusChanged: console.log("focus:" + focus)
//            onTabPositionChanged: {
////                drawPage
//            }
//            tabsVisible: updatePage.updateButton.enabled
            onCurrentIndexChanged: {
                currentTabRefresh(currentIndex);
                var item = getTab(currentIndex);
                currenttab = item.what;
                lastTabIndex = currentIndex;
                if (item.what !== undefined && item.what === mTAB_Palette) {
                    currentIndex = 0;
                    touch.run("drawpanel.exe");

                }
                if(item.what !== mTAB_Test)
                {
                    onboardTest.visible = false;
                    testProgressBar.value = 0;
                    isSupportOnboardtest = false;
                }

            }

            Tab {
                title: qsTr("Upgrade")
                id: updatePage
                anchors.fill: parent
                property Item updateButton: item.upgradeBtn

                property Item updateComBoxId:item.updateComBoxId
                property string messageText: item.messageText.text
                property Item messageView: item.messageText
                property Item messageBox: item.messageBox
                property Item upgradeProgressBar: item.upgradeProgressBar
                property Item updateShowMsgId:item.updateShowMsgId
                property Item updateShowDialog:item.updateShowDialog
                property Item lockIcon:item.lockIcon

                property int what: mTAB_Upgrade
                property bool flag: true
                property int messageBoxWidth:updateShowMsgId.width
                property int showDialogWidth:0
                property bool showComboBox:false

                Rectangle {
                    property Item upgradeBtn: upgradeBtn

                    property Item updateComBoxId:updateComBoxId
                    property Item messageText: messageText
                    property Item messageBox:item.messageBox
                    property Item upgradeProgressBar: upgradeProgressBar
                    property Item updateShowMsgId:updateShowMsgId
                    property Item updateShowDialog:updateShowDialog
                    property Item lockIcon:lockIcon
                    anchors.fill: parent



                    ColumnLayout {//纵向布局

                        anchors.fill: parent
                        anchors.top: parent.top
                        anchors.topMargin: defaultMargin

                        Rectangle {//横向布局
                            id:upgradePageOneRect
                            Layout.fillWidth: true
                            height: upgradeBtn.height
                            anchors.top: parent.top
                            anchors.left: parent.left
                            Button{
                                id:upgradeBtn;
                                property var text: qsTr("Upgrade")
                                width:Math.min(Math.max(buttonMinWidth,upgradeTestWidth * buttonMinWidth),windowWidth / 2.0);
                                height:Math.min(Math.max(buttonMinHeight,upgradeTestHeight * buttonMinHeight),windowHeight / 5.0);
                                style: ButtonStyle{
                                    label: Text{
                                        text: upgradeBtn.text
                                        color: "#FFFFFF"
                                        font.pointSize: Math.min(fontSize + (Math.min(upgradeTestWidth,upgradeTestHeight) - 1)*5,30)
                                        verticalAlignment: Text.AlignVCenter
                                        horizontalAlignment: Text.AlignHCenter
                                    }
                                    background: Rectangle{

                                        implicitWidth: upgradeBtn.width
                                        implicitHeight: upgradeBtn.height
//                                        border.width: 1
                                        color: (updatePage.flag ? "#64B5F6":"#BDBDBD")
                                        radius: 2
                                    }


                                }

                                onEnabledChanged: {
                                    if (enabled) {
                                        text = qsTr("Upgrade");

                                        updatePage.flag = true;


                                    } else {
                                        text = qsTr("During upgrade");

                                        updatePage.flag = false;
                                    }
                                }

                                onClicked: {

                                    //Qt.quit();
//                                    touch.testMultiPoint();
                                    if (testChartPage != null) {
                                        touch.debug("clear models");
                                        testChartPage.clearModels();

                                    }
                                    mainPage.sendDestroyDialog();
                                    if(updatePage.updateComBoxId.currentIndex >= 0)
                                    {
                                        console.log("升级文件：" + fileText.get(updatePage.updateComBoxId.currentIndex).text);
                                        touch.setUpdatePath(fileText.get(updatePage.updateComBoxId.currentIndex).text);
                                    }
                                    else
                                    {
                                        touch.setUpdatePath("");
                                    }

                                    touch.startUpgrade();
//                                    updatePage.showDialogWidth = updateShowMsgId.width/2;
                                    updatePage.messageBoxWidth = updateShowMsgId.width/2;

                                }

                            }
                            ProgressBar{
                                id: upgradeProgressBar
                                minimumValue: 0;
                                maximumValue: 100;
                                anchors.left: upgradeBtn.right
                                anchors.leftMargin: 5
                                anchors.top: parent.top
                                value: 0;
                                height: upgradeBtn.height
                                width: parent.width - upgradeBtn.width - 5

                                style: ProgressBarStyle {
                                    background: Rectangle {
                                        radius: 2
                                        color: "white"
                                        border.color: "gray"
                                        border.width: 1
                                        implicitWidth: 200
                                        implicitHeight: 24
                                    }
                                    progress: Rectangle {
                                        color: "#64B5F6"
                                        border.color: "#64B5F6"
                                    }
                                }
                            }
                        }

                        //升级界面显示设备信息
                        Rectangle{
                            id:upgradePageMainInfo
                            Layout.preferredHeight: 30
                            Layout.fillWidth: true
                            anchors.bottom: parent.bottom
                            anchors.left: parent.left
                            border.width: 1
                            border.color: "#aaaaaa"
                               RowLayout{
                                   anchors.fill: parent
                                   Image{
                                       id:upgradeDeviceImage
                                       Layout.preferredHeight: 25
                                       Layout.preferredWidth: 25
                                       source: deviceConnectImage
                                       fillMode: Image.Stretch
                                       anchors.verticalCenter: parent.verticalCenter
                                       anchors.left: parent.left
                                       anchors.leftMargin: defaultMargin
                                   }
                                   MyLabel{
                                       id: upgradeDeviceInfo
                                       textStr: deviceMainInfo
                                       Layout.fillWidth: true
                                       Layout.fillHeight: true
                                       anchors.left: upgradeDeviceImage.right
                                       anchors.topMargin: 5

                                   }
                               }
                        }
                        //升级界面显示升级信息
                        Rectangle
                        {

                            border.width: 1
                            border.color: "#aaaaaa"
                            Layout.fillWidth: true
                            Layout.fillHeight: true
                            id:updateShowMsgId
                            property Item messageBox:messageBox
                            anchors.bottom: upgradePageMainInfo.top
                            anchors.bottomMargin: 5
//                            property Item updateShowDialog:updateShowDialog

                            MouseArea{
                                anchors.fill: parent
                                enabled: true
                                acceptedButtons: Qt.AllButtons
                                onClicked: {
                                    updatePage.showComboBox = false;
                                    updateComBoxId.comboBox.state = ""
                                }
                            }
                            RowLayout
                            {
                                anchors.fill:parent
                                Rectangle
                                {

                                    border.width: 1
                                    border.color: "#aaaaaa"
//                                    Layout.preferredWidth: updatePage.messageBoxWidth
                                    Layout.preferredWidth: parent.width / 2.0
                                    Layout.preferredHeight:parent.height


                                    ScrollView {
                                        anchors.fill: parent
                                        horizontalScrollBarPolicy: Qt.ScrollBarAlwaysOff
                                        id: messageBox

                                        Text {
                                            id: messageText
//                                            renderType: Text.NativeRendering
                                            anchors.top: parent.top
                                            anchors.topMargin: 10
                                            anchors.left: parent.left
                                            anchors.leftMargin: 5
                                            anchors.bottomMargin: 10
                                            text:upgradeShowStr
                                            wrapMode: Text.Wrap
                                            font.pointSize: 10
                                            onTextChanged:
                                            {
                                                if (messageText.contentHeight > messageBox.height) {
                                                    messageBox.flickableItem.contentY = messageText.contentHeight - messageBox.height + 20;
                                                }
                                            }

                                        }


                                    }
                                    Rectangle{
                                        anchors.fill: parent
                                        anchors.top: parent.top
                                        anchors.left: parent.left
                                        anchors.bottom: parent.bottom
                                        anchors.right: parent.right
                                        opacity: 0
                                        visible: updatePage.showComboBox ? true : false
                                        MouseArea{
                                            anchors.fill: parent
                                            enabled: true
                                            acceptedButtons: Qt.AllButtons
                                            onClicked: {
                                                updateComBoxId.comboBox.state = ""
                                                updatePage.showComboBox = false;
                                            }
                                        }
                                    }

                                }

                                Rectangle
                                {
                                    id:updateShowDialog
                                    border.width: 1
                                    border.color: "#aaaaaa"
                                    anchors.top: parent.top
                                    anchors.left: messageBox.right
                                    anchors.right: parent.right
                                    Layout.preferredWidth: parent.width / 2.0
                                    Layout.preferredHeight:parent.height
                                }
                            }

                        }
                        //选择升级升级文件部分
                        Rectangle {
                            id:upgradePageTwoRect
                            anchors.top:upgradePageOneRect.bottom
                            anchors.topMargin: 5
                            anchors.bottom: updateShowMsgId.top
                            Layout.preferredHeight: upgradePageOneRect.height
                            Layout.fillWidth: true
                            Button{
                                id:fileSeleected;
//                                property color backgroundColor: ((control.enabled === true) ? ((control.pressed === true) ? "#42A5F5" : "#64B5F6") : "#BDBDBD")
                                Layout.preferredWidth: Math.min(Math.max(buttonMinWidth,upgradeTestWidth * buttonMinWidth),windowWidth / 2.0);
                                Layout.preferredHeight:Math.min(Math.max(buttonMinHeight,upgradeTestHeight * buttonMinHeight),windowHeight / 5.0);
                                style: ButtonStyle {
                                    label: Text {
                                        color: "#FFFFFF"
                                        text: qsTr("Select upgrade file")
                                        font.pointSize: Math.min(fontSize + (Math.min(upgradeTestWidth,upgradeTestHeight) - 1)*5,30)
                                        verticalAlignment: Text.AlignVCenter
                                        horizontalAlignment: Text.AlignHCenter
                                    }
                                    background: Rectangle{

                                        implicitWidth: upgradeBtn.width
                                        implicitHeight: upgradeBtn.height
//                                        border.width: 1
                                        color: (updatePage.flag ? "#64B5F6":"#BDBDBD")
                                        radius: 2
                                    }
                                }



                                onClicked: {
                                    //Qt.quit();
                                    if(updatePage.flag)
                                    {
                                        if(lockCheck)
                                        {
                                            showToast(qsTr("Please unlock and then select firmware"));
                                            return;
                                        }
                                        fileDialog.open();
                                    }
                                }

                            }

                            MyComboBoxLeft
                            {
                                id:updateComBoxId
                                height: fileSeleected.height
                                width: parent.width - fileSeleected.width  - lockIcon.width - 10
                                defCurrentIndex: 0
                                itemsModel: fileText
                                anchors.left: fileSeleected.right
                                anchors.leftMargin: 5
                                itemHeight: height
                                itemWidth: width - height
                                chosenItemTextStr:""

                                property int currentIndex:-1

                                onComboClicked:
                                {
                                    currentIndex = listView.currentIndex;
                                    console.log("当前序号 currentIndex = " + currentIndex);
                                }
                                onShowCombox:
                                {
                                    updatePage.showComboBox = val;
                                }
                                onCurrentIndexChanged:
                                {
                                    if(fileText.get(currentIndex).text === qsTr("clear history(up to ten)"))
                                    {
                                        touch.clearComboBoxData();
                                        updateComBoxId.defCurrentIndex = 0;
                                        chosenItemText.text = "";
                                        fileText.clear();
                                        fileText.insert(0,{"text":qsTr("clear history(up to ten)")});
                                        currentIndex = -1;

                                        touch.setUpdatePath("");
                                        touch.setUpgradeFile("Clear upgrade file");
                                    }
                                    else
                                    {
                                        touch.setUpdatePath(fileText.get(currentIndex).text);
                                        console.log("升级文件为：" + fileText.get(currentIndex).text)
                                    }

                                }
//                                property bool firstTime:true
                                Component.onCompleted:
                                {
                                    if(fileText.count === 0)
                                    {
//                                        firstTime = false;
                                        fileText.insert(0,{"text":qsTr("clear history(up to ten)")});
                                    }

                                }
                            }

                            Rectangle{
                                id:lockIcon
                                width: fileSeleected.height
                                height: fileSeleected.height
                                border.width: 1
                                border.color: "#cdcdcd"
                                visible: true
                                anchors.left: updateComBoxId.right
                                anchors.leftMargin: 5
                                ToolButton{
                                    id:lockBtn
                                    anchors.fill: parent
                                    tooltip: qsTr("Used to lock the firmware.") + "\n" + qsTr("Cannot select firmware when locked.")
                                    Image{
                                        anchors.fill: parent
                                        anchors.centerIn: parent
                                        source:lockImage
                                        fillMode: Image.Stretch
                                    }
                                    onClicked: {
                                        updateComBoxId.comboBox.state = ""
                                        updatePage.showComboBox = false;
                                        if(!lockCheck)
                                        {
                                            updateComBoxId.enabled = false;
                                            lockCheck = true;
                                            lockImage = "qrc:/dialog/images/lock.png"
                                        }
                                        else
                                        {
                                            updateComBoxId.enabled = true;
                                            lockCheck = false;
                                            lockImage = "qrc:/dialog/images/unlock.png"
                                        }
                                    }

                                }

                            }
                       }

                    }

                }
                onVisibleChanged:
                {
                    if(visible)
                    {
                        touch.tPrintf("升级模式:");
//                        console.log("升级界面的信息：" + upgradeShowStr);
//                        showPage = false;
//                        console.log("升级界面的信息：" + upgradeShowStr);
//                        messageText.text = upgradeShowStr;

                    }

                }
            }

            Tab {
                id: testPage;
                title: qsTr("Test")
                property Item messageView: (item !== null) ? item.messageView : null
                property Item messageBox: (item != null) ? item.messageBox : null
                property Item onboardTest:(item != null) ? item.onboardTest : null
                property Item testBtn: (item != null) ? item.testBtn : null
                property Item testProgressBar: (item != null) ? item.testProgressBar : null
                property Item testComboBox:(item != null) ? item.testComboBox : null
                property int testComboBoxIndex:0
                property Item testShowDialog:(item != null) ? item.testShowDialog : null
                property Item volienceUpgradeFileRow:(item != null) ? item.volienceUpgradeFileRow : null
                property Item volienceUpgradeFileText:(item != null) ? item.volienceUpgradeFileText : null

                property bool showComboBox:false
                property bool flag : true

                signal sendOnboardTestStart()


                property int what: mTAB_Test



                onTestComboBoxIndexChanged:
                {
                    if(testComboBoxIndex === 1)
                    {
                        volienceInfo = qsTr("Number of successful upgrades: ") + volienceSuccessfullyNum + "\n" +
                                                                qsTr("Number of failed upgrades: ") + volienceFailedNum;
                    }
                    else if(testComboBoxIndex === 2)
                    {
                        volienceInfo = qsTr("Number of restarts:") + restartNum;
                    }
                }
                Rectangle {
                    id: rectangle
                    anchors.fill: parent
                    property Item messageView: (isSupportOnboardtest ?onboardTest.onboardTestMessage:messageTextTest)
                    property Item messageBox: (isSupportOnboardtest ? onboardTest.showFailMessage:testRect.messageBoxTest)
                    property Item testShowDialog:testRect.testShowDialog
//                    property Item messageView: onboardTest.onboardTestMessage
//                    property Item messageBox: onboardTest.showFailMessage
                    property Item onboardTest:onboardTest
                    property Item testBtn: testBtn
                    property Item testProgressBar: testProgressBar
                    property Item testComboBox:testComboBox
                    property Item volienceUpgradeFileRow:volienceUpgradeFileRow
                    property Item volienceUpgradeFileText:volienceUpgradeFileText
                    property Item volienceUpgradeFileRec:volienceUpgradeFileRec
                    property Item volienceFileSeleected:volienceFileSeleected
                    property Item twoRect:twoRect

                    ColumnLayout {
                        anchors.fill: parent
                        anchors.top: parent.top
                        anchors.topMargin: defaultMargin
                        anchors.left: parent.left
                        //测试按钮一行布局
                        Rectangle{
                            id:oneRect
                            anchors.top: parent.top
                            anchors.topMargin: (touch.getAppType() === mAPP_RD) ? testComboBox.height + 5:0
                            anchors.left: parent.left
                            Layout.fillWidth: true
                            height: Math.min(Math.max(buttonMinHeight,upgradeTestHeight * buttonMinHeight),windowHeight / 5.0)
                            //测试或者连续升级的按钮
                            Button{
                                id:testBtn;
                                checkable: true
                                anchors.top: parent.top
                                anchors.left: parent.left
                                width:testPage.testComboBoxIndex !==2 ? Math.min(Math.max(buttonMinWidth,upgradeTestWidth * buttonMinWidth),windowWidth / 2.0) : parent.width;
                                height:Math.min(Math.max(buttonMinHeight,upgradeTestHeight * buttonMinHeight),windowHeight / 5.0);

                                style:ButtonStyle{
                                    label: Text {
                                        color: "#FFFFFF"
                                        text:testBtnName
                                        font.pointSize: Math.min(fontSize + (Math.min(upgradeTestWidth,upgradeTestHeight) - 1)*5,30)
                                        verticalAlignment: Text.AlignVCenter
                                        horizontalAlignment: Text.AlignHCenter
                                    }
                                    background: Rectangle{

                                        width: testBtn.width
                                        height: testBtn.height
//                                        border.width: 1
                                        color: testBtn.enabled ? "#64B5F6" : "#BDBDBD"
                                        radius: 2
                                    }

                                }


                                onClicked: {

                                    if(checked)
                                    {

                                        onboardTest.midRecttextString = "";
                                        isSupportOnboardtest = false;
                                        onboardTest.visible = false;
                                        testPage.testComboBox.enabled = false;
                                         mainPage.sendDestroyDialog();
                                        testBtnName = qsTr("Cancel");
                                        switch(testPage.testComboBoxIndex)
                                        {
                                        case 0:
                                            touch.setTestThreadToStop(false);
                                            touch.startTest();
                                            break;
                                        case 1:
                                            volienceInfo = qsTr("Number of successful upgrades: ") + 0 + "\n" +
                                                                                    qsTr("Number of failed upgrades: ") + 0;
                                            volienceSuccessfullyNum = 0;
                                            volienceFailedNum = 0;
                                            console.log("升级文件：" + testPage.volienceUpgradeFileText.text);
                                            touch.setUpdatePath(testPage.volienceUpgradeFileText.text);
                                            touch.startVolienceTest(testPage.testComboBoxIndex);
                                            updatingFw = true;
                                            break;
                                        case 2:
                                            volienceSuccessfullyNum = 0;
                                            volienceFailedNum = 0;
                                            volienceInfo = qsTr("Number of restarts:") + 0
                                            touch.startVolienceTest(testPage.testComboBoxIndex);
                                            break;
                                        }
                                    }
                                    else
                                    {


                                        if(testPage.testComboBoxIndex === 0)
                                        {
                                            touch.cancelTest(true);
                                            mainPage.sendDestroyDialog();
                                            touch.setTestThreadToStop(true);
                                            testPage.testBtn.enabled = false;
                                        }
                                        else
                                        {

                                            touch.setCancelVolienceTest(false);
                                            testPage.testBtn.enabled = false;

                                        }


//                                        setTestButtonEnable(false);

                                    }

                                }

                            }
                            //测试进展的情况
                            ProgressBar{
                                id: testProgressBar
                                minimumValue: 0;
                                maximumValue: 100;
                                value: 0;
                                anchors.top: parent.top
                                anchors.left: testBtn.right
                                anchors.leftMargin: 5
                                width:testPage.testComboBoxIndex !==2 ? parent.width - testBtn.width - 5 : 0
                                height: testBtn.height;
                                style: ProgressBarStyle {
                                    background: Rectangle {
                                        radius: 2
                                        color: "white"
                                        border.color: "gray"
                                        border.width: 1
                                        implicitWidth: 200
                                        implicitHeight: 24
                                    }
                                    progress: Rectangle {
                                        color: "#64B5F6"
                                        border.color: "#64B5F6"
                                    }
                                }
                            }
                        }

                        //连续升级的模式下的选择文件部分
                        Rectangle{
                            id:twoRect
                            Layout.preferredWidth: parent.width
                            Layout.preferredHeight: testPage.testComboBoxIndex === 1 ? oneRect.height + 5 : 0
                            anchors.top: oneRect.bottom
                            anchors.topMargin: 5
                            anchors.left: parent.left
                            Button{
                                id:volienceFileSeleected
                                visible: testPage.testComboBoxIndex === 1 ? true : false
                                enabled: (testBtn.checked || updatingFw)? false : true
                                width: testBtn.width
                                height:testBtn.height
                                anchors.top:parent.top
                                anchors.left: parent.left

                                style: ButtonStyle {
                                    label: Text {
                                        color: "#FFFFFF"
                                        text: qsTr("Select upgrade file")
                                        font.pointSize: Math.min(fontSize + (Math.min(upgradeTestWidth,upgradeTestHeight) - 1)*5,30)
                                        verticalAlignment: Text.AlignVCenter
                                        horizontalAlignment: Text.AlignHCenter
                                    }
                                    background: Rectangle{

                                        width: volienceFileSeleected.width
                                        height: volienceFileSeleected.height
                                        color: (testBtn.checked || updatingFw)? "#BDBDBD" : "#64B5F6"
                                        radius: 2
                                    }
                                }
                                onClicked: {
                                        fileDialog.open();
                                }

                            }
                            Rectangle{
                                id:volienceUpgradeFileRec
                                visible: testPage.testComboBoxIndex === 1 ? true : false
                                width: parent.width - volienceFileSeleected.width - 5
                                height: volienceFileSeleected.height
                                anchors.top: parent.top
                                anchors.left: volienceFileSeleected.right
                                anchors.leftMargin: 5
                                border.width: 1
                                border.color: "gray"
                                Text {
                                    id: volienceUpgradeFileText
                                    anchors.fill: parent
                                    elide: Text.ElideLeft // 超出范围左边使用...表示
                                    font.pointSize: 15
                                    verticalAlignment: Text.AlignVCenter

                                }
                            }

                        }
                        //测试界面的设备主要信息部分
                        Rectangle{
                            id:testMainInfoRec
                            Layout.preferredHeight: 30
                            Layout.fillWidth: true
                            border.width: 1
                            border.color: "#aaaaaa"

                            anchors.bottom: parent.bottom
                            anchors.left: parent.left
                               RowLayout{
                                   anchors.fill: parent
                                   Image{
                                       id:testDeviceImage
                                       Layout.preferredHeight: 25
                                       Layout.preferredWidth: 25
                                       source: deviceConnectImage
                                       fillMode: Image.Stretch
                                       anchors.verticalCenter: parent.verticalCenter
                                       anchors.left: parent.left
                                       anchors.leftMargin: defaultMargin
                                   }
                                   MyLabel{
                                       id: testDeviceInfo
                                       textStr: deviceMainInfo
                                       Layout.fillWidth: true
                                       Layout.fillHeight: true
                                       anchors.left: testDeviceImage.right
                                       anchors.topMargin: 5
                                   }
                               }
                        }

                        //中间显示打印信息以及显示图片的部分
                        Rectangle
                        {
                            id:testTextInfo
                            border.width: 1
                            border.color: "#aaaaaa"
                            anchors.top: twoRect.bottom
                            anchors.left: parent.left
                            anchors.bottom: testMainInfoRec.top
                            anchors.bottomMargin: 5
                            Layout.fillHeight: true
                            Layout.fillWidth: true

                            MouseArea{
                                anchors.fill: parent
                                enabled: true
                                acceptedButtons: Qt.AllButtons
                                onClicked: {
                                    testComboBox.comboBox.state = ""
                                    testPage.showComboBox = false;
                                }
                            }
                            //板载测试模式
                            OnboardTestInterface
                            {
                                id:onboardTest
                                anchors.fill: parent
                                anchors.top: parent.top
                                anchors.topMargin: 5
                                anchors.leftMargin: 5
                                anchors.rightMargin: 5
                                anchors.bottomMargin: 5
                                visible: false

                                function startOnboardTest()
                                {
                                    messageTextTest.text = " " + "\n";

                                    onboardTest.visible = true;
                                }
                                Component.onCompleted:
                                {
                                    testPage.sendOnboardTestStart.connect(startOnboardTest);
                                }
                                onVisibleChanged:
                                {
                                    messageTextTest.text = "";
                                    onboardTest.onboardTestMessage.text = "";
                                    if(visible)
                                    {
                                        onboardTest.onboardTestMessage.text += testMessage;
//                                        messageBoxTest.visible = false;
                                        testRect.visible = false;
                                    }
                                    else
                                    {

                                        testRect.visible = true;
                                        testRect.messageBoxTest.text += testMessage;
//                                        messageBoxTest.visible = true;
//                                        messageTextTest.text += testMessage;

                                    }
                                }
                            }
                            //非板载测试模式
                            Rectangle
                            {
                                anchors.fill: parent


                                id:testRect
                                border.width: 1
                                border.color: "#aaaaaa"
                                visible: true
                                property Item messageBoxTest:messageTextTest
                                property Item testShowDialog:testShowDialog
                                RowLayout
                                {
                                    anchors.fill: parent
                                    Rectangle
                                    {
                                        id:showMessageLog
                                        border.width: 1
                                        border.color: "#aaaaaa"
                                        Layout.preferredWidth: parent.width / 2
                                        Layout.preferredHeight: parent.height
                                        ScrollView
                                        {
                                            id: messageBoxTest
                                            anchors.fill: parent
                                            horizontalScrollBarPolicy: Qt.ScrollBarAlwaysOff

                                            Text {
                                                id: messageTextTest
//                                                renderType: Text.NativeRendering
                                                anchors.top: parent.top
                                                anchors.topMargin: 10
                                                anchors.left: parent.left
                                                anchors.leftMargin: 5
                                                anchors.bottomMargin: 10
                                                text:testStr
                                                font.pointSize: 10
                                                onTextChanged:
                                                {
                                                    if (messageTextTest.contentHeight > messageBoxTest.height) {
                                                        messageBoxTest.flickableItem.contentY = messageTextTest.contentHeight - messageBoxTest.height + 20;
                                                    }
                                                }
                                            }

                                        }
                                        Rectangle{
                                            anchors.fill: parent
                                            anchors.top: parent.top
                                            anchors.left: parent.left
                                            anchors.bottom: parent.bottom
                                            anchors.right: parent.right
                                            opacity: 0
                                            visible: testPage.showComboBox ? true : false
                                            MouseArea{
                                                anchors.fill: parent
                                                enabled: true
                                                acceptedButtons: Qt.AllButtons
                                                propagateComposedEvents: true
                                                onClicked: {
                                                    mouse.accepted = false;
                                                    testPage.testComboBox.comboBox.state = ""
                                                    testPage.showComboBox = false;
                                                }
                                            }
                                        }
                                    }

                                    Rectangle
                                    {
                                        anchors.top: parent.top
                                        anchors.left: showMessageLog.right
                                        anchors.right:parent.right
                                        anchors.bottom: parent.bottom
                                        Layout.preferredWidth: parent.width / 2.0
                                        Layout.preferredHeight:parent.height


//                                        color:"#aaaaaa"
                                            Rectangle{
                                                id:testShowDialog
                                                anchors.left: parent.left
                                                anchors.top: parent.top
                                                anchors.right: parent.right
                                                anchors.bottom: parent.bottom
                                                Layout.preferredWidth: parent.width  / 2.0
                                                Layout.preferredHeight: parent.height
                                                border.width: 1
                                                border.color: "#aaaaaa"

                                            }
                                            Rectangle{
                                                id:volientTestInfo
                                                visible: testComboBox.comboBox.selectedIndex !== 0 ? true : false
                                                Layout.preferredWidth:parent.width
                                                Layout.preferredHeight: testComboBox.comboBox.selectedIndex !== 0 ? 80 : 0
                                                anchors.left: parent.left
                                                anchors.top: parent.top
                                                anchors.topMargin: defaultMargin
                                                anchors.leftMargin: 5
                                                Text{
                                                    font.pointSize: 10
                                                    text:volienceInfo
                                                }
                                            }


                                    }
                                }

                            }
                        }
                        MyComboBox{
                            id:testComboBox
                            visible: (touch.getAppType() === mAPP_RD) ? true : false
                            itemsModel: testComboBoxList
                            anchors.top: parent.top
                            anchors.left: parent.left
                            Layout.fillWidth: true
                            Layout.preferredHeight: 40
                            itemHeight: height
                            itemWidth: width - height
                            chosenItemTextStr:qsTr("Test")
                            Component.onCompleted: {
                                testComboBoxList.insert(0,{"text":qsTr("Test")});
                                testComboBoxList.insert(1,{"text":qsTr("Violence upgrade")});
                                testComboBoxList.insert(2,{"text":qsTr("Continuous restart")});
                            }
                            onComboClicked: {

                                testPage.testComboBoxIndex = comboBox.selectedIndex;
                                clearTestInfo();

                                switch(comboBox.selectedIndex)
                                {
                                case 0:
                                    testBtnName = qsTr("Test");
                                    break;
                                case 1:

                                    testBtnName = qsTr("Violence upgrade");
                                    break;
                                case 2:
                                    testBtnName = qsTr("Continuous restart");
                                    break;
                                }
                            }
                            onShowCombox:
                            {
                                testPage.showComboBox = val;
                            }

                        }


                    }

                }
                onVisibleChanged:
                {
                    if(visible)
                    {
                        touch.tPrintf("测试模式:");

                        var str1 = "";
                        for(var i = 0;i < testMessage.length;i++)
                        {
                            str1 += testMessage[i];
                        }
                        messageView.text = str1;
                    }
                    else
                    {

                    }
                }


            } // Tab test

            Tab {

                title: qsTr("Signal chart")
                id: signalPageTab
                property int what: mTAB_Signal
                property Item testChartPage: (item !== null) ? item.testChartPage : null
                property bool usbStatus: false       // 1
                property bool serialStatus: false    // 2
                property int usb_channel: 1
                property int serial_channel: 2
                property bool firstDeviceConnect:false
                Rectangle {
                    property Item testChartPage: testChartPage
                    anchors.fill: parent
                    TestChart {

                        anchors.fill: parent
                        id: testChartPage
                        visible: true

                        Component.onCompleted: {
                            currentStatus = autoDisableCoordinate;
                            enterTest = setTest;
                        }
                        onClick: {
                            if (currentStatus) {
                                signalPageTab.disableCoords();
                            } else if (testChartPage.needRestoreStatus) {
                                restoreCoords();
                            }
                        }
                        onEnterTestChanged: {
                            setTest = enterTest;
                            touch.setTest(setTest ? 1 : 0);
                        }
                    }

                }
                //坐标通道失能
                function disableCoords() {
                    touch.debug("disableCoords");
                    usbStatus = touch.isCoordsEnables(usb_channel);
                    serialStatus = touch.isCoordsEnables(serial_channel);
                    var str = usbStatus?"usbStatus = 当前USB为打开状态":"usbStatus = 当前USB为关闭状态";
                    touch.tPrintf(str);
                    touch.tPrintf("disenable USB channel","disableCoords:");
                    touch.setCoordsEnabled(usb_channel, false);
                    touch.setCoordsEnabled(serial_channel, false);
                    testChartPage.needRestoreStatus = testChartPage.currentStatus;
                }

                function restoreCoords() {

                    touch.tPrintf("restoreCoords: ");
                    var str = usbStatus ? "usbStatus :设置USB状态为打开":"usbStatus:设置USB状态为关闭";
                    touch.tPrintf(str);
                    touch.setCoordsEnabled(usb_channel, usbStatus);
                    touch.setCoordsEnabled(serial_channel, serialStatus);
                }

                function restoreCoordsOrNot() {
                    if (testChartPage  !== null) {
                        if (testChartPage.needRestoreStatus) {
                            restoreCoords();
                        }
                    }
                }

                // handle signal chart
                onVisibleChanged: {
                    if (!visible) {
                        testChartPage.stopAutoRefresh();
                        touch.stopGetSignalDataBg();
                        if (testChartPage.needRestoreStatus) {
                            restoreCoords();
                        }
                    } else {
                        touch.tPrintf("信号图模式:")
                        startSignalChart(false);
                        console.log("selected count = " + testChartPage.getSelectedCount());
                        console.log("deviceCount = " + deviceCount);
                        console.log("defaultTestItems.length = " + defaultTestItems.length);
                        if (testChartPage.getSelectedCount() === 0 && defaultTestItems !== undefined && firstDeviceConnect) {
//                        if (testChartPage.getSelectedCount() === 0 && deviceCount == 1 &&  defaultTestItems !== undefined && firstDeviceConnect) {
                            firstDeviceConnect = false;
                            testChartPage.setSignalItems(defaultTestItems);
                            console.log("defaultTestItems is ok");
                        } else {
                            testChartPage.restoreNumbers();
                        }

                    }
//                    console.log(">>" + defaultTestItems);
                }

            } // Tab signal

            Tab {

//                title: qsTr("Accelerate aging")
                title: qsTr("Batch")
                id: agingPageTab
                property int what: mTAB_Aging
                property Item agingPage: (item !== null) ? item.agingPageV : null
                property Item batchChoose:(item !== null) ? item.batchChooseFile : null
                property Item batchUpgrade:(item !== null) ? item.batchUpgrade : null
                property Item batchUpgradeFileText: (item !== null) ? item.batchUpgradeFileText : null
                property Item batchComboBox:(item !== null) ? item.batchComboBox : null
                property Item batchChooseFile:(item !== null) ? item.batchChooseFile : null
                property Item batchUpgradeFileRec:(item !== null) ? item.batchUpgradeFileRec : null
                property Item batchStartWork:(item !== null) ? item.batchStartWork : null
                property int batchChooseBtnHeight: 50
                property int batchWorkingBtnHeight: 50

                property int functionIndex:0  //默认是加速老化(0)、升级(1)、测试(2)
                property string batchWorkBtnStr:qsTr("Start aging")
                property var batchRunning:false

                property bool showComboBox:false
                Rectangle {
                    anchors.fill: parent
                    anchors.top: parent.top


                    property Item agingPageV:agingPageId
                    property Item batchUpgrade:batchUpgrade
                    property Item batchUpgradeFileText:batchUpgradeFileText
                    property Item batchChooseFile:batchChooseFile
                    property Item batchUpgradeFileRec:batchUpgradeFileRec
                    property Item batchComboBox:batchComboBox
                    property Item batchStartWork:batchStartWork

                    Button{
                        id:batchStartWork
                        width:200
                        height:agingPageTab.batchWorkingBtnHeight
                        anchors.top: parent.top
                        anchors.topMargin: defaultMargin
                        anchors.right:parent.right
                        style: ButtonStyle {
                            label: Text {
                                Layout.preferredWidth:batchChooseFile.width
                                Layout.preferredHeight: batchChooseFile.height
                                color: "#FFFFFF"
                                text: agingPageTab.batchWorkBtnStr
                                font.pointSize: 14
                                verticalAlignment: Text.AlignVCenter
                                horizontalAlignment: Text.AlignHCenter
                            }
                            background: Rectangle{
                                Layout.preferredWidth:batchChooseFile.width
                                Layout.preferredHeight: batchChooseFile.height
//                                            border.width: 1
//                                            border.color: (batchFlag ? "#64B5F6":"#f0f0f0")
                                color: (batchStartWork.enabled ? "#64B5F6":"#404244")
                                radius: 2
                            }
                        }
                        onClicked:
                        {
                            //开始批量升级
                            if(!agingPageTab.batchRunning)
                            {
//                                            batchCheckResultTimer.restart();
                                mainTabView.tabsVisible = false;
                                batchComboBox.enabled = false;
                                agingPageTab.batchRunning  = true;
                                setBatchCancel(false);
                                initBatchDeviceInfo();
                                switch(agingPageTab.functionIndex)
                                {

                                case 0:
                                    //加速老化
                                    agingPageTab.batchWorkBtnStr = qsTr("Stop aging");
                                    for(var i = 0;i < batchConnectDeviceInfoList.length;i++)
                                    {
                                        agingPageTab.agingPage.timeFlag[i] = true;
                                        agingPageTab.agingPage.setDeviceResult(i,agingPage.batchRunning);
                                        agingPageTab.agingPage.setDeviceTime(i,agingPage.passAgingTime);
                                    }
                                    startAging();
                                    startAgingTest();
                                    break;

                                case 1:
                                    //升级
                                    updatingFw = true;
                                    agingPageTab.batchWorkBtnStr = qsTr("Cancel upgrade");
                                    agingPageTab.batchChooseFile.enabled = false;
                                    startBatchUpgrade();
                                    refreshBatchInfoTimer.start();
                                    break;

                                case 2:
                                    //测试
                                    agingPageTab.batchWorkBtnStr = qsTr("Cancel test");
                                    for(i = 0;i < batchConnectDeviceInfoList.length;i++)
                                    {
                                        if(agingPage.getDeviceStatus(i) === agingPage.deviceConnected && agingPage.getDeviceBootloader(i) === 0)
                                        {
//                                                        console.log("测试序号index = " + i);
                                            startBatchTest(i);
                                            agingPageTab.agingPage.setDeviceResult(i,agingPage.batchRunning)
                                        }
                                    }
                                    break;

                                }
                            }
                            else
                            {
                                //取消批处理
                                setBatchCancel(true);
                                agingPageTab.batchRunning = false;
                                batchStartWork.enabled = false;

                                if(agingPageTab.functionIndex === 0)
                                {
//                                                agingPageTab.batchWorkBtnStr = qsTr("Aging");
//                                                stopAgingTest();
                                    for(i = 0;i < batchConnectDeviceInfoList.length;i++)
                                    {
                                        if(agingPage.getDeviceResult(i) === agingPage.batchRunning)
                                        {

                                            agingPage.agingFinished(i);
                                        }

                                    }
                                    agingPage.stopAging();
                                    batchDone();
                                    showToast(qsTr("stop accelerate aging"))
                                }
                                else if(agingPageTab.functionIndex === 1)
                                {

//                                                updatingFw = false;
//                                                agingPageTab.batchWorkBtnStr = qsTr("Upgrade");
                                    showToast(qsTr("Stop upgrading. New connected devices will no longer be upgraded."))
                                }
                                else if(agingPageTab.functionIndex === 2)
                                {
//                                                agingPageTab.batchWorkBtnStr = qsTr("Test");
                                    showToast(qsTr("Stop testing. New connected devices will no longer be tested."))
                                }

                            }


                        }
                    }

                    Button{
                            id:batchChooseFile
                            visible: false
                            width: 200
                            height:batchComboBox.height
                            anchors.top:batchComboBox.bottom
                            anchors.topMargin: 5
                            anchors.left:parent.left
                            style: ButtonStyle {
                                label: Text {
                                    Layout.preferredWidth:batchChooseFile.width
                                    Layout.preferredHeight: batchChooseFile.height
                                    color: "#FFFFFF"
                                    text: qsTr("Select upgrade file")
                                    font.pointSize: 14
                                    verticalAlignment: Text.AlignVCenter
                                    horizontalAlignment: Text.AlignHCenter
                                }
                                background: Rectangle{
                                    Layout.preferredWidth:batchChooseFile.width
                                    Layout.preferredHeight: batchChooseFile.height
                                    border.width: 1
                                    border.color: (enabled ? "#64B5F6":"#BDBDBD")
                                    color: (enabled ? "#64B5F6":"#BDBDBD")
                                    radius: 2
                                }


                            }
                            onClicked: {
                                //Qt.quit();
                                fileDialog.open();
                            }

                        }
                        Rectangle{
                            id:batchUpgradeFileRec
                            visible: false
                            width:parent.width - batchChooseFile.width - batchStartWork.width - 10
                            height: batchChooseFile.height
                            anchors.top:batchComboBox.bottom
                            anchors.topMargin: 5
                            anchors.left:batchChooseFile.right
                            anchors.right: batchStartWork.left
                            anchors.leftMargin: 5
                            anchors.rightMargin: defaultMargin
                            border.width: 1
                            border.color: "gray"
                            Text {
                                id: batchUpgradeFileText
                                anchors.fill: parent
                                elide: Text.ElideLeft // 超出范围左边使用...表示
                                font.pointSize: 14
                                verticalAlignment: Text.AlignVCenter

                            }
                        }
                        Rectangle{
                            anchors.top: batchStartWork.bottom
                            width: parent.width
                            height: parent.height - batchStartWork.height - defaultMargin

                            Aging{
                                anchors.fill: parent
                                anchors.top: parent.top
                                anchors.topMargin: defaultMargin
                                passAgingTime: mainPage.passAgingTime

                                id: agingPageId

                                onAgingFinished: {
//                                    rectangle.setp();
                                    mainPage.agingFinished(index);
                                }

                            }
                        }
                        Rectangle{
                            anchors.top: batchStartWork.bottom
                            width: parent.width
                            height: parent.height - batchStartWork.height - defaultMargin
                            opacity: 0
                            visible: agingPageTab.showComboBox ? true : false
                            MouseArea{
                                anchors.fill: parent
                                enabled: true
                                acceptedButtons: Qt.AllButtons
                                onClicked: {
                                    batchComboBox.comboBox.state = ""
                                    agingPageTab.showComboBox = false;
                                }
                            }
                        }
                        MyComboBox{
                            id:batchComboBox
                            width:parent.width - batchStartWork.width - 5
                            height: 50
                            visible: true
                            enabled: true
                            defCurrentIndex: 0
                            itemsModel: batchText
                            anchors.top: parent.top
                            anchors.topMargin: defaultMargin
                            anchors.left:parent.left
                            anchors.right:batchStartWork.left
                            anchors.rightMargin:defaultMargin
                            itemWidth: width - height
                            itemHeight: height
                            chosenItemTextStr:qsTr("Accelerate aging")

                            property int currentIndex:defCurrentIndex
                            onComboClicked: {
                                currentIndex = comboBox.selectedIndex;
                                initBatchDeviceInfo();
                                console.log("current index = " + currentIndex);
                                agingPageTab.functionIndex = currentIndex;
                                agingPage.setFunctionIndex(currentIndex);
                                switch(currentIndex)
                                {
                                case 0:
                                    agingPageTab.batchWorkBtnStr = qsTr("Start aging")
                                    agingPageTab.batchChooseFile.visible = false;
                                    agingPageTab.batchUpgradeFileRec.visible = false;
                                    agingPageTab.batchChooseBtnHeight = 0;
                                    agingPageTab.batchWorkingBtnHeight = 50;

                                    break;
                                case 1:
                                    agingPageTab.batchWorkBtnStr = qsTr("Start upgrade")
                                    batchChooseFile.visible = true;
                                    batchUpgradeFileRec.visible = true;
                                    agingPageTab.batchChooseBtnHeight = 50;
                                    agingPageTab.batchWorkingBtnHeight = 105;
                                    break;
//                                    case 2:
//                                        agingPageTab.batchWorkBtnStr = qsTr("Start test")
//                                        batchChooseFile.visible = false;
//                                        batchUpgradeFileRec.visible = false;
//                                        agingPageTab.batchChooseBtnHeight = 0;
//                                        agingPageTab.batchWorkingBtnHeight = 40;
//                                        break;
                                }
                            }
                            onShowCombox:
                            {
                                agingPageTab.showComboBox = val;
                            }


                        }

                    }
                Component.onCompleted: {
                    batchText.insert(0,{"text":qsTr("Accelerate aging")});
                    batchText.insert(1,{"text":qsTr("Upgrade")});
//                    batchText.insert(2,{"text":qsTr("Test")});
                }
                onVisibleChanged: {
                    if(visible)
                    {
//                        batchComboBox.currentIndex = 0;
                        agingPageTab.functionIndex = batchComboBox.currentIndex;
                        agingPage.functionIndex = batchComboBox.currentIndex;
//                        batchWorkBtnStr = qsTr("Start aging");
                        batchWorkBtnStr = batchText.get(batchComboBox.currentIndex).text;
                        batchRunning = false;
                        initBatchDeviceInfo();
                    }
                    else
                    {

                    }

                }


            } // Tab aging


            Tab {

                title: qsTr("Paint")
                id: drawPage
                property int what: mTAB_Palette

                Rectangle {

                    width: 1080
                    height: 1920
                    x: 0
                    y: 0
                }
                onVisibleChanged: {
                    touch.tPrintf("全屏画图模式：");
//                    drawPanel.visible = visible;
                }
            }
            Tab {

                id: settingsTabId
                property Item settingsPage: (item !== null) ? item.settingsPageV : null
                title: qsTr("Settings")
                property int what: mTAB_Settings
                Rectangle {
                    anchors.fill: parent
                    property Item settingsPageV: settingsId
                    ColumnLayout{
                        anchors.fill: parent
                        anchors.top: parent.top
                        anchors.topMargin: defaultMargin
                        SettingPage{
                            id:settingsId
                            focus: true
                            Keys.enabled: true
    //                        anchors.fill: parent
                            Layout.preferredHeight: parent.height - settingeviceInfo.height - defaultMargin
                            Layout.preferredWidth: parent.width
                        }
                        Rectangle{
                            id:settingeviceInfo
                            anchors.bottom: parent.bottom
                            anchors.left: parent.left
                            Layout.preferredHeight: 30
                            Layout.fillWidth: true
                            border.width: 1
                            border.color: "#aaaaaa"
                               RowLayout{
                                   anchors.fill: parent
                                   Image{
                                       id:settingDeviceImage
                                       Layout.preferredHeight: 25
                                       Layout.preferredWidth: 25
                                       source: deviceConnectImage
                                       fillMode: Image.Stretch
                                       anchors.verticalCenter: parent.verticalCenter
                                       anchors.left: parent.left
                                       anchors.leftMargin: defaultMargin
                                   }
                                   MyLabel{
                                       id: settingDeviceInfo
                                       textStr: deviceMainInfo
                                       Layout.fillWidth: true
                                       Layout.fillHeight: true
                                       anchors.left: settingDeviceImage.right
                                       anchors.topMargin: 5
                                   }
//                                   Text {
//                                       id: settingDeviceInfo
//                                       text: deviceMainInfo
//                                       anchors.left: settingDeviceImage.right
//                                       anchors.leftMargin: defaultMargin
//                                       anchors.verticalCenter: parent.verticalCenter
//                                   }
                               }
                            }
                    }



                }
                onVisibleChanged: {
                    if(visible)
                    {
                        touch.tPrintf("设置模式:");
                        settingsPage.refreshSettings();
                    }
                }
            }
            Tab {
                title: qsTr("About")
                id: infoTab
                property int what: mTAB_Info
                signal refreshInfo();
                Rectangle{
                    anchors.fill: parent
                    ColumnLayout {
                        anchors.fill: parent

                        RowLayout
                        {
                            id:deviceID
//                            height: deviceHeight
                            anchors.fill: parent
                            anchors.left: parent.left
                            anchors.top: parent.top
                            Rectangle
                            {
                                id:deviceInfoNameID
                                anchors.fill: parent
                                anchors.top:parent.top
                                anchors.left: deviceInfoNameID.right
                                anchors.leftMargin: defaultMargin
                                anchors.topMargin: defaultMargin

                                MyLabel{

                                    width: parent.width
                                    height: parent.height
//                                    textStr: deviceInfoName + "\n" +softwareInfoName
                                    textStr: deviceInfoName
                                    fontSize: 13
                                }
                            }

                        }

                    }
                }
                onRefreshInfo:
                {
                    deviceInfoName =  touch.getRelativeInfo();
                }
                onVisibleChanged: {
                    if (visible) {
//                        showDeviceInfo();
                       deviceInfoName =  touch.getRelativeInfo()
                        touch.tPrintf("关于界面");
                    }
                }

            } // Tab info

            //================================================


            style: TabViewStyle {
                    frameOverlap: 1
                    tab: Rectangle {
                        color: styleData.selected ? "steelblue" :"#E1F5FE"
                        border.color:  "steelblue"
                        implicitWidth:Math.max(Math.min(Math.max(text.width + 4, 80) * tabWidth,windowWidth / mainTabView.count),Math.max(text.width + 4, 80));
                        implicitHeight: Math.max(Math.min(windowHeight / 5.0,20 * tabHeight),20)
                        radius: 2
                        Text {
                            id: text
                            anchors.centerIn: parent
                            text: styleData.title
                            font.pointSize: Math.min(8 + (tabHeight - 1) * 2,20)
                            color: styleData.selected ? "white" : "black"
                        }

//                        MouseArea {
//                            anchors.fill: parent
//                            propagateComposedEvents: true
//                            onPressed: {
//                                if ("全屏画图" === text.text && mainPage.visibility != Window.FullScreen) {
//                                    drawPanel.visible = false;
//                                    drawPanel.visible = true;
//                                }
//                                mouse.accepted = false;
//                            }
//                        }
                    }
                    frame: Rectangle { color: "steelblue" }
                }
        } // tabview

        //校准界面
        property Item calibrationUi : calibrationUi
        Calibration{
            id: calibrationUi
            Keys.enabled: false
            x: 0
            y: 0
            z: 1

            width: Screen.width
            height: Screen.height
            focus: false
            visible: false
            onExit: {
                exitCalibrate();
            }

        }

        FineTune{
            id:fineTune

            Keys.enabled: false
            x: 0
            y: 0
            z: 1
            width: Screen.width
            height: Screen.height

            focus: false
            visible: false
            onExitTune: {
                exitFineTune();
            }
            onVisibleChanged: {
                if(visible)
                {
                    initPointData();
                }
            }
        }

        EdgeStrech{
            id:edgeStrech
            x: 0
            y: 0
            z: 1

            width: Screen.width
            height: Screen.height
            focus: false
            visible: false

            onVisibleChanged: {
                if(visible)
                {
                    startEdgeStrech();
                }
            }
            onExitEdgeStrech: {
                mainPage.exitEdgeStrech();
            }
        }



    }
    Timer{
        id:batchCheckResultTimer
        interval:200
        repeat:true   //响应一次之后是否继续响应
        running:false   
        triggeredOnStart:false  //第一次开始计时是否响应
        onTriggered:{
            //检测是否批处理完成
            if(!agingPageTab.batchRunning)
            {
                var allFinish = true;
                for(var i = 0;i < agingPage.deviceCount;i++)
                {
//                    touch.tPrintf("序号 = " + i + ",结果 = agingPage.getDeviceResult(i) = " + agingPage.getDeviceResult(i));
                    if(agingPage.getDeviceResult(i) === agingPage.batchRunning)
                    {
                        allFinish = false;
                        break;

                    }
                }
                if(allFinish)
                {
                    touch.tPrintf("全部升级完成");

//                    batchCheckResultTimer.stop();
                }
            }
        }

    }

    function batchDone()
    {
        touch.tPrintf("批处理完成");
        refreshBatchInfoTimer.stop();
        mainTabView.tabsVisible = true;
        agingPageTab.batchComboBox.enabled = true;
        agingPageTab.batchStartWork.enabled = true;
        agingPageTab.batchChooseFile.enabled = true;
        if(agingPageTab.functionIndex === 0)
        {
            agingPageTab.batchWorkBtnStr = qsTr("Start aging");
        }
        else if(agingPageTab.functionIndex === 1)
        {
            agingPageTab.batchWorkBtnStr = qsTr("Start upgrade");
            touch.batchFinished(agingPageTab.functionIndex);
        }
        else if(agingPageTab.functionIndex === 2)
        {
            agingPageTab.batchWorkBtnStr = qsTr("Start test");
        }
        updatingFw = false;
    }
    property alias agingPage: agingPageTab.agingPage

    ListModel
    {
        id: fileText
    }
    ListModel{
        id:batchText
    }
    ListModel{
        id:testComboBoxList
    }
    property alias batchUpgradeFileText:agingPageTab.batchUpgradeFileText
    //该函数是通过文件夹获取到到的固件
    function setUpgradeFile(file,type) {
        if(type !== 0 && lockCheck && currenttab === mTAB_Upgrade)
        {
            showToast(qsTr("Please unlock and then select firmware"));
            return;
        }
        if(updatingFw)
        {
            showToast(qsTr("Unable to change firmware while upgrading"));
            return;
        }
        file = "" + file;
        if(currenttab === mTAB_Upgrade || type === 0)
        {
            if(fileText.count === 0)
            {
                fileText.insert(0,{"text":qsTr("clear history(up to ten)")});
            }
            var existFlsg = false;
            for(var i = 0;i < fileText.count;i++)
            {

                if(fileText.get(i).text === file)
                {
                    existFlsg = true;
                    break;
                }
            }
            if(!existFlsg)
            {
                fileText.insert(0,{"text":file});

                //保存文件
                touch.setUpgradeFile(file);
                if(fileText.count > 10)
                {
                    fileText.remove(fileText.count - 1);
                }


            }
            for(i = 0;i < fileText.count;i++)
            {
                if(fileText.get(i).text === file)
                {
                    updateComBoxId.currentIndex = i;
                    updateComBoxId.chosenItemText.text = file;
                    updateComBoxId.listView.currentIndex = i;
                    break;
                }
            }
            //设置升级文件
            touch.setUpdatePath(file);
        }
        else if(currenttab === mTAB_Aging)
        {
            console.log("获取到批量升级的文件");

            batchUpgradeFileText.text = file;
            batchUpgradeFile = file;
        }
        else if(currenttab === mTAB_Test)
        {
            console.log("获取到暴力升级的文件")
            testPage.volienceUpgradeFileText.text = file;

        }


        file = file.replace("file:///", "");
        var regex = /[^/]*bin/g;
        file = file.replace(regex, '');
        var folder = "file:///" + file.replace(new RegExp("/", 'g'), "\\");
//        folder = folder.replace(new RegExp("[^\/]*bin", 'g'), "")
//        folder = folder.replace(regex, '');
//        console.log("fFF: " + folder)
        fileDialog.folder = folder;
    }

    FileDialog {
        id: fileDialog
        nameFilters: [ qsTr("bin file")+"(*.bin)", qsTr("all files")+"(*)" ]
        title: "Please choose a file"
        onAccepted: {
//            console.log("You chose: " + fileDialog.fileUrls)
            this.close();
            setUpgradeFile(fileDialog.fileUrl,1);
            //touch.updateFireware(fileDialog.fileUrl);
        }

//        folder: "file:///F:"
        onRejected: {
            console.log("Canceled")
            this.close();
        }
        //Component.onCompleted: visible = true
    }

    FileDialog {
        property int mode: 0
        id: calibrationfileDialog
        nameFilters: [ qsTr("json file") + "(*.json)", qsTr("all files") + "(*)" ]
        selectExisting: mode === 0
        onAccepted: {
            if (mode === 0) {
                loadCalibrationData(calibrationfileDialog.fileUrl);
            } else if (mode === 1) {
                saveCalibrationData(calibrationfileDialog.fileUrl);
            }
        }
        folder: "file:///F://"
        onRejected: {
            this.close();
        }
        //Component.onCompleted: visible = true
    }

    function getFileText(){
//        return fileText.text;
        return updateComBoxId.currentText;
    }

    /*
QMessageBox::NoIcon	0	the message box does not have any icon.
QMessageBox::Question	4	an icon indicating that the message is asking a question.
QMessageBox::Information	1	an icon indicating that the message is nothing out of the ordinary.
QMessageBox::Warning	2	an icon indicating that the message is a warning, but can be dealt with.
QMessageBox::Critical	3	an icon indicating that the message represents a critical problem.
      */

    function showDialog(title, msg, type) {

        var tt;
        var titleName;
        var accpetTextBtn;
        var currentPage;

            tt = Qt.createComponent("qrc:qml/ui/InformationSign.qml");

            if (tt.errorString())
                touch.error("chart erros:" + tt.errorString());
            if(currenttab === mTAB_Test)
            {
                if(testPage.testComboBoxIndex === 1)
                {
                    currentPage = testPage.testShowDialog;
                }
                else
                {
                    currentPage = isSupportOnboardtest?onboardTest.midRectText:testPage.testShowDialog;
                }

            }
            else
            {
                currentPage = updatePage.updateShowDialog;
            }

            tt = tt.createObject(currentPage);
            tt.showMessage({
                               message: msg,
                               icon: type,
                               showCancel: false
                           })

//        }
        /*
        else
        {
//            if(isSupportOnboardtest)
//                onboardTest.midRecttextString = msg;

            tt = Qt.createComponent("qrc:qml/ui/TDialog.qml");
            //        console.log("chart erros:" + tt.errorString())
            if (tt.errorString())
                touch.error("chart erros:" + tt.errorString());

            if(showPage)
            {

                currentPage = isSupportOnboardtest?onboardTest.midRectText:testPage.testShowDialog;
            }
            else
            {
                currentPage = updatePage.updateShowDialog;

            }
            tt = tt.createObject(currentPage);
            tt.showMessage({
                               title: title,
                               message: msg,
                               icon: type,
                               accpetText: qsTr("close"),
                               showCancel: false
                           })

        }
        */

        mainPage.sendDestroyDialog.connect(tt.closeDialog);
    }
    function destroyDialog()
    {
        mainPage.sendDestroyDialog();
    }

    property alias upgradeProgressBar: updatePage.upgradeProgressBar
    function updateUpgradeProgress(progess) {
        if(currenttab === mTAB_Upgrade)
        {
            upgradeProgressBar.value = progess;
        }
        else if(currenttab === mTAB_Test)
        {
            testProgressBar.value = progess;
        }

//        console.debug("upgrade " + progess)
    }

    property alias testProgressBar: testPage.testProgressBar
    function updateTestProgress(progess) {
        testProgressBar.value = progess;
    }

    //type 0 == 升级测试界面均有的信息
    //type 1 == 升级模式
    //type 2 == 测试模式
    function appendText(message, type) {
       var tmpLength = 0;
       var tmpArray = [];
       var index = 0;
       var tmpSaveLeng = 0;
       var str = "";
       var i = 0;
       var str1 = "";
       str = message + "\n";
       if(type === 0)
       {
           var finalMessage = "";
           finalMessage = message.split(":");
           if(finalMessage[3].search("TouchApp") !== -1)
           {
               showToast(finalMessage[3]);
           }

       }
       if(type === 1 || type === 0)
       {
           updateMessage.push(str);
           updateMessageLength += str.length;

           if(updateMessageLength < maxMessageLeng)
           {
               str1 = "";
               for(i = 0;i < updateMessage.length;i++)
               {
                   str1 += updateMessage[i];
               }
//                mv.text = str1;
               upgradeShowStr = str1;
           }
           else
           {
               var tmpUpdateLength = 0;
               var tmpUpdateArray = [];
               var updateIndex = 0;
               var tmpUpdateSaveLeng = 0;
               str1 = "";
               for(i = 0;i < updateMessage.length;i++)
               {
                   tmpUpdateLength += updateMessage[i].length;
                   if((updateMessageLength - tmpUpdateLength) > maxMessageLeng)
                   {
                       continue;
                   }
                   tmpUpdateArray[updateIndex++] = updateMessage[i];
                   str1 += updateMessage[i];
                   tmpUpdateSaveLeng += updateMessage[i].length;
               }
//                mv.text = str1;
               upgradeShowStr = str1;
               updateMessage = tmpUpdateArray;
               updateMessageLength = tmpUpdateSaveLeng;
           }
           updatePage.messageView.text = str1;
       }
       if(type === 2 || type === 0)
       {
           testMessage.push(str);
           testMessagLength += str.length;

           if(testMessagLength < maxMessageLeng)
           {
               str1 = "";
               for(i = 0;i < testMessage.length;i++)
               {
                   str1 += testMessage[i];
               }
//                mv.text = str1;
//                testStr = str1;
           }
           else
           {
               tmpLength = 0;
               tmpArray = [];
               index = 0;
               tmpSaveLeng = 0;
               str1 = "";
               for(i = 0;i < testMessage.length;i++)
               {
                   tmpLength += testMessage[i].length;
                   if((testMessagLength - tmpLength) > maxMessageLeng)
                   {
                       continue;
                   }
                   tmpArray[index++] = testMessage[i];
                   str1 += testMessage[i];
                   tmpSaveLeng += testMessage[i].length;
               }
//                mv.text = str1;

               testMessage = tmpArray;
               testMessagLength = tmpSaveLeng;
//                testStr = str1;
           }
           testPage.messageView.text = str1;
       }

    }
//    property string volienceInfo:qsTr("Number of successful upgrades: ") + 0 + "\n" +
//                                        qsTr("Number of failed upgrades: ") + 0
    property string volienceInfo:""
    property int volienceSuccessfullyNum:0
    property int volienceFailedNum:0
    property string lastFailedReason:""

    property int restartNum:0
    function saveUpgradeResultNum(result,info)
    {
        console.log("升级完成结果result = " + result ? 1 : 0);
        if(result)
        {
            volienceSuccessfullyNum += 1;

        }
        else
        {
            volienceFailedNum += 1;
            lastFailedReason = info;
        }
        console.log("升级成功次数 = " + volienceSuccessfullyNum + ",升级失败的次数 = " + volienceFailedNum);
        if(volienceFailedNum > 0)
        {
            volienceInfo = qsTr("Number of successful upgrades: ") + volienceSuccessfullyNum + "\n" +
                    qsTr("Number of failed upgrades: ") + volienceFailedNum + "\n" +
                    qsTr("The last upgrade failed because: ") + lastFailedReason;
        }
        else
        {
            volienceInfo = qsTr("Number of successful upgrades: ") + volienceSuccessfullyNum + "\n" +
                    qsTr("Number of failed upgrades: ") + volienceFailedNum ;
        }


    }

    function resetNum(count)
    {
        restartNum = count;
        volienceInfo = qsTr("Number of restarts:") + restartNum;
    }
    function setText(message) {
        if (messageView === null)
            return;
        messageView.text = message
    }

    property alias testChartPage: signalPageTab.testChartPage
    function updateSignalData(data) {
        testChartPage.updateSignalData(data);
    }
    function updateChart() {
        testChartPage.updateChart(0);
    }

    function getSignalData(index) {
        return touch.getSignalData(index);
    }

    function setVisibleValue()
    {
        console.log("testPage.sendOnboardTestStart()");
        testPage.sendOnboardTestStart();
        isSupportOnboardtest = true;
    }
    property alias onboardTest : testPage.onboardTest
    function changeOnboardtestString(info)
    {
        onboardTest.midRecttextString = info;
    }

    property alias testBtn: testPage.testBtn
    function setTestButtonEnable(enable) {
        testBtn.enabled = enable;
    }
    function setTestButtonCheck(check)
    {
        testBtn.checked = check;

    }
    function setTextButtonText(status)
    {
        if(status === 0)
        {
            testPage.testComboBox.enabled = false;
            testBtnName = qsTr("Cancel");
            switch(testPage.testComboBoxIndex)
            {
            case 0:

                break;
            case 1:

                break;
            case 2:

                break;
            }
        }
        else if(status === 1)
        {
            testPage.testComboBox.enabled = true;
            testPage.testBtn.enabled = true;
            switch(testPage.testComboBoxIndex)
            {
            case 0:
                testBtnName = qsTr("Test");
                break;
            case 1:
                testBtnName = qsTr("Volience upgrade");
                break;
            case 2:
                testBtnName = qsTr("Continuous restart");
                break;
            }
        }

    }

    function setUpgradeButtonText(text) {
        updatePage.updateButton.text = text;
    }

    function setUpgradeButtonEnable(enable) {
        updatePage.updateButton.enabled = enable;
    }

    function setUpgrading(u){
        if(currenttab === mTAB_Upgrade || (currenttab === mTAB_Test && !testPage.testBtn.checked))
        {

            console.log("11111111111111111111111111111111111111111111111 u = " + u ? 1 : 0);
            updatingFw = u;
        }

    }
    function setTesting(u){
        testingFw = u;
    }
    function autoTestConnect(){
        if(currenttab === mTAB_Test)
        {
            if(testingFw)
            {
                return;
            }
            testBtn.checked  = true;
            onboardTest.midRecttextString = "";
            isSupportOnboardtest = false;
            onboardTest.visible = false;
            testPage.testComboBox.enabled = false;
            testBtnName = qsTr("Cancel");
            switch(testPage.testComboBoxIndex)
            {
            case 0:

                break;
            case 1:

                break;
            case 1:

                break;
            }
            mainPage.sendDestroyDialog();
            touch.setTestThreadToStop(false);
            touch.startTest();
        }


    }
    function clearTestInfo()
    {
        if(currenttab === mTAB_Test)
        {
            testProgressBar.value = 0;
            touch.cancelTest(true);
            mainPage.sendDestroyDialog();
            touch.setTestThreadToStop(true);
            isSupportOnboardtest = false;
            onboardTest.visible = false;
        }

    }
    function showUpgradePage() {

    }

    function showTestPage() {
    }


    signal agingFinished(int index);
    signal stopAgingTest();
    signal startAgingTest();

    function refreshSettings() {
        if (settingsTabId.settingsPage != null)
            settingsTabId.settingsPage.refreshSettings();
        if (calibrationUi.visible && !calibrationFirst) {
            calibrationUi.exitPanel();
        }
        calibrationFirst = false
    }
    property bool calibrationFirst: false
    function calibration() {
        if (settingsTabId.settingsPage != null) {
            calibrationFirst = true
            calibrationUi.visible = true;
            lastVisibility = mainPage.visibility;
            showFullScreen();
        }
            //settingsTabId.enterCalibration()
            //settingsTabId.settingsPage.clickCalibration();
    }

    function startAging() {

        agingPage.startAging();
    }
    function stopAging() {
        agingPage.stopAging();

    }
    function setDeviceStatus(dev, status) {
        agingPage.setDeviceStatus(dev, status);
    }

    property int appType: -1
    function setAppType(type) {
        appType = type;
    }
    onAppTypeChanged: {
        console.log("type:" + appType);
        switch (appType) {
        case mAPP_Client:
            mainTabView.removeTab(3);
            updatePage.lockIcon.visible = false;
//            mainTabView.removeTab(1);
//            mainTabView.removeTab(1);
//            mainTabView.removeTab(1);
//            mainTabView.removeTab(1);
//            mainTabView.removeTab(1);

            break;
        case mAPP_PCBA:
            mainTabView.removeTab(3);
            break;
        case mAPP_Factory:
//            mainTabView.removeTab(5);
            break;
        case mAPP_RD:
            break;
        }
    }

    onHeightChanged: {
        windowHeight = height;
//        testChartPage.scrollHeight = height - 170;
//        testChartPage.height = height - 100;
        if(isSupportOnboardtest)
            onboardTest.refreshCanvas();

    }
    onWidthChanged: {
        windowWidth = width;
//        testChartPage.scrollWidth = width;
//        testChartPage.width = width;
        if(isSupportOnboardtest)
            onboardTest.refreshCanvas();
    }

    //    Timer{
    //        id: refreshTimer
    //        interval: 150
    //        repeat: true
    //        running: true
    //        triggeredOnStart: true
    //        property int xxx: 1
    //        onTriggered: {
    //            appendText("xxx" + xxx + "\n");
    //            xxx++;
    //        }
    //    }

    property var toaskInfo: ""
    function showToast(info) {
        toask.opacity = 1;
        toaskInfo = info;
    }
    Rectangle {
        id: toask
        color: "#00ff00"
        visible: true
        radius: 4
        opacity: 0
        Behavior on opacity {
            PropertyAnimation{ duration : 500 }
        }
        onOpacityChanged: {
            if (opacity === 1) {
                delay(2000, function() {
                    opacity = 0;
                })
            }
        }
        Rectangle {
            width: toaskLabel.paintedWidth + toaskLabel.rightPadding * 2
            height: toaskLabel.height
            border.width: 0
            color: "#263238"
            radius: 4
            anchors.centerIn: parent

            Cont2.Label {
                id: toaskLabel
                padding: 20
                color: "#FFFFFF";
                text: toaskInfo
                font.pointSize: 12
                anchors.centerIn: parent
            }

        }

        anchors.centerIn: parent
    }
    Timer {
        id: timer
    }

    function delay(delayTime, cb) {
        timer.interval = delayTime;
        timer.repeat = false;
        timer.triggered.connect(cb);
        timer.start();
    }

    function onHotplug(plugin) {

        infoTab.refreshInfo();
        var _deviceMainInfo = touch.getDeviceMainInfo();
        if(_deviceMainInfo.localeCompare("No connected devices!") === 0)
        {
            deviceMainInfo = qsTr("No connected devices!");
            deviceConnectImage = "qrc:/dialog/images/error.png";
        }
        else
        {
            deviceMainInfo = _deviceMainInfo;
            deviceConnectImage = "qrc:/dialog/images/success.png";
        }

        if (plugin) {
            deviceCount++;
            if(deviceCount == 1)
            {
              signalPageTab.firstDeviceConnect = true;

            }
            if(testChartPage.selectedSignalCount === 0 && signalPageTab.firstDeviceConnect && mainTabView.currentIndex == mTAB_Signal)
            {
                signalPageTab.firstDeviceConnect = false;
                startSignalChart(false);
                testChartPage.setSignalItems(defaultTestItems);
                console.log("testChartPage.setSignalItems(defaultTestItems) is ok");
            }
        }

        if (!plugin) {
            if (testChartPage !== null) {
//                console.log("onHotplug @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@")
                testChartPage.saveNumbers();
                testChartPage.clearAndRefreshItems();
                testChartPage.stopAutoRefresh();
                touch.stopGetSignalDataBg();
                //            testChartPage.refreshItems(true);
            }
        }
        if (mainTabView.getTab(mainTabView.currentIndex).what === mTAB_Signal  && signalPageTab.visible && plugin && testChartPage !== null) {
            console.log("start signal chart");
            testChartPage.clearModels();
            startSignalChart(true);
            testChartPage.restoreNumbers();
        }





    }

    function startSignalChart(force) {

        var da = {};
        da.setTest = setTest ? 1 : 0;
        touch.enterSignalMode(da);
        testChartPage.refreshItems(force);
        if (testChartPage.currentStatus) {
            signalPageTab.disableCoords();
        }
        testChartPage.needRestoreStatus = testChartPage.currentStatus;

        if (testChartPage.stopRefresh === false) {
            touch.startGetSignalDataBg(1);
            testChartPage.startAutoRefresh();
        }
    }

    function setDeviceInfo(info) {
//        deviceInfoString = info;
    }
    function newRunner() {
        touch.debug("new runner");
        requestActivate();
        showMinimized();
        showMaximized();
        raise();
    }


    DrawPanel {
        anchors.fill: parent
        id: drawPanel
        visible: false

        onVisibleChanged: {
            if (visible) {
                lastVisibility = mainPage.visibility;
                anchors.topMargin = 0;
                showFullScreen();
            }
        }

        onWidthChanged: repaintPath();
        onHeightChanged: repaintPath();

        onExit: {
            if (anchors.topMargin === 0) {
                mainPage.visibility = lastVisibility;
                anchors.topMargin = 50;
            }
            visible = true;
            mainTabView.tabsVisible = true;
        }
    }



    ListModel {
        id: calibrationDataModel
    }


    Component.onCompleted: {
        showUpgradePage();
        var i;
        for (i = 0; i < calibrationUi.calibratePoints; i++) {
            calibrationDataModel.append({
                index: i,
                targetX: 0,
                targetY: 0,
                collectX: 0,
                collectY: 0,
                maxX: Screen.width,
                maxY: Screen.height
            });
        }
    }
    property var lastVisibility: visibility
    function readFile(fileUrl) {
        var request = new XMLHttpRequest();
        request.open("GET", fileUrl, false);
        request.send(null);
        return request.responseText;
    }
    function saveFile(fileUrl, text) {
        var request = new XMLHttpRequest();
        request.open("PUT", fileUrl, false);
        request.send(text);
        return request.status;
    }

    function createCalibrationData() {
        var points = [];
        var model;
        var i;
        for (i = 0; i < calibrationDataModel.count; i++) {
            model = calibrationDataModel.get(i);
            points[i] = {
                index: model.index,
                targetX: model.targetX,
                targetY: model.targetY,
                collectX: model.collectX,
                collectY: model.collectY,
                maxX: model.maxX,
                maxY: model.maxY
            }
        }
        return {count: calibrationDataModel.count, points: points,};
    }

    function saveCalibrationData(file) {

        showProgessing();
        var calJson = JSON.stringify(createCalibrationData());
        touch.debug(calJson);
        saveFile(file, "" + calJson);

        hideProgessing();
        showToast(qsTr("Saved successfully"));
    }

    function resetCalibrationData(){
        var datas = touch.getCalibrationDatas(2);
        touch.debug(JSON.stringify(datas));
        if (datas.count === undefined || datas.count <= 0)
            return;
        var i;
        var points = datas.points;
        calibrationDataModel.clear();
        for (i = 0; i < datas.count; i++) {
            var point = points[i];
            calibrationDataModel.append({
                                            index: point.index,
                                            targetX: point.targetX,
                                            targetY: point.targetY,
                                            collectX: point.collectX,
                                            collectY: point.collectY,
                                            maxX: point.maxX,
                                            maxY: point.maxY
                                        });
        }
        touch.setCalibrationDatas(datas);
    }

    function refreshCalibrationData(){
        var datas = touch.getCalibrationDatas(1);
        touch.debug(JSON.stringify(datas));
        if (datas.count === undefined || datas.count <= 0)
            return;
        calibrationUi.calibratePoints = datas.count;
        calibrateMode = datas.mode;
        calibrationPoints = datas.count;
        var i;
        var points = datas.points;
        calibrationDataModel.clear();
        for (i = 0; i < datas.count; i++) {
            var point = points[i];
            calibrationDataModel.append({
                                            index: point.index,
                                            targetX: point.targetX,
                                            targetY: point.targetY,
                                            collectX: point.collectX,
                                            collectY: point.collectY,
                                            maxX: point.maxX,
                                            maxY: point.maxY
                                        });
        }
    }

    function loadCalibrationData(file) {
        showProgessing();
        var xhr = new XMLHttpRequest();
        xhr.open("GET",file,true);
        xhr.onreadystatechange = function() {
            if ( xhr.readyState == xhr.DONE) {
                if ( xhr.status == 200) {
                    var jsonObject = JSON.parse(xhr.responseText);
                    var model;
                    var i;
                    var points = jsonObject.points;
                    touch.debug("load cali:" + xhr.responseText);
                    calibrationDataModel.clear();
                    for (i = 0; i < jsonObject.count; i++) {
                        var point = points[i];
                        calibrationDataModel.append({
                            index: point.index,
                            targetX: point.targetX,
                            targetY: point.targetY,
                            collectX: point.collectX,
                            collectY: point.collectY,
                            maxX: point.maxX,
                            maxY: point.maxY
                        });
                    }
                }
            }
            hideProgessing();
        }
        xhr.send();
    }

    function showProgessing() {
        progressing.visible = true;
    }
    function hideProgessing() {
        progressing.visible = false;
    }

    Rectangle {
        id: progressing
        anchors.fill: parent
        visible: false
        color: "#00000000"
        Cont2.ProgressBar {
            width: 200
            height: 30
            anchors.centerIn: parent

            indeterminate: true
        }
    }

    DropArea {
        id: dropArea;
        anchors.fill: parent;
        keys: ['application/x-qt-windows-mime;value="FileNameW"']
        onEntered: {
            if (drag.hasUrls) {
                drag.accept(Qt.LinkAction);
            }
        }
        onDropped: {
            if (drop.hasUrls) {
//                console.log(drop.urls[0])
                setUpgradeFile(drop.urls[0]);
            }
        }
        onExited: {
//            console.log ("onExited");
        }
    }

    onClosing: {

        if (!updatePage.updateButton.enabled || updatingFw) {

            showToast(qsTr("Upgrading! Please do not close the program"));
            close.accepted = false;
        }
       else if (testPage != null && testPage.testBtn != null && !testPage.testBtn.enabled) {
           showToast(qsTr("Testing! Please do not close the program"));
           close.accepted = false;
       }

        if(currenttab === mTAB_Signal)
        {
            testChartPage.stopAutoRefresh();
            touch.stopGetSignalDataBg();
            if (testChartPage.needRestoreStatus) {
                restoreCoords();
            }
        }

        if (close.accepted) {
            setWindowHidden(false);
            close.accepted = false;
        }
    }

    function setAgingTime(time) {
        passAgingTime = time;
//        agingPage.passAgingTime = time;
    }
    function onboardTestFinish(title,message,type)
    {

    }
    function onboardShowDialog(title,message,type)
    {
//        mainPage.sendOnboardTestShowDialog(title,message,type);
    }
    function refreshOnboardTestData(map)
    {
        mainPage.sendRefreshOnboardTestData(map);
    }
    function setCurrentIndex(index)
    {
        if(index !== mTAB_Upgrade && touch.isUpgrading())
        {
            showToast(qsTr("During upgrade,don't switch infterface"));
            return;
        }
        if(index !== mTAB_Test && touch.isTesting())
        {
            showToast(qsTr("During test,don't switch infterface"));
            return;
        }
        if(calibrationUi.visible)
        {
           exitCalibrate();
        }
        if(mAPP_Client === touch.getAppType())
        {
            if(index === 3)
                index = 0;
            if(index > 3)
                index--;
        }
        mainTabView.currentIndex = index;
    }

    function setWindowHidden(visibled)
    {
        if(mainPage.visible && visibled)
        {
            return;
        }
        mainPage.setVisible(visibled);
        if(visibled)
        {
            mainPage.visibility =  Window.Maximized;
            if(currenttab === mTAB_Signal)
            {
                startSignalChart(false);
                if (testChartPage.getSelectedCount() === 0 && defaultTestItems !== undefined && firstDeviceConnect) {
//                        if (testChartPage.getSelectedCount() === 0 && deviceCount == 1 &&  defaultTestItems !== undefined && firstDeviceConnect) {
                    firstDeviceConnect = false;
                    testChartPage.setSignalItems(defaultTestItems);
                    console.log("defaultTestItems is ok");
                } else {
                    testChartPage.restoreNumbers();
                }
            }
        }

    }
    //界面跳转
    /*
    * 设置界面:         0
    * 校准界面:         1
    * 微调校准数据界面:   2
    * 边缘拉伸界面：     3
    */
    property int settingsPage:      0
    property int calibrationPage:   1
    property int fineTunePage:      2
    property int edgeStrechPage:    3
    //跳转的界面
    property int enterInterface:0

     function enterCalibrate()
     {
         if(touch.isUpgrading())
         {
             showToast(qsTr("During upgrade,don't switch infterface"));
             return;
         }
         if(touch.isTesting())
         {
             showToast(qsTr("During test,don't switch infterface"));
             return;
         }
         if(!mainPage.visible)
         {
             setWindowHidden(true);
         }
         if(mainTabView.currentIndex != mTAB_Settings)
         {
             mainTabView.currentIndex = mTAB_Settings;
         }
         if(!calibrationUi.visible)
         {
             calibrationUi.visible = true;
             lastVisibility = mainPage.visibility;
             settingsTabId.visible = false;
             enterInterface = calibrationPage;
             showFullScreen();
         }

     }
     function exitCalibrate(){
         calibrationUi.focus = false;
         calibrationUi.visible = false;
         settingsTabId.visible = true;
         mainPage.visibility = lastVisibility;
         settingsTabId.settingsPage.focus = true;
         enterInterface = settingsPage;

     }
     //微调
     function enterFineTune(){
         fineTune.visible = true;
         lastVisibility = mainPage.visibility;
         showFullScreen();
         settingsTabId.visible = false;
         enterInterface = fineTunePage;
     }
     function exitFineTune(){
         fineTune.focus = false;
         fineTune.visible = false;
         mainPage.visibility = lastVisibility;
         settingsTabId.visible = true;
         settingsTabId.settingsPage.focus = true;
         enterInterface = settingsPage;
     }

     //边缘拉伸

     function enterEdgeStrech(){
         edgeStrech.visible = true;
         lastVisibility = mainPage.visibility;
         showFullScreen();
         settingsTabId.visible = false;
         enterInterface = edgeStrechPage;
     }
     function exitEdgeStrech(){
         touch.setCancelEdgeStrech(true);
         edgeStrech.focus = false;
         edgeStrech.visible = false;
         mainPage.visibility = lastVisibility;
         settingsTabId.visible = true;
         settingsTabId.settingsPage.focus = true;
         enterInterface = edgeStrechPage;
         settingsTabId.settingsPage.settingConfigurationPage.getEdgeStrechVal(0);

     }
     function edgeStrechFinish(activityEdge)
     {
         edgeStrech.getEdgeStrechVal();
         edgeStrech.setNextActivityEdge(true);
     }
     function refreshEdgeStrechProgress(map)
     {
         edgeStrech.refreshEdgeStrechProgress(map);
     }

     //批处理
     function initBatchDeviceInfo()
     {

         batchConnectDeviceInfoList.length = 0;
         var connectDeviceInfo = touch.getConnectDeviceInfo();
         console.log("############# qml count = " + connectDeviceInfo['count']);
         if(connectDeviceInfo['count'] > 0)
         {
             var deviceInfoList = connectDeviceInfo['deviceInfoList'];
            //  console.log("############# qml deviceInfoList.length = " + deviceInfoList.length);
             for(var i = 0;i < deviceInfoList.length;i++)
             {
                 var saveDeviceInfo;
                 var conDeviceInfo = deviceInfoList[i];
                 saveDeviceInfo = {"number":i,"deviceStatus":conDeviceInfo['deviceStatus'],"mcuID":conDeviceInfo['mcuID']};
                 agingPage.setDeviceStatus(i,conDeviceInfo['deviceStatus']);
                 agingPage.setDeviceMcdId(i,conDeviceInfo['mcuID']);
                 agingPage.setDeviceInfo(i,"");
                 agingPage.setDeviceProgress(i,0);
                 agingPage.setDeviceResult(i,0);
                 agingPage.setDeviceTime(i,agingPage.passAgingTime);
                 agingPage.setDeviceBootloader(i,conDeviceInfo['bootloader']);
//                console.log("############# qml deviceConnectIndex = " + i +",deviceStatus = "+conDeviceInfo['deviceStatus'] + ",mcuid = " + conDeviceInfo['mcuID']);
                 batchConnectDeviceInfoList.push(saveDeviceInfo);
             }
         }
    }
     Timer
     {
         id:refreshBatchInfoTimer
         interval: 16
         repeat: true
         running: false
         triggeredOnStart: false
         onTriggered: {
             batchRefreshUpgradeInfo();
         }
     }
     function batchRefreshUpgradeInfo()
     {
         var datas = touch.getBatchUpgradeData();
         if(datas["result"] === 0)
         {
             return;
         }
         var dataList = datas["batchUpgradeInfoList"];
         for(var i = 0; i < dataList.length;i++)
         {
             var curInfo = dataList[i];
             agingPage.setDeviceProgress(curInfo["index"],curInfo["progress"]);
//             console.log("batchRefreshUpgradeInfo: index = " + curInfo["index"] + ",progress = " + curInfo["progress"]);
         }

     }

     function refreshBatchDeviceInfo()
     {
         var curDeciceInfoMap = touch.getConnectDeviceInfo();
         if(curDeciceInfoMap['count'] <= 0)
         {
             console.log("连接设备个数为 0 ");
             for(var n = 0; n < batchConnectDeviceInfoList.length;n++)
             {
                 agingPage.setDeviceStatus(n,agingPage.deviceDisconnected);
                 batchConnectDeviceInfoList[n].deviceStatus = agingPage.deviceDisconnected;
             }

             return;
         }
         //判断设备的当前状态
         var sameDevice = false;
         var deviceInfoList = curDeciceInfoMap['deviceInfoList'];
         for(var i = 0 ; i < deviceInfoList.length;i++)
         {
             sameDevice = false;
             var curDevice = deviceInfoList[i];
             //===============================================
             for(var j = 0;j < batchConnectDeviceInfoList.length;j++)
             {
                 if(curDevice['mcuID'] === agingPage.getDeviceMcdId(j))
                 {
                     sameDevice = true;
                     break;
                 }
             }
             if(sameDevice)
             {
                 var beforeDevice = batchConnectDeviceInfoList[i];
                 beforeDevice.deviceStatus = curDevice['deviceStatus'];
                 agingPage.setDeviceStatus(j,curDevice['deviceStatus']);

             }
             else
             {
                 if(curDevice['mcuID'] === "")
                     continue;
                 var saveDeviceInfo;
                 console.log("batchConnectDeviceInfoList.length = " + batchConnectDeviceInfoList.length);
                 saveDeviceInfo = {"number":batchConnectDeviceInfoList.length,"deviceStatus":curDevice['deviceStatus'],"mcuID":curDevice['mcuID']};
                 agingPage.setDeviceStatus(batchConnectDeviceInfoList.length,curDevice['deviceStatus']);
                 agingPage.setDeviceMcdId(batchConnectDeviceInfoList.length,curDevice['mcuID']);
                 agingPage.setDeviceInfo(batchConnectDeviceInfoList.length,"");
                 agingPage.setDeviceProgress(batchConnectDeviceInfoList.length,0);
                 agingPage.setDeviceBootloader(batchConnectDeviceInfoList.length,curDevice['bootloader']);
                 agingPage.setDeviceTime(batchConnectDeviceInfoList.length,agingPage.passAgingTime);
                 agingPage.setDeviceResult(batchConnectDeviceInfoList.length,0);
                 batchConnectDeviceInfoList.push(saveDeviceInfo);

             }

         }

     }
     function addBatchDevice(deviceMap)
     {
         var saveDeviceInfo;

         saveDeviceInfo = {"number":batchConnectDeviceInfoList.length,"deviceStatus":deviceMap['deviceStatus'],"mcuID":deviceMap['mcuID']};
         agingPage.setDeviceStatus(batchConnectDeviceInfoList.length,deviceMap['deviceStatus']);
         agingPage.setDeviceMcdId(batchConnectDeviceInfoList.length,deviceMap['mcuID']);
         agingPage.setDeviceInfo(batchConnectDeviceInfoList.length,"");
         agingPage.setDeviceProgress(batchConnectDeviceInfoList.length,0);
         agingPage.setDeviceBootloader(batchConnectDeviceInfoList.length,deviceMap['bootloader']);
         agingPage.setDeviceTime(batchConnectDeviceInfoList.length,agingPage.passAgingTime);
         agingPage.setDeviceResult(batchConnectDeviceInfoList.length,0);
         batchConnectDeviceInfoList.push(saveDeviceInfo);

     }


     function startBatchTest(index)
     {
         touch.startBatchTest(index);
     }
     function refreshBatchStatus(index,status)
     {
         agingPage.setDeviceStatus(index,status);
     }
     function refreshBatchProgress(index,progress)
     {
         agingPage.setDeviceProgress(index,progress);
     }
     function refreshBatchInfo(index,info)
     {
         agingPage.setDeviceInfo(index,info);
     }

     function startBatchUpgrade()
     {
         touch.startBatchUpgrade(agingPageTab.batchUpgradeFileText.text);
     }
     function refreshBatchResult(dev,result)
     {
         agingPage.setDeviceResult(dev,result);
     }
     function setBatchCancel(batchCancel)
     {
         touch.setBatchCancel(batchCancel);
     }

     function currentTabRefresh(currenttab)
     {
         if(touch.getAppType() === mAPP_Client)
         {
             if(currenttab > 2)
                currenttab += 1;
         }
        touch.currentTabRefresh(currenttab);
     }



}
