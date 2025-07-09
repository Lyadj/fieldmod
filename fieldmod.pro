QT += quick virtualkeyboard widgets svg serialbus serialport core

CONFIG += c++17

# You can make your code fail to compile if it uses deprecated APIs.
# In order to do so, uncomment the following line.
#DEFINES += QT_DISABLE_DEPRECATED_BEFORE=0x060000    # disables all the APIs deprecated before Qt 6.0.0

RESOURCES += qml.qrc

# Additional import path used to resolve QML modules in Qt Creator's code model
QML_IMPORT_PATH =

# Additional import path used to resolve QML modules just for Qt Quick Designer
QML_DESIGNER_IMPORT_PATH =

# Default rules for deployment.
qnx: target.path = /tmp/$${TARGET}/bin
else: unix:!android: target.path = /opt/$${TARGET}/bin
!isEmpty(target.path): INSTALLS += target

HEADERS += \
    CRC16/crc16.h \
    gripper/include/Gripper.Commons.hpp \
    gripper/include/Gripper.h \
    serialtool/include/Serialtool.Commons.hpp \
    serialtool/include/Serialtool.h \
    utility/include/utility.h

SOURCES += \
        CRC16/crc16.cpp \
        gripper/src/Gripper.cpp \
        main.cpp \
        serialtool/src/Serialtool.cpp
