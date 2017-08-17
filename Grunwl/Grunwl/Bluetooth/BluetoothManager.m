//
//  BluetoothManager.m
//  Grunwl
//
//  Created by mojingyu on 16/1/31.
//  Copyright © 2016年 Mojy. All rights reserved.
//

#import "BluetoothManager.h"
#import "BluetoothCommand.h"
#import "ITTCustomAlertView.h"
#import "NotifyDefine.h"
#import "UUIDDefine.h"

@interface BluetoothManager()<BluetoothLibaryDelegate>

@property (nonatomic, strong) BluetoothLibary *bluetoothClient;
@property (nonatomic, strong) NSData *resultData;

@property (nonatomic, copy) void (^onScanDeviceFinishBlock)();
@property (nonatomic, copy) void (^onGetDataBlock)(NSData *getData);

@end

@implementation BluetoothManager

//实现单例
SYNTHESIZE_SINGLETONE_FOR_CLASS(BluetoothManager);

- (void)loadData
{
    
}

- (NSMutableArray *)deviceArray
{
//    if (!_deviceArray) {
//        _deviceArray = [[NSMutableArray alloc] init];
//    }
//    return _deviceArray;
    
    if (_bluetoothClient)
        return _bluetoothClient.devices;
    
    return nil;
}

#pragma mark 蓝牙控制管理
- (BluetoothLibary *)bluetoothClient
{
    if (!_bluetoothClient) {
        _bluetoothClient = [[BluetoothLibary alloc] init];
        _bluetoothClient.delegate = self;
    }
    return _bluetoothClient;
}

- (CBPeripheral *)peripheral
{
    if (!_bluetoothClient) return nil;
    
    return _bluetoothClient.peripheral;
}

- (BOOL)startScanBluetoothDevice
{
    BOOL retCode = [self.bluetoothClient startScanWithReset:YES withTimeOut:5.0 withTimeOutBlock:^{
        //通知超时
        [[NSNotificationCenter defaultCenter] postNotificationName:Notify_ScanTimeOut object:nil];
    }];
    
    return retCode;
}

- (void)scanDevice
{
    if (self.peripheral && self.peripheral.state == CBPeripheralStateConnected) {
        return;
    }
    
    //未连接则重新扫描
    [self.bluetoothClient scanWithDeviceName:TRANSFER_DEVICE_NAME withConnectBlock:^{
        //connected
        MyLog(@"Connetct Device :%@", self.peripheral);
    }];
    
//    self.bluetoothClient.isAutoConnect = YES;
//    if (![self.bluetoothClient startScanWithReset:YES withTimeOut:0 withTimeOutBlock:nil]) {
////        [ITTCustomAlertView showMessage:@"请打开蓝牙"];
//    }
}

- (void)scanDevice:(void (^)(NSArray *deviceArray))onFinishedBlock
{
    [self.deviceArray removeAllObjects];
    [self.bluetoothClient scanDeciveOnFindBlock:onFinishedBlock];
}

// 连接设备
- (void)connectPeripheral:(CBPeripheral *)peripheral onConnectedBlock:(void (^)())onConnectedBlock
{
    [self.bluetoothClient connectPeripheral:peripheral onConnectedBlock:onConnectedBlock];
}

- (void)stopScanDevice
{
    [self.bluetoothClient stopScan];
}

//- (void)scanDevice:(void (^)())onFinishedBlock
//{
//    if (self.peripheral && self.peripheral.state == CBPeripheralStateConnected) {
//        if (onFinishedBlock)
//            onFinishedBlock();
//        return;
//    }
//    
//    //scan
//    _onScanDeviceFinishBlock = onFinishedBlock;
//    if (![self.bluetoothClient startScanWithReset:YES withTimeOut:0 withTimeOutBlock:nil]) {
//        //        [ITTCustomAlertView showMessage:@"请打开蓝牙"];
//    }
//}

