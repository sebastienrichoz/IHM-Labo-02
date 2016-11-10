/**
  * @file main.cpp
  * @brief Starting point for our application. This application is build
  * with Qt Quick and uses Qt version 5.7
  *
  * @author Sébastien Richoz & Damien Rochat
  * @date 10th November 2016
  */

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
