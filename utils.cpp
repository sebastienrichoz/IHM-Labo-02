#include "utils.h"
#include <QClipboard>
#include <QApplication>
#include <QString>

Utils::Utils(QObject *parent) :
    QObject(parent)
{

}

void Utils::copyButtonClicked(const QString &in)
{
    QClipboard *clipboard = QApplication::clipboard();
    clipboard->setText(in);
}

QString Utils::getText(const QString& in, const int start)
{
    qDebug() << "in.length : " << in.length();
    int length = in.length() - start;
    return in.right(length);
}
