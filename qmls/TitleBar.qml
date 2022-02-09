import QtQuick 2.0
import QtQuick.Window 2.3
import QtQuick.Controls 2.5

Item {
    id: root
    //transmit {window} to resize or move
    property Window window
    property bool isNormal: true

    //titlebar radius, only upper half
    property alias radius: circleRec.radius
    //titlebar color
    property string color: "#dedcde"
    //titleBar title
    property alias title: title.text

    property alias rightPos: restoreButton
//TitleBar mouse Behavior
    MouseArea{
        anchors.fill: parent
        hoverEnabled: true

        property point initMousePos
        property bool isDoubleClick: false


        onDoubleClicked: {
            isDoubleClick = true
            doSysResize()

        }

        //onEntered: cursorShape = Qt.OpenHandCursor


        onPressed: {
            //cursorShape = Qt.ClosedHandCursor
            isDoubleClick = false
            initMousePos = Qt.point(mouseX,mouseY)
        }

        onReleased: {
            //cursorShape = Qt.OpenHandCursor
            isDoubleClick = false
        }

        onPositionChanged: {
            //console.log((mouseX - initMousePos.x))
            if(pressed && (!isDoubleClick)){
                if(window.visibility !== Window.Maximized&&window.visibility !== Window.FullScreen){
                    window.x += (mouseX - initMousePos.x)
                    window.y += (mouseY - initMousePos.y)

                }else if(window.visibility === Window.Maximized || window.visibility === Window.FullScreen){
                    window.showNormal()
                    isDoubleClick = true
                }
            }
        }

    }

//set radius
    Rectangle{
        id: circleRec
        anchors.fill: parent
        radius: 5
        color: root.color

    }
//cover radius when did't needed
    Rectangle{
        id: bottomRectangle
        width: parent.width
        height: parent.height * 0.5
        anchors.bottom: parent.bottom
        color: root.color
    }
//the close button
    TitleButton{
        id: closeButton
        anchors.verticalCenter: parent.verticalCenter
        anchors.left: parent.left
        anchors.leftMargin: width * 0.8
        size: root.height * 0.5
        icon: "qrc:/icon/close.png"
        color: "#fd2c56"
        onClicked: {
            Qt.quit()
        }
    }
//the restore button
    TitleButton{
        id: minButton
        anchors.verticalCenter: parent.verticalCenter
        anchors.left: closeButton.right
        anchors.margins: width * 0.5
        icon: "qrc:/icon/min.png"
        size: root.height * 0.5
        color: "#f5c400"
        onClicked: {
            window.showMinimized()
        }
    }
//the showMinimized button
    TitleButton{
        id: restoreButton
        anchors.verticalCenter: parent.verticalCenter
        anchors.left: minButton.right
        anchors.margins: width * 0.5
        icon: "qrc:/icon/max.png"
        size: root.height * 0.5
        color: "#55ff00"
        onClicked: {
             doSysResize()
        }
    }


    Item {
        id: titleRoot
        height: parent.height
        width: 200
        anchors.verticalCenter: parent.verticalCenter
        anchors.horizontalCenter: parent.horizontalCenter
        clip: true
        Text {
            id: title
            text: "title"
//            maximumLineCount: 1
            width: parent.width
            anchors.centerIn: parent
            horizontalAlignment: Text.AlignHCenter
            clip: true
            elide: Text.ElideMiddle
//            style: Text.Raised
        }

    }

    function doSysResize(){
        if(window.visibility === Window.Maximized){
            window.showNormal();
            restoreButton.icon = "qrc:/icon/max.png"
        }
        else{
            window.showMaximized();
            restoreButton.icon = "qrc:/icon/restore.png"
        }
    }
}
