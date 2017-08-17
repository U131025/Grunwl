//
//  MultiPumpViewController.m
//  Grunwl
//
//  Created by mojingyu on 16/7/3.
//  Copyright © 2016年 Mojy. All rights reserved.
//

#import "MultiPumpViewController.h"
#import "MultiPumpBackgroundView.h"
#import "WaitingCircle.h"
#import "myUILabel.h"

@interface MultiPumpViewController ()

@property (nonatomic, strong) myUILabel *bSumLabel;
@property (nonatomic, strong) myUILabel *a1Label;
@property (nonatomic, strong) myUILabel *a2Label;
@property (nonatomic, strong) myUILabel *a3Label;
@property (nonatomic, strong) myUILabel *a4Label;
@property (nonatomic, strong) myUILabel *a5Label;
@property (nonatomic, strong) myUILabel *a6Label;
@property (nonatomic, strong) myUILabel *b1Label;
@property (nonatomic, strong) myUILabel *b2Label;
@property (nonatomic, strong) myUILabel *b3Label;
@property (nonatomic, strong) myUILabel *b4Label;
@property (nonatomic, strong) myUILabel *b5Label;
@property (nonatomic, strong) myUILabel *b6Label;
@property (nonatomic, strong) myUILabel *c1Label;
@property (nonatomic, strong) myUILabel *c2Label;

@property (nonatomic, assign) CGFloat c3;
@property (nonatomic, assign) NSInteger c4;

@property (nonatomic, strong) WaitingCircle *a1Circle;
@property (nonatomic, strong) WaitingCircle *a2Circle;
@property (nonatomic, strong) WaitingCircle *a3Circle;
@property (nonatomic, strong) WaitingCircle *a4Circle;
@property (nonatomic, strong) WaitingCircle *a5Circle;
@property (nonatomic, strong) WaitingCircle *a6Circle;

@property (nonatomic, strong) MultiPumpBackgroundView *backgroundView;
@property (nonatomic, strong) UILabel *errorLabel;
@property (nonatomic, copy) NSArray *errorCodes;    //错误代码
- (void)setupUI;

@end

@implementation MultiPumpViewController

#pragma mark - init Datas
@synthesize c3 = _c3;
@synthesize c4 = _c4;

- (id)init
{
    self =[super init];
    if (self) {
        _c3 = 0.0;
        _c4 = 0.0;
    }
    return self;
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

- (void)setC4:(NSInteger)c4
{
    _c4 = c4;
    if (c4 != 0) {
        //显示错误码
        _errorLabel.hidden = NO;
        _errorLabel.textColor = RedBackgroundColor;
        
        NSInteger index = _c4 - 1;
        if (index < self.errorCodes.count) {
            _errorLabel.text = self.errorCodes[_c4 - 1];
        }
        else {
            BLYLogError(@"errorCodes 索引越界 : %ld", index);
        }
        
        [UIView beginAnimations:@"errorCodeAnimation" context:nil];
        [UIView setAnimationDuration:0.5];
        [UIView setAnimationRepeatCount:HUGE_VALF];
        [UIView setAnimationRepeatAutoreverses:YES];
        
        _errorLabel.layer.opacity = 0;
        [UIView commitAnimations];
    }
    else {
        [_errorLabel.layer removeAllAnimations];
        _errorLabel.hidden = YES;
    }
}

#pragma mark - View Life Cycle
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setupUI];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateATypeDatas:) name:Notify_MultiPumpValues_AType object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateBTypeDatas:) name:Notify_MultiPumpValues_BType object:nil];
   
#ifdef TestImitateBluetoolDevice
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        _a1Label.text = @"0.0 %";
        _a2Label.text = @"0.1 %";
        _a3Label.text = @"0.2 %";
        _a4Label.text = @"0.3 %";
        _a5Label.text = @"0.4 %";
        _a6Label.text = @"0.5 %";
        _c1Label.text = @"0.6 bar";
        
        _b1Label.text = @"0.1 kw";
        _b2Label.text = @"0.2 kw";
        _b3Label.text = @"0.3 kw";
        _b4Label.text = @"0.4 kw";
        _b5Label.text = @"0.5 kw";
        _b6Label.text = @"0.6 kw";
        _c2Label.text = @"0.7 bar";
        
        self.c3 = 6.0;
        self.c4 = 1;
        
        [self updateDisplay];

    });
    
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        _c3 = 3;
//        [self updateDisplay];
//    });
#endif
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [[BluetoothManager sharedInstance] sendDataWithCommandType:Command_MultiPumpIn];
    });
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - setupUI

