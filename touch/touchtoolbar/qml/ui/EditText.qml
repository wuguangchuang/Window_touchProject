import QtQuick 2.7
import QtQuick.Controls 2.0

Item {
    id: root
//    property var maxValue: ""
    property var value: "0"
    property int defaultHeight:40
    property bool read_only:false
    property bool focusVal:true
//    height: textField.implicitHeight
    height: defaultHeight

    signal textChanged(var text);
    TextField {
        id: textField
        property bool showHint: false
        readOnly: read_only
        MouseArea {
            anchors.fill: parent
            hoverEnabled: true
            onEntered: {
                parent.showHint = true;
            }
            onExited: parent.showHint = false;
            focus: false
            acceptedButtons: Qt.NoButton
        }

        Component.onCompleted: {
            root.height = textField.height
            text = value
        }
        width: root.width
        height: defaultHeight
        font.pointSize: 14
        focus: focusVal
//        validator: RegExpValidator {
//            regExp: /[0-9]+/
//        }
        onShowHintChanged:
        {
            if (text === "") {
                text = "0";
                return;
            }
            root.textChanged(text);
        }
        onActiveFocusChanged: {
            if (activeFocus === true)
                return;
            if (text === "") {
                text = "0";
                return;
            }

            root.textChanged(text);
        }
    }
}
