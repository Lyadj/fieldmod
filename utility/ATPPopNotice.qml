/*

  设计弹窗提醒的弹窗

*/

import QtQuick 2.14
import QtQuick.Controls 2.12
import QtQuick.Layouts 1.12

import QtGraphicalEffects 1.14
import QtQuick.Controls.Styles 1.4
import QtQuick.Controls.Material 2.12

Popup{
    id:notice_1


    property string notice_str: qsTr("提示信息")
    property int animation_time: 300

    font.family: sourceNotoFont.name
    font.pixelSize: 20
    Material.theme: Material.Dark



    //----------普通信息颜色
    property color n1col: "#ffffff"
    //--------------警示颜色
    property color n2col: "#FF9800"
    //-----------错误信息颜色
    property color n3col: "#F44336"

    property var iconinfolist: {
                          "info":{"icon":qsTr("qrc:/resources/info_icon.svg"),
                             "color":n1col},
                          "warn":{"icon":qsTr("qrc:/resources/warn_icon.svg"),
                             "color":n2col},
                          "error":{"icon":qsTr("qrc:/resources/error_icon.svg"),
                             "color":n3col}
                          }

    property string cicon: iconinfolist["info"]["icon"]
    property string ccol: iconinfolist["info"]["color"]

    property color flowcol: "white"


    //--------------背景设置
    background: Item{

        Material.theme: Material.Dark

        RectangularGlow {
            id: effect
            anchors.fill: rect
            glowRadius: 4
            spread: 0.0
            color: flowcol
            cornerRadius: 8
        }

        Rectangle {
            id: rect
            color: "navy"
            anchors.centerIn: parent
            width: parent.width
            height: parent.height
        }

    }

    //---------------------------信息提示窗口: 弹出与消失的动画
    enter: Transition {
        NumberAnimation{
            properties: "scale"
            from:0
            to:1
            easing.type: Easing.OutBounce
            duration:animation_time
        }
    }
    exit: Transition {
    }

    Label{
        id:noticelable
        anchors.centerIn: parent
        text:notice_str
        color: ccol
        font.pixelSize: 24
    }

    ToolButton{
        id:noticebtn
        icon.source: cicon
        icon.color:ccol
        anchors.right: noticelable.left
        anchors.verticalCenter: noticelable.verticalCenter
        scale: 1.5

    }

    closePolicy: Popup.CloseOnEscape | Popup.CloseOnPressOutside

    function pop_info(debug_info){

        cicon = iconinfolist["info"]["icon"]
        ccol = iconinfolist["info"]["color"]
        notice_str = debug_info
        notice_1.open()
    }

    function pop_warn(warn_info){

        cicon = iconinfolist["warn"]["icon"]
        ccol = iconinfolist["warn"]["color"]
        notice_str = warn_info
        notice_1.open()
    }

    function pop_error(error_info){

        cicon = iconinfolist["error"]["icon"]
        ccol = iconinfolist["error"]["color"]
        notice_str = error_info
        notice_1.open()
    }


}

