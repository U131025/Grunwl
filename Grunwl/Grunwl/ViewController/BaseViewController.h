//
//  BaseViewController.h
//  Grunwl
//
//  Created by mojingyu on 16/1/29.
//  Copyright © 2016年 Mojy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BaseViewController : UIViewController

@property (nonatomic, strong) UIView *toolBarView;
@property (nonatomic, strong) UIImageView *logoImageView;

- (UIButton *)createToolBarButtonWithFrame:(CGRect)frame withName:(NSString *)name;
- (void)setupToolBar:(NSArray *)buttonsArray;
- (void)buttonClickAction:(UIButton *)button;
- (void)setupLogo;
- (void)setupLogoWithOriginY:(CGFloat)originY isShowText:(BOOL)isShowText withView:(UIView *)view;

//语言切换事件
- (void)changeLanuageNotify:(NSNotification *)notify;

- (void)enableButtonNotify:(NSNotification *)notify;
- (void)disalbeButtonNotify:(NSNotification *)notify;

// 进入设置界面校验密码
- (void)inputPasswordOnOKBlock:(void (^)(BOOL invalidStatus))onOKBlock;
- (void)showTipWithMessage:(NSString *)message withTitle:(NSString *)title useCancel:(BOOL)useCancel onOKBlock:(void (^)())onOKBlock;

//启动定时器
- (void)startTimerWithSeconds:(NSInteger)seconds onEndBlock:(void (^)())onEndBlock;

@end
