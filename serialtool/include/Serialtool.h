#ifndef SERIALTOOL_H
#define SERIALTOOL_H

#include "Serialtool.Commons.hpp"


namespace SerialTool {


    class XYSerialPort : public QObject
    {

        Q_OBJECT

        public:
            explicit XYSerialPort(QObject *parent = nullptr);

        signals:
            //串口debug
            void xyserialport_info_signal(QString infomsg);
            //串口warning
            void xyserialport_warn_signal(QString warnmsg);
            //串口error
            void xyserialport_error_signal(QString errormsg);

            //连接与断开切换：true-已连接，false-已断开
            void xyserialport_connection_signal(bool statestatus);

            //接收数据输出
            void xyserialport_revdata_signal(QString rev_hexstr);

        public slots:

            //寻找所有可用的串口
            QList<QString> searchAllAvailableSerialPorts();

            //连接串口
            bool connect2SerialPort(QVariantMap serial_info_map);

            //断开串口连接
            bool disconnectfromSerialPort();

            //查询串口当前的状态
            bool getSerialPortConnectionStatus();

            //处理错误状态
            void handleErrorOccurred(QSerialPort::SerialPortError error);

            //返回串口连接的参数信息
            QString getSerialPortConnectionParaInfo();

            //利用已知的参数：站址、功能码、寄存器地址、寄存器数值 计算2字节的CRC16
            int calculateCRC16(int stationID,QString funcCode,int regAddr,int regValue);
            //返回CRC16字符串
            QString getCRC16HexString();
            //返回Modbus-RTU指令的hex string
            QString getModbusCommandHexString();

            //返回负数对应的hex string
            QString getNegativeValueHexString(int value);

            //发送modbusrtu指令
            void sendModbusRTUCommand(QString send_hexstr);

            //处理modbus-RTU返回的信息
            void handleModbusRTURevData();

            void handle_btn_command(int status);

            //增加任务
            void appendTask(QString task);
            //增加任务
            void appendTaskfromMap(QVariantMap taskmap);
            //增加任务
            void appendTaskfromList(QList<QString> tasklist);

            //转动处理
            void handle_movement(int up_down);

            void handle_movement_i();

            void handle_movement_ii();

            void handle_movement_exe();

            //执行写入任务
            void handle_task();

            //持续保持状态
            void handleStepMoveStatus();

    private:

        //写入timer
        QTimer* m_timer;
        //写入step mode 的timer
        QTimer* m_stepmove_timer;


        QVector<QByteArray> m_task_vector;

        //串口名称
        QList<QString> m_avaiable_serialports_list;

        //串口连接状态
        bool m_serialport_connection_status;

        //上下运动的zhuang'tai
        int m_up_down_status = 0;

        //串口
        QSerialPort* m_serialport;

        //串口连接设置的参数
        QString m_serialport_para_info;

        //CRC16的16进制字符串
        QString m_crc16_hexstring;

        //总体命令的字符串
        QString m_modbus_rtu_command_hexstring;

        QMap<int,QSerialPort::DataBits> XYSerialPort_DataBits_Map={
            {5,QSerialPort::Data5},
            {6,QSerialPort::Data6},
            {7,QSerialPort::Data7},
            {8,QSerialPort::Data8}
        };

        QMap<double,QSerialPort::StopBits> XYSerialPort_StopBits_Map={
            {1,QSerialPort::OneStop},
            {1.5,QSerialPort::OneAndHalfStop},
            {2,QSerialPort::TwoStop}
        };

        QMap<QString,QSerialPort::Parity> XYSerialPort_Parity_Map={
            {"无校验",QSerialPort::NoParity},
            {"偶校验",QSerialPort::EvenParity},
            {"奇校验",QSerialPort::OddParity},
            {"空格校验",QSerialPort::SpaceParity},
            {"标记校验",QSerialPort::MarkParity}
        };

        QMap<QString,QSerialPort::FlowControl> XYSerialPort_FlowControl_Map={
            {"无流控",QSerialPort::NoFlowControl},
            {"软件流控",QSerialPort::SoftwareControl},
            {"硬件流控",QSerialPort::HardwareControl}
        };


        //旋转台任务
        const QString DDR_Run_Tag = "旋转台Run";
        const QString DDR_Run_Reset_Tag = "旋转台Run重置";

        const QString DDR_Ready_Tag = "旋转台Ready";
        const QString DDR_Ready_Reset_Tag = "旋转台Ready重置";


        //正向点动需要持续写入
        bool step_mode_status = false;


        const QString DDR_CW_StepMove_Tag = "正向点动";
        const QString DDR_CW_StepMove_1_Tag = "正向点动1";
        const QString DDR_CW_StepMove_2_Tag = "正向点动2";
        const QString DDR_CW_StepMove_3_Tag = "正向点动3";

        QVector<QString> DDR_CW_StepMove_Set_List={
            DDR_CW_StepMove_1_Tag,DDR_CW_StepMove_2_Tag,
            DDR_CW_StepMove_3_Tag,
        };


        const QString DDR_CCW_StepMove_Tag = "反向点动";
        const QString DDR_CCW_StepMove_1_Tag = "反向点动1";
        const QString DDR_CCW_StepMove_2_Tag = "反向点动2";
        const QString DDR_CCW_StepMove_3_Tag = "反向点动3";


        QVector<QString> DDR_CCW_StepMove_Set_List={
            DDR_CCW_StepMove_1_Tag,DDR_CCW_StepMove_2_Tag,
            DDR_CCW_StepMove_3_Tag,
        };


