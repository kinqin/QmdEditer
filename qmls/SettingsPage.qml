import QtQuick 2.9
import QtQuick.Controls 2.5
import Qt.labs.platform 1.1
import QtQuick.Window 2.3

Item {
    id: root

    property alias fontSize: fontSizeView.value
    property alias windowWidth: windowWidth.value
    property alias windowHeight: windowHeight.value

    property int miniWidth: 640
    property int miniHeight: 480
    property int defaultWidth: 1000
    property int defaultHeight: 800

//TODO: 绘制三角形   worked！
    Item {
        id: triangle
        anchors.top: parent.top
        anchors.right: parent.right
        anchors.topMargin: -20
        anchors.rightMargin: 10
        width: 50
        height: 20


        Canvas{
            id: triangleCanvas
            anchors.fill: parent
            onPaint: {
                var ctx = getContext("2d")
                ctx.fillStyle = "#cccccc"
//                ctx.strokeStyle = "#0000ff"
                ctx.beginPath()
                ctx.moveTo(width-30,0)
                ctx.lineTo(0,height)
                ctx.lineTo(width-10,height)
                ctx.closePath()
                ctx.fill()
            }
        }
    }


    Rectangle{
        anchors.fill: parent
        radius: 8
        color: "#cccccc"

//TODO: Setting

        Rectangle{
            id: cententSetting
            anchors.fill: parent
            anchors.margins: 8
            color: "#00000000"

            Rectangle{
                id: interfaceSetting
                anchors.top: parent.top
                anchors.left: parent.left
                width: parent.width
                height: 60
                color: "#00000000"

                Label{
                    id: interfaceMessage
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.left: parent.left
                    anchors.leftMargin: 5
                    text: "界面"
                }

                Rectangle{
                    id: lineSplict
                    width: 1
                    height: cententSetting.height
                    anchors.left: interfaceMessage.right
                    anchors.leftMargin: 5
                    color: "#454545"
                    opacity: 0.5
                }

                Rectangle{
                    id: rowLineSplict
                    width: parent.width
                    height: 1
                    anchors.top: interfaceSetting.bottom
                    anchors.left: parent.left
                    color: "#555555"
                    opacity: 0.5
                }

                SettingLabel{
                    id: windowWidth
                    width: 120
                    height: 20
                    anchors.left: lineSplict.right
                    anchors.leftMargin: 10
                    label: "宽 : "
                    inputMask: "9999"
                }

                Slider{
                    id: windowWidthSlider
                    anchors.left: windowWidth.right
                    width: 120
                    height: windowWidth.height
                    from: root.miniWidth
                    to: Screen.width
                    value: defaultWidth
                    live: false
                    onValueChanged: windowWidth.value = value.toFixed(0)
                }

                SettingLabel{
                    id: windowHeight
                    width: 120
                    height: 20
                    anchors.left: windowWidthSlider.right
                    anchors.leftMargin: 10
                    label: "高 : "
                    inputMask: "9999"
                }

                Slider{
                    id: windowHeightSlider
                    anchors.left: windowHeight.right
                    width: 120
                    height: windowHeight.height
                    from: root.miniHeight
                    to: Screen.height
                    value: defaultHeight
                    live: false
                    onValueChanged: windowHeight.value = value.toFixed(0)
                }

                Label{
                    id: fontLabel
                    text: "字体 : "
                    width: windowWidth.width * 0.5
                    anchors.top: windowHeight.bottom
                    anchors.left: windowWidth.left
                    horizontalAlignment: Text.AlignRight

                }

                Rectangle{
                    id: fontSettings
                    anchors.left: fontLabel.right
                    anchors.leftMargin: 5
                    anchors.top: fontLabel.top
                    anchors.topMargin: 2
                    width: fontLabel.width * 3
                    height: fontLabel.height - 4
                    color: "#aaaaaa"
                    radius: width * 0.5

                    MouseArea{
                        anchors.fill: parent
                        hoverEnabled: true
                        onClicked: fontdialog.open()
                        onEntered: cursorShape = Qt.PointingHandCursor
                    }

                    Text {
                        id: btn
                        text: font.family
                        anchors.centerIn: parent
                        font.pixelSize: 12
                    }
                }

                SettingLabel{
                    id: fontSizeView
                    width: 120
                    height: 20
                    anchors.left: fontSettings.right
                    anchors.leftMargin: 10
                    anchors.top: fontSettings.top
                    label: "字号 : "
                    inputMask: "99"

                    onValueChanged: {
                        if(value <= 0)value = 1;
                        else if(value >= 98)value = 98;
                    }

                    onWheel: {
                        switch(wheelStatus){
                            case "add": if(++value>98)value = 98; break;
                            case "sub": if(--value<1)value = 1; break;
                            default: break;
                        }
                    }
                }

            }
        }
    }

    FontDialog{
        id: fontdialog

        onAccepted: {
            console.log(font.family)
            btn.font.family = font.family
            fontSizeView.value = font.pointSize
        }
    }

}
