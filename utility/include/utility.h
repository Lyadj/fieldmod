#ifndef XYUTILITY
#define XYUTILITY

#include<stdint.h>
#include<math.h>
#include<string>
#include <algorithm>
#include <cstdint>
#include <cstring>
#include <memory>
#include <QSerialPort>
#include <QSerialPortInfo>
#include <QTimer>
#include <QObject>
#include <QDebug>
#include <QModbusClient>
#include <QModbusServer>
#include <QModbusDevice>
#include <QModbusDataUnit>
#include <QModbusRtuSerialMaster>
#include "CRC16/crc16.h"
#include <deque>
#include <queue>

namespace XYUtility {

    //串口-连接参数的结构体
    struct stModbusRTUCommunicationParam{
        uint32_t unBaudrate=0; //波特率
        uint8_t ucDatabit=0;  //数据位
        uint8_t ucStopbit=0;  //停止位
        QSerialPort::Parity eParity; //检验
        QSerialPort::FlowControl eFlowcontrol; //流控
    };

}



#endif
