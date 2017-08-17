//
//  HelpViewController.m
//  Grunwl
//
//  Created by mojingyu on 16/1/30.
//  Copyright © 2016年 Mojy. All rights reserved.
//

#import "HelpViewController.h"

@interface HelpViewController ()<UITextViewDelegate, UIScrollViewDelegate>

@property (nonatomic, strong) UITextView *textView;

@end

@implementation HelpViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setupToolBar:@[[APPDELEGATE.TextDictionary objectForKey:@"Home"],
                         [APPDELEGATE.TextDictionary objectForKey:@"Set"],
                         [APPDELEGATE.TextDictionary objectForKey:@"control"]]];
    [self setupUI];
    [self resetTimer];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(resetTimer)];
    tap.numberOfTapsRequired = 1;
    [self.view addGestureRecognizer:tap];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)resetTimer
{
    [[NSNotificationCenter defaultCenter] postNotificationName:Notify_Operation object:nil];
    [self startTimerWithSeconds:ReturnControlPageTimeOutVlaue onEndBlock:^{
        //return to control
        self.tabBarController.selectedIndex = 1;
    }];
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
            [self checkPassword];
            break;
        case 2:
            //主控
            self.tabBarController.selectedIndex = 1;
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
        
        [[NSNotificationCenter defaultCenter] postNotificationName:Notify_Operation object:nil];
        if (invalidStatus) {
            //设置
            self.tabBarController.selectedIndex = 3;
        } else {
            [self showTipWithMessage:nil withTitle:[APPDELEGATE.TextDictionary objectForKey:@"Invalid password"] useCancel:NO onOKBlock:nil];
        }
    }];
}

- (void)setupUI
{
    [self setupLogoWithOriginY:NavBarHeight isShowText:NO withView:self.view];
    
    UITextView *textView = [[UITextView alloc] init];
    self.textView = textView;
    [self.view addSubview:textView];
    
    CGFloat textViewHeiht = ScreenHeight - CGRectGetMaxY(self.logoImageView.frame)- 40 - self.toolBarView.height;
    
    textView.frame = (CGRect){20, CGRectGetMaxY(self.logoImageView.frame)+20, ScreenWidth-40, textViewHeiht};
    
//    NSString *helpTextFileName = APPDELEGATE.languageType == Text_Zh ? @"error_help" : @"error_help_en" ;
    NSString *helpTextFileName = [self getHelpTextName];
    NSString *helpText = [NSString stringWithContentsOfFile:[[NSBundle mainBundle]pathForResource:helpTextFileName ofType:@"txt"] encoding:NSUTF8StringEncoding error:nil];
    textView.text = helpText;
    textView.textAlignment = NSTextAlignmentLeft;
    textView.font = FontNoBold(18);
    if (APPDELEGATE.isPad)
        textView.font = FontNoBold(25);
    
    textView.editable = NO;
    textView.scrollsToTop = YES;
    textView.delegate = self;
    textView.backgroundColor = DarkGreenBackgroundColor;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(resetTimer)];
    tap.numberOfTapsRequired = 1;
    [self.textView addGestureRecognizer:tap];

}

- (void)changeLanuageNotify:(NSNotification *)notify
{
//    NSString *helpTextFileName = APPDELEGATE.languageType == Text_Zh ? @"error_help" : @"error_help_en" ;
    NSString *helpTextFileName = [self getHelpTextName];
    NSString *helpText = [NSString stringWithContentsOfFile:[[NSBundle mainBundle]pathForResource:helpTextFileName ofType:@"txt"] encoding:NSUTF8StringEncoding error:nil];
    self.textView.text = helpText;
    self.textView.textAlignment = NSTextAlignmentLeft;
    
    [self setupToolBar:@[[APPDELEGATE.TextDictionary objectForKey:@"Home"],
                         [APPDELEGATE.TextDictionary objectForKey:@"Set"],
                         [APPDELEGATE.TextDictionary objectForKey:@"control"]]];
}

- (NSString *)getHelpTextName
{
    if (APPDELEGATE.languageType == Text_Zh)
        return @"error_help";
    else if (APPDELEGATE.languageType == Text_Ru)
        return @"error_help_ru";
    else if (APPDELEGATE.languageType == Text_Tr)
        return @"error_help_tr";
    else if (APPDELEGATE.languageType == Text_It)
        return @"error_help_it";
    else if (APPDELEGATE.languageType == Text_Ar)
        return @"error_help_ar";
    else if (APPDELEGATE.languageType == Text_Ko)
        return @"error_help_ko";
    else if (APPDELEGATE.languageType == Text_Es)
        return @"error_help_es";
    else if (APPDELEGATE.languageType == Text_Pt)
        return @"error_help_pt";
    
    return @"error_help_en";
}

#pragma UIScrollViewDelegate
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self resetTimer];
}
@end
