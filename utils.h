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
    void copyButtonClicked(const QString& in);
    QString getText(const QString& in, const int start);
};

#endif // TESTCLASS_H
