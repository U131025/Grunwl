//
//  HomeViewController.m
//  Grunwl
//
//  Created by mojingyu on 16/1/30.
//  Copyright © 2016年 Mojy. All rights reserved.
//

#import "HomeViewController.h"
#import "UIImage+Extension.h"
#import "MonitorViewController.h"
#import "LightView.h"
#import "BluetoothManager.h"
#import "WaitingView.h"
#import "DevicesViewController.h"
#import "myUILabel.h"
#import "VerifyViewController.h"
#import "UIImage+Extension.h"

@interface HomeViewController ()

@property (nonatomic, copy) NSArray *imageNameArray;
@property (nonatomic, strong) WaitingView *waiting;
@property (nonatomic, copy) NSArray *deviceArray;
@property (nonatomic, assign) BOOL isSearchTimeOut;
@property (nonatomic, assign) BOOL isRecieveDiscoverNotify;

@property (nonatomic, strong) myUILabel *serialALabel;
@property (nonatomic, strong) myUILabel *serialBLabel;
@property (nonatomic, strong) myUILabel *serialCLabel;
@property (nonatomic, strong) UIButton *activeButton;

@end

@implementation HomeViewController

- (NSArray *)deviceArray
{
    return [BluetoothManager sharedInstance].deviceArray;
}

- (NSArray *)imageNameArray
{
    if (!_imageNameArray) {
        
#ifdef FLOTEQ
        _imageNameArray = @[@"flo_d1", @"flo_d2", @"flo_d3"];
#else
        if (APPDELEGATE.isPad)
            _imageNameArray = @[@"device_01", @"device_02", @"device_03", @"device_04",@"device_05", @"device_06", @"F305", @"F3335", @"FGAB"];
        else
            _imageNameArray = @[@"device_01", @"device_02", @"device_03", @"device_04",@"device_05", @"device_06"];
#endif
    }
    return _imageNameArray;
}

- (id)init
{
    self = [super init];
    if (self) {
        //
        self.isSearchTimeOut = NO;
        self.isRecieveDiscoverNotify = NO;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [APPDELEGATE playMp3WithName:@"Scaning.mp3"];
    
    self.view.backgroundColor = RGBAlphaColor(0, 112, 192, 1);
    
#ifdef FLOTEQ
    [self setupFLOTEQ];
#else
    [self setupUI];
#endif
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(discoverDevice:) name:Notify_DiscoverDevice object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(disconnectDevice:) name:Notify_Disconnect object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateSerialNumber:) name:Notify_SerialNumber object:nil];
    
//    [NSThread sleepForTimeInterval:2.5];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if ([BluetoothManager sharedInstance].peripheral.state == CBPeripheralStateDisconnected) {
        
        self.isSearchTimeOut = NO;
        self.isRecieveDiscoverNotify = NO;
        
        [[BluetoothManager sharedInstance] scanDevice:^(NSArray *deviceArray) {
            
//            self.deviceArray  = deviceArray;
        }];

        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{

            self.isSearchTimeOut = YES;
            MyLog(@"\n======= Search TimeOut =======\n");
            
            // 在5秒的扫描时间里，如果只有1台设备则自动连接，有多台设备则跳转至设备选择界面
            [self onFindDeviceAction];
            
        });
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(30 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            //30 s 没有搜索到设备这退出程序
            if (self.deviceArray.count == 0)
                [[NSNotificationCenter defaultCenter] postNotificationName:Notify_ExitApp object:nil];
            
        });
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(45 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            //45s未连接则退出程序
            if ([BluetoothManager sharedInstance].peripheral.state != CBPeripheralStateConnected) {
                [ITTCustomAlertView showMessage:[APPDELEGATE.TextDictionary objectForKey:@"Device not connected"]];
                
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    
                    //退出程序
                    [[NSNotificationCenter defaultCenter] postNotificationName:Notify_ExitApp object:nil];
                });
            }
            
        });
        
        self.serialALabel.hidden = YES;
        self.serialBLabel.hidden = YES;
        self.serialCLabel.hidden = YES;
        
        [_waiting setHidden:NO];
        _waiting.tipText = [APPDELEGATE.TextDictionary objectForKey:@"Scaning"];
        [_waiting startAnimation];
        
    } else if ([BluetoothManager sharedInstance].peripheral.state == CBPeripheralStateConnected) {
        
        self.serialALabel.hidden = NO;
        self.serialBLabel.hidden = NO;
        self.serialCLabel.hidden = NO;
        
        _waiting.tipText = [APPDELEGATE.TextDictionary objectForKey:@"Connected"];
        [_waiting stopAnimation];
        [_waiting setHidden:YES];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    
    
}

