import QtQuick 2.7

import QtQuick.Window 2.2
import QtQuick.Controls 1.4
import QtQuick.Controls.Styles 1.4
import QtQuick.Layouts 1.3


Item {
    signal exitTune();

    property int offset:5

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
//    property var midMessage:qsTr("Please draw vertical lines on the left and right and horizontal lines up and down to tune.")
    property var midMessage:qsTr("Please draw a vertical line in the left and right boxes, and a horizontal line in the upper and lower boxes respectively, and detect the left and right offset positions of the vertical lines and the up and down offset positions of the horizontal lines respectively, and then click the left, right, up, and down keys to adjust.")
    property string leftPlaceholderStr:qsTr("Please draw a vertical line in this box to detect the offset position, and then click the left and right buttons to adjust.")
    property string rightPlaceholderStr:qsTr("Please draw a vertical line in this box to detect the offset position, and then click the left and right buttons to adjust.")
    property string upPlaceholderStr:qsTr("Please draw a horizontal line in this box to detect the offset position, and then click the up and down buttons to adjust.")
    property string downPlaceholderStr:qsTr("Please draw a horizontal line in this box to detect the offset position, and then click the up and down buttons to adjust.")
    property int point0X:0
    property int point0Y:0
    property int point1X:0
    property int point1Y:0
    property int point2X:0
    property int point2Y:0
    property int point3X:0
    property int point3Y:0

    focus: false
//    Keys.enabled: false
//    Keys.onPressed: {
//        console.log("按键按下%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%")
//        switch (event.key){
//        case Qt.Key_Escape:

//            clearCanvas();
//            exitTune();
//            break;
//        case Qt.Key_C:
//            clearCanvas();
//            break;
//        }
//    }

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

    Menu {
        id: tuneMenu
        style:MenuStyle{
            font: Qt.font({pointSize:15,color: "black"})
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
        enabled: true
        acceptedButtons: Qt.AllButtons
        onClicked: {

            fineTuneId.comboBox.state = ""
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
        //长按
        onPressAndHold:
        {
            tuneMenu.popup();
        }

    }
    Rectangle{
        anchors.fill: parent
        color: "#fafafa"

        Rectangle{
            id:leftDrawArea
            visible: true
            x:parent.width / 8
            y:parent.height / 4 + 50
            width:parent.width / 8
            height: parent.height / 2 - 100
            border.width: 1
            border.color: "#a5a5a5"
            color: "#fafafa"
            MultiPointTouchArea{
                id:leftTouchPoint
                anchors.fill: parent
                enabled: true
                mouseEnabled: false
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
                    leftPlaceholderStr = ""
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
            Text {
                id: leftPlaceholder
                anchors.top: parent.top
                anchors.left: parent.left
                anchors.leftMargin: 5
                anchors.right: parent.right
                anchors.rightMargin: 5
                anchors.bottom: parent.bottom
                color: "#7f7f7f"
                font.pointSize: 12
                text: leftPlaceholderStr
                lineHeight: 1.5
//                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
                wrapMode: Text.Wrap
            }

        }
        ToolButton{
            id:left_right
            visible: true
            x:leftDrawArea.x + leftDrawArea.width + defaultMargin
            y:leftDrawArea.y + leftDrawArea.height / 2 - height / 2
            width: 100
            height: 64
            Image {
                id:left_right_image
                width: 64
                height: 64
                anchors.centerIn: parent
                fillMode: Image.Stretch
                source: "qrc:/dialog/images/triangle_right.png"
            }
            Text{
                id:left_right_text
                width: 64
                height: 64
                verticalAlignment: Text.AlignVCenter
                anchors.left: parent.left
                anchors.leftMargin: (parent.width - left_right_image.width) / 2 + 10
                color: "#ffffff"
                text:offset.toString()
                font.pointSize: 15
            }
            style: Rectangle{
                width: left_right.width
                height: left_right.height
                color: left_right.pressed ? "#d9ebf9":"#fafafa"
            }
            onClicked: {
                changeCalibrationData(left_direction,offset - 2 * offset);
            }

        }

        ToolButton{
            id:left_left
            visible: true
            x:leftDrawArea.x -  (width + defaultMargin)
            y:leftDrawArea.y + leftDrawArea.height / 2 - height / 2
            width: 100
            height: 64
            Image {
                id:left_left_image
                width: 64
                height: 64
                anchors.centerIn: parent
                fillMode: Image.Stretch
                source: "qrc:/dialog/images/triangle_left.png"
            }
            Text{
                id:left_left_text
                width: 64
                height: 64
                anchors.right: parent.right
                anchors.rightMargin: (parent.width - left_left_image.width) / 2 + 10
                verticalAlignment: Text.AlignVCenter
                horizontalAlignment: Text.AlignRight
                color: "#ffffff"
                text:offset.toString()
                font.pointSize: 15
            }
            style: Rectangle{
                width: left_left.width
                height: left_left.height
                color: left_left.pressed ? "#d9ebf9":"#fafafa"
            }
            onClicked: {
                changeCalibrationData(left_direction,offset);
            }
        }


        Rectangle{
            id:rightDrawArea
            visible: true
            x:parent.width /  4 * 3
            y:leftDrawArea.y
            width:leftDrawArea.width
            height: leftDrawArea.height
            border.width: 1
            border.color: "#a5a5a5"
            color: "#fafafa"
            MultiPointTouchArea{
                id:rightTouchPoint
                anchors.fill: parent
                enabled: true
                mouseEnabled: false
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
                    rightPlaceholderStr = ""
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
            Text {
                id: rightPlaceholder
                anchors.top: parent.top
                anchors.left: parent.left
                anchors.leftMargin: 5
                anchors.right: parent.right
                anchors.rightMargin: 5
                anchors.bottom: parent.bottom
                color: "#7f7f7f"
                text: rightPlaceholderStr
                lineHeight: 1.5
                font.pointSize: 12
//                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
                wrapMode: Text.Wrap
            }

        }
        ToolButton{
            id:right_right
            visible: true
            x:rightDrawArea.x + rightDrawArea.width + defaultMargin
            y:rightDrawArea.y + rightDrawArea.height / 2 - height / 2
            width: 100
            height: 64
            Image {
                id:right_right_image
                width: 64
                height: 64
                anchors.centerIn: parent
                fillMode: Image.Stretch
                source: "qrc:/dialog/images/triangle_right.png"
            }
            Text{
                id:right_right_text
                width: 64
                height: 64
                verticalAlignment: Text.AlignVCenter
                anchors.left: parent.left
                anchors.leftMargin: (parent.width - right_right_image.width) / 2 + 10
                color: "#ffffff"
                text:offset.toString()
                font.pointSize: 15
            }
            style: Rectangle{
                width: right_right.width
                height: right_right.height
                color: right_right.pressed ? "#d9ebf9":"#fafafa"
            }
            onClicked: {
                changeCalibrationData(right_direction,offset - 2 * offset);
            }
        }

        ToolButton{
            id:right_left
            visible: true
            x:rightDrawArea.x -  (width + defaultMargin)
            y:rightDrawArea.y + rightDrawArea.height / 2 - height / 2
            width: 100
            height: 64

            Image {
                id:right_left_image
                width: 64
                height: 64
                anchors.centerIn: parent
                fillMode: Image.Stretch
                source: "qrc:/dialog/images/triangle_left.png"
            }
            Text{
                id:right_left_text
                width: 64
                height: 64
                verticalAlignment: Text.AlignVCenter
                anchors.right: parent.right
                anchors.rightMargin: (parent.width - right_left_image.width) / 2 + 10
                horizontalAlignment: Text.AlignRight
                color: "#ffffff"
                text:offset.toString()
                font.pointSize: 15
            }
            style: Rectangle{
                width: right_left.width
                height: right_left.height
                color: right_left.pressed ? "#d9ebf9":"#fafafa"
            }
            onClicked: {
                changeCalibrationData(right_direction,offset);
            }
        }

        Rectangle{
            id:upDrawArea
            visible: true
            x:parent.width / 4
            y:parent.height / 8
//            y:parent.height / 8
            width:parent.width / 2
            height: parent.height / 8 + 50
            border.width: 1
            border.color: "#a5a5a5"
            color: "#fafafa"
            MultiPointTouchArea{
                id:upTouchPoint
                anchors.fill: parent
                enabled: true
                mouseEnabled: false
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
                    upPlaceholderStr = ""
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
            Text {
                id: upPlaceholder
                anchors.top: parent.top
                anchors.left: parent.left
                anchors.leftMargin: 5
                anchors.right: parent.right
                anchors.rightMargin: 5
                anchors.bottom: parent.bottom
                color: "#7f7f7f"
                text: upPlaceholderStr
                lineHeight: 1.5
                font.pointSize: 12
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
                wrapMode: Text.Wrap
            }

        }
        ToolButton{
            id:up_down
            visible: true
            x:upDrawArea.x + upDrawArea.width / 2 - width / 2
            y:upDrawArea.y + upDrawArea.height + defaultMargin
            width: 64
            height: 100
            Image {
                id:up_down_image
                width: 64
                height: 64
                anchors.centerIn: parent
                fillMode: Image.Stretch
                source: "qrc:/dialog/images/triangle_down.png"
            }
//            Text{
//                id:up_down_text
//                anchors.top: up_down_image.bottom
//                text:offset.toString() + " *"
//                anchors.horizontalCenter: parent.horizontalCenter
//                font.pointSize: 15
//                rotation: 270
//            }
            Text{
                id:up_down_text
                width: 64
                height: 64
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignTop
                anchors.top: parent.top
                anchors.topMargin: (parent.height - up_down_image.height) / 2 + 10
                color: "#ffffff"
                text:offset.toString()
                font.pointSize: 15
            }
            style: Rectangle{
                width: up_down.width
                height: up_down.height
                color: up_down.pressed ? "#d9ebf9":"#fafafa"
            }
            onClicked: {
                changeCalibrationData(up_direction,offset - 2 * offset);
            }
        }

        ToolButton{
            id:up_up
            visible: true
            x:upDrawArea.x + upDrawArea.width / 2 - width / 2
            y:upDrawArea.y - (height + defaultMargin)
            width: 64
            height: 100
//            Text{
//                id:up_up_text
//                anchors.bottom: up_up_image.top
//                anchors.horizontalCenter: parent.horizontalCenter
//                text:"* " + offset.toString()
//                font.pointSize: 15
//                rotation: 270
//            }
            Image {
                id:up_up_image
                width: 64
                height: 64
                anchors.centerIn: parent
                fillMode: Image.Stretch
                source: "qrc:/dialog/images/triangle_up.png"
            }
            Text{
                id:up_up_text
                width: 64
                height: 64
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignBottom
                anchors.bottom: parent.bottom
                anchors.bottomMargin: (parent.height - up_up_image.height) / 2 + 10
                color: "#ffffff"
                text:offset.toString()
                font.pointSize: 15
            }
            style: Rectangle{
                width: up_up.width
                height: up_up.height
                color: up_up.pressed ? "#d9ebf9":"#fafafa"
            }
            onClicked: {
                changeCalibrationData(up_direction,offset);
            }
        }


        Rectangle{
            id:downDrawArea
            visible: true
            x:upDrawArea.x
            y:leftDrawArea.y + leftDrawArea.height
            width:upDrawArea.width
            height: upDrawArea.height
            border.width: 1
            border.color: "#a5a5a5"
            color: "#fafafa"
            MultiPointTouchArea{
                id:downTouchPoint
                anchors.fill: parent
                enabled: true
                mouseEnabled: false
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
                    downPlaceholderStr = ""
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
            Text {
                id: downPlaceholder
                anchors.top: parent.top
                anchors.left: parent.left
                anchors.leftMargin: 5
                anchors.right: parent.right
                anchors.rightMargin: 5
                anchors.bottom: parent.bottom
                color: "#7f7f7f"
                text: downPlaceholderStr
                lineHeight: 1.5
                font.pointSize: 12
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
                wrapMode: Text.Wrap
            }
        }
        ToolButton{
            id:down_down
            visible: true
            x:downDrawArea.x + downDrawArea.width / 2 - width / 2
            y:downDrawArea.y + downDrawArea.height + defaultMargin
            width: 64
            height: 100
            Image {
                id:down_down_image
                width:64
                height: 64
                anchors.centerIn: parent
                fillMode: Image.Stretch
                source: "qrc:/dialog/images/triangle_down.png"
            }
//            Text{
//                id:down_down_text
//                anchors.top: down_down_image.bottom
//                anchors.horizontalCenter: parent.horizontalCenter
//                text:offset.toString() + " *"
//                font.pointSize: 15
//                rotation: 270
//            }
            Text{
                id:down_down_text
                width: 64
                height: 64
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignTop
                anchors.top: parent.top
                anchors.topMargin: (parent.height - down_down_image.height) / 2 + 10
                color: "#ffffff"
                text:offset.toString()
                font.pointSize: 15
            }
            style: Rectangle{
                width: down_down.width
                height: down_down.height
                color: down_down.pressed ? "#d9ebf9":"#fafafa"
            }
            onClicked: {
                changeCalibrationData(down_direction,offset - 2 * offset);
            }
        }


        ToolButton{
            id:down_up
            visible: true
            x:downDrawArea.x + downDrawArea.width / 2 - width / 2
            y:downDrawArea.y - (height + defaultMargin)
            width: 64
            height: 100
            Image {
                id:down_up_image
                width: 64
                height: 64
//                anchors.bottom: parent.bottom
                anchors.centerIn: parent
                fillMode: Image.Stretch
                source: "qrc:/dialog/images/triangle_up.png"
            }
//            Text{
//                id:down_up_text
//                anchors.bottom: down_up_image.top
//                anchors.horizontalCenter: parent.horizontalCenter
//                text:"* " + offset.toString()
//                font.pointSize: 15
//                rotation: 270
//            }
            Text{
                id:down_up_text
                width: 64
                height: 64
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignBottom
                anchors.bottom: parent.bottom
                anchors.bottomMargin: (parent.height - down_up_image.height) / 2 + 10
                color: "#ffffff"
                text:offset.toString()
                font.pointSize: 15
            }
            style: Rectangle{
                width: down_up.width
                height: down_up.height
                color: down_up.pressed ? "#d9ebf9":"#fafafa"
            }
            onClicked: {
                changeCalibrationData(down_direction,offset);
            }
        }

        //中间位置
        Rectangle{
            id:midTextRect
            visible: true
            x:left_right.x + left_right.width + 10
            y:up_down.y + up_down.height + 10
            width: right_left.x - x - 10
            height: down_up.y - y - 10
            color: "#fafafa"

            property int fineTuneComboBoxHeight:60
            property int btnWidth:180
            ToolButton
            {
                id:exitBtn
                x:parent.width / 2 - width
                y:parent.height / 2 - height
                width: parent.btnWidth
                height: parent.fineTuneComboBoxHeight

                tooltip: qsTr("Exit the fine-tuning interface.")

                style:ButtonStyle{
                    background: Rectangle{
                        width: exitBtn.width
                        height: exitBtn.height
                        color: exitBtn.pressed ? "#d9ebf9":"#f0f0f0"
                    }
                    label: Text{
                        verticalAlignment: Text.AlignVCenter
                        horizontalAlignment: Text.AlignHCenter
                        font.pointSize: 14
                        text:qsTr("exit")
                    }

                }
                onClicked:
                {
                    clearCanvas();
                    exitTune();
                }
            }
            ToolButton
            {
                id:clearBtn
                x:exitBtn.x + exitBtn.width + 5
                y:exitBtn.y
                width: parent.btnWidth
                height: parent.fineTuneComboBoxHeight
                tooltip: qsTr("Clear line trace.")

                style:ButtonStyle{
                    background: Rectangle{
                        width: clearBtn.width
                        height: clearBtn.height
                        color: clearBtn.pressed ? "#d9ebf9":"#f0f0f0"
                    }
                    label: Text{
    //                    width: clearBtn.width
    //                    height: clearBtn.height
                        verticalAlignment: Text.AlignVCenter
                        horizontalAlignment: Text.AlignHCenter
                        font.pointSize: 14
                        text:qsTr("clear")
                    }

                }
                onClicked:
                {
                    clearCanvas();
                }
            }
            Text {

                id: offestText
                width: parent.btnWidth
                height: parent.fineTuneComboBoxHeight
                x:exitBtn.x
                y:exitBtn.y + exitBtn.height + 5
                verticalAlignment: Text.AlignVCenter
                horizontalAlignment: Text.AlignRight
                text: qsTr("offest:")
                font.pointSize: 14
            }
            MyComboBox{
                id:fineTuneId
                visible: true
                width: parent.btnWidth
                height: parent.fineTuneComboBoxHeight
                anchors.top: exitBtn.bottom
                anchors.topMargin: 5
                anchors.left: offestText.right
                anchors.leftMargin: 5
                itemWidth: parent.btnWidth - parent.fineTuneComboBoxHeight
                itemHeight: parent.fineTuneComboBoxHeight
                defCurrentIndex: 2
                chosenItemTextStr:"5"
                itemsModel: itemsModel
                onComboClicked:
                {
                    offset = itemsModel.get(comboBox.selectedIndex).text;
                }
                onVisibleChanged:
                {
                    if(visible)
                    {
                        if(itemsModel.count === 0)
                        {
                            itemsModel.insert(0,{"text":"10"})
                            itemsModel.insert(0,{"text":"5"})
                            itemsModel.insert(0,{"text":"2"})
                            itemsModel.insert(0,{"text":"1"})
                        }
                        chosenItemTextStr = itemsModel.get(2).text;
                    }
                }
            }


        }
        //显示四个校准点的数据：

        Text{
            x:leftDrawArea.x
            y:upDrawArea.y
            width: leftDrawArea.width - defaultMargin
            height: upDrawArea.height - defaultMargin
            horizontalAlignment: Text.AlignRight
            verticalAlignment: Text.AlignBottom
            text:"(" + point0X + "," + point0Y + ")"
            font.pointSize: 14
        }
        Text{
            x:rightDrawArea.x + defaultMargin
            y:upDrawArea.y
            width: rightDrawArea.width - defaultMargin
            height: upDrawArea.height - defaultMargin
            horizontalAlignment: Text.AlignLeft
            verticalAlignment: Text.AlignBottom
            text:"(" + point1X + "," + point1Y + ")"
            font.pointSize: 14
        }
        Text{
            x:leftDrawArea.x
            y:leftDrawArea.y + leftDrawArea.height +defaultMargin
            width: leftDrawArea.width - defaultMargin
            height: downDrawArea.height - defaultMargin
            horizontalAlignment: Text.AlignRight
            verticalAlignment: Text.AlignTop
            text:"(" + point2X + "," + point2Y + ")"
            font.pointSize: 14
        }
        Text{
            x:downDrawArea.x + downDrawArea.width + defaultMargin
            y:downDrawArea.y + defaultMargin
            width: rightDrawArea.width - defaultMargin
            height: downDrawArea.height - defaultMargin
            horizontalAlignment: Text.AlignLeft
            verticalAlignment: Text.AlignTop
            text:"(" + point3X + "," + point3Y + ")"
            font.pointSize: 14
        }

    }

    ListModel{
        id:itemsModel
    }



    function initPointData()
    {
        var tryCount = 3;
        var datas;
        do{
            datas = touch.getCalibrationDatas(1);
            tryCount--;
        }while((datas.count === undefined || datas.count <= 0) && tryCount > 0);
        var points = datas.points;
        point0X = points[0].collectX;
        point0Y = points[0].collectY;
        point1X = points[1].collectX;
        point1Y = points[1].collectY;
        point2X = points[2].collectX;
        point2Y = points[2].collectY;
        point3X = points[3].collectX;
        point3Y = points[3].collectY;

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

        leftPlaceholderStr = qsTr("Please draw a vertical line in this box to detect the offset position, and then click the left and right buttons to adjust.")
        rightPlaceholderStr = qsTr("Please draw a vertical line in this box to detect the offset position, and then click the left and right buttons to adjust.")
        upPlaceholderStr = qsTr("Please draw a horizontal line in this box to detect the offset position, and then click the up and down buttons to adjust.")
        downPlaceholderStr = qsTr("Please draw a horizontal line in this box to detect the offset position, and then click the up and down buttons to adjust.")
    }
    function changeCalibrationData(direction,value)
    {
//        touch.tPrintf("校准数据加减 value = " + value);
        var datas = touch.getCalibrationDatas(1);
        touch.debug(JSON.stringify(datas));
        if (datas.count === undefined || datas.count <= 0 || direction > datas.count)
            return;
        var i;
        var points = datas.points;
        switch(direction)
        {
        case left_direction:
            points[0].collectX += value;
            point0X += value;
            points[2].collectX += value;
            point2X += value;
            break;
        case right_direction:

            points[1].collectX += value;
            point1X += value;
            points[3].collectX += value;
            point3X += value;
            break;
         case up_direction:

             points[0].collectY += value;
             point0Y += value;
             points[1].collectY += value;
             point1Y += value;
             break;
         case down_direction:
             points[2].collectY += value;
             point2Y += value;
             points[3].collectY += value;
             point3Y += value;
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
