//
//  settingCellView.h
//  Grunwl
//
//  Created by mojingyu on 16/1/31.
//  Copyright © 2016年 Mojy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "InputHelper.h"

@protocol SettingCellViewDelegate <NSObject>

- (void)settingCellViewButtonClick:(NSInteger)tag withValue:(NSString *)value;

@end

@interface settingCellView : UIView

@property (nonatomic, assign) id<SettingCellViewDelegate> delegate;
@property (nonatomic, strong) NSString *titleText;
@property (nonatomic, strong) NSString *valueText;
@property (nonatomic, strong) NSString *placeholder;
@property (nonatomic, assign) ValidationType keyboardType;

@property (nonatomic, strong) UITextField *valueTextField;

- (void)enableOKButton;
- (void)disableOKButton;

@end
