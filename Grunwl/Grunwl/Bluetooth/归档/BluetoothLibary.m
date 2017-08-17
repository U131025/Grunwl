//
//  BluetoothLibary.m
//  BluetoothLibary
//
//  Created by JuLong on 15/6/17.
//  Copyright (c) 2015年 julong. All rights reserved.
//

#import "BluetoothLibary.h"
#import "UUIDDefine.h"
#import <math.h>

// NSLog 不打印
#define NSLog(...) {}

@interface BluetoothLibary () <CBCentralManagerDelegate, CBPeripheralDelegate>

@property (nonatomic, strong) NSMutableArray *devices; //of CBPeripheral
@property (nonatomic, strong) NSMutableArray *services; // of CBService

@property (nonatomic, strong) CBCentralManager *centralManager;

@property (nonatomic, strong) CBCharacteristic *writeCharacteristics;

@property (nonatomic, strong) NSString *bluetoothMacAddress;    //匹配的蓝牙设备Mac地址
//@property (nonatomic, assign) BOOL isAutoConnect;
@property (nonatomic, assign) BOOL cbReady;
@property (nonatomic, assign) BOOL isRefreshing;

@property (nonatomic, strong) NSString *serviceUUID;
@property (nonatomic, strong) NSString *readUUID;
@property (nonatomic, strong) NSString *writeUUID;
@property (nonatomic, strong) NSString *notifyUUID;

@property (nonatomic, assign) BOOL foundDevice;

@end

@implementation BluetoothLibary

@synthesize delegate = _delegate;
@synthesize bluetoothMacAddress = _bluetoothMacAddress;
@synthesize devices = _devices;
@synthesize writeCharacteristics = _writeCharacteristics;

@synthesize peripheral = _peripheral;
@synthesize centralManager = _centralManager;

@synthesize serviceUUID = _serviceUUID;
@synthesize readUUID = _readUUID;
@synthesize writeUUID = _writeUUID;
@synthesize notifyUUID = _notifyUUID;

- (NSString *)serviceUUID
{
    if (!_serviceUUID) {
        _serviceUUID = TRANSFER_SERVICE_UUID;
//        _serviceUUID = [NSString stringWithFormat:@"%@", TRANSFER_SERVICE_UUID];
    }
    return _serviceUUID;
}

- (NSString *)readUUID
{
    if (!_readUUID) {
        _readUUID = TRANSFER_READ_UUID;
    }
    return _readUUID;
}

- (NSString *)writeUUID
{
    if (!_writeUUID) {
        _writeUUID = TRANSFER_WRITE_UUID;
    }
    return _writeUUID;
}

- (NSString *)notifyUUID
{
    if (!_notifyUUID) {
        _notifyUUID = TRANSFER_NOTIFY_UUID;
    }
    return _notifyUUID;
}

- (void)setDevices:(NSMutableArray *)devices
{
    _devices = devices;
}

- (NSMutableArray *)devices
{
    if (_devices == nil) {
        _devices = [[NSMutableArray alloc] init];
    }
    return _devices;
}

- (void)setCentralManager:(CBCentralManager *)centralManager
{
    _centralManager = centralManager;
}

- (CBCentralManager *)centralManager
{
    if (_centralManager == nil)
        _centralManager = [[CBCentralManager alloc] initWithDelegate:self queue:nil];
    
    return _centralManager;
}

- (id)init
{
    self = [super init];
    if (self) {
        NSLog(@"init ...");
        self.centralManager = [[CBCentralManager alloc] initWithDelegate:self queue:nil];
        self.isAutoConnect = YES;
    }
    
    return self;
}

//
- (float)getDistance:(NSNumber *)RSSI
{
    float power = (abs([RSSI intValue]) - 59) / (10*2.0);
    return powf(10.0f, power);
}


#pragma mark - 对外接口

//获取扫描到得设备集合
- (NSMutableArray *)getScannedDevices
{
    return _devices;
}