        const QString DDR_CW_StepMove_PreSet_Tag = "点动开启";
        const QString DDR_CW_StepMove_PreSet_1_Tag = "点动预设1";
        const QString DDR_CW_StepMove_PreSet_2_Tag = "点动预设2";
        const QString DDR_CW_StepMove_PreSet_3_Tag = "点动预设3";
        const QString DDR_CW_StepMove_PreSet_4_Tag = "点动预设4";
        const QString DDR_CW_StepMove_PreSet_5_Tag = "点动预设5";
        const QString DDR_CW_StepMove_PreSet_6_Tag = "点动预设6";
        const QString DDR_CW_StepMove_PreSet_7_Tag = "点动预设7";
        const QString DDR_CW_StepMove_PreSet_8_Tag = "点动预设8";
        const QString DDR_CW_StepMove_PreSet_9_Tag = "点动预设9";
        const QString DDR_CW_StepMove_PreSet_10_Tag = "点动预设10";
        const QString DDR_CW_StepMove_PreSet_11_Tag = "点动预设11";
        const QString DDR_CW_StepMove_PreSet_12_Tag = "点动预设12";

        const QString DDR_CW_StepMove_Cancel_Tag = "取消点动";
        const QString DDR_CW_StepMove_Cancel_Set_1_Tag = "取消点动设置1";
        const QString DDR_CW_StepMove_Cancel_Set_2_Tag = "取消点动设置1";
        const QString DDR_CW_StepMove_Cancel_Set_3_Tag = "取消点动设置1";


        QVector<QString> DDR_StepMove_PreSet_List={
            DDR_CW_StepMove_PreSet_1_Tag,DDR_CW_StepMove_PreSet_2_Tag,
            DDR_CW_StepMove_PreSet_3_Tag,DDR_CW_StepMove_PreSet_4_Tag,
            DDR_CW_StepMove_PreSet_5_Tag,DDR_CW_StepMove_PreSet_6_Tag,
            DDR_CW_StepMove_PreSet_7_Tag,DDR_CW_StepMove_PreSet_8_Tag,
            DDR_CW_StepMove_PreSet_9_Tag,DDR_CW_StepMove_PreSet_10_Tag,
            DDR_CW_StepMove_PreSet_11_Tag,DDR_CW_StepMove_PreSet_12_Tag,
        };

        QVector<QString> DDR_StepMove_Cancel_Set_List={
            DDR_CW_StepMove_Cancel_Set_1_Tag,DDR_CW_StepMove_Cancel_Set_2_Tag,
            DDR_CW_StepMove_Cancel_Set_3_Tag,
        };


        const QString DDR_Move_Combo_1_Tag = "运动测试1";

        const QString DDR_Move_Combo_2_Tag = "运动测试2";

        QVector<QString> DDR_Move_Combo_1_Set_List={
            DDR_Enable_Path_Move,
            DDR_Run_Status_Set_On,
        };

        QVector<QString> DDR_Move_Combo_2_Set_List={
            DDR_SetUp_1_Cycle_CCW,
            DDR_Enable_Path_Move,
            DDR_Run_Status_Set_On
        };


        QMap<QString,QString> DDR_Command_Map={
            {DDR_Run_Tag,DDR_Run_Status_Set_On},
            {DDR_Run_Reset_Tag,DDR_Run_Status_Set_Reset},
            {DDR_Ready_Tag,DDR_Ready_Status_Set_On},
            {DDR_Ready_Reset_Tag,DDR_Ready_Status_Set_Reset},


            {DDR_CW_StepMove_1_Tag,DDR_CW_StepMove_Set_1},
            {DDR_CW_StepMove_2_Tag,DDR_CW_StepMove_Set_2},
            {DDR_CW_StepMove_3_Tag,DDR_CW_StepMove_Set_3},


            {DDR_CCW_StepMove_1_Tag,DDR_CCW_StepMove_Set_1},
            {DDR_CCW_StepMove_2_Tag,DDR_CCW_StepMove_Set_2},
            {DDR_CCW_StepMove_3_Tag,DDR_CCW_StepMove_Set_3},


            {DDR_CW_StepMove_PreSet_1_Tag,DDR_CCW_StepMove_PreSet_1},
            {DDR_CW_StepMove_PreSet_2_Tag,DDR_CCW_StepMove_PreSet_2},
            {DDR_CW_StepMove_PreSet_3_Tag,DDR_CCW_StepMove_PreSet_3},
            {DDR_CW_StepMove_PreSet_4_Tag,DDR_CCW_StepMove_PreSet_4},
            {DDR_CW_StepMove_PreSet_5_Tag,DDR_CCW_StepMove_PreSet_5},
            {DDR_CW_StepMove_PreSet_6_Tag,DDR_CCW_StepMove_PreSet_6},
            {DDR_CW_StepMove_PreSet_7_Tag,DDR_CCW_StepMove_PreSet_7},
            {DDR_CW_StepMove_PreSet_8_Tag,DDR_CCW_StepMove_PreSet_8},
            {DDR_CW_StepMove_PreSet_9_Tag,DDR_CCW_StepMove_PreSet_9},
            {DDR_CW_StepMove_PreSet_10_Tag,DDR_CCW_StepMove_PreSet_10},
            {DDR_CW_StepMove_PreSet_11_Tag,DDR_CCW_StepMove_PreSet_11},
            {DDR_CW_StepMove_PreSet_12_Tag,DDR_CCW_StepMove_PreSet_12},


            {DDR_CW_StepMove_Cancel_Set_1_Tag,DDR_CCW_StepMove_Cancel_Set_1},
            {DDR_CW_StepMove_Cancel_Set_2_Tag,DDR_CCW_StepMove_Cancel_Set_2},
            {DDR_CW_StepMove_Cancel_Set_3_Tag,DDR_CCW_StepMove_Cancel_Set_3},

        };



    };

}



#endif // SerialTool
