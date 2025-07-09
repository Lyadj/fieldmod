import QtQuick 2.14
import QtQuick.Controls 2.14
import QtQuick.Controls.Material 2.14
import QtGraphicalEffects 1.12
import QtQuick.Layouts 1.14


Popup{
    id:connectpanel_1
    width: parent.width
    height: 0.2*parent.height
    modal: false
    focus: true
    closePolicy: Popup.CloseOnEscape | Popup.CloseOnPressOutside
    transformOrigin: Item.Bottom
    x:parent.x
    y:parent.y+0.8*parent.height

    property int animation_time_200: 200
    property int animation_time: 300

    property string blurcolor: "white"
    property string bgcolor: "#31363F"
    property real vgap: 0.01*parent.height
    property real hgap: 0.01*parent.width

    property var serialList: ["串口1","串口2"]

    //--------------背景设置
    background: Item{
        RectangularGlow {
            id: effect
            anchors.fill: rect
            glowRadius: 2*hgap
            spread: 0.0
            color: blurcolor
            cornerRadius: 4*hgap
        }

        Rectangle {
            id: rect
            color: bgcolor
            anchors.centerIn: parent
            width: parent.width
            height: parent.height
        }
    }

    enter: Transition {
        PropertyAnimation{
            target: connectpanel_1
            properties: "x"
            from:parent.x+parent.width
            to:parent.x
            duration: animation_time
            easing.type: Easing.InOutQuad
        }
    }

    exit:Transition {
        PropertyAnimation{
            target: connectpanel_1
            properties: "x"
            from:parent.x
            to:parent.x+parent.width
            duration: animation_time
            easing.type: Easing.InOutQuad
        }
    }

    Label{
        id:title_gripper_1
        x:0.5*hgap
        y:0.5*vgap
        text: "机械电爪 - 串口连接 - 设置"
        color: blurcolor
    }


    GripperSerialComboBox{
        id:serial_port_combobox_1
        x:hgap
        y:title_gripper_1.y+title_gripper_1.height+vgap
        width: 12*hgap
        height: 10*vgap
    }

    Label{
        id:baudrate_title_1
        anchors.verticalCenter:  serial_port_combobox_1.verticalCenter
        anchors.leftMargin: hgap
        font.pixelSize: 16
        anchors.left: serial_port_combobox_1.right
        color: blurcolor
        text: "波特率: "
    }

    GripperComboBox{
        id:serial_port_combobox_2
        anchors.verticalCenter:  baudrate_title_1.verticalCenter
        anchors.left: baudrate_title_1.right
        width: 9*hgap
        height: 10*vgap
        currentIndex: 12
        model: [110,300,600,1200,2400,4800,9600,14400,19200,38400,56000,57600,115200,128000,256000]
    }


    Label{
        id:databit_title_1
        anchors.verticalCenter:  serial_port_combobox_2.verticalCenter
        anchors.leftMargin: hgap
        font.pixelSize: 16
        anchors.left: serial_port_combobox_2.right
        color: blurcolor
        text: "数据位: "
    }

    GripperComboBox{
        id:serial_port_combobox_3
        anchors.verticalCenter:  databit_title_1.verticalCenter
        anchors.left: databit_title_1.right
        width: 6*hgap
        height: 10*vgap
        currentIndex: 3
        model: [5,6,7,8]
    }


    Label{
        id:stopbit_title_1
        anchors.verticalCenter:  serial_port_combobox_3.verticalCenter
        anchors.leftMargin: hgap
        font.pixelSize: 16
        anchors.left: serial_port_combobox_3.right
        color: blurcolor
        text: "停止位: "
    }


    GripperComboBox{
        id:serial_port_combobox_4
        anchors.verticalCenter:  stopbit_title_1.verticalCenter
        anchors.left: stopbit_title_1.right
        width: 6*hgap
        height: 10*vgap
        currentIndex: 0
        model: [1,1.5,2]
    }


    Label{
        id:parity_title_1
        anchors.verticalCenter:  serial_port_combobox_4.verticalCenter
        anchors.leftMargin: hgap
        font.pixelSize: 16
        anchors.left: serial_port_combobox_4.right
        color: blurcolor
        text: "奇偶检验: "
    }

    GripperComboBox{
        id:serial_port_combobox_5
        anchors.verticalCenter:  parity_title_1.verticalCenter
        anchors.left: parity_title_1.right
        width: 12*hgap
        height: 10*vgap
        model: ["无校验","奇校验","偶校验","标记校验","空格校验"]
    }

    Label{
        id:flow_title_1
        anchors.verticalCenter:  serial_port_combobox_5.verticalCenter
        anchors.leftMargin: hgap
        font.pixelSize: 16
        anchors.left: serial_port_combobox_5.right
        color: blurcolor
        text: "流控: "
    }

    GripperComboBox{
        id:serial_port_combobox_6
        anchors.verticalCenter:  flow_title_1.verticalCenter
        anchors.left: flow_title_1.right
        width: 12*hgap
        height: 10*vgap
        model: ["无流控","软件流控","硬件流控"]
    }

    Button{
        id:connect_btn
        anchors.verticalCenter:  serial_port_combobox_6.verticalCenter
        anchors.left: serial_port_combobox_6.right
        anchors.leftMargin: hgap
        width: 8*hgap
        height: 8*vgap
        states:[
            State {
                name: "disconneted"
                PropertyChanges {
                    target: connect_btn
                    text:"连接电爪"
                }
            },
            State {
                name: "connected"
                PropertyChanges {
                    target: connect_btn
                    text:"断开连接"
                }
            }
        ]
        state: "disconneted"

        onClicked: {
            if(connect_btn.state=="connected"){
                gripper_backend.disconnect2Gripper()
                close()
                notice_popup.pop_warn("机械电爪-串口连接已断开");
                return;
            }

            //结合参数
            if(serial_port_combobox_1.displayText == serial_port_combobox_1.defaultserialname){
                console.warn("请选择用于连接机械电爪的串口")
                close()
                notice_popup.pop_warn("机械电爪-未选择连接的串口");
                return
            }

            var connectInfo={"serial_portname":serial_port_combobox_1.displayText,"serial_baudrate":serial_port_combobox_2.currentValue,
            "serial_databit":serial_port_combobox_3.currentValue,"serial_stopbit":serial_port_combobox_4.currentValue,
            "serial_parity":serial_port_combobox_5.currentValue,"serial_flowcontrol":serial_port_combobox_6.currentValue}

            gripper_backend.getStatusofGripperConnection() ? gripper_backend.disconnect2Gripper():gripper_backend.connect2Gripper(connectInfo)
            close()

            notice_popup.pop_info("机械电爪-已连接");
        }

    }


    onVisibleChanged: {
        if(visible){

            if(serial_port_combobox_1.count > 0){
                return
            }
            serialList = gripper_backend.searchAllAvailableSerialports()
            serial_port_combobox_1.addSerialPort(serialList)
        }
    }


    function handle_connect_state_changed(status){
        if(status){
            connect_btn.state="connected"
        }else{
            connect_btn.state="disconneted"
        }
    }


}
