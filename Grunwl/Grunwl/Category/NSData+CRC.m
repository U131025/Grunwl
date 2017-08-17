//
//  NSData+CRC.m
//  Grunwl
//
//  Created by mojingyu on 16/2/20.
//  Copyright © 2016年 Mojy. All rights reserved.
//

#import "NSData+CRC.h"

@implementation NSData (CRC)

-(int32_t)crc32
{
    uint32_t *table = malloc(sizeof(uint32_t) * 256);
    uint32_t crc = 0xffffffff;
    uint8_t *bytes = (uint8_t *)[self bytes];
    
    for (uint32_t i=0; i<256; i++) {
        table[i] = i;
        for (int j=0; j<8; j++) {
            if (table[i] & 1) {
                table[i] = (table[i] >>= 1) ^ 0xedb88320;
            } else {
                table[i] >>= 1;
            }
        }
    }
    
    for (int i=0; i<self.length; i++) {
        crc = (crc >> 8) ^ table[(crc & 0xff) ^ bytes[i]];
    }
    crc ^= 0xffffffff;
    
    free(table);
    return crc;
}

// --------------------------------------------------------------
//      CRC16计算方法2:使用简单的校验表
// --------------------------------------------------------------
const int16_t wCRCTalbeAbs[] =
{
    0x0000, 0xCC01, 0xD801, 0x1400, 0xF001, 0x3C00, 0x2800, 0xE401, 0xA001, 0x6C00, 0x7800, 0xB401, 0x5000, 0x9C01, 0x8801, 0x4400,
};

- (int16_t)crc16
{
    uint8_t *pchMsg = (uint8_t *)[self bytes];
    uint16_t wDataLen = self.length;
    
    uint16_t wCRC = 0xFFFF;
    uint16_t i;
    Byte chChar;
    
    for (i = 0; i < wDataLen; i++)
    {
        chChar = *pchMsg++;
        wCRC = wCRCTalbeAbs[(chChar ^ wCRC) & 15] ^ (wCRC >> 4);
        wCRC = wCRCTalbeAbs[((chChar >> 4) ^ wCRC) & 15] ^ (wCRC >> 4);
    }
    
    return wCRC;
}

@end
