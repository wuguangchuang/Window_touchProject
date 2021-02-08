import QtQuick 2.7

import QtQuick.Window 2.2
import QtQuick.Controls 1.4
import QtQuick.Controls.Styles 1.4
import QtQuick.Layouts 1.3


Item {
    signal exitTune();

    property int left_direction:1
    property int right_direction:2
    property int up_direction:3
    property int down_direction:4

    property var leftPreviousX:0
    property var leftPreviousY:0
    property var leftSceneX:0
    property var leftSceneY:0

    property var rightPreviousX:0
    property var rightPreviousY:0
    property var rightSceneX:0
    property var rightSceneY:0

    property var upPreviousX:0
    property var upPreviousY:0
    property var upSceneX:0
    property var upSceneY:0

    property var downPreviousX:0
    property var downPreviousY:0
    property var downSceneX:0
    property var downSceneY:0

    property var golbalPreviousX:0
    property var golbalPreviousY:0
    property var golbalSceneX:0
    property var golbalSceneY:0

    property bool left_rightBtn:false
    property var midMessage:qsTr("Please draw vertical lines on the left and right and horizontal lines up and down to tune.")
    property int imageSize:64

    focus: false
    Keys.enabled: false
    Keys.onPressed: {
        console.log("按键按下%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%")
        switch (event.key){
        case Qt.Key_Escape:

            clearCanvas();
            exitTune();
            break;
        case Qt.Key_C:
            clearCanvas();
            break;
        }
    }

    function onPressed(event)
    {

        switch (event.key){
        case Qt.Key_Escape:
            clearCanvas();
            exitTune();
            break;
        case Qt.Key_C:
            clearCanvas();
            break;
        }
    }

    Timer{
        id: golbalTimer
        interval: 1000
        repeat: false
        running: false
        triggeredOnStart: false
        onTriggered: {
            tuneMenu.popup();

        }
    }

    Menu {
        id: tuneMenu
        style:MenuStyle{
//            itemDelegate.background: Rectangle{

//                height: 80
//                width: 300
//                border.width: 1
//                border.color: "grey"
//            }
//            itemDelegate.label: Text{
//                height:40
//                width:300
//                font.pointSize:12
//                color: "grey"
////                font.family:"微软雅黑"

//            }
            font: Qt.font({pointSize:12,color: "grey"})
        }

        MenuItem{

            id:clearDrawLine           
            text:qsTr("clear")
            onTriggered: {
                clearCanvas();
            }
        }
        MenuSeparator{}
        MenuItem {
            text: qsTr("exit")
            onTriggered:{
                clearCanvas();
                exitTune();
            }
        }
    }
    MouseArea{
        anchors.fill: parent
        acceptedButtons: Qt.AllButtons
        onClicked: {
            switch (mouse.button) {
            case Qt.LeftButton:
                mouse.accepted = true;
                break;
            case Qt.RightButton:
                tuneMenu.popup();
                mouse.accepted = true;
                break;
            }
        }
    }
    Rectangle{
        anchors.fill: parent
        MultiPointTouchArea{
            anchors.fill: parent
            enabled: true
            mouseEnabled: true
            maximumTouchPoints: 1
            minimumTouchPoints: 1
            touchPoints: [
                TouchPoint
                {
                    id:golbalMultTouch1
                }
            ]
            onPressed: {

                golbalPreviousX = golbalMultTouch1.sceneX;
                golbalPreviousY = golbalMultTouch1.sceneY;
                golbalSceneX = golbalPreviousX;
                golbalSceneY = golbalPreviousY;
                golbalTimer.start();

            }
            onReleased: {

                golbalTimer.stop();

            }
            onUpdated: {
                golbalSceneX = golbalMultTouch1.sceneX;
                golbalSceneY = golbalMultTouch1.sceneY;
                if(Math.abs(golbalSceneX - golbalPreviousX) > 64 ||
                        Math.abs(golbalSceneY - golbalPreviousY) > 64)
                {

                    golbalTimer.stop();
                }
            }

        }
        Rectangle{
            id:leftDrawArea
            visible: true
            x:parent.width / 8 + imageSize
            y:parent.height / 4 + imageSize
            width:parent.width / 8
            height: parent.height / 2 - imageSize * 2
            border.width: 1
            border.color: "#a5a5a5"
            MultiPointTouchArea{
                id:leftTouchPoint
                anchors.fill: parent
                enabled: true
                mouseEnabled: true
                maximumTouchPoints: 1
                minimumTouchPoints: 1
                touchPoints: [
                    TouchPoint{
                        id:touchPointL1
                    }
        //                TouchPoint{
        //                    id:touchPoint2
        //                },
        //                TouchPoint{
        //                    id:touchPoint3
        //                }
                ]
                onPressed: {
                    leftPreviousX = touchPointL1.sceneX - parent.x;
                    leftPreviousY = touchPointL1.sceneY - parent.y;
                    leftSceneX = touchPointL1.sceneX - parent.x;
                    leftSceneY = touchPointL1.sceneY - parent.y;

                }
                onReleased: {
                }
                onUpdated: {

                    leftSceneX = touchPointL1.sceneX - parent.x;
                    leftSceneY = touchPointL1.sceneY - parent.y;
                    leftCanvas.requestPaint();

                }
            }
            Canvas{
                id:leftCanvas
                anchors.fill: parent
                onPaint: {
                    var ctx = getContext("2d");
                    ctx.save();
                    ctx.lineWidth = 2;
                    ctx.strokeStyle = "red";
                    ctx.fillStyle = "red";
                    ctx.beginPath();
                    ctx.moveTo(leftPreviousX,leftPreviousY);
                    ctx.lineTo(leftSceneX,leftSceneY);
                    ctx.stroke();
                    ctx.fill();
                    leftPreviousX = leftSceneX;
                    leftPreviousY = leftSceneY;
                }
            }

        }
        ToolButton{
            id:left_right_5
            visible: true
            x:leftDrawArea.x + leftDrawArea.width + 15
            y:leftDrawArea.y + leftDrawArea.height / 2 - height / 2
            width: 120
            height: 64
            Image {
                id:left_right_5_image
                width: 64
                height: 64
                fillMode: Image.Stretch
                source: "qrc:/dialog/images/triangle_right.png"
            }
            Text{
                id:left_right_5_text
                anchors.left: left_right_5_image.right
                text:"* 5"
                anchors.verticalCenter: parent.verticalCenter
                font.pointSize: 15
            }

            onClicked: {
                changeCalibrationData(left_direction,-5);
            }

        }
        ToolButton{
            id:left_right_2
            visible: true
            width: 120
            height: 64
            anchors.left: leftDrawArea.right
            anchors.leftMargin: 15
            anchors.bottom:left_right_5.top
            anchors.bottomMargin: 10
            Image {
                id:left_right_2_image
                width: 64
                height: 64
                fillMode: Image.Stretch
                source: "qrc:/dialog/images/triangle_right.png"
            }
            Text{
                id:left_right_2_text
                anchors.left: left_right_2_image.right
                text:"* 2"
                anchors.verticalCenter: parent.verticalCenter
                font.pointSize: 15
            }

            onClicked: {
                changeCalibrationData(left_direction,-2);
            }
        }
        ToolButton{
            id:left_right_10
            visible: true
            width: 120
            height: 64
            anchors.left: leftDrawArea.right
            anchors.leftMargin: 15
            anchors.top: left_right_5.bottom
            anchors.topMargin: 10
            Image {
                id:left_right_10_image
                width: 64
                height: 64
                fillMode: Image.Stretch
                source: "qrc:/dialog/images/triangle_right.png"
            }
            Text{
                id:left_right_10_text
                anchors.left: left_right_10_image.right
                text:"* 10"
                anchors.verticalCenter: parent.verticalCenter
                font.pointSize: 15
            }
            onClicked: {
                changeCalibrationData(left_direction,-10);
            }
        }
        ToolButton{
            id:left_left_5
            visible: true
            x:leftDrawArea.x -  135
            y:leftDrawArea.y + leftDrawArea.height / 2 - height / 2
            width: 120
            height: 64
            Text{
                id:left_left_5_text
                anchors.right: left_left_5_image.left
                text:"5 *"
                anchors.verticalCenter: parent.verticalCenter
                font.pointSize: 15
            }
            Image {
                id:left_left_5_image
                width: 64
                height: 64
                anchors.right: parent.right
                fillMode: Image.Stretch
                source: "qrc:/dialog/images/triangle_left.png"
            }
            onClicked: {
                changeCalibrationData(left_direction,5);
            }
        }
        ToolButton{
            id:left_left_2
            visible: true
            x:leftDrawArea.x -  135
            anchors.bottom: left_left_5.top
            anchors.bottomMargin: 10
            width: 120
            height: 64
            Text{
                id:left_left_2_text
                anchors.right: left_left_2_image.left
                text:"2 *"
                anchors.verticalCenter: parent.verticalCenter
                font.pointSize: 15
            }
            Image {
                id:left_left_2_image
                width: 64
                height: 64
                anchors.right: parent.right
                fillMode: Image.Stretch
                source: "qrc:/dialog/images/triangle_left.png"
            }
            onClicked: {
                changeCalibrationData(left_direction,2);
            }
        }
        ToolButton{
            id:left_left_10
            visible: true
            x:leftDrawArea.x -  135
            anchors.top: left_left_5.bottom
            anchors.topMargin: 10
            width: 120
            height: 64
            Text{
                id:left_left_10_text
                anchors.right: left_left_10_image.left
                text:"10 *"
                anchors.verticalCenter: parent.verticalCenter
                font.pointSize: 15
            }
            Image {
                id:left_left_10_image
                width: 64
                height: 64
                anchors.right: parent.right
                fillMode: Image.Stretch
                source: "qrc:/dialog/images/triangle_left.png"
            }
            onClicked: {
                changeCalibrationData(left_direction,10);
            }
        }


        Rectangle{
            id:rightDrawArea
            visible: true
            x:parent.width /  4 * 3 - imageSize
            y:leftDrawArea.y
            width:leftDrawArea.width
            height: leftDrawArea.height
            border.width: 1
            border.color: "#a5a5a5"
            MultiPointTouchArea{
                id:rightTouchPoint
                anchors.fill: parent
                enabled: true
                mouseEnabled: true
                maximumTouchPoints: 1
                minimumTouchPoints: 1
                touchPoints: [
                    TouchPoint{
                        id:touchPointR1
                    }
                ]
                onPressed: {
                    rightPreviousX = touchPointR1.sceneX - parent.x;
                    rightPreviousY = touchPointR1.sceneY - parent.y;
                    rightSceneX = touchPointR1.sceneX - parent.x;
                    rightSceneY = touchPointR1.sceneY - parent.y;

                }
                onReleased: {
                }
                onUpdated: {
                    rightSceneX = touchPointR1.sceneX - parent.x;
                    rightSceneY = touchPointR1.sceneY - parent.y;
                    rightCanvas.requestPaint();
                }
            }
            Canvas{
                id:rightCanvas
                anchors.fill: parent
                onPaint: {
                    var ctx = getContext("2d");
                    ctx.save();
                    ctx.lineWidth = 2;
                    ctx.strokeStyle = "red";
                    ctx.fillStyle = "red";
                    ctx.beginPath();
                    ctx.moveTo(rightPreviousX,rightPreviousY);
                    ctx.lineTo(rightSceneX,rightSceneY);
                    ctx.stroke();
                    ctx.fill();
                    rightPreviousX = rightSceneX;
                    rightPreviousY = rightSceneY;
                }
            }

        }
        ToolButton{
            id:right_right_5
            visible: true
            x:rightDrawArea.x + rightDrawArea.width + 15
            y:rightDrawArea.y + rightDrawArea.height / 2 - height / 2
            width: 120
            height: 64
            Image {
                id:right_right_5_image
                width: 64
                height: 64
                fillMode: Image.Stretch
                source: "qrc:/dialog/images/triangle_right.png"
            }
            Text{
                id:right_right_5_text
                anchors.left: right_right_5_image.right
                text:"* 5"
                anchors.verticalCenter: parent.verticalCenter
                font.pointSize: 15
            }
            onClicked: {
                changeCalibrationData(right_direction,-5);
            }
        }
        ToolButton{
            id:right_right_2
            visible: true
            x:rightDrawArea.x + rightDrawArea.width + 15
            anchors.bottom: right_right_5.top
            anchors.bottomMargin: 10
            width: 120
            height: 64
            Image {
                id:right_right_2_image
                width: 64
                height: 64
                fillMode: Image.Stretch
                source: "qrc:/dialog/images/triangle_right.png"
            }
            Text{
                id:right_right_2_text
                anchors.left: right_right_2_image.right
                text:"* 2"
                anchors.verticalCenter: parent.verticalCenter
                font.pointSize: 15
            }
            onClicked: {
                changeCalibrationData(right_direction,-2);
            }
        }
        ToolButton{
            id:right_right_10
            visible: true
            x:rightDrawArea.x + rightDrawArea.width + 15
            anchors.top: right_right_5.bottom
            anchors.topMargin: 10
            width: 120
            height: 64
            Image {
                id:right_right_10_image
                width: 64
                height: 64
                fillMode: Image.Stretch
                source: "qrc:/dialog/images/triangle_right.png"
            }
            Text{
                id:right_right_10_text
                anchors.left: right_right_10_image.right
                text:"* 10"
                anchors.verticalCenter: parent.verticalCenter
                font.pointSize: 15
            }
            onClicked: {
                changeCalibrationData(right_direction,-10);
            }
        }
        ToolButton{
            id:right_left_5
            visible: true
            x:rightDrawArea.x -  135
            y:rightDrawArea.y + rightDrawArea.height / 2 - height / 2
            width: 120
            height: 64
            Text{
                id:right_left_5_text
                anchors.right: right_left_5_image.left
                text:"5 *"
                anchors.verticalCenter: parent.verticalCenter
                font.pointSize: 15
            }
            Image {
                id:right_left_5_image
                width: 64
                height: 64
                anchors.right: parent.right
                fillMode: Image.Stretch
                source: "qrc:/dialog/images/triangle_left.png"
            }
            onClicked: {
                changeCalibrationData(right_direction,5);
            }
        }
        ToolButton{
            id:right_left_2
            visible: true
            x:rightDrawArea.x -  135
            anchors.bottom: right_left_5.top
            anchors.bottomMargin: 10
            width: 120
            height: 64
            Text{
                id:right_left_2_text
                anchors.right: right_left_2_image.left
                text:"2 *"
                anchors.verticalCenter: parent.verticalCenter
                font.pointSize: 15
            }
            Image {
                id:right_left_2_image
                width: 64
                height: 64
                anchors.right: parent.right
                fillMode: Image.Stretch
                source: "qrc:/dialog/images/triangle_left.png"
            }
            onClicked: {
                changeCalibrationData(right_direction,2);
            }
        }
        ToolButton{
            id:right_left_10
            visible: true
            x:rightDrawArea.x -  135
            anchors.top: right_left_5.bottom
            anchors.topMargin: 10
            width: 120
            height: 64
            Text{
                id:right_left_10_text
                anchors.right: right_left_10_image.left
                text:"10 *"
                anchors.verticalCenter: parent.verticalCenter
                font.pointSize: 15
            }
            Image {
                id:right_left_10_image
                width: 64
                height: 64
                anchors.right: parent.right
                fillMode: Image.Stretch
                source: "qrc:/dialog/images/triangle_left.png"
            }
            onClicked: {
                changeCalibrationData(right_direction,10);
            }
        }


        Rectangle{
            id:upDrawArea
            visible: true
            x:parent.width / 4 + imageSize
            y:parent.height / 8 + imageSize
            width:parent.width / 2 - imageSize * 2
            height: parent.height / 8
            border.width: 1
            border.color: "#a5a5a5"
            MultiPointTouchArea{
                id:upTouchPoint
                anchors.fill: parent
                enabled: true
                mouseEnabled: true
                maximumTouchPoints: 1
                minimumTouchPoints: 1
                touchPoints: [
                    TouchPoint{
                        id:touchPointU1
                    }
                ]
                onPressed: {
                    upPreviousX = touchPointU1.sceneX - parent.x;
                    upPreviousY = touchPointU1.sceneY - parent.y;
                    upSceneX = touchPointU1.sceneX - parent.x;
                    upSceneY = touchPointU1.sceneY - parent.y;

                }
                onReleased: {
                }
                onUpdated: {
                    upSceneX = touchPointU1.sceneX - parent.x;
                    upSceneY = touchPointU1.sceneY - parent.y;
                    upCanvas.requestPaint();
                }
            }
            Canvas{
                id:upCanvas
                anchors.fill: parent
                onPaint: {
                    var ctx = getContext("2d");
                    ctx.save();
                    ctx.lineWidth = 2;
                    ctx.strokeStyle = "red";
                    ctx.fillStyle = "red";
                    ctx.beginPath();
                    ctx.moveTo(upPreviousX,upPreviousY);
                    ctx.lineTo(upSceneX,upSceneY);
                    ctx.stroke();
                    ctx.fill();
                    upPreviousX = upSceneX;
                    upPreviousY = upSceneY;
                }
            }
        }
        ToolButton{
            id:up_down_5
            visible: true
            x:upDrawArea.x + upDrawArea.width / 2 - width / 2
            y:upDrawArea.y + upDrawArea.height + 15
            width: 64
            height: 120
            Image {
                id:up_down_5_image
                width: 64
                height: 64
                anchors.top: parent.top
                fillMode: Image.Stretch
                source: "qrc:/dialog/images/triangle_down.png"
            }
            Text{
                id:up_down_5_text
                anchors.top: up_down_5_image.bottom
                text:"5 *"
                anchors.horizontalCenter: parent.horizontalCenter
                font.pointSize: 15
                rotation: 270
            }
            onClicked: {
                changeCalibrationData(up_direction,-5);
            }
        }
        ToolButton{
            id:up_down_2
            visible: true
            anchors.right:up_down_5.left
            anchors.rightMargin: 10
            y:upDrawArea.y + upDrawArea.height + 15
            width: 64
            height: 120
            Image {
                id:up_down_2_image
                width: 64
                height: 64
                anchors.top: parent.top
                fillMode: Image.Stretch
                source: "qrc:/dialog/images/triangle_down.png"
            }
            Text{
                id:up_down_2_text
                anchors.top: up_down_2_image.bottom
                text:"2 *"
                anchors.horizontalCenter: parent.horizontalCenter
                font.pointSize: 15
                rotation: 270
            }
            onClicked: {
                changeCalibrationData(up_direction,-2);
            }
        }
        ToolButton{
            id:up_down_10
            visible: true
            anchors.left: up_down_5.right
            anchors.leftMargin: 10
            y:upDrawArea.y + upDrawArea.height + 15
            width: 64
            height: 120
            Image {
                id:up_down_10_image
                width: 64
                height: 64
                anchors.top: parent.top
                fillMode: Image.Stretch
                source: "qrc:/dialog/images/triangle_down.png"
            }
            Text{
                id:up_down_10_text
                anchors.top: up_down_10_image.bottom
                text:"10 *"
                anchors.horizontalCenter: parent.horizontalCenter
                font.pointSize: 15
                rotation: 270
            }
            onClicked: {
                changeCalibrationData(up_direction,-10);
            }
        }

        ToolButton{
            id:up_up_5
            visible: true
            x:upDrawArea.x + upDrawArea.width / 2 - width / 2
            y:upDrawArea.y - 135
            width: 64
            height: 120
            Text{
                id:up_up_5_text
                anchors.bottom: up_up_5_image.top
                anchors.horizontalCenter: parent.horizontalCenter
                text:"* 5"
                font.pointSize: 15
                rotation: 270
            }
            Image {
                id:up_up_5_image
                width: 64
                height: 64
                anchors.bottom: parent.bottom

                fillMode: Image.Stretch
                source: "qrc:/dialog/images/triangle_up.png"
            }
            onClicked: {
                changeCalibrationData(up_direction,5);
            }
        }
        ToolButton{
            id:up_up_2
            visible: true
            anchors.right: up_up_5.left
            anchors.rightMargin: 10
            y:upDrawArea.y - 135
            width: 64
            height: 120
            Text{
                id:up_up_2_text
                anchors.bottom: up_up_2_image.top
                anchors.horizontalCenter: parent.horizontalCenter
                text:"* 2"
                font.pointSize: 15
                rotation: 270
            }
            Image {
                id:up_up_2_image
                width: 64
                height: 64
                anchors.bottom: parent.bottom

                fillMode: Image.Stretch
                source: "qrc:/dialog/images/triangle_up.png"
            }
            onClicked: {
                changeCalibrationData(up_direction,2);
            }
        }
        ToolButton{
            id:up_up_10
            visible: true
            anchors.left: up_up_5.right
            anchors.leftMargin: 10
            y:upDrawArea.y - 135
            width: 64
            height: 120
            Text{
                id:up_up_10_text
                anchors.bottom: up_up_10_image.top
                anchors.horizontalCenter: parent.horizontalCenter
                text:"* 10"
                font.pointSize: 15
                rotation: 270
            }
            Image {
                id:up_up_10_image
                width: 64
                height: 64
                anchors.bottom: parent.bottom

                fillMode: Image.Stretch
                source: "qrc:/dialog/images/triangle_up.png"
            }
            onClicked: {
                changeCalibrationData(up_direction,10);
            }
        }

        Rectangle{
            id:downDrawArea
            visible: true
            x:upDrawArea.x
            y:parent.height / 4 * 3 - imageSize
            width:upDrawArea.width
            height: upDrawArea.height
            border.width: 1
            border.color: "#a5a5a5"
            MultiPointTouchArea{
                id:downTouchPoint
                anchors.fill: parent
                enabled: true
                mouseEnabled: true
                maximumTouchPoints: 1
                minimumTouchPoints: 1
                touchPoints: [
                    TouchPoint{
                        id:touchPointD1
                    }
                ]
                onPressed: {
                    downPreviousX = touchPointD1.sceneX - parent.x;
                    downPreviousY = touchPointD1.sceneY - parent.y;
                    downSceneX = touchPointD1.sceneX - parent.x;
                    downSceneY = touchPointD1.sceneY - parent.y;

                }
                onReleased: {

                }
                onUpdated: {
                    downSceneX = touchPointD1.sceneX - parent.x;
                    downSceneY = touchPointD1.sceneY - parent.y;
                    downCanvas.requestPaint();
                }
            }
            Canvas{
                id:downCanvas
                anchors.fill: parent
                onPaint: {
                    var ctx = getContext("2d");
                    ctx.save();
                    ctx.lineWidth = 2;
                    ctx.strokeStyle = "red";
                    ctx.fillStyle = "red";
                    ctx.beginPath();
                    ctx.moveTo(downPreviousX,downPreviousY);
                    ctx.lineTo(downSceneX,downSceneY);
                    ctx.stroke();
                    ctx.fill();
                    downPreviousX = downSceneX;
                    downPreviousY = downSceneY;
                }
            }
        }
        ToolButton{
            id:down_down_5
            visible: true
            x:downDrawArea.x + downDrawArea.width / 2 - width / 2
            y:downDrawArea.y + downDrawArea.height + 15
            width: 64
            height: 120
            Image {
                id:down_down_5_image
                width:64
                height: 64
                anchors.top: parent.top
                anchors.horizontalCenter: parent.horizontalCenter
                fillMode: Image.Stretch
                source: "qrc:/dialog/images/triangle_down.png"
            }
            Text{
                id:down_down_text
                anchors.top: down_down_5_image.bottom
                anchors.horizontalCenter: parent.horizontalCenter
                text:"5 *"
                font.pointSize: 15
                rotation: 270
            }
            onClicked: {
                changeCalibrationData(down_direction,-5);
            }
        }
        ToolButton{
            id:down_down_2
            visible: true
            anchors.right: down_down_5.left
            anchors.rightMargin: 10
            y:downDrawArea.y + downDrawArea.height + 15
            width: 64
            height: 120
            Image {
                id:down_down_2_image
                width:64
                height: 64
                anchors.top: parent.top
                anchors.horizontalCenter: parent.horizontalCenter
                fillMode: Image.Stretch
                source: "qrc:/dialog/images/triangle_down.png"
            }
            Text{
                id:down_down_2_text
                anchors.top: down_down_2_image.bottom
                anchors.horizontalCenter: parent.horizontalCenter
                text:"2 *"
                font.pointSize: 15
                rotation: 270
            }
            onClicked: {
                changeCalibrationData(down_direction,-2);
            }
        }
        ToolButton{
            id:down_down_10
            visible: true
            anchors.left: down_down_5.right
            anchors.leftMargin: 10
            y:downDrawArea.y + downDrawArea.height + 15
            width: 64
            height: 120
            Image {
                id:down_down_10_image
                width:64
                height: 64
                anchors.top: parent.top
                anchors.horizontalCenter: parent.horizontalCenter
                fillMode: Image.Stretch
                source: "qrc:/dialog/images/triangle_down.png"
            }
            Text{
                id:down_down_10_text
                anchors.top: down_down_10_image.bottom
                anchors.horizontalCenter: parent.horizontalCenter
                text:"10 *"
                font.pointSize: 15
                rotation: 270
            }
            onClicked: {
                changeCalibrationData(down_direction,-10);
            }
        }


        ToolButton{
            id:down_up_5
            visible: true
            x:downDrawArea.x + downDrawArea.width / 2 - width / 2
            y:downDrawArea.y - 135
            width: 64
            height: 120
            Image {
                id:down_up_5_image
                width: 64
                height: 64
                anchors.bottom: parent.bottom
                fillMode: Image.Stretch
                source: "qrc:/dialog/images/triangle_up.png"
            }
            Text{
                id:down_up_5_text
                anchors.bottom: down_up_5_image.top
                anchors.horizontalCenter: parent.horizontalCenter
                text:"* 5"
                font.pointSize: 15
                rotation: 270
            }
            onClicked: {
                changeCalibrationData(down_direction,5);
            }
        }
        ToolButton{
            id:down_up_2
            visible: true
            anchors.right: down_up_5.left
            anchors.rightMargin: 10
            y:downDrawArea.y - 135
            width: 64
            height: 120
            Image {
                id:down_up_2_image
                width: 64
                height: 64
                anchors.bottom: parent.bottom
                fillMode: Image.Stretch
                source: "qrc:/dialog/images/triangle_up.png"
            }
            Text{
                id:down_up_2_text
                anchors.bottom: down_up_2_image.top
                anchors.horizontalCenter: parent.horizontalCenter
                text:"* 2"
                font.pointSize: 15
                rotation: 270
            }
            onClicked: {
                changeCalibrationData(down_direction,2);
            }
        }
        ToolButton{
            id:down_up_10
            visible: true
            anchors.left: down_up_5.right
            anchors.leftMargin: 10
            y:downDrawArea.y - 135
            width: 64
            height: 120
            Image {
                id:down_up_10_image
                width: 64
                height: 64
                anchors.bottom: parent.bottom
                fillMode: Image.Stretch
                source: "qrc:/dialog/images/triangle_up.png"
            }
            Text{
                id:down_up_10_text
                anchors.bottom: down_up_10_image.top
                anchors.horizontalCenter: parent.horizontalCenter
                text:"* 10"
                font.pointSize: 15
                rotation: 270
            }
            onClicked: {
                changeCalibrationData(down_direction,10);
            }
        }

        Rectangle{
            id:midTextRect
            visible: true
            x:left_right_5.x + left_right_5.width + 30
            y:up_down_5.y + up_down_5.height + 20
            width: right_left_5.x - x - 30
            height: down_up_5.y - y - 10
    //        border.width: 1
    //        border.color: "#a5a5a5"

            Text{
                anchors.fill: parent
                anchors.topMargin: 10
                text:midMessage
    //            font.italic: true
                font.pointSize: 15
                wrapMode: Text.Wrap
            }
        }
    }
    function clearCanvas(){
        var leftCtx = leftCanvas.getContext("2d");
        leftCtx.clearRect(0,0,leftCanvas.width,leftCanvas.height);
        leftCanvas.requestPaint();

        var rightCtx = rightCanvas.getContext("2d");
        rightCtx.clearRect(0,0,rightCanvas.width,rightCanvas.height);
        rightCanvas.requestPaint();

        var upCtx = upCanvas.getContext("2d");
        upCtx.clearRect(0,0,upCanvas.width,upCanvas.height);
        upCanvas.requestPaint();

        var downCtx = downCanvas.getContext("2d");
        downCtx.clearRect(0,0,downCanvas.width,downCanvas.height);
        downCanvas.requestPaint();
    }
    function changeCalibrationData(direction,value)
    {
        var datas = touch.getCalibrationDatas(1);
        touch.debug(JSON.stringify(datas));
        if (datas.count === undefined || datas.count <= 0 || direction > datas.count)
            return;
        var i;
        var points = datas.points;
        var point0,point1,point2,point3;
        switch(direction)
        {
        case left_direction:
            point0 = points[0];
            point0.collectX += value;
            point2 = points[2];
            point2.collectX += value;
            break;
        case right_direction:
            point1 = points[1];
            point1.collectX += value;
            point3 = points[3];
            point3.collectX += value;
            break;
         case up_direction:
             point0 = points[0];
             point0.collectY += value;
             point1 = points[1];
             point1.collectY += value;
             break;
         case down_direction:
             point2 = points[2];
             point2.collectY += value;
             point3 = points[3];
             point3.collectY += value;
             break;

        }
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

        touch.setCalibrationDatas(createCalibrationData());
        touch.saveCalibration();
    }


}
