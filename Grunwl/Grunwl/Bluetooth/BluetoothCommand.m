//
//  BluetoothCommand.m
//  Grunwl
//
//  Created by mojingyu on 16/1/31.
//  Copyright © 2016年 Mojy. All rights reserved.
//

#import "BluetoothCommand.h"
#import "NSData+CRC.h"

@implementation BluetoothCommand

// 按位异或处理
+ (Byte)getVerify:(Byte *)sendData datalength:(int)length
{
    Byte verify = sendData[0];
    
    for (int i = 1; i < length; i++) {
        verify ^= sendData[i];
    }
    
    return verify;
}

+ (Byte *)getCurTime
{
    NSDate *  senddate=[NSDate date];
    NSDateFormatter  *dateformatter=[[NSDateFormatter alloc] init];
    [dateformatter setDateFormat:@"YYMMdd"];
    NSString *time=[dateformatter stringFromDate:senddate];
    
    NSData *bytes = [time dataUsingEncoding:NSUTF8StringEncoding];
    Byte *udidByte = (Byte *)[bytes bytes];
    return udidByte;
}

//+ (Byte *)converStringToByte:(int)value
//{
//    [ITTCustomAlertView showMessage:[NSString stringWithFormat:@"value : %d", value]];
//    
////    NSString *hexStr = [NSString stringWithFormat:@"%x", [str intValue]];
////    NSData *data = [hexStr dataUsingEncoding:NSUTF8StringEncoding];
//    Byte byteData[2] = {0};
//    byteData[0] = (value >> 8) & 0xff;
//    byteData[1] = value & 0xff;
////    [data getBytes:&byteData length:2];
//    
////    Byte *p = byteData;
//    return (Byte *)byteData;
//}

+ (NSData *)getSendCRCDataWithBytes:(Byte *)buffer length:(NSUInteger)length
{
    NSMutableData *sendData = [[NSMutableData alloc] initWithBytes:buffer length:length];
    int16_t checksum = [sendData crc16];
    int16_t swapped = CFSwapInt16LittleToHost(checksum);
    char *a = (char*) &swapped;
    [sendData appendBytes:a length:sizeof(int16_t)];
    return sendData;
}

+ (NSData *)powerOnCommand
{
    int pos = 0;
    Byte commandData[6] = {0};
    commandData[pos] = 0x11; pos++;
    commandData[pos] = 0x06; pos++;
    commandData[pos] = 0x00; pos++;
    commandData[pos] = 0x7c; pos++;
    commandData[pos] = 0x00; pos++;
    commandData[pos] = 0x01; pos++;
//    commandData[pos] = 0x8b; pos++;
//    commandData[pos] = 0x42; pos++;
    
    return [self getSendCRCDataWithBytes:commandData length:sizeof(commandData)];
    
    //检验
//    Byte *b1 = (Byte *)[sendData bytes];
//    NSLog(@"===============================================");
//    for (int i = 0; i < sendData.length; i++) {
//        NSLog(@"b1[%d] == %02x",i,b1[i]);
//    }
//    NSLog(@"b1:%@",[sendData base64EncodedStringWithOptions:0]);
//
//    return [[NSData alloc] initWithBytes:commandData length:8];
}
+ (NSData *)powerOffCommand
{
    int pos = 0;
    Byte commandData[8] = {0};
    commandData[pos] = 0x11; pos++;
    commandData[pos] = 0x06; pos++;
    commandData[pos] = 0x00; pos++;
    commandData[pos] = 0x7c; pos++;
    commandData[pos] = 0x00; pos++;
    commandData[pos] = 0x00; pos++;
    commandData[pos] = 0x4a; pos++;
    commandData[pos] = 0x82; pos++;
    
//    Byte verify = [self getVerify:commandData datalength:6];
//    commandData[pos] = verify;
    return [[NSData alloc] initWithBytes:commandData length:8];
}
+ (NSData *)plusDownCommand
{
    int pos = 0;
    Byte commandData[8] = {0};
    commandData[pos] = 0x11; pos++;
    commandData[pos] = 0x06; pos++;
    commandData[pos] = 0x10; pos++;
    commandData[pos] = 0x02; pos++;
    commandData[pos] = 0x01; pos++;
    commandData[pos] = 0x00; pos++;
    commandData[pos] = 0x2f; pos++;
    commandData[pos] = 0xca; pos++;
    
//    Byte verify = [self getVerify:commandData datalength:6];
//    commandData[pos] = verify;
    return [[NSData alloc] initWithBytes:commandData length:8];

}
+ (NSData *)plusUpCommand
{
    return [self plusDownCommand];
}
+ (NSData *)reduceDownCommand
{
    int pos = 0;
    Byte commandData[8] = {0};
    commandData[pos] = 0x11; pos++;
    commandData[pos] = 0x06; pos++;
    commandData[pos] = 0x10; pos++;
    commandData[pos] = 0x02; pos++;
    commandData[pos] = 0x02; pos++;
    commandData[pos] = 0x00; pos++;
    commandData[pos] = 0x2f; pos++;
    commandData[pos] = 0x3a; pos++;
    
//    Byte verify = [self getVerify:commandData datalength:6];
//    commandData[pos] = verify;
    return [[NSData alloc] initWithBytes:commandData length:8];
}
+ (NSData *)reduceUpCommand
{
    return [self reduceDownCommand];
}

