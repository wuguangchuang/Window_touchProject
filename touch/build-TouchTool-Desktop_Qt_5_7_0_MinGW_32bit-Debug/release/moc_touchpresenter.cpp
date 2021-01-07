/****************************************************************************
** Meta object code from reading C++ file 'touchpresenter.h'
**
** Created by: The Qt Meta Object Compiler version 67 (Qt 5.7.0)
**
** WARNING! All changes made in this file will be lost!
*****************************************************************************/

#include "../../touchtoolbar/include/presenter/touchpresenter.h"
#include <QtCore/qbytearray.h>
#include <QtCore/qmetatype.h>
#if !defined(Q_MOC_OUTPUT_REVISION)
#error "The header file 'touchpresenter.h' doesn't include <QObject>."
#elif Q_MOC_OUTPUT_REVISION != 67
#error "This file was generated using the moc from 5.7.0. It"
#error "cannot be used with the include files from this version of Qt."
#error "(The moc has changed too much.)"
#endif

QT_BEGIN_MOC_NAMESPACE
struct qt_meta_stringdata_ProcessStarter_t {
    QByteArrayData data[4];
    char stringdata0[32];
};
#define QT_MOC_LITERAL(idx, ofs, len) \
    Q_STATIC_BYTE_ARRAY_DATA_HEADER_INITIALIZER_WITH_OFFSET(len, \
    qptrdiff(offsetof(qt_meta_stringdata_ProcessStarter_t, stringdata0) + ofs \
        - idx * sizeof(QByteArrayData)) \
    )
static const qt_meta_stringdata_ProcessStarter_t qt_meta_stringdata_ProcessStarter = {
    {
QT_MOC_LITERAL(0, 0, 14), // "ProcessStarter"
QT_MOC_LITERAL(1, 15, 3), // "run"
QT_MOC_LITERAL(2, 19, 0), // ""
QT_MOC_LITERAL(3, 20, 11) // "application"

    },
    "ProcessStarter\0run\0\0application"
};
#undef QT_MOC_LITERAL

static const uint qt_meta_data_ProcessStarter[] = {

 // content:
       7,       // revision
       0,       // classname
       0,    0, // classinfo
       1,   14, // methods
       0,    0, // properties
       0,    0, // enums/sets
       0,    0, // constructors
       0,       // flags
       0,       // signalCount

 // slots: name, argc, parameters, tag, flags
       1,    1,   19,    2, 0x0a /* Public */,

 // slots: parameters
    QMetaType::Void, QMetaType::QString,    3,

       0        // eod
};

void ProcessStarter::qt_static_metacall(QObject *_o, QMetaObject::Call _c, int _id, void **_a)
{
    if (_c == QMetaObject::InvokeMetaMethod) {
        ProcessStarter *_t = static_cast<ProcessStarter *>(_o);
        Q_UNUSED(_t)
        switch (_id) {
        case 0: _t->run((*reinterpret_cast< const QString(*)>(_a[1]))); break;
        default: ;
        }
    }
}

const QMetaObject ProcessStarter::staticMetaObject = {
    { &QProcess::staticMetaObject, qt_meta_stringdata_ProcessStarter.data,
      qt_meta_data_ProcessStarter,  qt_static_metacall, Q_NULLPTR, Q_NULLPTR}
};


const QMetaObject *ProcessStarter::metaObject() const
{
    return QObject::d_ptr->metaObject ? QObject::d_ptr->dynamicMetaObject() : &staticMetaObject;
}

void *ProcessStarter::qt_metacast(const char *_clname)
{
    if (!_clname) return Q_NULLPTR;
    if (!strcmp(_clname, qt_meta_stringdata_ProcessStarter.stringdata0))
        return static_cast<void*>(const_cast< ProcessStarter*>(this));
    return QProcess::qt_metacast(_clname);
}

int ProcessStarter::qt_metacall(QMetaObject::Call _c, int _id, void **_a)
{
    _id = QProcess::qt_metacall(_c, _id, _a);
    if (_id < 0)
        return _id;
    if (_c == QMetaObject::InvokeMetaMethod) {
        if (_id < 1)
            qt_static_metacall(this, _c, _id, _a);
        _id -= 1;
    } else if (_c == QMetaObject::RegisterMethodArgumentMetaType) {
        if (_id < 1)
            *reinterpret_cast<int*>(_a[0]) = -1;
        _id -= 1;
    }
    return _id;
}
struct qt_meta_stringdata_TouchPresenter_t {
    QByteArrayData data[108];
    char stringdata0[1373];
};
#define QT_MOC_LITERAL(idx, ofs, len) \
    Q_STATIC_BYTE_ARRAY_DATA_HEADER_INITIALIZER_WITH_OFFSET(len, \
    qptrdiff(offsetof(qt_meta_stringdata_TouchPresenter_t, stringdata0) + ofs \
        - idx * sizeof(QByteArrayData)) \
    )
