//
//  DebugViewController.m
//  Grunwl
//
//  Created by mojingyu on 16/4/3.
//  Copyright © 2016年 Mojy. All rights reserved.
//

#import "DebugViewController.h"
#import "StatusView.h"
#import "LightView.h"
#import "PercentageView.h"
#import "BluetoothManager.h"
#import "BluetoothCommand.h"

@interface DebugViewController()

@property (nonatomic, strong) LightView *runLightView;          //指示灯
@property (nonatomic, strong) StatusView *d1;
@property (nonatomic, strong) StatusView *d2;
//@property (nonatomic, strong) StatusView *d3;
@property (nonatomic, strong) StatusView *d4;
@property (nonatomic, strong) StatusView *d5;
//@property (nonatomic, strong) StatusView *d6;
@property (nonatomic, strong) StatusView *d7;
@property (nonatomic, strong) StatusView *d8;

@property (nonatomic, strong) NSTimer *timer;

@property (nonatomic, strong) PercentageView *d1Slider;
@property (nonatomic, strong) PercentageView *d2Slider;
@property (nonatomic, strong) PercentageView *d4Slider;


@end

@implementation DebugViewController

- (id)init
{
    self = [super init];
    if (self) {
        //init parameter
        self.timeValue = 0;
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //
    self.view.backgroundColor = WhiteColor;
    
    [self setupUI];
    [self updateLightColorWithTimeValue:self.timeValue];
    [self clearDXData];
    
    if (APPDELEGATE.monitorDictionary.count > 0) {
        [self setMonitorData:APPDELEGATE.monitorDictionary];
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateMonitorData:) name:Notify_Update_MonitorData object:nil];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];    
    [self cancelTimer];
    [super viewDidDisappear:animated];
}

