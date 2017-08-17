//
//  MeishiAlertView.m
//  KunshanMeishi
//
//  Created by MT on 12-12-20.
//  Copyright (c) 2012年 itotem. All rights reserved.
//

#import "ITTCustomAlertView.h"

@interface ITTCustomAlertView()

@property (nonatomic, assign) NSTimeInterval timeOutSecond;

@end

@implementation ITTCustomAlertView

@synthesize message = _message;

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.timeOutSecond = 1;
    }
    return self;
}


+ (ITTCustomAlertView *)showMessage:(NSString *)message
{
    ITTCustomAlertView *view = [self showMessage:message withTitle:nil withTimeOutSeconds:2];
//    ITTCustomAlertView *view = [super viewFromNib];
//    [view show];
//    view.top -= 50;
//    view.message.text = message;
    return view;
}

+ (ITTCustomAlertView *)showMessage:(NSString *)message withTitle:(NSString *)title
{
    ITTCustomAlertView *view = [self showMessage:message withTitle:title withTimeOutSeconds:2];
    return view;
}

+ (ITTCustomAlertView *)showMessage:(NSString *)message withTitle:(NSString *)title withTimeOutSeconds:(NSTimeInterval)timeOutSeconds
{
    ITTCustomAlertView *view = [super viewFromNib];
    view.top -= 50;
    if (title) {
        view.titleLabel.text = title;
        view.titleLabel.hidden = NO;
    } else {
        [view setFrame:CGRectMake(view.frame.origin.x, view.frame.origin.y, view.frame.size.width, 80)];
    }
    
    if (message) {
        view.message.text = message;
        view.message.hidden = NO;
    }
    view.timeOutSecond = timeOutSeconds;
    [view performSelector:@selector(cancel) withObject:nil afterDelay:view.timeOutSecond];
    [view show];
    
    return view;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
//    [self performSelector:@selector(cancel) withObject:nil afterDelay:self.timeOutSecond];

    [self makeImageView];
}

//- (void)dealloc
//
//    [_message release];
//    [_viewAlertBg release];
//    [super dealloc];
//}

-(void) makeImageView
{
    self.layer.masksToBounds = YES;
    [self.layer setCornerRadius:8.0];
    self.titleLabel.hidden = YES;
    self.message.hidden = YES;
}

@end
