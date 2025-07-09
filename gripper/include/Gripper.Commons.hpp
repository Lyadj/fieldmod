#pragma once


#include "utility/include/utility.h"

//机械爪自定义参数

namespace ATPGripper {


    const QString Serial_PortName_Key="serial_portname";
    const QString Serial_BaudRate_Key="serial_baudrate";
    const QString Serial_DataBits_Key="serial_databit";
    const QString Serial_StopBits_Key="serial_stopbit";
    const QString Serial_Parity_Key="serial_parity";
    const QString Serial_FlowControl_Key="serial_flowcontrol";

    const int Max_Gripper_Idle_Time=400;

    //读取-机械爪初始化状态
    const QString Command_Initial_Gripper_Get= "01 03 01 00 00 01 85 f6";
    //设置-机械爪初始化状态
    const QString Command_Initial_Gripper_Set= "01 06 01 00 00 01 49 f6";
    //读取-夹持力20%-80%
    const QString Command_Gripper_Force_Get= "01 03 01 01 00 01 d4 36";

    //设置-夹持力20%
    const QString Command_Gripper_Force_Set_20= "01 06 01 01 00 14 d9 f9";
    //设置-夹持力30%
    const QString Command_Gripper_Force_Set_30= "01 06 01 01 00 1e 59 fe";
    //设置-夹持力40%
    const QString Command_Gripper_Force_Set_40= "01 06 01 01 00 28 d9 e8";
    //设置-夹持力50%
    const QString Command_Gripper_Force_Set_50= "01 06 01 01 00 32 58 23";
    //设置-夹持力60%
    const QString Command_Gripper_Force_Set_60= "01 06 01 01 00 3c d9 e7";
    //设置-夹持力70%
    const QString Command_Gripper_Force_Set_70= "01 06 01 01 00 46 58 04";
    //设置-夹持力80%
    const QString Command_Gripper_Force_Set_80= "01 06 01 01 00 50 d9 ca";
    //设置-夹持力90%
    const QString Command_Gripper_Force_Set_90= "01 06 01 01 00 5a 59 cd";
    //设置-夹持力100%
    const QString Command_Gripper_Force_Set_100= "01 06 01 01 00 64 d8 1d";


    //读取-运动位置
    const QString Command_Gripper_Position_Get= "01 03 01 03 00 01 75 f6";
    //设置-运动位置, 范围：0-1000%
    //设置-运动位置：0%
    const QString Command_Gripper_Position_Set_0= "01 06 01 03 00 00 78 36";
    //设置-运动位置：10%
    const QString Command_Gripper_Position_Set_10= "01 06 01 03 00 0a f8 31";
    //设置-运动位置：20%
    const QString Command_Gripper_Position_Set_20= "01 06 01 03 00 14 78 39";
    //设置-运动位置：50%
    const QString Command_Gripper_Position_Set_50= "01 06 01 03 00 32 f9 e3";
    //设置-运动位置：100%
    const QString Command_Gripper_Position_Set_100= "01 06 01 03 00 64 79 dd";
    //设置-运动位置：150%
    const QString Command_Gripper_Position_Set_150= "01 06 01 03 00 96 f8 58";
    //设置-运动位置：200%
    const QString Command_Gripper_Position_Set_200= "01 06 01 03 00 c8 79 a0";
    //设置-运动位置：400%
    const QString Command_Gripper_Position_Set_400= "01 06 01 03 01 90 79 ca";
    //设置-运动位置：500%
    const QString Command_Gripper_Position_Set_500= "01 06 01 03 01 f4 78 21";
    //设置-运动位置：600%
    const QString Command_Gripper_Position_Set_600= "01 06 01 03 02 58 78 ac";
    //设置-运动位置：800%
    const QString Command_Gripper_Position_Set_800= "01 06 01 03 03 20 79 1e";
    //设置-运动位置：1000%
    const QString Command_Gripper_Position_Set_1000= "01 06 01 03 03 e8 78 88";

    //读取-运动速度
    const QString Command_Gripper_Speed_Get= "01 03 01 04 00 01 c4 37";
    //设置-运动速度, 范围：0-100%
    //设置-运动速度：10%
    const QString Command_Gripper_Speed_Set_10= "01 06 01 04 00 0a 49 f0";
    //设置-运动速度：20%
    const QString Command_Gripper_Speed_Set_20= "01 06 01 04 00 14 c9 f8";
    //设置-运动速度：40%
    const QString Command_Gripper_Speed_Set_40= "01 06 01 04 00 28 c9 e9";
    //设置-运动速度：50%
    const QString Command_Gripper_Speed_Set_50= "01 06 01 04 00 32 48 22";
    //设置-运动速度：60%
    const QString Command_Gripper_Speed_Set_60= "01 06 01 04 00 3c c9 e6";
    //设置-运动速度：80%
    const QString Command_Gripper_Speed_Set_80= "01 06 01 04 00 50 c9 cb";
    //设置-运动速度：90%
    const QString Command_Gripper_Speed_Set_90= "01 06 01 04 00 5a 49 cc";
    //设置-运动速度：100%
    const QString Command_Gripper_Speed_Set_100= "01 06 01 04 00 64 c8 1c";

    //读取-旋转角度
    const QString Command_Gripper_Rotation_Degree_Get= "01 06 01 01 00 64 d8 1d";
    //设置-旋转角度, 范围：-32768(0x8000) - 32767(0x7FFF)
    //设置-旋转角度：


}