+ (NSData *)readConfigCommand
{
    int pos = 0;
    Byte commandData[8] = {0};
    commandData[pos] = 0x11; pos++;
    commandData[pos] = 0x03; pos++;
    commandData[pos] = 0x27; pos++;
    commandData[pos] = 0x00; pos++;
    commandData[pos] = 0x00; pos++;
    commandData[pos] = 0x08; pos++;
    commandData[pos] = 0x4c; pos++;
    commandData[pos] = 0x28; pos++;
    
//    Byte verify = [self getVerify:commandData datalength:6];
//    commandData[pos] = verify;
    return [[NSData alloc] initWithBytes:commandData length:8];
}

+ (NSData *)setA1Command:(CGFloat)value
{
    value = value*10;

    int pos = 0;
    Byte commandData[6] = {0};
    commandData[pos] = 0x11; pos++;
    commandData[pos] = 0x06; pos++;
    commandData[pos] = 0x00; pos++;
    commandData[pos] = 0x0C; pos++;
    commandData[pos] = ((int)value >> 8) & 0xff; pos++;
    commandData[pos] = (int)value & 0xff; pos++;
    
    return [self getSendCRCDataWithBytes:commandData length:sizeof(commandData)];
}
+ (NSData *)setA2Command:(CGFloat)value
{
    value = value*10;
//    Byte *pValue = [self converStringToByte:(int)value];
    
    int pos = 0;
    Byte commandData[6] = {0};
    commandData[pos] = 0x11; pos++;
    commandData[pos] = 0x06; pos++;
    commandData[pos] = 0x00; pos++;
    commandData[pos] = 0x0D; pos++;
    commandData[pos] = ((int)value >> 8) & 0xff; pos++;
    commandData[pos] = (int)value & 0xff; pos++;
    
    return [self getSendCRCDataWithBytes:commandData length:sizeof(commandData)];
}
+ (NSData *)setA3Command:(CGFloat)value
{
    value = value*10;
//    Byte *pValue = [self converStringToByte:(int)value];
    
    int pos = 0;
    Byte commandData[6] = {0};
    commandData[pos] = 0x11; pos++;
    commandData[pos] = 0x06; pos++;
    commandData[pos] = 0x00; pos++;
    commandData[pos] = 0x1C; pos++;
    commandData[pos] = ((int)value >> 8) & 0xff; pos++;
    commandData[pos] = (int)value & 0xff; pos++;
    
    return [self getSendCRCDataWithBytes:commandData length:sizeof(commandData)];
}
+ (NSData *)setA4Command:(CGFloat)value
{
    value = value*10;
    
    int pos = 0;
    Byte commandData[6] = {0};
    commandData[pos] = 0x11; pos++;
    commandData[pos] = 0x06; pos++;
    commandData[pos] = 0x00; pos++;
    commandData[pos] = 0x15; pos++;
    commandData[pos] = ((int)value >> 8) & 0xff; pos++;
    commandData[pos] = (int)value & 0xff; pos++;
    
    return [self getSendCRCDataWithBytes:commandData length:sizeof(commandData)];

}

