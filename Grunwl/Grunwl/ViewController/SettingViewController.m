//
//  SettingViewController.m
//  Grunwl
//
//  Created by mojingyu on 16/1/30.
//  Copyright © 2016年 Mojy. All rights reserved.
//

#import "SettingViewController.h"
#import "settingCellView.h"
#import "BluetoothManager.h"
#import "InputHelper.h"

@interface SettingViewController ()<SettingCellViewDelegate, UITextFieldDelegate>
@property (nonatomic, strong) NSMutableArray *settingConfigArray; //of SettingCellView
@property (nonatomic, strong) UIView *backgroundView;
@property (nonatomic, strong) NSMutableDictionary *axConfigDictionary;    // of settingCellView
@property (nonatomic, copy) NSArray *settingConfigTextArray;
@end

@implementation SettingViewController

@synthesize settingConfigTextArray = _settingConfigTextArray;

- (NSMutableDictionary *)axConfigDictionary
{
    if (!_axConfigDictionary) {
        _axConfigDictionary = [[NSMutableDictionary alloc] init];
    }
    return _axConfigDictionary;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self loadUI];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateConfigValue:) name:Notify_Recive_SettingData object:nil];
    
    if (APPDELEGATE.enableButtons) {
        [self enableButtonNotify:nil];
    } else {
        [self disalbeButtonNotify:nil];
    }
    
    [self resetTimer];
}

- (void)updateConfigValue:(NSNotification *)notify
{
    NSInteger index = 1;
    NSArray *keys = [self.axConfigDictionary allKeys];
    
    for (NSString *key in keys) {
        
        NSString *value = [notify.userInfo objectForKey:key];
        if ([key isEqualToString:@"A9"]) {
            value = [NSString stringWithFormat:@"%@ M", value];
        } else if ([key isEqualToString:@"A12"]) {
            value = [NSString stringWithFormat:@"%@ %%", value];
        } else {
            value = [NSString stringWithFormat:@"%@ S", value];
        }
        
        settingCellView *cell = [self.axConfigDictionary objectForKey:key];
        cell.valueText = value;
        
        index++;
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if ([BluetoothManager sharedInstance].peripheral.state != CBPeripheralStateConnected)
        [[BluetoothManager sharedInstance] scanDevice];
    
    double delaySeconds = 1;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delaySeconds *NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^{
        
        [[BluetoothManager sharedInstance] sendDataWithCommandType:Command_ReadConfig];
    });
    
    NSString *password = [[NSUserDefaults standardUserDefaults] objectForKey:@"Password"];
    if (!password || [password isEqualToString:@""]) {
        //提示输入密码
    }

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)buttonClickAction:(UIButton *)button
{
    [[NSNotificationCenter defaultCenter] postNotificationName:Notify_Operation object:nil];
    switch (button.tag) {
        case 0:
            //主页
            self.tabBarController.selectedIndex = 0;
            break;
        case 1:
            //帮助
            self.tabBarController.selectedIndex = 2;
            break;
        case 2:
            //主控
            self.tabBarController.selectedIndex = 1;
            break;
        default:
            break;
    }
}

