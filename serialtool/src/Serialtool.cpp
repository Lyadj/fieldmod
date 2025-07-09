#include "serialtool/include/Serialtool.h"


namespace SerialTool {


    XYSerialPort::XYSerialPort(QObject *parent)
    {
        Q_UNUSED(parent)
        //可用串口列表初始化
        m_avaiable_serialports_list.clear();
        //串口连接状态-初始化-false
        m_serialport_connection_status = false;
        //串口初始化

        m_serialport = new QSerialPort();
        //串口信息初始化
        m_serialport_para_info.clear();
        //CRC16字符串初始化
        m_crc16_hexstring.clear();
        //modbus-rtu总体命令字符串初始化
        m_modbus_rtu_command_hexstring.clear();

        //清除任务
        m_task_vector.clear();

        //处于非点动模式
        step_mode_status = false;


        //处理串口错误
         connect(m_serialport,SIGNAL( errorOccurred(QSerialPort::SerialPortError) ),
                 this,SLOT( handleErrorOccurred(QSerialPort::SerialPortError) ));

        //处理数据
        connect(m_serialport,SIGNAL( readyRead() ),this,SLOT( handleModbusRTURevData()
                    ));


        //连接定点函数
        m_timer = new QTimer();
        m_timer->setInterval(Task_Interval);

        m_stepmove_timer = new QTimer();
        m_stepmove_timer->setInterval(StepMoveStatus_Interval);
        connect(m_stepmove_timer,SIGNAL(timeout()),this,SLOT( handleStepMoveStatus() ));

    }

    QList<QString> XYSerialPort::searchAllAvailableSerialPorts()
    {

        m_avaiable_serialports_list.clear();
        QList<QSerialPortInfo> available_ports_list = QSerialPortInfo::availablePorts();

        for(auto eachport:available_ports_list){
            m_avaiable_serialports_list.append(eachport.portName());
        }

        return m_avaiable_serialports_list;
    }

    bool XYSerialPort::connect2SerialPort(QVariantMap serial_info_map)
    {

        qDebug().noquote() << "设置串口参数，并尝试连接" <<endl;

        m_serialport_para_info.clear();
        //设置串口名称
        m_serialport->setPortName(serial_info_map.value(SerialPort_PortName_Key).toString());

        //设置波特率
        m_serialport->setBaudRate(serial_info_map.value(SerialPort_BaudRate_Key).toUInt());

        //设置数据位
        m_serialport->setDataBits(XYSerialPort_DataBits_Map.value(serial_info_map.value(SerialPort_DataBits_Key).toUInt()));

        //设置停止位置
        m_serialport->setStopBits( XYSerialPort_StopBits_Map.value(serial_info_map.value(SerialPort_StopBits_Key).toDouble()) );

        //设置奇偶校验
        m_serialport->setParity( XYSerialPort_Parity_Map.value(serial_info_map.value(SerialPort_Parity_Key).toString()) );

        //设置流控
        m_serialport->setFlowControl(XYSerialPort_FlowControl_Map.value(serial_info_map.value(SerialPort_FlowControl_Key).toString()));

        //设置串口信息
        m_serialport_para_info=QString("串口:%1  波特率: %2  数据位: %3  停止位: %4  奇偶检验: %5  流控: %6").arg(serial_info_map.value(SerialPort_PortName_Key).toString())
                .arg(serial_info_map.value(SerialPort_BaudRate_Key).toUInt()).arg(serial_info_map.value(SerialPort_DataBits_Key).toUInt())
                .arg(serial_info_map.value(SerialPort_StopBits_Key).toDouble()).arg( serial_info_map.value(SerialPort_Parity_Key).toString() )
                .arg( serial_info_map.value(SerialPort_FlowControl_Key).toString() );

        //开启串口
        m_serialport_connection_status = m_serialport->open(QIODevice::ReadWrite);
        emit xyserialport_connection_signal(m_serialport_connection_status);

        if(m_serialport_connection_status){
            m_task_vector.clear();
            connect(m_timer,SIGNAL( timeout() ),this,SLOT( handle_task() ));
            m_timer->start();
        }

        return m_serialport_connection_status;
    }

    bool XYSerialPort::disconnectfromSerialPort()
    {

        if(m_serialport->isOpen()){
            qDebug().noquote() << "断开串口连接" <<endl;
            m_serialport->close();
            m_serialport_connection_status = false;
            emit xyserialport_connection_signal(m_serialport_connection_status);

            disconnect(m_timer,SIGNAL( timeout() ),this,SLOT( handle_task() ));
            m_timer->stop();

            m_task_vector.clear();

            return true;
        }
        return false;
    }

    bool XYSerialPort::getSerialPortConnectionStatus()
    {
        return  m_serialport_connection_status;
    }

    void XYSerialPort::handleErrorOccurred(QSerialPort::SerialPortError error)
    {

        if(error != QSerialPort::NoError){
            qDebug().noquote() << "串口错误: "<< error << endl;
        }

    }

