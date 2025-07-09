import QtQuick 2.14
import QtQuick.Controls 2.14
import QtQuick.Controls.Material 2.14
import QtGraphicalEffects 1.12
import QtQuick.Layouts 1.14
import casbio.lab 1.1

Item{
    id:gripper_1
    clip: true

    property real vgap: 0.01*parent.height
    property real hgap: 0.01*parent.width

    property string timestampformat: "yyyy年MM月dd日 HH:mm:ss.zzz"

    property string crc16: "无"

    property string send_string: ""

    property int areapadding:10

    GripperConnectStatus{
        id:gripper_connectstatus

    }

    GripperConnectPanel{
        id:gripper_connectpanel

    }

    //站址
    SpinBox{
        id:gripper_slaveid
        x:gripper_connectstatus.x
        y:gripper_connectstatus.y+gripper_connectstatus.height+1.5*vgap
        anchors.top:gripper_connectstatus.bottom
        anchors.left: gripper_connectstatus.left
        anchors.topMargin:5*vgap
        width: 18*hgap
        height:8*vgap
        from:1
        stepSize: 1
        to:255
        value: 1
        editable: true
        onValueChanged: {
            calculate_crc16()
        }
    }
    Label{
        id:gripper_slaveid_label
        x:gripper_slaveid.x
        y:gripper_slaveid.y-height
        color: "white"
        text: "设备ID: 0x"+gripper_slaveid.value.toString(16).padStart(2,'0')
    }

    //功能码
    GripperComboBox{
        id:func_code
        width: 12*hgap
        height:8*vgap
        x:gripper_slaveid.x+3*hgap+gripper_slaveid.width
        y:gripper_slaveid.y
        model:["01","02","03","04","06","OF","10"]
        currentIndex:2
        onCurrentValueChanged: {
            calculate_crc16()
        }
    }
    Label{
        id:func_code_label
        x:func_code.x
        y:func_code.y-height
        color: "white"
        text: "功能码: 0x"+func_code.currentText
    }

    //寄存器地址
    SpinBox{
        id:gripper_registeraddress
        width: 18*hgap
        height: 8*vgap
        x:func_code.x+3*hgap+func_code.width
        y:func_code.y
        from:1
        to:2048
        stepSize: 1
        value: 256
        editable: true
        onValueChanged: {
            calculate_crc16()
        }
    }
    Label{
        id:gripper_registeraddress_label
        x:gripper_registeraddress.x
        y:gripper_registeraddress.y-height
        color: "white"
        text: "寄存器地址: 0x"+gripper_registeraddress.value.toString(16).padStart(4,'0')
    }

    //寄存器数据
    SpinBox{
        id:gripper_registervalue
        width: 18*hgap
        height: 8*vgap
        x:gripper_registeraddress.x+3*hgap+gripper_registeraddress.width
        y:gripper_registeraddress.y
        from:-32768
        to:65535
        stepSize: 1
        value: 1
        editable: true
        onValueChanged: {
            calculate_crc16()
        }
    }
    Label{
        id:gripper_registervalue_label
        x:gripper_registervalue.x
        y:gripper_registervalue.y-height
        color: "white"
        text: "寄存器数据: 0x"+ (gripper_registervalue.value>=0?gripper_registervalue.value.toString(16).padStart(4,'0'):
                                                          gripper_backend.getNegativeHexString(gripper_registervalue.value))
    }

    //CRC-16校验
    Rectangle{
        id:crc16_cal
        width: 10*hgap
        height: 8*vgap
        x:gripper_registervalue.x+3*hgap+gripper_registervalue.width
        y:gripper_registervalue.y
        color: "transparent"
        Label{
            anchors.left: parent.left
            anchors.verticalCenter: parent.verticalCenter
            text:  "0x" + crc16
            color:"white"
        }
    }
    Label{
        id:crc_label
        width: 12*hgap
        x:crc16_cal.x
        y:crc16_cal.y-height
        text:"CRC16检验: "
        color:"white"
    }


    Rectangle {
        id: input_command
        x:gripper_slaveid.x
        y:gripper_slaveid.y+gripper_slaveid.height+4.2*vgap
        width: 30*hgap
        height: 6*vgap
        radius:vgap
        property alias font: textEdit.font
        property alias text: textEdit.text
        color: "#454545"
        TextInput{
            id: textEdit
            x:input_command.x-areapadding*0.5
            y:0.5*input_command.height - 0.5*height
            width: parent.width
            height: parent.height*0.8
            focus: true
            color: "white"
            font.pixelSize: 18
            wrapMode: TextEdit.Wrap
            maximumLength: 36
            font.family:sourceNotoFont.name
            inputMethodHints: Qt.ImhDialableCharactersOnly
            validator: RegExpValidator{regExp:/[0-9A-Fa-f ]+/ }
         }
    }
    Label{
        id:input_command_label
        x:input_command.x
        y:input_command.y-height*1.1
        color: "white"
        text: "发送窗口:"
    }

    //选择发送按钮
    Button{
        id:send_btn
        text: "发送指令"
        width: 8*hgap
        height: 7*vgap
        font.pixelSize: 18
        x:input_command.x+input_command.width+hgap
        y:input_command.y+0.5*input_command.height - 0.5*height

        onClicked: {

            var constatus = gripper_backend.getStatusofGripperConnection()

            if( !constatus ){
                log_page.warn_log("机械爪未连接-发送指令无效")
                notice_popup.pop_warn("机械爪未连接-发送指令无效");
                return
            }

            append_send(textEdit.text)
            gripper_backend.sendcommand(textEdit.text)
        }
    }

    //接收串口
    Label{
        id:revwindow_label
        x:input_command.x
        y:input_command.height+input_command.y+vgap
        text: "返回窗口:"
    }
    ScrollView{
        id:revwindow
        width: 30*hgap
        height: 60*vgap
        x:revwindow_label.x
        y:revwindow_label.y+revwindow_label.height
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

    //清除数据按钮
    Button{
        id:clear_btn
        text: "清除数据"
        width: 8*hgap
        height: 7*vgap
        font.pixelSize: 18
        x:send_btn.x
        y:send_btn.y+send_btn.height + 0.1*height

        onClicked: {
            revtextarea.clear()
            revtextarea.cursorPosition=0
        }

    }

    Label{
        id:timer_label
        x:clear_btn.x
        y:clear_btn.y+clear_btn.height + 2*vgap
        text: "定时间隔(ms):"
    }
    GripperComboBox{
        id:timer_combobox
        width: 8*hgap
        height: 7*vgap
        x:timer_label.x
        y:timer_label.y+timer_label.height + 0.1*height
        model: [100,200,300,400,500,1000]

    }
    CheckBox{
        id:timer_checkbox
        width: 10*hgap
        height: 7*vgap
        x:timer_combobox.x
        y:timer_combobox.y+timer_combobox.height
        text: "定时发送"
    }

    //保存结果
    Button{
        id: save_btn
        width: 8*hgap
        height: 7*vgap
        x:timer_checkbox.x
        y:timer_checkbox.y+timer_checkbox.height+2*vgap
        text: "保存数据"
    }

    Gripper{
        id:gripper_backend
        onGripper_statechanged_signal:{
            gripper_connectstatus.handle_gripper_state_changed(statestatus)
            gripper_connectpanel.handle_connect_state_changed(statestatus)
        }
        onRev_data_signal: {
            append_rev(rev_str)
        }
    }

    //开始建议指令集合
    GripperCommandBox{
        id:command_combobox
        x:send_btn.x+send_btn.width+2*hgap
        y:send_btn.y
        width: 20*hgap
        height: 8*vgap
        currentIndex: 0
        model:ListModel {
            id: commandModel
        }
        onCurrentIndexChanged: {
            commandComboxdisplay()
        }
    }
    CheckBox{
        id:simple_command_checkbox
        x:command_combobox.x+command_combobox.width+hgap
        y:command_combobox.y+0.5*command_combobox.height-0.5*height
        text: "启用集成指令"
        onCheckedChanged: {
            enableComplexCommand(checked)
        }
    }
    Label{
        id:command_combobox_label
        x:command_combobox.x
        y:command_combobox.y-height
        text: "集成指令:"
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

    //计算CRC16校验
    function calculate_crc16(){
        gripper_backend.getCRC16(gripper_slaveid.value,func_code.currentText,gripper_registeraddress.value,gripper_registervalue.value);
        crc16 = gripper_backend.getCRC16CurrentString()
        textEdit.clear()
        send_string = gripper_backend.getModbusString()
        textEdit.text = send_string
    }

    function enableComplexCommand(setStatus){
        gripper_registervalue.enabled = !setStatus
        gripper_slaveid.enabled=!setStatus
        func_code.enabled=!setStatus
        gripper_registeraddress.enabled = !setStatus
        if(setStatus){
            textEdit.clear()
            textEdit.text = command_combobox.valueAt(command_combobox.currentIndex)
        }else{
            calculate_crc16()
        }
    }

    //集成指令显示
    function commandComboxdisplay(){
        if(simple_command_checkbox.checked){
            textEdit.text = command_combobox.valueAt(command_combobox.currentIndex)
        }
    }

    onVisibleChanged: {
        if(visible){
            if(simple_command_checkbox.checked){
                textEdit.text = command_combobox.valueAt(command_combobox.currentIndex)
            }else{
                calculate_crc16()
            }
        }
    }

    Component.onCompleted:{
        commandModel.clear()
        var namelist = gripper_backend.getAllCommandList()
        for(var i =0;i<namelist.length;++i){
            commandModel.append({index:i,commandName:namelist[i],hexCommandString:gripper_backend.getCommandHexStringByName(namelist[i])})
        }
    }

}