- (void)setupUI
{
    self.backgroundView = [[UIView alloc] initWithFrame:self.view.frame];
    [self.view addSubview:self.backgroundView];
    
    [self setupLogoWithOriginY:20 isShowText:YES withView:self.backgroundView];
    
    CGFloat fontSize = 18;
    if (APPDELEGATE.isPad)
        fontSize = 30;
    
    UIButton *readButton = [[UIButton alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(self.logoImageView.frame)+5, 110, 40)];
    if (APPDELEGATE.isPad)
        readButton.frame = (CGRect){20, CGRectGetMaxY(self.logoImageView.frame)+5, 250, 80};
    
    readButton.layer.borderColor = BlackColor.CGColor;
    readButton.layer.borderWidth = 1;
    readButton.backgroundColor = DarkGreenBackgroundColor;
    readButton.titleLabel.font = Font(fontSize);
    readButton.titleLabel.numberOfLines = 0;
    readButton.titleLabel.textAlignment = NSTextAlignmentCenter;
    [readButton setTitle:[APPDELEGATE.TextDictionary objectForKey:@"Read parameters"] forState:UIControlStateNormal];
    [readButton setTitleColor:BlackColor forState:UIControlStateNormal];
    [readButton addTarget:self action:@selector(readConfig) forControlEvents:UIControlEventTouchUpInside];
    [self.backgroundView addSubview:readButton];
        
    CGFloat offsetY = CGRectGetMaxY(readButton.frame)+10;
    
    CGFloat cellHeight = (ScreenHeight - CGRectGetMaxY(readButton.frame) - 50 - 20) / self.settingConfigTextArray.count;
    if (APPDELEGATE.isPad)
        cellHeight = (ScreenHeight - CGRectGetMaxY(readButton.frame) - 100 - 20) / self.settingConfigTextArray.count;
    
    CGFloat cellWidth = ScreenWidth;
    
    [self.axConfigDictionary removeAllObjects];
    for (int i = 0; i < self.settingConfigTextArray.count; i++) {
        
        NSDictionary *dic = [self.settingConfigTextArray objectAtIndex:i];
        NSString *name = [dic objectForKey:@"name"];
        NSString *tagStr = [dic objectForKey:@"tag"];
        //
        settingCellView *cellView = [[settingCellView alloc] initWithFrame:CGRectMake(0, offsetY, cellWidth, cellHeight)];
        [self.backgroundView addSubview:cellView];
        
        if (i == 0 || i == 1 || i == 2 || i == 5 || i == 9) {
            cellView.keyboardType = ValidationTypeNumberPoint;
        } else {
            cellView.keyboardType = ValidationTypeNumberInt;
        }
        
        if ([tagStr intValue] == 9) {
            //a9
            cellView.placeholder = @"M";
        } else if ([tagStr intValue] == 12) {
            //a12
            cellView.placeholder = @"%";
        } else {
            cellView.placeholder = @"S";
        }
        
        cellView.tag = i;
        cellView.titleText = name;
        cellView.delegate = self;
        cellView.valueTextField.delegate = self;
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(resetTimer)];
        tap.numberOfTapsRequired = 1;
        [cellView addGestureRecognizer:tap];
        
        NSString *key = [NSString stringWithFormat:@"A%@", tagStr];
        [self.axConfigDictionary setObject:cellView forKey:key];
        
        offsetY += cellHeight;
    }
    return;
}

- (void)readConfig
{
    [self resetTimer];
    //读取设置
    [[BluetoothManager sharedInstance] sendDataWithCommandType:Command_ReadConfig];    
}

#pragma settingConfigViewDelegate
- (void)settingCellViewButtonClick:(NSInteger)tag withValue:(NSString *)value
{
    [self resetTimer];
    MyLog(@"setting Config Index: %ld", (long)tag);
    
    NSDictionary *dic = [self.settingConfigTextArray objectAtIndex:tag];
    NSInteger index = [[dic objectForKey:@"tag"] integerValue];
    CGFloat fValue = [value floatValue];
    MyLog(@"fValue: %f", fValue);
    
    //
//    NSData *sendData;
    switch (index) {
        case 1:
            //加速时间
            [[BluetoothManager sharedInstance] sendDataWithCommandType:Command_SetA1 withValue:fValue];
            break;
        case 2:
            [[BluetoothManager sharedInstance] sendDataWithCommandType:Command_SetA2 withValue:fValue];
            break;
        case 3:
            [[BluetoothManager sharedInstance] sendDataWithCommandType:Command_SetA3 withValue:fValue];
            break;
        case 4:
            [[BluetoothManager sharedInstance] sendDataWithCommandType:Command_SetA4 withValue:fValue];
            break;
        case 5:
            [[BluetoothManager sharedInstance] sendDataWithCommandType:Command_SetA5 withValue:fValue];
            break;
        case 6:
            [[BluetoothManager sharedInstance] sendDataWithCommandType:Command_SetA6 withValue:fValue];
            break;
        case 7:
            [[BluetoothManager sharedInstance] sendDataWithCommandType:Command_SetA7 withValue:fValue];
            break;
        case 8:
            [[BluetoothManager sharedInstance] sendDataWithCommandType:Command_SetA8 withValue:fValue];
            break;
        case 9:
            [[BluetoothManager sharedInstance] sendDataWithCommandType:Command_SetA9 withValue:fValue];
            break;
        case 10:
            [[BluetoothManager sharedInstance] sendDataWithCommandType:Command_SetA10 withValue:fValue];
            break;
        case 11:
            [[BluetoothManager sharedInstance] sendDataWithCommandType:Command_SetA11 withValue:fValue];
            break;
        case 12:
            [[BluetoothManager sharedInstance] sendDataWithCommandType:Command_SetA12 withValue:fValue];
            break;
            
        default:
            break;
    }
    
    //显示发送的命名
//    NSString *title = [dic objectForKey:@"name"];
//    title = [NSString stringWithFormat:@"设置%@", title];
//    
//    NSString *message = [NSString stringWithFormat:@"输入值：%@\n命令：%@", value, sendData];
//    [self showTipMessage:message withTitle:title];
    
    //3秒后读取参数
    double delaySeconds = 3;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delaySeconds *NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^{
        
        [[BluetoothManager sharedInstance] sendDataWithCommandType:Command_ReadConfig];
    });
}

