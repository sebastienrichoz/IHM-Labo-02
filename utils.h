/**
  * @file utils.h
  * @brief Utility class defining some methods that we couldn't achieve
  * easier in the qml files.
  *
  * @author Sébastien Richoz & Damien Rochat
  * @date 10th November 2016
  */

#ifndef TESTCLASS_H
#define TESTCLASS_H

#include <QDebug>
#include <QObject>

class Utils : public QObject
{
    Q_OBJECT
public:
    explicit Utils(QObject *parent = 0);

public slots:
    /**
     * @brief this method is called when COPY button is clicked. It copy
     * the string passed in parameter to the clipboard.
     * @param in is the string to copy to clipboard
     */
    void copyButtonClicked(const QString& in);

    /**
     * @brief getText extract the string 'in' starting from 'start' position
     * @param in the string
     * @param start the position where the extraction must begin
     * @return the complete string beggining from 'start' position
     */
    QString getText(const QString& in, const int start);
};

#endif // TESTCLASS_H
