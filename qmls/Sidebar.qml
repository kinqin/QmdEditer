import QtQuick 2.9
import Qt.labs.folderlistmodel 2.2
//import Qt.labs.platform 1.0
import Qt.labs.platform 1.1

Item {
    id: root

    property alias background: background.color
    property string documentBuffer: ""
    //file folder fileurl
    property var fileInfo: ["QmdEditer",StandardPaths.writableLocation(StandardPaths.DocumentsLocation),""]

    Rectangle{
        id: background
        anchors.fill: parent
        color: "#eeeeee"
    }

    Rectangle{
        id: splitLine
        width: 1
        height: parent.height
        anchors.left: fileList.right
        color: "#555555"
        opacity: 0.5
    }

    Rectangle{
        id: tool
        width: 20
        height: parent.height
        anchors.right: parent.right
        color: background.color

        TitleToolButton{
            id: newFile
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.top: parent.top
            anchors.topMargin: 5
            icon: "qrc:/icon/new.png"
            size: parent.width * 0.8
            tooltip: "新建文件"

            onClicked: fileSaveDialog.open()
        }

        TitleToolButton{
            id: openFile
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.top: newFile.bottom
            anchors.topMargin: 5
            icon: "qrc:/icon/open.png"
            size: parent.width * 0.8
            tooltip: "打开文件"

            onClicked: fileOpenDialog.open()
        }

//        TitleToolButton{
//            id: newFolder
//            anchors.horizontalCenter: parent.horizontalCenter
//            anchors.top: openFile.bottom
//            anchors.topMargin: 5
//            icon: "qrc:/icon/new_folder.png"
//            size: parent.width * 0.8
//            tooltip: "新建文件夹"
//        }

        TitleToolButton{
            id: openFolder
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.top: openFile.bottom
            anchors.topMargin: 5
            icon: "qrc:/icon/open_folder.png"
            size: parent.width * 0.7
            tooltip: "打开文件夹"

            onClicked: openFolderDialog.open()
        }

    }


    ListView{
        id: fileList
        height: parent.height
        width: parent.width - tool.width - splitLine.width
        anchors.left: parent.left
        model: foldList
        delegate: fileDelegate
        clip: true

//        focus: true
    }

    Component{
        id: fileDelegate
        Rectangle{
            id: wrapper
            width: fileList.width
            height: text.font.pixelSize + 4
            color: ListView.isCurrentItem ? "#1d545c" : "#00000000"

            Image{
                id: icon
                width: height
                height: text.font.pixelSize + 4
                source: fileIsDir ? "qrc:/icon/folder.png" : "qrc:/icon/file.png"
                anchors.left: parent.left
            }

            Text {
                id: text
                text: fileName
                clip: true

                anchors.verticalCenter: parent.verticalCenter
                anchors.left: icon.right
                color: wrapper.ListView.isCurrentItem ? "#ffffff" : "#000000"
            }

            MouseArea{
                anchors.fill: parent
                cursorShape: Qt.PointingHandCursor
                onClicked: {
                    fileList.currentIndex = index
                    fileInfo = $globalMethod.updateFileInfo(fileUrl)
                    documentBuffer = $globalMethod.getDocumentBuffer(fileInfo[2])
//                    console.log(documentBuffer)
                    if(foldList.isFolder(fileList.currentIndex)){
                        fileList.currentIndex = 0
                    }
                }

            }
        }
    }

    FolderListModel{
        id: foldList
        folder: fileInfo[1]
        rootFolder: "/"
        sortField: FolderListModel.Name
        showDirsFirst: true
        showDotAndDotDot: true
        showHidden: true

    }

    FileDialog{
        id: fileOpenDialog
        folder: StandardPaths.writableLocation(StandardPaths.DocumentsLocation)
        nameFilters: ["Makedown\t*.md(*.md *.MD)","Txt\t\t\t*.txt(*.txt)","All\t\t\t*(*)"]
        onAccepted: {
            fileInfo = $globalMethod.getFileInfo(file)
            documentBuffer = $globalMethod.getDocumentBuffer(fileInfo[2])
        }
    }

    FileDialog{
        id: fileSaveDialog
        folder: StandardPaths.writableLocation(StandardPaths.DocumentsLocation)
        nameFilters: ["Makedown\t*.md(*.md *.MD)","Txt\t\t\t*.txt(*.txt)","All\t\t\t*(*)"]
        fileMode: FileDialog.SaveFile
        options: FileDialog.DontConfirmOverwrite
        onAccepted: {
//            console.log(file)
            if($globalMethod.newFile(file)===false){
                //console.log("或已存在")
                messageLoader.active = true
                messageLoader.source = "qrc:/CustomMessageDialog.qml"
                fileInfo = $globalMethod.getFileInfo(file)
                documentBuffer = $globalMethod.getDocumentBuffer(fileInfo[2])
            }
        }
    }

    Loader{
        id: messageLoader
        active: false
        source: "qrc:/CustomMessageDialog.qml"
    }

    Connections{
        target: messageLoader.item
        function onMessage(msg) {
            messageLoader.source = ""
        }
    }

    FolderDialog{
        id: openFolderDialog
        folder: StandardPaths.writableLocation(StandardPaths.DocumentsLocation)
        options: FolderDialog.ShowDirsOnly
        onAccepted: {
            fileInfo = $globalMethod.updateFileInfo(currentFolder)
            //documentBuffer = $globalMethod.getDocumentBuffer(fileInfo[2])
            fileList.currentIndex = 0

        }
    }
}
