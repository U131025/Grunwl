//
//  BluetoothManager.h
//  Grunwl
//
//  Created by mojingyu on 16/1/31.
//  Copyright © 2016年 Mojy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BluetoothLibary.h"

typedef NS_ENUM(NSInteger, CommandType) {

    Command_PowerOn,
    Command_PowerOff,
    Command_PlusDown,
    Command_PlusUp,
    Command_ReduceDown,
    Command_ReduceUp,
    //设置
    Command_ReadConfig,
    
    Command_SetA1,
    Command_SetA2,
    Command_SetA3,
    Command_SetA4,
    Command_SetA5,
    Command_SetA6,
    Command_SetA7,
    Command_SetA8,
    Command_SetA9,
    Command_SetA10,
    Command_SetA11,
    Command_SetA12,
    
    Command_DebugStart,
    Command_DebugStop,
    Command_DebugLeftPlus,
    Command_DebugRightPlus,
    Command_DebugLeftReduce,
    Command_DebugRightReduce,
    
    Command_Exit,
    
    Command_ReadSerialNumber,   //获取产品序列号
    Command_Active,             //激活命令
    
    Command_MultiPumpPlus,
    Command_MultiPumpReduce,
    Command_MultiPumpRun,
    Command_MultiPumpStop,
    Command_hiddenCommand,
    Command_MultiPumpLeave,
    Command_MultiPumpIn,
    
    Command_VerifyPassword,
    Command_ChangePassword,
};

@interface BluetoothManager : NSObject

//单例
DECLARE_SINGLETON(BluetoothManager);

@property (nonatomic, strong) CBPeripheral *peripheral;
@property (nonatomic, strong) NSMutableArray *deviceArray;

//- (BOOL)startScanBluetoothDevice;
- (void)scanDevice;

- (void)scanDevice:(void (^)(NSArray *deviceArray))onFinishedBlock;

- (void)stopScanDevice;

// 连接设备
- (void)connectPeripheral:(CBPeripheral *)peripheral onConnectedBlock:(void (^)())onConnectedBlock;

//- (void)scanDevice:(void (^)())onFinishedBlock;

- (void)sendDataWithCommandType:(CommandType)type;
- (NSData *)sendDataWithCommandType:(CommandType)type withValue:(CGFloat)value;

- (void)sendDataWithCommandType:(CommandType)type withValue:(CGFloat)value getBlock:(void (^)(NSData *readData))onGetBlock;
- (void)sendDataWithCommandType:(CommandType)type getBlock:(void (^)(NSData *readData))onGetBlock;

@end