+ (NSData *)setA5Command:(CGFloat)value
{
    value = value*10;
//    Byte *pValue = [self converStringToByte:(int)value];
    
    int pos = 0;
    Byte commandData[6] = {0};
    commandData[pos] = 0x11; pos++;
    commandData[pos] = 0x06; pos++;
    commandData[pos] = 0x00; pos++;
    commandData[pos] = 0x19; pos++;
    commandData[pos] = ((int)value >> 8) & 0xff; pos++;
    commandData[pos] = (int)value & 0xff; pos++;
    
    return [self getSendCRCDataWithBytes:commandData length:sizeof(commandData)];

}
+ (NSData *)setA6Command:(CGFloat)value
{
//    Byte *pValue = [self converStringToByte:(int)value];
    
    int pos = 0;
    Byte commandData[6] = {0};
    commandData[pos] = 0x11; pos++;
    commandData[pos] = 0x06; pos++;
    commandData[pos] = 0x00; pos++;
    commandData[pos] = 0x2F; pos++;
    commandData[pos] = ((int)value >> 8) & 0xff; pos++;
    commandData[pos] = (int)value & 0xff; pos++;
    
    return [self getSendCRCDataWithBytes:commandData length:sizeof(commandData)];

}
+ (NSData *)setA7Command:(CGFloat)value
{
//    Byte *pValue = [self converStringToByte:(int)value];
    
    int pos = 0;
    Byte commandData[6] = {0};
    commandData[pos] = 0x11; pos++;
    commandData[pos] = 0x06; pos++;
    commandData[pos] = 0x00; pos++;
    commandData[pos] = 0x2C; pos++;
    commandData[pos] = ((int)value >> 8) & 0xff; pos++;
    commandData[pos] = (int)value & 0xff; pos++;
    
    return [self getSendCRCDataWithBytes:commandData length:sizeof(commandData)];
}
+ (NSData *)setA8Command:(CGFloat)value
{
    value = value*10;
//    Byte *pValue = [self converStringToByte:(int)value];
    
    int pos = 0;
    Byte commandData[6] = {0};
    commandData[pos] = 0x11; pos++;
    commandData[pos] = 0x06; pos++;
    commandData[pos] = 0x00; pos++;
    commandData[pos] = 0x2D; pos++;
    commandData[pos] = ((int)value >> 8) & 0xff; pos++;
    commandData[pos] = (int)value & 0xff; pos++;
    
    return [self getSendCRCDataWithBytes:commandData length:sizeof(commandData)];

}

+ (NSData *)setA9Command:(CGFloat)value
{
//    Byte *pValue = [self converStringToByte:(int)value];
    
    int pos = 0;
    Byte commandData[6] = {0};
    commandData[pos] = 0x11; pos++;
    commandData[pos] = 0x06; pos++;
    commandData[pos] = 0x00; pos++;
    commandData[pos] = 0x1E; pos++;
    commandData[pos] = ((int)value >> 8) & 0xff; pos++;
    commandData[pos] = (int)value & 0xff; pos++;
    
    return [self getSendCRCDataWithBytes:commandData length:sizeof(commandData)];
}

+ (NSData *)setA10Command:(CGFloat)value
{
//    value = [NSString stringWithFormat:@"%d", [value intValue]];
//    Byte *pValue = [self converStringToByte:(int)value];
    
    int pos = 0;
    Byte commandData[6] = {0};
    commandData[pos] = 0x11; pos++;
    commandData[pos] = 0x06; pos++;
    commandData[pos] = 0x00; pos++;
    commandData[pos] = 0x21; pos++;
    commandData[pos] = ((int)value >> 8) & 0xff; pos++;
    commandData[pos] = (int)value & 0xff; pos++;
    
    return [self getSendCRCDataWithBytes:commandData length:sizeof(commandData)];
}

