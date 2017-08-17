//
//  BluetoothLibary.m
//  BluetoothLibary
//
//  Created by JuLong on 15/6/17.
//  Copyright (c) 2015年 julong. All rights reserved.
//

#import "BluetoothLibary.h"
#import "UUIDDefine.h"

//#define LIGHTBLUETOOTH_WRITE_SERVICE_UUID @"FFE5"
//#define LIGHTBLUETOOTH_WRITE_CHARACTERISTICS_UUID @"FFE9"
//
//#define LIGHTBLUETOOTH_NOTIFY_SERVICE_UUID @"FFE0"
//#define LIGHTBLUETOOTH_NOTIFY_CHARACTERISTICS_UUID @"FFE4"

//#define LIGHTBLUETOOTH_WRITE_SERVICE_UUID @"FFF0"
//#define LIGHTBLUETOOTH_WRITE_CHARACTERISTICS_UUID @"FFF1"
//
//#define LIGHTBLUETOOTH_NOTIFY_SERVICE_UUID @"FFF1"
//#define LIGHTBLUETOOTH_NOTIFY_CHARACTERISTICS_UUID @"FFF1"

// NSLog 不打印
//#define NSLog(...) {}

@interface BluetoothLibary () <CBCentralManagerDelegate, CBPeripheralDelegate>


@property (nonatomic, strong) NSMutableArray *services; // of CBService

@property (nonatomic, strong) CBCentralManager *centralManager;

@property (nonatomic, strong) CBCharacteristic *writeCharacteristics;

@property (nonatomic, copy) NSString *bluetoothMacAddress;    //匹配的蓝牙设备Mac地址
@property BOOL isAutoConnect;
@property BOOL cbReady;
@property BOOL isRefreshing;
@property BOOL foundDevice;
@property (nonatomic, copy) NSString *deviceName;
@property (nonatomic, assign) BOOL isScanning;
@property (nonatomic, copy) void (^onAutoConnectDeviceBlock)();

@property (nonatomic, copy) void (^onFindDevicesBlock)(NSMutableArray *devices);
@property (nonatomic, copy) void (^onConnectedBlock)();

@end

@implementation BluetoothLibary

@synthesize delegate = _delegate;
//@synthesize bluetoothMacAddress = _bluetoothMacAddress;
//@synthesize devices = _devices;
//@synthesize writeCharacteristics = _writeCharacteristics;
//
//@synthesize peripheral = _peripheral;
//@synthesize centralManager = _centralManager;

//@synthesize serviceUUID = _serviceUUID;
//@synthesize readUUID = _readUUID;
//@synthesize writeUUID = _writeUUID;
//@synthesize notifyUUID = _notifyUUID;

- (NSMutableArray *)devices
{
    if (_devices == nil) {
        _devices = [[NSMutableArray alloc] init];
    }
    return _devices;
}

- (CBCentralManager *)centralManager
{
    if (!_centralManager)
        _centralManager = [[CBCentralManager alloc] initWithDelegate:self queue:nil];
    
    return _centralManager;
}

- (id)init
{
    self = [super init];
    if (self) {
        self.centralManager = [[CBCentralManager alloc] initWithDelegate:self queue:nil];
        
        self.isAutoConnect = NO;
        self.isScanning = NO;
    }
    
    return self;
}


#pragma mark - 对外接口

//自动扫描并连接
- (void)scanWithDeviceName:(NSString *)deviceName withConnectBlock:(void (^)())onConnectedBlock
{
    self.serviceUUID = TRANSFER_SERVICE_UUID;
    self.readUUID = TRANSFER_READ_UUID;
    self.writeUUID = TRANSFER_WRITE_UUID;
    
    self.isAutoConnect = YES;
    self.deviceName = deviceName;
    self.onAutoConnectDeviceBlock = onConnectedBlock;
    [self scanDeviceWithAutoConnect];
}

- (void)scanDeviceWithAutoConnect
{
    if (!_isScanning) {
        [self startScanWithReset:YES withTimeOut:0 withTimeOutBlock:nil];
    }
}