- (void)onFindDeviceAction
{
    
#ifdef TestImitateBluetoolDevice
//    VerifyViewController *viewController = [[VerifyViewController alloc] init];
//    viewController.deviceID = @"160802";
//    [self.navigationController pushViewController:viewController animated:YES];
//    return;
#else
    
//#ifdef TestOtherDevice
//    if (self.deviceArray.count > 0) {
//        //跳转手动连接
//        self.isRecieveDiscoverNotify = NO;
//        DevicesViewController *devicesVC = [[DevicesViewController alloc] initWithDevices:self.deviceArray];
//        [self.navigationController pushViewController:devicesVC animated:YES];        
//    }
//    else {
//        self.isRecieveDiscoverNotify = YES;
//    }
//    
//#else
    
    if (self.deviceArray.count > 1) {
        //跳转手动连接
        self.isRecieveDiscoverNotify = NO;
        DevicesViewController *devicesVC = [[DevicesViewController alloc] initWithDevices:self.deviceArray];
        [self.navigationController pushViewController:devicesVC animated:YES];
        
    } else if (self.deviceArray.count == 1) {
        //自动连接
        self.isRecieveDiscoverNotify = NO;
        
        CBPeripheral *peripheral = [self.deviceArray objectAtIndex:0];
        [[BluetoothManager sharedInstance] connectPeripheral:peripheral onConnectedBlock:^{
            //
            [[NSNotificationCenter defaultCenter] postNotificationName:Notify_Connected object:nil];
            
            self.serialALabel.hidden = NO;
            self.serialBLabel.hidden = NO;
            self.serialCLabel.hidden = NO;
            
            _waiting.tipText = [APPDELEGATE.TextDictionary objectForKey:@"Connected"];
            [_waiting stopAnimation];
            [_waiting setHidden:YES];
            
            //
            NSString *name;
            if ([[peripheral.name uppercaseString] containsString:@"GRUNWL-"])
                name = [peripheral.name substringFromIndex:7];
            else
                name = peripheral.name;
            
            //连接上后跳转到验证页面
            VerifyViewController *viewController = [[VerifyViewController alloc] init];
            viewController.deviceID = name;
            [self.navigationController pushViewController:viewController animated:YES];
            
        }];
    } else {
        self.isRecieveDiscoverNotify = YES;
    }
    
//#endif  
    
#endif
}

#pragma mark -消息处理
- (void)updateSerialNumber:(NSNotification *)notify
{
    NSDictionary *dic = notify.userInfo;
   
    self.serialALabel.text = [APPDELEGATE.logoDictionary objectForKey:[dic objectForKey:@"D"]];
    
    NSString *name;
    CBPeripheral *peripheral = [BluetoothManager sharedInstance].peripheral;
    if ([[peripheral.name uppercaseString] containsString:@"GRUNWL-"])
        name = [peripheral.name substringFromIndex:7];
    else
        name = peripheral.name;
    
    self.serialBLabel.text = name;
//    self.serialBLabel.text = [NSString stringWithFormat:@"%@%@", [dic objectForKey:@"A"], [dic objectForKey:@"B"]];
    
    NSString *strSerial = [NSString stringWithFormat:@"%@%@%@", [dic objectForKey:@"A"], [dic objectForKey:@"B"], [dic objectForKey:@"C"]];
    
    if ([strSerial integerValue] == 0) {
        self.activeButton.hidden = NO;
        self.serialCLabel.text = @"";
    } else {
        self.activeButton.hidden = YES;
        self.serialCLabel.text = [NSString stringWithFormat:@"20%@", strSerial];
    }
    
}

