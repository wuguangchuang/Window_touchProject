import QtQuick 2.0
import QtQuick.Controls 1.4 as Cont1
import QtQuick.Controls 1.2
import QtQuick.Controls 2.0
import QtQuick.Controls.Styles 1.4
import QtQuick.Layouts 1.3

Item {
    property int  defaultSpacing: 10
    property int labelWidth:250

    property var xMirrorCheckBox:xMirrorCheckBox
    property var yMirrorCheckBox:yMirrorCheckBox
    property var touchRotationGroup:touchRotationGroup
    property var screenRotationGroup:screenRotationGroup

    ScrollView{
        anchors.fill: parent
        horizontalScrollBarPolicy: Qt.ScrollBarAlwaysOn

        ColumnLayout{
            RowLayout {
                spacing: defaultSpacing
                id:touchTurnLayout
                Image {
                    id: turnOver;
                    visible: true
                    Layout.preferredHeight:parent.implicitHeight / 5.0 * 4
                    Layout.preferredWidth: parent.implicitHeight  / 5.0 * 4
    //                height: parent.implicitHeight / 5.0 * 4
    //                width: parent.implicitHeight  / 5.0 * 4
                    fillMode: Image.PreserveAspectFit
                    source: "qrc:/dialog/images/touch_rotate.png";
                }
                Label {
                    text: qsTr("turn over") + "(3)"
                    font.pointSize: 14
                    Layout.preferredHeight:defaultSpacing
                    Layout.preferredWidth: labelWidth
    //                width: labelWidth
    //                height: defaultSpacing
                    verticalAlignment: Text.AlignVCenter
                    anchors.verticalCenter: parent.verticalCenter
                }

                CheckBox {
                    text: qsTr("turn over X")
                    font.pointSize: 14
                    id: xMirrorCheckBox
                    anchors.rightMargin: 10
                    onCheckedChanged: {
                        if (refreshing) return;
                        touch.setSettings("xMirror", checked ? 1 : 0);
                    }
                    MouseArea{
                        id:xMirrorCheckBoxMouse
                        anchors.fill: parent
                        hoverEnabled: true
                        onEntered: {
                            spinTimer.restart();
                            mouseAreaWhat = 0;
                        }
                        onExited: {
                            spinTimer.stop();
                            xMirrorCheckBoxTooltip.visible = false;
                        }
                        onClicked: {
                            xMirrorCheckBox.checked = !xMirrorCheckBox.checked;
                        }
                    }
                }
                CheckBox {
                    id: yMirrorCheckBox
                    text: qsTr("turn over Y")
                    font.pointSize: 14
                    anchors.rightMargin: 10
                    onCheckedChanged: {
                        if (refreshing) return;
                        touch.setSettings("yMirror", checked ? 1 : 0);
                    }
                    MouseArea{
                        id:yMirrorCheckBoxMouse
                        anchors.fill: parent
                        hoverEnabled: true
                        onEntered: {
                            spinTimer.restart();
                            mouseAreaWhat = 1;
                        }
                        onExited: {
                            spinTimer.stop();
                            yMirrorCheckBoxTooltip.visible = false;
                        }
                        onClicked: {
                            yMirrorCheckBox.checked = !yMirrorCheckBox.checked;
                        }
                    }
                }


                MyButton{
                    textStr: qsTr("factory reset")
                    imageSource:"qrc:/dialog/images/restort_blue.png"
                    tooltipStr: qsTr("Restore factory touch frame flip parameters.")
                    onClicked: {
                        var def = touch.resetXYOrientation();
                        if (def & 0xff) {
                            xMirrorCheckBox.checked = true;
                        } else {
                            xMirrorCheckBox.checked = false;
                        }
                        if (def & 0xff00) {
                            yMirrorCheckBox.checked = true;
                        } else {
                            yMirrorCheckBox.checked = false;
                        }
                    }
                }
            }
            ButtonGroup {
                id: touchRotationGroup
                onCheckedButtonChanged: {
                    if (refreshing) return;
                    console.log("触摸框旋转");
                    touch.setSettings("touchRotation", checkedButton.mode);
                }
            }
            RowLayout {
                id:touchSpinLayout
                spacing: defaultSpacing
                Image {
                    id: touchSpin;
                    visible: true
                    Layout.preferredHeight:parent.implicitHeight
                    Layout.preferredWidth: parent.implicitHeight / 5.0 * 4
                    fillMode: Image.PreserveAspectFit
                    source: "qrc:/dialog/images/touch_spin.png";
                }
                Label {
                    text: qsTr("touch clockwise rotation") + "(4)"
                    Layout.preferredHeight:defaultSpacing
                    Layout.preferredWidth: labelWidth
                    verticalAlignment: Text.AlignVCenter
                    anchors.verticalCenter: parent.verticalCenter
                    font.pointSize: 14
                }

                RadioButton {
                    id:touchSpin0
                    property int mode: 0
                    text: "0°"
                    font.pointSize: 14
                    checked: true
                    ButtonGroup.group: touchRotationGroup
                    anchors.rightMargin: 10
                    MouseArea{
                        id:touchSpin0Mouse
                        anchors.fill: parent
                        hoverEnabled: true
                        onEntered: {
                            spinTimer.restart();
                            mouseAreaWhat = 2;
                        }
                        onExited: {
                            spinTimer.stop();
                            touchSpin0Tooltip.visible = false;
                        }
                        onClicked: {
                            touchSpin0.checked = true;
                        }
                    }
                }
                RadioButton {
                    id:touchSpin1
                    property int mode: 1
                    text: "90°"
                    font.pointSize: 14
                    ButtonGroup.group: touchRotationGroup
                    anchors.rightMargin: 10

                    MouseArea{
                        id:touchSpin1Mouse
                        anchors.fill: parent
                        hoverEnabled: true
                        onEntered: {
                            spinTimer.restart();
                            mouseAreaWhat = 3;
                        }
                        onExited: {
                            spinTimer.stop();
                            touchSpin1Tooltip.visible = false;
                        }
                        onClicked: {
                            touchSpin1.checked = true;
                        }
                    }
                }
                RadioButton {
                    id:touchSpin2
                    property int mode: 2
                    text: "180°"
                    font.pointSize: 14
                    ButtonGroup.group: touchRotationGroup
                    anchors.rightMargin: 10
                    MouseArea{
                        id:touchSpin2Mouse
                        anchors.fill: parent
                        hoverEnabled: true
                        onEntered: {
                            spinTimer.restart();
                            mouseAreaWhat = 4;
                        }
                        onExited: {
                            spinTimer.stop();
                            touchSpin2Tooltip.visible = false;
                        }
                        onClicked: {
                            touchSpin2.checked = true;
                        }
                    }
                }
                RadioButton {
                    id:touchSpin3
                    property int mode: 3
                    text: "270°"
                    font.pointSize: 14
                    ButtonGroup.group: touchRotationGroup
                    anchors.rightMargin: 10
                    MouseArea{
                        id:touchSpin3Mouse
                        anchors.fill: parent
                        hoverEnabled: true
                        onEntered: {
                            spinTimer.restart();
                            mouseAreaWhat = 5;
                        }
                        onExited: {
                            spinTimer.stop();
                            touchSpin3Tooltip.visible = false;
                        }
                        onClicked: {
                            touchSpin3.checked = true;
                        }
                    }
                }
                MyButton{
                    textStr: qsTr("factory reset")
                    imageSource:"qrc:/dialog/images/restort_blue.png"
                    tooltipStr: qsTr("Restore factory touch frame to rotate clockwise parameters.")
                    onClicked: {
                        var def = touch.resetTouchRotation();
                        var btn;
                        for (var i = 0; i < touchRotationGroup.buttons.length; i++) {
                            btn = touchRotationGroup.buttons[i];
                            if (btn.mode === def) {
                                btn.checked = true;
                            } else {
                                btn.checked = false;
                            }
                        }
                    }
                }
            }

            ButtonGroup {
                id: screenRotationGroup
                onCheckedButtonChanged: {
                    if (refreshing) return;
                    console.log("屏幕旋转")
                    touch.setSettings("screenRotation", checkedButton.mode);
                }
            }
            RowLayout {
                id:screenSpinLayout
                spacing: defaultSpacing
                Image {
                    id: screenSpin;
                    visible: true
                    Layout.preferredHeight:parent.implicitHeight / 5.0 * 4
                    Layout.preferredWidth: parent.implicitHeight / 5.0 * 4
                    fillMode: Image.PreserveAspectFit
                    source: "qrc:/dialog/images/screen_spin.png";
                }
                Label {
                    text: qsTr("screen clockwise rotation") + "(5)"
                    font.pointSize: 14
                    Layout.preferredHeight:defaultSpacing
                    Layout.preferredWidth: labelWidth
                    verticalAlignment: Text.AlignVCenter
                    anchors.verticalCenter: parent.verticalCenter
                }

                RadioButton {
                    id:screenSpin0
                    property int mode: 0
                    text: "0°"
                    font.pointSize: 14
                    checked: true
                    ButtonGroup.group: screenRotationGroup
                    anchors.rightMargin: 10
                    MouseArea{
                        id:screenSpin0Mouse
                        anchors.fill: parent
                        hoverEnabled: true
                        onEntered: {
                            spinTimer.restart();
                            mouseAreaWhat = 6;
                        }
                        onExited: {
                            spinTimer.stop();
                            screenSpin0Tooltip.visible = false;
                        }
                        onClicked: {
                            screenSpin0.checked = true;
                        }
                    }
                }
                RadioButton {
                    id:screenSpin1
                    property int mode: 1
                    text: "90°"
                    font.pointSize: 14
                    ButtonGroup.group: screenRotationGroup
                    anchors.rightMargin: 10
                    MouseArea{
                        id:screenSpin1Mouse
                        anchors.fill: parent
                        hoverEnabled: true
                        onEntered: {
                            spinTimer.restart();
                            mouseAreaWhat = 7;
                        }
                        onExited: {
                            spinTimer.stop();
                            screenSpin1Tooltip.visible = false;
                        }
                        onClicked: {
                            screenSpin1.checked = true;
                        }
                    }
                }
                RadioButton {
                    id:screenSpin2
                    property int mode: 2
                    text: "180°"
                    font.pointSize: 14
                    ButtonGroup.group: screenRotationGroup
                    anchors.rightMargin: 10
                    MouseArea{
                        id:screenSpin2Mouse
                        anchors.fill: parent
                        hoverEnabled: true
                        onEntered: {
                            spinTimer.restart();
                            mouseAreaWhat = 8;
                        }
                        onExited: {
                            spinTimer.stop();
                            screenSpin2Tooltip.visible = false;
                        }
                        onClicked: {
                            screenSpin2.checked = true;
                        }
                    }
                }
                RadioButton {
                    id:screenSpin3
                    property int mode: 3
                    text: "270°"
                    font.pointSize: 14
                    ButtonGroup.group: screenRotationGroup
                    anchors.rightMargin: 10
                    MouseArea{
                        id:screenSpin3Mouse
                        anchors.fill: parent
                        hoverEnabled: true
                        onEntered: {
                            spinTimer.restart();
                            mouseAreaWhat = 9;
                        }
                        onExited: {
                            spinTimer.stop();
                            screenSpin3Tooltip.visible = false;
                        }
                        onClicked: {
                            screenSpin3.checked = true;
                        }
                    }
                }
                MyButton{
                    textStr: qsTr("factory reset")
                    imageSource:"qrc:/dialog/images/restort_blue.png"
                    tooltipStr: qsTr("Restore factory screen clockwise rotation parameters.")
                    onClicked: {
                        var def = touch.resetScreenRotation();
                        var btn;
                        for (var i = 0; i < screenRotationGroup.buttons.length; i++) {
                            btn = screenRotationGroup.buttons[i];
                            if (btn.mode === def) {
                                btn.checked = true;
                            } else {
                                btn.checked = false;
                            }
                        }
                    }
                }
            }
        }
    }

    Rectangle{
        id:xMirrorCheckBoxTooltip
        visible: false
        height: xMirrorCheckBoxText.height + defaultMargin
        width:xMirrorCheckBoxText.width + defaultMargin
        x: xMirrorCheckBox.x + defaultMargin
        y:touchTurnLayout.y  + touchTurnLayout.height
        border.width: 1
        border.color: "#cccccc"
        Text{
            id:xMirrorCheckBoxText
//            width:400
            text:qsTr("Keep the value of the y axis unchanged,and flip the value of the x axis.")
            font.pointSize: 10
            wrapMode: Text.Wrap
            anchors.centerIn: parent
        }

    }
    Rectangle{
        id:yMirrorCheckBoxTooltip
        visible: false
        height: yMirrorCheckBoxText.height + defaultMargin
        width:yMirrorCheckBoxText.width + defaultMargin
        x: yMirrorCheckBox.x + defaultMargin
        y:touchTurnLayout.y  + touchTurnLayout.height
        border.width: 1
        border.color: "#cccccc"
        Text{
            id:yMirrorCheckBoxText
//            width:400
            text:qsTr("Keep the value of the y axis unchanged,and flip the value of the x axis.")
            font.pointSize: 10
            wrapMode: Text.Wrap
            anchors.centerIn: parent
        }

    }

    Rectangle{
        id:touchSpin0Tooltip
        visible: false
        height: touchSpin0Text.height + defaultMargin
        width:touchSpin0Text.width + defaultMargin
        x: touchSpin0.x + defaultMargin
        y:touchSpinLayout.y  + touchSpinLayout.height
        border.width: 1
        border.color: "#cccccc"
        Text{
            id:touchSpin0Text
//            width:400
            text:qsTr("0° means no rotation, this value is the default value of the origin of the touch frame.")
            font.pointSize: 10
            wrapMode: Text.Wrap
            anchors.centerIn: parent
        }

    }
    Rectangle{
        id:touchSpin1Tooltip
        visible: false
        height: touchSpin1Text.height + defaultMargin
        width:touchSpin1Text.width + defaultMargin
        x: touchSpin1.x + defaultMargin
        y:touchSpinLayout.y  + touchSpinLayout.height
        border.width: 1
        border.color: "#cccccc"
        Text{
            id:touchSpin1Text
//            width:400
            text:qsTr("Rotate 90° relative to the origin of the touch frame.")
            font.pointSize: 10
            wrapMode: Text.Wrap
            anchors.centerIn: parent
        }

    }
    Rectangle{
        id:touchSpin2Tooltip
        visible: false
        height: touchSpin2Text.height + defaultMargin
        width:touchSpin2Text.width + defaultMargin
        x: touchSpin2.x + defaultMargin
        y:touchSpinLayout.y  + touchSpinLayout.height
        border.width: 1
        border.color: "#cccccc"
        Text{
            id:touchSpin2Text
//            width:400
            text:qsTr("Rotate 180° relative to the origin of the touch frame.")
            font.pointSize: 10
            wrapMode: Text.Wrap
            anchors.centerIn: parent
        }

    }
    Rectangle{
        id:touchSpin3Tooltip
        visible: false
        height: touchSpin3Text.height + defaultMargin
        width:touchSpin3Text.width + defaultMargin
        x: touchSpin3.x + defaultMargin
        y:touchSpinLayout.y  + touchSpinLayout.height
        border.width: 1
        border.color: "#cccccc"
        Text{
            id:touchSpin3Text
//            width:400
            text:qsTr("Rotate 270° relative to the origin of the touch frame.")
            font.pointSize: 10
            wrapMode: Text.Wrap
            anchors.centerIn: parent
        }

    }
    Rectangle{
        id:screenSpin0Tooltip
        visible: false
        height: screenSpin0Text.height + defaultMargin
        width:screenSpin0Text.width + defaultMargin
        x: screenSpin0.x + defaultMargin
        y:screenSpinLayout.y  + screenSpinLayout.height
        border.width: 1
        border.color: "#cccccc"
        Text{
            id:screenSpin0Text
//            width:400
            text:qsTr("0° means no rotation, this value is the default value of the screen origin.")
            font.pointSize: 10
            wrapMode: Text.Wrap
            anchors.centerIn: parent
        }

    }
    Rectangle{
        id:screenSpin1Tooltip
        visible: false
        height: screenSpin1Text.height + defaultMargin
        width:screenSpin1Text.width + defaultMargin
        x: screenSpin1.x + defaultMargin
        y:screenSpinLayout.y  + screenSpinLayout.height
        border.width: 1
        border.color: "#cccccc"
        Text{
            id:screenSpin1Text
//            width:400
            text:qsTr("Rotate 90° relative to the origin of the screen.")
            font.pointSize: 10
            wrapMode: Text.Wrap
            anchors.centerIn: parent
        }

    }
    Rectangle{
        id:screenSpin2Tooltip
        visible: false
        height: screenSpin2Text.height + defaultMargin
        width:screenSpin2Text.width + defaultMargin
        x: screenSpin2.x + defaultMargin
        y:screenSpinLayout.y  + screenSpinLayout.height
        border.width: 1
        border.color: "#cccccc"
        Text{
            id:screenSpin2Text
//            width:400
            text:qsTr("Rotate 180° relative to the origin of the screen.")
            font.pointSize: 10
            wrapMode: Text.Wrap
            anchors.centerIn: parent
        }

    }
    Rectangle{
        id:screenSpin3Tooltip
        visible: false
        height: screenSpin3Text.height + defaultMargin
        width:screenSpin3Text.width + defaultMargin
        x: screenSpin3.x + defaultMargin
        y:screenSpinLayout.y  + screenSpinLayout.height
        border.width: 1
        border.color: "#cccccc"
        Text{
            id:screenSpin3Text
//            width:400
            text:qsTr("Rotate 270° relative to the origin of the screen.")
            font.pointSize: 10
            wrapMode: Text.Wrap
            anchors.centerIn: parent
        }

    }

    //鼠标区域默认的值
    // 0 X轴翻转
    // 1 Y轴翻转
    // 2 触摸框顺时针旋转0度
    // 3 触摸框顺时针旋转90度
    // 4 触摸框顺时针旋转180度
    // 5 触摸框顺时针旋转270度
    // 6 屏幕顺时针旋转0度
    // 7 屏幕顺时针旋转90度
    // 8 屏幕顺时针旋转180度
    // 9 屏幕顺时针旋转270度

    property int mouseAreaWhat:0
    Timer{
        id:spinTimer
        running: false
        triggeredOnStart: false
        interval: 1000
        onTriggered: {
            switch(mouseAreaWhat)
            {
            case 0:
                xMirrorCheckBoxTooltip.visible = true;
                break;
            case 1:
                yMirrorCheckBoxTooltip.visible = true;
                break;
            case 2:
                touchSpin0Tooltip.visible = true;
                break;
            case 3:
                touchSpin1Tooltip.visible = true;
                break;
            case 4:
                touchSpin2Tooltip.visible = true;
                break;
            case 5:
                touchSpin3Tooltip.visible = true;
                break;
            case 6:
                screenSpin0Tooltip.visible = true;
                break;
            case 7:
                screenSpin1Tooltip.visible = true;
                break;
            case 8:
                screenSpin2Tooltip.visible = true;
                break;
            case 9:
                screenSpin3Tooltip.visible = true;
                break;
            default:
                console.log("coordsTimer is error!");
                break;
            }
        }
    }

}
