import QtQuick 2.5
import QtQuick.Window 2.2
import QtQuick.Layouts 1.3

import QtQuick.Dialogs 1.1
import "qrc:/"
import "qrc:/qml/ui/"

Item {
    id:batchPage
    property int deviceCount: 40
    property int columns: 8
    property int rows: 5
    property int itemWidth: width / columns
    property int itemHeigth: height / rows
    property int passAgingTime: 15
    property var deviceModel:deviceModel
    visible: true

    function getDeviceCount() {
        return deviceCount;
    }
    function getDeviceStatus(dev)
    {
        return deviceModel.get(dev).deviceStatus;
    }
    function setDeviceStatus(dev, status) {
        deviceModel.get(dev).deviceStatus = status;
    }
    function setDeviceMcdId(dev,mcu)
    {
        deviceModel.get(dev).mcuID = mcu;
    }
    function getDeviceMcdId(dev)
    {
        return deviceModel.get(dev).mcuID;
    }
    function setDeviceProgress(dev,progress)
    {
        deviceModel.get(dev).inProgress  = progress;
    }
    function setDeviceInfo(dev,info)
    {
        deviceModel.get(dev).info = info;
    }
    function setDeviceResult(dev,result)
    {
        deviceModel.get(dev).result = result;
    }
    function getDeviceResult(dev)
    {
        return deviceModel.get(dev).result;
    }
    function setDeviceBootloader(dev,bool)
    {
        deviceModel.get(dev).bootloader = bool;
    }
    function getDeviceBootloader(dev)
    {
        return deviceModel.get(dev).bootloader;
    }
    function getDeviceTime(dev)
    {
        return deviceModel.get(dev).time;
    }
    function setDeviceTime(dev,time)
    {
        deviceModel.get(dev).time = time;
    }
    signal agingFinished(int index);

    /**
      * deviceStatus:
      * 0: default, no device
      * 1: connected
      * 2: disconnected
      * 3: error
      * 4: finished
      */
    property int deviceNc: 0
    property int deviceConnected: 1
    property int deviceDisconnected: 2
    property int deviceError: 3

    //批处理的结果
    /*
      result:
      batchResult                   : default
      deviceFinished                : aging finish
      batchSuccess  or batchError   : upgrade and test result
      batchRunning                  : upgrade and test is running
    */
    property int batchResult:0
    property int deviceFinished: 1
    property int batchSuccess:2
    property int batchError:3
    property int batchRunning:4
    property int batchCancel:5


    property int defaultMargin: 10
    property var timeFlag : []
    /*
      functionIndex:
      0:加速老化
      1：升级
      2：测试
    */
    property int functionAging:0
    property int functionUpgrade:1
    property int functionTest:2

    property int functionIndex:functionAging
    signal setFunctionIndex(int index);
    property Item deviceItem:deviceItem

    onSetFunctionIndex: {
        console.log("切换功能：" + index);
        functionIndex = index;
    }

    Component {
        id: deviceDelegate;
        Item {
            id: deviceItem
//            property color cNc: "#263238"
//            property color cConnected: "#64DD17"
//            property color cDisconnected: "#FDD835"
//            property color cError: "#FF3D00"
//            property color cFinished: "#FFFFFF"
            property color cNc: "#FF3D00"
            property color cConnected: "#FF3D00"
            property color cDisconnected: "#FF3D00"
            property color cError: "#FF3D00"
            property color cFinished: "#64DD17"

            property var hour : parseInt(passAgingTime / (60 * 60))
            property var minute : parseInt((passAgingTime - (60 * 60 * hour)) / 60)
            property int second : passAgingTime % 60
            property var totalTime : prefixInteger(hour, 2) + ":" + prefixInteger(minute,2) + ":" + prefixInteger(second,2)
        Rectangle {
            width: itemWidth
            height: itemHeigth
            color: "#272822"
            border.width: 1
            border.color: "#007F00"

            Column {
                anchors.left: parent.left
                anchors.leftMargin: defaultMargin
                anchors.rightMargin: defaultMargin
                Text {

                    font.pixelSize: itemWidth / 10
                    text: "#" + number + "# " +
                          (deviceStatus === deviceConnected ? (functionIndex === functionAging) ? qsTr("accelerated aging"):(functionIndex === functionUpgrade ? qsTr("Upgrade"):qsTr("Test")):
                                                    (deviceStatus === deviceDisconnected ?  qsTr("disconnected") :
                                                    (deviceStatus === deviceError ? qsTr("device error") :"")))
//                    text:deviceItem.textOneLineStr
                    color: (result === deviceFinished ? cFinished :
                           (result ===  batchSuccess? cFinished :
                           (result ===  batchError? cError :
                           (result ===  batchCancel? cError :cConnected))))
                }
                Text{
                    font.pixelSize: itemWidth / 10
//                    text:((deviceStatus === deviceConnected || deviceStatus === deviceFinished)? (qsTr("total time:") + totalTime):" ")
                    text:((deviceStatus === deviceConnected || inProgress !== 0)? (functionIndex === 0) ? (qsTr("total time:") + totalTime) : qsTr("Progress: ") + inProgress + "%":" ")
//                    text:deviceItem.textTwoLineStr
                    color: (result === deviceFinished ? cFinished :
                           (result ===  batchSuccess? cFinished :
                           (result ===  batchError? cError :
                           (result ===  batchCancel? cError :"red"))))
                }
                Text {
//                    font.pointSize: (result ===  batchSuccess ||
//                                                 result === deviceFinished || functionIndex === functionAging)? 10:8
                    font.pixelSize: itemWidth / 10
                    text: info
                    wrapMode: Text.Wrap
                    color: (result === deviceFinished ? cFinished :
                           (result ===  batchSuccess? cFinished :
                           (result ===  batchError? cError :
                           (result ===  batchCancel?cError:cConnected))))
                }

            }


        }
        onVisibleChanged: {
        }

        }

    }
    ColumnLayout{
        anchors.fill: parent

        Item {
            id:agingItem
            Layout.fillHeight: true
            Layout.fillWidth: true
            anchors.bottomMargin: defaultMargin
            GridView {
                anchors.fill: parent
                cellWidth: itemWidth
                cellHeight: itemHeigth
                model: DeviceModel {
                    id: deviceModel
                    count: deviceCount
                }
                delegate: deviceDelegate
            }
        }
    }

    function startAging() {
        countdown.start();
        console.log("start aging")
    }

    function stopAging() {
        console.log("################stop aging, clear models");
//        timeFlag = true;
        countdown.stop();
        
        for (var i = 0; i < deviceCount; i++) {

            var model = deviceModel.get(i);
            model.time = 0;
//            model.deviceStatus = deviceNc;
            model.info = "";
            model.result = batchCancel;
        }
    }

    Timer{
        id:countdown
        interval: 1000
        repeat: true
        running: false
        triggeredOnStart: false
        onTriggered: {
//            console.log("time triggered")
            var model;

            for (var i = 0; i < deviceCount; i++) {
                model = deviceModel.get(i);

                //console.log("#" + i + " status: " + model.deviceStatus + " time: " + model.time)
                if (model && model.deviceStatus === deviceConnected) {
//                    console.log("#序号 = " + i + " status: " + model.deviceStatus + " time: " + model.time)
                    if(timeFlag[i])
                    {
                        model.time = passAgingTime;
                        timeFlag[i] = false;
                    }
                    else
                    {
                        if(model.time === 0)
                            continue;
                        model.time -= 1;
                    }


                    var hour = parseInt(model.time / (60 * 60));
                    var minute = parseInt((model.time - (60 * 60 * hour)) / 60);
                    var second = model.time % 60;
                    model.info = prefixInteger(hour, 2) + ":" + prefixInteger(minute,2) + ":" + prefixInteger(second,2);
//                    console.log(hour + ":" + minute + ":" + second + " pass:" + passAgingTime);
                    if (model.time <= 0) {
                        model.result = deviceFinished;
                        agingFinished(i);
                        timeFlag[i] = false;
                    }
                }
            }

        }

    }
    function prefixInteger(num, n) {
        return (new Array(n).join(0) + num).slice(-n);
    }

}
