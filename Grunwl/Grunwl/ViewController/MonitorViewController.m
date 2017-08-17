//
//  MonitorViewController.m
//  Grunwl
//
//  Created by mojingyu on 16/1/30.
//  Copyright © 2016年 Mojy. All rights reserved.
//

#import "MonitorViewController.h"
#import "LightView.h"
#import "StatusView.h"
#import "BluetoothManager.h"
#import "DebugViewController.h"
#import "MultiPumpViewController.h"

@interface MonitorViewController ()

@property (nonatomic, strong) UIImageView *deviceImageView;

@property (nonatomic, strong) LightView *runLightView;          //指示灯
@property (nonatomic, strong) StatusView *d1;
@property (nonatomic, strong) StatusView *d2;
@property (nonatomic, strong) StatusView *d3;
@property (nonatomic, strong) StatusView *d4;
@property (nonatomic, strong) StatusView *d5;
@property (nonatomic, strong) StatusView *d6;
@property (nonatomic, strong) StatusView *d7;
@property (nonatomic, strong) StatusView *d8;

@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, strong) UIButton *turnOn;
@property (nonatomic, strong) UIButton *turnOff;
@property (nonatomic, assign) NSInteger timeValue;
@property (nonatomic, assign) NSInteger d2Value;

@property (nonatomic, copy) NSArray *errorCodes;    //错误代码
@end

@implementation MonitorViewController

- (void)setDeviceImage:(UIImage *)deviceImage
{
    _deviceImage = deviceImage;
    if (_deviceImageView) {
        CGFloat buttonWidth = (ScreenWidth - 4) / 3;
        _deviceImageView.image = [_deviceImage scaleToSize:CGSizeMake(buttonWidth, buttonWidth)];
        
    }    
}

- (id)init
{
    self = [super init];
    if (self) {
        self.timeValue = 0;
    }
    return self;
}

- (void)viewDidLoad
{
     [super viewDidLoad];
    // Do any additional setup after loading the view.   
    
    self.view.backgroundColor = WhiteColor;
    [self setupToolBar:@[[APPDELEGATE.TextDictionary objectForKey:@"Home"],
                         [APPDELEGATE.TextDictionary objectForKey:@"Set"],
                         [APPDELEGATE.TextDictionary objectForKey:@"Help"],
                         [APPDELEGATE.TextDictionary objectForKey:@"Exit"]]];
    [self setupUI];
    [self updateLightColorWithTimeValue:self.timeValue];
    self.d2Value = 0;
    [self clearDXData];
    
    if (APPDELEGATE.enableButtons) {
        [self enableButtonNotify:nil];
    } else {
        [self disalbeButtonNotify:nil];
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateMonitorData:) name:Notify_Update_MonitorData object:nil];
    
}

- (void)startTimer
{
    if (!_timer) {
        _timer = [NSTimer scheduledTimerWithTimeInterval:60 target:self selector:@selector(clearDXData) userInfo:nil repeats:NO];
    }
}

- (void)clearDXData
{
    _d1.midText = @"0";
    _d2.midText = @"0";
    _d3.midText = @"0";
    _d4.midText = @"0";
    _d5.midText = @"0";
    _d6.midText = @"0";
    _d7.midText = @"0";
    _d8.midText = @"0";
}

- (void)cancelTimer
{
    if (_timer.isValid) {
        [_timer invalidate];
    }
    _timer = nil;
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if (APPDELEGATE.monitorDictionary.count > 0) {
        [self setMonitorData:APPDELEGATE.monitorDictionary];
    }

    MyLog(@"%ld", (long)[BluetoothManager sharedInstance].peripheral.state);
    if ([BluetoothManager sharedInstance].peripheral.state != CBPeripheralStateConnected)
        [[BluetoothManager sharedInstance] scanDevice];
}

- (void)updateMonitorData:(NSNotification *)notify
{
    [self setMonitorData:notify.userInfo];
}

- (NSArray *)errorCodes
{
    if (!_errorCodes) {
        _errorCodes = @[@"E.24D", @"E.04D", @"E.34D", @"E.09D", @"E.02D",
                        @"E.FBD", @"E.01D", @"E.0HD", @"E.07D", @"E.08H",
                        @"E.05D", @"E.01D", @"E.0PH", @"E.1FH", @"E.0FD",
                        @"E.0DH", @"E.07", @"E.08", @"E.05", @"E.0H",
                        @"E.SS", @"E.13", @"E.1P", @"E.0F", @"E.1P",
                        @"E.2P", @"E.HP", @"E.HB", @"E.LB", @"E.11",
                        @"E.3P", @"E.5P"];
    }
    return _errorCodes;
}