// 扫描设备
- (void)scanDeciveOnFindBlock:(void (^)(NSMutableArray *devices))onFindBlock
{
    self.serviceUUID = TRANSFER_SERVICE_UUID;
    self.readUUID = TRANSFER_READ_UUID;
    self.writeUUID = TRANSFER_WRITE_UUID;
    
    self.isAutoConnect = NO;
    self.deviceName = nil;
    self.onFindDevicesBlock = onFindBlock;
    [self scanDeviceWithAutoConnect];
}

// 连接设备
- (void)connectPeripheral:(CBPeripheral *)peripheral onConnectedBlock:(void (^)())onConnectedBlock
{
    self.onConnectedBlock = onConnectedBlock;
    [self connectPeripheral:peripheral];
}

// 扫描所有设备
- (BOOL)startScanWithReset:(BOOL)reset withTimeOut:(NSInteger)seconds withTimeOutBlock:(void(^)())timeOutBlock
{
    
    if (self.centralManager.state == CBCentralManagerStatePoweredOn) {
        
        if (self.isScanning)
            [self stopScan];
        
        self.isScanning = YES;
        if (reset) {
            [self.devices removeAllObjects];
        }
        
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            
            //扫描所有设备
            self.foundDevice = NO;
//            if (self.serviceUUID) {
//                [self.centralManager scanForPeripheralsWithServices:@[[CBUUID UUIDWithString:self.serviceUUID]] options:@{ CBCentralManagerScanOptionAllowDuplicatesKey: @YES }];
//            }
//            else
            {
                [self.centralManager scanForPeripheralsWithServices:nil options:@{ CBCentralManagerScanOptionAllowDuplicatesKey: @YES }];
            }
            
            //timeout
            if (seconds > 0) {
                double delaySeconds = seconds;
                dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delaySeconds *NSEC_PER_SEC));
                dispatch_after(popTime, dispatch_get_main_queue(), ^{
                    
                    [self stopScan];
                    if (timeOutBlock && !self.foundDevice) {
                        timeOutBlock();
                    }
                });
            }
            
        });
        
        return YES;
    }
   
    return NO;
}

//停止扫描
- (void)stopScan
{
    self.isScanning = NO;
    [self.centralManager stopScan];
    NSLog(@"stop scan.");
}

//手动连接蓝牙外设
- (void)connectPeripheral:(CBPeripheral *)peripheral
{
    if (_cbReady && ![self.peripheral isEqual:peripheral]) {
        [self disConnectPeripheral];
    }
    
    NSLog(@"try connect peripheral: %@", peripheral);
    if (_cbReady == NO) {
        [self stopScan];
        
        // connect device
        if (peripheral != nil) {
            _peripheral = peripheral;
            [self.centralManager connectPeripheral:_peripheral options:@{ CBConnectPeripheralOptionNotifyOnDisconnectionKey: @YES }];
            
            if (_peripheral.state == CBPeripheralStateConnected)
                _cbReady = YES;
        }
        
        NSLog(@"connectPeripheral: %@", peripheral);
    } else {
        //
        MyLog(@"设备已经连接.%@", self.peripheral);
    }
}

// 手动连接设备
- (void)connectPeripheral:(CBPeripheral *)peripheral withServiceUUID:(NSString *)serviceUUID withReadUUID:(NSString *)readUUID withWriteUUID:(NSString *)writeUUID
{
    _serviceUUID = serviceUUID;
    _readUUID = serviceUUID;
    _writeUUID = writeUUID;
    [self connectPeripheral:peripheral];
}

//断开连接
- (void)disConnectPeripheral
{
    [self cleanup];
}

//发送数据至蓝牙设备
- (void)sendDataToPeripheral:(NSData *)sendData
{    
    if (self.peripheral != nil && _writeCharacteristics != nil) {
        
        NSLog(@"send data: %@", sendData);
        [self.peripheral writeValue:sendData forCharacteristic:_writeCharacteristics type:CBCharacteristicWriteWithoutResponse];
    }
}