static const qt_meta_stringdata_TouchPresenter_t qt_meta_stringdata_TouchPresenter = {
    {
QT_MOC_LITERAL(0, 0, 14), // "TouchPresenter"
QT_MOC_LITERAL(1, 15, 13), // "agingFinished"
QT_MOC_LITERAL(2, 29, 0), // ""
QT_MOC_LITERAL(3, 30, 5), // "index"
QT_MOC_LITERAL(4, 36, 18), // "setUpgradeProgress"
QT_MOC_LITERAL(5, 55, 1), // "p"
QT_MOC_LITERAL(6, 57, 15), // "setTestProgress"
QT_MOC_LITERAL(7, 73, 15), // "upgradeFireware"
QT_MOC_LITERAL(8, 89, 4), // "path"
QT_MOC_LITERAL(9, 94, 12), // "startUpgrade"
QT_MOC_LITERAL(10, 107, 13), // "setCancelTest"
QT_MOC_LITERAL(11, 121, 1), // "t"
QT_MOC_LITERAL(12, 123, 14), // "setUpgradeFile"
QT_MOC_LITERAL(13, 138, 17), // "clearComboBoxData"
QT_MOC_LITERAL(14, 156, 14), // "setMessageText"
QT_MOC_LITERAL(15, 171, 7), // "message"
QT_MOC_LITERAL(16, 179, 17), // "appendMessageText"
QT_MOC_LITERAL(17, 197, 4), // "type"
QT_MOC_LITERAL(18, 202, 7), // "hotplug"
QT_MOC_LITERAL(19, 210, 2), // "in"
QT_MOC_LITERAL(20, 213, 9), // "startTest"
QT_MOC_LITERAL(21, 223, 17), // "getSignalDataDone"
QT_MOC_LITERAL(22, 241, 5), // "datas"
QT_MOC_LITERAL(23, 247, 7), // "stopAll"
QT_MOC_LITERAL(24, 255, 17), // "setTestThreadStop"
QT_MOC_LITERAL(25, 273, 4), // "stop"
QT_MOC_LITERAL(26, 278, 13), // "setUpdatePath"
QT_MOC_LITERAL(27, 292, 9), // "newRunner"
QT_MOC_LITERAL(28, 302, 14), // "updateFireware"
QT_MOC_LITERAL(29, 317, 13), // "getSignalData"
QT_MOC_LITERAL(30, 331, 5), // "count"
QT_MOC_LITERAL(31, 337, 14), // "getSignalItems"
QT_MOC_LITERAL(32, 352, 20), // "startGetSignalDataBg"
QT_MOC_LITERAL(33, 373, 19), // "stopGetSignalDataBg"
QT_MOC_LITERAL(34, 393, 21), // "stopGetSignalDataSync"
QT_MOC_LITERAL(35, 415, 7), // "tPrintf"
QT_MOC_LITERAL(36, 423, 3), // "str"
QT_MOC_LITERAL(37, 427, 5), // "_func"
QT_MOC_LITERAL(38, 433, 19), // "getBoardAndLampData"
QT_MOC_LITERAL(39, 453, 6), // "msleep"
QT_MOC_LITERAL(40, 460, 4), // "time"
QT_MOC_LITERAL(41, 465, 9), // "paintLock"
QT_MOC_LITERAL(42, 475, 11), // "paintUnlock"
QT_MOC_LITERAL(43, 487, 16), // "paintDefaultLock"
QT_MOC_LITERAL(44, 504, 18), // "paintDefaultUnlock"
QT_MOC_LITERAL(45, 523, 7), // "setTest"
QT_MOC_LITERAL(46, 531, 2), // "on"
QT_MOC_LITERAL(47, 534, 10), // "cancelTest"
QT_MOC_LITERAL(48, 545, 19), // "setTestThreadToStop"
QT_MOC_LITERAL(49, 565, 15), // "enterSignalMode"
QT_MOC_LITERAL(50, 581, 14), // "exitSignalMode"
QT_MOC_LITERAL(51, 596, 16), // "getSettingsInfos"
QT_MOC_LITERAL(52, 613, 11), // "setSettings"
QT_MOC_LITERAL(53, 625, 3), // "key"
QT_MOC_LITERAL(54, 629, 5), // "value"
QT_MOC_LITERAL(55, 635, 15), // "getRelativeInfo"
QT_MOC_LITERAL(56, 651, 20), // "whetherDeviceConnect"
QT_MOC_LITERAL(57, 672, 17), // "getDeviceInfoName"
QT_MOC_LITERAL(58, 690, 13), // "getDeviceInfo"
QT_MOC_LITERAL(59, 704, 17), // "getDeviceMainInfo"
QT_MOC_LITERAL(60, 722, 19), // "getSoftwareInfoName"
QT_MOC_LITERAL(61, 742, 15), // "getSoftwareInfo"
QT_MOC_LITERAL(62, 758, 10), // "signalInit"
QT_MOC_LITERAL(63, 769, 4), // "mode"
QT_MOC_LITERAL(64, 774, 16), // "getSettingsValue"
QT_MOC_LITERAL(65, 791, 15), // "getSettingsBool"
QT_MOC_LITERAL(66, 807, 16), // "setSettingsValue"
QT_MOC_LITERAL(67, 824, 19), // "getCalibrationDatas"
QT_MOC_LITERAL(68, 844, 5), // "where"
QT_MOC_LITERAL(69, 850, 19), // "setCalibrationDatas"
QT_MOC_LITERAL(70, 870, 20), // "enterCalibrationMode"
QT_MOC_LITERAL(71, 891, 19), // "exitCalibrationMode"
QT_MOC_LITERAL(72, 911, 12), // "enableCoords"
QT_MOC_LITERAL(73, 924, 6), // "enable"
QT_MOC_LITERAL(74, 931, 23), // "setCalibrationPointData"
QT_MOC_LITERAL(75, 955, 4), // "data"
QT_MOC_LITERAL(76, 960, 23), // "captureCalibrationIndex"
QT_MOC_LITERAL(77, 984, 21), // "getCalibrationCapture"
QT_MOC_LITERAL(78, 1006, 15), // "saveCalibration"
QT_MOC_LITERAL(79, 1022, 15), // "testCaliCapture"
QT_MOC_LITERAL(80, 1038, 14), // "testMultiPoint"
QT_MOC_LITERAL(81, 1053, 5), // "debug"
QT_MOC_LITERAL(82, 1059, 3), // "msg"
QT_MOC_LITERAL(83, 1063, 5), // "error"
QT_MOC_LITERAL(84, 1069, 17), // "isDeviceConnected"
QT_MOC_LITERAL(85, 1087, 16), // "setCoordsEnabled"
QT_MOC_LITERAL(86, 1104, 7), // "channel"
QT_MOC_LITERAL(87, 1112, 7), // "enabled"
QT_MOC_LITERAL(88, 1120, 15), // "isCoordsEnables"
QT_MOC_LITERAL(89, 1136, 16), // "updateSignalList"
QT_MOC_LITERAL(90, 1153, 4), // "list"
QT_MOC_LITERAL(91, 1158, 10), // "getAppType"
QT_MOC_LITERAL(92, 1169, 10), // "setAppType"
QT_MOC_LITERAL(93, 1180, 3), // "run"
QT_MOC_LITERAL(94, 1184, 3), // "app"
QT_MOC_LITERAL(95, 1188, 18), // "resetXYOrientation"
QT_MOC_LITERAL(96, 1207, 18), // "resetTouchRotation"
QT_MOC_LITERAL(97, 1226, 19), // "resetScreenRotation"
QT_MOC_LITERAL(98, 1246, 10), // "resetMacOs"
QT_MOC_LITERAL(99, 1257, 15), // "showExitMessage"
QT_MOC_LITERAL(100, 1273, 11), // "emitStopAll"
QT_MOC_LITERAL(101, 1285, 16), // "getUpgradeStatus"
QT_MOC_LITERAL(102, 1302, 11), // "isUpgrading"
QT_MOC_LITERAL(103, 1314, 9), // "isTesting"
QT_MOC_LITERAL(104, 1324, 9), // "isrunning"
QT_MOC_LITERAL(105, 1334, 11), // "modeSetting"
QT_MOC_LITERAL(106, 1346, 7), // "startup"
QT_MOC_LITERAL(107, 1354, 18) // "refreshModeSetting"

    },
    "TouchPresenter\0agingFinished\0\0index\0"
    "setUpgradeProgress\0p\0setTestProgress\0"
    "upgradeFireware\0path\0startUpgrade\0"
    "setCancelTest\0t\0setUpgradeFile\0"
    "clearComboBoxData\0setMessageText\0"
    "message\0appendMessageText\0type\0hotplug\0"
    "in\0startTest\0getSignalDataDone\0datas\0"
    "stopAll\0setTestThreadStop\0stop\0"
    "setUpdatePath\0newRunner\0updateFireware\0"
    "getSignalData\0count\0getSignalItems\0"
    "startGetSignalDataBg\0stopGetSignalDataBg\0"
    "stopGetSignalDataSync\0tPrintf\0str\0"
    "_func\0getBoardAndLampData\0msleep\0time\0"
    "paintLock\0paintUnlock\0paintDefaultLock\0"
    "paintDefaultUnlock\0setTest\0on\0cancelTest\0"
    "setTestThreadToStop\0enterSignalMode\0"
    "exitSignalMode\0getSettingsInfos\0"
    "setSettings\0key\0value\0getRelativeInfo\0"
    "whetherDeviceConnect\0getDeviceInfoName\0"
    "getDeviceInfo\0getDeviceMainInfo\0"
    "getSoftwareInfoName\0getSoftwareInfo\0"
    "signalInit\0mode\0getSettingsValue\0"
    "getSettingsBool\0setSettingsValue\0"
    "getCalibrationDatas\0where\0setCalibrationDatas\0"
    "enterCalibrationMode\0exitCalibrationMode\0"
    "enableCoords\0enable\0setCalibrationPointData\0"
    "data\0captureCalibrationIndex\0"
    "getCalibrationCapture\0saveCalibration\0"
    "testCaliCapture\0testMultiPoint\0debug\0"
    "msg\0error\0isDeviceConnected\0"
    "setCoordsEnabled\0channel\0enabled\0"
    "isCoordsEnables\0updateSignalList\0list\0"
    "getAppType\0setAppType\0run\0app\0"
    "resetXYOrientation\0resetTouchRotation\0"
    "resetScreenRotation\0resetMacOs\0"
    "showExitMessage\0emitStopAll\0"
    "getUpgradeStatus\0isUpgrading\0isTesting\0"
    "isrunning\0modeSetting\0startup\0"
    "refreshModeSetting"
};
#undef QT_MOC_LITERAL

