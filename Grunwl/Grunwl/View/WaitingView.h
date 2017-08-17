//
//  WaitingView.h
//  Grunwl
//
//  Created by mojingyu on 16/4/25.
//  Copyright © 2016年 Mojy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WaitingView : UIView

@property (nonatomic, strong) NSString *tipText;
@property (nonatomic, strong) UIColor *color;
@property (nonatomic, assign) BOOL isStartAnimation;

- (void)startAnimation;
- (void)stopAnimation;

@end
