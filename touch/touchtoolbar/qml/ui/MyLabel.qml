import QtQuick 2.2
import QtQuick.Controls 1.4


Item {
    id: root

    property string textStr:""
    property int fontSize:10

//    width: 300
//    height: 900

    TextArea {
        id: lbl_name_show
        visible: true
        anchors.fill: parent
        anchors.top: parent.top
        anchors.topMargin: 5
        anchors.left: parent.left
        anchors.leftMargin: defaultMargin
        anchors.verticalCenter: parent.verticalCenter
        verticalScrollBarPolicy: Qt.ScrollBarAlwaysOff
        antialiasing: true          //是否抗锯齿
        readOnly: true
        frameVisible : false        //去掉边框
        backgroundVisible : false   //去掉背景
        text:textStr
        font.pointSize: fontSize
        textFormat: Text.AutoText
        textMargin: 1.5

    }


}
