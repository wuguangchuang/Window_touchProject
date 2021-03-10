import QtQuick 2.7

Item {
    property int itemWidth:100
    property int itemHeight:30
//    property var items:[1,2,5,10]
    property Item comboBox:comboBox
    property var itemsModel
    property int defCurrentIndex:0
    property string chosenItemTextStr:""
    property Item chosenItemText:chosenItemText
    property Item listView : listView


    signal comboClicked;
    signal showCombox(bool val);
    Rectangle {
        id:comboBox
        property string selectedItem: chosenItemText.text;
        property int selectedIndex: listView.currentIndex;

        width: itemWidth + itemHeight
        height: itemHeight


        Rectangle {
            id:chosenItem
            width:parent.width;
            height:comboBox.height;
            border.color:"gray"
            border.width: 1
            Text {

                id:chosenItemText
                text:chosenItemTextStr
                font.pointSize: 14
                anchors.fill: parent
                verticalAlignment:Text.AlignVCenter
                anchors.left: parent.left
                anchors.leftMargin: 5
                elide:Text.ElideLeft
                smooth:true
            }
            Image {
                id: dropdown
                height: itemHeight / 3
                width: itemHeight / 3
                anchors.top: parent.top
                anchors.topMargin: itemHeight / 3
                anchors.right:parent.right
                anchors.rightMargin: itemHeight / 3

                source: "qrc:/dialog/images/dropDown.png"
            }

            MouseArea {
                anchors.fill: parent;
                onClicked: {
                    comboBox.state=comboBox.state==="dropDown"?"":"dropDown"
                    if(comboBox.state === "dropDown")
                    {
                        showCombox(true);
                    }
                    else
                    {
                        showCombox(false);
                    }
                }
            }
        }

        Rectangle {
            id:dropDown
            width:comboBox.width;
            height:0;
            clip:true;
            anchors.top: chosenItem.bottom;
//                color:"#f0f0f0"

            ListView {
                id:listView
                height:1000
                model: itemsModel
                currentIndex: defCurrentIndex
                delegate: Rectangle{
                    width:comboBox.width;
                    height: comboBox.height;
                    property bool flag:false
                    color: flag ? "#d9ebf9" : "#f0f0f0"

                    Rectangle{
                        id:lineRect
                        anchors.left: parent.left
                        width: parent.width
                        height: 1
                        color: "#cdcdcd"
                        border.color: "#cdcdcd"
                        border.width: 1
                    }
                    Text {
                        id:listViewText
                        anchors.fill: parent
                        anchors.top: lineRect.bottom
                        anchors.left: parent.left
                        anchors.leftMargin: 5
                        verticalAlignment: Text.AlignVCenter
                        text: modelData
                        font.pointSize: 14
                        elide:Text.ElideLeft
                    }

                    MouseArea {
                        anchors.fill: parent;
                        hoverEnabled: true

                        onEntered: flag = true;
                        onExited:  flag = false;
                        onClicked: {
                            comboBox.state=""
                            var prevSelection=chosenItemText.text
                            chosenItemText.text = modelData;
                            listView.currentIndex=index;
                            if(chosenItemText.text !=prevSelection){
                                comboClicked();
                            }
                        }
                    }
                }
            }
        }
        //此属性保存该项目的可能状态列表。若要更改此项的状态，请将state属性设置为这些状态之一，
        //或将state属性设置为空字符串以将该项目恢复为其默认状态。
        states: State {
            name:"dropDown";
            PropertyChanges { target: dropDown; height:itemHeight*itemsModel.count}
        }

        //修改动画的显示时间
//        transitions: Transition {
//            NumberAnimation { target: dropDown; properties:"height"; easing.type: Easing.OutExpo; duration: 250 }
//        }
    }
//    ListModel{
//        id:itemsModel
//    }

}
