//
//  BaseViewController.m
//  Grunwl
//
//  Created by mojingyu on 16/1/29.
//  Copyright © 2016年 Mojy. All rights reserved.
//

#import "BaseViewController.h"
#import "myUILabel.h"

@interface BaseViewController ()

@property (nonatomic, strong) UILabel *productLabel;
@property (nonatomic, strong) UILabel *logoLabel;
@property (nonatomic, copy) NSString *password;

@property (strong, nonatomic) NSTimer *timer;
@property (nonatomic, copy) void (^onTimerEndBlock)();

@end

@implementation BaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationController.navigationBar.hidden = YES;
    self.tabBarController.tabBar.hidden = YES;
    
    self.view.backgroundColor = RGBAlphaColor(0, 112, 192, 1);
    
    if ([self respondsToSelector:@selector(setEdgesForExtendedLayout:)]){
        self.edgesForExtendedLayout = UIRectEdgeBottom;
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeLanuageNotify:) name:Notify_Change_Lanuage object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(enableButtonNotify:) name:Notify_Enable_Button object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(disalbeButtonNotify:) name:Notify_Disable_Button object:nil];
}

- (void)enableButtonNotify:(NSNotification *)notify
{
    
}

- (void)disalbeButtonNotify:(NSNotification *)notify
{
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UIButton *)createToolBarButtonWithFrame:(CGRect)frame withName:(NSString *)name
{
    UIButton *button = [[UIButton alloc] initWithFrame:frame];
    [button setTitle:name forState:UIControlStateNormal];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    return button;
}

- (void)setupToolBar:(NSArray *)buttonsArray
{
    if (buttonsArray.count == 0) {
        MyLog(@"buutonArray is zero.");
        return;
    }
    
    if (_toolBarView) {
        [_toolBarView removeAllSubviews];
    }
    
    UIView *toolBarView = [[UIView alloc] init];
    toolBarView.frame = (CGRect){0, ScreenHeight-50, ScreenWidth, 50};
    toolBarView.backgroundColor = RGBAlphaColor(0, 112, 192, 1);
    if (APPDELEGATE.isPad)
        toolBarView.frame = (CGRect){0, ScreenHeight-100, ScreenWidth, 100};
    
    UILabel *linetop = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 1)];
    linetop.backgroundColor = BlackColor;
    [toolBarView addSubview:linetop];
    
    CGFloat buttonWidth = ScreenWidth / buttonsArray.count;
    NSInteger offsetX = 0;
    for (int i = 0; i < buttonsArray.count; i++) {
        NSString *buttonText = [buttonsArray objectAtIndex:i];
        UIButton *toolBarButton = [self createToolBarButtonWithFrame:CGRectMake(offsetX, 0, buttonWidth, 50) withName:buttonText];
        if (APPDELEGATE.isPad)
            toolBarButton.frame = (CGRect){offsetX, 0, buttonWidth, 100};
        
        toolBarButton.tag = i;
        toolBarButton.titleLabel.font = Font(18);
        if (APPDELEGATE.isPad)
            toolBarButton.titleLabel.font = Font(30);
        
        [toolBarButton addTarget:self action:@selector(buttonClickAction:) forControlEvents:UIControlEventTouchUpInside];
        [toolBarView addSubview:toolBarButton];
        
        if (i != buttonsArray.count) {
            UILabel *line = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(toolBarButton.frame), CGRectGetMinY(toolBarButton.frame), 1, CGRectGetHeight(toolBarButton.frame))];
            line.backgroundColor = BlackColor;
            [toolBarView addSubview:line];
        }
        
        offsetX += buttonWidth;
    }
    
    _toolBarView = toolBarView;
    [self.view addSubview:toolBarView];
    
}