- (void)sendData:(NSData *)sendData
{
    NSLog(@"send data: %@", sendData);
    if (self.peripheral && self.peripheral.state == CBPeripheralStateConnected) {
        [self.bluetoothClient sendDataToPeripheral:sendData];
    } else {
        [ITTCustomAlertView showMessage:[APPDELEGATE.TextDictionary objectForKey:@"Device not connected"]];
    }
    
}

#pragma mark BluetoothDelegate
- (void)updateValueForPeripheral:(NSData *)data
{
    if (self.onGetDataBlock)
        self.onGetDataBlock(data);
    
    // 接收数据并进行解析
    Byte value[50] = {0};
    [data getBytes:&value length:sizeof(value)];
    
    [self parseMonitorData:value];
    [self parseConfigData:value];
    [self parseSerialNumberData:value];
    [self parseMultiPumpATypeData:value];
    [self parseMultiPumpBTypeData:value];
    [self parseVerifyData:value];
}

- (void)didDiscoverPeripheral:(CBPeripheral *)peripheral
{    
    //对设备名进行过滤
    NSString *deviceName = peripheral.name;
    if (!deviceName) return;
    deviceName = [deviceName uppercaseString];
   
#ifndef TestOtherDevice
    if ([deviceName containsString:@"GRUNWL"]) {
#endif
//        [self.deviceArray addObject:peripheral];
        
        //将设备添加到列表中
        [[NSNotificationCenter defaultCenter] postNotificationName:Notify_DiscoverDevice object:nil];
        
        if (_onScanDeviceFinishBlock)
            _onScanDeviceFinishBlock();
        
#ifndef TestOtherDevice
    }
#endif
}

- (void)didDisconnectPeripheral
{
    NSLog(@"didDisconnectPeripheral");
    
    //通知连接断开
    [[NSNotificationCenter defaultCenter] postNotificationName:Notify_Disconnect object:nil];
}

- (void)connetctSuccess:(CBPeripheral *)peripheral
{
    //连接成功消息
    
    //将设备添加到列表中
//    [[NSNotificationCenter defaultCenter] postNotificationName:Notify_DiscoverDevice object:nil];
}

#pragma mark -解析数据

- (double)getValueWithHighValue:(Byte)high withLowValue:(Byte)low
{
    int highValue = (high << 8) & 0xff00;
    int lowValue = low;
    double dValue = (double)(highValue + lowValue);
    return dValue;
}

- (void)parseSerialNumberData:(Byte *)value
{
    int pos = 0;
    NSMutableDictionary *dictionary = [[NSMutableDictionary alloc] init];

    // 数据头
    if (value[0] != 0x11 || value[1] != 0x99) return;
    pos += 2;
    
    //A
    int a = value[pos]; pos++;
    [dictionary setObject:[NSString stringWithFormat:@"%02d", a] forKey:@"A"];
    
    //B
    int b = value[pos]; pos++;
    [dictionary setObject:[NSString stringWithFormat:@"%02d", b] forKey:@"B"];
    
    //C
    int c = value[pos]; pos++;
    [dictionary setObject:[NSString stringWithFormat:@"%02d", (int)c] forKey:@"C"];
    
    //D
    int d = value[pos]; pos++;
    [dictionary setObject:[NSString stringWithFormat:@"%d", d] forKey:@"D"];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:Notify_SerialNumber object:nil userInfo:dictionary];
}

