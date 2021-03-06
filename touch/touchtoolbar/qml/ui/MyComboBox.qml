import QtQuick 2.0

Item {
    property int itemWidth:100
    property int itemHeight:30
    property var items:["2","1","5","10"]
    signal comboClicked;
    Rectangle {
            id:comboBox
//            property variant items: ["1","2","5","10"]
            property alias selectedItem: chosenItemText.text;
            property alias selectedIndex: listView.currentIndex;

            width: itemWidth + itemHeight
            height: itemHeight


            Rectangle {
                id:chosenItem
                width:parent.width;
                height:comboBox.height;
//                color:"#cccccc"
                border.color:"#cccccc"
                border.width: 1
                Text {
                    width:itemWidth - 10
                    height: itemHeight
                    anchors.left: parent.left
                    anchors.top: parent.top
                    anchors.leftMargin: 5
                    anchors.right: dropdown.left
                    anchors.rightMargin: 5
                    id:chosenItemText
                    text:items[0]
                    font.pointSize: 14
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
                    }
                }
            }

            Rectangle {
                id:dropDown
                width:comboBox.width;
                height:0;
                clip:true;
                anchors.top: chosenItem.bottom;
                color:"#f0f0f0"

                ListView {
                    id:listView
                    height:500
                    model: items
                    currentIndex: 0
                    delegate: Item{
                        width:comboBox.width;
                        height: comboBox.height;

                        Text {
//                            anchors.centerIn: parent
                            anchors.left: parent.left
                            anchors.leftMargin: 5
                            text: modelData
                            font.pointSize: 14
                            elide:Text.ElideLeft
                        }
                        MouseArea {
                            anchors.fill: parent;
                            onClicked: {
                                comboBox.state=""
                                var prevSelection=chosenItemText.text
                                chosenItemText.text=modelData
                                if(chosenItemText.text !=prevSelection){
                                    comboClicked();
                                }
                                listView.currentIndex=index;
                            }
                        }
                    }
                }
            }

//            Component {
//                id: highlight
//                Rectangle {
//                    width:comboBox.width;
//                    height:comboBox.height;
//                    color:"red";
//                    radius: 4
//                }
//            }

            states: State {
                name:"dropDown";
                PropertyChanges { target: dropDown; height:itemHeight*items.length }
            }

            transitions: Transition {
                NumberAnimation { target: dropDown; properties:"height"; easing.type: Easing.OutExpo; duration: 250 }
            }
        }
    }