- (void)setupUI
{
    CGFloat ratio = 1.0;
    if (APPDELEGATE.isPad) {
        ratio = 1.5;
    }
    
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
    [self.view addSubview:scrollView];
    
    //
    UIImageView *logoImageView = [[UIImageView alloc] init];
    logoImageView.image = [[UIImage imageNamed:LogoImage] scaleToSize:CGSizeMake(280, NavBarHeight)];
    logoImageView.frame = (CGRect){0, 50, 280, NavBarHeight};
    [scrollView addSubview:logoImageView];
        
    //
    CGFloat buttonWidth = (ScreenWidth - 4) / 3;
    
    CGFloat offsetX = 0;
    CGFloat offsetY = CGRectGetMaxY(logoImageView.frame) + 5;
    
    CGFloat cellHeight = 100*ratio;
    CGFloat cellWidth = buttonWidth;
    
    _d7 =  [self createStatueViewWithFrame:CGRectMake(offsetX, offsetY, cellWidth, cellHeight) withTitles:@[[APPDELEGATE.TextDictionary objectForKey:@"Output current"], @"", @"A"] parentView:scrollView];
    offsetX += cellWidth + 2;
    
    _d8 = [self createStatueViewWithFrame:CGRectMake(offsetX, offsetY, cellWidth, cellHeight) withTitles:@[[APPDELEGATE.TextDictionary objectForKey:@"Output frequen"], @"", @"Hz"] parentView:scrollView];
    offsetX += cellWidth + 2;
    
    _d5 = [self createStatueViewWithFrame:CGRectMake(offsetX, offsetY, cellWidth, cellHeight) withTitles:@[[APPDELEGATE.TextDictionary objectForKey:@"Output power"], @"", @"kw"] parentView:scrollView];
    offsetX = 0;
    offsetY += 5 + cellHeight;
    
    _d2 = [self createStatueViewWithFrame:CGRectMake(offsetX, offsetY, cellWidth, cellHeight) withTitles:@[[APPDELEGATE.TextDictionary objectForKey:@"Set pressure"], @"", @"Bar"] parentView:scrollView];
    offsetX += cellWidth + 2;
    
    _d1 = [self createStatueViewWithFrame:CGRectMake(offsetX, offsetY, cellWidth, cellHeight) withTitles:@[[APPDELEGATE.TextDictionary objectForKey:@"Actual pressure"], @"", @"Bar"] parentView:scrollView];
    offsetX += cellWidth + 2;
    
    _d4 = [self createStatueViewWithFrame:CGRectMake(offsetX, offsetY, cellWidth, cellHeight) withTitles:@[[APPDELEGATE.TextDictionary objectForKey:@"Speed"], @"", @"%"] parentView:scrollView];
    
    //添加百分比界面
    CGFloat bodyViewHeight = ScreenHeight - 110 - CGRectGetMaxY(_d4.frame) - 10;
    if (IS_IPAD)
        bodyViewHeight = ScreenHeight - 170 - CGRectGetMaxY(_d4.frame) - 10;
    
    if (bodyViewHeight < 160)
        bodyViewHeight = 160;
    
    UIView *bodyView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_d4.frame)+5, ScreenWidth, bodyViewHeight)];
    bodyView.backgroundColor = BlueBackgroundColor;
    [scrollView addSubview:bodyView];
    
    CGFloat sliderWidth = 40;
    if (APPDELEGATE.isPad)
        sliderWidth = 60;
    
    offsetX = 20;
    _d2Slider = [[PercentageView alloc] initWithFrame:CGRectMake(offsetX, 1, sliderWidth, bodyViewHeight-2)];
    _d2Slider.maxValue = 20.0;
    _d2Slider.processValue = 0;
    [bodyView addSubview:_d2Slider];
    
    offsetX = (ScreenWidth - sliderWidth) /2;
    _d1Slider = [[PercentageView alloc] initWithFrame:CGRectMake(offsetX, 1, sliderWidth, bodyViewHeight-2)];
    _d1Slider.maxValue = 20.0;
    _d1Slider.processValue = 0;
    [bodyView addSubview:_d1Slider];
    
    offsetX = ScreenWidth - sliderWidth - 20;
    _d4Slider = [[PercentageView alloc] initWithFrame:CGRectMake(offsetX, 1, sliderWidth, bodyViewHeight-2)];
    _d4Slider.maxValue = 100;
    _d4Slider.processValue = 0;
    [bodyView addSubview:_d4Slider];
    
    //    buttonWidth = CGRectGetMinX(_d1Slider.frame) - CGRectGetMaxX(_d2Slider.frame) - 20;
    buttonWidth = 74;
    if (APPDELEGATE.isPad)
        buttonWidth = 74*2;
    
    offsetX = (CGRectGetMinX(_d1Slider.frame) - CGRectGetMaxX(_d2Slider.frame) - buttonWidth) / 2;
    CGFloat spacingValue = (bodyView.height - buttonWidth*2) / 3;
    
    UIButton *debugButton = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_d2Slider.frame)+offsetX, spacingValue, buttonWidth, buttonWidth)];
    debugButton.layer.cornerRadius = buttonWidth/2;
    debugButton.layer.borderWidth = 1;
    debugButton.layer.borderColor = BlackColor.CGColor;
    debugButton.backgroundColor = RGBFromColor(0x2bd541);
    [debugButton setTitle:[APPDELEGATE.TextDictionary objectForKey:@"Debug"] forState:UIControlStateNormal];
    [debugButton addTarget:self action:@selector(debugButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [bodyView addSubview:debugButton];
    
    offsetY = CGRectGetMaxY(debugButton.frame) + spacingValue;
    UIButton *stopButton = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_d2Slider.frame)+offsetX, offsetY, buttonWidth, buttonWidth)];
    stopButton.layer.cornerRadius = buttonWidth / 2;
    stopButton.layer.borderColor = BlackColor.CGColor;
    stopButton.layer.borderWidth = 1;
    stopButton.backgroundColor = RedBackgroundColor;
    [stopButton setTitle:[APPDELEGATE.TextDictionary objectForKey:@"Stop"] forState:UIControlStateNormal];
    [stopButton addTarget:self action:@selector(stopButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [bodyView addSubview:stopButton];
    
    offsetY = (bodyView.height - buttonWidth) / 2;
    _runLightView = [[LightView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_d1Slider.frame)+offsetX, offsetY, buttonWidth, buttonWidth)];
    [_runLightView setIsShowText:NO];
    
    __weak typeof(self) weakSelf = self;
    _runLightView.clickBlock = ^() {
        [[NSNotificationCenter defaultCenter] postNotificationName:Notify_Operation object:nil];
        [weakSelf.navigationController popViewControllerAnimated:YES];
    };
    
    [bodyView addSubview:_runLightView];
    
    // +
    UIView *plusView = [[UIView alloc] init];
    plusView.frame = (CGRect){0, CGRectGetMaxY(bodyView.frame)+5, ScreenWidth, 50};
    if (APPDELEGATE.isPad) {
        plusView.frame = (CGRect){0, CGRectGetMaxY(bodyView.frame)+5, ScreenWidth, 80};
    }
    
    plusView.backgroundColor = BlueBackgroundColor;
    [scrollView addSubview:plusView];
    
    UIButton *plusLeftButton = [[UIButton alloc] initWithFrame:CGRectMake(20, 0, 50, 50)];
    plusLeftButton.titleLabel.font = Font(18);
    if (APPDELEGATE.isPad) {
        plusLeftButton.frame = (CGRect){20, 0, 80, 80};
        plusLeftButton.titleLabel.font = Font(30);
    }
    
    [plusLeftButton setTitle:@"＋" forState:UIControlStateNormal];
    plusLeftButton.tag = 0;
    [plusLeftButton addTarget:self action:@selector(plusButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [plusView addSubview:plusLeftButton];
    
    UIButton *plusRightButton = [[UIButton alloc] initWithFrame:CGRectMake(ScreenWidth-70, 0, 50, 50)];
    plusRightButton.titleLabel.font = Font(18);
    if (APPDELEGATE.isPad) {
        plusRightButton.frame = (CGRect){ScreenWidth-100, 0, 80, 80};
        plusRightButton.titleLabel.font = Font(30);
    }
    [plusRightButton setTitle:@"＋" forState:UIControlStateNormal];
    plusRightButton.tag = 1;
    [plusRightButton addTarget:self action:@selector(plusButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [plusView addSubview:plusRightButton];
    
    //-
    UIView *reduceView = [[UIView alloc] init];
    
    if (APPDELEGATE.isPad)
        reduceView.frame = (CGRect){0, CGRectGetMaxY(plusView.frame)+5, ScreenWidth, 80};
    else
        reduceView.frame = (CGRect){0, CGRectGetMaxY(plusView.frame)+5, ScreenWidth, 50};
    
    reduceView.backgroundColor = BlueBackgroundColor;
    [scrollView addSubview:reduceView];
    
    UIButton *reduceLeftButton = [[UIButton alloc] initWithFrame:CGRectMake(20, 0, 50, 50)];
    reduceLeftButton.titleLabel.font = Font(18);
    
    if (APPDELEGATE.isPad) {
        reduceLeftButton.frame = (CGRect){20, 0, 80, 80};
        reduceLeftButton.titleLabel.font = Font(30);
    }
    
    [reduceLeftButton setTitle:@"−" forState:UIControlStateNormal];
    reduceLeftButton.tag = 0;
    [reduceLeftButton addTarget:self action:@selector(reduceButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [reduceView addSubview:reduceLeftButton];
    
    UIButton *reduceRightButton = [[UIButton alloc] initWithFrame:CGRectMake(ScreenWidth-70, 0, 50, 50)];
    reduceRightButton.titleLabel.font = Font(18);
    if (APPDELEGATE.isPad) {
        reduceRightButton.frame = (CGRect){ScreenWidth-100, 0, 80, 80};
        reduceRightButton.titleLabel.font = Font(30);
    }
    
    [reduceRightButton setTitle:@"−" forState:UIControlStateNormal];
    reduceRightButton.tag = 1;
    [reduceRightButton addTarget:self action:@selector(reduceButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [reduceView addSubview:reduceRightButton];
    
    scrollView.contentSize = CGSizeMake(ScreenWidth, CGRectGetMaxY(reduceView.frame));
    
}

- (StatusView *)createStatueViewWithFrame:(CGRect)frame withTitles:(NSArray *)titleArray parentView:(UIView *)parentView
{
    StatusView *statueView = [[StatusView alloc] initWithFrame:frame];
    
    if (titleArray.count == 3) {
        statueView.topText = [titleArray objectAtIndex:0];
        statueView.midText = [titleArray objectAtIndex:1];
        statueView.bottomText = [titleArray objectAtIndex:2];
    }
    
    [parentView addSubview:statueView];
    return statueView;
}

- (void)clearDXData
{
    _d1.midText = @"0";
    _d2.midText = @"0";
//    _d3.midText = @"0";
    _d4.midText = @"0";
    _d5.midText = @"0";
//    _d6.midText = @"0";
    _d7.midText = @"0";
    _d8.midText = @"0";
}

- (void)updateMonitorData:(NSNotification *)notify
{
    [self setMonitorData:notify.userInfo];
    
    //
}

- (void)setMonitorData:(NSDictionary *)dictionary
{
    [self cancelTimer];
    
    _d1.midText = [dictionary objectForKey:@"D1"];
    _d2.midText = [dictionary objectForKey:@"D2"];
    //    _d3.midText = [dictionary objectForKey:@"D3"];
    _d4.midText = [dictionary objectForKey:@"D4"];
    _d5.midText = [dictionary objectForKey:@"D5"];
    //    _d6.midText = [dictionary objectForKey:@"D6"];
    _d7.midText = [dictionary objectForKey:@"D7"];
    _d8.midText = [dictionary objectForKey:@"D8"];
    
    MyLog(@"dictionary : %@", dictionary);
    
    _d1Slider.processValue = [[dictionary objectForKey:@"D1"] doubleValue];
    _d2Slider.processValue = [[dictionary objectForKey:@"D2"] doubleValue];
    _d4Slider.processValue = [[dictionary objectForKey:@"D4"] doubleValue];
    
    MyLog(@"D1: %.2f / %.2f", _d1Slider.processValue, _d1Slider.maxValue);
    MyLog(@"D1: %.2f / %.2f", _d2Slider.processValue, _d2Slider.maxValue);
    MyLog(@"D1: %.2f / %.2f", _d4Slider.processValue, _d4Slider.maxValue);
    
    //    if ([dictionary objectForKey:@"D2"]) {
    //        self.d2Value = [[notify.userInfo objectForKey:@"D2"] integerValue];
    //    }
    
    NSString *runTimeStr = [dictionary objectForKey:@"D4"];
    runTimeStr = runTimeStr ? runTimeStr : @"0";
    
    if (runTimeStr) {
        self.timeValue = [runTimeStr integerValue];
        [self updateLightColorWithTimeValue:self.timeValue];
    }
    
    [self startTimer];
    [self.view setNeedsDisplay];
}

- (void)startTimer
{
    if (!_timer) {
        _timer = [NSTimer scheduledTimerWithTimeInterval:60 target:self selector:@selector(clearDXData) userInfo:nil repeats:NO];
    }
}

- (void)updateLightColorWithTimeValue:(NSInteger)timeValue
{
    if (timeValue > 0 && timeValue < 0xE000) {
        _runLightView.timeText = [APPDELEGATE.TextDictionary objectForKey:@"Run"];
        _runLightView.lightColor = GreenLightColor;
        [_runLightView startLightFlickerWithColor:GreenLightColor];
    } else if (timeValue > 0xE000) {
        _runLightView.timeText = [APPDELEGATE.TextDictionary objectForKey:@"No Error"];
        _runLightView.lightColor = [UIColor yellowColor];
        [_runLightView startLightFlickerWithColor:[UIColor yellowColor]];
    } else {
        // = 0
        _runLightView.timeText = [APPDELEGATE.TextDictionary objectForKey:@"Stop"];
        _runLightView.lightColor = RedBackgroundColor;
        [_runLightView stopLightFlicker];
    }
}

- (void)cancelTimer
{
    if (_timer.isValid) {
        [_timer invalidate];
    }
    _timer = nil;
}

- (void)plusButtonClick:(UIButton *)button
{
    [[NSNotificationCenter defaultCenter] postNotificationName:Notify_Operation object:nil];
    if (button.tag == 0) {
        //left
        [[BluetoothManager sharedInstance] sendDataWithCommandType:Command_DebugLeftPlus];
    } else {
        //right
        [[BluetoothManager sharedInstance] sendDataWithCommandType:Command_DebugRightPlus];
    }
}

- (void)reduceButtonClick:(UIButton *)button
{
    [[NSNotificationCenter defaultCenter] postNotificationName:Notify_Operation object:nil];
    if (button.tag == 0) {
        //left
        [[BluetoothManager sharedInstance] sendDataWithCommandType:Command_DebugLeftReduce];
    } else {
        //right
        [[BluetoothManager sharedInstance] sendDataWithCommandType:Command_DebugRightReduce];
    }
    
}

- (void)debugButtonClick
{
    [[NSNotificationCenter defaultCenter] postNotificationName:Notify_Operation object:nil];
    [[BluetoothManager sharedInstance] sendDataWithCommandType:Command_DebugStart];
}

- (void)stopButtonClick
{
    [[NSNotificationCenter defaultCenter] postNotificationName:Notify_Operation object:nil];
    [[BluetoothManager sharedInstance] sendDataWithCommandType:Command_DebugStop];
}


@end