//解析参数读取
- (void)parseConfigData:(Byte *)value
{
//    Byte value[50] = {0};
//    [data getBytes:&value length:sizeof(value)];
    
    int pos = 0;
    // 数据头
    if (value[0] != 0x33 || value[1] != 0x55 || value[2] != 0x11) return;
    pos += 3;
    
    NSMutableDictionary *monitorDataDictionary = [[NSMutableDictionary alloc] init];
    
    //a1
    CGFloat a1 = [self getValueWithHighValue:value[pos] withLowValue:value[pos+1]] / 10.0;
    [monitorDataDictionary setObject:[NSString stringWithFormat:@"%.1f", a1] forKey:@"A1"];
    pos += 2;
    
    //a2
//    CGFloat a2 = [self getValueWithHighValue:value[pos] withLowValue:value[pos+1]] / 10.0;
//    [monitorDataDictionary setObject:[NSString stringWithFormat:@"%.1f", a2] forKey:@"A2"];
//    pos += 2;
    
    //A3
    CGFloat a3 = [self getValueWithHighValue:value[pos] withLowValue:value[pos+1]] / 10.0;
    [monitorDataDictionary setObject:[NSString stringWithFormat:@"%.1f", a3] forKey:@"A3"];
    pos += 2;
    
    //A4
    CGFloat a4 = value[pos] / 10.0;
    [monitorDataDictionary setObject:[NSString stringWithFormat:@"%.1f", a4] forKey:@"A4"];
    pos += 1;
    
    //A5
//    CGFloat a5 = [self getValueWithHighValue:value[pos] withLowValue:value[pos+1]] / 10.0;
//    [monitorDataDictionary setObject:[NSString stringWithFormat:@"%.1f", a5] forKey:@"A5"];
//    pos += 2;
    
    //A6
    [monitorDataDictionary setObject:[NSString stringWithFormat:@"%d", (int)value[pos]] forKey:@"A6"];
    pos += 1;
    
    //A7
    CGFloat a7 = [self getValueWithHighValue:value[pos] withLowValue:value[pos+1]];
    [monitorDataDictionary setObject:[NSString stringWithFormat:@"%d", (int)a7] forKey:@"A7"];
    pos += 2;
    
    //A8
    CGFloat a8 = [self getValueWithHighValue:value[pos] withLowValue:value[pos+1]] / 10.0;
    [monitorDataDictionary setObject:[NSString stringWithFormat:@"%.1f", a8] forKey:@"A8"];
    pos += 2;
    
    //a9
    CGFloat a9 = [self getValueWithHighValue:value[pos] withLowValue:value[pos+1]];
    [monitorDataDictionary setObject:[NSString stringWithFormat:@"%d", (int)a9] forKey:@"A9"];
    pos += 2;
    
    //A10
    CGFloat a10 = value[pos];
    [monitorDataDictionary setObject:[NSString stringWithFormat:@"%d", (int)a10] forKey:@"A10"];
    pos += 1;
    
    //A11
    CGFloat a11 = value[pos];
    [monitorDataDictionary setObject:[NSString stringWithFormat:@"%d", (int)a11] forKey:@"A11"];
    pos += 1;
    
    //A12
    CGFloat a12 = [self getValueWithHighValue:value[pos] withLowValue:value[pos+1]] / 10.0;
    [monitorDataDictionary setObject:[NSString stringWithFormat:@"%.1f", a12] forKey:@"A12"];
//    pos += 2;
    
    [[NSNotificationCenter defaultCenter] postNotificationName:Notify_Recive_SettingData object:nil userInfo:monitorDataDictionary];
}

