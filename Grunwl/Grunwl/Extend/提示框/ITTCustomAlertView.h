//
//  MeishiAlertView.h
//  KunshanMeishi
//
//  Created by MT on 12-12-20.
//  Copyright (c) 2012年 itotem. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PoppingBaseView.h"
#import "UIView+ITTAdditions.h"

//警告框
@interface ITTCustomAlertView : PoppingBaseView
{
    IBOutlet UILabel            *_message;
    IBOutlet UIView *_viewAlertBg;
}

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@property (nonatomic ,retain) IBOutlet UILabel *message;//提示文字

+ (ITTCustomAlertView *)showMessage:(NSString *)message;

+ (ITTCustomAlertView *)showMessage:(NSString *)message withTitle:(NSString *)title;

+ (ITTCustomAlertView *)showMessage:(NSString *)message withTitle:(NSString *)title withTimeOutSeconds:(NSTimeInterval)timeOutSeconds;

@end
