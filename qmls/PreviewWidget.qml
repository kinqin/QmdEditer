import QtQuick 2.9
import QtQuick.Controls 2.5
import QtWebEngine 1.8
import QtWebChannel 1.0
import cxl.normal 1.0
Item {
    id: root

//    property alias background: backgroundImage.color
    property alias text: m_content.text
//    property alias padding: preview.padding
    property double cursorPos

    onCursorPosChanged:{
        web_view.runJavaScript(
            "document.documentElement.scrollHeight",
            function (i_actualPageWidth) {
                web_view.scrollEnhance = cursorPos * (i_actualPageWidth - web_view.height + web_view.height * 0.2)
            }
        )

        web_view.runJavaScript("window.scrollTo(0,"+web_view.scrollEnhance+")")
    }

    WebEngineView{
        id: web_view
        url: "qrc:/index.html"
        anchors.fill: parent
        backgroundColor: "#00000000"
        settings.showScrollBars: false
        focus: true
        webChannel: WebChannel{
            registeredObjects:[m_content]
        }

        Document{
            id:m_content
            text: ""
            WebChannel.id:"content"
        }

        property double scrollEnhance: 0

    }
}