//关闭通知并断开连接
-(void)cleanup
{
    NSLog(@"cleanup");
    if (_peripheral != nil) {
        for (CBService *service in _peripheral.services) {
            if (service.characteristics != nil) {
                for (CBCharacteristic *characteristic in service.characteristics) {
                    
                    if (!self.readUUID) {
                        break;
                    }
                    
                    if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:self.readUUID]]) {
                        if (characteristic.isNotifying) {
                            [_peripheral setNotifyValue:NO forCharacteristic:characteristic];
                            return;
                        }
                    }
                    
                }
            }
        }
    }
    
    //disconnect peripheral
    if (_peripheral) {

        [self.centralManager cancelPeripheralConnection:self.peripheral];
        NSLog(@"diconnect peripheral : %@", self.peripheral);
    }
    self.peripheral = nil;
    _cbReady = NO;
}


#pragma mark - CBCentralManagerDelegate

//查看服务，蓝牙开启
- (void)centralManagerDidUpdateState:(CBCentralManager *)central
{
    switch (central.state) {
        case CBCentralManagerStatePoweredOn:
            NSLog(@"Bluetooth power on, please scan devices.");
            
//            if (self.isAutoConnect)
                [self scanDeviceWithAutoConnect];

            break;
        case CBCentralManagerStatePoweredOff:
            NSLog(@"Bluetooth power off, please open it.");
            break;
        default:
            break;
    }
}

//找到外设后,添加至列表中
- (void)centralManager:(CBCentralManager *)central didDiscoverPeripheral:(CBPeripheral *)peripheral advertisementData:(NSDictionary *)advertisementData RSSI:(NSNumber *)RSSI
{
    //获取数据
//    NSData *manufacturerData = [advertisementData valueForKeyPath:CBAdvertisementDataManufacturerDataKey];
//    if (advertisementData.description.length > 0) {
//        NSLog(@"\n/======== advertisementData: %@ ==============/\n", advertisementData.description);
//        NSLog(@"\n/======== peripheral: %@ ===========/\n", peripheral.description);
//        NSLog(@"\n/======== identifer: %@ ============/\n", peripheral.identifier);
//    }
    
    _peripheral = peripheral;
    
    BOOL replace = NO;
    
    // Match if we have this device from before
    for (int i = 0; i < self.devices.count; i++) {
        CBPeripheral *peripheralObject = [self.devices objectAtIndex:i];
        if ([peripheralObject isEqual:peripheral]) {
            [self.devices replaceObjectAtIndex:i withObject:peripheral];
            replace = YES;
        }
    }
    
    if (!replace) {
        
        MyLog(@"Discover Peripheral:%@ identifier:%@ at %@", peripheral, peripheral.identifier, RSSI);
        
#ifndef TestOtherDevice
        NSString *deviceName = peripheral.name;
        if (!deviceName) return;
        deviceName = [deviceName uppercaseString];
        if (![deviceName containsString:@"GRUNWL"])
            return;
#endif
        
        [self.devices addObject:peripheral];
        
        // 如果为自动连接
        if (_isAutoConnect && [peripheral.name isEqualToString:self.deviceName]) {
            [self stopScan];
            self.foundDevice = YES;
            [self connectPeripheral:peripheral];
        }
        
        if (self.onFindDevicesBlock) {
            self.onFindDevicesBlock(self.devices);
        }
        
        if ([self.delegate respondsToSelector:@selector(didDiscoverPeripheral:)]) {
            [self.delegate didDiscoverPeripheral:peripheral];
        }
        
    }
}

//连接外设成功，开始发现服务
- (void)centralManager:(CBCentralManager *)central didConnectPeripheral:(CBPeripheral *)peripheral
{
    NSLog(@"connect success %@", peripheral);
    [self.peripheral setDelegate:self];
    [self.peripheral discoverServices:nil];

}

//连接断开
- (void)centralManager:(CBCentralManager *)central didDisconnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error
{
    NSLog(@"disconnect error: %@", [error localizedDescription]);
    _cbReady = NO;
    
    if ([self.delegate respondsToSelector:@selector(didDisconnectPeripheral)]) {
        [self.delegate didDisconnectPeripheral];
    }
}

//连接失败
- (void)centralManager:(CBCentralManager *)central didFailToConnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error
{
    NSLog(@"didFailToConnectPeripheral error: %@", [error localizedDescription]);
    if (_isAutoConnect) {
        [self scanDeviceWithAutoConnect];
    }
}

