//
//  VerifyViewController.m
//  Grunwl
//
//  Created by mojingyu on 16/8/1.
//  Copyright © 2016年 Mojy. All rights reserved.
//

#import "VerifyViewController.h"
#import "BluetoothManager.h"

#define textFieldContent @"1234567890"

@interface VerifyViewController()<UITextFieldDelegate>

@property (nonatomic, strong) UITextField *password;
@property (nonatomic, strong) UITextField *passwordNew;
@property (nonatomic, strong) UILabel *passwordNewLabel;
@property (nonatomic, strong) UILabel *deviceIDLabel;
@property (nonatomic, strong) UIButton *okButton;
@property (nonatomic, strong) UIButton *nextButton;
@property (nonatomic, getter=isVerified, assign) BOOL verified;

@end

@implementation VerifyViewController

@synthesize deviceID = _deviceID;
@synthesize verified = _verified;

- (void)setDeviceID:(NSString *)deviceID
{
    _deviceID = deviceID;
    _deviceIDLabel.text = _deviceID;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.verified = NO;
    
#ifdef FLOTEQ
    UIImage *logoImage = [UIImage imageNamed:@"logo_floteq"];
    UIImageView *logoImageView = [[UIImageView alloc] initWithImage:logoImage];
    logoImageView.backgroundColor = [UIColor whiteColor];
    logoImageView.contentMode = UIViewContentModeScaleAspectFit;
    [self.view addSubview:logoImageView];
    [logoImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(SYRealValue(30));
        make.left.right.equalTo(self.view);
        make.height.mas_equalTo(SYRealValue(60));
    }];
    
#else
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 50, ScreenWidth, 50)];
    titleLabel.backgroundColor = WhiteColor;
    titleLabel.textColor = BlackColor;
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.font = Font(30);
    titleLabel.text = GRUNWL;
    [self.view addSubview:titleLabel];
    
#endif
    
    _deviceIDLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 130, 130, 50)];
    _deviceIDLabel.backgroundColor = WhiteColor;
    _deviceIDLabel.textColor = BlackColor;
    _deviceIDLabel.textAlignment = NSTextAlignmentCenter;
    _deviceIDLabel.font = Font(26);
    _deviceIDLabel.text = _deviceID;
    [self.view addSubview:_deviceIDLabel];
    
    UILabel *passwordLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, CGRectGetMaxY(_deviceIDLabel.frame)+20, ScreenWidth, 30)];
    passwordLabel.textColor = WhiteColor;
    passwordLabel.textAlignment = NSTextAlignmentLeft;
    passwordLabel.font = Font(26);
    passwordLabel.text = @"Password:";
    [self.view addSubview:passwordLabel];
    
    _password = [[UITextField alloc] initWithFrame:CGRectMake(20, CGRectGetMaxY(passwordLabel.frame)+20, ScreenWidth-160, 50)];
    _password.backgroundColor = WhiteColor;
    _password.layer.borderColor = BlackColor.CGColor;
    _password.layer.borderWidth = 1;
    _password.keyboardType = UIKeyboardTypeNumberPad;
    _password.delegate = self;
    _password.text = @"0000";
    
    UIView *leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 20, 50)];
    leftView.backgroundColor = [UIColor clearColor];
    _password.leftView = leftView;
    _password.leftViewMode = UITextFieldViewModeAlways;
    [self.view addSubview:_password];
    
    UIButton *enButton = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_password.frame)+10, CGRectGetMinY(_password.frame), 60, 50)];
    [enButton setTitle:@"EN" forState:UIControlStateNormal];
    enButton.titleLabel.font = Font(26);
    [enButton setTitleColor:WhiteColor forState:UIControlStateNormal];
    [enButton addTarget:self action:@selector(enAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:enButton];
    
    _passwordNewLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, CGRectGetMaxY(_password.frame)+20, ScreenWidth, 30)];
    _passwordNewLabel.textColor = WhiteColor;
    _passwordNewLabel.textAlignment = NSTextAlignmentLeft;
    _passwordNewLabel.font = Font(26);
    _passwordNewLabel.text = @"New Password:";
    _passwordNewLabel.hidden = YES;
    [self.view addSubview:_passwordNewLabel];
    
    _passwordNew = [[UITextField alloc] initWithFrame:CGRectMake(20, CGRectGetMaxY(_passwordNewLabel.frame)+10, ScreenWidth-160, 50)];
    _passwordNew.backgroundColor = WhiteColor;
    _passwordNew.layer.borderColor = BlackColor.CGColor;
    _passwordNew.layer.borderWidth = 1;
    _passwordNew.keyboardType = UIKeyboardTypeNumberPad;
    _passwordNew.delegate = self;
    _passwordNew.hidden = YES;
    
    UIView *leftView2 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 20, 50)];
    leftView2.backgroundColor = [UIColor clearColor];
    _passwordNew.leftView = leftView2;
    _passwordNew.leftViewMode = UITextFieldViewModeAlways;
    [self.view addSubview:_passwordNew];
    
    _okButton = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_passwordNew.frame)+10, CGRectGetMinY(_passwordNew.frame), 60, 50)];
    [_okButton setTitle:@"OK" forState:UIControlStateNormal];
    _okButton.titleLabel.font = Font(26);
    [_okButton setTitleColor:WhiteColor forState:UIControlStateNormal];
    [_okButton addTarget:self action:@selector(changePassword) forControlEvents:UIControlEventTouchUpInside];
    _okButton.hidden = YES;
    [self.view addSubview:_okButton];
    
    _nextButton = [[UIButton alloc] initWithFrame:CGRectMake((ScreenWidth - 100)/2, ScreenHeight - 80, 100, 50)];
    [_nextButton setTitle:@"next" forState:UIControlStateNormal];
    _nextButton.titleLabel.font = Font(26);
    [_nextButton setTitleColor:WhiteColor forState:UIControlStateNormal];
    [_nextButton addTarget:self action:@selector(goToNext) forControlEvents:UIControlEventTouchUpInside];
    _nextButton.hidden = YES;
    [self.view addSubview:_nextButton];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(verifyCallBack) name:Notify_Verify_Device object:nil];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singelClick:)];
    tap.numberOfTapsRequired = 1;
    [self.view addGestureRecognizer:tap];
    