+ (NSData *)setA11Command:(CGFloat)value
{
//    value = [NSString stringWithFormat:@"%d", [value intValue]];
//    Byte *pValue = [self converStringToByte:(int)value];
    
    int pos = 0;
    Byte commandData[6] = {0};
    commandData[pos] = 0x11; pos++;
    commandData[pos] = 0x06; pos++;
    commandData[pos] = 0x00; pos++;
    commandData[pos] = 0x23; pos++;
    commandData[pos] = ((int)value >> 8) & 0xff; pos++;
    commandData[pos] = (int)value & 0xff; pos++;
    
    return [self getSendCRCDataWithBytes:commandData length:sizeof(commandData)];
}

+ (NSData *)setA12Command:(CGFloat)value
{
    value = value*10;
//    Byte *pValue = [self converStringToByte:(int)value];
    
    int pos = 0;
    Byte commandData[6] = {0};
    commandData[pos] = 0x11; pos++;
    commandData[pos] = 0x06; pos++;
    commandData[pos] = 0x00; pos++;
    commandData[pos] = 0x0F; pos++;
    commandData[pos] = ((int)value >> 8) & 0xff; pos++;
    commandData[pos] = (int)value & 0xff; pos++;
    
    return [self getSendCRCDataWithBytes:commandData length:sizeof(commandData)];
}

+ (NSData *)debugStartCommand
{
    int pos = 0;
    Byte commandData[8] = {0};
    commandData[pos] = 0x11; pos++;
    commandData[pos] = 0x06; pos++;
    commandData[pos] = 0x00; pos++;
    commandData[pos] = 0x7c; pos++;
    commandData[pos] = 0x00; pos++;
    commandData[pos] = 0x02; pos++;
    commandData[pos] = 0xcb; pos++;
    commandData[pos] = 0x43; pos++;
 
    return [[NSData alloc] initWithBytes:commandData length:8];
}

+ (NSData *)debugStopCommand
{
    int pos = 0;
    Byte commandData[8] = {0};
    commandData[pos] = 0x11; pos++;
    commandData[pos] = 0x06; pos++;
    commandData[pos] = 0x00; pos++;
    commandData[pos] = 0x7c; pos++;
    commandData[pos] = 0x00; pos++;
    commandData[pos] = 0x00; pos++;
    commandData[pos] = 0x4a; pos++;
    commandData[pos] = 0x82; pos++;
    
    return [[NSData alloc] initWithBytes:commandData length:8];
}

+ (NSData *)debugPlusCommand:(NSInteger)tag
{
    int pos = 0;
    Byte commandData[8] = {0};
    commandData[pos] = 0x11; pos++;
    commandData[pos] = 0x06; pos++;
    
    if (tag == 0) {
        //left
        commandData[pos] = 0x10; pos++;
        commandData[pos] = 0x02; pos++;
        commandData[pos] = 0x01; pos++;
        commandData[pos] = 0x00; pos++;
        commandData[pos] = 0x2f; pos++;
        commandData[pos] = 0xca; pos++;
    } else {
        //right
        commandData[pos] = 0x10; pos++;
        commandData[pos] = 0x03; pos++;
        commandData[pos] = 0x00; pos++;
        commandData[pos] = 0x01; pos++;
        commandData[pos] = 0xbe; pos++;
        commandData[pos] = 0x5a; pos++;
    }
    
    
    return [[NSData alloc] initWithBytes:commandData length:8];
}