//发现服务
- (void)peripheral:(CBPeripheral *)peripheral didDiscoverServices:(NSError *)error
{
    
    for (CBService *service in peripheral.services) {
        NSLog(@"Discover services: %@, UUID: %@", service, service.UUID);
        [self.services addObject:service];
        
        if (self.serviceUUID && [service.UUID isEqual:[CBUUID UUIDWithString:self.serviceUUID]]) {
            [peripheral discoverCharacteristics:nil forService:service];
        } else {
            [peripheral discoverCharacteristics:nil forService:service];
        }
    }
    
//    for (CBService *service in peripheral.services) {
//        NSLog(@"Discover services: %@, UUID: %@", service, service.UUID);
//        [self.services addObject:service];
//        
//        if ([service.UUID isEqual:[CBUUID UUIDWithString:self.writeUUID]]) {
//            //写服务
//            [peripheral discoverCharacteristics:nil forService:service];
//        } else if ([service.UUID isEqual:[CBUUID UUIDWithString:self.readUUID]]) {
//            //通知
//            [peripheral discoverCharacteristics:nil forService:service];
//        } else {
////           [peripheral discoverCharacteristics:nil forService:service];
//        }
//        
//    }
}

//已搜索到得Characteristics
- (void)peripheral:(CBPeripheral *)peripheral didDiscoverCharacteristicsForService:(CBService *)service error:(NSError *)error
{
    if (error) {
        NSLog(@"discover characteristics error:%@", [error localizedDescription]);
        [self cleanup];
        return;
    }
    
#ifndef TestOtherDevice
    if (self.serviceUUID && ![service.UUID isEqual:[CBUUID UUIDWithString:self.serviceUUID]])
        return;
#endif
    
    for (CBCharacteristic *characteristics in service.characteristics) {
        
        NSLog(@"Characteristics UUID: %@ (%@)", characteristics.UUID.data, characteristics.UUID);
        
        if ([characteristics.UUID isEqual:[CBUUID UUIDWithString:self.writeUUID]]) {
            _writeCharacteristics = characteristics;
            
        }
        
        if ([characteristics.UUID isEqual:[CBUUID UUIDWithString:self.readUUID]]) {
            
            [self.peripheral readValueForCharacteristic:characteristics];
            [self.peripheral setNotifyValue:YES forCharacteristic:characteristics];
        }
        
        // other characteristics
        
    }
    
    if (_peripheral.state == CBPeripheralStateConnected)
        _cbReady = YES;
    
    if (self.onAutoConnectDeviceBlock) {
        self.onAutoConnectDeviceBlock();
        self.onAutoConnectDeviceBlock = nil;
    }
    
    if (self.onConnectedBlock) {
        self.onConnectedBlock();
        self.onConnectedBlock = nil;
    }
    
    //连接成功通知
    if ([self.delegate respondsToSelector:@selector(connetctSuccess:)]) {
        [self.delegate connetctSuccess:peripheral];
    }
}

//获取外设发送的数据
- (void)peripheral:(CBPeripheral *)peripheral didUpdateValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error
{
    if (error) {
        NSLog(@"Error updating value for charateristic %@ error :%@", characteristic.UUID, [error localizedDescription]);
        return;
    }
    
    if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:self.readUUID]]) {
        
        if (characteristic.value.length > 0) {
            
            NSLog(@"readData: %@", characteristic.value);
            if ([self.delegate respondsToSelector:@selector(updateValueForPeripheral:)]) {
                [self.delegate updateValueForPeripheral:characteristic.value];
                
            }
        }
        
    }
    // other peripheral data
    
}

//中心读取外设实时数据
- (void)peripheral:(CBPeripheral *)peripheral didUpdateNotificationStateForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error
{
    if (error) {
        NSLog(@"Error changing notification state: %@", [error localizedDescription]);
    }
    
    // Notification has started
    if (characteristic.isNotifying) {
        [peripheral readValueForCharacteristic:characteristic];
    } else {
        NSLog(@"cancelPeripheralConnection: ");
        // Notification has stopped, so disconnect from the peripheral
        [self.centralManager cancelPeripheralConnection:peripheral];
        
    }
}

//用于检测中心向外设写数据是否成功
- (void)peripheral:(CBPeripheral *)peripheral didWriteValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error
{
    if (error) {
        NSLog(@"Write Error: %@", error.userInfo);
    } else {
       NSLog(@"Write Success.");
    }
}

@end