- (void)showTipMessage:(NSString *)message withTitle:(NSString *)title
{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *cancleAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:nil];
    
    [alertController addAction:cancleAction];
    [self presentViewController:alertController animated:YES completion:nil];
}

- (void)showSendDataTip:(NSData *)sendData withTitle:(NSString *)title
{
    NSString *tip = [NSString stringWithFormat:@"%@", sendData];
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:tip preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *cancleAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:nil];
    
    [alertController addAction:cancleAction];
    [self presentViewController:alertController animated:YES completion:nil];
}

- (void)changeLanuageNotify:(NSNotification *)notify
{
    [self loadUI];
}

- (void)loadUI
{
    _settingConfigTextArray = @[@{@"name":[APPDELEGATE.TextDictionary objectForKey:@"Pid Time"],@"tag":@"1"},
                                //                                       @{@"name":@"响应减速时间",@"tag":@"2"},
                                @{@"name":[APPDELEGATE.TextDictionary objectForKey:@"Breaking protection delay"],@"tag":@"3"},
                                @{@"name":[APPDELEGATE.TextDictionary objectForKey:@"Pipeline coefficient"],@"tag":@"4"},
                                //                                        @{@"name":@"睡眠检测时间",@"tag":@"5"},
                                @{@"name":[APPDELEGATE.TextDictionary objectForKey:@"Water deficient delay"],@"tag":@"6"},
                                @{@"name":[APPDELEGATE.TextDictionary objectForKey:@"Antifreeze interval time"],@"tag":@"7"},
                                @{@"name":[APPDELEGATE.TextDictionary objectForKey:@"Antifreezing work time"],@"tag":@"8"},
                                @{@"name":[APPDELEGATE.TextDictionary objectForKey:@"Auto changeover delay"],@"tag":@"9"},
                                @{@"name":[APPDELEGATE.TextDictionary objectForKey:@"Add pump delay"],@"tag":@"10"},
                                @{@"name":[APPDELEGATE.TextDictionary objectForKey:@"Reduc pump delay"],@"tag":@"11"},
                                @{@"name":[APPDELEGATE.TextDictionary objectForKey:@"Reduc pump coefficient"],@"tag":@"12"}];
    
    [self.view removeAllSubviews];
    [self setupUI];
    [self setupToolBar:@[[APPDELEGATE.TextDictionary objectForKey:@"Home"],
                         [APPDELEGATE.TextDictionary objectForKey:@"Help"],
                         [APPDELEGATE.TextDictionary objectForKey:@"control"]]];
    
    [inputHelper setupInputHelperForView:self.backgroundView withDismissType:InputHelperDismissTypeTapGusture];
}

- (void)enableButtonNotify:(NSNotification *)notify
{
    NSArray *keys = [self.axConfigDictionary allKeys];
    for (NSString *key in keys) {
        settingCellView *view = (settingCellView *)[self.axConfigDictionary objectForKey:key];
        [view enableOKButton];
    }
}

- (void)disalbeButtonNotify:(NSNotification *)notify
{
    NSArray *keys = [self.axConfigDictionary allKeys];
    for (NSString *key in keys) {
        settingCellView *view = (settingCellView *)[self.axConfigDictionary objectForKey:key];
        [view disableOKButton];
    }
}

- (void)resetTimer
{
    [[NSNotificationCenter defaultCenter] postNotificationName:Notify_Operation object:nil];
    [self startTimerWithSeconds:ReturnControlPageTimeOutVlaue onEndBlock:^{
        //return to control
        self.tabBarController.selectedIndex = 1;
    }];
}

#pragma UITextFieldDelegate
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    [self resetTimer];
}

@end
