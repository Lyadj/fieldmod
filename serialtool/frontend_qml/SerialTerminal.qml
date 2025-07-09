import QtQuick 2.14
import QtQuick.Controls 2.14
import QtQuick.Controls.Material 2.14
import QtGraphicalEffects 1.12
import casbio.lab 1.1
import QtQuick.Layouts 1.14

Flickable{
    id:serial_flickable_1
    clip: true

    property real vgap: 0.01*parent.height
    property real hgap: 0.01*parent.width
    property int animation_duration: 400
    property string timestampformat: "yyyy年MM月dd日 HH:mm:ss.zzz"
    property string crc16: "ffff"
    property string send_hexstring: ""
    property int areapadding:10


    rebound: Transition {
        NumberAnimation {
            properties: "x,y"
            duration: animation_duration
            easing.type: Easing.OutBounce
        }
    }

    width: parent.width
    height: parent.height
    contentWidth: parent.width
    contentHeight: parent.height*1.05


    SerialConnectStatus{
        id:serial_connectstatus

    }

    SerialConnectPanel{
        id:serial_connectpanel

    }

    //指令设置
    RowLayout{
        id:param_row_layout
        x:serial_connectstatus.x-hgap
        y:serial_connectstatus.y+serial_connectstatus.height*1.4
        width: parent.width
        height: 14*vgap
        spacing: 2*hgap

        //站址
        SpinBox{
            id:serialport_slaveid
            Layout.preferredWidth: 16*vgap
            Layout.preferredHeight: 10*vgap
            Layout.fillWidth: true
            Layout.alignment: Qt.AlignVCenter
            font.pixelSize: 20
            from:1
            stepSize: 1
            to:255
            value: 1
            editable: true
            Label{
                id:serialport_slaveid_label
                anchors.bottom: parent.top
                anchors.left: parent.left
                anchors.leftMargin: hgap
                font.pixelSize: 20
                text: "站址: 0x"+serialport_slaveid.value.toString(16).padStart(2,'0')
            }
            onValueChanged: {
                calculate_crc16()
            }
        }

        //功能码
        SerialComboBox{
            id:serial_func_code
            Layout.preferredWidth: 16*vgap
            Layout.preferredHeight: 10*vgap
            Layout.alignment: Qt.AlignVCenter
            font.pixelSize: 20
            Layout.fillWidth: true
            model:["01","02","03","04","06","Of","10"]
            currentIndex:2
            Label{
                id:serial_func_code_label
                anchors.bottom: parent.top
                anchors.left: parent.left
                anchors.leftMargin: hgap
                font.pixelSize: 20
                text: "功能码: 0x"+serial_func_code.currentText
            }
            onCurrentValueChanged: {
                calculate_crc16()
            }
        }

        //寄存器地址
        SpinBox{
            id:serial_registeraddress
            Layout.preferredWidth: 16*vgap
            Layout.preferredHeight: 10*vgap
            Layout.fillWidth: true
            font.pixelSize: 20
            Layout.alignment: Qt.AlignVCenter
            from:0
            to:65535
            stepSize: 1
            value: 1
            editable: true
            Label{
                id:serial_registeraddress_label
                anchors.bottom: parent.top
                anchors.left: parent.left
                anchors.leftMargin: hgap
                font.pixelSize: 20
                text: "寄存器地址: 0x"+serial_registeraddress.value.toString(16).padStart(2,'0')
            }
            onValueChanged: {
                calculate_crc16()
            }
        }


        //寄存器数据
        SpinBox{
            id:serial_registervalue
            Layout.preferredWidth: 16*vgap
            Layout.preferredHeight: 10*vgap
            Layout.alignment: Qt.AlignVCenter
            Layout.fillWidth: true
            from:-32768
            to:65535
            stepSize: 1
            font.pixelSize: 20
            value: 1
            editable: true
            Label{
                id:serial_registervalue_label
                anchors.bottom: parent.top
                anchors.left: parent.left
                anchors.leftMargin: hgap
                font.pixelSize: 20
                text: "寄存器数据: 0x"+xyserialport.getNegativeValueHexString(serial_registervalue.value)
            }
            onValueChanged: {
                calculate_crc16()
            }
        }


        //CRC-16校验
        Rectangle{
            id:serial_crc16_cal
            Layout.preferredWidth: 16*vgap
            Layout.preferredHeight: 10*vgap
            Layout.alignment: Qt.AlignVCenter
            Layout.fillWidth: true
            color: "transparent"
            Label{
                anchors.left: parent.left
                anchors.verticalCenter: parent.verticalCenter
                text:  "0x" + crc16
                font.pixelSize: 20
                color:"white"
            }
            Label{
                id:serial_crc16_cal_label
                anchors.bottom: parent.top
                anchors.left: parent.left
                font.pixelSize: 20
                text: "CRC16校验码: "
            }

        }

    }


    //发送窗口
    RowLayout{
        id:send_layout
        x:param_row_layout.x+hgap
        y:param_row_layout.y+param_row_layout.height*1.05
        spacing: 2*hgap
        width: 40*hgap
        height: 10*vgap

        Rectangle {
            id: input_command
            Layout.preferredWidth: 30*hgap
            Layout.preferredHeight: 6*vgap
            Layout.alignment: Qt.AlignVCenter
            radius:vgap
            color: "#454545"
            TextInput{
                id: textEdit
                anchors.fill: parent
                anchors.topMargin: 0.5*vgap
                anchors.leftMargin: 0.5*hgap
                focus: true
                color: "white"
                font.pixelSize: 20
                wrapMode: TextEdit.Wrap
                maximumLength: 40
                font.family:sourceNotoFont.name
                inputMethodHints: Qt.ImhDialableCharactersOnly
                validator: RegExpValidator{regExp:/[0-9A-Fa-f ]+/ }
             }
            Label{
                id:input_command_label
                anchors.bottom: parent.top
                anchors.left: parent.left
                anchors.bottomMargin: 0.5*vgap
                font.pixelSize: 18
                color: "white"
                text: "发送窗口:"
            }
        }


        //选择发送按钮
        Button{
            id:send_btn
            text: "发送指令"
            font.pixelSize: 20
            Layout.alignment: Qt.AlignVCenter

            onClicked: {

                var constatus = xyserialport.getSerialPortConnectionStatus()

                if( !constatus ){
                    log_page.warn_log("串口未连接-发送指令无效")
                    notice_popup.pop_warn("串口未连接-发送指令无效");
                    return
                }
                append_send(textEdit.text)
                xyserialport.sendModbusRTUCommand(textEdit.text)
            }

        }

    }

    Label{
        id:revwindow_label
        x:send_layout.x
        y:send_layout.y+send_layout.height*0.8
        font.pixelSize: 18
        color: "white"
        text: "接收窗口:"
    }


    //接收窗口
    RowLayout{
        id:revlayout
        x:revwindow_label.x
        y:revwindow_label.y+revwindow_label.height*0.7

        width: 40*hgap
        height: 60*vgap

        ScrollView{
            id:revwindow
            Layout.preferredWidth: 30*hgap
            Layout.preferredHeight: 56*vgap
            Layout.alignment: Qt.AlignVCenter
            TextArea{
                id:revtextarea
                wrapMode: TextArea.WordWrap
                readOnly: true
                padding: areapadding
                placeholderText: "等待返回的数据..."
                textFormat: TextEdit.RichText
                background: Rectangle{
                    anchors.fill: parent
                    color: "#454545"
                    radius: vgap
                }
            }

        }

        //选择发送按钮
        Button{
            id:clean_btn
            text: "清除窗口"
            font.pixelSize: 20
            Layout.alignment: Qt.AlignVCenter
            onClicked: {
                revtextarea.clear()
            }
        }

    }


    Label{
        id:testlabel
        x:send_layout.x+1*send_layout.width+6*hgap
        y:send_layout.y
        font.pixelSize: 18
        color: "white"
        text: "单元操作:"
    }

    //测试窗口
    GridLayout{
        id:test_layout
        columnSpacing: 6*hgap
        rowSpacing: 2*hgap
        x:testlabel.x
        y:testlabel.y+1.2*testlabel.height

        columns: 4

        Button{
            text:"上升"
            onClicked: {
                xyserialport.handle_movement(2);
            }
        }

        Button{
            text:"下降"
            onClicked: {
                xyserialport.handle_movement(1);
            }
        }

        Button{
            text:"旋转台Run"
            onClicked: {
                xyserialport.appendTask("旋转台Run");
            }
        }

        Button{
            text:"旋转台Ready"
            onClicked: {
                xyserialport.appendTask("旋转台Ready");
            }
        }


        Button{
            text:"点动开启"
            onClicked: {
                xyserialport.appendTask("点动开启");
            }
        }

        Button{
            text:"取消点动"
            onClicked: {
                xyserialport.appendTask("取消点动");
            }
        }


        Button{
            text:"正向点动"
            onClicked: {
                xyserialport.appendTask("正向点动");
            }
        }

        Button{
            text:"负向点动"
            onClicked: {
                xyserialport.appendTask("反向点动");
            }
        }

        Button{
            text:"初始化DDR"
            onClicked: {
                xyserialport.appendTask("初始化DDR");
            }
        }


        Button{
            text:"运动测试1"
            onClicked: {
                xyserialport.appendTask("运动测试1");
            }
        }

        Button{
            text:"运动测试2"
            onClicked: {
                xyserialport.appendTask("运动测试2");
            }
        }


        Button{
            id:shift_btn
            text:"暂停"
            onClicked: {
                xyserialport.appendTask(shift_btn.text);
                if(shift_btn.text =="暂停"){
                shift_btn.text="启动"
                }else if(shift_btn.text =="启动"){
                    shift_btn.text="暂停"
                }
            }
        }

    }


    XYSerialPort{
        id:xyserialport

        //处理连接与断开信号
        onXyserialport_connection_signal:{
            serial_connectstatus.handle_serial_state_changed(statestatus)
            serial_connectpanel.handle_connect_status_changed(statestatus)
        }

        //接收串口数据
        onXyserialport_revdata_signal:{
            append_rev(rev_hexstr)
        }

    }

    onVisibleChanged: {
        if(visible){
            calculate_crc16()
        }
    }

    //计算CRC16校验
    function calculate_crc16(){
        xyserialport.calculateCRC16(serialport_slaveid.value,serial_func_code.currentText,serial_registeraddress.value,serial_registervalue.value);
        crc16 = xyserialport.getCRC16HexString()
        textEdit.clear()
        send_hexstring = xyserialport.getModbusCommandHexString()
        textEdit.text = send_hexstring
    }


    function append_send(msg){
        var send_msg= "<p style='color:#C6EBC5;font-size:16px' >"+
                new Date().toLocaleString(Qt.locale("zh_CN"), timestampformat)+" | 发送数据"+"<br/>" + msg +"<br/>"+"</p>"
        revtextarea.append(send_msg)
        revtextarea.cursorPosition = revtextarea.length-1
    }

    function append_rev(msg){
        var rev_msg= "<p style='color:#FFF2D7;font-size:16px' >"+
                new Date().toLocaleString(Qt.locale("zh_CN"), timestampformat)+" | 返回数据"+"<br/>" + msg+"<br/>"+"</p>"
        revtextarea.append(rev_msg)
        revtextarea.cursorPosition = revtextarea.length-1
    }


}