- (void)setupLogoWithOriginY:(CGFloat)originY isShowText:(BOOL)isShowText withView:(UIView *)view
{
    UIImageView *logoImageView = [[UIImageView alloc] init];
    
    if (APPDELEGATE.isPad) {
        logoImageView.image = [[UIImage imageNamed:LogoImage] scaleToSize:CGSizeMake(280, 100)];
        logoImageView.frame = (CGRect){0, originY, 420, 150};
    } else {
        logoImageView.image = [[UIImage imageNamed:LogoImage] scaleToSize:CGSizeMake(280, 100)];
        logoImageView.frame = (CGRect){0, originY, 280, 100};
    }
    
    _logoImageView = logoImageView;
    [view addSubview:logoImageView];
    
    if (isShowText) {
        
        CGFloat offsetY = CGRectGetMaxY(logoImageView.frame)+10;
        NSString *productText = [APPDELEGATE.TextDictionary objectForKey:@"Intelligent water supply"];
        NSInteger fontSize = IS_IPHONE_5_OR_LESS ? 23 : 25;
        
        if (APPDELEGATE.isPad)
            fontSize = 36;
        
        if (APPDELEGATE.languageType != Text_Zh) {
            fontSize -= 5;
//            offsetY += 10;
            
        }
        
        CGSize textSize = [productText sizeWithFont:Font(fontSize) maxSize:CGSizeMake(MAXFLOAT, MAXFLOAT)];
        CGFloat textWidth = 300;
        if (textSize.width > textWidth)
            textSize = [productText sizeWithFont:Font(fontSize) maxSize:CGSizeMake(textWidth, MAXFLOAT)];
        
        myUILabel *productLabel = [[myUILabel alloc] initWithFrame:CGRectMake(ScreenWidth-20-textSize.width, offsetY, textSize.width, textSize.height*2)];
        productLabel.text = productText;
        productLabel.textColor = WhiteColor;
        productLabel.font = Font(fontSize);
        productLabel.numberOfLines = 2;
        productLabel.textAlignment = NSTextAlignmentRight;
        productLabel.verticalAlignment = VerticalAlignmentTop;

        self.productLabel = productLabel;
        [view addSubview:productLabel];
        
        if (APPDELEGATE.languageType == Text_Zh) {
            NSString *logoText = [APPDELEGATE.TextDictionary objectForKey:GRUNWL];
            fontSize = IS_IPHONE_5_OR_LESS ? 23 : 30;
            
            if (APPDELEGATE.isPad)
                fontSize = 36;
            
            if (APPDELEGATE.languageType != Text_Zh)
                fontSize -= 6;
            
            CGSize logoTextSize = [logoText sizeWithFont:Font(fontSize) maxSize:CGSizeMake(MAXFLOAT, MAXFLOAT)];
            CGFloat offsetX = 0;
            if (APPDELEGATE.languageType != Text_Zh) {
                fontSize -= 8;
//                offsetY = CGRectGetMinY(productLabel.frame) - logoTextSize.height;
                offsetY = CGRectGetMaxY(logoImageView.frame)+10;
                offsetX = CGRectGetMinX(productLabel.frame);
            } else {
                offsetX = CGRectGetMinX(productLabel.frame) - 20 -logoTextSize.width;
                offsetY = CGRectGetMaxY(logoImageView.frame)+5;
//                offsetY = CGRectGetMaxY(productLabel.frame) - logoTextSize.height;;
            }
            
            myUILabel *logoLabel = [[myUILabel alloc] initWithFrame:CGRectMake(offsetX, offsetY, logoTextSize.width, logoTextSize.height)];
            logoLabel.text = logoText;
            logoLabel.textColor = WhiteColor;
            logoLabel.font = Font(fontSize);
            self.logoLabel = logoLabel;
            [view addSubview:logoLabel];

        }
    }
    
}

- (void)setupLogo
{
    [self.logoImageView removeFromSuperview];
    [self.logoLabel removeFromSuperview];
    [self.productLabel removeFromSuperview];
    
    [self setupLogoWithOriginY:ScreenHeight/5 - 50 isShowText:YES withView:self.view];
}

- (void)buttonClickAction:(UIButton *)button
{
   //
}

- (void)changeLanuageNotify:(NSNotification *)notify
{
    
}

// 进入设置界面校验密码
- (void)inputPasswordOnOKBlock:(void (^)(BOOL invalidStatus))onOKBlock
{
    [[NSNotificationCenter defaultCenter] postNotificationName:Notify_Operation object:nil];
    UIAlertController *alertController = nil;
    alertController = [UIAlertController alertControllerWithTitle:[APPDELEGATE.TextDictionary objectForKey:@"Please input password"] message:nil preferredStyle:UIAlertControllerStyleAlert];
    
    [alertController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        

    }];
    UIAlertAction *cancleAction = [UIAlertAction actionWithTitle:@"Cancle" style:UIAlertActionStyleCancel handler:nil];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [[NSNotificationCenter defaultCenter] postNotificationName:Notify_Operation object:nil];
        NSString *inputPassword = alertController.textFields.firstObject.text;
        
        NSLog(@"password input : %@", inputPassword);
        if (![inputPassword isEqualToString:DEFAULT_PASSWORD]) {
            APPDELEGATE.isLogin = NO;
        } else {
//            [[NSUserDefaults standardUserDefaults] setObject:inputPassword forKey:PASSWORD];
            APPDELEGATE.isLogin = YES;
        }
        
        if (onOKBlock) {
            onOKBlock(APPDELEGATE.isLogin);
        }
        
        
    }];
    [alertController addAction:cancleAction];
    [alertController addAction:okAction];
    
    [self presentViewController:alertController animated:YES completion:nil];
}

- (void)handleTextFieldDidChangeNotification:(NSNotification *)notification
{
    //    UITextField *textField = notification.object;
}

#pragma mark -公用提示框
- (void)showTipWithMessage:(NSString *)message withTitle:(NSString *)title useCancel:(BOOL)useCancel onOKBlock:(void (^)())onOKBlock
{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *cancleAction = [UIAlertAction actionWithTitle:APPDELEGATE.languageType == Text_Zh? @"取消":@"Cancel" style:UIAlertActionStyleCancel handler:nil];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:APPDELEGATE.languageType == Text_Zh? @"确认":@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        if (onOKBlock) {
            onOKBlock();
        }
    }];
    
    if (useCancel) {
        [alertController addAction:cancleAction];
    }
    
    [alertController addAction:okAction];
    [self presentViewController:alertController animated:YES completion:nil];
}

//启动定时器
- (void)startTimerWithSeconds:(NSInteger)seconds onEndBlock:(void (^)())onEndBlock
{
    if (self.timer) {
        [self.timer invalidate];
        self.timer = nil;
    }
    
    self.onTimerEndBlock = onEndBlock;
    if (!self.timer)
        self.timer = [NSTimer scheduledTimerWithTimeInterval:seconds target:self selector:@selector(timeoutAction) userInfo:nil repeats:NO];
}

- (void)timeoutAction
{
    //timeout
    if (self.onTimerEndBlock) {
        self.onTimerEndBlock();
    }
}

@end