static const uint qt_meta_data_TouchPresenter[] = {

 // content:
       7,       // revision
       0,       // classname
       0,    0, // classinfo
      84,   14, // methods
       0,    0, // properties
       0,    0, // enums/sets
       0,    0, // constructors
       0,       // flags
      16,       // signalCount

 // signals: name, argc, parameters, tag, flags
       1,    1,  434,    2, 0x06 /* Public */,
       4,    1,  437,    2, 0x06 /* Public */,
       6,    1,  440,    2, 0x06 /* Public */,
       7,    1,  443,    2, 0x06 /* Public */,
       9,    0,  446,    2, 0x06 /* Public */,
      10,    1,  447,    2, 0x06 /* Public */,
      12,    1,  450,    2, 0x06 /* Public */,
      13,    0,  453,    2, 0x06 /* Public */,
      14,    1,  454,    2, 0x06 /* Public */,
      16,    2,  457,    2, 0x06 /* Public */,
      18,    1,  462,    2, 0x06 /* Public */,
      20,    0,  465,    2, 0x06 /* Public */,
      21,    1,  466,    2, 0x06 /* Public */,
      23,    0,  469,    2, 0x06 /* Public */,
      24,    1,  470,    2, 0x06 /* Public */,
      26,    1,  473,    2, 0x06 /* Public */,

 // slots: name, argc, parameters, tag, flags
      27,    0,  476,    2, 0x0a /* Public */,

 // methods: name, argc, parameters, tag, flags
      28,    1,  477,    2, 0x02 /* Public */,
      29,    2,  480,    2, 0x02 /* Public */,
      29,    1,  485,    2, 0x22 /* Public | MethodCloned */,
      31,    0,  488,    2, 0x02 /* Public */,
      32,    1,  489,    2, 0x02 /* Public */,
      33,    0,  492,    2, 0x02 /* Public */,
      34,    0,  493,    2, 0x02 /* Public */,
      35,    2,  494,    2, 0x02 /* Public */,
      35,    1,  499,    2, 0x22 /* Public | MethodCloned */,
      38,    0,  502,    2, 0x02 /* Public */,
      39,    1,  503,    2, 0x02 /* Public */,
      41,    0,  506,    2, 0x02 /* Public */,
      42,    0,  507,    2, 0x02 /* Public */,
      43,    0,  508,    2, 0x02 /* Public */,
      44,    0,  509,    2, 0x02 /* Public */,
      45,    1,  510,    2, 0x02 /* Public */,
      47,    1,  513,    2, 0x02 /* Public */,
      48,    1,  516,    2, 0x02 /* Public */,
      49,    1,  519,    2, 0x02 /* Public */,
      50,    1,  522,    2, 0x02 /* Public */,
      51,    0,  525,    2, 0x02 /* Public */,
      52,    2,  526,    2, 0x02 /* Public */,
      55,    0,  531,    2, 0x02 /* Public */,
      56,    0,  532,    2, 0x02 /* Public */,
      57,    0,  533,    2, 0x02 /* Public */,
      58,    0,  534,    2, 0x02 /* Public */,
      59,    0,  535,    2, 0x02 /* Public */,
      60,    0,  536,    2, 0x02 /* Public */,
      61,    0,  537,    2, 0x02 /* Public */,
      62,    1,  538,    2, 0x02 /* Public */,
      64,    1,  541,    2, 0x02 /* Public */,
      65,    1,  544,    2, 0x02 /* Public */,
      66,    2,  547,    2, 0x02 /* Public */,
      67,    1,  552,    2, 0x02 /* Public */,
      69,    1,  555,    2, 0x02 /* Public */,
      70,    0,  558,    2, 0x02 /* Public */,
      71,    0,  559,    2, 0x02 /* Public */,
      72,    1,  560,    2, 0x02 /* Public */,
      74,    2,  563,    2, 0x02 /* Public */,
      76,    1,  568,    2, 0x02 /* Public */,
      77,    0,  571,    2, 0x02 /* Public */,
      78,    0,  572,    2, 0x02 /* Public */,
      79,    1,  573,    2, 0x02 /* Public */,
      79,    0,  576,    2, 0x22 /* Public | MethodCloned */,
      80,    0,  577,    2, 0x02 /* Public */,
      81,    1,  578,    2, 0x02 /* Public */,
      83,    1,  581,    2, 0x02 /* Public */,
      84,    0,  584,    2, 0x02 /* Public */,
      85,    2,  585,    2, 0x02 /* Public */,
      88,    1,  590,    2, 0x02 /* Public */,
      89,    1,  593,    2, 0x02 /* Public */,
      91,    0,  596,    2, 0x02 /* Public */,
      92,    1,  597,    2, 0x02 /* Public */,
      93,    1,  600,    2, 0x02 /* Public */,
      95,    0,  603,    2, 0x02 /* Public */,
      96,    0,  604,    2, 0x02 /* Public */,
      97,    0,  605,    2, 0x02 /* Public */,
      98,    0,  606,    2, 0x02 /* Public */,
      99,    0,  607,    2, 0x02 /* Public */,
     100,    0,  608,    2, 0x02 /* Public */,
     101,    0,  609,    2, 0x02 /* Public */,
     102,    0,  610,    2, 0x02 /* Public */,
     103,    0,  611,    2, 0x02 /* Public */,
     104,    0,  612,    2, 0x02 /* Public */,
     105,    1,  613,    2, 0x02 /* Public */,
     105,    0,  616,    2, 0x22 /* Public | MethodCloned */,
     107,    0,  617,    2, 0x02 /* Public */,

 // signals: parameters
    QMetaType::Void, QMetaType::Int,    3,
    QMetaType::Void, QMetaType::QVariant,    5,
    QMetaType::Void, QMetaType::QVariant,    5,
    QMetaType::Void, QMetaType::QString,    8,
    QMetaType::Void,
    QMetaType::Void, QMetaType::Bool,   11,
    QMetaType::Void, QMetaType::QString,    8,
    QMetaType::Void,
    QMetaType::Void, QMetaType::QVariant,   15,
    QMetaType::Void, QMetaType::QVariant, QMetaType::QVariant,   15,   17,
    QMetaType::Void, QMetaType::QVariant,   19,
    QMetaType::Void,
    QMetaType::Void, QMetaType::QVariantMap,   22,
    QMetaType::Void,
    QMetaType::Void, QMetaType::Bool,   25,
    QMetaType::Void, QMetaType::QString,    8,

 // slots: parameters
    QMetaType::Void,

 // methods: parameters
    QMetaType::Void, QMetaType::QVariant,    8,
    QMetaType::QVariantMap, QMetaType::QVariant, QMetaType::Int,    3,   30,
    QMetaType::QVariantMap, QMetaType::QVariant,    3,
    QMetaType::QVariantMap,
    QMetaType::Void, QMetaType::QVariant,    3,
    QMetaType::Void,
    QMetaType::Void,
    QMetaType::Void, QMetaType::QString, QMetaType::QString,   36,   37,
    QMetaType::Void, QMetaType::QString,   36,
    QMetaType::QVariantMap,
    QMetaType::Void, QMetaType::QVariant,   40,
    QMetaType::Void,
    QMetaType::Void,
    QMetaType::Void,
    QMetaType::Void,
    QMetaType::Void, QMetaType::QVariant,   46,
    QMetaType::Void, QMetaType::Bool,   11,
    QMetaType::Void, QMetaType::Bool,   25,
    QMetaType::Void, QMetaType::QVariantMap,   22,
    QMetaType::Void, QMetaType::QVariantMap,   22,
    QMetaType::QVariantMap,
    QMetaType::QVariant, QMetaType::QVariant, QMetaType::QVariant,   53,   54,
    QMetaType::QVariant,
    QMetaType::Bool,
    QMetaType::QVariant,
    QMetaType::QVariant,
    QMetaType::QVariant,
    QMetaType::QVariant,
    QMetaType::QVariant,
    QMetaType::Void, QMetaType::QVariant,   63,
    QMetaType::QVariant, QMetaType::QVariant,   53,
    QMetaType::QVariant, QMetaType::QVariant,   53,
    QMetaType::Void, QMetaType::QVariant, QMetaType::QVariant,   53,   54,
    QMetaType::QVariantMap, QMetaType::QVariant,   68,
    QMetaType::QVariant, QMetaType::QVariantMap,   22,
    QMetaType::QVariant,
    QMetaType::QVariant,
    QMetaType::QVariant, QMetaType::Bool,   73,
    QMetaType::QVariant, QMetaType::QVariant, QMetaType::QVariantMap,    3,   75,
    QMetaType::QVariant, QMetaType::QVariant,    3,
    QMetaType::QVariantMap,
    QMetaType::QVariant,
    QMetaType::QVariant, QMetaType::QVariant,   40,
    QMetaType::QVariant,
    QMetaType::QVariant,
    QMetaType::Void, QMetaType::QVariant,   82,
    QMetaType::Void, QMetaType::QVariant,   82,
    QMetaType::QVariant,
    QMetaType::Void, QMetaType::QVariant, QMetaType::QVariant,   86,   87,
    QMetaType::Bool, QMetaType::QVariant,   86,
    QMetaType::Void, QMetaType::QVariant,   90,
    QMetaType::Int,
    QMetaType::Void, QMetaType::Int,   17,
    QMetaType::Void, QMetaType::QVariant,   94,
    QMetaType::Int,
    QMetaType::Int,
    QMetaType::Int,
    QMetaType::Int,
    QMetaType::Void,
    QMetaType::Void,
    QMetaType::Void,
    QMetaType::Bool,
    QMetaType::Bool,
    QMetaType::Bool,
    QMetaType::Void, QMetaType::Bool,  106,
    QMetaType::Void,
    QMetaType::QVariantMap,

       0        // eod
};

