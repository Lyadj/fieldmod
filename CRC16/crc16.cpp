#include "crc16.h"


namespace CRC {

    CRC16::CRC16()
    {

    }

    uint16_t CRC16::CRC16_Modbus(uint8_t *pData, uint16_t usDataLen)
    {

        unsigned int crc = 0xFFFF;
        for (int pos = 0; pos < usDataLen; pos++)
        {
        crc ^= (unsigned int)pData[pos];

        for (int i = 8; i != 0; i--) {
          if ((crc & CRC16_MODBUS_XOR) != 0) {
            crc >>= 1;
            crc ^= CRC16_MODBUS_POLY;
          }
          else
            crc >>= 1;
          }
        }

        uint8_t high_byte = crc & 0xFF;
        uint8_t low_byte = (crc>>8) & 0xFF;
        uint16_t becrc = uint16_t(high_byte << 8) | low_byte;

        return becrc;
    }



}


