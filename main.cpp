#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QtQuickControls2>
#include <QQuickStyle>

#include "testclass.h"

int main(int argc, char *argv[])
{
    QCoreApplication::setAttribute(Qt::AA_EnableHighDpiScaling);
    QGuiApplication app(argc, argv);

    QQuickStyle::setStyle("Material");

    TestClass myClass;  // A class containing my functions

    QQmlApplicationEngine engine;
    engine.rootContext()->setContextProperty("_TestClass", &myClass);
    engine.load(QUrl(QLatin1String("qrc:/Ressources/QML/main.qml")));

    return app.exec();
}
