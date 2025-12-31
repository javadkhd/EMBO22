QT += core gui network serialport
greaterThan(QT_MAJOR_VERSION, 4): QT += widgets printsupport

CONFIG += c++11 release
TEMPLATE = app

VERSION = 0.1.5
MIN_FW  = 0.2.3

DEFINES += APP_VERSION=\\\"$$VERSION\\\"
DEFINES += MIN_FW_VER=\\\"$$MIN_FW\\\"
DEFINES += QT_DEPRECATED_WARNINGS

win32:RC_ICONS = icon.ico
macx:ICON = icon.icns

# -------------------------------------------------
# Optional QtHelp
# -------------------------------------------------
qtHaveModule(help) {
    QT += help
    DEFINES += HAS_QT_HELP
}

# -------------------------------------------------
# QSimpleUpdater
# -------------------------------------------------
exists($$PWD/__updater/QSimpleUpdater.pri) {
    include($$PWD/__updater/QSimpleUpdater.pri)
    message("QSimpleUpdater included successfully")
} else {
    DEFINES += NO_UPDATER
    message("QSimpleUpdater NOT found - building without updater support")
}

# -------------------------------------------------
# Architecture Detection
# -------------------------------------------------
greaterThan(QT_MAJOR_VERSION, 4) {
    TARGET_ARCH = $$QT_ARCH
} else {
    TARGET_ARCH = $$QMAKE_HOST. arch
}

# =================================================
# WINDOWS BUILD
# =================================================
# =================================================
# WINDOWS BUILD
# =================================================
win32 {

    ARCHITECTURE = windows
    DESTDIR = $$PWD/build/windows

    # -------------------------------------------------
    # Crash Handler (QBreakpad)
    # -------------------------------------------------
    exists($$PWD/lib/win64/libqBreakpad.a) {

        DEFINES += HAS_QBREAKPAD

        INCLUDEPATH += $$PWD/__crashhandler/handler
        INCLUDEPATH += $$PWD/lib/include

        HEADERS += \
            $$PWD/__crashhandler/handler/QBreakpadHandler.h

        SOURCES += \
            $$PWD/__crashhandler/handler/QBreakpadHandler.cpp

        LIBS += -L$$PWD/lib/win64 -lqBreakpad

    } else {

        DEFINES += NO_BREAKPAD
    }

    # -------------------------------------------------
    # FFTW (runtime DLL copy)
    # -------------------------------------------------
    contains(QT_ARCH, x86_64) {

        INSTALL_DLL = $$PWD/lib/win64/libfftw3-3.dll

    } else {

        INSTALL_DLL = $$PWD/lib/win32/libfftw3-3.dll
    }

    inst.files = $$INSTALL_DLL
    inst.path  = $$DESTDIR
    INSTALLS  += inst

    # -------------------------------------------------
    # Documentation
    # -------------------------------------------------
    help.files = \
        $$PWD/doc/EMBO.chm \
        $$PWD/doc/EMBO.pdf

    help.path  = $$DESTDIR/doc
    INSTALLS  += help
}


# =================================================
# LINUX BUILD
# =================================================
unix: ! macx {
    TARGET = EMBO
    ARCHITECTURE = linux
    DESTDIR = $$PWD/build/linux/release
    CONFIG += link_pkgconfig
    PKGCONFIG += fftw3
}

# =================================================
# macOS BUILD
# =================================================
macx {
    TARGET = EMBO
    ARCHITECTURE = macos
    DESTDIR = $$PWD/build/macos/release
    CONFIG += link_pkgconfig
    PKGCONFIG += fftw3
    LIBS += -framework AppKit
    CONFIG += sdk_no_version_check

    exists($$PWD/lib/mac_10. 15/libqBreakpad.a) {
        LIBS += -L$$PWD/lib/mac_10.15 -lqBreakpad
        DEFINES += HAS_QBREAKPAD
    }
}

# -------------------------------------------------
# Compiler flags
# -------------------------------------------------
QMAKE_CXXFLAGS += -Wno-deprecated -Wno-deprecated-declarations

# -------------------------------------------------
# Include paths
# -------------------------------------------------
INCLUDEPATH += src
INCLUDEPATH += src/windows

# -------------------------------------------------
# Sources
# -------------------------------------------------
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
    src/core.h \
    src/containers.h \
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
