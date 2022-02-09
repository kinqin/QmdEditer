#include "globalmethod.h"
#include <QDebug>

GlobalMethod::GlobalMethod(QObject *parent)
    : QObject(parent)
{

}

QString GlobalMethod::getDocumentBuffer(const QString &fileUrl)
{
    QFile file(QUrl(fileUrl).toLocalFile());
    QFileInfo f(QUrl(fileUrl).toLocalFile());
    if(!f.isFile()){
        return "Not A File";
    }

    QMimeType mime = db.mimeTypeForFile(file);
    if(!mime.name().startsWith("text/")){
        m_fileInfo[1] = QUrl::fromLocalFile(f.path()).toString();
        return "Not A Text File";
    }

    if(file.open(QIODevice::ReadOnly|QIODevice::Text)){
        m_documentBuffer = file.readAll();
        file.close();
    }else{
        m_documentBuffer="";
    }
    return m_documentBuffer;
}

QStringList GlobalMethod::getFileInfo(const QString &fileUrl)
{
    QFileInfo file(QUrl(fileUrl).toLocalFile());
    QMimeType mime = db.mimeTypeForFile(file);
    if(!mime.name().startsWith("text/")){
//        m_fileInfo[0] = "Not A Text File";
        m_fileInfo[1] = QUrl::fromLocalFile(file.path()).toString();
//        qDebug()<<"not a text file"<<m_fileInfo[1];
        return m_fileInfo;
    }

    m_fileInfo[0] = file.fileName();
    m_fileInfo[1] = QUrl::fromLocalFile(file.path()).toString();
    m_fileInfo[2] = fileUrl;
    //qDebug()<<m_fileInfo[0];
    return m_fileInfo;
}

QStringList GlobalMethod::updateFileInfo(const QString &fileUrl)
{
    QFileInfo file(QUrl(fileUrl).toLocalFile());
    QMimeType mime = db.mimeTypeForFile(file);

    if(file.isDir()){
        m_fileInfo[1] = QUrl::fromLocalFile(file.filePath()).toString();

    }

    if(file.isFile()&&(mime.name().startsWith("text/"))){// ((file.suffix()=="md")||(file.suffix()=="txt"))){
        m_fileInfo[0] = file.fileName();
        m_fileInfo[2] = fileUrl;
        //当前文件夹下，储存为空才更新
        if(m_fileInfo[1]==""){
            m_fileInfo[1] = QUrl::fromLocalFile(file.path()).toString();
        }
        //qDebug()<<file.path()<<QUrl::fromLocalFile(fileUrl).toString();
    }

    return m_fileInfo;
}

bool GlobalMethod::newFile(const QString &fileUrl)
{
    QFile file(QUrl(fileUrl).toLocalFile());
    if(file.exists()){
        //qDebug()<<"文件已存在";
        return false;
    }else{
        if(file.open(QIODevice::WriteOnly|QIODevice::Text)){
            file.close();
        }
    }

    return true;
}

bool GlobalMethod::saveFile(const QString &fileUrl,const QString &text)
{
    QFile file(QUrl(fileUrl).toLocalFile());
    if(file.exists()){
        if(file.open(QIODevice::WriteOnly|QIODevice::Text)){
            QByteArray out = text.toUtf8();
            file.write(out,out.length());
            if(file.flush()){
                file.close();
            }
        }
    }

    return true;
}


bool GlobalMethod::saveBuffer(const QString &text)
{
    m_documentBuffer = text;
    return true;
}

QString GlobalMethod::getBuffer()
{
    return m_documentBuffer;
}
