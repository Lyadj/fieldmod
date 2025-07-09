#pragma once

#include "utility/include/utility.h"


namespace SerialTool {

    const QString SerialPort_PortName_Key="serial_portname";
    const QString SerialPort_BaudRate_Key="serial_baudrate";
    const QString SerialPort_DataBits_Key="serial_databit";
    const QString SerialPort_StopBits_Key="serial_stopbit";
    const QString SerialPort_Parity_Key="serial_parity";
    const QString SerialPort_FlowControl_Key="serial_flowcontrol";


    //电机驱动设置的相关指令
    //设置运动位置
    //正向运动
    const QString ClockWise_High_Address="01 06 00 37 00 00 38 04";
    const QString ClockWise_Low_Address="01 06 00 38 07 d0 0b ab";


    //反向运动
    const QString CounterClockWise_High_Address="01 06 00 37 ff ff 39 b4";
    const QString CounterClockWise_Low_Address="01 06 00 38 f8 30 4b d3";


    const QString Execution_Movement="01 06 00 4e 00 01 28 1d";

    //顶点写入时间间隔
    const int Task_Interval = 80;

    //顶点写入时间间隔
    const int StepMoveStatus_Interval = 2000;


    //转动台的指令测试
    const QString DDR_Run_Status_Set_On="01 06 03 0b 00 01 39 8c";

    const QString DDR_Run_Status_Set_Reset="01 06 03 0b 00 00 f8 4c";

    const QString DDR_Ready_Status_Set_On="01 06 0d 05 00 01 5a a7";

    const QString DDR_Ready_Status_Set_Reset="01 06 0d 05 00 00 9b 67";

    //正向点动 clockwise
    const QString DDR_CW_StepMove_Set_1="01 06 2f 1d 00 00 11 18";
    const QString DDR_CW_StepMove_Reset_1="";

    const QString DDR_CW_StepMove_Set_2="01 06 2f 0b 00 01 31 1c";
    const QString DDR_CW_StepMove_Reset_2="";

    const QString DDR_CW_StepMove_Set_3="01 06 2f 0b 00 00 f0 dc";
    const QString DDR_CW_StepMove_Reset_3="";



    //负向点动 counter-clockwise
    const QString DDR_CCW_StepMove_Set_1="01 06 2f 1d 00 00 11 18";
    const QString DDR_CCW_StepMove_Reset_1="";

    const QString DDR_CCW_StepMove_Set_2="01 06 2f 0b 00 02 71 1d";
    const QString DDR_CCW_StepMove_Reset_2="";

    const QString DDR_CCW_StepMove_Set_3="01 06 2f 0b 00 00 f0 dc";
    const QString DDR_CCW_StepMove_Reset_3="";



    const QString DDR_CCW_StepMove_PreSet_1="01 06 2f 09 00 3c 51 0d";
    const QString DDR_CCW_StepMove_PreSet_2="01 06 2f 0a 00 32 20 c9";
    const QString DDR_CCW_StepMove_PreSet_3="01 06 2f 1e 01 90 e0 e4";
    const QString DDR_CCW_StepMove_PreSet_4="01 06 2f 1f 00 64 b1 33";
    const QString DDR_CCW_StepMove_PreSet_5="01 06 2f 18 01 f4 01 0e";
    const QString DDR_CCW_StepMove_PreSet_6="01 06 2f 0b 00 00 f0 dc";

    const QString DDR_CCW_StepMove_PreSet_7="01 06 2f 0c 00 00 41 1d";
    const QString DDR_CCW_StepMove_PreSet_8="01 06 2f 1d 00 01 d0 d8";
    const QString DDR_CCW_StepMove_PreSet_9="01 06 2f 01 00 01 11 1e";
    const QString DDR_CCW_StepMove_PreSet_10="01 06 2f 00 00 3c 81 0f";
    const QString DDR_CCW_StepMove_PreSet_11="01 06 2f 08 00 01 c1 1c";
    //处于点动模式需要持续写入此条
    const QString DDR_CCW_StepMove_PreSet_12="01 06 2f 00 00 3c 81 0f";

    const QString DDR_CCW_StepMove_Cancel_Set_1="01 06 2f 1d 00 01 d0 d8";
    const QString DDR_CCW_StepMove_Cancel_Set_2="01 06 2f 08 00 00 00 dc";
    const QString DDR_CCW_StepMove_Cancel_Set_3="01 06 2f 00 00 28 81 00";

    //旋转台初始化
    const QString DDR_Init_SetUp_Default_Assign_1="01 06 03 00 00 01 48 4e";
    const QString DDR_Init_SetUp_Default_Assign_2="01 06 03 01 00 00 d8 4e";
    const QString DDR_Init_SetUp_Servo_On_Func_Code="01 06 03 0a 00 01 68 4c";
    const QString DDR_Init_SetUp_Move_Path_Func_Code="01 06 03 0c 00 1c 48 44";
    const QString DDR_Init_SetUp_Path_Mode="01 06 05 00 00 02 08 c7";
    const QString DDR_Init_SetUp_Individual_Move_Mode="01 06 11 00 00 00 8c f6";
    //设置总的路程数，就使用1段
    const QString DDR_Init_SetUp_Path_Count="01 06 11 01 00 01 1c f6";
    //继续上一次运动还是单独运动
    const QString DDR_Init_SetUp_Move_Resume_Mode="01 06 11 02 00 01 ec f6";
    //运动1圈,CW
    const QString DDR_SetUp_1_Cycle_CW="0110110c000204000003843339";
    //运动1圈,CCW
    const QString DDR_SetUp_1_Cycle_CCW="01 06 11 0c fc 7c 0c 14";
    //设置速度,18
    const QString DDR_SetUp_RPM="01 06 11 0e 00 12 6d 38";
    //加速减速时间
    const QString DDR_SetUp_Ramping_Time="01 06 11 0f 01 f4 bc e2";
    //等待时间
    const QString DDR_SetUp_Idle_Time="01 06 11 10 00 0a 0d 34";


    const QString DDR_SetUp_Servo_On="01 06 03 0b 00 01 39 8c";
    const QString DDR_SetUp_Servo_ReSet="01 06 03 0b 00 00 f8 4c";

    const QString DDR_SetUp_Path_On="01 06 03 0d 00 01 d9 8d";
    const QString DDR_SetUp_Path_On_ReSet="01 06 03 0d 00 00 18 4d";


    const QString DDR_Current_RPM_Get = "01 03 0b 00 00 01 86 2e";

    const QString DDR_Enable_Path_Move="01 06 03 0d 00 01 d9 8d";



}
