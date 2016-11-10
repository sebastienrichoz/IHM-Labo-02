#include "testclass.h"
#include <QClipboard>
#include <QApplication>
#include <QString>

TestClass::TestClass(QObject *parent) :
    QObject(parent)
{

}

void TestClass::copyButtonClicked(const QString &in)
{
    qDebug() << in;
    QClipboard *clipboard = QApplication::clipboard();
    clipboard->setText(in);
}

QString TestClass::getText(const QString& in, const int start)
{
    qDebug() << "in.length : " << in.length();
    int length = in.length() - start;
    return in.right(length);
}