//解析接收到的数据
- (void)parseMonitorData:(Byte *)value
{
//    Byte value[50] = {0};
//    [data getBytes:&value length:sizeof(value)];
    
    int pos = 0;
    // 数据头
    if (value[0] != 0x10 || value[1] != 0x08) return;
    pos += 2;
    
    NSMutableDictionary *monitorDataDictionary = [[NSMutableDictionary alloc] init];
    
    //D1
    CGFloat d1 = [self getValueWithHighValue:value[pos] withLowValue:value[pos+1]] / 10;
    [monitorDataDictionary setObject:[NSString stringWithFormat:@"%.1f", d1] forKey:@"D1"];
    pos += 2;
    
    //D2
    CGFloat d2 = [self getValueWithHighValue:value[pos] withLowValue:value[pos+1]] / 10;
    [monitorDataDictionary setObject:[NSString stringWithFormat:@"%.1f", d2] forKey:@"D2"];
    pos += 2;
    
    //D3
    [monitorDataDictionary setObject:[NSString stringWithFormat:@"%d", (int)[self getValueWithHighValue:value[pos] withLowValue:value[pos+1]]] forKey:@"D3"];
    pos += 2;
    
    //D4
    CGFloat d4 = [self getValueWithHighValue:value[pos] withLowValue:value[pos+1]] / 10;
    [monitorDataDictionary setObject:[NSString stringWithFormat:@"%.1f", d4] forKey:@"D4"];
    pos += 2;
    
    //D5
    CGFloat d5 = [self getValueWithHighValue:value[pos] withLowValue:value[pos+1]] / 10.0;
    [monitorDataDictionary setObject:[NSString stringWithFormat:@"%.1f", d5] forKey:@"D5"];
    pos += 2;
    
    //D6
    [monitorDataDictionary setObject:[NSString stringWithFormat:@"%d", (int)[self getValueWithHighValue:value[pos] withLowValue:value[pos+1]]] forKey:@"D6"];
    pos += 2;
    
    //D7
    CGFloat d7 = [self getValueWithHighValue:value[pos] withLowValue:value[pos+1]] / 10.0;
    [monitorDataDictionary setObject:[NSString stringWithFormat:@"%.1f", d7] forKey:@"D7"];
    pos += 2;
    
    //D8
    CGFloat d8 = [self getValueWithHighValue:value[pos] withLowValue:value[pos+1]] / 10.0;
    [monitorDataDictionary setObject:[NSString stringWithFormat:@"%.1f", d8] forKey:@"D8"];
    pos += 2;
    
    //D9
    CGFloat d9 = value[pos];
    [monitorDataDictionary setObject:[NSString stringWithFormat:@"%.0f", d9] forKey:@"D9"];
    pos += 1;
    
    //crc
    [monitorDataDictionary setObject:[NSString stringWithFormat:@"%d", (int)[self getValueWithHighValue:value[pos] withLowValue:value[pos+1]]] forKey:@"crc"];
//    pos += 2;
    
    [[NSNotificationCenter defaultCenter] postNotificationName:Notify_Update_MonitorData object:nil userInfo:monitorDataDictionary];
}

//解析多泵数据 A类型
- (void)parseMultiPumpATypeData:(Byte *)value
{
    int pos = 0;
    // 数据头
    if (value[0] != 0x13 || value[1] != 0x55) return;
    pos += 2;
    
    NSMutableDictionary *userDataDictionary = [[NSMutableDictionary alloc] init];
    
    //A1
    CGFloat a1 = [self getValueWithHighValue:value[pos] withLowValue:value[pos+1]]/10;
    [userDataDictionary setObject:[NSString stringWithFormat:@"%.1f", a1] forKey:@"A1"];
    pos += 2;
    
    //A2
    CGFloat a2 = [self getValueWithHighValue:value[pos] withLowValue:value[pos+1]]/10;
    [userDataDictionary setObject:[NSString stringWithFormat:@"%.1f", a2] forKey:@"A2"];
    pos += 2;
    
    //A3
    CGFloat a3 = [self getValueWithHighValue:value[pos] withLowValue:value[pos+1]]/10;
    [userDataDictionary setObject:[NSString stringWithFormat:@"%.1f", a3] forKey:@"A3"];
    pos += 2;
    
    //A4
    CGFloat a4 = [self getValueWithHighValue:value[pos] withLowValue:value[pos+1]]/10;
    [userDataDictionary setObject:[NSString stringWithFormat:@"%.1f", a4] forKey:@"A4"];
    pos += 2;
    
    //A5
    CGFloat a5 = [self getValueWithHighValue:value[pos] withLowValue:value[pos+1]]/10;
    [userDataDictionary setObject:[NSString stringWithFormat:@"%.1f", a5] forKey:@"A5"];
    pos += 2;
    
    //A6
    CGFloat a6 = [self getValueWithHighValue:value[pos] withLowValue:value[pos+1]]/10;
    [userDataDictionary setObject:[NSString stringWithFormat:@"%.1f", a6] forKey:@"A6"];
    pos += 2;
    
    //C1
    CGFloat c1 = [self getValueWithHighValue:value[pos] withLowValue:value[pos+1]] / 10;
    [userDataDictionary setObject:[NSString stringWithFormat:@"%.1f", c1] forKey:@"C1"];
    pos += 2;
    
    //C2
    CGFloat c2 = [self getValueWithHighValue:value[pos] withLowValue:value[pos+1]] / 10;
    [userDataDictionary setObject:[NSString stringWithFormat:@"%.1f", c2] forKey:@"C2"];
//    pos += 2;    

    [[NSNotificationCenter defaultCenter] postNotificationName:Notify_MultiPumpValues_AType object:nil userInfo:userDataDictionary];
}

