import QtQuick 2.0

Item {
    id: root

    property real sidebarWidth: 0
    property real previewWidth: 0

    property real sidebarDefaultWidth: 120
    property real previewDefaultWidth: 400

    signal refresh()
    signal setting()

    TitleToolButton{
        id: siderButton
        anchors.verticalCenter: parent.verticalCenter
//        anchors.left: parent.left
        anchors.right: previewButton.left
        anchors.rightMargin: height * 0.5
        icon: "qrc:/icon/sider.png"
        size: parent.height * 0.6
        tooltip: "侧边栏"
        onClicked: {
            if(sidebarWidth){
                sidebarWidth = 0
            }else{
                sidebarWidth = 120
            }
        }
    }

    TitleToolButton{
        id: previewButton
        anchors.verticalCenter: parent.verticalCenter
//        anchors.left: siderButton.right
//        anchors.leftMargin: height * 0.5
        anchors.right: refreshButton.left
        anchors.rightMargin: height * 0.5
        icon: "qrc:/icon/preview.png"
        size: parent.height * 0.6
        tooltip: "预览"

        onClicked: {
            if(previewWidth){
                previewWidth = 0
            }else{
                previewWidth = previewDefaultWidth
            }
        }
    }

    TitleToolButton{
        id: refreshButton
        anchors.verticalCenter: parent.verticalCenter
//        anchors.left: previewButton.right
//        anchors.leftMargin: height * 0.5
        anchors.right: settingsButton.left
        anchors.rightMargin: height * 0.5
        icon: "qrc:/icon/refresh.png"
        size: parent.height * 0.6
        tooltip: "刷新"
        onClicked: {
            root.refresh()
        }
    }

    TitleToolButton{
        id: settingsButton
        anchors.verticalCenter: parent.verticalCenter
        anchors.right: parent.right
        anchors.rightMargin: 30
        icon: "qrc:/icon/settings.png"
        size: parent.height * 0.6
        tooltip: "设置"
        onClicked: {
            root.setting()
        }
    }
}
