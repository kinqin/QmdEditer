#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>
#include <QIcon>
#include <QtWebEngine/qtwebengineglobal.h>
#include "document.h"
//#include "highlighter.h"
#include "globalmethod.h"
#include <QFont>
#include <QQuickTextDocument>
#include <QTextOption>

int main(int argc, char *argv[])
{
    QtWebEngine::initialize();

#if QT_VERSION < QT_VERSION_CHECK(6, 0, 0)
    QCoreApplication::setAttribute(Qt::AA_EnableHighDpiScaling);
#endif

    QGuiApplication app(argc, argv);
    //字体
    QFont font;
    font.setFamily("Noto Sans Telugu");
    font.setPixelSize(14);
    app.setFont(font);
    //语法高亮
//    qmlRegisterType<Highlighter>("qml.highlighter", 1, 0, "Highlighter");
//    qmlRegisterType<TextCharFormat>("qml.highlighter", 1, 0, "TextCharFormat");

    qmlRegisterType<Document>("cxl.normal", 1, 0, "Document");
    //setting记录
    app.setOrganizationName("KinqinSoft");
    app.setOrganizationDomain("github.com/kinqin/QmdEditer");
    app.setApplicationName("QmdEditer");
    //图标
    app.setWindowIcon(QIcon(":/icon/open.png"));

    QQmlApplicationEngine engine;

    //全局
    auto globalMethod = new GlobalMethod();
    engine.rootContext()->setContextProperty("$globalMethod", globalMethod);

    const QUrl url(QStringLiteral("qrc:/main.qml"));
    QObject::connect(&engine, &QQmlApplicationEngine::objectCreated,
                     &app, [url](QObject *obj, const QUrl &objUrl) {
        if (!obj && url == objUrl)
            QCoreApplication::exit(-1);
    }, Qt::QueuedConnection);
    engine.load(url);
    //设置Tab指标符大小
    QObject *root = engine.rootObjects().at(0);
    QObject *textSetTab = root->findChild<QObject*>(QStringLiteral("inputWidget"));
    QQuickTextDocument *quickTextDocument = textSetTab->property("textDocument").value<QQuickTextDocument*>();
    QTextDocument *document = quickTextDocument->textDocument();
    QTextOption textOptions = document->defaultTextOption();
    textOptions.setTabStopDistance(qreal(40));
    document->setDefaultTextOption(textOptions);

    return app.exec();
}
