QT += core
QT -= gui

CONFIG += c++11

TARGET = needAdminPermission
#CONFIG += console
CONFIG -= app_bundle

TEMPLATE = app

SOURCES += main.cpp \
    tdebug.cpp \
    manager.cpp

RC_FILE=uac.rc


HEADERS += \
    tdebug.h \
    manager.h \
    sdk/TouchManager.h \
    sdk/hidapi.h \
    sdk/touch.h

LIBS += -LD:\qt\PC_TouchProject\touch D:\qt\PC_TouchProject\touch\touch.dll
