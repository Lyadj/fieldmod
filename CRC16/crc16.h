#ifndef CRC16_H
#define CRC16_H

#include <stdint.h>
#include <cstring>

const uint16_t CRC16_MODBUS_POLY = 0xA001; // CRC-16多项式
const uint16_t CRC16_MODBUS_INIT_VALUE = 0xFFFF; // 初始CRC值
const uint16_t CRC16_MODBUS_XOR = 0x0001; // 初始CRC值

namespace CRC {

    class CRC16
    {
    public:
        CRC16();

        static uint16_t CRC16_Modbus(uint8_t* pData,uint16_t usDataLen);

    };

}


#endif // CRC16_H
