import QtQuick 2.0

//import QtQuick.Controls 2.0
import QtQuick.Layouts 1.3
import QtQuick.Controls 1.4
import QtQuick.Controls.Styles 1.4

import QtQuick.Controls 1.2
import QtQml 2.2

Button{
    property int listBtnheight:60
    property string textStr:""

    property int what:0
    id:myToolBtn
    Layout.preferredHeight: listBtnheight
    Layout.fillWidth: true

    style: ButtonStyle{
        background: Rectangle{
            color: checkBtn === what ? "#ece7fe" : "#dedaef"
        }
        label: Text{
            text:textStr
            verticalAlignment: Text.AlignVCenter
            horizontalAlignment: Text.AlignHCenter
            font.family: "Helvetica"
            font.pointSize: 15
        }

    }

}