void TouchPresenter::qt_static_metacall(QObject *_o, QMetaObject::Call _c, int _id, void **_a)
{
    if (_c == QMetaObject::InvokeMetaMethod) {
        TouchPresenter *_t = static_cast<TouchPresenter *>(_o);
        Q_UNUSED(_t)
        switch (_id) {
        case 0: _t->agingFinished((*reinterpret_cast< int(*)>(_a[1]))); break;
        case 1: _t->setUpgradeProgress((*reinterpret_cast< QVariant(*)>(_a[1]))); break;
        case 2: _t->setTestProgress((*reinterpret_cast< QVariant(*)>(_a[1]))); break;
        case 3: _t->upgradeFireware((*reinterpret_cast< QString(*)>(_a[1]))); break;
        case 4: _t->startUpgrade(); break;
        case 5: _t->setCancelTest((*reinterpret_cast< bool(*)>(_a[1]))); break;
        case 6: _t->setUpgradeFile((*reinterpret_cast< QString(*)>(_a[1]))); break;
        case 7: _t->clearComboBoxData(); break;
        case 8: _t->setMessageText((*reinterpret_cast< QVariant(*)>(_a[1]))); break;
        case 9: _t->appendMessageText((*reinterpret_cast< QVariant(*)>(_a[1])),(*reinterpret_cast< QVariant(*)>(_a[2]))); break;
        case 10: _t->hotplug((*reinterpret_cast< QVariant(*)>(_a[1]))); break;
        case 11: _t->startTest(); break;
        case 12: _t->getSignalDataDone((*reinterpret_cast< QVariantMap(*)>(_a[1]))); break;
        case 13: _t->stopAll(); break;
        case 14: _t->setTestThreadStop((*reinterpret_cast< bool(*)>(_a[1]))); break;
        case 15: _t->setUpdatePath((*reinterpret_cast< QString(*)>(_a[1]))); break;
        case 16: _t->newRunner(); break;
        case 17: _t->updateFireware((*reinterpret_cast< QVariant(*)>(_a[1]))); break;
        case 18: { QVariantMap _r = _t->getSignalData((*reinterpret_cast< QVariant(*)>(_a[1])),(*reinterpret_cast< int(*)>(_a[2])));
            if (_a[0]) *reinterpret_cast< QVariantMap*>(_a[0]) = _r; }  break;
        case 19: { QVariantMap _r = _t->getSignalData((*reinterpret_cast< QVariant(*)>(_a[1])));
            if (_a[0]) *reinterpret_cast< QVariantMap*>(_a[0]) = _r; }  break;
        case 20: { QVariantMap _r = _t->getSignalItems();
            if (_a[0]) *reinterpret_cast< QVariantMap*>(_a[0]) = _r; }  break;
        case 21: _t->startGetSignalDataBg((*reinterpret_cast< QVariant(*)>(_a[1]))); break;
        case 22: _t->stopGetSignalDataBg(); break;
        case 23: _t->stopGetSignalDataSync(); break;
        case 24: _t->tPrintf((*reinterpret_cast< QString(*)>(_a[1])),(*reinterpret_cast< QString(*)>(_a[2]))); break;
        case 25: _t->tPrintf((*reinterpret_cast< QString(*)>(_a[1]))); break;
        case 26: { QVariantMap _r = _t->getBoardAndLampData();
            if (_a[0]) *reinterpret_cast< QVariantMap*>(_a[0]) = _r; }  break;
        case 27: _t->msleep((*reinterpret_cast< QVariant(*)>(_a[1]))); break;
        case 28: _t->paintLock(); break;
        case 29: _t->paintUnlock(); break;
        case 30: _t->paintDefaultLock(); break;
        case 31: _t->paintDefaultUnlock(); break;
        case 32: _t->setTest((*reinterpret_cast< QVariant(*)>(_a[1]))); break;
        case 33: _t->cancelTest((*reinterpret_cast< bool(*)>(_a[1]))); break;
        case 34: _t->setTestThreadToStop((*reinterpret_cast< bool(*)>(_a[1]))); break;
        case 35: _t->enterSignalMode((*reinterpret_cast< QVariantMap(*)>(_a[1]))); break;
        case 36: _t->exitSignalMode((*reinterpret_cast< QVariantMap(*)>(_a[1]))); break;
        case 37: { QVariantMap _r = _t->getSettingsInfos();
            if (_a[0]) *reinterpret_cast< QVariantMap*>(_a[0]) = _r; }  break;
        case 38: { QVariant _r = _t->setSettings((*reinterpret_cast< QVariant(*)>(_a[1])),(*reinterpret_cast< QVariant(*)>(_a[2])));
            if (_a[0]) *reinterpret_cast< QVariant*>(_a[0]) = _r; }  break;
        case 39: { QVariant _r = _t->getRelativeInfo();
            if (_a[0]) *reinterpret_cast< QVariant*>(_a[0]) = _r; }  break;
        case 40: { bool _r = _t->whetherDeviceConnect();
            if (_a[0]) *reinterpret_cast< bool*>(_a[0]) = _r; }  break;
        case 41: { QVariant _r = _t->getDeviceInfoName();
            if (_a[0]) *reinterpret_cast< QVariant*>(_a[0]) = _r; }  break;
        case 42: { QVariant _r = _t->getDeviceInfo();
            if (_a[0]) *reinterpret_cast< QVariant*>(_a[0]) = _r; }  break;
        case 43: { QVariant _r = _t->getDeviceMainInfo();
            if (_a[0]) *reinterpret_cast< QVariant*>(_a[0]) = _r; }  break;
        case 44: { QVariant _r = _t->getSoftwareInfoName();
            if (_a[0]) *reinterpret_cast< QVariant*>(_a[0]) = _r; }  break;
        case 45: { QVariant _r = _t->getSoftwareInfo();
            if (_a[0]) *reinterpret_cast< QVariant*>(_a[0]) = _r; }  break;
        case 46: _t->signalInit((*reinterpret_cast< QVariant(*)>(_a[1]))); break;
        case 47: { QVariant _r = _t->getSettingsValue((*reinterpret_cast< QVariant(*)>(_a[1])));
            if (_a[0]) *reinterpret_cast< QVariant*>(_a[0]) = _r; }  break;
        case 48: { QVariant _r = _t->getSettingsBool((*reinterpret_cast< QVariant(*)>(_a[1])));
            if (_a[0]) *reinterpret_cast< QVariant*>(_a[0]) = _r; }  break;
        case 49: _t->setSettingsValue((*reinterpret_cast< QVariant(*)>(_a[1])),(*reinterpret_cast< QVariant(*)>(_a[2]))); break;
        case 50: { QVariantMap _r = _t->getCalibrationDatas((*reinterpret_cast< QVariant(*)>(_a[1])));
            if (_a[0]) *reinterpret_cast< QVariantMap*>(_a[0]) = _r; }  break;
        case 51: { QVariant _r = _t->setCalibrationDatas((*reinterpret_cast< QVariantMap(*)>(_a[1])));
            if (_a[0]) *reinterpret_cast< QVariant*>(_a[0]) = _r; }  break;
        case 52: { QVariant _r = _t->enterCalibrationMode();
            if (_a[0]) *reinterpret_cast< QVariant*>(_a[0]) = _r; }  break;
        case 53: { QVariant _r = _t->exitCalibrationMode();
            if (_a[0]) *reinterpret_cast< QVariant*>(_a[0]) = _r; }  break;
        case 54: { QVariant _r = _t->enableCoords((*reinterpret_cast< bool(*)>(_a[1])));
            if (_a[0]) *reinterpret_cast< QVariant*>(_a[0]) = _r; }  break;
        case 55: { QVariant _r = _t->setCalibrationPointData((*reinterpret_cast< QVariant(*)>(_a[1])),(*reinterpret_cast< QVariantMap(*)>(_a[2])));
            if (_a[0]) *reinterpret_cast< QVariant*>(_a[0]) = _r; }  break;
        case 56: { QVariant _r = _t->captureCalibrationIndex((*reinterpret_cast< QVariant(*)>(_a[1])));
            if (_a[0]) *reinterpret_cast< QVariant*>(_a[0]) = _r; }  break;
        case 57: { QVariantMap _r = _t->getCalibrationCapture();
            if (_a[0]) *reinterpret_cast< QVariantMap*>(_a[0]) = _r; }  break;
        case 58: { QVariant _r = _t->saveCalibration();
            if (_a[0]) *reinterpret_cast< QVariant*>(_a[0]) = _r; }  break;
        case 59: { QVariant _r = _t->testCaliCapture((*reinterpret_cast< QVariant(*)>(_a[1])));
            if (_a[0]) *reinterpret_cast< QVariant*>(_a[0]) = _r; }  break;
        case 60: { QVariant _r = _t->testCaliCapture();
            if (_a[0]) *reinterpret_cast< QVariant*>(_a[0]) = _r; }  break;
        case 61: { QVariant _r = _t->testMultiPoint();
            if (_a[0]) *reinterpret_cast< QVariant*>(_a[0]) = _r; }  break;
        case 62: _t->debug((*reinterpret_cast< QVariant(*)>(_a[1]))); break;
        case 63: _t->error((*reinterpret_cast< QVariant(*)>(_a[1]))); break;
        case 64: { QVariant _r = _t->isDeviceConnected();
            if (_a[0]) *reinterpret_cast< QVariant*>(_a[0]) = _r; }  break;
        case 65: _t->setCoordsEnabled((*reinterpret_cast< QVariant(*)>(_a[1])),(*reinterpret_cast< QVariant(*)>(_a[2]))); break;
        case 66: { bool _r = _t->isCoordsEnables((*reinterpret_cast< QVariant(*)>(_a[1])));
            if (_a[0]) *reinterpret_cast< bool*>(_a[0]) = _r; }  break;
        case 67: _t->updateSignalList((*reinterpret_cast< QVariant(*)>(_a[1]))); break;
        case 68: { int _r = _t->getAppType();
            if (_a[0]) *reinterpret_cast< int*>(_a[0]) = _r; }  break;
        case 69: _t->setAppType((*reinterpret_cast< int(*)>(_a[1]))); break;
        case 70: _t->run((*reinterpret_cast< QVariant(*)>(_a[1]))); break;
        case 71: { int _r = _t->resetXYOrientation();
            if (_a[0]) *reinterpret_cast< int*>(_a[0]) = _r; }  break;
        case 72: { int _r = _t->resetTouchRotation();
            if (_a[0]) *reinterpret_cast< int*>(_a[0]) = _r; }  break;
        case 73: { int _r = _t->resetScreenRotation();
            if (_a[0]) *reinterpret_cast< int*>(_a[0]) = _r; }  break;
        case 74: { int _r = _t->resetMacOs();
            if (_a[0]) *reinterpret_cast< int*>(_a[0]) = _r; }  break;
        case 75: _t->showExitMessage(); break;
        case 76: _t->emitStopAll(); break;
        case 77: _t->getUpgradeStatus(); break;
        case 78: { bool _r = _t->isUpgrading();
            if (_a[0]) *reinterpret_cast< bool*>(_a[0]) = _r; }  break;
        case 79: { bool _r = _t->isTesting();
            if (_a[0]) *reinterpret_cast< bool*>(_a[0]) = _r; }  break;
        case 80: { bool _r = _t->isrunning();
            if (_a[0]) *reinterpret_cast< bool*>(_a[0]) = _r; }  break;
        case 81: _t->modeSetting((*reinterpret_cast< bool(*)>(_a[1]))); break;
        case 82: _t->modeSetting(); break;
        case 83: { QVariantMap _r = _t->refreshModeSetting();
            if (_a[0]) *reinterpret_cast< QVariantMap*>(_a[0]) = _r; }  break;
        default: ;
        }
    } else if (_c == QMetaObject::IndexOfMethod) {
        int *result = reinterpret_cast<int *>(_a[0]);
        void **func = reinterpret_cast<void **>(_a[1]);
        {
            typedef void (TouchPresenter::*_t)(int );
            if (*reinterpret_cast<_t *>(func) == static_cast<_t>(&TouchPresenter::agingFinished)) {
                *result = 0;
                return;
            }
        }
        {
            typedef void (TouchPresenter::*_t)(QVariant );
            if (*reinterpret_cast<_t *>(func) == static_cast<_t>(&TouchPresenter::setUpgradeProgress)) {
                *result = 1;
                return;
            }
        }
        {
            typedef void (TouchPresenter::*_t)(QVariant );
            if (*reinterpret_cast<_t *>(func) == static_cast<_t>(&TouchPresenter::setTestProgress)) {
                *result = 2;
                return;
            }
        }
        {
            typedef void (TouchPresenter::*_t)(QString );
            if (*reinterpret_cast<_t *>(func) == static_cast<_t>(&TouchPresenter::upgradeFireware)) {
                *result = 3;
                return;
            }
        }
        {
            typedef void (TouchPresenter::*_t)();
            if (*reinterpret_cast<_t *>(func) == static_cast<_t>(&TouchPresenter::startUpgrade)) {
                *result = 4;
                return;
            }
        }
        {
            typedef void (TouchPresenter::*_t)(bool );
            if (*reinterpret_cast<_t *>(func) == static_cast<_t>(&TouchPresenter::setCancelTest)) {
                *result = 5;
                return;
            }
        }
        {
            typedef void (TouchPresenter::*_t)(QString );
            if (*reinterpret_cast<_t *>(func) == static_cast<_t>(&TouchPresenter::setUpgradeFile)) {
                *result = 6;
                return;
            }
        }
        {
            typedef void (TouchPresenter::*_t)();
            if (*reinterpret_cast<_t *>(func) == static_cast<_t>(&TouchPresenter::clearComboBoxData)) {
                *result = 7;
                return;
            }
        }
        {
            typedef void (TouchPresenter::*_t)(QVariant );
            if (*reinterpret_cast<_t *>(func) == static_cast<_t>(&TouchPresenter::setMessageText)) {
                *result = 8;
                return;
            }
        }
        {
            typedef void (TouchPresenter::*_t)(QVariant , QVariant );
            if (*reinterpret_cast<_t *>(func) == static_cast<_t>(&TouchPresenter::appendMessageText)) {
                *result = 9;
                return;
            }
        }
        {
            typedef void (TouchPresenter::*_t)(QVariant );
            if (*reinterpret_cast<_t *>(func) == static_cast<_t>(&TouchPresenter::hotplug)) {
                *result = 10;
                return;
            }
        }
        {
            typedef void (TouchPresenter::*_t)();
            if (*reinterpret_cast<_t *>(func) == static_cast<_t>(&TouchPresenter::startTest)) {
                *result = 11;
                return;
            }
        }
        {
            typedef void (TouchPresenter::*_t)(QVariantMap );
            if (*reinterpret_cast<_t *>(func) == static_cast<_t>(&TouchPresenter::getSignalDataDone)) {
                *result = 12;
                return;
            }
        }
        {
            typedef void (TouchPresenter::*_t)();
            if (*reinterpret_cast<_t *>(func) == static_cast<_t>(&TouchPresenter::stopAll)) {
                *result = 13;
                return;
            }
        }
        {
            typedef void (TouchPresenter::*_t)(bool );
            if (*reinterpret_cast<_t *>(func) == static_cast<_t>(&TouchPresenter::setTestThreadStop)) {
                *result = 14;
                return;
            }
        }
        {
            typedef void (TouchPresenter::*_t)(QString );
            if (*reinterpret_cast<_t *>(func) == static_cast<_t>(&TouchPresenter::setUpdatePath)) {
                *result = 15;
                return;
            }
        }
    }
}