- (void)setMonitorData:(NSDictionary *)dictionary
{
    [self cancelTimer];
    
    _d1.midText = [dictionary objectForKey:@"D1"];
    _d2.midText = [dictionary objectForKey:@"D2"];
    _d3.midText = [dictionary objectForKey:@"D3"];
    _d4.midText = [dictionary objectForKey:@"D4"];
    _d5.midText = [dictionary objectForKey:@"D5"];
    _d6.midText = [dictionary objectForKey:@"D6"];
    _d7.midText = [dictionary objectForKey:@"D7"];
    _d8.midText = [dictionary objectForKey:@"D8"];
    
    if ([dictionary objectForKey:@"D2"]) {
        self.d2Value = [[dictionary objectForKey:@"D2"] integerValue];
    }
    
    NSInteger d9 = [[dictionary objectForKey:@"D9"] integerValue];  //1...32,对应错误编码
    if (d9 == 0) {
        _runLightView.flickerText = NO;
        
        //显示运行或停止状态
        NSString *runTimeStr = [dictionary objectForKey:@"D4"];
        runTimeStr = runTimeStr ? runTimeStr : @"0";
        
        if (runTimeStr) {
            self.timeValue = [runTimeStr integerValue];
            [self updateLightColorWithTimeValue:self.timeValue];
        }
    }
    else {
       //显示错误编码
        NSInteger index = d9-1;        
        if (index < self.errorCodes.count) {
            _runLightView.timeText = self.errorCodes[d9-1];
        }
        else {
            BLYLogError(@"errorCodes 索引越界 : %ld", index);
        }
        
        _runLightView.textColor = RedBackgroundColor;
        _runLightView.lightColor = [UIColor yellowColor];
        _runLightView.flickerText = YES;
        [_runLightView startLightFlickerWithColor:[UIColor yellowColor]];

    }
    
    [self startTimer];
}

- (void)setD2Value:(NSInteger)d2Value
{
    _d2Value = d2Value;
    if (_d2Value == 0) {
        APPDELEGATE.enableButtons = NO;
        [[NSNotificationCenter defaultCenter] postNotificationName:Notify_Disable_Button object:nil];
    } else {
        APPDELEGATE.enableButtons = YES;
        [[NSNotificationCenter defaultCenter] postNotificationName:Notify_Enable_Button object:nil];

    }
}

- (void)updateLightColorWithTimeValue:(NSInteger)timeValue
{
    if (timeValue > 0) {
        _runLightView.timeText = [APPDELEGATE.TextDictionary objectForKey:@"Run"];
        _runLightView.lightColor = GreenLightColor;
        _runLightView.textColor = GreenLightColor;
        [_runLightView startLightFlickerWithColor:GreenLightColor];
    }
//    else if (timeValue > 0xE000) {
//        _runLightView.timeText = [APPDELEGATE.TextDictionary objectForKey:@"No Error"];
//        _runLightView.lightColor = [UIColor yellowColor];
//        [_runLightView startLightFlickerWithColor:[UIColor yellowColor]];
//    }
    else {
        // = 0
        _runLightView.timeText = [APPDELEGATE.TextDictionary objectForKey:@"Stop"];
        _runLightView.lightColor = RedBackgroundColor;
        _runLightView.textColor = RedBackgroundColor;
        [_runLightView stopLightFlicker];
//        [_runLightView startLightFlickerWithColor:RedBackgroundColor];
    }
}

- (void)buttonClickAction:(UIButton *)button
{
    MyLog(@"button tag :%ld", (long)button.tag);
    [[NSNotificationCenter defaultCenter] postNotificationName:Notify_Operation object:nil];
    
    switch (button.tag) {
        case 0:
            //主页
            self.tabBarController.selectedIndex = 0;
            break;
        case 1:
            //设置
            [self checkPassword];
//            self.tabBarController.selectedIndex = 3;
            break;
        case 2:
            //帮助
            self.tabBarController.selectedIndex = 2;
            break;
        case 3:
            //退出
            [[BluetoothManager sharedInstance] sendDataWithCommandType:Command_Exit];
            [[NSNotificationCenter defaultCenter] postNotificationName:Notify_ExitApp object:nil];
            break;
        default:
            break;
    }
}

