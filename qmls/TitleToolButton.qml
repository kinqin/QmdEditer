import QtQuick 2.0
import QtQuick.Controls 2.15

Item {
    id: root
    width: 20
    height: width

    property alias background: background.color
    property alias icon: icon.source
    property alias size: root.width
    property string tooltip: "tool"
    signal clicked()

    Rectangle{
        id: background
        anchors.fill: parent
        color: "#ffffff"
        opacity: 0
    }

    Image {
        id: icon
        width: parent.width * 0.9
        height: width
        anchors.centerIn: parent
        source: "qrc:/icon/sider.png"
        ToolTip.visible: visibleFlag
        ToolTip.text: tooltip
        ToolTip.delay: 500
        ToolTip.timeout: 1500

        property bool visibleFlag: false
    }

    MouseArea{
        anchors.fill: parent
        hoverEnabled: true
        onEntered: {
            cursorShape = Qt.PointingHandCursor
            background.opacity = 1
            icon.visibleFlag = true
            //tooltipItem.show(tooltip,1500)
        }
        onExited: {
            background.opacity = 0
            //tooltipItem.hide()
            icon.visibleFlag = false
        }
        onClicked: root.clicked()
    }

}