//开始扫描蓝牙设备
- (void)startScan:(NSString *)scanDeviceMacAddress isReset:(BOOL)reset timeoutSeconds:(double)timeoutSeconds
{
    if (self.centralManager.state == CBCentralManagerStatePoweredOn) {
        
        [self.centralManager stopScan];
        NSLog(@"start scan ...");
        
        // 重置
        if (reset) {
            [self.devices removeAllObjects];
        }
        
        _isAutoConnect = YES;
//        if (scanDeviceMacAddress) {
//            _bluetoothMacAddress = scanDeviceMacAddress;
//            _isAutoConnect = YES;
//        }
        
        NSLog(@"%@", self.serviceUUID);
//        [_centralManager scanForPeripheralsWithServices:@[[CBUUID UUIDWithString:self.serviceUUID]] options:@{ CBCentralManagerScanOptionAllowDuplicatesKey: @YES }];
        
        [self.centralManager scanForPeripheralsWithServices:nil options:@{ CBCentralManagerScanOptionAllowDuplicatesKey: @YES }];
        
        // 超时设置
        if (timeoutSeconds > 0) {
            double delaySeconds = timeoutSeconds;
            dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delaySeconds *NSEC_PER_SEC));
            dispatch_after(popTime, dispatch_get_main_queue(), ^{
                
                [self.centralManager stopScan];
                NSLog(@"Time out, Stop scan.");
            });
        }
    }
}

// 根据UUID进行扫描
- (void)startScan:(NSString *)serviceUUID inReadUUID:(NSString *)readUUID inWriteUUID:(NSString *)writeUUID inTimeOutSeconds:(int)timeOutSeconds
{
    _serviceUUID = serviceUUID;
    _readUUID = readUUID;
    _writeUUID = writeUUID;
    _isAutoConnect = YES;
    [self startScan:nil isReset:YES timeoutSeconds:timeOutSeconds];
}

// 扫描所有设备
- (BOOL)startScanWithReset:(BOOL)reset withTimeOut:(NSInteger)seconds withTimeOutBlock:(void(^)())timeOutBlock
{
    if (self.centralManager.state == CBCentralManagerStatePoweredOn) {
        [self.centralManager stopScan];
        
        if (reset) {
            [self.devices removeAllObjects];
        }
        
        //扫描所有设备
        _isAutoConnect = YES;
        self.foundDevice = NO;
        if (self.serviceUUID) {
            [self.centralManager scanForPeripheralsWithServices:@[[CBUUID UUIDWithString:self.serviceUUID]] options:@{ CBCentralManagerScanOptionAllowDuplicatesKey: @YES }];
        } else {
            [self.centralManager scanForPeripheralsWithServices:nil options:@{ CBCentralManagerScanOptionAllowDuplicatesKey: @YES }];
        }
        
        //timeout
        if (seconds > 0) {
            double delaySeconds = seconds;
            dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delaySeconds *NSEC_PER_SEC));
            dispatch_after(popTime, dispatch_get_main_queue(), ^{
                
                [self.centralManager stopScan];
                if (timeOutBlock && !self.foundDevice) {
                    timeOutBlock();
                }
            });
        }
        
        return YES;
    }
    
    return NO;
}

//停止扫描
- (void)stopScan
{
    [self.centralManager stopScan];
    NSLog(@"stop scan.");
}

//手动连接蓝牙外设
- (void)connectPeripheral:(CBPeripheral *)peripheral
{
    NSLog(@"try connect peripheral: %@", peripheral);
    if (_cbReady == NO) {
        [self stopScan];
        
        NSLog(@"connectPeripheral: %@", peripheral);
        // connect device
        if (peripheral != nil) {
            _peripheral = peripheral;
            [self.centralManager connectPeripheral:_peripheral options:@{ CBConnectPeripheralOptionNotifyOnDisconnectionKey: @YES }];
            _cbReady = YES;
        }
        
    }
}

//断开连接
- (void)disConnectPeripheral
{
    if (_cbReady == YES) {
        [self cleanup];
    }
}

//发送数据至蓝牙设备
- (void)sendDataToPeripheral:(NSData *)sendData
{
    if (self.peripheral != nil && _writeCharacteristics != nil) {
//        NSLog(@"send data: %@", sendData);
        [self.peripheral writeValue:sendData forCharacteristic:_writeCharacteristics type:CBCharacteristicWriteWithoutResponse];
    }
}

