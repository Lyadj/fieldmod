#include "gripper/include/Gripper.h"


namespace ATPGripper {

    Gripper::Gripper(QObject *parent) : QObject(parent)
    {

        m_gripper_serialport = new QSerialPort();
        m_gripper_master = new QModbusRtuSerialMaster();

        m_avaiable_serial_ports.clear();

        m_connection_status = false;

        m_serialport_info="";

        m_CRC16_string = "";

        m_Modbus_string = "";

        //处理错误
        connect(m_gripper_serialport,SIGNAL( errorOccurred(QSerialPort::SerialPortError) ),this,SLOT( handleErrorOccurred(QSerialPort::SerialPortError) ));
        //处理数据返回
        connect(m_gripper_serialport,SIGNAL( readyRead() ),this,SLOT( handlerevdata() ));

    }

    bool Gripper::getStatusofGripperConnection()
    {
        return m_connection_status;
    }

    bool Gripper::connect2Gripper(QVariantMap serial_info_map)
    {
        qDebug().noquote() << "通过串口开始连接电爪" <<endl;

        m_serialport_info="";
        //设置串口名称
        m_gripper_serialport->setPortName(serial_info_map.value(Serial_PortName_Key).toString());
        m_gripper_master->setConnectionParameter(QModbusDevice::SerialPortNameParameter,serial_info_map.value(Serial_PortName_Key).toString());

        //设置波特率
        m_gripper_serialport->setBaudRate(serial_info_map.value(Serial_BaudRate_Key).toUInt());
        m_gripper_master->setConnectionParameter(QModbusDevice::SerialBaudRateParameter,serial_info_map.value(Serial_BaudRate_Key).toUInt());

        //设置数据位
        m_gripper_serialport->setDataBits(ATPGripper_Serial_DataBits_Map.value(serial_info_map.value(Serial_DataBits_Key).toUInt()));
        m_gripper_master->setConnectionParameter(QModbusDevice::SerialDataBitsParameter,ATPGripper_Serial_DataBits_Map.value(serial_info_map.value(Serial_DataBits_Key).toUInt()));

        //设置停止位置
        m_gripper_serialport->setStopBits( ATPGripper_Serial_StopBits_Map.value(serial_info_map.value(Serial_StopBits_Key).toDouble()) );
        m_gripper_master->setConnectionParameter(QModbusDevice::SerialStopBitsParameter,ATPGripper_Serial_StopBits_Map.value(serial_info_map.value(Serial_StopBits_Key).toDouble()));

        //设置奇偶校验
        m_gripper_serialport->setParity( ATPGripper_Serial_Parity_Map.value(serial_info_map.value(Serial_Parity_Key).toString()) );
        m_gripper_master->setConnectionParameter(QModbusDevice::SerialParityParameter,ATPGripper_Serial_Parity_Map.value(serial_info_map.value(Serial_Parity_Key).toString()));

        //设置流控
        m_gripper_serialport->setFlowControl(ATPGripper_Serial_FlowControl_Map.value(serial_info_map.value(Serial_FlowControl_Key).toString()));

        //设置串口最大限制时间
        m_gripper_master->setTimeout(Max_Gripper_Idle_Time);

        //设置串口信息
        m_serialport_info=QString("串口:%1  波特率: %2  数据位: %3  停止位: %4  奇偶检验: %5  流控: %6").arg(serial_info_map.value(Serial_PortName_Key).toString())
                .arg(serial_info_map.value(Serial_BaudRate_Key).toUInt()).arg(serial_info_map.value(Serial_DataBits_Key).toUInt())
                .arg(serial_info_map.value(Serial_StopBits_Key).toDouble()).arg( serial_info_map.value(Serial_Parity_Key).toString() )
                .arg( serial_info_map.value(Serial_FlowControl_Key).toString() );

        //RTU服务器设置串口
        m_connection_status = m_gripper_serialport->open(QIODevice::ReadWrite);

        emit gripper_statechanged_signal(m_connection_status);

        return m_connection_status;

    }

    bool Gripper::disconnect2Gripper()
    {

        qDebug().noquote() << "准备断开电爪连接" <<endl;
        m_gripper_serialport->close();
        m_connection_status = m_gripper_serialport->isOpen();
        emit gripper_statechanged_signal(m_connection_status);
        return true;
    }

    void Gripper::handleStateChanged(QModbusDevice::State state)
    {

        qDebug().noquote() << "电爪连接状态切换至: " << state <<endl;

        m_connection_status = (state==QModbusDevice::ConnectedState) ? true:(state==QModbusDevice::UnconnectedState)?false:false;
        emit gripper_statechanged_signal(m_connection_status);

    }

    void Gripper::handleErrorOccurred(QSerialPort::SerialPortError error)
    {
        qDebug().noquote() << "电爪串口通信错误: " << error <<endl;
    }

    QString Gripper::getSerialInfo()
    {
        return m_serialport_info;
    }

    QString Gripper::getCRC16CurrentString()
    {
        return m_CRC16_string;
    }

    QString Gripper::getModbusString()
    {
        return m_Modbus_string;
    }

    void Gripper::handlerevdata()
    {

        revData += m_gripper_serialport->readAll();

        if(!valid_receive_bytearray(revData)){
            return;
        }

        QString rev_string="";
        m_Modbus_string.clear();
        QString tempstring = revData.toHex();
        for (int i = 0; i < tempstring.size(); ++i) {
            if (i % 2 == 0 && i>0 ) {
              rev_string.append(' ');
            }
            rev_string.append(tempstring[i]);
        }

        emit rev_data_signal(rev_string);

        revData.clear();

    }

    bool Gripper::valid_receive_bytearray(QByteArray& rawdata){
        return rawdata.length() == Gripper_Rev_Length;
    }

    int Gripper::getCRC16(int stationID, QString funcCode, int regAddr, int regValue)
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

        m_CRC16_string = QString::number(usCRC16,16).rightJustified(4,QChar('0'));

        //当前命令
        m_Modbus_string.clear();
        QString tempstring = data.toHex()+m_CRC16_string;
        for (int i = 0; i < tempstring.size(); ++i) {
            if (i % 2 == 0 && i>0 ) {
              m_Modbus_string.append(' ');
            }
            m_Modbus_string.append(tempstring[i]);
        }

        return usCRC16;
    }

    void Gripper::sendcommand(QString send_str)
    {

        send_str.replace(" ","");//清除空格
        QByteArray send_data = QByteArray::fromHex(send_str.toUtf8());
        m_gripper_serialport->write(send_data);

    }

    QString Gripper::getNegativeHexString(int value)
    {
        QString hex_str = QString::number(value,16).right(4);
        return hex_str;
    }

    QString Gripper::getCommandHexStringByName(QString commandName)
    {
        return CommandMap.value(commandName);
    }

    QStringList Gripper::getAllCommandList()
    {
        return CommandNameList;
    }


    QList<QString> Gripper::searchAllAvailableSerialports()
    {

        m_avaiable_serial_ports.clear();
        QList<QSerialPortInfo> available_ports_list = QSerialPortInfo::availablePorts();


        for(auto eachport:available_ports_list){
            m_avaiable_serial_ports.append(eachport.portName());
        }

        return m_avaiable_serial_ports;
    }


}


