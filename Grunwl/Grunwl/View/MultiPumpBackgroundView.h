//
//  MultiPumpBackgroundView.h
//  Grunwl
//
//  Created by mojingyu on 16/7/3.
//  Copyright © 2016年 Mojy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MultiPumpBackgroundView : UIView

@property (nonatomic, assign) NSInteger count;

- (void)run;
- (void)stop;

@end
