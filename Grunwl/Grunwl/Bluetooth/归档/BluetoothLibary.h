//
//  BluetoothLibary.h
//  BluetoothLibary
//
//  Created by JuLong on 15/6/17.
//  Copyright (c) 2015年 julong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreBluetooth/CoreBluetooth.h>

@protocol BluetoothDelegate <NSObject>

//发现蓝牙设备
- (void)didDiscoverPeripheral:(CBPeripheral *)peripheral;

//接收外设发送数据
- (void)updateValueForPeripheral:(NSData *)data;

// 断开连接消息
- (void)didDisconnectPeripheral;

@end

@interface BluetoothLibary : NSObject
{
    id<BluetoothDelegate> delegate;
}
    
@property (nonatomic, assign) id<BluetoothDelegate> delegate;
@property (nonatomic, assign) BOOL isAutoConnect;
@property (nonatomic, strong) CBPeripheral *peripheral;

// 手动获取所有扫描到的设备集合
- (NSMutableArray *)getScannedDevices;

// 扫描所有设备
- (BOOL)startScanWithReset:(BOOL)reset withTimeOut:(NSInteger)seconds withTimeOutBlock:(void(^)())timeOutBlock;

// 停止扫描
- (void)stopScan;

// 手动连接蓝牙外设
- (void)connectPeripheral:(CBPeripheral *)peripheral;

// 断开连接
- (void)disConnectPeripheral;

// 发送数据至蓝牙设备
- (void)sendDataToPeripheral:(NSData *)sendData;

@end
