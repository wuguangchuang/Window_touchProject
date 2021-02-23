import QtQuick 2.0
import QtQuick.Controls 1.4 as Cont1
import QtQuick.Controls 1.2
import QtQuick.Controls 2.0
import QtQuick.Controls.Styles 1.4
import QtQuick.Layouts 1.3
Item {
    property int  defaultSpacing: 10
    property int labelWidth:200
    signal clickCalibration();
    signal clickFineTune();
    property var caliDataModel: null

    property var calibrationList:calibrationList
    property var caliDataDelegate: calibrationDataDelegate
    property var calibrationButtonRow:calibrationButtonRow
    property var  refreshBtn:refreshBtn

    ScrollView{
        anchors.fill: parent
        horizontalScrollBarPolicy: Qt.ScrollBarAlwaysOn
        ColumnLayout{

            RowLayout {
                id: calibrationButtonRow
                spacing: 10

                MyButton{
                    id:calibrationStartBtn
                    textStr: qsTr("calibration")
                    tooltipStr: qsTr("Enter the calibration interface to calibrate.")
                    imageSource:"qrc:/dialog/images/calibrate_blue.png"
                    clickBtn: 1
                    onClicked: {
                        clickCalibration();
                    }

                }
                MyButton{
                    id:fineTuneBtn
                    textStr: qsTr("fine tune")
                    tooltipStr: qsTr("Used to fine-tune calibration data.") + "\n" +
    qsTr("Click to enter the fine-tuning interface to draw line calibration.")
                    imageSource:"qrc:/dialog/images/tune.png"
                    clickBtn: 8
                    onClicked: {
                        clickFineTune();
                    }
                }
                MyButton{
                    id:refreshBtn
                    textStr: qsTr("refresh")
                    tooltipStr: qsTr("Refresh calibration data.")
                    imageSource:"qrc:/dialog/images/refresh_blue.png"
                    clickBtn: 2
                    onClicked: {
                        refreshCalibrationData();
                    }
                }

                MyButton{
                    id:setBtn
                    textStr: qsTr("set")
                    tooltipStr: qsTr("Apply the following calibration data to the firmware.")
                    imageSource:"qrc:/dialog/images/setting_blue.png"
                    clickBtn: 3
                    onClicked: {
                        showProgessing();
                        touch.setCalibrationDatas(createCalibrationData());
                        hideProgessing();var result = touch.saveCalibration();
                        if (result === false) {
                            showToast(qsTr("save data failure"));
                        } else {
                            showToast(qsTr("set success"));
                        }
                    }
                }

                MyButton{
                    id:saveBtn
                    textStr: qsTr("save")
                    tooltipStr: qsTr("Save the following calibration data to a local file.")
                    imageSource:"qrc:/dialog/images/save_blue.png"
                    clickBtn: 4
                    onClicked: {
                        calibrationfileDialog.mode = 1;
                        focus = true;
                        calibrationfileDialog.open();
                    }
                }

                MyButton{
                    id:readBtn
                    textStr: qsTr("read")
                    tooltipStr: qsTr("Read the calibration data in the local file and apply it to the firmware.")
                    imageSource:"qrc:/dialog/images/read_blue.png"
                    clickBtn: 5
                    onClicked: {
                        calibrationfileDialog.mode = 0;
                        focus = true;
                        calibrationfileDialog.open();
                    }
                }

                MyButton{
                    id:hidBtn
                    visible: false
                    tooltipStr: qsTr("Hide or show calibration data.")
                    textStr: calibrationList.visible === true ? qsTr("hide datas") : qsTr("show datas")
                    imageSource:calibrationList.visible === true ? "qrc:/dialog/images/hide_blue.png" : "qrc:/dialog/images/show_blue.png"
                    clickBtn: 6
                    onClicked: {
                        calibrationList.visible = !calibrationList.visible;
                        resetCalibrationData();
                    }
                }
                MyButton{
                    textStr: qsTr("factory reset")
                    tooltipStr: qsTr("Restore factory calibration data.")
                    imageSource: "qrc:/dialog/images/restort_blue.png"
                    clickBtn: 7
                    onClicked: {
                        showProgessing();
                        resetCalibrationData();
                        touch.saveCalibration();
                        hideProgessing();
                    }
                }
            }

            ListView {
                id: calibrationList
            //                    anchors.top: calibrationButtonRow.bottom
            //                    anchors.topMargin: 10
                anchors.left: parent.left
    //            anchors.leftMargin: labelView.width + 10
                Layout.preferredHeight: 53 * (mainPage.calibrationPoints + 1);
                Layout.preferredWidth: parent.width
    //            width: parent.width
    //            height: 260
                spacing: 15
                visible: true

                header: RowLayout {
                    Layout.preferredHeight:50
                    Layout.preferredWidth: parent.width

                    spacing: 15

                    Label {
                        topPadding: 10
                        bottomPadding: 15
                        text: qsTr("Number")
                        horizontalAlignment: Text.left
                        Layout.preferredWidth:calibrationTextWidth

                    }
                    Label {
                        topPadding: 10
                        bottomPadding: 15
                        text: qsTr("target point %1").arg("X")
                        horizontalAlignment: Text.Center
    //                    width: calibrationTextWidth
                        Layout.preferredWidth:calibrationTextWidth

                    }
                    Label {
                        topPadding: 10
                        bottomPadding: 15
                        text: qsTr("target point %1").arg("Y")
                        horizontalAlignment: Text.Center
    //                    width: calibrationTextWidth
                        Layout.preferredWidth:calibrationTextWidth

                    }
                    Label {
                        topPadding: 10
                        bottomPadding: 15
                        text: qsTr("collect point %1").arg("X")
                        horizontalAlignment: Text.Center
    //                    width: calibrationTextWidth
                        Layout.preferredWidth:calibrationTextWidth

                    }
                    Label {
                        topPadding: 10
                        bottomPadding: 15
                        text: qsTr("collect point %1").arg("Y")
                        horizontalAlignment: Text.Center
    //                    width: calibrationTextWidth
                        Layout.preferredWidth:calibrationTextWidth

                    }
                }

                delegate: caliDataDelegate
                model: caliDataModel
            }
        }
    }

       property real calibrationLabelHeight: 50
       property real calibrationTextWidth: 110
       Component {
           id: calibrationDataDelegate
           Row {
               spacing: 15
               Label {
                   text: "" + index
                   height: parent.implicitHeight
    //                height: calibrationLabelHeight
                   width: calibrationTextWidth
                   font.pixelSize: height
                   horizontalAlignment: Text.left
                   verticalAlignment: Text.Center
               }

               CaliTextEdit {
                   width: calibrationTextWidth
    //                height: calibrationLabelHeight
                   height: parent.implicitHeight
                   maxValue: maxX
                   onTextChanged:
                   {
                       console.log("changeTargetX = " + text);
                       targetX = text;
                       console.log("targetX = " + targetX);
                   }
                   value: targetX
               }
               CaliTextEdit {
                   width: calibrationTextWidth
    //                height: calibrationLabelHeight
                   height: parent.implicitHeight
                   maxValue: maxY
                   onTextChanged:
                   {
                       console.log("changeTargetY = " + text);
                       targetY = text;
                       console.log("targetY = " + targetX);
                   }
                   value: targetY
               }
               CaliTextEdit {
                   width: calibrationTextWidth
    //                height: calibrationLabelHeight
                   height: parent.implicitHeight
                   maxValue: maxX
                   onTextChanged: {
                       console.log("changeCollectX = " + text);
                       collectX = text;
                       console.log("collectX = " + collectX);
                   }
                   value: collectX

               }
               CaliTextEdit {
                   width: calibrationTextWidth
    //                height: calibrationLabelHeight
                   height: parent.implicitHeight
                   maxValue: maxY
                   onTextChanged: {
                       console.log("changeCollectY = " + text);
                       collectY = text;
                       console.log("collectY = " + collectY);
                   }
                   value: collectY

               }



           }
       }

}