- (void)discoverDevice:(NSNotification *)notify
{
    if (self.isRecieveDiscoverNotify) {
        [self onFindDeviceAction];
    }
}

- (void)disconnectDevice:(NSNotification *)notify
{
    //重新扫描
    if ([BluetoothManager sharedInstance].peripheral == CBPeripheralStateDisconnected) {
        [[BluetoothManager sharedInstance] scanDevice];
        _waiting.tipText = [APPDELEGATE.TextDictionary objectForKey:@"Scaning"];
        [_waiting startAnimation];
    }
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(10 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if (self.deviceArray.count == 0)
            [[NSNotificationCenter defaultCenter] postNotificationName:Notify_ExitApp object:nil];
    });
}

#pragma mark -界面处理
- (void)setupFLOTEQ
{
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIImage *logoImage = [UIImage imageNamed:@"logo_floteq"];
    UIImageView *logoImageView = [[UIImageView alloc] initWithImage:logoImage];
    logoImageView.contentMode = UIViewContentModeScaleAspectFit;
    [self.view addSubview:logoImageView];
    [logoImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(SYRealValue(30));
        make.left.equalTo(self.view).offset(SYRealValue(10));
//        make.height.mas_equalTo(SYRealValue(60));
        make.size.mas_equalTo([logoImage calculateTargetSize:CGSizeMake(ScreenWidth, 60)]);
    }];
    
    //添加中英文切换按钮
    UIButton *changeLanguageButton = [[UIButton alloc] init];
    changeLanguageButton.layer.borderColor = BlackColor.CGColor;
    changeLanguageButton.layer.borderWidth = 1;
    changeLanguageButton.backgroundColor = DarkGreenBackgroundColor;
    changeLanguageButton.titleLabel.textAlignment = NSTextAlignmentCenter;
    if (APPDELEGATE.languageType == Text_Zh) {
        changeLanguageButton.selected = NO;
    } else {
        changeLanguageButton.selected = YES;
    }
    
    if (APPDELEGATE.isPad)
        changeLanguageButton.frame = (CGRect){30, CGRectGetMaxY(self.logoImageView.frame)+10, 160, 60};
    
    [changeLanguageButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [changeLanguageButton setTitleColor:[UIColor blackColor] forState:UIControlStateSelected];
    [changeLanguageButton setTitle:[self getLanguageName] forState:UIControlStateNormal];
    //    [changeLanguageButton setTitle:@"中文" forState:UIControlStateSelected];
    [changeLanguageButton addTarget:self action:@selector(changeLanuageAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:changeLanguageButton];
    [changeLanguageButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(SYRealValue(20));
        make.top.equalTo(logoImageView.mas_bottom).offset(SYRealValue(15));
        make.width.mas_equalTo(SYRealValue(80));
        make.height.mas_equalTo(SYRealValue(30));
    }];
    
    UIImageView *centerLogoImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"home_logo"]];
    centerLogoImageView.contentMode = UIViewContentModeScaleAspectFit;