const QMetaObject TouchPresenter::staticMetaObject = {
    { &QObject::staticMetaObject, qt_meta_stringdata_TouchPresenter.data,
      qt_meta_data_TouchPresenter,  qt_static_metacall, Q_NULLPTR, Q_NULLPTR}
};


const QMetaObject *TouchPresenter::metaObject() const
{
    return QObject::d_ptr->metaObject ? QObject::d_ptr->dynamicMetaObject() : &staticMetaObject;
}

void *TouchPresenter::qt_metacast(const char *_clname)
{
    if (!_clname) return Q_NULLPTR;
    if (!strcmp(_clname, qt_meta_stringdata_TouchPresenter.stringdata0))
        return static_cast<void*>(const_cast< TouchPresenter*>(this));
    return QObject::qt_metacast(_clname);
}

int TouchPresenter::qt_metacall(QMetaObject::Call _c, int _id, void **_a)
{
    _id = QObject::qt_metacall(_c, _id, _a);
    if (_id < 0)
        return _id;
    if (_c == QMetaObject::InvokeMetaMethod) {
        if (_id < 84)
            qt_static_metacall(this, _c, _id, _a);
        _id -= 84;
    } else if (_c == QMetaObject::RegisterMethodArgumentMetaType) {
        if (_id < 84)
            *reinterpret_cast<int*>(_a[0]) = -1;
        _id -= 84;
    }
    return _id;
}

