/****************************************************************************
**
** Copyright (C) 2016 The Qt Company Ltd.
** Contact: https://www.qt.io/licensing/
**
** This file is part of the Qt Virtual Keyboard module of the Qt Toolkit.
**
** $QT_BEGIN_LICENSE:GPL$
** Commercial License Usage
** Licensees holding valid commercial Qt licenses may use this file in
** accordance with the commercial license agreement provided with the
** Software or, alternatively, in accordance with the terms contained in
** a written agreement between you and The Qt Company. For licensing terms
** and conditions see https://www.qt.io/terms-conditions. For further
** information use the contact form at https://www.qt.io/contact-us.
**
** GNU General Public License Usage
** Alternatively, this file may be used under the terms of the GNU
** General Public License version 3 or (at your option) any later version
** approved by the KDE Free Qt Foundation. The licenses are as published by
** the Free Software Foundation and appearing in the file LICENSE.GPL3
** included in the packaging of this file. Please review the following
** information to ensure the GNU General Public License requirements will
** be met: https://www.gnu.org/licenses/gpl-3.0.html.
**
** $QT_END_LICENSE$
**
****************************************************************************/

import QtQuick 2.0
import QtQuick.Layouts 1.0
import QtQuick.VirtualKeyboard 2.1
import QtQuick.VirtualKeyboard.Plugins 2.3

KeyboardLayout {
    inputMethod: PlainInputMethod {}
    inputMode: InputEngine.InputMode.Numeric


    KeyboardColumn {
        Layout.fillWidth: false
        Layout.preferredWidth: height*1.2
        Layout.fillHeight: true
        Layout.alignment: Qt.AlignHCenter
        KeyboardRow {
            Key {
                key: Qt.Key_1
                text: "1"
            }
            Key {
                key: Qt.Key_2
                text: "2"
            }
            Key {
                key: Qt.Key_3
                text: "3"
            }
            Key {
                key: Qt.Key_4
                text: "4"
            }
            BackspaceKey {}
        }
        KeyboardRow {
            Key {
                key: Qt.Key_5
                text: "5"
            }
            Key {
                key: Qt.Key_6
                text: "6"
            }
            Key {
                key: Qt.Key_7
                text: "7"
            }
            Key {
                key: Qt.Key_8
                text: "8"
            }
            Key {
                text: " "
                displayText: "\u2423"
                repeat: true
                showPreview: false
                key: Qt.Key_Space
            }
        }
        KeyboardRow {
            Key {
                key: Qt.Key_9
                text: "9"
            }
            Key {
                key: Qt.Key_0
                text: "0"
            }
            Key {
                key: Qt.Key_A
                text: "A"
            }
            Key {
                key: Qt.Key_B
                text: "B"
            }
            HideKeyboardKey {}
        }
        KeyboardRow {
            Key {
                key: Qt.Key_C
                text: "C"
            }
            Key {
                key: Qt.Key_D
                text: "D"
            }
            Key {
                key: Qt.Key_C
                text: "E"
            }
            Key {
                key: Qt.Key_C
                text: "F"
            }
            EnterKey {

            }
        }
    }
}