//    [self.view addSubview:centerLogoImageView];
    [self.view insertSubview:centerLogoImageView atIndex:0];
    [centerLogoImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.centerY.equalTo(self.view).offset(-SYRealValue(60));
        make.width.height.mas_equalTo(SYRealValue(300));
    }];
    
    CGFloat buttonWidth = ScreenWidth / 3;
    _waiting = [[WaitingView alloc] initWithFrame:(CGRect){02, 0, buttonWidth, buttonWidth}];
    [self.view addSubview:_waiting];
    [_waiting mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(centerLogoImageView);
        make.width.height.mas_equalTo(buttonWidth);
    }];
    
    UIView *preView;
    NSInteger index = 0;
    for (NSString *imageName in self.imageNameArray) {
        UIButton *device = [[UIButton alloc] init];
        device.tag = index;
        device.imageView.contentMode = UIViewContentModeScaleAspectFit;
        [device addTarget:self action:@selector(deviceButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        [device setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
        [self.view addSubview:device];
        [device mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(centerLogoImageView.mas_bottom).offset(SYRealValue(10));
            make.left.equalTo(preView ? preView.mas_right : self.view);
            make.bottom.equalTo(self.view).offset(-SYRealValue(100));
            make.width.equalTo(self.view).multipliedBy(1.0/self.imageNameArray.count);
        }];
        preView = device;
        index++;
    }
    
    UIImageView *textImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bottom_text"]];
    textImageView.contentMode = UIViewContentModeScaleAspectFit;
    [self.view addSubview:textImageView];
    [textImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.top.equalTo(preView.mas_bottom).offset(SYRealValue(5));
        make.bottom.equalTo(self.view).offset(-SYRealValue(30));
    }];
    
    
    ///// 解锁的隐藏按钮
    
    //active button
    self.activeButton = [[UIButton alloc] init];
    //    self.activeButton.frame = (CGRect){ScreenWidth-120, offsetY+buttonHeight/2-40, 80, 80};
    self.activeButton.layer.borderColor = GreenColor.CGColor;
    self.activeButton.layer.borderWidth = 1;
    self.activeButton.backgroundColor = DarkGreenBackgroundColor;
    self.activeButton.hidden = YES;
    [self.activeButton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [self.activeButton setImage:[UIImage imageNamed:@"active.jpg"] forState:UIControlStateNormal];
    [self.activeButton setTitle:[APPDELEGATE.TextDictionary objectForKey:@"Active"] forState:UIControlStateNormal];
    [self.activeButton addTarget:self action:@selector(activeAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.activeButton];
    [self.activeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.mas_equalTo(SYRealValue(80));
        make.right.equalTo(self.view).offset(-SYRealValue(10));
        make.centerY.equalTo(changeLanguageButton);
    }];
    
    // serial number A
    self.serialALabel = [[myUILabel alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth-130, buttonWidth)];
    self.serialALabel.backgroundColor = [UIColor clearColor];
    self.serialALabel.textColor = GreenColor;
    self.serialALabel.font = Font(30);
    self.serialALabel.textAlignment = NSTextAlignmentCenter;
    self.serialALabel.numberOfLines = 2;
    self.serialALabel.verticalAlignment = VerticalAlignmentMiddle;
    //    self.serialALabel.text = [APPDELEGATE.logoDictionary objectForKey:@"25"];
    self.serialALabel.hidden = YES;
    [self.view addSubview:self.serialALabel];
    [self.serialALabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(changeLanguageButton.mas_right).offset(SYRealValue(10));
        make.right.equalTo(self.activeButton.mas_left).offset(-SYRealValue(10));
        make.centerY.equalTo(changeLanguageButton);
        make.height.mas_equalTo(SYRealValue(50));
    }];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(logoClickAction:)];
    tap.numberOfTapsRequired = 1;
    [self.serialALabel addGestureRecognizer:tap];
    
    
    //B
    self.serialBLabel = [[myUILabel alloc] initWithFrame:CGRectMake(10, ScreenHeight-40, ScreenWidth/2-20, 30)];
    self.serialBLabel.backgroundColor = [UIColor clearColor];
    self.serialBLabel.textColor = GreenColor;
    self.serialBLabel.font = Font(20);
    self.serialBLabel.textAlignment = NSTextAlignmentLeft;
    self.serialBLabel.verticalAlignment = VerticalAlignmentBottom;
    self.serialBLabel.text = @"Serial B";
    self.serialBLabel.hidden = YES;
    [self.view addSubview:self.serialBLabel];
    [self.serialBLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(SYRealValue(10));
        make.bottom.equalTo(self.view).offset(-SYRealValue(10));
        make.right.equalTo(self.view.mas_centerX);
        make.height.mas_equalTo(30);
    }];
    
    //C
    self.serialCLabel = [[myUILabel alloc] initWithFrame:CGRectMake(ScreenWidth/2+10, ScreenHeight-40, ScreenWidth/2 - 20, 30)];
    self.serialCLabel.backgroundColor = [UIColor clearColor];
    self.serialCLabel.textColor = GreenColor;
    self.serialCLabel.font = Font(20);
    self.serialCLabel.textAlignment = NSTextAlignmentRight;
    self.serialCLabel.verticalAlignment = UIControlContentVerticalAlignmentTop;
    self.serialCLabel.text = @"Serial C";
    self.serialCLabel.hidden = YES;
    [self.view addSubview:self.serialCLabel];
    [self.serialCLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_centerX);
        make.right.equalTo(self.view).offset(-SYRealValue(10));
        make.bottom.height.equalTo(self.serialBLabel);
    }];
    
    if ([BluetoothManager sharedInstance].peripheral == CBPeripheralStateDisconnected) {
        _waiting.tipText = [APPDELEGATE.TextDictionary objectForKey:@"Scaning"];
        [_waiting startAnimation];
    }
    
    //    self.serialALabel.hidden = NO;
    //    self.serialBLabel.hidden = NO;
    //    self.serialCLabel.hidden = NO;
    //    self.activeButton.hidden = NO;
}


