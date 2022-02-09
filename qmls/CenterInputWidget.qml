import QtQuick 2.9
import QtQuick.Controls 2.5

Item {
    id: root

    property alias background: background.color
    property alias text: inputWidget.text
    property alias textSize: inputWidget.font.pointSize

    property alias lineCount: inputWidget.lineCount
    property alias padding: inputWidget.padding
    property double cursorPosition: inputWidget.cursorPosition/inputWidget.length
    property bool readOnly: false

    Rectangle{
        id: background
        anchors.fill: parent
        color: "#454545"

    }

    ScrollView{
        id: scrollView
        anchors.fill: parent
        clip: true

        Flickable{
            id: removableView
            clip: true
            width: root.width
            height: root.height
            contentHeight: inputWidget.paintedHeight
            contentWidth: inputWidget.paintedWidth

            function ensureVisible(r)
            {
               if (contentX >= r.x)
                   contentX = r.x;
               else if (contentX+width <= r.x+r.width)
                   contentX = r.x+r.width-width;
               if (contentY >= r.y)
                   contentY = r.y;
               else if (contentY+height <= r.y+r.height)
                   contentY = r.y+r.height-height;
            }

//            Item {
//                id: lineCount
//                width: 40
//                height: parent.height
//                anchors.top: parent.top
//                anchors.topMargin: inputWidget.padding

//                ListView{
//                    id: lineList
//                    anchors.fill: parent
//                    model: 10000//inputWidget.lineCount
//                    delegate: Item{
//                        width: lineList.width
//                        height: content.contentHeight// + 4
//                        Text{
//                            id:content
//                            text: index + 1
//                            anchors.right: parent.right
//                            anchors.verticalCenter: parent.verticalCenter
//                        }
//                    }
//                }
//            }

            TextEdit{
                id: inputWidget
                width: root.width * 2
                //height: contentHeight + padding * 2
                //anchors.right: parent.right
                padding: 50
                objectName: "inputWidget"
                focus: readOnly ? false : true
                //clip属性必须要为false，否则会导致flickable剪裁
                clip: false
                readOnly: root.readOnly
                activeFocusOnPress: root.readOnly ? false : true
                textFormat: TextEdit.PlainText
                wrapMode: TextEdit.NoWrap
                selectByMouse: true
                selectedTextColor: "#ffffff"
                selectionColor: "#3399ff"
                onCursorRectangleChanged: {
                    removableView.ensureVisible(cursorRectangle)
                }
            }
        }
    }
}
