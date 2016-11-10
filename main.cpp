#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QtQuickControls2>
#include <QQuickStyle>

#include "utils.h"

int main(int argc, char *argv[])
{
    QCoreApplication::setAttribute(Qt::AA_EnableHighDpiScaling);
    QGuiApplication app(argc, argv);

    QQuickStyle::setStyle("Material");

    Utils utilities;  // A class containing my functions

    QQmlApplicationEngine engine;
    engine.rootContext()->setContextProperty("UtilityClass", &utilities);
    engine.load(QUrl(QLatin1String("qrc:/Ressources/QML/main.qml")));

    return app.exec();
}
