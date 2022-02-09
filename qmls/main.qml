import QtQuick 2.15
import QtQuick.Window 2.15
import Qt.labs.settings 1.1
import Qt.labs.platform 1.1
import QtWebEngine 1.8

Window {
    id: win
    width: settingsPage.windowWidth
    height: settingsPage.windowHeight
    minimumWidth: 640
    minimumHeight: 480
    x: (Screen.width-width)*0.5
    y: (Screen.desktopAvailableHeight-height) * 0.5
    visible: true
    color: "#00000000"
    flags: Qt.FramelessWindowHint

    property string backgroundColor: "#eeeeee"

    Settings{
        id: settings
    }

    TitleBar{
        id: titleBar
        anchors.top: parent.top
        width: parent.width
        height: 30
        window: win
        title: sideBar.fileInfo[0]
        radius: 8

        CustomToolBar{
            id: toolBar
            width: 200
            height: parent.height
//            anchors.left: parent.left
//            anchors.leftMargin: height * 3
            anchors.right: parent.right
            anchors.rightMargin: 5
            sidebarWidth: 120
            previewWidth: (root.width -sideBar.width) * 0.5
            sidebarDefaultWidth: 120
            previewDefaultWidth: (root.width -sideBar.width) * 0.5

            onRefresh: {
                previewWidget.text = inputWidget.text
                if(sideBar.fileInfo[2]!==""){
                    fileSave()
                }
            }

            onSetting: {
                settingsPage.visible = !settingsPage.visible
            }
        }

    }

    Rectangle{
        id: background
        anchors.top: titleBar.bottom
        width: parent.width
        height: parent.height * 0.5
        color: backgroundColor
    }

    Rectangle{
        id: root
        anchors.top: titleBar.bottom
        radius: 8
        width: parent.width
        height: parent.height - titleBar.height
        color: backgroundColor

        Sidebar{
            id: sideBar
            anchors.left: parent.left
            anchors.top: parent.top
            width: toolBar.sidebarWidth
            height: parent.height - parent.radius
            background: "#dddddd"
            onDocumentBufferChanged: {
                inputWidget.text = documentBuffer
            }


            Item {
                anchors.right: parent.right
                width: 20
                height: parent.height
                visible: true
                z: -1
                //color: parent.background
                MouseArea{
                    anchors.fill: parent
                    hoverEnabled: true

                    onEntered: cursorShape = Qt.SizeHorCursor
                    onExited: cursorShape = Qt.ArrowCursor

                    property var initPos
                    onPressed: {
                        initPos = Qt.point(mouseX,mouseY)
                    }

                    onPositionChanged: {
                        if(pressed){
                            if(mouseX -initPos.x){
                                if(toolBar.sidebarWidth && (toolBar.sidebarWidth + mouseX -initPos.x)
                                        <=(root.width - toolBar.previewWidth) * 0.7){
                                    toolBar.sidebarWidth += mouseX -initPos.x
                                }
                            }else{
                                toolBar.sidebarWidth += mouseX -initPos.x
                            }
                            if(toolBar.sidebarWidth < 3)toolBar.sidebarWidth = 0;
                        }
                    }
                }
            }
        }

        CenterInputWidget{
            id: inputWidget
            anchors.left: sideBar.right
            width: parent.width - toolBar.sidebarWidth - previewWidget.width
            height: parent.height - parent.radius
            background: "#00000000"
            padding: 20
            readOnly: settingsPage.visible ? true : false
            textSize: Number(settingsPage.fontSize)
            onTextSizeChanged: console.log("textsize",textSize)

            onLineCountChanged: refreshTimer.start()

        }

        //TODO：文件打开保存

        PreviewWidget{
            id: previewWidget
            width: toolBar.previewWidth//(root.width -sideBar.width)* 0.5
            height: inputWidget.height
            anchors.left: inputWidget.right
//            background: "#00000000"
//            padding: inputWidget.padding
            cursorPos: {
//                console.log(inputWidget.cursorPosition)
                inputWidget.cursorPosition
            }

            Rectangle {
                id: splitLine
                width: 1
                height: parent.height
                opacity: 0.5
                color: "#454545"
                anchors.left: parent.left
            }

            Item{
                id: previewWidgetResizeItem
                anchors.left: parent.left
                anchors.leftMargin: -2
                width: 4
                height: parent.height
                z: -1
                MouseArea{
                    anchors.fill: parent
                    hoverEnabled: true

                    onEntered: cursorShape = Qt.SizeHorCursor
                    onExited: cursorShape = Qt.ArrowCursor

                    property var initPos

                    onPressed: {
                        initPos = Qt.point(mouseX,mouseY)
                    }

                    onPositionChanged: {
                        resize()
                    }

                    function resize(){
                        if(pressed){
                            if(mouseX - initPos.x){
                                if(toolBar.previewWidth && (toolBar.previewWidth - (mouseX - initPos.x))
                                        < (root.width - toolBar.sidebarWidth) * 0.8){
                                    toolBar.previewWidth -= (mouseX - initPos.x)
                                }
                            }else{
                                toolBar.previewWidth -= (mouseX - initPos.x)
                            }

                            if(toolBar.previewWidth < 3)toolBar.previewWidth = 0;
                        }
                    }
                }

            }
        }

        Rectangle{
            id: statusBar
            width: parent.width * 0.5
            height: parent.radius
            color: "#00000000"
            anchors.bottom: parent.bottom
            anchors.horizontalCenter: parent.horizontalCenter

            property string defaultText: "共 " + inputWidget.lineCount + " 行" + "\t" +new Date().toLocaleDateString()

            Text {
                id: statusBarText
                text: parent.defaultText
                anchors.centerIn: parent
                font.pixelSize: 8
            }
        }

        Timer{
            id: refreshTimer
            interval: defaultInterval
            repeat: false
            property int defaultInterval: 500
            onTriggered: {
                previewWidget.text = inputWidget.text
                if(sideBar.fileInfo[2] !== ""){
//                    console.log("save...")
                    fileSave()
                }else{
                    statusBarText.text = statusBar.defaultText + "\t\t未保存,请选择编辑文件..."
                }
            }
        }

    }

    function fileSave(){
        statusBarText.text = statusBar.defaultText + "\t\t正在保存..."
        if(!$globalMethod.saveFile(sideBar.fileInfo[2],inputWidget.text)){
            console.log("failed to saved....")
            statusBarText.text = statusBar.defaultText + "\t\tfailed to saved!"
        }

        statusBarText.text = statusBar.defaultText + "\t\t已保存!"
        statusBarTextTimeout.start()
    }

    Timer{
        id: statusBarTextTimeout
        interval: 1500
        repeat: false
        onTriggered: {
            statusBarText.text = statusBar.defaultText
        }
    }

    SettingsPage{
        id: settingsPage
        width: 600
        height: 400
        anchors.right: parent.right
        anchors.top: parent.top
        anchors.rightMargin: 5
        anchors.topMargin: 50
        visible: false
        fontSize: "14"
        windowWidth: "1000"
        windowHeight: "800"
    }
}