// SIGNAL 0
void TouchPresenter::agingFinished(int _t1)
{
    void *_a[] = { Q_NULLPTR, const_cast<void*>(reinterpret_cast<const void*>(&_t1)) };
    QMetaObject::activate(this, &staticMetaObject, 0, _a);
}

// SIGNAL 1
void TouchPresenter::setUpgradeProgress(QVariant _t1)
{
    void *_a[] = { Q_NULLPTR, const_cast<void*>(reinterpret_cast<const void*>(&_t1)) };
    QMetaObject::activate(this, &staticMetaObject, 1, _a);
}

// SIGNAL 2
void TouchPresenter::setTestProgress(QVariant _t1)
{
    void *_a[] = { Q_NULLPTR, const_cast<void*>(reinterpret_cast<const void*>(&_t1)) };
    QMetaObject::activate(this, &staticMetaObject, 2, _a);
}

// SIGNAL 3
void TouchPresenter::upgradeFireware(QString _t1)
{
    void *_a[] = { Q_NULLPTR, const_cast<void*>(reinterpret_cast<const void*>(&_t1)) };
    QMetaObject::activate(this, &staticMetaObject, 3, _a);
}

// SIGNAL 4
void TouchPresenter::startUpgrade()
{
    QMetaObject::activate(this, &staticMetaObject, 4, Q_NULLPTR);
}