//关闭通知并断开连接
-(void)cleanup
{
    if (_peripheral != nil) {
        for (CBService *service in _peripheral.services) {
            if (service.characteristics != nil) {
                for (CBCharacteristic *characteristic in service.characteristics) {
                    if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:self.notifyUUID]]) {
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
    [self.centralManager cancelPeripheralConnection:self.peripheral];
    NSLog(@"diconnect peripheral : %@", self.peripheral);
    _cbReady = YES;
}


#pragma mark - CBCentralManagerDelegate

//查看服务，蓝牙开启
- (void)centralManagerDidUpdateState:(CBCentralManager *)central
{
    switch (central.state) {
        case CBCentralManagerStatePoweredOn:
            NSLog(@"Bluetooth power on, please scan devices.");
            
            if (_isAutoConnect)
                [self startScan:nil isReset:YES timeoutSeconds:0];
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
    _peripheral = peripheral;
    
    // stop scan
    //[self.centralManager stopScan];
    
    if (advertisementData.description.length > 0) {
        MyLog(@"\n/======== advertisementData: %@ ==============/\n", advertisementData.description);
        MyLog(@"\n/======== peripheral: %@ ===========/\n", peripheral.description);
        MyLog(@"\n/======== identifer: %@ ============/\n", peripheral.identifier);
    }

    
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
        
        NSLog(@"Discover Peripheral:%@ identifier:%@ at %@", peripheral, peripheral.identifier, RSSI);
        [self.devices addObject:peripheral];
        
        // 如果为自动连接，检测当前信号距离，在3米内则自动连接        
        if (_isAutoConnect && [peripheral.name isEqualToString:TRANSFER_DEVICE_NAME]) {
            [self.centralManager stopScan];
            self.foundDevice = YES;
            [self connectPeripheral:peripheral];
        }
        
        if (_bluetoothMacAddress == nil) {
            //不采用mac地址进行匹配则通知调用方更新数据
            if ([self.delegate respondsToSelector:@selector(didDiscoverPeripheral:)]) {
                [self.delegate didDiscoverPeripheral:peripheral];
            }
        }
        
    }
}

//连接外设成功，开始发现服务
- (void)centralManager:(CBCentralManager *)central didConnectPeripheral:(CBPeripheral *)peripheral
{
    NSLog(@"connect success %@", peripheral);
    [_peripheral setDelegate:self];
    [_peripheral discoverServices:nil];
}

//连接失败
- (void)centralManager:(CBCentralManager *)central didDisconnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error
{
    NSLog(@"disconnect error: %@", [error localizedDescription]);
    _cbReady = NO;
    if (_isAutoConnect) {
        [self startScan:nil isReset:YES timeoutSeconds:0];
    }
    
    if ([self.delegate respondsToSelector:@selector(didDisconnectPeripheral)]) {
        [self.delegate didDisconnectPeripheral];
    }
}

//连接失败
- (void)centralManager:(CBCentralManager *)central didFailToConnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error
{
    NSLog(@"didFailToConnectPeripheral error: %@", [error localizedDescription]);
    if (_isAutoConnect) {
        [self startScan:nil isReset:YES timeoutSeconds:0];
    }
}

//发现服务
- (void)peripheral:(CBPeripheral *)peripheral didDiscoverServices:(NSError *)error
{
    for (CBService *service in peripheral.services) {
        NSLog(@"Discover services: %@, UUID: %@", service, service.UUID);
        [self.services addObject:service];
        [peripheral discoverCharacteristics:nil forService:service];
    }
}



//已搜索到得Characteristics
- (void)peripheral:(CBPeripheral *)peripheral didDiscoverCharacteristicsForService:(CBService *)service error:(NSError *)error
{
    if (error) {
        NSLog(@"discover characteristics error:%@", [error localizedDescription]);
        [self cleanup];
        return;
    }
    
    NSLog(@"service.UUID : %@", service.UUID);
    if ([service.UUID isEqual:[CBUUID UUIDWithString:self.serviceUUID]]) {
        
        for (CBCharacteristic *characteristics in service.characteristics) {
            
            NSLog(@"Characteristics UUID: %@ (%@)", characteristics.UUID.data, characteristics.UUID);
            
            if ([characteristics.UUID isEqual:[CBUUID UUIDWithString:self.writeUUID]]) {
                _writeCharacteristics = characteristics;
            }
            
            if ([characteristics.UUID isEqual:[CBUUID UUIDWithString:self.readUUID]]) {
                
                [self.peripheral readValueForCharacteristic:characteristics];
                [self.peripheral setNotifyValue:YES forCharacteristic:characteristics];
            }
        }
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
        
    } else if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:self.notifyUUID]]) {
        
        if ([self.delegate respondsToSelector:@selector(updateValueForPeripheral:)]) {
            [self.delegate updateValueForPeripheral:characteristic.value];
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