- (void)setupUI
{
    [self setupLogo];
    
    //添加中英文切换按钮
    UIButton *changeLanguageButton = [[UIButton alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(self.logoImageView.frame)+10, 80, 30)];
    changeLanguageButton.layer.borderColor = BlackColor.CGColor;
    changeLanguageButton.layer.borderWidth = 1;
    changeLanguageButton.backgroundColor = DarkGreenBackgroundColor;
    changeLanguageButton.titleLabel.textAlignment = NSTextAlignmentCenter;
    if (APPDELEGATE.languageType == Text_Zh) {
        changeLanguageButton.selected = NO;
    } else {
        changeLanguageButton.selected = YES;
    }
    
    if (APPDELEGATE.isPad)
        changeLanguageButton.frame = (CGRect){30, CGRectGetMaxY(self.logoImageView.frame)+10, 160, 60};
    
    [changeLanguageButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [changeLanguageButton setTitleColor:[UIColor blackColor] forState:UIControlStateSelected];
    [changeLanguageButton setTitle:[self getLanguageName] forState:UIControlStateNormal];
//    [changeLanguageButton setTitle:@"中文" forState:UIControlStateSelected];
    [changeLanguageButton addTarget:self action:@selector(changeLanuageAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:changeLanguageButton];
    
    CGFloat buttonWidth = ScreenWidth / 3;
    CGFloat buttonHeight = buttonWidth;
    
    if (APPDELEGATE.isPad) {
        buttonHeight = 150;
        buttonWidth = 150;
    }
    
    
    NSInteger spaceValue = 0;
    NSInteger offsetY = ScreenHeight-50-2*buttonHeight;
    if (APPDELEGATE.isPad) {
        spaceValue = (ScreenWidth - 3*buttonHeight)/4;
        offsetY = ScreenHeight-50-3*buttonHeight;
    }
    NSInteger offset = spaceValue;
    
    if (IS_IPHONE_5_OR_LESS) {
        UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, ScreenHeight-50-buttonHeight, ScreenWidth, buttonHeight)];
        scrollView.showsHorizontalScrollIndicator = NO;
        
        [self.view addSubview:scrollView];
        
        for (int i = 0; i < self.imageNameArray.count; i++) {
            UIButton *device = [[UIButton alloc] initWithFrame:CGRectMake(offset, 0, buttonWidth, buttonHeight)];
            device.tag = i;
            [device addTarget:self action:@selector(deviceButtonAction:) forControlEvents:UIControlEventTouchUpInside];
            [device setImage:[UIImage imageNamed:[self.imageNameArray objectAtIndex:i]] forState:UIControlStateNormal];
            [scrollView addSubview:device];
            offset += buttonWidth + spaceValue;
        }
        
        scrollView.contentSize = CGSizeMake(offset, buttonHeight);
        
    } else {
        for (int i = 0; i < self.imageNameArray.count; i++) {
            UIButton *device = [[UIButton alloc] initWithFrame:CGRectMake(offset, offsetY, buttonWidth, buttonHeight)];
            device.tag = i;
            [device addTarget:self action:@selector(deviceButtonAction:) forControlEvents:UIControlEventTouchUpInside];
            [device setImage:[UIImage imageNamed:[self.imageNameArray objectAtIndex:i]] forState:UIControlStateNormal];
            [self.view addSubview:device];
            offset += buttonWidth + spaceValue;
            
            if (i == 2 || i == 5 ) {
                offset = spaceValue;
                offsetY += buttonHeight;
            }
        }
    }
    
    
    offsetY = ScreenHeight-50-3*buttonHeight;
    if (IS_IPHONE_5_OR_LESS) {
        offsetY = ScreenHeight-50-2*buttonHeight;
    }
    
    if (APPDELEGATE.isPad) {
        offsetY = ScreenHeight-50-4*buttonHeight;
    }
    
    _waiting = [[WaitingView alloc] initWithFrame:(CGRect){(ScreenWidth-buttonWidth)/2, offsetY, buttonWidth, buttonHeight}];
    [self.view addSubview:_waiting];
    
    // serial number
    UIView *logoTextView = [[UIView alloc] initWithFrame:CGRectMake(0, offsetY, ScreenWidth-130, buttonWidth)];
    
//    self.serialALabel = [[myUILabel alloc] initWithFrame:CGRectMake(0, offsetY, ScreenWidth-130, buttonWidth)];
    self.serialALabel = [[myUILabel alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth-130, buttonWidth)];
    self.serialALabel.backgroundColor = [UIColor clearColor];
    self.serialALabel.textColor = WhiteColor;
    self.serialALabel.font = Font(30);
    self.serialALabel.textAlignment = NSTextAlignmentCenter;
    self.serialALabel.numberOfLines = 2;
    self.serialALabel.verticalAlignment = VerticalAlignmentMiddle;
//    self.serialALabel.text = [APPDELEGATE.logoDictionary objectForKey:@"25"];
    self.serialALabel.hidden = YES;
    [logoTextView addSubview:self.serialALabel];
    
    //给logo添加点击事件
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(logoClickAction:)];
    tap.numberOfTapsRequired = 1;
    [logoTextView addGestureRecognizer:tap];
    
    [self.view addSubview:logoTextView];
    
    //active button
    self.activeButton = [[UIButton alloc] init];
    self.activeButton.frame = (CGRect){ScreenWidth-120, offsetY+buttonHeight/2-40, 80, 80};
    self.activeButton.layer.borderColor = WhiteColor.CGColor;
    self.activeButton.layer.borderWidth = 1;
    self.activeButton.backgroundColor = DarkGreenBackgroundColor;
    self.activeButton.hidden = YES;
    [self.activeButton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [self.activeButton setImage:[UIImage imageNamed:@"active.jpg"] forState:UIControlStateNormal];
    [self.activeButton setTitle:[APPDELEGATE.TextDictionary objectForKey:@"Active"] forState:UIControlStateNormal];
    [self.activeButton addTarget:self action:@selector(activeAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.activeButton];
    
    //B
    self.serialBLabel = [[myUILabel alloc] initWithFrame:CGRectMake(10, ScreenHeight-40, ScreenWidth/2-20, 30)];
    self.serialBLabel.backgroundColor = [UIColor clearColor];
    self.serialBLabel.textColor = WhiteColor;
    self.serialBLabel.font = Font(20);
    self.serialBLabel.textAlignment = NSTextAlignmentLeft;
    self.serialBLabel.verticalAlignment = VerticalAlignmentBottom;
    self.serialBLabel.text = @"Serial B";
    self.serialBLabel.hidden = YES;
    [self.view addSubview:self.serialBLabel];
    
    //C
    self.serialCLabel = [[myUILabel alloc] initWithFrame:CGRectMake(ScreenWidth/2+10, ScreenHeight-40, ScreenWidth/2 - 20, 30)];
    self.serialCLabel.backgroundColor = [UIColor clearColor];
    self.serialCLabel.textColor = WhiteColor;
    self.serialCLabel.font = Font(20);
    self.serialCLabel.textAlignment = NSTextAlignmentRight;
    self.serialCLabel.verticalAlignment = UIControlContentVerticalAlignmentTop;
    self.serialCLabel.text = @"Serial C";
    self.serialCLabel.hidden = YES;
    [self.view addSubview:self.serialCLabel];
    
    if ([BluetoothManager sharedInstance].peripheral == CBPeripheralStateDisconnected) {
        _waiting.tipText = [APPDELEGATE.TextDictionary objectForKey:@"Scaning"];
        [_waiting startAnimation];
    }
    
    self.serialALabel.hidden = NO;
    self.serialBLabel.hidden = NO;
    self.serialCLabel.hidden = NO;
    self.activeButton.hidden = NO;
}

- (NSString *)getLanguageName
{
    NSString *name = nil;
    
    switch (APPDELEGATE.languageType) {
        case Text_Zh:
            name = @"中文";
            break;
        case Text_En:
            name = @"English";
            break;
        case Text_Ru:
            name = @"русский";
            break;
        case Text_Tr:
            name = @"Türk";
            break;
        case Text_Ko:
            name = @"한국어";
            break;
        case Text_It:
            name = @"In Italiano";
            break;
        case Text_Es:
            name = @"El español";
            break;
        case Text_Pt:
            name = @"Português";
            break;
        case Text_Ar:
            name = @"عربي";
            break;
            
        default:
            name = @"English";
            break;
    }
    
    return name;
}

- (void)changeLanuageAction:(UIButton *)button
{
    [[NSNotificationCenter defaultCenter] postNotificationName:Notify_Operation object:nil];
    
    //弹出语言选择界面
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Choose your language" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *cancleAction = [UIAlertAction actionWithTitle:@"Cancle" style:UIAlertActionStyleCancel handler:nil];
    UIAlertAction *ChAction = [UIAlertAction actionWithTitle:@"中文" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        APPDELEGATE.languageType = Text_Zh;
        [self upDateLanguageAction:button newName:@"中文"];
    }];
    
    UIAlertAction *EnAction = [UIAlertAction actionWithTitle:@"English" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        APPDELEGATE.languageType = Text_En;
        [self upDateLanguageAction:button newName:@"English"];
    }];
    
    UIAlertAction *RuAction = [UIAlertAction actionWithTitle:@"русский" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        APPDELEGATE.languageType = Text_Ru;
        [self upDateLanguageAction:button newName:@"русский"];
    }];
    
    UIAlertAction *TrAction = [UIAlertAction actionWithTitle:@"Türk" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        APPDELEGATE.languageType = Text_Tr;
        [self upDateLanguageAction:button newName:@"Türk"];
    }];
    
    UIAlertAction *HgAction = [UIAlertAction actionWithTitle:@"한국어" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        APPDELEGATE.languageType = Text_Ko;
        [self upDateLanguageAction:button newName:@"한국어"];
    }];
    UIAlertAction *YdlAction = [UIAlertAction actionWithTitle:@"In Italiano" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        APPDELEGATE.languageType = Text_It;
        [self upDateLanguageAction:button newName:@"In Italiano"];
    }];
    UIAlertAction *XbyAction = [UIAlertAction actionWithTitle:@"El español" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        APPDELEGATE.languageType = Text_Es;
        [self upDateLanguageAction:button newName:@"El español"];
    }];
    UIAlertAction *PtyAction = [UIAlertAction actionWithTitle:@"Português" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        APPDELEGATE.languageType = Text_Pt;
        [self upDateLanguageAction:button newName:@"Português"];
    }];
    UIAlertAction *AlbAction = [UIAlertAction actionWithTitle:@"عربي" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        APPDELEGATE.languageType = Text_Ar;
        [self upDateLanguageAction:button newName:@"عربي"];
    }];
    
    [alertController addAction:cancleAction];
    