// SIGNAL 5
void TouchPresenter::setCancelTest(bool _t1)
{
    void *_a[] = { Q_NULLPTR, const_cast<void*>(reinterpret_cast<const void*>(&_t1)) };
    QMetaObject::activate(this, &staticMetaObject, 5, _a);
}

// SIGNAL 6
void TouchPresenter::setUpgradeFile(QString _t1)
{
    void *_a[] = { Q_NULLPTR, const_cast<void*>(reinterpret_cast<const void*>(&_t1)) };
    QMetaObject::activate(this, &staticMetaObject, 6, _a);
}

// SIGNAL 7
void TouchPresenter::clearComboBoxData()
{
    QMetaObject::activate(this, &staticMetaObject, 7, Q_NULLPTR);
}

// SIGNAL 8
void TouchPresenter::setMessageText(QVariant _t1)
{
    void *_a[] = { Q_NULLPTR, const_cast<void*>(reinterpret_cast<const void*>(&_t1)) };
    QMetaObject::activate(this, &staticMetaObject, 8, _a);
}

// SIGNAL 9
void TouchPresenter::appendMessageText(QVariant _t1, QVariant _t2)
{
    void *_a[] = { Q_NULLPTR, const_cast<void*>(reinterpret_cast<const void*>(&_t1)), const_cast<void*>(reinterpret_cast<const void*>(&_t2)) };
    QMetaObject::activate(this, &staticMetaObject, 9, _a);
}

