import QtQuick 2.0
import QtQuick.Layouts 1.1
import QtQuick.Controls 1.4
import QtQuick.Controls.Styles 1.4

Item {

    property int defaultMargin: 10
    property int defaultCtrlHeight:50
    property int defaultCtrlWidth:130
    property int defaultBtnHeight:50

    //分别对应0、1、2、3 这四边的边缘拉伸参数
    property Item no_0_editText:no_0_editText
    property Item no_1_editText:no_1_editText
    property Item no_2_editText:no_2_editText
    property Item no_3_editText:no_3_editText

    //边缘拉伸的按钮
    property Item enterEdgeStrechBtn:enterEdgeStrechBtn
    property Item refreshEdgeStrechBtn:refreshEdgeStrechBtn
    property Item settingEdgeStrechBtn:settingEdgeStrechBtn
    property Item factoryResetEdgeStrech:factoryResetEdgeStrech

    signal enterEdgeStrech();
    Rectangle{
        anchors.fill: parent
        anchors.top: parent.top
        anchors.left: parent.left

        //边缘拉伸按钮
        Rectangle{
            id:edgeStrechButtonRect
            anchors.top: parent.top
            anchors.left: parent.left
            width: parent.width
            height: defaultBtnHeight
            RowLayout{
                anchors.fill: parent
                MyButton{
                    id:enterEdgeStrechBtn
                    defaultHeight: defaultBtnHeight
                    textStr: qsTr("Edge strech")
                    imageSource:"qrc:/dialog/images/edge_strech.png"
                    tooltipStr:qsTr("Enter the edge stretch interface.")
                    onClicked: {
                        enterEdgeStrech();
                    }
                }
                MyButton{
                    id:refreshEdgeStrechBtn
                    defaultHeight: defaultBtnHeight
                    anchors.left: enterEdgeStrechBtn.right
                    anchors.leftMargin: defaultMargin
                    textStr: qsTr("Refresh")
                    tooltipStr: qsTr("Refresh edge stretch value.")
                    imageSource:"qrc:/dialog/images/refresh_blue.png"
                    onClicked: {
                        getEdgeStrechVal(0)
                        showToast(qsTr("Refresh success"));
                    }
                }
                MyButton{
                    id:settingEdgeStrechBtn
                    defaultHeight: defaultBtnHeight
                    anchors.left: refreshEdgeStrechBtn.right
                    anchors.leftMargin: defaultMargin
                    textStr: qsTr("Apply")
                    imageSource:"qrc:/dialog/images/setting_blue.png"
                    tooltipStr:qsTr("Set the edge stretch value to the firmware.")
                    onClicked: {
                        setEdgeStrechVal();
                        showToast(qsTr("Setting success"));
                    }
                }

                MyButton{
                    id:factoryResetEdgeStrech
                    defaultHeight: defaultBtnHeight
                    anchors.left: settingEdgeStrechBtn.right
                    anchors.leftMargin: defaultMargin
                    textStr: qsTr("Factory reset")
                    tooltipStr: qsTr("Restore factory edge stretch value.")
                    imageSource: "qrc:/dialog/images/restort_blue.png"

                    onClicked: {
                        getEdgeStrechVal(1);
                    }
                }
            }

        }
        //显示边缘拉伸的参数
        Rectangle{
            id:edgeStrechTextRect
            anchors.top: edgeStrechButtonRect.bottom
            anchors.topMargin: defaultMargin
            anchors.left: parent.left
            width:parent.width
            height: defaultCtrlHeight
            Text{
                id:edgeStretchText
                height: parent.height
                width: 250
                text:qsTr("Number:")
                font.pointSize: 14
                verticalAlignment: Text.AlignVCenter
                horizontalAlignment: Text.AlignLeft
            }
            Text{
                id:no_0_Text
                text:qsTr("0")
//                font.bold: true
                font.pixelSize: height
                height:parent.height - defaultMargin
                width: defaultCtrlWidth
                verticalAlignment: Text.AlignVCenter
                horizontalAlignment: Text.AlignHCenter
                anchors.top: parent.top
                anchors.left: edgeStretchText.right
                anchors.leftMargin: defaultMargin
            }
            Text{
                id:no_1_Text
                text:qsTr("1")
//                font.bold: true
                font.pixelSize: height
                height: parent.height - defaultMargin
                width: defaultCtrlWidth
                verticalAlignment: Text.AlignVCenter
                horizontalAlignment: Text.AlignHCenter
                anchors.top: parent.top
                anchors.left: no_0_Text.right
                anchors.leftMargin: defaultMargin
            }
            Text{
                id:no_2_Text
                text:qsTr("2")
//                font.bold: true
                font.pixelSize: height
                height: parent.height - defaultMargin
                width: defaultCtrlWidth
                verticalAlignment: Text.AlignVCenter
                horizontalAlignment: Text.AlignHCenter
                anchors.top: parent.top
                anchors.left: no_1_Text.right
                anchors.leftMargin: defaultMargin
            }
            Text{
                id:no_3_Text
                text:qsTr("3")
//                font.bold: true
                font.pixelSize: height
                height: parent.height - defaultMargin
                width: defaultCtrlWidth
                verticalAlignment: Text.AlignVCenter
                horizontalAlignment: Text.AlignHCenter
                anchors.top: parent.top
                anchors.left: no_2_Text.right
                anchors.leftMargin: defaultMargin
            }
        }

        Rectangle{
            id:edgeStrechCtrlRect
            anchors.top: edgeStrechTextRect.bottom
            anchors.topMargin: 5
            anchors.left: parent.left
            width:parent.width
            height: defaultCtrlHeight

            RowLayout{
                anchors.fill: parent
                Text{
                    Layout.preferredHeight: parent.height
                    Layout.preferredWidth: 250
                    text:qsTr("Edge stretch value:")
                    font.pointSize: 14
                    verticalAlignment: Text.AlignVCenter
                    horizontalAlignment: Text.AlignLeft
                }
                EditText {
                    id:no_0_editText
                    Layout.preferredWidth: defaultCtrlWidth
                    Layout.preferredHeight: defaultCtrlHeight
                    anchors.left: parent.left
                    anchors.leftMargin: 250 + defaultMargin
                    defaultHeight: 40
                    onTextChanged:
                    {
//                        console.log("0号当前的值为：" + text);
                    }
                }
                EditText {
                    id:no_1_editText
                    Layout.preferredWidth: defaultCtrlWidth
                    Layout.preferredHeight: defaultCtrlHeight
                    anchors.left: no_0_editText.right
                    anchors.leftMargin: defaultMargin
                    defaultHeight: 40
                    onTextChanged:
                    {
//                        console.log("1号当前的值为：" + text);
                    }
                }
                EditText {
                    id:no_2_editText
                    Layout.preferredWidth: defaultCtrlWidth
                    Layout.preferredHeight: defaultCtrlHeight
                    anchors.left: no_1_editText.right
                    anchors.leftMargin: defaultMargin
                    defaultHeight: 40
                    onTextChanged:
                    {
//                        console.log("2号当前的值为：" + text);
                    }
                }
                EditText {
                    id:no_3_editText
                    Layout.preferredWidth: defaultCtrlWidth
                    Layout.preferredHeight: defaultCtrlHeight
                    anchors.left: no_2_editText.right
                    anchors.leftMargin: defaultMargin
                    defaultHeight: 40
                    onTextChanged:
                    {
//                        console.log("3号当前的值为：" + text);
                    }
                }

            }

        }


    }

    function getEdgeStrechVal(initVal)
    {
        var datas = touch.getEdgeStrechVal(initVal);
        no_0_editText.textField.text = datas["edgeStrech0"];
        no_1_editText.textField.text = datas["edgeStrech1"];
        no_2_editText.textField.text = datas["edgeStrech2"];
        no_3_editText.textField.text = datas["edgeStrech3"];
        touch.tPrintf("获取边缘拉伸的值：" + datas["edgeStrech0"] + "," + datas["edgeStrech1"] + "," + datas["edgeStrech2"] + "," + datas["edgeStrech3"])
    }
    function setEdgeStrechVal()
    {
        var edgeStrechVal = [];
        edgeStrechVal[0] = no_0_editText.textField.text;
        edgeStrechVal[1] = no_1_editText.textField.text;
        edgeStrechVal[2] = no_2_editText.textField.text;
        edgeStrechVal[3] = no_3_editText.textField.text;
        touch.setEdgeStrechVal(edgeStrechVal);
    }


}
