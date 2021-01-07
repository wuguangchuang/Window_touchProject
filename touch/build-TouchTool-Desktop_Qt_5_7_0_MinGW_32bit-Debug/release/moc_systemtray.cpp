/****************************************************************************
** Meta object code from reading C++ file 'systemtray.h'
**
** Created by: The Qt Meta Object Compiler version 67 (Qt 5.7.0)
**
** WARNING! All changes made in this file will be lost!
*****************************************************************************/

#include "../../touchtoolbar/include/systemtray.h"
#include <QtCore/qbytearray.h>
#include <QtCore/qmetatype.h>
#if !defined(Q_MOC_OUTPUT_REVISION)
#error "The header file 'systemtray.h' doesn't include <QObject>."
#elif Q_MOC_OUTPUT_REVISION != 67
#error "This file was generated using the moc from 5.7.0. It"
#error "cannot be used with the include files from this version of Qt."
#error "(The moc has changed too much.)"
#endif

QT_BEGIN_MOC_NAMESPACE
struct qt_meta_stringdata_SystemTray_t {
    QByteArrayData data[12];
    char stringdata0[190];
};
#define QT_MOC_LITERAL(idx, ofs, len) \
    Q_STATIC_BYTE_ARRAY_DATA_HEADER_INITIALIZER_WITH_OFFSET(len, \
    qptrdiff(offsetof(qt_meta_stringdata_SystemTray_t, stringdata0) + ofs \
        - idx * sizeof(QByteArrayData)) \
    )
static const qt_meta_stringdata_SystemTray_t qt_meta_stringdata_SystemTray = {
    {
QT_MOC_LITERAL(0, 0, 10), // "SystemTray"
QT_MOC_LITERAL(1, 11, 12), // "signal_close"
QT_MOC_LITERAL(2, 24, 0), // ""
QT_MOC_LITERAL(3, 25, 16), // "ActivationReason"
QT_MOC_LITERAL(4, 42, 33), // "QSystemTrayIcon::ActivationRe..."
QT_MOC_LITERAL(5, 76, 14), // "activityAction"
QT_MOC_LITERAL(6, 91, 12), // "openProgress"
QT_MOC_LITERAL(7, 104, 17), // "changeUpgradePage"
QT_MOC_LITERAL(8, 122, 14), // "changeTestPage"
QT_MOC_LITERAL(9, 137, 18), // "enterCalibratePage"
QT_MOC_LITERAL(10, 156, 17), // "changeSettingPage"
QT_MOC_LITERAL(11, 174, 15) // "changeAboutPage"

    },
    "SystemTray\0signal_close\0\0ActivationReason\0"
    "QSystemTrayIcon::ActivationReason\0"
    "activityAction\0openProgress\0"
    "changeUpgradePage\0changeTestPage\0"
    "enterCalibratePage\0changeSettingPage\0"
    "changeAboutPage"
};
#undef QT_MOC_LITERAL

static const uint qt_meta_data_SystemTray[] = {

 // content:
       7,       // revision
       0,       // classname
       0,    0, // classinfo
       8,   14, // methods
       0,    0, // properties
       0,    0, // enums/sets
       0,    0, // constructors
       0,       // flags
       1,       // signalCount

 // signals: name, argc, parameters, tag, flags
       1,    0,   54,    2, 0x06 /* Public */,

 // slots: name, argc, parameters, tag, flags
       3,    1,   55,    2, 0x0a /* Public */,
       6,    0,   58,    2, 0x0a /* Public */,
       7,    0,   59,    2, 0x0a /* Public */,
       8,    0,   60,    2, 0x0a /* Public */,
       9,    0,   61,    2, 0x0a /* Public */,
      10,    0,   62,    2, 0x0a /* Public */,
      11,    0,   63,    2, 0x0a /* Public */,

 // signals: parameters
    QMetaType::Void,

 // slots: parameters
    QMetaType::Void, 0x80000000 | 4,    5,
    QMetaType::Void,
    QMetaType::Void,
    QMetaType::Void,
    QMetaType::Void,
    QMetaType::Void,
    QMetaType::Void,

       0        // eod
};

void SystemTray::qt_static_metacall(QObject *_o, QMetaObject::Call _c, int _id, void **_a)
{
    if (_c == QMetaObject::InvokeMetaMethod) {
        SystemTray *_t = static_cast<SystemTray *>(_o);
        Q_UNUSED(_t)
        switch (_id) {
        case 0: _t->signal_close(); break;
        case 1: _t->ActivationReason((*reinterpret_cast< QSystemTrayIcon::ActivationReason(*)>(_a[1]))); break;
        case 2: _t->openProgress(); break;
        case 3: _t->changeUpgradePage(); break;
        case 4: _t->changeTestPage(); break;
        case 5: _t->enterCalibratePage(); break;
        case 6: _t->changeSettingPage(); break;
        case 7: _t->changeAboutPage(); break;
        default: ;
        }
    } else if (_c == QMetaObject::IndexOfMethod) {
        int *result = reinterpret_cast<int *>(_a[0]);
        void **func = reinterpret_cast<void **>(_a[1]);
        {
            typedef void (SystemTray::*_t)();
            if (*reinterpret_cast<_t *>(func) == static_cast<_t>(&SystemTray::signal_close)) {
                *result = 0;
                return;
            }
        }
    }
}

const QMetaObject SystemTray::staticMetaObject = {
    { &QWidget::staticMetaObject, qt_meta_stringdata_SystemTray.data,
      qt_meta_data_SystemTray,  qt_static_metacall, Q_NULLPTR, Q_NULLPTR}
};


const QMetaObject *SystemTray::metaObject() const
{
    return QObject::d_ptr->metaObject ? QObject::d_ptr->dynamicMetaObject() : &staticMetaObject;
}

void *SystemTray::qt_metacast(const char *_clname)
{
    if (!_clname) return Q_NULLPTR;
    if (!strcmp(_clname, qt_meta_stringdata_SystemTray.stringdata0))
        return static_cast<void*>(const_cast< SystemTray*>(this));
    return QWidget::qt_metacast(_clname);
}

int SystemTray::qt_metacall(QMetaObject::Call _c, int _id, void **_a)
{
    _id = QWidget::qt_metacall(_c, _id, _a);
    if (_id < 0)
        return _id;
    if (_c == QMetaObject::InvokeMetaMethod) {
        if (_id < 8)
            qt_static_metacall(this, _c, _id, _a);
        _id -= 8;
    } else if (_c == QMetaObject::RegisterMethodArgumentMetaType) {
        if (_id < 8)
            *reinterpret_cast<int*>(_a[0]) = -1;
        _id -= 8;
    }
    return _id;
}

// SIGNAL 0
void SystemTray::signal_close()
{
    QMetaObject::activate(this, &staticMetaObject, 0, Q_NULLPTR);
}
QT_END_MOC_NAMESPACE
