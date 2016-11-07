#include "testclass.h"

TestClass::TestClass(QObject *parent) :
    QObject(parent)
{

}

void TestClass::buttonClicked(const QString &in)
{
    qDebug() << in;
//    QString fileName;
//    fileName = QFileDialog::getOpenFileName(this, tr("Open File"), QString(),
//                tr("Text Files (*.txt);;C++ Files (*.cpp *.h)"));

//    if (!fileName.isEmpty()) {
//        QFile file(fileName);
//        if (!file.open(QIODevice::ReadOnly)) {
//            QMessageBox::critical(this, tr("Error"), tr("Could not open file"));
//            return;
//        }
//        QTextStream in(&file);
//        ui->textEdit->setText(in.readAll());
//        file.close();
//    }
}
