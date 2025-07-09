import QtQuick 2.14
import QtQuick.Controls 2.14
import QtQuick.Controls.Material 2.14
import QtGraphicalEffects 1.12
import QtQuick.Layouts 1.14


Popup{
    id:serial_connectpanel_1
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

    property string btnhighlightcolor: "#31363F"
    property string  btndefaultcolor: ""


    property var serialList: ["串口G1","串口G2"]
    property var serialLastList: []

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
            target: serial_connectpanel_1
            properties: "x"
            from:parent.x+parent.width
            to:parent.x
            duration: animation_time
            easing.type: Easing.InOutQuad
        }
    }

    exit:Transition {
        PropertyAnimation{
            target: serial_connectpanel_1
            properties: "x"
            from:parent.x
            to:parent.x+parent.width
            duration: animation_time
            easing.type: Easing.InOutQuad
        }
    }



    TabBar {
        id: tab_row_1
        x:-hgap*0.8
        y:-1.8*vgap
        width: 24*hgap
        height: 6*vgap
        spacing: 0
        background:Rectangle{
            color: bgcolor
        }
        TabButton {
            text: "Modbus-RTU"
            width: 12*hgap
            height: 6*vgap
        }
        TabButton {
            text: "Modbus-TCP"
            width: 12*hgap
            height: 6*vgap
        }
    }


    StackLayout{
        id:serial_connect_swipeview_1
        currentIndex: tab_row_1.currentIndex

        //RTU-设置内容
        Item{
            SerialPortComboBox{
                    id:serial_port_combobox_1
                    x:hgap
                    y:tab_row_1.y+tab_row_1.height+2*vgap
                    width: 12*hgap
                    height: 10*vgap
            }

            Label{
                id:serial_baudrate_title_1
                anchors.verticalCenter:  serial_port_combobox_1.verticalCenter
                anchors.leftMargin: hgap
                font.pixelSize: 16
                anchors.left: serial_port_combobox_1.right
                color: blurcolor
                text: "波特率: "
            }

            SerialComboBox{
                id:serial_port_combobox_2
                anchors.verticalCenter:  serial_baudrate_title_1.verticalCenter
                anchors.left: serial_baudrate_title_1.right
                width: 9*hgap
                height: 10*vgap
                currentIndex: 12
                model: [110,300,600,1200,2400,4800,9600,14400,19200,38400,56000,57600,115200,128000,256000]
            }

            Label{
                id:serial_databit_title_1
                anchors.verticalCenter:  serial_port_combobox_2.verticalCenter
                anchors.leftMargin: hgap
                font.pixelSize: 16
                anchors.left: serial_port_combobox_2.right
                color: blurcolor
                text: "数据位: "
            }

            SerialComboBox{
                id:serial_port_combobox_3
                anchors.verticalCenter:  serial_databit_title_1.verticalCenter
                anchors.left: serial_databit_title_1.right
                width: 6*hgap
                height: 10*vgap
                currentIndex: 3
                model: [5,6,7,8]
            }


            Label{
                id:serial_stopbit_title_1
                anchors.verticalCenter:  serial_port_combobox_3.verticalCenter
                anchors.leftMargin: hgap
                font.pixelSize: 16
                anchors.left: serial_port_combobox_3.right
                color: blurcolor
                text: "停止位: "
            }


            SerialComboBox{
                id:serial_port_combobox_4
                anchors.verticalCenter:  serial_stopbit_title_1.verticalCenter
                anchors.left: serial_stopbit_title_1.right
                width: 6*hgap
                height: 10*vgap
                currentIndex: 0
                model: [1,1.5,2]
            }


            Label{
                id:serial_parity_title_1
                anchors.verticalCenter:  serial_port_combobox_4.verticalCenter
                anchors.leftMargin: hgap
                font.pixelSize: 16
                anchors.left: serial_port_combobox_4.right
                color: blurcolor
                text: "奇偶检验: "
            }

            SerialComboBox{
                id:serial_port_combobox_5
                anchors.verticalCenter:  serial_parity_title_1.verticalCenter
                anchors.left: serial_parity_title_1.right
                width: 12*hgap
                height: 10*vgap
                model: ["无校验","奇校验","偶校验","标记校验","空格校验"]
            }

            Label{
                id:serial_flow_title_1
                anchors.verticalCenter:  serial_port_combobox_5.verticalCenter
                anchors.leftMargin: hgap
                font.pixelSize: 16
                anchors.left: serial_port_combobox_5.right
                color: blurcolor
                text: "流控: "
            }

            SerialComboBox{
                id:serial_port_combobox_6
                anchors.verticalCenter:  serial_flow_title_1.verticalCenter
                anchors.left: serial_flow_title_1.right
                width: 12*hgap
                height: 10*vgap
                model: ["无流控","软件流控","硬件流控"]
            }

            Button{
                id:serial_connect_btn
                anchors.verticalCenter:  serial_port_combobox_6.verticalCenter
                anchors.left: serial_port_combobox_6.right
                anchors.leftMargin: hgap
                width: 8*hgap
                height: 8*vgap
                states:[
                    State {
                        name: "disconnected"
                        PropertyChanges {
                            target: serial_connect_btn
                            text:"连接串口"
                        }
                    },
                    State {
                        name: "connected"
                        PropertyChanges {
                            target: serial_connect_btn
                            text:"断开连接"
                        }
                    }
                ]
                state: "disconnected"

                onClicked: {

                    //判断是否选择连接的串口
                    if(serial_port_combobox_1.displayText == serial_port_combobox_1.defaultserialname){
                        console.warn("请选择需要连接的串口")
                        close()
                        notice_popup.pop_warn("未选择连接的串口");
                        return
                    }

                    var connectInfo={"serial_portname":serial_port_combobox_1.displayText,"serial_baudrate":serial_port_combobox_2.currentValue,
                    "serial_databit":serial_port_combobox_3.currentValue,"serial_stopbit":serial_port_combobox_4.currentValue,
                    "serial_parity":serial_port_combobox_5.currentValue,"serial_flowcontrol":serial_port_combobox_6.currentValue}

                    xyserialport.getSerialPortConnectionStatus() ? xyserialport.disconnectfromSerialPort():xyserialport.connect2SerialPort(connectInfo)
                    close()

                }

            }

        }

        //TCP-工具
        Item{

            Label{
                id:tcp_ip_address_label
                x:hgap
                y:tab_row_1.y+tab_row_1.height+4*vgap
                color: blurcolor
                text: "目的IP: "
            }


            Rectangle{
                id:input_ip_rec
                color: "transparent"
                radius: 0.2*hgap
                anchors.verticalCenter:  tcp_ip_address_label.verticalCenter
                anchors.leftMargin: hgap
                anchors.left: tcp_ip_address_label.right
                width: 12*hgap
                height: 7*vgap
                border.color: "white"
                border.width: 1
                TextInput{
                    id:tcp_ip_input_1
                    anchors.centerIn: parent
                    font.pixelSize: 18
                    font.family: sourceNotoFont.name
                    inputMask: "000.000.000.000"
                    text: "192.168.0.80"
                    color: blurcolor
                    inputMethodHints: Qt.ImhDigitsOnly
                }
            }


            Label{
                id:tcp_ip_port_label
                anchors.verticalCenter:  input_ip_rec.verticalCenter
                anchors.leftMargin: 5*hgap
                font.pixelSize: 16
                anchors.left: input_ip_rec.right
                color: blurcolor
                text: "目的端口(1-65535):"
            }

            SpinBox{
                id:tcp_ip_port_1
                anchors.verticalCenter:  tcp_ip_port_label.verticalCenter
                anchors.leftMargin: hgap
                font.pixelSize: 16
                width: 18*hgap
                height: 10*vgap
                anchors.left: tcp_ip_port_label.right
                inputMethodHints:Qt.ImhDigitsOnly
                font.family: sourceNotoFont.name
                value: 10137
                from:1
                editable: true
                stepSize: 1
                to:65535
            }

            Button{
                id:tcp_connect_btn
                anchors.verticalCenter:  tcp_ip_port_1.verticalCenter
                anchors.left: tcp_ip_port_1.right
                anchors.leftMargin: hgap
                width: 8*hgap
                height: 8*vgap
                text: "连接设备"
            }

        }

    }




    onVisibleChanged: {
        if(visible){
            serialList = xyserialport.searchAllAvailableSerialPorts()

            if(serialList.toString() !== serialLastList.toString() ){
                serial_port_combobox_1.addSerialPort(serialList)
                serialLastList = serialList
            }
        }
    }


    function handle_connect_status_changed(status){
        if(status){
            serial_connect_btn.state="connected"
            notice_popup.pop_info("串口已连接")
        }else{
            serial_connect_btn.state="disconnected"
            notice_popup.pop_warn("串口已断开")
        }
    }


}