//解析多泵数据 B类型
- (void)parseMultiPumpBTypeData:(Byte *)value
{
    int pos = 0;
    // 数据头
    if (value[0] != 0x13 || value[1] != 0x77) return;
    pos += 2;
    
    NSMutableDictionary *userDataDictionary = [[NSMutableDictionary alloc] init];
    
    //b1
    CGFloat b1 = [self getValueWithHighValue:value[pos] withLowValue:value[pos+1]]/10;
    [userDataDictionary setObject:[NSString stringWithFormat:@"%.1f", b1] forKey:@"B1"];
    pos += 2;
    
    //b2
    CGFloat b2 = [self getValueWithHighValue:value[pos] withLowValue:value[pos+1]]/10;
    [userDataDictionary setObject:[NSString stringWithFormat:@"%.1f", b2] forKey:@"B2"];
    pos += 2;
    
    //b3
    CGFloat b3 = [self getValueWithHighValue:value[pos] withLowValue:value[pos+1]]/10;
    [userDataDictionary setObject:[NSString stringWithFormat:@"%.1f", b3] forKey:@"B3"];
    pos += 2;
    
    //b4
    CGFloat b4 = [self getValueWithHighValue:value[pos] withLowValue:value[pos+1]]/10;
    [userDataDictionary setObject:[NSString stringWithFormat:@"%.1f", b4] forKey:@"B4"];
    pos += 2;
    
    //b5
    CGFloat b5 = [self getValueWithHighValue:value[pos] withLowValue:value[pos+1]]/10;
    [userDataDictionary setObject:[NSString stringWithFormat:@"%.1f", b5] forKey:@"B5"];
    pos += 2;
    
    //b6
    CGFloat b6 = [self getValueWithHighValue:value[pos] withLowValue:value[pos+1]]/10;
    [userDataDictionary setObject:[NSString stringWithFormat:@"%.1f", b6] forKey:@"B6"];
    pos += 2;
    
    //C3
    CGFloat c3_s = value[pos];
    [userDataDictionary setObject:[NSString stringWithFormat:@"%.0f", c3_s] forKey:@"C3"];
    
//    CGFloat c3 = [self getValueWithHighValue:value[pos] withLowValue:value[pos+1]];
//    [userDataDictionary setObject:[NSString stringWithFormat:@"%.0f", c3] forKey:@"C3"];
    pos += 1;
    
    //C4
    CGFloat c4 = value[pos];
    [userDataDictionary setObject:[NSString stringWithFormat:@"%.0f", c4] forKey:@"C4"];
        
    [[NSNotificationCenter defaultCenter] postNotificationName:Notify_MultiPumpValues_BType object:nil userInfo:userDataDictionary];
}

- (void)parseVerifyData:(Byte *)value
{
    if (value[0] == 0x99 && value[1] == 0x11 && value[2] == 0x33 && value[3] == 0x55) {
        
        [[NSNotificationCenter defaultCenter] postNotificationName:Notify_Verify_Device object:nil userInfo:nil];
    }
}

#pragma mark 发送数据
- (void)sendDataWithCommandType:(CommandType)type
{
    [self sendDataWithCommandType:type withValue:0];
}

- (void)sendDataWithCommandType:(CommandType)type getBlock:(void (^)(NSData *))onGetBlock
{
    self.onGetDataBlock = onGetBlock;
    [self sendDataWithCommandType:type withValue:0];
}

- (void)sendDataWithCommandType:(CommandType)type withValue:(CGFloat)value getBlock:(void (^)(NSData *))onGetBlock
{
    self.onGetDataBlock = onGetBlock;
    [self sendDataWithCommandType:type withValue:value];
}

