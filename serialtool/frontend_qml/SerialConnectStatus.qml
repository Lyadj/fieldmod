import QtQuick 2.14
import QtQuick.Controls 2.14
import QtQuick.Controls.Material 2.14
import QtGraphicalEffects 1.12
import QtQuick.Layouts 1.14



ColumnLayout{
    id:gripper_connect_status_1

    property int animation_time_200: 200
    property int animation_time: 300
    property string lock_color: "#005B41"
    property string unlock_color: "transparent"



    property real vgap: 0.01*parent.height
    property real hgap: 0.01*parent.width

    property string status_indicator_string: "未连接"

    property bool m_connect_status: false

    width: parent.width
    spacing: 2*vgap
    anchors { top: parent.top; topMargin: 2*vgap;left: parent.left;leftMargin: 2*hgap }

    Rectangle{
        id:connectbtn
        Layout.preferredWidth: 9*hgap
        Layout.preferredHeight: vgap*8
        Layout.alignment: Qt.AlignLeft
        radius: hgap
        color:connecttbtnarea.containsMouse ? lock_color : unlock_color
        Image {
            id:connect_icon
            scale: 1.0
            source: "qrc:/resources/connect.svg"
            anchors { verticalCenter: parent.verticalCenter; left: parent.left;}
        }
        Label{
            id:connect_info
            anchors.left: connect_icon.right
            anchors.verticalCenter: connect_icon.verticalCenter
            color: "white"
            text: status_indicator_string
        }
        Behavior on color {
            ColorAnimation {
                duration: animation_time_200
            }
        }
        states: [
            State {
                name: "closed"
                PropertyChanges {
                    target: connectbtn
                    Layout.preferredWidth: 9*hgap
                }
            },
            State {
                name: "opened"
                PropertyChanges {
                    target: connectbtn
                    Layout.preferredWidth: 52*hgap
                }
            }
        ]
        state: "closed"
        transitions: [
            Transition {
                from: "closed"
                to: "opened"
                NumberAnimation{
                    properties: "Layout.preferredWidth,color"
                    duration: animation_time
                    easing.type: Easing.InOutSine
                }
            },
            Transition {
                from: "opened"
                to: "closed"
                NumberAnimation{
                    properties: "Layout.preferredWidth,color"
                    duration: animation_time
                    easing.type: Easing.InOutSine
                }
            }
        ]

        PropertyAnimation{
            id:clickanimation
            loops: 1
            target: connect_icon
            properties: "opacity"
            from:0
            to:1
            duration: animation_time
            easing.type: Easing.InOutBounce
        }
        PropertyAnimation{
            id:clickanimation_label
            loops: 1
            target: connect_info
            properties: "opacity"
            from:0
            to:1
            duration: animation_time
            easing.type: Easing.InOutBounce
        }

        MouseArea{
            id:connecttbtnarea
            hoverEnabled: true
            anchors.fill: connectbtn
            onClicked: {
                handle_serialport_connect()
            }

        }
    }


    function handle_serialport_connect(){

        clickanimation.start()
        clickanimation_label.start()
        if(serial_connectpanel.visible){
            serial_connectpanel.close()
        }else{
            serial_connectpanel.open()
        }

    }

    function handle_serial_state_changed(status){
        if(status){
            connectbtn.state="opened"
            status_indicator_string = xyserialport.getSerialPortConnectionParaInfo()
        }else{
            connectbtn.state="closed"
            status_indicator_string = "未连接"
        }
    }



}
