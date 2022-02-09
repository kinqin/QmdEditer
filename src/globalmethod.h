#ifndef GLOBALMETHOD_H
#define GLOBALMETHOD_H

#include <QObject>
#include <QFile>
#include <QUrl>
#include <QFileInfo>
#include <QStandardPaths>
#include <QDir>
#include <QStringList>
#include <QMimeType>
#include <QMimeDatabase>

class GlobalMethod : public QObject
{
    Q_OBJECT
public:
    explicit GlobalMethod(QObject *parent = nullptr);


public slots:
    QString getDocumentBuffer(const QString &fileUrl);
    QStringList getFileInfo(const QString &fileUrl);
    QStringList updateFileInfo(const QString &fileUrl);
    bool newFile(const QString &fileUrl);
    bool saveFile(const QString &fileUrl,const QString &text);

    bool saveBuffer(const QString &text);
    QString getBuffer();

signals:


private:
    QString m_documentBuffer="";
    QStringList m_fileInfo={"QMD","",""};
    QMimeDatabase db;
};

#endif // GLOBALMETHOD_H