    QString XYSerialPort::getSerialPortConnectionParaInfo()
    {
        return m_serialport_para_info;
    }

    int XYSerialPort::calculateCRC16(int stationID, QString funcCode, int regAddr, int regValue)
    {
        QByteArray data;
        data.clear();

        //站址
        QString station_hex_str = QString::number(stationID,16).rightJustified(2,QChar('0'));
        data +=QByteArray::fromHex(station_hex_str.toUtf8());

        //功能码
        data += QByteArray::fromHex(funcCode.toUtf8());

        //寄存器地址
        QString regAddr_hex_str = QString::number(regAddr,16).rightJustified(4,QChar('0'));
        data += QByteArray::fromHex(regAddr_hex_str.toUtf8());

        //寄存器值
        if(regValue>=0){
            QString regValue_hex_str = QString::number(regValue,16).rightJustified(4,QChar('0'));
            data += QByteArray::fromHex(regValue_hex_str.toUtf8());
        }else if(regValue<0){
            QString regValue_hex_str = QString::number(regValue,16).right(4);
            data += QByteArray::fromHex(regValue_hex_str.toUtf8());
        }

        uint8_t* caldata = reinterpret_cast<uint8_t*>(data.data());
        uint16_t usCRC16 = CRC::CRC16::CRC16_Modbus(caldata,data.size());
        //当前CRC16 字符串
        m_crc16_hexstring = QString::number(usCRC16,16).rightJustified(4,QChar('0'));

        //计算Modbus-RTU命令
        m_modbus_rtu_command_hexstring.clear();
        QString tempstring = data.toHex()+m_crc16_hexstring;
        for (int i = 0; i < tempstring.size(); ++i) {
            if (i % 2 == 0 && i>0 ) {
              m_modbus_rtu_command_hexstring.append(' ');
            }
            m_modbus_rtu_command_hexstring.append(tempstring[i]);
        }

        return usCRC16;
    }

    QString XYSerialPort::getCRC16HexString()
    {
        return m_crc16_hexstring;
    }

    QString XYSerialPort::getModbusCommandHexString()
    {
        return m_modbus_rtu_command_hexstring;
    }

    QString XYSerialPort::getNegativeValueHexString(int value)
    {
        QString hex_str = QString::number(value,16).right(4);
        return hex_str;
    }

    void XYSerialPort::sendModbusRTUCommand(QString send_hexstr)
    {
        send_hexstr.replace(" ","");//清除空格
        QByteArray send_data = QByteArray::fromHex(send_hexstr.toUtf8());
        m_serialport->write(send_data);
    }

    void XYSerialPort::handleModbusRTURevData()
    {

        QByteArray revRawData = m_serialport->readAll();
        QString data_hexstring="";

        QString tempstring = revRawData.toHex();
        for (int i = 0; i < tempstring.size(); ++i) {
            if (i % 2 == 0 && i>0 ) {
              data_hexstring.append(' ');
            }
            data_hexstring.append(tempstring[i]);
        }

        emit xyserialport_revdata_signal(data_hexstring);
    }

    void XYSerialPort::handle_btn_command(int status)
    {

        QByteArray cmd;
        cmd.clear();

        switch (status) {
            case 1:
                cmd.append(QByteArray::fromHex(QString("01 06 00 4E 00 01 28 1D").toUtf8()));
                break;
            case 2:
                cmd.append(QByteArray::fromHex(QString("01 06 00 4E 00 20 E8 05").toUtf8()));
                break;
            case 3:
                break;
            case 4:
                break;
            default:
                break;
        }
    }