- (void)setupUI
{
    //load background
    _backgroundView = [[MultiPumpBackgroundView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
    [self.view addSubview:_backgroundView];
    
    CGSize logoTextSize = [GRUNWL sizeWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:Font(28),NSFontAttributeName, nil]];
    
#ifdef FLOTEQ
    UIImage *logoImage = [UIImage imageNamed:@"logo_floteq"];
    UIImageView *logoImageView = [[UIImageView alloc] initWithImage:logoImage];
    logoImageView.backgroundColor = [UIColor whiteColor];
    logoImageView.contentMode = UIViewContentModeScaleAspectFit;
    [self.view addSubview:logoImageView];
    [logoImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(SYRealValue(30));
        make.left.equalTo(self.view);
        make.width.mas_equalTo(logoTextSize.width);
        make.height.mas_equalTo(SYRealValue(60));
    }];
    
#else
    UILabel *logoLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 50, logoTextSize.width, 50)];
    logoLabel.text = GRUNWL;
    logoLabel.textColor = [UIColor whiteColor];
    logoLabel.font = Font(28);
    [self.view addSubview:logoLabel];
#endif
        
    _errorLabel = [[UILabel alloc] initWithFrame:CGRectMake(logoTextSize.width + 50, 100, 100, 30)];
//    _errorLabel.layer.borderColor = [UIColor blackColor].CGColor;
//    _errorLabel.layer.borderWidth = 1;
//    _errorLabel.backgroundColor = [UIColor whiteColor];
//    _errorLabel.textAlignment = NSTextAlignmentCenter;
    _errorLabel.font = Font(23);
    _errorLabel.hidden = YES;
    [self.view addSubview:_errorLabel];
    
    //a1~a6 b1~b6
    CGFloat labelWidth = (ScreenWidth - 150) / 2;
    CGFloat labelHeight = (ScreenHeight - 350) / 6;
    CGFloat spacing = 3;
    CGFloat top = 150;
    CGFloat offsetX = 100;
    CGFloat circleWidth =  MIN (fabs(offsetX - 50.0) , labelHeight-4);
    CGFloat circleOffsetX = (50.0 - circleWidth) / 2;
    
    _a6Label = [self createLabelWithFrame:CGRectMake(offsetX, top - labelHeight/2, labelWidth, labelHeight)];
    _b6Label = [self createLabelWithFrame:CGRectMake(CGRectGetMaxX(_a6Label.frame), CGRectGetMinY(_a6Label.frame), labelWidth, labelHeight)];
    _a6Circle = [[WaitingCircle alloc] initWithFrame:CGRectMake(50+circleOffsetX, CGRectGetMidY(_a6Label.frame)-(circleWidth/2), circleWidth, circleWidth)];
    _a6Circle.text = @"6";
    [self.view addSubview:_a6Circle];
    
    _a5Label = [self createLabelWithFrame:CGRectMake(offsetX, CGRectGetMaxY(_a6Label.frame)+spacing, labelWidth, labelHeight)];
    _b5Label = [self createLabelWithFrame:CGRectMake(CGRectGetMaxX(_a5Label.frame), CGRectGetMinY(_a5Label.frame)+spacing, labelWidth, labelHeight)];
    _a5Circle = [[WaitingCircle alloc] initWithFrame:CGRectMake(50+circleOffsetX, CGRectGetMidY(_a5Label.frame)-(circleWidth/2), circleWidth, circleWidth)];
    _a5Circle.text = @"5";
    [self.view addSubview:_a5Circle];
    
    _a4Label = [self createLabelWithFrame:CGRectMake(offsetX, CGRectGetMaxY(_a5Label.frame)+spacing, labelWidth, labelHeight)];
    _b4Label = [self createLabelWithFrame:CGRectMake(CGRectGetMaxX(_a4Label.frame), CGRectGetMinY(_a4Label.frame), labelWidth, labelHeight)];
    _a4Circle = [[WaitingCircle alloc] initWithFrame:CGRectMake(50+circleOffsetX, CGRectGetMidY(_a4Label.frame)-(circleWidth/2), circleWidth, circleWidth)];
    _a4Circle.text = @"4";
    [self.view addSubview:_a4Circle];
    
    _a3Label = [self createLabelWithFrame:CGRectMake(offsetX, CGRectGetMaxY(_a4Label.frame)+spacing, labelWidth, labelHeight)];
    _b3Label = [self createLabelWithFrame:CGRectMake(CGRectGetMaxX(_a3Label.frame), CGRectGetMinY(_a3Label.frame), labelWidth, labelHeight)];
    _a3Circle = [[WaitingCircle alloc] initWithFrame:CGRectMake(50+circleOffsetX, CGRectGetMidY(_a3Label.frame)-(circleWidth/2), circleWidth, circleWidth)];
    _a3Circle.text = @"3";
    [self.view addSubview:_a3Circle];
    
    _a2Label = [self createLabelWithFrame:CGRectMake(offsetX, CGRectGetMaxY(_a3Label.frame)+spacing, labelWidth, labelHeight)];
    _b2Label = [self createLabelWithFrame:CGRectMake(CGRectGetMaxX(_a2Label.frame), CGRectGetMinY(_a2Label.frame), labelWidth, labelHeight)];
    _a2Circle = [[WaitingCircle alloc] initWithFrame:CGRectMake(50+circleOffsetX, CGRectGetMidY(_a2Label.frame)-(circleWidth/2), circleWidth, circleWidth)];
    _a2Circle.text = @"2";
    [self.view addSubview:_a2Circle];
    
    _a1Label = [self createLabelWithFrame:CGRectMake(offsetX, CGRectGetMaxY(_a2Label.frame)+spacing, labelWidth, labelHeight)];
    _b1Label = [self createLabelWithFrame:CGRectMake(CGRectGetMaxX(_a1Label.frame), CGRectGetMinY(_a1Label.frame), labelWidth, labelHeight)];
    _a1Circle = [[WaitingCircle alloc] initWithFrame:CGRectMake(50+circleOffsetX, CGRectGetMidY(_a1Label.frame)-(circleWidth/2), circleWidth, circleWidth)];
    _a1Circle.text = @"1";
    [self.view addSubview:_a1Circle];    
    
    CGFloat offsetY = 50;
    _c1Label = [self createLabelWithFrame:CGRectMake(10, ScreenHeight-200+offsetY, 120, 50)];
    _c1Label.text = @"bar";
    _c1Label.font = Font(26);
    
    _c2Label = [self createLabelWithFrame:CGRectMake(CGRectGetMaxX(_c1Label.frame), CGRectGetMinY(_c1Label.frame), CGRectGetWidth(_c1Label.frame), CGRectGetHeight(_c1Label.frame))];
    _c2Label.text = @"bar";
    _c2Label.font = Font(26);
    
    _bSumLabel = [self createLabelWithFrame:CGRectMake(CGRectGetMaxX(_a1Label.frame), CGRectGetMinY(_errorLabel.frame), labelWidth, 30)];
    _bSumLabel.text = @"kw";
    
    UIButton *plusButton = [[UIButton alloc] initWithFrame:CGRectMake(ScreenWidth-100, CGRectGetMinY(_c1Label.frame)-30, 100, 60)];
    
    if (IS_IPAD) {
        plusButton.titleLabel.font = Font(80);
    }
    else {
        plusButton.titleLabel.font = Font(50);
    }
    
    [plusButton setTitle:@"+" forState:UIControlStateNormal];
    [plusButton setTitleColor:WhiteColor forState:UIControlStateNormal];
    [plusButton addTarget:self action:@selector(plusAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:plusButton];
    
    UIButton *reduceButton = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetMinX(plusButton.frame), CGRectGetMaxY(plusButton.frame)+20, CGRectGetWidth(plusButton.frame), CGRectGetHeight(plusButton.frame))];
    
    if (IS_IPAD) {
        reduceButton.titleLabel.font = Font(80);
    }
    else {
       reduceButton.titleLabel.font = Font(50);
    }
    
    [reduceButton setTitleColor:WhiteColor forState:UIControlStateNormal];
    [reduceButton setTitle:@"−" forState:UIControlStateNormal];
    [reduceButton addTarget:self action:@selector(reduceAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:reduceButton];
    
    UIButton *homeButton = [[UIButton alloc] initWithFrame:CGRectMake(0, ScreenHeight-50, 100, 50)];
    homeButton.layer.borderColor = BlackColor.CGColor;
    homeButton.layer.borderWidth = 1;
    homeButton.backgroundColor = RGBAlphaColor(9, 108, 189, 1);
    [homeButton setTitle:[APPDELEGATE.TextDictionary objectForKey:@"Home"] forState:UIControlStateNormal];
    [homeButton setTitleColor:WhiteColor forState:UIControlStateNormal];
    [homeButton addTarget:self action:@selector(homeAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:homeButton];
    
    UIButton *operationButton = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetMaxX(homeButton.frame)-1, CGRectGetMinY(homeButton.frame), 150, CGRectGetHeight(homeButton.frame))];
    operationButton.layer.borderColor = BlackColor.CGColor;
    operationButton.layer.borderWidth = 1;
    operationButton.backgroundColor = RGBAlphaColor(9, 108, 189, 1);
    [operationButton setTitleColor:WhiteColor forState:UIControlStateNormal];
    [operationButton setTitle:@"RUN/STOP" forState:UIControlStateNormal];
    [operationButton addTarget:self action:@selector(operateAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:operationButton];
    
    //隐藏按钮
    UIButton *hiddenButton = [[UIButton alloc] initWithFrame:CGRectMake(40, top, 50+labelWidth, labelHeight*6)];
//    hiddenButton.backgroundColor = RGBAlphaColor(100, 100, 0, 0.6);
    [hiddenButton addTarget:self action:@selector(hiddenButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:hiddenButton];
    
    [self initUIText];
}

- (myUILabel *)createLabelWithFrame:(CGRect)frame
{
    myUILabel *label = [[myUILabel alloc] initWithFrame:frame];
    label.font = Font(23);
    label.textAlignment = NSTextAlignmentCenter;
    label.verticalAlignment = VerticalAlignmentMiddle;
    label.textColor = WhiteColor;
    [self.view addSubview:label];
    
    return label;
}

- (void)initUIText
{
    _a1Label.text = @"0 %";
    _a2Label.text = @"0 %";
    _a3Label.text = @"0 %";
    _a4Label.text = @"0 %";
    _a5Label.text = @"0 %";
    _a6Label.text = @"0 %";
    _c1Label.text = @"0 bar";
    
    _b1Label.text = @"0 kw";
    _b2Label.text = @"0 kw";
    _b3Label.text = @"0 kw";
    _b4Label.text = @"0 kw";
    _b5Label.text = @"0 kw";
    _b6Label.text = @"0 kw";
    _c2Label.text = @"0 bar";
    
    [self updateDisplay];
}

- (void)updateDisplay
{
    [self updateByC3];
    [self updateCircle];
    [self updateSum];
}

#pragma mark - Notify
- (void)updateATypeDatas:(NSNotification *)notify
{
    _a1Label.text = [NSString stringWithFormat:@"%@ %%",[notify.userInfo objectForKey:@"A1"]];
    _a2Label.text = [NSString stringWithFormat:@"%@ %%",[notify.userInfo objectForKey:@"A2"]];
    _a3Label.text = [NSString stringWithFormat:@"%@ %%",[notify.userInfo objectForKey:@"A3"]];
    _a4Label.text = [NSString stringWithFormat:@"%@ %%",[notify.userInfo objectForKey:@"A4"]];
    _a5Label.text = [NSString stringWithFormat:@"%@ %%",[notify.userInfo objectForKey:@"A5"]];
    _a6Label.text = [NSString stringWithFormat:@"%@ %%",[notify.userInfo objectForKey:@"A6"]];
    _c1Label.text = [NSString stringWithFormat:@"%@ bar",[notify.userInfo objectForKey:@"C1"]];
    _c2Label.text = [NSString stringWithFormat:@"%@ bar",[notify.userInfo objectForKey:@"C2"]];
    
    [self updateDisplay];
}

- (void)updateBTypeDatas:(NSNotification *)notify
{
    _b1Label.text = [self getBTypeValueWithAType:_a1Label withBlock:^NSString *{
       return [NSString stringWithFormat:@"%@ kw",[notify.userInfo objectForKey:@"B1"]];
    }];
    
    _b2Label.text = [self getBTypeValueWithAType:_a2Label withBlock:^NSString *{
        return [NSString stringWithFormat:@"%@ kw",[notify.userInfo objectForKey:@"B2"]];
    }];
    
    _b3Label.text = [self getBTypeValueWithAType:_a3Label withBlock:^NSString *{
        return [NSString stringWithFormat:@"%@ kw",[notify.userInfo objectForKey:@"B3"]];
    }];
    
    _b4Label.text = [self getBTypeValueWithAType:_a4Label withBlock:^NSString *{
        return [NSString stringWithFormat:@"%@ kw",[notify.userInfo objectForKey:@"B4"]];
    }];
    
    _b5Label.text = [self getBTypeValueWithAType:_a5Label withBlock:^NSString *{
        return [NSString stringWithFormat:@"%@ kw",[notify.userInfo objectForKey:@"B5"]];
    }];
    
    _b6Label.text = [self getBTypeValueWithAType:_a6Label withBlock:^NSString *{
        return [NSString stringWithFormat:@"%@ kw",[notify.userInfo objectForKey:@"B6"]];
    }];
    
    self.c3 = [[notify.userInfo objectForKey:@"C3"] floatValue];
    self.c4 = [[notify.userInfo objectForKey:@"C4"] integerValue];
    
    [self updateDisplay];
}

- (NSString *)getBTypeValueWithAType:(UILabel *)aValue withBlock:(NSString * (^)())block
{
    if ([aValue.text floatValue] < 0.01f) {
        return @"0.0 kw";
    }
    else {
        return block();
//        return [NSString stringWithFormat:@"%@ kw",block()];
    }
}

- (void)updateSum
{
    CGFloat sum = 0.0;
    if (!_b1Label.isHidden)
        sum += [[_b1Label.text stringByReplacingOccurrencesOfString:@"" withString:@"kw"] floatValue];
    if (!_b2Label.isHidden)
        sum += [[_b2Label.text stringByReplacingOccurrencesOfString:@"" withString:@"kw"] floatValue];
    if (!_b3Label.isHidden)
        sum += [[_b3Label.text stringByReplacingOccurrencesOfString:@"" withString:@"kw"] floatValue];
    if (!_b4Label.isHidden)
        sum += [[_b4Label.text stringByReplacingOccurrencesOfString:@"" withString:@"kw"] floatValue];
    if (!_b5Label.isHidden)
        sum += [[_b5Label.text stringByReplacingOccurrencesOfString:@"" withString:@"kw"] floatValue];
    if (!_b6Label.isHidden)
        sum += [[_b6Label.text stringByReplacingOccurrencesOfString:@"" withString:@"kw"] floatValue];
    _bSumLabel.text = [NSString stringWithFormat:@"%.1f kw", sum];
}

- (void)updateCircle
{
    [self updateCircle:_a1Circle byLabel:_a1Label];
    [self updateCircle:_a2Circle byLabel:_a2Label];
    [self updateCircle:_a3Circle byLabel:_a3Label];
    [self updateCircle:_a4Circle byLabel:_a4Label];
    [self updateCircle:_a5Circle byLabel:_a5Label];
    [self updateCircle:_a6Circle byLabel:_a6Label];
    
    if ([self getATypeSum] > 0.01) {
        [self.backgroundView run];
    }
    else {
        [self.backgroundView stop];
    }
}

- (void)updateCircle:(WaitingCircle *)circle byLabel:(UILabel *)label
{
    if ([[label.text stringByReplacingOccurrencesOfString:@"" withString:@"%%"] floatValue] > 0.01) {
        [circle run];
    }
    else {
        [circle stop];
    }
}

- (void)updateByC3
{
    NSInteger value = (int)_c3;
    self.backgroundView.count = value;
    
    _a1Label.hidden = YES;
    _a2Label.hidden = YES;
    _a3Label.hidden = YES;
    _a4Label.hidden = YES;
    _a5Label.hidden = YES;
    _a6Label.hidden = YES;
    _a1Circle.hidden = YES;
    _a2Circle.hidden = YES;
    _a3Circle.hidden = YES;
    _a4Circle.hidden = YES;
    _a5Circle.hidden = YES;
    _a6Circle.hidden = YES;
    _b1Label.hidden = YES;
    _b2Label.hidden = YES;
    _b3Label.hidden = YES;
    _b4Label.hidden = YES;
    _b5Label.hidden = YES;
    _b6Label.hidden = YES;
    
    switch (value) {
        case 6:
            _a6Label.hidden = NO;
            _a6Circle.hidden = NO;
            _b6Label.hidden = NO;
        case 5:
            _a5Label.hidden = NO;
            _a5Circle.hidden = NO;
            _b5Label.hidden = NO;
        case 4:
            _a4Label.hidden = NO;
            _a4Circle.hidden = NO;
            _b4Label.hidden = NO;
        case 3:
            _a3Label.hidden = NO;
            _a3Circle.hidden = NO;
            _b3Label.hidden = NO;
        case 2:
            _a2Label.hidden = NO;
            _a2Circle.hidden = NO;
            _b2Label.hidden = NO;
        case 1:
            _a1Label.hidden = NO;
            _a1Circle.hidden = NO;
            _b1Label.hidden = NO;
            break;
        default:
            break;
    }

    
}

#pragma mark - Action
- (void)plusAction
{
    [[BluetoothManager sharedInstance] sendDataWithCommandType:Command_MultiPumpPlus];
}

- (void)reduceAction
{
    [[BluetoothManager sharedInstance] sendDataWithCommandType:Command_MultiPumpReduce];
}

- (void)homeAction
{
    [[BluetoothManager sharedInstance] sendDataWithCommandType:Command_MultiPumpLeave];
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)operateAction
{
    if ([self getATypeSum] > 0) {
        [[BluetoothManager sharedInstance] sendDataWithCommandType:Command_MultiPumpStop];
    }
    else {
        [[BluetoothManager sharedInstance] sendDataWithCommandType:Command_MultiPumpRun];
    }
}

- (CGFloat)getATypeSum
{
    CGFloat sum = 0.0;
    
    if (!_a1Label.isHidden)
        sum += [[_a1Label.text stringByReplacingOccurrencesOfString:@"" withString:@"%%"] floatValue];
    if (!_a2Label.isHidden)
        sum += [[_a2Label.text stringByReplacingOccurrencesOfString:@"" withString:@"%%"] floatValue];
    if (!_a3Label.isHidden)
        sum += [[_a3Label.text stringByReplacingOccurrencesOfString:@"" withString:@"%%"] floatValue];
    if (!_a4Label.isHidden)
        sum += [[_a4Label.text stringByReplacingOccurrencesOfString:@"" withString:@"%%"] floatValue];
    if (!_a5Label.isHidden)
        sum += [[_a5Label.text stringByReplacingOccurrencesOfString:@"" withString:@"%%"] floatValue];
    if (!_a6Label.isHidden)
        sum += [[_a6Label.text stringByReplacingOccurrencesOfString:@"" withString:@"%%"] floatValue];
    
    return sum;
}

- (void)hiddenButtonClick
{
    [[BluetoothManager sharedInstance] sendDataWithCommandType:Command_hiddenCommand];
}

@end
