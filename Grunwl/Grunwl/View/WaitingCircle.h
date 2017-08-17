//
//  WaitingCircle.h
//  Grunwl
//
//  Created by mojingyu on 16/7/4.
//  Copyright © 2016年 Mojy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WaitingCircle : UIView

@property (nonatomic, copy) NSString *text;

- (void)run;
- (void)stop;

@end
