QT += core gui network serialport help
greaterThan(QT_MAJOR_VERSION, 4): QT += widgets printsupport

CONFIG += c++11

VERSION = 0.1.5
MIN_FW = 0.2.3

DEFINES += APP_VERSION=\\\"$$VERSION\\\"
DEFINES += MIN_FW_VER=\\\"$$MIN_FW\\\"
DEFINES += QT_DEPRECATED_WARNINGS

win32:RC_ICONS = icon.ico
macx: ICON = icon.icns

greaterThan(QT_MAJOR_VERSION, 4){
    TARGET_ARCH = $${QT_ARCH}
}else{
    TARGET_ARCH = $${QMAKE_HOST.arch}
}

# =================================================
# QSimpleUpdater (vendored – CI safe)
# =================================================
INCLUDEPATH += $$PWD/src/thirdparty/qsimpleupdater

SOURCES += \
    src/thirdparty/qsimpleupdater/QSimpleUpdater.cpp

HEADERS += \
    src/thirdparty/qsimpleupdater/QSimpleUpdater.h

# =================================================
# Platform specific
# =================================================

LINUX_LIB_DIR = ubuntu_18
MACOS_LIB_DIR = mac_10.15

win32 {

    ARCHITECTURE = win64
    QMAKE_LIBDIR += $$PWD/lib/win64
    LIBS += $$PWD/lib/win64/libfftw3-3.dll

    CONFIG(release, debug|release): DESTDIR = $$PWD/build/windows/release
    CONFIG(debug, debug|release): DESTDIR = $$PWD/build/windows/debug

    inst.files += $$PWD/lib/win64/libfftw3-3.dll
    inst.path += $${DESTDIR}
    INSTALLS += inst

    help.files += "$${PWD}/doc/EMBO.chm" \
                  "$${PWD}/doc/EMBO.pdf"
    help.path += $${DESTDIR}/doc
    INSTALLS += help
}

linux {

    ARCHITECTURE = linux
    QMAKE_LIBDIR += $$PWD/lib/$$LINUX_LIB_DIR
    LIBS += $$PWD/lib/$$LINUX_LIB_DIR/libfftw3.a

    CONFIG(release, debug|release): DESTDIR = $$PWD/build/linux/release
    CONFIG(debug, debug|release): DESTDIR = $$PWD/build/linux/debug
}

macx {

    ARCHITECTURE = mac
    QMAKE_LIBDIR += $$PWD/lib/$$MACOS_LIB_DIR
    LIBS += -framework AppKit
    LIBS += $$PWD/lib/$$MACOS_LIB_DIR/libfftw3.a

    CONFIG(release, debug|release): DESTDIR = $$PWD/build/mac/release
    CONFIG(debug, debug|release): DESTDIR = $$PWD/build/mac/debug
}

# =================================================
# Project metadata
# =================================================

QMAKE_TARGET_COMPANY = CTU Jakub Parez
QMAKE_TARGET_PRODUCT = EMBO
QMAKE_TARGET_DESCRIPTION = EMBedded Oscilloscope
QMAKE_TARGET_COPYRIGHT = CTU Jakub Parez

QMAKE_CXXFLAGS += -Wno-deprecated -Wno-deprecated-declarations
QMAKE_POST_LINK = $(MAKE) install

# =================================================
# Includes
# =================================================

INCLUDEPATH += src
INCLUDEPATH += src/windows

# =================================================
# Sources / Headers / Forms
# =================================================

SOURCES += \
    lib/qdial2.cpp \
    lib/ctkrangeslider.cpp \
    lib/qcustomplot.cpp \
    src/main.cpp \
    src/core.cpp \
    src/messages.cpp \
    src/msg.cpp \
    src/qcpcursors.cpp \
    src/recorder.cpp \
    src/settings.cpp \
    src/utils.cpp \
    src/windows/window__main.cpp \
    src/windows/window_cntr.cpp \
    src/windows/window_la.cpp \
    src/windows/window_pwm.cpp \
    src/windows/window_scope.cpp \
    src/windows/window_sgen.cpp \
    src/windows/window_vm.cpp

HEADERS += \
    lib/qdial2.h \
    lib/ctkrangeslider.h \
    lib/qcustomplot.h \
    lib/fftw3.h \
    src/containers.h \
    src/core.h \
    src/css.h \
    src/interfaces.h \
    src/messages.h \
    src/movemean.h \
    src/msg.h \
    src/qcpcursors.h \
    src/recorder.h \
    src/settings.h \
    src/utils.h \
    src/windows/window__main.h \
    src/windows/window_cntr.h \
    src/windows/window_la.h \
    src/windows/window_pwm.h \
    src/windows/window_scope.h \
    src/windows/window_sgen.h \
    src/windows/window_vm.h

FORMS += \
    src/windows/window__main.ui \
    src/windows/window_cntr.ui \
    src/windows/window_la.ui \
    src/windows/window_pwm.ui \
    src/windows/window_scope.ui \
    src/windows/window_sgen.ui \
    src/windows/window_vm.ui

RESOURCES += resources/resources.qrc

DISTFILES += \
    icon.icns \
    icon.ico
