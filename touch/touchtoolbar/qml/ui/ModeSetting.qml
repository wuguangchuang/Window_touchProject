import QtQuick 2.0
import QtQuick.Controls 1.4 as Cont1
import QtQuick.Controls 1.2
import QtQuick.Controls 2.0
import QtQuick.Controls.Styles 1.4
import QtQuick.Layouts 1.3

Item {
    property int  defaultSpacing: 10
    property int labelWidth:200
    ScrollView{
        anchors.fill: parent
        horizontalScrollBarPolicy: Qt.ScrollBarAlwaysOn
        ColumnLayout{
            RowLayout {
                spacing: defaultSpacing
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
                    Layout.preferredHeight:parent.implicitHeight
                    Layout.minimumWidth: labelWidth
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
    function refreshModeSetting()
    {
        var data = touch.refreshModeSetting();
        var startup = data['startup'];
        startupBox.checked = startup;
    }
}
