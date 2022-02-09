import QtQuick 2.12
import QtQuick.Window 2.15

Window {
    id: root
    color: "#00000000"
    width: 300
    height: 150
    visible: true
    flags: Qt.Dialog|Qt.FramelessWindowHint

    signal message(string msg)

    Rectangle{
        id: background
        anchors.fill: parent
        radius: 8
        color: "#aaaaaa"
    }

    Rectangle{
        anchors.verticalCenter: parent.verticalCenter
        height: parent.height - background.radius * 2
        width: parent.width
        color: "#aaaaaa"

        Text {
            id: content
            text: qsTr("警告!\n文件已存在,将打开文件")
            color: "#ff1111"
            font.pixelSize: 20
            anchors.centerIn: parent
        }

        Rectangle{
            id: button
            width: 50
            height: 20
            anchors.bottom: parent.bottom
            anchors.right: parent.right
            anchors.bottomMargin: 5
            anchors.rightMargin: 5
            color: "#888888"
            radius: 8
            Text{
                id: ok
                text: "OK"
                color: "#ffffff"
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.top: parent.top
                anchors.topMargin: 2
                font.pixelSize: 14
            }

            MouseArea{
                anchors.fill: parent
                onClicked: message("clicked")
            }
        }
    }

}