+ (NSData *)debugReduceCommand:(NSInteger)tag
{
    int pos = 0;
    Byte commandData[8] = {0};
    commandData[pos] = 0x11; pos++;
    commandData[pos] = 0x06; pos++;
    
    if (tag == 0) {
        commandData[pos] = 0x10; pos++;
        commandData[pos] = 0x02; pos++;
        commandData[pos] = 0x02; pos++;
        commandData[pos] = 0x00; pos++;
        commandData[pos] = 0x2f; pos++;
        commandData[pos] = 0x3a; pos++;
    } else {
        commandData[pos] = 0x10; pos++;
        commandData[pos] = 0x03; pos++;
        commandData[pos] = 0x00; pos++;
        commandData[pos] = 0x02; pos++;
        commandData[pos] = 0xfe; pos++;
        commandData[pos] = 0x5b; pos++;
    }
    
    
    return [[NSData alloc] initWithBytes:commandData length:8];
}

+ (NSData *)exitCommand
{
    int pos = 0;
    Byte commandData[8] = {0};
    commandData[pos] = 0x11; pos++;
    commandData[pos] = 0x06; pos++;
    commandData[pos] = 0x10; pos++;
    commandData[pos] = 0x03; pos++;
    commandData[pos] = 0x00; pos++;
    commandData[pos] = 0x05; pos++;
    commandData[pos] = 0xbf; pos++;
    commandData[pos] = 0x99; pos++;
    
    return [[NSData alloc] initWithBytes:commandData length:8];
}

+ (NSData *)readSerialNubmerCommand
{
    int pos = 0;
    Byte commandData[8] = {0};
    commandData[pos] = 0x11; pos++;
    commandData[pos] = 0x03; pos++;
    commandData[pos] = 0x27; pos++;
    commandData[pos] = 0x01; pos++;
    commandData[pos] = 0x00; pos++;
    commandData[pos] = 0x07; pos++;
    commandData[pos] = 0x5d; pos++;
    commandData[pos] = 0xec; pos++;
    
    return [[NSData alloc] initWithBytes:commandData length:8];
}

+ (NSData *)activeCommand
{
    int pos = 0;
    Byte commandData[6] = {0};
    commandData[pos] = 0x11; pos++;
    commandData[pos] = 0x06; pos++;
    commandData[pos] = 0x10; pos++;
    commandData[pos] = 0x07; pos++;
    
    //time
    NSDate *  senddate=[NSDate date];
    NSDateFormatter  *dateformatter=[[NSDateFormatter alloc] init];
    [dateformatter setDateFormat:@"YYMMdd"];
    NSString *time=[dateformatter stringFromDate:senddate];
    
    int iYear = [[time substringToIndex:2] intValue] << 9;
    int iMonth = [[time substringWithRange:NSMakeRange(2, 2)] intValue] << 5;
    int iDay = [[time substringWithRange:NSMakeRange(4, 2)] intValue];
    
    long lTime = iYear + iMonth + iDay;
    MyLog(@"\n======== lTime : %ld", lTime);
    
    commandData[pos] = (lTime >> 8) ; pos++;
    commandData[pos] = lTime; pos++;
    
    return [self getSendCRCDataWithBytes:commandData length:sizeof(commandData)];
}

+ (NSData *)runMultiPumpCommand
{
    int pos = 0;
    Byte commandData[8] = {0};
    commandData[pos] = 0x11; pos++;
    commandData[pos] = 0x06; pos++;
    commandData[pos] = 0x00; pos++;
    commandData[pos] = 0x7c; pos++;
    commandData[pos] = 0x00; pos++;
    commandData[pos] = 0x01; pos++;
    commandData[pos] = 0x8b; pos++;
    commandData[pos] = 0x42; pos++;
    
    return [[NSData alloc] initWithBytes:commandData length:8];
}
+ (NSData *)stopMultiPumpCommand
{
    int pos = 0;
    Byte commandData[8] = {0};
    commandData[pos] = 0x11; pos++;
    commandData[pos] = 0x06; pos++;
    commandData[pos] = 0x00; pos++;
    commandData[pos] = 0x7c; pos++;
    commandData[pos] = 0x00; pos++;
    commandData[pos] = 0x00; pos++;
    commandData[pos] = 0x4a; pos++;
    commandData[pos] = 0x82; pos++;
    
    return [[NSData alloc] initWithBytes:commandData length:8];
}
+ (NSData *)plusMultiPumpCommand
{
    int pos = 0;
    Byte commandData[8] = {0};
    commandData[pos] = 0x11; pos++;
    commandData[pos] = 0x06; pos++;
    commandData[pos] = 0x10; pos++;
    commandData[pos] = 0x02; pos++;
    commandData[pos] = 0x01; pos++;
    commandData[pos] = 0x00; pos++;
    commandData[pos] = 0x2f; pos++;
    commandData[pos] = 0xca; pos++;
    
    return [[NSData alloc] initWithBytes:commandData length:8];
}