#ifdef USE_ZH
    [alertController addAction:ChAction];
#endif
    
    [alertController addAction:EnAction];
    [alertController addAction:RuAction];
    [alertController addAction:TrAction];
    [alertController addAction:HgAction];
    [alertController addAction:YdlAction];
    [alertController addAction:XbyAction];
    [alertController addAction:PtyAction];
    [alertController addAction:AlbAction];
    
    alertController.popoverPresentationController.sourceView = self.view;
    alertController.popoverPresentationController.sourceRect = CGRectMake(CGRectGetMaxX(button.frame) , CGRectGetMaxY(button.frame)-30, 1.0, 1.0);

    [self presentViewController:alertController animated:YES completion:nil];
    
}

- (void)upDateLanguageAction:(UIButton *)button newName:(NSString *)name
{
    [[NSNotificationCenter defaultCenter] postNotificationName:Notify_Operation object:nil];
    //更换按钮名称
    [button setTitle:name forState:UIControlStateNormal];
    
    //刷新界面
    [[NSNotificationCenter defaultCenter] postNotificationName:Notify_Change_Lanuage object:nil];
    
    if (_waiting.isStartAnimation) {
        _waiting.tipText = [APPDELEGATE.TextDictionary objectForKey:@"Scaning"];
    } else {
        _waiting.tipText = [APPDELEGATE.TextDictionary objectForKey:@"Connected"];
    }
}