    void XYSerialPort::appendTask(QString task)
    {

        if(DDR_Command_Map.contains(task)){

            if(task == DDR_Run_Tag){

                m_task_vector.push_back( QByteArray::fromHex(DDR_Command_Map.value(DDR_Run_Tag).toUtf8()) );
                m_task_vector.push_back( QByteArray::fromHex(DDR_Command_Map.value(DDR_Run_Reset_Tag).toUtf8()) );

            }

            if(task == DDR_Ready_Tag){

                m_task_vector.push_back( QByteArray::fromHex(DDR_Command_Map.value(DDR_Ready_Tag).toUtf8()) );
                m_task_vector.push_back( QByteArray::fromHex(DDR_Command_Map.value(DDR_Ready_Reset_Tag).toUtf8()) );

            }

        }

        //启动点动
        if(task == DDR_CW_StepMove_PreSet_Tag){

            for(auto& each_preset_tag : DDR_StepMove_PreSet_List){

                m_task_vector.push_back( QByteArray::fromHex(DDR_Command_Map.value(each_preset_tag).toUtf8()) );
            }
            step_mode_status = true;
            m_stepmove_timer->start();
        }

        //取消点动
        if( task == DDR_CW_StepMove_Cancel_Tag ){
            for(auto& each_preset_tag:DDR_StepMove_Cancel_Set_List){
                m_task_vector.push_back( QByteArray::fromHex(DDR_Command_Map.value(each_preset_tag).toUtf8()) );
            }
            step_mode_status=false;
            m_stepmove_timer->stop();
        }

        //正向点动
        if(task == DDR_CW_StepMove_Tag){
            for(auto& each_preset_tag:DDR_CW_StepMove_Set_List){
                m_task_vector.push_back( QByteArray::fromHex(DDR_Command_Map.value(each_preset_tag).toUtf8()) );
            }
        }


        //反向点动
        if(task == DDR_CCW_StepMove_Tag){
            for(auto& each_preset_tag:DDR_CCW_StepMove_Set_List){
                m_task_vector.push_back( QByteArray::fromHex(DDR_Command_Map.value(each_preset_tag).toUtf8()) );
            }
        }


        //测试运动1
        if(task == DDR_Move_Combo_1_Tag){
            //添加位移
//            uint8_t* caldata = reinterpret_cast<uint8_t*>(data.data());
//            uint16_t usCRC16 = CRC::CRC16::CRC16_Modbus(caldata,data.size());
//                    m_crc16_hexstring = QString::number(usCRC16,16).rightJustified(4,QChar('0'));
//            QString path1="01 10 11 0c 00 02 04 00 00";
//            QString hex_str =QString::number(450,16).rightJustified(2,QChar('0'));
//            path1 += hex_str;
//            CRC::CRC16::CRC16_Modbus();
            QString path1="01 10 11 0c 00 02 04 00 00 01 c2 b3 ab";
            m_task_vector.push_back( QByteArray::fromHex(path1.toUtf8()) );

            QString vel1="01 06 11 0e 00 48 ed 03";
            m_task_vector.push_back( QByteArray::fromHex(vel1.toUtf8()) );

            for(auto& each_preset_tag:DDR_Move_Combo_1_Set_List){
                m_task_vector.push_back( QByteArray::fromHex(each_preset_tag.toUtf8()) );
            }
        }

        //测试运动2
        if(task == DDR_Move_Combo_2_Tag){
            //添加位移
            QString path2="01 10 11 0c 00 02 04 ff ff fe 3e f2 3e";
            m_task_vector.push_back( QByteArray::fromHex(path2.toUtf8()) );

            QString vel2="01 06 11 0e 00 12 6d 38";
            m_task_vector.push_back( QByteArray::fromHex(vel2.toUtf8()) );


//            for(auto& each_preset_tag:DDR_Move_Combo_2_Set_List){
//                m_task_vector.push_back( QByteArray::fromHex(each_preset_tag.toUtf8()) );
//            }
        }

        if(task == "暂停"){

            m_task_vector.push_back( QByteArray::fromHex(DDR_Ready_Status_Set_On.toUtf8()) );

        }

        if(task == "启动"){

            m_task_vector.push_back( QByteArray::fromHex(DDR_Ready_Status_Set_Reset.toUtf8()) );

        }

    }

    void XYSerialPort::appendTaskfromMap(QVariantMap taskmap)
    {

    }

    void XYSerialPort::appendTaskfromList(QList<QString> tasklist)
    {

    }

    void XYSerialPort::handle_movement(int up_down)
    {
        QByteArray cmd;
        if(up_down==1){
            cmd = QByteArray::fromHex(ClockWise_High_Address.toUtf8());
        }else if(up_down ==2){
            cmd = QByteArray::fromHex(CounterClockWise_High_Address.toUtf8());
        }

        m_up_down_status = up_down;
        m_serialport->write(cmd);

        QTimer::singleShot(100,this,SLOT(handle_movement_i()));
    }

    void XYSerialPort::handle_movement_i()
    {
        QByteArray cmd;
        if(m_up_down_status==1){
            cmd = QByteArray::fromHex(ClockWise_Low_Address.toUtf8());
        }else if(m_up_down_status ==2){
            cmd = QByteArray::fromHex(CounterClockWise_Low_Address.toUtf8());
        }
        m_serialport->write(cmd);
        QTimer::singleShot(100,this,SLOT(handle_movement_ii()));

    }

    void XYSerialPort::handle_movement_ii()
    {
        if(m_up_down_status==1){


        }else if(m_up_down_status ==2){

        }

        this->handle_movement_exe();
    }

    void XYSerialPort::handle_movement_exe()
    {
        QByteArray cmd = QByteArray::fromHex(Execution_Movement.toUtf8());
        m_serialport->write(cmd);

    }

    void XYSerialPort::handle_task()
    {

        if(m_task_vector.empty()){
            return;
        }

        QByteArray current_command = m_task_vector.front();

        if(m_serialport->isOpen()){
            m_serialport->write(current_command);
        }

        m_task_vector.pop_front();


    }

    void XYSerialPort::handleStepMoveStatus()
    {

        if(step_mode_status){
            m_task_vector.push_back(QByteArray::fromHex(DDR_CCW_StepMove_PreSet_12.toUtf8()));
        }

    }



}


