import QtQuick 2.0

Item {
    id: root
    width: 12
    height: width

    property alias size: root.width
    property alias background: button.color
    property alias icon: image.source
    property alias color: foreRec.color

    signal clicked()

    Rectangle{
        id: button
        anchors.fill: parent
        radius: width * 0.5
        color: "#f7f7f7"
    }

    Image {
        id: image
        width: parent.width * 0.8
        height: width
        source: "qrc:/icon/close.png"
        anchors.centerIn: parent
    }

    Rectangle{
        id: foreRec
        anchors.fill: parent
        color: root.enabled ? "#ff2200" : "#cccccc"
        radius: width * 0.5
        opacity: 1
    }

    MouseArea{
        anchors.fill: parent
        hoverEnabled: true
        onEntered: {
            cursorShape = Qt.PointingHandCursor
            foreRec.opacity=0
        }
        onExited: foreRec.opacity=1
        onClicked: root.clicked()
    }
}