+ (NSData *)reduceMultiPumpCommand
{
    int pos = 0;
    Byte commandData[8] = {0};
    commandData[pos] = 0x11; pos++;
    commandData[pos] = 0x06; pos++;
    commandData[pos] = 0x10; pos++;
    commandData[pos] = 0x02; pos++;
    commandData[pos] = 0x02; pos++;
    commandData[pos] = 0x00; pos++;
    commandData[pos] = 0x2f; pos++;
    commandData[pos] = 0x3a; pos++;
    
    return [[NSData alloc] initWithBytes:commandData length:8];
}

+ (NSData *)hiddenCommand
{
    int pos = 0;
    Byte commandData[8] = {0};
    commandData[pos] = 0x11; pos++;
    commandData[pos] = 0x03; pos++;
    commandData[pos] = 0x27; pos++;
    commandData[pos] = 0x01; pos++;
    commandData[pos] = 0x00; pos++;
    commandData[pos] = 0x08; pos++;
    commandData[pos] = 0x1d; pos++;
    commandData[pos] = 0xe8; pos++;
    
    return [[NSData alloc] initWithBytes:commandData length:8];
}

+ (NSData *)leaveMultiPumpCommand
{
    int pos = 0;
    Byte commandData[8] = {0};
    commandData[pos] = 0x11; pos++;
    commandData[pos] = 0x03; pos++;
    commandData[pos] = 0x27; pos++;
    commandData[pos] = 0x01; pos++;
    commandData[pos] = 0x00; pos++;
    commandData[pos] = 0x09; pos++;
    commandData[pos] = 0xdc; pos++;
    commandData[pos] = 0x28; pos++;
    
    return [[NSData alloc] initWithBytes:commandData length:8];
}

+ (NSData *)inMultiPumpCommand
{
    int pos = 0;
    Byte commandData[8] = {0};
    commandData[pos] = 0x11; pos++;
    commandData[pos] = 0x03; pos++;
    commandData[pos] = 0x27; pos++;
    commandData[pos] = 0x01; pos++;
    commandData[pos] = 0x00; pos++;
    commandData[pos] = 0x08; pos++;
    commandData[pos] = 0x1d; pos++;
    commandData[pos] = 0xe8; pos++;
    
    return [[NSData alloc] initWithBytes:commandData length:8];
}

+ (NSData *)verifyPasswordCommand:(CGFloat)password
{
    int pos = 0;
    Byte commandData[6] = {0};
    commandData[pos] = 0x11; pos++;
    commandData[pos] = 0x03; pos++;
    commandData[pos] = 0x27; pos++;
    commandData[pos] = 0x05; pos++;
    
    commandData[pos] = (int)password >> 8 ; pos++;
    commandData[pos] = password; pos++;
    
    return [self getSendCRCDataWithBytes:commandData length:sizeof(commandData)];
}

+ (NSData *)changPasswordCommand:(CGFloat)newPassword
{
    int pos = 0;
    Byte commandData[6] = {0};
    commandData[pos] = 0x11; pos++;
    commandData[pos] = 0x03; pos++;
    commandData[pos] = 0x27; pos++;
    commandData[pos] = 0x07; pos++;
    
    commandData[pos] = (int)newPassword >> 8 ; pos++;
    commandData[pos] = newPassword; pos++;
    
    return [self getSendCRCDataWithBytes:commandData length:sizeof(commandData)];
}

@end
