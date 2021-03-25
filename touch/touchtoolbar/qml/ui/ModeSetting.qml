import QtQuick 2.0
import QtQuick.Controls 1.4 as Cont1
import QtQuick.Controls 1.2
import QtQuick.Controls 2.0
import QtQuick.Controls.Styles 1.4
import QtQuick.Layouts 1.3

Item {
    id:root
    property int  defaultSpacing: 10
    property int labelWidth:200
    property int defaultHeight:100
    property int defaultWidth:100

    property Item removeDriver:removeDriver
    property Item refreshDriver:refreshDriver

    ScrollView{
        anchors.fill: parent
        horizontalScrollBarPolicy: Qt.ScrollBarAlwaysOn

        ColumnLayout{
            anchors.fill: parent
            Label{
                id:driverTitle
                text:qsTr("Driver")
                font.pointSize: 15
                horizontalAlignment: Text.AlignLeft

            }
            Rectangle{
                id:dirverRect
                Layout.preferredWidth: parent.width
                Layout.preferredHeight: removeDriver.height
                anchors.top: driverTitle.bottom
                anchors.topMargin: defaultMargin
                anchors.left: parent.left
                RowLayout{
                    anchors.fill: parent
                    MyButton{
                        id:removeDriver
                        textStr: qsTr("Remove driver")
                        tooltipStr: qsTr("Unmount the USB device driver.")
                        imageSource:"qrc:/dialog/images/uninstall.png"
                        onClicked: {
                            removeDriver.enabled = false;
                            touch.removeDriver();
                        }

                    }
                    MyButton{
                        id:refreshDriver
                        textStr: qsTr("Search driver")
                        tooltipStr: qsTr("Scanning seedlings to detect hardware drivers.")
                        imageSource:"qrc:/dialog/images/search.png"
                        onClicked: {
                            refreshDriver.enabled = false;
                            touch.refreshDriver();
                        }

                    }
                }


            }

            Rectangle{
                id:line1
                Layout.preferredWidth: parent.width
                Layout.preferredHeight: 2
                anchors.top: dirverRect.bottom
                anchors.topMargin: defaultMargin * 2
                Rectangle{
                    width:root.width
                    height: 2
                    border.color: "#cdcdcd"
                    border.width: 1
                    color: "#cdcdcd"
                }

            }
            Label{
                id:otherTitle
                text:qsTr("Other")
                font.pointSize: 15
                horizontalAlignment: Text.AlignLeft
                anchors.top: line1.bottom
                anchors.topMargin: defaultMargin
            }

            Rectangle{
                Layout.preferredWidth: parent.width
                Layout.preferredHeight: 50
                anchors.top: otherTitle.bottom
                anchors.topMargin: defaultMargin
                anchors.left: parent.left
                border.width: 1
                border.color: "#404244"

                RowLayout {
//                    spacing: defaultSpacing
                    anchors.fill: parent
                    Image {
                        id: startupImage
                        visible: true
                        Layout.preferredHeight:parent.implicitHeight / 5.0 * 4
                        Layout.preferredWidth: parent.implicitHeight / 5.0 * 4
                        fillMode: Image.PreserveAspectFit
                        source: "qrc:/dialog/images/startup.png";
                    }
                    Label {
                        id:startupLabel
                        text: qsTr("Self-starting software")
                        font.pointSize: 14
                        verticalAlignment: Text.AlignVCenter
                        anchors.verticalCenter: parent.verticalCenter
                    }

                    CheckBox {
                        id: startupBox
                        onCheckedChanged: {
                            touch.modeSetting(startupBox.checked ? true : false);
                        }
                    }
                }
            }
        }



    }
    function refreshModeSetting()
    {
        var data = touch.refreshModeSetting();
        var startup = data['startup'];
        startupBox.checked = startup;
    }
}
