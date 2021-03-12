import QtQuick 2.0
import QtQuick.Layouts 1.1
import QtQuick.Controls 1.4
import QtQuick.Controls.Styles 1.4

Item {

    id:root
    signal exitEdgeStrech();

    property int defaultMargin:10
    property int defaultProgressSize:30
    property int buttonWidth:180
    property int buttonheight:50
    property int midRectWidth:parent.width / 2

    property int edgeStrech0:0
    property int edgeStrech1:0
    property int edgeStrech2:0
    property int edgeStrech3:0

    Rectangle{
        anchors.fill: parent

        color: "#fafafa"


        //0号板
        Rectangle{
            id:no_0_rect
            border.color: "gray"
            border.width: 1
            color: "#fafafa"
            width: parent.width - defaultProgressSize * 2 - defaultMargin * 2
            height: defaultProgressSize
            anchors.bottom: parent.bottom
            anchors.bottomMargin: defaultMargin
            anchors.left: parent.left
            anchors.leftMargin: defaultProgressSize + defaultMargin


        }
        Rectangle{
            anchors.left:parent.left
            anchors.leftMargin: parent.width / 2
            anchors.bottom: no_0_rect.top
            anchors.bottomMargin: defaultMargin
            height:40
            width: height
            radius: width / 2
            border.color: "gray"
            border.width: 1
            color: "#fafafa"
            Text{
                text:"0"
                font.pointSize: 14
                anchors.centerIn: parent
            }
        }
        //1号板
        Rectangle{
            id:no_1_rect
            border.color: "gray"
            border.width: 1
            color: "#fafafa"
            width: defaultProgressSize
            height: parent.height - defaultProgressSize * 2 - defaultMargin * 2
            anchors.right: parent.right
            anchors.rightMargin: defaultMargin
            anchors.top: parent.top
            anchors.topMargin: defaultProgressSize + defaultMargin

        }
        Rectangle{
            anchors.top:parent.top
            anchors.topMargin: parent.height / 2
            anchors.right: no_1_rect.left
            anchors.rightMargin: defaultMargin
            height:40
            width: height
            radius: width / 2
            border.color: "gray"
            border.width: 1
            color: "#fafafa"
            Text{
                text:"1"
                font.pointSize: 14
                anchors.centerIn: parent
            }
        }
        //2号板
        Rectangle{
            id:no_2_rect
            border.color: "gray"
            border.width: 1
            color: "#fafafa"
            width: parent.width - defaultProgressSize * 2 - defaultMargin * 2
            height: defaultProgressSize
            anchors.top: parent.top
            anchors.topMargin: defaultMargin
            anchors.left: parent.left
            anchors.leftMargin: defaultProgressSize + defaultMargin

        }
        Rectangle{
            anchors.top: no_2_rect.bottom
            anchors.topMargin: defaultMargin
            anchors.left: parent.left
            anchors.leftMargin: parent.width / 2
            height:40
            width: height
            radius: width / 2
            border.color: "gray"
            border.width: 1
            color: "#fafafa"
            Text{
                text:"2"
                font.pointSize: 14
                anchors.centerIn: parent
            }
        }
        //3号板
        Rectangle{
            id:no_3_rect
            border.color: "gray"
            border.width: 1
            color: "#fafafa"
            width: defaultProgressSize
            height: parent.height - defaultProgressSize * 2 - defaultMargin * 2
            anchors.left:parent.left
            anchors.leftMargin: defaultMargin
            anchors.top: parent.top
            anchors.topMargin: defaultProgressSize + defaultMargin

        }
        Rectangle{
            anchors.left: no_3_rect.right
            anchors.leftMargin: defaultMargin
            anchors.top: parent.top
            anchors.topMargin: parent.height / 2
            height:40
            width: height
            radius: width / 2
            border.color: "gray"
            border.width: 1
            color: "#fafafa"
            Text{
                text:"3"
                font.pointSize: 14
                anchors.centerIn: parent
            }
        }

        //中间显示提示信息的方框
        Rectangle{
            id:midRect
            border.color: "gray"
            border.width: 1
            color: "#fafafa"
            width: midRectWidth
            height: parent.height / 4
            anchors.top: parent.top
            anchors.topMargin: parent.height / 4
            anchors.left: parent.left
            anchors.leftMargin: (parent.width - midRectWidth) / 2

            Text{
                anchors.centerIn: parent
                text:"显示信息"
                font.pointSize: 18
            }
        }
        //边缘拉伸参数
        Rectangle{
            id:edgeStrechVal
            width: midRect.width
            height: 90
            color: "#fafafa"
            anchors.top: midRect.bottom
            anchors.topMargin: defaultMargin
            anchors.left: parent.left
            anchors.leftMargin: (parent.width - midRectWidth) / 2
            Text{
                id:edgeStrechText
                anchors.left: parent.left
                width: 250
                height:(parent.height -  defaultMargin) / 2
                text:qsTr("Edge stretch value:")
                font.pointSize: 14
                verticalAlignment: Text.AlignVCenter
                horizontalAlignment: Text.AlignLeft
            }
            Rectangle{
                id:mid_no_0
                anchors.top: parent.top
                anchors.left:edgeStrechText.right
                anchors.leftMargin: defaultMargin
                height:(parent.height -  defaultMargin) / 2
                width: height
                radius: width / 2
                border.color: "gray"
                border.width: 1
                color: "#fafafa"
                Text{
                    text:"0"
                    font.pointSize: 14
                    anchors.centerIn: parent
                }
            }
            Rectangle{
                id:mid_no_0_edit
                height:(parent.height -  defaultMargin) / 2
                width:120
                border.width: 1
                color: "#fafafa"
                anchors.left: mid_no_0.right
                anchors.leftMargin: defaultMargin
                anchors.top: parent.top
                Text{
                    anchors.fill: parent
                    font.pointSize: 14
                    text:edgeStrech0
                    anchors.left: parent.left
                    anchors.leftMargin: 5
                    verticalAlignment: Text.AlignVCenter

                }
            }

            Rectangle{
                id:mid_no_1
                anchors.top: parent.top
                anchors.left:mid_no_0_edit.right
                anchors.leftMargin: defaultMargin * 3
                height:(parent.height -  defaultMargin) / 2
                width: height
                radius: width / 2
                border.color: "gray"
                border.width: 1
                color: "#fafafa"
                Text{
                    text:"1"
                    font.pointSize: 14
                    anchors.centerIn: parent
                }
            }
            Rectangle{
                id:mid_no_1_edit
                height:(parent.height -  defaultMargin) / 2
                width:120
                border.width: 1
                color: "#fafafa"
                anchors.left: mid_no_1.right
                anchors.leftMargin: defaultMargin
                anchors.top: parent.top
                Text{
                    anchors.fill: parent
                    font.pointSize: 14
                    text:edgeStrech1
                    anchors.left: parent.left
                    anchors.leftMargin: 5
                    verticalAlignment: Text.AlignVCenter

                }
            }
            Rectangle{
                id:mid_no_2

                anchors.left:parent.left
                anchors.leftMargin: edgeStrechText.width + defaultMargin
                anchors.top:mid_no_0.bottom
                anchors.topMargin: defaultMargin
                height:(parent.height -  defaultMargin) / 2
                width: height
                radius: width / 2
                border.color: "gray"
                border.width: 1
                color: "#fafafa"
                Text{
                    text:"2"
                    font.pointSize: 14
                    anchors.centerIn: parent
                }
            }
            Rectangle{
                id:mid_no_2_edit
                height:(parent.height -  defaultMargin) / 2
                width:120
                border.width: 1
                color: "#fafafa"
                anchors.left: mid_no_2.right
                anchors.leftMargin: defaultMargin
                anchors.top:mid_no_0_edit.bottom
                anchors.topMargin: defaultMargin

                Text{
                    anchors.fill: parent
                    font.pointSize: 14
                    text:edgeStrech2
                    anchors.left: parent.left
                    anchors.leftMargin: 5
                    verticalAlignment: Text.AlignVCenter

                }
            }
            Rectangle{
                id:mid_no_3
                anchors.top: mid_no_1.bottom
                anchors.topMargin: defaultMargin
                anchors.left:mid_no_2_edit.right
                anchors.leftMargin: defaultMargin * 3
                height:(parent.height -  defaultMargin) / 2
                width: height
                radius: width / 2
                border.color: "gray"
                border.width: 1
                color: "#fafafa"
                Text{
                    text:"3"
                    font.pointSize: 14
                    anchors.centerIn: parent
                }
            }
            Rectangle{
                id:mid_no_3_edit
                height:(parent.height -  defaultMargin) / 2
                width:120
                border.width: 1
                color: "#fafafa"
                anchors.left: mid_no_3.right
                anchors.leftMargin: defaultMargin
                anchors.top: mid_no_1_edit.bottom
                anchors.topMargin: defaultMargin

                Text{
                    anchors.fill: parent
                    font.pointSize: 14
                    text:edgeStrech3
                    anchors.left: parent.left
                    anchors.leftMargin: 5
                    verticalAlignment: Text.AlignVCenter


                }
            }

        }

        //控件按钮
        Rectangle{
            width:midRect.width
            height: buttonheight
            anchors.top:edgeStrechVal.bottom
            anchors.topMargin: defaultMargin * 2
            anchors.left: parent.left
            anchors.leftMargin: (parent.width - midRectWidth) / 2
            color: "#fafafa"
            Button{
                id:paintingBoardBtn
                width: buttonWidth
                height: buttonheight
                anchors.left: parent.left
                anchors.top: parent.top
                text: qsTr("Painting board")
                style:ButtonStyle{
                    label: Text{
                        anchors.fill: parent
                        text:paintingBoardBtn.text
                        font.pointSize: 14
                        verticalAlignment: Text.AlignVCenter
                        horizontalAlignment: Text.AlignHCenter

                    }
                    background: Rectangle{
                        anchors.fill: parent
                        color: paintingBoardBtn.pressed ? "#64B5F6" : (paintingBoardBtn.hovered ? "#d9ebf9" : "#cdcdcd")
                    }
                }
                onClicked: {
                    touch.run("drawpanel.exe");
                }

            }
            Button{
                id:exitBtn
                width: buttonWidth
                height: buttonheight
                anchors.right: parent.right
                anchors.top: parent.top
                text: qsTr("Exit")
                style:ButtonStyle{
                    label: Text{
                        anchors.fill: parent
                        text:exitBtn.text
                        font.pointSize: 14
                        verticalAlignment: Text.AlignVCenter
                        horizontalAlignment: Text.AlignHCenter

                    }
                    background: Rectangle{
                        anchors.fill: parent
                        color: exitBtn.pressed ? "#c6e0f7" : (exitBtn.hovered ? "#d9ebf9" : "#cdcdcd")
                    }
                }

                onClicked: {
                    exitEdgeStrech();
                }

            }

        }












    }

}
