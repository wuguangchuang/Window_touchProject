import QtQuick 2.0
import QtQuick.Controls 1.2
import QtQml 2.2
import QtQuick.Controls 1.4
import QtQuick.Layouts 1.0
import QtQuick.Controls.Styles 1.4

Button {
    property string textStr:""
    property string imageSource:""
    property int clickBtn:1
    property string tooltipStr:""
    id:rootBtn
    property int defaultWidth:btnIcon.width + btnText.width + 35
    property int defaultHeight:50
    Layout.preferredWidth: defaultWidth
    Layout.preferredHeight: defaultHeight
    tooltip: tooltipStr
        RowLayout{
            id:btnRect
            spacing: 10
            anchors.verticalCenter: parent.verticalCenter
            anchors.fill: parent
            Image {
                id: btnIcon
                visible: true
//                height: rootBtn.height / 5.0 * 4
                Layout.preferredHeight: rootBtn.height / 5.0 * 4
                Layout.preferredWidth: rootBtn.height / 5.0 * 4
                anchors.verticalCenter: parent.verticalCenter
                anchors.left: parent.left
                anchors.leftMargin: defaultMargin
                fillMode: Image.Stretch
                source: imageSource

            }

            Text{
                id:btnText
                text:textStr
                anchors.left: btnIcon.right
                anchors.leftMargin: 5
                anchors.verticalCenter: parent.verticalCenter
                font.pointSize: 14
            }

        }
        style:ButtonStyle{
            background: Rectangle{
                anchors.fill: parent
                color: rootBtn.enabled ? (rootBtn.pressed ? "#c2def5" : (rootBtn.hovered ? "#d9ebf9" : "#e7f2ff")):"#d4d4d5"
            }
        }
}