- (void)changeLanuageNotify:(NSNotification *)notify
{
    
#ifndef FLOTEQ
    [self setupLogo];
#endif
    
}

- (void)deviceButtonAction:(UIButton *)button
{
    MyLog(@"button.tag : %ld", (long)button.tag);
    [[NSNotificationCenter defaultCenter] postNotificationName:Notify_Operation object:nil];
    
    if ([BluetoothManager sharedInstance].peripheral.state == CBPeripheralStateConnected) {
        //跳转到监控
        UINavigationController *nav = [self.tabBarController.viewControllers objectAtIndex:1];
        MonitorViewController *monitorVC = (MonitorViewController *)nav.viewControllers[0];
        
        if (button.tag < self.imageNameArray.count) {
            monitorVC.deviceImage = [UIImage imageNamed:[self.imageNameArray objectAtIndex:button.tag]];
        }
        
        self.tabBarController.selectedIndex = 1;
    } else {
        MyLog(@"Device not connected!");
        
#ifdef TestImitateBluetoolDevice
        UINavigationController *nav = [self.tabBarController.viewControllers objectAtIndex:1];
        MonitorViewController *monitorVC = (MonitorViewController *)nav.viewControllers[0];
        monitorVC.deviceImage = [UIImage imageNamed:[self.imageNameArray objectAtIndex:button.tag]];
        self.tabBarController.selectedIndex = 1;
#endif
        
    }
    
}

