//
//  LightView.h
//  Grunwl
//
//  Created by mojingyu on 16/1/30.
//  Copyright © 2016年 Mojy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LightView : UIView

@property (nonatomic, strong) UIColor *lightColor;
@property (nonatomic, strong) UIColor *flickerColor;    //闪烁颜色
@property (nonatomic, strong) NSString *timeText;
@property (nonatomic, copy) void (^clickBlock)();
@property (nonatomic, assign) BOOL isShowText;
@property (nonatomic, assign) BOOL isShowTip;
@property (nonatomic, strong) UILabel *tipLabel;
@property (nonatomic, strong) UIColor *textColor;   //按钮颜色
@property (nonatomic, getter=isFlickerText, assign) BOOL flickerText;

- (void)startLightFlicker;
- (void)startLightFlickerWithColor:(UIColor *)color;

- (void)stopLightFlicker;

@end
