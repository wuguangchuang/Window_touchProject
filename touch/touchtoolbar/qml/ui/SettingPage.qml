import QtQuick 2.0

import QtQuick.Controls 2.0
import QtQuick.Layouts 1.3
import QtQuick.Controls 1.4
import QtQuick.Controls.Styles 1.4
import QtQuick.Dialogs 1.2



Item{

    property int defaultSpacing: 10
    property int labelSize: 25
    property var mSettings: []
    property var refreshing: true



    property bool updateSettings: false
//    signal clickCalibration();

    //坐标页面
    property var usbModeEnabledBox:settingCoordsPage.usbModeEnabledBox
    property var usbModeGroup:settingCoordsPage.usbModeGroup
    property var serialModeGroup:settingCoordsPage.serialModeGroup
    property var usbMode:settingCoordsPage.usbMode
    property var usbModeMouse:settingCoordsPage.usbModeMouse
    property var usbModeTouch:settingCoordsPage.usbModeTouch
    property var serialModeGG:settingCoordsPage.serialModeGG
    property var serialModeEnabledBox:settingCoordsPage.serialModeEnabledBox

    //旋转页面
    property var xMirrorCheckBox:settingSpinPage.xMirrorCheckBox
    property var yMirrorCheckBox:settingSpinPage.yMirrorCheckBox
    property var touchRotationGroup:settingSpinPage.touchRotationGroup
    property var screenRotationGroup:settingSpinPage.screenRotationGroup

    //校准界面
    property var calibrationList:settingCalibratePage.calibrationList
    property var calibrationButtonRow:settingCalibratePage.calibrationButtonRow
    property var caliDataModel: settingCalibratePage.caliDataModel

    //可配置参数界面


    id: root
    focus: true
    Keys.enabled: true
    Keys.onPressed: {

        if(mainPage.enterInterface === mainPage.calibrationPage)
        {
            calibrationUi.onPressed(event);
        }
        else if(mainPage.enterInterface === mainPage.fineTunePage)
        {
            fineTune.onPressed(event);
        }
        else
        {
            switch (event.key)
            {
            case Qt.Key_1:
                if (usbModeEnabledBox.checked) {
                    if (usbModeMouse.checked) {
                        usbModeMouse.checked = false;
                        usbModeTouch.checked = true;
                    } else {
                        usbModeMouse.checked = true;
                        usbModeTouch.checked = false;
                        usbModeEnabledBox.checked = false;
                    }
                } else {
                    usbModeEnabledBox.checked = true;
                }

                break;

            case Qt.Key_2:
                serialModeEnabledBox.checked = !serialModeEnabledBox.checked;

                break;

            case Qt.Key_3:
                if (!xMirrorCheckBox.checked && !yMirrorCheckBox.checked) {
                    xMirrorCheckBox.checked = true;
                } else if (xMirrorCheckBox.checked && !yMirrorCheckBox.checked) {
                    yMirrorCheckBox.checked = true;
                } else if (xMirrorCheckBox.checked && yMirrorCheckBox.checked) {
                    xMirrorCheckBox.checked = false;
                } else {
                    xMirrorCheckBox.checked = yMirrorCheckBox.checked = false;
                }

                break;
            case Qt.Key_4:

                var count = touchRotationGroup.buttons.length;
                var button = touchRotationGroup.checkedButton;
    //            console.log("count=" + count + " mode=" + button.mode);
                button.checked = false;
                var nextMode = button.mode + 1;
                if (button.mode === (count - 1)) {
                    nextMode = 0;
                }
                for (var index = 0; index < count; index++) {
                    if (nextMode === touchRotationGroup.buttons[index].mode) {
                        touchRotationGroup.buttons[index].checked = true;
                        break;
                    }
                }

                break;
            case Qt.Key_5:
                count = screenRotationGroup.buttons.length;
                button = screenRotationGroup.checkedButton;
    //            console.log("count=" + count + " mode=" + button.mode);
                button.checked = false;
                nextMode = button.mode + 1;
                if (button.mode === (count - 1)) {
                    nextMode = 0;
                }
                for (index = 0; index < count; index++) {
                    if (nextMode === screenRotationGroup.buttons[index].mode) {
                        screenRotationGroup.buttons[index].checked = true;
                        break;
                    }
                }

                break;
    //        case Qt.Key_6:
    //            count = macOsGroup.buttons.length;
    //            button = macOsGroup.checkedButton;
    ////            console.log("count=" + count + " mode=" + button.mode);
    //            button.checked = false;
    //            nextMode = button.mode + 1;
    //            if (button.mode === (count - 1)) {
    //                nextMode = 0;
    //            }
    //            for (var index = 0; index < count; index++) {
    //                if (nextMode === macOsGroup.buttons[index].mode) {
    //                    macOsGroup.buttons[index].checked = true;
    //                    break;
    //                }
    //            }

    //            break;

            }
        }

    }



    property bool systemScreenDirection:false
    property var dirention:0
    function refreshSettings() {
        console.log("refresh settings")
        refreshing = true;
        var settings = touch.getSettingsInfos();
        var enables = true;
        var buttons;
        var btn;
        var i;
        if (settings.usbMode !== undefined && settings.usbMode !== -1) {
            for (i = 0; i < usbModeGroup.buttons.length; i++) {
                btn = usbModeGroup.buttons[i];
                if (btn.mode === settings.usbMode) {
                    btn.checked = true;
                    break;
                }
            }
            enables = true;
        } else {
            enables = false;
        }

        buttons = usbModeGroup.buttons;
        for ( i = 0; i < buttons.length; i++) {
            buttons[i].enabled = enables;
            if (enables === false) {
                buttons[i].checked = false;
            }
        }

        enables = true;
        if (settings.serialMode !== undefined && settings.serialMode !== -1) {
            for ( i = 0; i < serialModeGroup.buttons.length; i++) {
                btn = serialModeGroup.buttons[i];
                if (btn.mode === settings.serialMode) {
                    btn.checked = true;
                    break;
                }
            }
            enables = true;
        } else {
            enables = false;
        }

        buttons = serialModeGroup.buttons;
        for ( i = 0; i < buttons.length; i++) {
            buttons[i].enabled = enables;
            if (enables === false) {
                buttons[i].checked = enables;
            }
        }

        enables = false;
        if (settings.touchRotation !== undefined && settings.touchRotation !== -1) {
            for ( i = 0; i < touchRotationGroup.buttons.length; i++) {
                btn = touchRotationGroup.buttons[i];
                if (btn.mode === settings.touchRotation) {
                    btn.checked = true;
                    break;
                }
            }
            enables = true;
        } else {
            enables = false;
        }
        buttons = touchRotationGroup.buttons;
        for ( i = 0; i < buttons.length; i++) {
            buttons[i].enabled = enables;
            if (enables === false) {
                buttons[i].checked = enables;
            }
        }

        if (settings.screenRotation !== undefined && settings.screenRotation !== -1) {
            for (i = 0; i < screenRotationGroup.buttons.length; i++) {
                btn = screenRotationGroup.buttons[i];
                if (btn.mode === settings.screenRotation) {
                    btn.checked = true;
                    break;
                }
            }
            enables = true;
        } else {
            enables = false;
        }
        buttons = screenRotationGroup.buttons;
        for (i = 0; i < buttons.length; i++) {
            buttons[i].enabled = enables;
            if (enables === false) {
                buttons[i].checked = enables;
            }
        }

        if (settings.xMirror !== undefined && settings.xMirror !== -1) {
            xMirrorCheckBox.checked = settings.xMirror === 1;
            xMirrorCheckBox.enabled = true;
        } else {
            xMirrorCheckBox.enabled = false;
        }

        if (settings.yMirror !== undefined && settings.yMirror !== -1) {
            yMirrorCheckBox.checked = settings.yMirror === 1;
            yMirrorCheckBox.enabled = true;
        } else {
            yMirrorCheckBox.enabled = false;
        }

        enables = true;
//        if (settings.mac !== undefined && settings.mac !== -1) {
//            var mac

//            for (var i = 0; i < macOsGroup.buttons.length; i++) {
//                mac = macOsGroup.buttons[i];
//                if (mac.mode === settings.mac) {
//                    mac.checked = true;
//                    break;
//                }
//            }
//        } else {
//            enables = false;
//        }
//        buttons = macOsGroup.buttons;
//        for (var i = 0; i < buttons.length; i++) {
//            buttons[i].enabled = enables;
//            if (enables === false) {
//                buttons[i].checked = enables;
//            }
//        }

        mSettings = settings;
        refreshing = false;
        var connected = touch.isDeviceConnected();
        calibrationButtonRow.enabled = connected;
        calibrationList.enabled = connected;
        if (connected) {
            refreshCalibrationData();

            usbModeEnabledBox.enabled = true;
            serialModeEnabledBox.enabled = true;
//            console.log('usb === ' + settings.usbEnabled);
//            console.log('serial === ' + settings.serialEnabled);
            usbModeEnabledBox.checked = serialModeEnabledBox.checked = true;
            usbModeEnabledBox.checked = settings.usbEnabled === 1;
            serialModeEnabledBox.checked = settings.serialEnabled === 1;
        } else {
            usbModeEnabledBox.enabled = false;
            serialModeEnabledBox.enabled = false;
        }

//        var lockAGC = settings.lockAGC;
//        updateSettings = true;
//        lockAGCcb.checked = lockAGC === 1;
//        clearUpdate.restart()
        modeSettingPage.refreshModeSetting();

        //只提示一次：判断获取固件屏幕方向是否与当前系统显示方向保持一致
        if(!systemScreenDirection && settings.screenRotation !== undefined && settings.screenRotation !== -1)
        {
            systemScreenDirection = true;
            dirention = touch.getScreenOrientation();
            if(dirention >= 0 && dirention !== settings.screenRotation)
            {
                swipeView.currentIndex = 1;
                systemScreenDirectionMessage.visible = true;
            }
        }

    }
    Timer{
        id: clearUpdate
        interval: 200
        running: false
        triggeredOnStart: false
        onTriggered: {
            updateSettings = false;
        }
    }

//    id:rootSetting
    property int defaultTopMargin:5
    property int listBtnheight:60
    anchors.top: parent.top
//    anchors.topMargin: defaultTopMargin

    //右侧页面
    SwipeView{
        id: swipeView
        anchors.left: rootitem.right
        anchors.top: parent.top
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        currentIndex: 0

        Rectangle{
            //currentIndex === 0 : 设置坐标通道页

//            gradient: Gradient{
//                GradientStop{position: 0.0;color: "#f6f6f6"}
//                GradientStop{position: 1.0;color: "#e3ddf9"}
//            }
            SettingCoordsPage{
                id:settingCoordsPage
                anchors.top: parent.top
                anchors.topMargin: 2 * defaultMargin
                anchors.left: parent.left
                anchors.leftMargin: 3 * defaultMargin
                anchors.fill: parent
            }
        }
        Rectangle{
            //currentIndex === 1 : 设置界面的旋转页

//            gradient: Gradient{
//                GradientStop{position: 0.0;color: "#f6f6f6"}
//                GradientStop{position: 1.0;color: "#e3ddf9"}
//            }
            SettingSpinPage{
                id:settingSpinPage
                anchors.top: parent.top
                anchors.topMargin: 2 * defaultMargin
                anchors.left: parent.left
                anchors.leftMargin: 3 * defaultMargin
                anchors.fill: parent

            }

        }
        Rectangle{
            //currentIndex === 2 : 设置界面的校准页

//            gradient: Gradient{
//                GradientStop{position: 0.0;color: "#f6f6f6"}
//                GradientStop{position: 1.0;color: "#e3ddf9"}
//            }
            SettingCalibratePage{
                id:settingCalibratePage
                anchors.top: parent.top
                anchors.topMargin: 2 * defaultMargin
                anchors.left: parent.left
                anchors.leftMargin: 3 * defaultMargin
                anchors.fill: parent

                onClickCalibration: {
                    mainPage.enterCalibrate();
                }
                onClickFineTune: {
                    mainPage.enterFineTune();
                }
                Component.onCompleted: {
                    settingCalibratePage.caliDataModel = calibrationDataModel;
                }
            }

        }
        Rectangle{
            //currentIndex === 3 : 配置参数页
            SettingConfigurationPage{
                id:settingConfigurationPage
                anchors.top: parent.top
                anchors.topMargin: 2 * defaultMargin
                anchors.left: parent.left
                anchors.leftMargin: 3 * defaultMargin
                anchors.fill: parent

                onEnterEdgeStrech: {
                    mainPage.enterEdgeStrech();
                }
            }
        }
        Rectangle{
            //currentIndex === 4 : 更多设置页
//            gradient: Gradient{
//                GradientStop{position: 0.0;color: "#f6f6f6"}
//                GradientStop{position: 1.0;color: "#e3ddf9"}
//            }
            ModeSetting{
                id:modeSettingPage
                anchors.top: parent.top
                anchors.topMargin: 2 * defaultMargin
                anchors.left: parent.left
                anchors.leftMargin: 3 * defaultMargin
                anchors.fill: parent

            }

        }
        onCurrentIndexChanged: {
            checkBtn = currentIndex;
            switch(currentIndex)
            {
            case 0:
                settingCoordsPage.visible = true;
                settingSpinPage.visible = false;
                settingCalibratePage.visible = false;
                modeSettingPage.visible = false;
                break;
            case 1:
                settingCoordsPage.visible = false;
                settingSpinPage.visible = true;
                settingCalibratePage.visible = false;
                modeSettingPage.visible = false;
                break;
            case 2:
                settingCoordsPage.visible = false;
                settingSpinPage.visible = false;
                settingCalibratePage.visible = true;
                modeSettingPage.visible = false;
                break;
            case 3:
                settingCoordsPage.visible = false;
                settingSpinPage.visible = false;
                settingCalibratePage.visible = false;
                settingConfigurationPage.visible = true
                modeSettingPage.visible = false;
                break;
            case 4:
                settingCoordsPage.visible = false;
                settingSpinPage.visible = false;
                settingCalibratePage.visible = false;
                settingConfigurationPage.visible = false
                modeSettingPage.visible = true;
                break;
            }
        }

    }
    //左侧列表
    property int checkBtn:0
    Rectangle
    {
        id : rootitem
        anchors.left: parent.left

        anchors.top: parent.top

        width: 180
        height: parent.height;
        color: "#dedaef"
        ColumnLayout{
            id : lyout
            width: parent.width
            Layout.fillWidth: true

            SettingMyToolButton{
                id:coordsBtn
                width: parent.width
                Layout.preferredHeight: listBtnheight
                Layout.fillWidth: true
                what:0
                textStr:qsTr("Coordinate")
                onClicked: {
                    swipeView.currentIndex = 0;
                    checkBtn = 0;
                }

            }

            SettingMyToolButton{
                id:spinBtn
                width: parent.width
                Layout.preferredHeight: listBtnheight
                Layout.fillWidth: true
                what:1
                textStr:qsTr("Spin")
                onClicked: {
                    swipeView.currentIndex = 1;
                    checkBtn = 1;
                }

            }

            SettingMyToolButton{
                id:calibrationBtn
                width: parent.width
                Layout.preferredHeight: listBtnheight
                Layout.fillWidth: true
                what:2
                textStr:qsTr("Calibrate")
                onClicked: {
                    swipeView.currentIndex = 2;
                    checkBtn = 2;
                }
            }
            SettingMyToolButton{
                id:configurationBtn
                width: parent.width
                Layout.preferredHeight: listBtnheight
                Layout.fillWidth: true
                what:3
                textStr:qsTr("Configuration")
                onClicked: {
                    swipeView.currentIndex = 3;
                    checkBtn = 3;
                }
            }
            SettingMyToolButton{
                id:modeSetting
                width: parent.width
                Layout.preferredHeight: listBtnheight
                Layout.fillWidth: true
                what:4
                textStr:qsTr("mode")
                onClicked: {
                    swipeView.currentIndex = 4;
                    checkBtn = 4;
                }
            }

        }

    }
    MessageDialog{
        id:systemScreenDirectionMessage
        visible: false
        width: 500
        height: 300
        title: qsTr("System display direction")
        text:qsTr("System display orientation is inconsistent with firmware screen orientation.The current display direction of the system is %1°.\n").arg(dirention * 90) + "\n" +
             qsTr("Is the firmware screen display orientation set to the system display orientation?")
        standardButtons:StandardButton.Yes|StandardButton.No

        onYes: {

            console.log("设置屏幕的显示方向：" + dirention);
            for (var i = 0; i < screenRotationGroup.buttons.length; i++) {
                var btn = screenRotationGroup.buttons[i];
                if (btn.mode === dirention) {
                    btn.checked = true;
                    break;
                }
            }

        }
        onNo: {
            console.log("不设置屏幕的显示方向" );
        }
    }


}