- (void)activeAction
{
    //
    [[BluetoothManager sharedInstance] sendDataWithCommandType:Command_Active];
    [[NSNotificationCenter defaultCenter] postNotificationName:Notify_Operation object:nil];
}

- (void)logoClickAction:(UITapGestureRecognizer *)tap
{
    if (!self.serialALabel.isHidden) {
        //再次读取序列号
        [[BluetoothManager sharedInstance] sendDataWithCommandType:Command_ReadSerialNumber];
        [[NSNotificationCenter defaultCenter] postNotificationName:Notify_Operation object:nil];
    }    
}

//- (void)playMp3WithName:(NSString *)fileName
//{
//    if (_player) {
//        [_player stop];
//    }
//    
//    NSString *soundPath = [NSString stringWithFormat:@"%@/%@", [[NSBundle mainBundle]resourcePath], fileName];
////    NSString *soundPath=[[NSBundle mainBundle] pathForResource:@"Scaning" ofType:@"mp3"];
//    //把音频文件转换成url格式
//    NSURL *url = [NSURL fileURLWithPath:soundPath];
//    AVAudioPlayer *newAudioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:nil];
//    self.player = newAudioPlayer;
////    _player.volume = 1;
//    _player.numberOfLoops = 0;
//    [_player prepareToPlay];
//    
//    
//    [_player play];
//}

@end
