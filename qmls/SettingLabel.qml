import QtQuick 2.12
import QtQuick.Controls 2.12

Item {
    id: root

    property alias label: label.text
    property alias value: input.text
    property alias inputMask: input.inputMask

    signal wheel(var wheelStatus)

    MouseArea{
        anchors.fill: parent
        hoverEnabled: true

        onEntered: cursorShape = Qt.IBeamCursor

        onClicked: {
            input.forceActiveFocus()            //获取焦点
            input.selectAll()
        }

        onWheel: {
            if(!wheel.modifiers){
                if(wheel.angleDelta.y > 0){
                    root.wheel("add")
                }else{
                    root.wheel("sub")
                }
            }
        }
    }

    Rectangle{
        anchors.fill: parent
        radius: height * 0.5
        clip: true
        color: "#00000000"

        Label{
            id: label
            anchors.left: parent.left
            anchors.leftMargin: parent.radius
            anchors.verticalCenter: parent.verticalCenter
            width: parent.width * 0.5 - parent.radius
            text: "设置 :"
            horizontalAlignment: Text.AlignRight
            font.pixelSize: 14
        }


        TextInput{
            id: input
            anchors.left: label.right
            anchors.verticalCenter: parent.verticalCenter
            anchors.verticalCenterOffset: 1
            width: parent.width * 0.5
            color: "#FF0000"
            clip: true
            text: "1"
            selectByMouse: true
            horizontalAlignment: TextInput.AlignLeft
            font.pixelSize: 14
//            inputMask: "999"
        }
    }
}
