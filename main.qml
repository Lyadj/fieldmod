import QtQuick 2.14
import QtQuick.Window 2.14
import QtQuick.Controls 2.14
import QtQuick.VirtualKeyboard 2.14

import "./utility/"


ApplicationWindow {
    id: window
    x:0
    y:0
    width: 1280
    height: 800
//    width: 1080
//    height: 720
    visible: true
//    visibility: Qt.WindowFullScreen
    title: qsTr("FieldMod工控通信调试")


    FontLoader{
        id:sourceNotoFont
        source: "./fonts/NotoSansSC-Regular.ttf"
    }

    //header
    header:ATPHeader{
        id:appheader

    }

    //app footer
    footer:ATPFooter{
       id:appfooter

    }

    //主体框架
    ATPToolView{
        id:mainview
        width: parent.width
        height: parent.height
        x:0
        y:0
    }


//    InputPanel {
//        id: inputPanel
//        z: 99
//        x: 0
//        y: window.height
//        width: window.width

//        states: State {
//            name: "visible"
//            when: inputPanel.active
//            PropertyChanges {
//                target: inputPanel
//                y: window.height - inputPanel.height
//            }
//        }
//        transitions: Transition {
//            from: ""
//            to: "visible"
//            reversible: true
//            ParallelAnimation {
//                NumberAnimation {
//                    properties: "y"
//                    duration: 250
//                    easing.type: Easing.InOutQuad
//                }
//            }
//        }
//    }




}