- (void)checkPassword
{
    if (APPDELEGATE.isLogin) {
        self.tabBarController.selectedIndex = 3;
        return;
    }
    
    [self inputPasswordOnOKBlock:^(BOOL invalidStatus) {
        if (invalidStatus) {
            //设置
            self.tabBarController.selectedIndex = 3;
        } else {
            [self showTipWithMessage:nil withTitle:[APPDELEGATE.TextDictionary objectForKey:@"Invalid password"] useCancel:NO onOKBlock:nil];
        }
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setupUI
{
    //
    UIImageView *logoImageView = [[UIImageView alloc] init];
    logoImageView.image = [[UIImage imageNamed:LogoImage] scaleToSize:CGSizeMake(280, NavBarHeight)];
    logoImageView.frame = (CGRect){0, 50, 280, NavBarHeight};
    [self.view addSubview:logoImageView];
    
    //
    CGFloat buttonWidth = (ScreenWidth - 4) / 3;
    
    _deviceImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(logoImageView.frame)+5, buttonWidth, buttonWidth)];
    _deviceImageView.image = [_deviceImage scaleToSize:CGSizeMake(buttonWidth, buttonWidth)];
    _deviceImageView.userInteractionEnabled = YES;
    [self.view addSubview:_deviceImageView];
    
    UITapGestureRecognizer *logoTapGestrueRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(logoImageClick:)];
    logoTapGestrueRecognizer.numberOfTapsRequired = 1;
    [_deviceImageView addGestureRecognizer:logoTapGestrueRecognizer];
    
    _runLightView = [[LightView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_deviceImageView.frame)+2, CGRectGetMinY(_deviceImageView.frame), buttonWidth, buttonWidth)];

    [self.view addSubview:_runLightView];
    
    //点击跳转值调试界面
    __weak typeof(self) weakSelf = self;
    
    @try {
        _runLightView.clickBlock = ^(){
            [[NSNotificationCenter defaultCenter] postNotificationName:Notify_Operation object:nil];
            DebugViewController *debugVc = [[DebugViewController alloc] init];
            debugVc.timeValue = weakSelf.timeValue;
            [weakSelf.navigationController pushViewController:debugVc animated:YES];
            
        };
    } @catch (NSException *exception) {
        ;
    } @finally {
        ;
    }
    
    //
    UIView *powerView = [[UIView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_runLightView.frame)+2, CGRectGetMinY(_deviceImageView.frame), buttonWidth, buttonWidth)];
    powerView.layer.borderColor = BlackColor.CGColor;
    powerView.layer.borderWidth = 1;
    powerView.backgroundColor = BlueBackgroundColor;
    [self.view addSubview:powerView];
    
    //turn on
    UIButton *turnOn = [[UIButton alloc] initWithFrame:CGRectMake(20, 20, buttonWidth - 40, buttonWidth/2 - 24)];
    turnOn.backgroundColor = GreenBackgroundColor;
    [turnOn setTitle:[APPDELEGATE.TextDictionary objectForKey:@"Run"] forState:UIControlStateNormal];
    [turnOn addTarget:self action:@selector(turnOnAction) forControlEvents:UIControlEventTouchUpInside];
    self.turnOn = turnOn;
    if (APPDELEGATE.isPad) {
        turnOn.frame = (CGRect){30, 20, buttonWidth - 60, buttonWidth/2 - 30};
        turnOn.titleLabel.font = Font(30);
    }
    
    [powerView addSubview:turnOn];
    
    //turn off
    UIButton *turnOff = [[UIButton alloc] initWithFrame:CGRectMake(20, CGRectGetMaxY(turnOn.frame)+8, buttonWidth - 40, CGRectGetHeight(turnOn.frame))];
    self.turnOff = turnOff;
    turnOff.backgroundColor = RedBackgroundColor;
    [turnOff setTitle:[APPDELEGATE.TextDictionary objectForKey:@"Stop"] forState:UIControlStateNormal];
    [turnOff addTarget:self action:@selector(turnOffAction) forControlEvents:UIControlEventTouchUpInside];
    if (APPDELEGATE.isPad) {
        turnOff.frame = (CGRect){30, buttonWidth-CGRectGetHeight(turnOn.frame)-20, buttonWidth - 60, CGRectGetHeight(turnOn.frame)};
        turnOff.titleLabel.font = Font(30);
    }
    [powerView addSubview:turnOff];
    
    CGFloat cellHeight = (ScreenHeight - CGRectGetMaxY(_runLightView.frame) - self.toolBarView.height - 50) / 3;
    CGFloat cellWidth = buttonWidth;
    
    //
    CGFloat offsetX = 0;
    CGFloat offsetY = CGRectGetMaxY(_runLightView.frame) + 20;
    _d3 = [self createStatueViewWithFrame:CGRectMake(offsetX, offsetY, cellWidth, cellHeight) withTitles:@[[APPDELEGATE.TextDictionary objectForKey:@"Runing time"], @"", @"h"]];
    offsetX += cellWidth + 2;
    
    _d4 = [self createStatueViewWithFrame:CGRectMake(offsetX, offsetY, cellWidth, cellHeight) withTitles:@[[APPDELEGATE.TextDictionary objectForKey:@"Speed"], @"", @"%"]];
    offsetX += cellWidth + 2;
    
    _d5 = [self createStatueViewWithFrame:CGRectMake(offsetX, offsetY, cellWidth, cellHeight) withTitles:@[[APPDELEGATE.TextDictionary objectForKey:@"Output power"], @"", @"kw"]];
    offsetX = 0;
    offsetY += 5 + cellHeight;
    
    _d6 = [self createStatueViewWithFrame:CGRectMake(offsetX, offsetY, cellWidth, cellHeight) withTitles:@[[APPDELEGATE.TextDictionary objectForKey:@"DC voltage"], @"", @"V"]];
    offsetX += cellWidth + 2;
    
    _d7 =  [self createStatueViewWithFrame:CGRectMake(offsetX, offsetY, cellWidth, cellHeight) withTitles:@[[APPDELEGATE.TextDictionary objectForKey:@"Output current"], @"", @"A"]];
    offsetX += cellWidth + 2;
    
    _d8 = [self createStatueViewWithFrame:CGRectMake(offsetX, offsetY, cellWidth, cellHeight) withTitles:@[[APPDELEGATE.TextDictionary objectForKey:@"Output frequen"], @"", @"Hz"]];
    offsetX = 0;
    offsetY += 5 + cellHeight;
    
    _d2 = [self createStatueViewWithFrame:CGRectMake(offsetX, offsetY, cellWidth, cellHeight) withTitles:@[[APPDELEGATE.TextDictionary objectForKey:@"Set pressure"], @"", @"Bar"]];
    offsetX += cellWidth + 2;
    
    //加减按钮
    UIButton *plusButton = [[UIButton alloc] initWithFrame:CGRectMake(offsetX, offsetY, cellWidth, (cellHeight-4)/2)];
    plusButton.backgroundColor = BlueBackgroundColor;
    plusButton.layer.borderColor = BlackColor.CGColor;
    plusButton.layer.borderWidth = 1;
    
    if (APPDELEGATE.isPad)
        plusButton.titleLabel.font = Font(30);
    else
        plusButton.titleLabel.font = Font(18);
    
    [plusButton setTitle:@"+" forState:UIControlStateNormal];
    [plusButton setTitleColor:WhiteColor forState:UIControlStateNormal];
    [plusButton addTarget:self action:@selector(plusClickUpAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:plusButton];
    
    UIButton *reduceButton = [[UIButton alloc] initWithFrame:CGRectMake(offsetX, CGRectGetMaxY(plusButton.frame)+4, cellWidth, CGRectGetHeight(plusButton.frame))];
    reduceButton.backgroundColor = BlueBackgroundColor;
    reduceButton.layer.borderColor = BlackColor.CGColor;
    reduceButton.layer.borderWidth = 1;
    
    if (APPDELEGATE.isPad)
        reduceButton.titleLabel.font = Font(36);
    else
        reduceButton.titleLabel.font = Font(18);
    
    [reduceButton setTitle:@"−" forState:UIControlStateNormal];
    [reduceButton setTitleColor:WhiteColor forState:UIControlStateNormal];
    [reduceButton addTarget:self action:@selector(reduceClickUpAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:reduceButton];
    
    offsetX += cellWidth + 2;
    _d1 = [self createStatueViewWithFrame:CGRectMake(offsetX, offsetY, cellWidth, cellHeight) withTitles:@[[APPDELEGATE.TextDictionary objectForKey:@"Actual pressure"], @"", @"Bar"]];
}

- (void)reduceClickDownAction
{
    [[NSNotificationCenter defaultCenter] postNotificationName:Notify_Operation object:nil];
    MyLog(@"reduce down");
    [[BluetoothManager sharedInstance] sendDataWithCommandType:Command_ReduceDown];
}

- (void)reduceClickUpAction
{
    [[NSNotificationCenter defaultCenter] postNotificationName:Notify_Operation object:nil];
    MyLog(@"reduce up");
    [[BluetoothManager sharedInstance] sendDataWithCommandType:Command_ReduceUp];
}

- (void)plusClickDownAction
{
    [[NSNotificationCenter defaultCenter] postNotificationName:Notify_Operation object:nil];
    MyLog(@"plus down");
    [[BluetoothManager sharedInstance] sendDataWithCommandType:Command_PlusDown];
}

- (void)plusClickUpAction
{
    [[NSNotificationCenter defaultCenter] postNotificationName:Notify_Operation object:nil];
    MyLog(@"plus up");
    [[BluetoothManager sharedInstance] sendDataWithCommandType:Command_PlusUp];
}

- (StatusView *)createStatueViewWithFrame:(CGRect)frame withTitles:(NSArray *)titleArray
{
    StatusView *statueView = [[StatusView alloc] initWithFrame:frame];
    
    if (titleArray.count == 3) {
        statueView.topText = [titleArray objectAtIndex:0];
        statueView.midText = [titleArray objectAtIndex:1];
        statueView.bottomText = [titleArray objectAtIndex:2];
    }
    
    [self.view addSubview:statueView];
    return statueView;
}

- (void)turnOnAction
{
    [[NSNotificationCenter defaultCenter] postNotificationName:Notify_Operation object:nil];
    //
    [[BluetoothManager sharedInstance] sendDataWithCommandType:Command_PowerOn];
}

- (void)turnOffAction
{
    [[NSNotificationCenter defaultCenter] postNotificationName:Notify_Operation object:nil];
    //
    [[BluetoothManager sharedInstance] sendDataWithCommandType:Command_PowerOff];
}

- (void)changeLanuageNotify:(NSNotification *)notify
{
    [self.turnOn setTitle:[APPDELEGATE.TextDictionary objectForKey:@"Run"] forState:UIControlStateNormal];
    [self.turnOff setTitle:[APPDELEGATE.TextDictionary objectForKey:@"Stop"] forState:UIControlStateNormal];
    
    _d1.topText= [APPDELEGATE.TextDictionary objectForKey:@"Actual pressure"];
    _d2.topText = [APPDELEGATE.TextDictionary objectForKey:@"Set pressure"];
    _d3.topText = [APPDELEGATE.TextDictionary objectForKey:@"Runing time"];
    _d4.topText = [APPDELEGATE.TextDictionary objectForKey:@"Speed"];
    _d5.topText = [APPDELEGATE.TextDictionary objectForKey:@"Output power"];
    _d6.topText = [APPDELEGATE.TextDictionary objectForKey:@"DC voltage"];
    _d7.topText = [APPDELEGATE.TextDictionary objectForKey:@"Output current"];
    _d8.topText = [APPDELEGATE.TextDictionary objectForKey:@"Output frequen"];
    
    [self setupToolBar:@[[APPDELEGATE.TextDictionary objectForKey:@"Home"],
                         [APPDELEGATE.TextDictionary objectForKey:@"Set"],
                         [APPDELEGATE.TextDictionary objectForKey:@"Help"],
                         [APPDELEGATE.TextDictionary objectForKey:@"Exit"]]];
    
    [self updateLightColorWithTimeValue:self.timeValue];
}

//
- (void)enableButtonNotify:(NSNotification *)notify
{
    self.turnOn.enabled = YES;
    self.turnOn.backgroundColor = GreenBackgroundColor;
    self.turnOff.enabled = YES;
    self.turnOff.backgroundColor = RedBackgroundColor;
}

- (void)disalbeButtonNotify:(NSNotification *)notify
{
    self.turnOn.enabled = NO;
    self.turnOn.backgroundColor = [UIColor lightGrayColor];
    self.turnOff.enabled = NO;
    self.turnOff.backgroundColor = [UIColor lightGrayColor];
}

- (void)logoImageClick:(UITapGestureRecognizer *)tap
{
    MultiPumpViewController *viewController = [[MultiPumpViewController alloc] init];
    [self.navigationController pushViewController:viewController animated:YES];
}

@end
