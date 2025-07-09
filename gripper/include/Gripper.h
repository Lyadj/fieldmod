#ifndef GRIPPER_H
#define GRIPPER_H


#include "Gripper.Commons.hpp"


namespace ATPGripper {



    class Gripper : public QObject
    {
        Q_OBJECT
    public:
        explicit Gripper(QObject *parent = nullptr);

        bool valid_receive_bytearray(QByteArray& rawdata);

    signals:
        void gripper_ready_signal();

        void gripper_info_signal(QString infomsg);
        void gripper_warn_signal(QString warnmsg);
        void gripper_error_signal(QString errormsg);

        //状态切换的信号：true-已连接，false-已断开
        void gripper_statechanged_signal(bool statestatus);
        //接收数据输出
        void rev_data_signal(QString rev_str);


    public slots:
        //寻找所有可用的串口
        QList<QString> searchAllAvailableSerialports();
        //查询机械爪连接状态
        bool getStatusofGripperConnection();
        //设置连接的窗口
        bool connect2Gripper(QVariantMap serial_info_map);
        //断开连接
        bool disconnect2Gripper();
        //处理连接的状态切换
        void handleStateChanged(QModbusDevice::State state);
        //处理错误状态
        void handleErrorOccurred(QSerialPort::SerialPortError error);
        //返回串口连接信息
        QString getSerialInfo();
        //返回CRC16字符串
        QString getCRC16CurrentString();
        //返回Modbus字符串的指令
        QString getModbusString();
        //处理返回的信息
        void handlerevdata();

        int getCRC16(int stationID,QString funcCode,int regAddr,int regValue);

        void sendcommand(QString send_str);
        //返回负数对应的16进制string
        QString getNegativeHexString(int value);
        //返回指令名称对应的值
        QString getCommandHexStringByName(QString commandName);
        //获取所有指令的数值
        QStringList getAllCommandList();


    public:
        QMap<QString,QString> CommandMap={
            {"读取-初始化状态",Command_Initial_Gripper_Get},
            {"设置-初始化",Command_Initial_Gripper_Set},
            {"读取-夹持力",Command_Gripper_Force_Get},
            {"设置-夹持力20%",Command_Gripper_Force_Set_20},
            {"设置-夹持力30%",Command_Gripper_Force_Set_30},
            {"设置-夹持力40%",Command_Gripper_Force_Set_40},
            {"设置-夹持力50%",Command_Gripper_Force_Set_50},
            {"设置-夹持力60%",Command_Gripper_Force_Set_60},
            {"设置-夹持力70%",Command_Gripper_Force_Set_70},
            {"设置-夹持力80%",Command_Gripper_Force_Set_80},
            {"设置-夹持力90%",Command_Gripper_Force_Set_90},
            {"设置-夹持力100%",Command_Gripper_Force_Set_100},

        };

        QStringList CommandNameList={
            "读取-初始化状态",
            "设置-初始化",
            "读取-夹持力",
            "设置-夹持力20%",
            "设置-夹持力30%",
            "设置-夹持力40%",
            "设置-夹持力50%",
            "设置-夹持力60%",
            "设置-夹持力70%",
            "设置-夹持力80%",
            "设置-夹持力90%",
            "设置-夹持力100%",
        };


    private:
        QSerialPort* m_gripper_serialport;

        QModbusRtuSerialMaster* m_gripper_master;

        bool m_connection_status;

        QString m_CRC16_string;

        QString m_Modbus_string;

        const int Gripper_Rev_Length = 8;

        QList<QString> m_avaiable_serial_ports;

        QByteArray revData;

        QMap<int,QSerialPort::DataBits> ATPGripper_Serial_DataBits_Map={
            {5,QSerialPort::Data5},
            {6,QSerialPort::Data6},
            {7,QSerialPort::Data7},
            {8,QSerialPort::Data8}
        };

        QMap<double,QSerialPort::StopBits> ATPGripper_Serial_StopBits_Map={
            {1,QSerialPort::OneStop},
            {1.5,QSerialPort::OneAndHalfStop},
            {2,QSerialPort::TwoStop}
        };

        QMap<QString,QSerialPort::Parity> ATPGripper_Serial_Parity_Map={
            {"无校验",QSerialPort::NoParity},
            {"偶校验",QSerialPort::EvenParity},
            {"奇校验",QSerialPort::OddParity},
            {"空格校验",QSerialPort::SpaceParity},
            {"标记校验",QSerialPort::MarkParity}
        };

        QMap<QString,QSerialPort::FlowControl> ATPGripper_Serial_FlowControl_Map={
            {"无流控",QSerialPort::NoFlowControl},
            {"软件流控",QSerialPort::SoftwareControl},
            {"硬件流控",QSerialPort::HardwareControl}
        };



        QString m_serialport_info;

    };


}



#endif // GRIPPER_H