//#ifdef TestImitateBluetoolDevice
//    self.nextButton.hidden = NO;
//    self.passwordNew.hidden = NO;
//    self.passwordNewLabel.hidden = NO;
//    self.okButton.hidden = NO;
//#endif
    
//#ifdef TestOtherDevice
//    self.nextButton.hidden = NO;
//#endif
    
}

- (void)singelClick:(UITapGestureRecognizer *)tap
{
    [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
}

- (void)verifyCallBack
{
    self.verified = YES;
    self.nextButton.hidden = NO;
}

#pragma mark - Button Handle

- (void)enAction
{
    __weak typeof(self) weakSelf = self;
    static BOOL repeat = NO;
    
#ifndef TestImitateBluetoolDevice
    
    CGFloat value = [_password.text floatValue];
    [[BluetoothManager sharedInstance] sendDataWithCommandType:Command_VerifyPassword withValue:value];
#endif
    
    if ([[_password.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] isEqualToString:@"9131"]) {
        
        //
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            //3秒后
            repeat = YES;
        });
    }
    
    if ([[_password.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] isEqualToString:@"9137"]
        && repeat
        && !weakSelf.isVerified) {
        
        weakSelf.nextButton.hidden = NO;
        
    }
    
//    self.nextButton.hidden = NO;
//    [[BluetoothManager sharedInstance] sendDataWithCommandType:Command_VerifyPassword withValue:value getBlock:^(NSData *data) {
//        //如果返回 99 11 33 55 则将验证成功的标识至YES
//        // 接收数据并进行解析
//        @try {
//            Byte value[10] = {0};
//            [data getBytes:&value length:sizeof(value)];
//            
//            if (value[0] == 0x99 && value[1] == 0x11 && value[2] == 0x33 && value[3] == 0x55) {
//                weakSelf.verified = YES;
//                weakSelf.nextButton.hidden = NO;
//            }
//        } @catch (NSException *exception) {
//            return;
//        }
//
//    }];
}

- (void)changePassword
{
    CGFloat value = [_passwordNew.text floatValue];    
    [[BluetoothManager sharedInstance] sendDataWithCommandType:Command_ChangePassword withValue:value];
}

- (void)goToNext
{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

#pragma mark - UITextFieldDelegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    //输入校验
    //先设置只能输入的集合  invertedSet就是将咱们允许输入的字符串的字符找出
    NSCharacterSet *canInputSet = [[NSCharacterSet characterSetWithCharactersInString:textFieldContent] invertedSet];
    //把允许输入的内容转化成数组,再转化成字符串
    NSString *str = [[string componentsSeparatedByCharactersInSet:canInputSet] componentsJoinedByString:@""];
    //判断输入的字符是否包含在允许输入的字符之内
    BOOL isSuccess = [string isEqualToString:str];
    if (!isSuccess)
        return NO;
    
    //内容校验
    NSMutableString *text = [textField.text mutableCopy];
    [text replaceCharactersInRange:range withString:string];
    
    if ([textField isEqual:_password]) {
        
        if (text.length == 4) {
            NSString *value = [NSString stringWithFormat:@"%@%@", _password.text, string];
            [self verifyPassword:value];
        }
        else if (text.length > 4) {
            [self verifyPassword:_password.text];
        }
    }
    
    return text.length <= 4;
}
//
//- (void)textFieldDidEndEditing:(UITextField *)textField
//{
//    if ([textField isEqual:_password]) {
//        
//        [self verifyPassword:_password.text];
//    }
//}

- (void)verifyPassword:(NSString *)password
{
    if (self.isVerified && [password isEqualToString:@"1111"]) {
        //显示 New password
        self.passwordNew.hidden = NO;
        self.passwordNewLabel.hidden = NO;
        self.okButton.hidden = NO;
    }
}

@end
