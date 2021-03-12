import QtQuick 2.0
import QtQuick.Controls 1.4 as Cont1
import QtQuick.Controls 1.2
import QtQuick.Controls 2.0
import QtQuick.Controls.Styles 1.4
import QtQuick.Layouts 1.3
Item {
    property int  defaultSpacing: 10
    property int labelWidth:250

    property var usbModeEnabledBox:usbModeEnabledBox
    property var usbModeGroup:usbModeGroup
    property var serialModeGroup:serialModeGroup
    property var usbMode:usbMode
    property var usbModeMouse:usbModeMouse
    property var usbModeTouch:usbModeTouch
    property var serialModeGG:serialModeGG
    property var serialModeEnabledBox:serialModeEnabledBox

    property var usbCheckBoxMouse:usbCheckBoxMouse


    ScrollView{
        anchors.fill: parent
        horizontalScrollBarPolicy: Qt.ScrollBarAlwaysOn

        ColumnLayout{
            ButtonGroup {
                id: usbModeGroup
                onCheckedButtonChanged: {
                    console.log("usb mode:"+checkedButton.mode)
                    if (refreshing) return;
                    touch.setSettings("usbMode", checkedButton.mode);
                }
            }
            RowLayout {
                spacing: defaultSpacing
                id: usbMode
                Image {
                    id: usbIcon;
                    visible: true
                    Layout.preferredHeight: parent.implicitHeight / 5.0 * 4
                    Layout.preferredWidth: parent.implicitHeight  / 5.0 * 4
    //                height: parent.implicitHeight / 5.0 * 4
    //                width: parent.implicitHeight  / 5.0 * 4
                    fillMode: Image.PreserveAspectFit
                    source: "qrc:/dialog/images/usb.png";
                }
                Label {
                    id: labelView
                    text: qsTr("usb coordinate mode") + "(1)"
                    Layout.preferredHeight:parent.implicitHeight
                    Layout.preferredWidth: labelWidth
                    verticalAlignment: Text.AlignVCenter
                    font.pointSize: 14
                }

                CheckBox {
                    id: usbModeEnabledBox
                    MouseArea{
                        id:usbCheckBoxMouse
                        anchors.fill: parent
                        hoverEnabled: true
                        onEntered: {
                            mouseAreaWhat = 0;
                            coordsTimer.restart();
                        }
                        onExited: {
                            coordsTimer.stop();
                            usbChannelTooltip.visible = false;
                        }
                        onClicked: {
                            usbModeEnabledBox.checked = !usbModeEnabledBox.checked;
                        }
                    }
                    onCheckedChanged: {
                        usbModeMouse.enabled = checked;
                        usbModeTouch.enabled = ((winVersion === undefined || winVersion !== winXPVersion) ? checked : false)
                        var str = checked?"设置 checked = true":"设置 checked = false";
                        touch.tPrintf(str);
                        touch.setCoordsEnabled(1, checked ? 1: 0);
                    }
                }

                RadioButton {
                    id: usbModeMouse
                    text: qsTr("simulate mouse")
                    font.pointSize: 14
                    ButtonGroup.group: usbModeGroup
                    property int mode: 1
                    MouseArea{
                        id:usbModeMouseMouse
                        anchors.fill: parent
                        hoverEnabled: true
                        onEntered: {
                            mouseAreaWhat = 1;
                            coordsTimer.restart();
                        }
                        onExited: {
                            coordsTimer.stop();
                            simulateMouseTooltip.visible = false;
                        }
                        onClicked: {
                            usbModeMouse.checked = true;
                        }
                    }
                }
                RadioButton {
                    id: usbModeTouch
                    property int mode: 2
                    text: qsTr("multitouch")
                    font.pointSize: 14
                    ButtonGroup.group: usbModeGroup
                    //enabled: ((winVersion === undefined || winVersion !== winXPVersion) ? true : false);
                    MouseArea{
                        id:usbModeTouchMouse
                        anchors.fill: parent
                        hoverEnabled: true
                        onEntered: {
                            mouseAreaWhat = 2;
                            coordsTimer.restart();

                        }
                        onExited: {
                            coordsTimer.stop();
                            usbModeTouchTooltip.visible = false;
                        }
                        onClicked: {
                            usbModeTouch.checked = true;
                        }
                    }
                }
            }
            ButtonGroup {
                id: serialModeGroup
                onCheckedButtonChanged: {
                    console.log("serial mode:" + checkedButton.mode)
                    if (refreshing) return;
                    touch.setSettings("serialMode", checkedButton.mode);
                }
            }
            RowLayout {
                spacing: defaultSpacing
                id: serialModeGG
                anchors.top: usbMode.bottom
                anchors.topMargin: defaultSpacing
                Image {
                    id: uartIcon;
                    visible: true
                    Layout.preferredHeight:parent.implicitHeight / 5.0 * 4
                    Layout.preferredWidth: parent.implicitHeight  / 5.0 * 4
    //                height: parent.implicitHeight / 5.0 * 4
    //                width: parent.implicitHeight  / 5.0 * 4
                    fillMode: Image.PreserveAspectFit
                    source: "qrc:/dialog/images/serial.png";
                }
                Label {
                    text: qsTr("uart coordinate mode") + "(2)"
                    Layout.preferredHeight:parent.implicitHeight
                    Layout.preferredWidth: labelWidth
    //                height: parent.implicitHeight
    //                width:labelWidth
                    verticalAlignment: Text.AlignVCenter
                    font.pointSize: 14
                }


                CheckBox {
                    id: serialModeEnabledBox
                    MouseArea{
                        id:serialModeMouse
                        anchors.fill: parent
                        hoverEnabled: true
                        onEntered: {
                            mouseAreaWhat = 3;
                            coordsTimer.restart();

                        }
                        onExited: {
                            coordsTimer.stop();
                            serialModeEnabledBoxTooltip.visible = false;
                        }
                        onClicked: {
                            serialModeEnabledBox.checked = !serialModeEnabledBox.checked;
                        }
                    }
                    onCheckedChanged: {
                        var str = checked?"设置 checked = true":"设置 checked = false";
                        touch.setCoordsEnabled(2, checked ? 1: 0);
                    }
                }
                RadioButton {
                    visible: false
                    text: qsTr("exclude touch size")
                    font.pointSize: 14
                    ButtonGroup.group: serialModeGroup
                    property int mode: 1
                }
                RadioButton {
                    visible: false
                    property int mode: 2
                    text: qsTr("include touch size")
                    font.pointSize: 14
                    checked: true
                    ButtonGroup.group: serialModeGroup
                }
            }
        }
    }
    //鼠标区域默认的值
    // 0 USB坐标模式区域
    // 1 模拟鼠标模式
    // 2 多点触摸模式
    // 3 Serial坐标模式区域
    property int mouseAreaWhat:0
    Timer{
        id:coordsTimer
        running: false
        triggeredOnStart: false
        interval: 1000
        onTriggered: {
            switch(mouseAreaWhat)
            {
            case 0:
                usbChannelTooltip.visible = true;
                break;
            case 1:
                simulateMouseTooltip.visible = true;
                break;
            case 2:
                usbModeTouchTooltip.visible = true;
                break;
            case 3:
                serialModeEnabledBoxTooltip.visible = true;
                break;
            default:
                console.log("coordsTimer is error!");
                break;
            }
        }
    }
    //提示部分
    Rectangle{
        id:usbChannelTooltip
        visible: false
        height: usbChannelText.height + defaultMargin
        width:usbChannelText.width + defaultMargin
        x: usbModeEnabledBox.x + defaultMargin
        y:usbModeEnabledBox.y  + usbModeEnabledBox.height
        border.width: 1
        border.color: "#cccccc"
        Text{
            id:usbChannelText
            text:qsTr("USB coordinate channel switch.")
            font.pointSize: 10
            wrapMode: Text.Wrap
            anchors.centerIn: parent
        }

    }

    Rectangle{
        id:simulateMouseTooltip
        visible: false
        height: simulateMouseText.height + defaultMargin
        width:simulateMouseText.width + defaultMargin
        x: usbModeMouse.x + defaultMargin
        y:usbModeMouse.y  + usbModeMouse.height
        border.width: 1
        border.color: "#cccccc"
        Text{
            id:simulateMouseText
            text:qsTr("Switch to simulated mouse mode.")
            font.pointSize: 10
            wrapMode: Text.Wrap
            anchors.centerIn: parent
        }
    }
    Rectangle{
        id:usbModeTouchTooltip
        visible: false
        height: usbModeTouchText.height + defaultMargin
        width:usbModeTouchText.width + defaultMargin
        x: usbModeTouch.x + defaultMargin
        y:usbModeTouch.y  + usbModeMouse.height
        border.width: 1
        border.color: "#cccccc"
        Text{
            id:usbModeTouchText
//            width: 400
            text:qsTr("Switch to multi-touch mode.It will take effect when the device supports multi-touch.")
            font.pointSize: 10
            wrapMode: Text.Wrap
            anchors.centerIn: parent
        }

    }

    Rectangle{
        id:serialModeEnabledBoxTooltip
        visible: false
        height: serialModeEnabledBoxText.height + defaultMargin
        width:serialModeEnabledBoxText.width + defaultMargin
        x: serialModeEnabledBox.x + defaultMargin
        y:serialModeGG.y  + serialModeGG.height
        border.width: 1
        border.color: "#cccccc"
        Text{
            id:serialModeEnabledBoxText
            text:qsTr("Serial coordinate channel switch.")
            font.pointSize: 10
            wrapMode: Text.Wrap
            anchors.centerIn: parent
        }

    }

}