// SIGNAL 10
void TouchPresenter::hotplug(QVariant _t1)
{
    void *_a[] = { Q_NULLPTR, const_cast<void*>(reinterpret_cast<const void*>(&_t1)) };
    QMetaObject::activate(this, &staticMetaObject, 10, _a);
}

// SIGNAL 11
void TouchPresenter::startTest()
{
    QMetaObject::activate(this, &staticMetaObject, 11, Q_NULLPTR);
}

// SIGNAL 12
void TouchPresenter::getSignalDataDone(QVariantMap _t1)
{
    void *_a[] = { Q_NULLPTR, const_cast<void*>(reinterpret_cast<const void*>(&_t1)) };
    QMetaObject::activate(this, &staticMetaObject, 12, _a);
}

// SIGNAL 13
void TouchPresenter::stopAll()
{
    QMetaObject::activate(this, &staticMetaObject, 13, Q_NULLPTR);
}

// SIGNAL 14
void TouchPresenter::setTestThreadStop(bool _t1)
{
    void *_a[] = { Q_NULLPTR, const_cast<void*>(reinterpret_cast<const void*>(&_t1)) };
    QMetaObject::activate(this, &staticMetaObject, 14, _a);
}

// SIGNAL 15
void TouchPresenter::setUpdatePath(QString _t1)
{
    void *_a[] = { Q_NULLPTR, const_cast<void*>(reinterpret_cast<const void*>(&_t1)) };
    QMetaObject::activate(this, &staticMetaObject, 15, _a);
}
QT_END_MOC_NAMESPACE