- (NSData *)sendDataWithCommandType:(CommandType)type withValue:(CGFloat)value
{
    
//    MyLog(@"==== value: %@ ========", value);
    NSData *sendData;
    switch (type) {
        case Command_PowerOn:
            sendData = [BluetoothCommand powerOnCommand];
            break;
        case Command_PowerOff:
            sendData = [BluetoothCommand powerOffCommand];
            break;
        case Command_PlusUp:
            sendData = [BluetoothCommand plusUpCommand];
            break;
        case Command_PlusDown:
            sendData = [BluetoothCommand plusDownCommand];
            break;
        case Command_ReduceUp:
            sendData = [BluetoothCommand reduceUpCommand];
            break;
        case Command_ReduceDown:
            sendData = [BluetoothCommand reduceDownCommand];
            break;
        case Command_ReadConfig:
            sendData = [BluetoothCommand readConfigCommand];
            break;
        case Command_SetA1:
            sendData = [BluetoothCommand setA1Command:value];
            break;
        case Command_SetA2:
            sendData = [BluetoothCommand setA2Command:value];
            break;
        case Command_SetA3:
            sendData = [BluetoothCommand setA3Command:value];
            break;
        case Command_SetA4:
            sendData = [BluetoothCommand setA4Command:value];
            break;
        case Command_SetA5:
            sendData = [BluetoothCommand setA5Command:value];
            break;
        case Command_SetA6:
            sendData = [BluetoothCommand setA6Command:value];
            break;
        case Command_SetA7:
            sendData = [BluetoothCommand setA7Command:value];
            break;
        case Command_SetA8:
            sendData = [BluetoothCommand setA8Command:value];
            break;
        case Command_SetA9:
            sendData = [BluetoothCommand setA9Command:value];
            break;
        case Command_SetA10:
            sendData = [BluetoothCommand setA10Command:value];
            break;
        case Command_SetA11:
            sendData = [BluetoothCommand setA11Command:value];
            break;
        case Command_SetA12:
            sendData = [BluetoothCommand setA12Command:value];
            break;
        case Command_DebugStart:
            sendData = [BluetoothCommand debugStartCommand];
            break;
        case Command_DebugStop:
            sendData = [BluetoothCommand debugStopCommand];
            break;
        case Command_DebugLeftPlus:
            sendData = [BluetoothCommand debugPlusCommand:0];
            break;
        case Command_DebugRightPlus:
            sendData = [BluetoothCommand debugPlusCommand:1];
            break;
        case Command_DebugLeftReduce:
            sendData = [BluetoothCommand debugReduceCommand:0];
            break;
        case Command_DebugRightReduce:
            sendData = [BluetoothCommand debugReduceCommand:1];
            break;
        case Command_Exit:
            sendData = [BluetoothCommand exitCommand];
            break;
        case Command_ReadSerialNumber:
            sendData = [BluetoothCommand readSerialNubmerCommand];
            break;
        case Command_Active:
            sendData = [BluetoothCommand activeCommand];
            break;
        case Command_MultiPumpRun:
            sendData = [BluetoothCommand runMultiPumpCommand];
            break;
        case Command_MultiPumpStop:
            sendData = [BluetoothCommand stopMultiPumpCommand];
            break;
        case Command_MultiPumpPlus:
            sendData = [BluetoothCommand plusMultiPumpCommand];
            break;
        case Command_MultiPumpReduce:
            sendData = [BluetoothCommand reduceMultiPumpCommand];
            break;
        case Command_hiddenCommand:
            sendData = [BluetoothCommand hiddenCommand];
            break;
        case Command_MultiPumpLeave:
            sendData = [BluetoothCommand leaveMultiPumpCommand];
            break;
        case Command_MultiPumpIn:
            sendData = [BluetoothCommand inMultiPumpCommand];
            break;
        case Command_VerifyPassword:
            sendData = [BluetoothCommand verifyPasswordCommand:value];
            break;
        case Command_ChangePassword:
            sendData = [BluetoothCommand changPasswordCommand:value];
        default:
            break;
    }
    
    if (sendData) {
        [self sendData:sendData];
    }
    
    return sendData;
}

@end
