QT += core
QT -= gui

CONFIG += c++11

TARGET = needAdminPermission
#CONFIG += console
CONFIG -= app_bundle

TEMPLATE = app

SOURCES += main.cpp \
    tdebug.cpp

RC_FILE=uac.rc


HEADERS += \
    tdebug.h
