import QtQuick 2.14
import QtQuick.Controls 2.14
import QtQuick.Controls.Material 2.14
import QtGraphicalEffects 1.12
import QtQuick.Layouts 1.14

ScrollView {
    id:log_1

    ScrollBar.vertical.policy:ScrollBar.AlwaysOn
    ScrollBar.vertical.interactive:true
    ScrollBar.vertical.width:6*hgap

    property real vgap: 0.01*parent.height
    property real hgap: 0.01*parent.width
    property string transcolor: "transparent"

    //---------------------右键点击日志窗口出现选择菜单： 清除/全选/复制
    Menu {
        id: editMenu
        font.pixelSize: 18
        font.family:sourceNotoFont.name
        function openMenu() {
            popup()
        }
        MenuItem {
            text: qsTr("清除")
            onTriggered:{
                edit.clear()
                edit.text = new Date().toLocaleString(Qt.locale(), "yyyy年MM月dd号 HH:mm:ss<br></br>")
                            + qsTr("日志窗口已清除<br></br>")
            }
        }
        MenuItem {
            text: qsTr("全选")
            onTriggered: edit.selectAll()
        }
        MenuItem {
            text: qsTr("取消全选")
            onTriggered: edit.deselect()
        }
        MenuItem {
            text: qsTr("复制")
            onTriggered: edit.copy()
        }
    }


    //-------------------显示日志的文本区域
    TextArea{
        id:edit
        focus: true
        x:hgap
        wrapMode: TextEdit.Wrap
        verticalAlignment: TextEdit.AlignTop
        horizontalAlignment: TextEdit.AlignLeft
        implicitWidth: 0.98*log_1.width
        selectByMouse: true
        selectByKeyboard: true
        persistentSelection: true
        font.pixelSize: 18
        font.family:sourceNotoFont.name
        readOnly: true
        textFormat: TextEdit.RichText
        text: new Date().toLocaleString(Qt.locale(), "yyyy年MM月dd号 HH:mm:ss<br/>") + qsTr("日志记录开启")

        //---------------无修饰的背景
        background: Rectangle {
            border.color:transcolor
            color:transcolor
        }

        MouseArea {
            anchors.fill: parent
            focus: true
            preventStealing: true
            onDoubleClicked: {
                editMenu.openMenu()
            }

        }
    }

    //----------------------设置可点击的鼠标区域




    //-----------------------------debug输出信息
    function debug_log(s) {

        var time_stamp = new Date().toLocaleString(Qt.locale(), "yyyy年MM月dd号 HH:mm:ss")
        var debug_msg = "<p style='color:#FFFFFF;font-size:18px' >" + "<br/>" + time_stamp +"<br/>" +s + "</p>"
        edit.append(debug_msg);
        edit.cursorPosition = edit.length-1//让滚动条回到最新添加的那行

    }
    //-----------------------------warn输出信息
    function warn_log(s){

        var time_stamp = new Date().toLocaleString(Qt.locale(), "yyyy年MM月dd号 HH:mm:ss")
        var warn_msg = "<p style='color:#FF9800;font-size:18px' >" + "<br/>" + time_stamp +"<br/>" +s + "</p>"
        edit.append(warn_msg);
        edit.cursorPosition = edit.length-1

    }
    //-----------------------------err输出信息
    function error_log(s){

        var time_stamp = new Date().toLocaleString(Qt.locale(), "yyyy年MM月dd号 HH:mm:ss")
        var error_msg = "<p style='color:#F44336;font-size:18px' >" + "<br/>" + time_stamp +"<br/>" + s + "</p>"
        edit.append(error_msg);
        edit.cursorPosition = edit.length-1

    }




}
