/**
  * @file utils.cpp
  * @brief Implement the methods defined in utils.h
  *
  * @author Sébastien Richoz & Damien Rochat
  * @date 10th November 2016
  */

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
    int length = in.length() - start;
    return in.right(length);
}
