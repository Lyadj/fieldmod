#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QApplication>
#include <QFont>
#include <QSysInfo>
#include <QSurfaceFormat>
#include <QQmlContext>

#include "gripper/include/Gripper.h"
#include "serialtool/include/Serialtool.h"

//-----------日志文件输出与日志窗口打印
static QObject * logObject;
void myMessageOutput(QtMsgType type,
    const QMessageLogContext & context,
        const QString & msg);

int main(int argc, char *argv[])
{

    qputenv("QT_IM_MODULE", QByteArray("qtvirtualkeyboard"));
    //添加自定义的键盘：hex pad
    qputenv("QT_VIRTUALKEYBOARD_LAYOUT_PATH","qrc:/resources/atpkb/QtQuick/VirtualKeyboard/layouts");
    qputenv("QT_VIRTUALKEYBOARD_STYLE","atpkbstyles");


#if QT_VERSION < QT_VERSION_CHECK(6, 0, 0)
    QCoreApplication::setAttribute(Qt::AA_EnableHighDpiScaling);
#endif

    QApplication app(argc, argv);

    //设置全局字体
    QFont ATPglobalFont("./fonts/NotoSansSC-Regular",16);
    app.setFont(ATPglobalFont);

    app.setAutoSipEnabled(false);

    QSurfaceFormat sufformat;
    sufformat.setSamples(8);
    QSurfaceFormat::setDefaultFormat(sufformat);


    //注册机械爪
    qmlRegisterType<ATPGripper::Gripper>("casbio.lab",1,1,"Gripper");
    //注册串口后端
    qmlRegisterType<SerialTool::XYSerialPort>("casbio.lab",1,1,"XYSerialPort");


    QQmlApplicationEngine engine;
    engine.addImportPath("qrc:/resources/atpkb");

    const QUrl url(QStringLiteral("qrc:/main.qml"));
    QObject::connect(&engine, &QQmlApplicationEngine::objectCreated,
                     &app, [url](QObject *obj, const QUrl &objUrl) {
        if (!obj && url == objUrl)
            QCoreApplication::exit(-1);
    }, Qt::QueuedConnection);


    engine.load(url);

    //------------加载日志窗口
    QObject * rootObject = engine.rootObjects().front();
    logObject = rootObject->findChild<QObject*>("logview");

    //指令集合model传递给前端gripper

//    engine.rootContext()->setContextProperty("gripperCommandModel",ATPGripper::CommandNameList);

    //------安装输出日志的窗口
    qInstallMessageHandler(myMessageOutput);


    return app.exec();
}


//-------------------设置日志窗口
void myMessageOutput(QtMsgType type, const QMessageLogContext & context, const QString & msg) {


    switch (type) {
        case QtDebugMsg:
            QMetaObject::invokeMethod(logObject, "debug_log", Q_ARG(QVariant, QVariant(msg)));
            break;

        case QtWarningMsg:
            QMetaObject::invokeMethod(logObject, "warn_log", Q_ARG(QVariant, QVariant(msg)));
            break;

        case QtCriticalMsg:
            QMetaObject::invokeMethod(logObject, "error_log", Q_ARG(QVariant, QVariant(msg)));
            break;

        case QtFatalMsg:
            abort();
        default:
            break;
    }


}
