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
macx: ICON = icon.icns

# -------------------------------------------------
# Architecture detection
# -------------------------------------------------
greaterThan(QT_MAJOR_VERSION, 4) {
    TARGET_ARCH = $$QT_ARCH
} else {
    TARGET_ARCH = $$QMAKE_HOST.arch
}

# -------------------------------------------------
# Updater
# -------------------------------------------------
include(__updater/QSimpleUpdater.pri)

# =================================================
# ================ WINDOWS ========================
# =================================================
win32 {

    QT += help
    include(__crashhandler/qBreakpad.pri)

    contains(TARGET_ARCH, x86_64) {
        ARCHITECTURE = win64
        DESTDIR = $$PWD/build/windows/x64
        QMAKE_LIBDIR += $$PWD/lib/win64
        LIBS += $$PWD/lib/win64/libqBreakpad.a
        INSTALL_DLL = $$PWD/lib/win64/libfftw3-3.dll
    } else {
        ARCHITECTURE = win32
        DESTDIR = $$PWD/build/windows/x86
        QMAKE_LIBDIR += $$PWD/lib/win32
        LIBS += $$PWD/lib/win32/libqBreakpad.a
        INSTALL_DLL = $$PWD/lib/win32/libfftw3-3.dll
    }

    LIBS += -lfftw3-3

    inst.files = $$INSTALL_DLL
    inst.path = $$DESTDIR
    INSTALLS += inst

    help.files += $$PWD/doc/EMBO.chm $$PWD/doc/EMBO.pdf
    help.path = $$DESTDIR/doc
    INSTALLS += help
}

# =================================================
# ================= LINUX =========================
# =================================================
unix:!macx {

    ARCHITECTURE = linux
    DESTDIR = $$PWD/build/linux

    CONFIG += link_pkgconfig
    PKGCONFIG += fftw3

    QMAKE_CXXFLAGS += -fPIC

    # Optional breakpad
    # include(__crashhandler/qBreakpad.pri)
}

# =================================================
# ================= macOS =========================
# =================================================

macx {

    ARCHITECTURE = macos
    DESTDIR = $$PWD/build/macos

    CONFIG += link_pkgconfig
    PKGCONFIG += fftw3

    LIBS += -framework AppKit

    # ---------------------------------------------
    # !!! Breakpad DISABLED on macOS !!!
    # ---------------------------------------------
    DEFINES += NO_BREAKPAD
    message("macOS: Breakpad explicitly disabled")
}


# -------------------------------------------------
# Compiler flags
# -------------------------------------------------
QMAKE_CXXFLAGS += -Wno-deprecated -Wno-deprecated-declarations

# -------------------------------------------------
# Metadata
# -------------------------------------------------
QMAKE_TARGET_COMPANY = "CTU Javad Khadem"
QMAKE_TARGET_PRODUCT = "EMBO"
QMAKE_TARGET_DESCRIPTION = "EMBedded Oscilloscope"
QMAKE_TARGET_COPYRIGHT = "© CTU Javad Khadem"

# -------------------------------------------------
# Install target
# -------------------------------------------------
unix:!android {
    target.path = /opt/$$TARGET/bin
    INSTALLS += target
}

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

# -------------------------------------------------
# Headers
# -------------------------------------------------
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

# -------------------------------------------------
# UI Forms
# -------------------------------------------------
FORMS += \
    src/windows/window__main.ui \
    src/windows/window_cntr.ui \
    src/windows/window_la.ui \
    src/windows/window_pwm.ui \
    src/windows/window_scope.ui \
    src/windows/window_sgen.ui \
    src/windows/window_vm.ui

# -------------------------------------------------
# Resources
# -------------------------------------------------
RESOURCES += resources/resources.qrc

# -------------------------------------------------
# Distribution files
# -------------------------------------------------
DISTFILES += \
    icon.icns \
    icon.ico
