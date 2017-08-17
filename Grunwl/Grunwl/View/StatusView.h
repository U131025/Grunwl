//
//  StatusView.h
//  Grunwl
//
//  Created by mojingyu on 16/1/31.
//  Copyright © 2016年 Mojy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface StatusView : UIView

@property (nonatomic, strong) NSString *topText;
@property (nonatomic, strong) NSString *midText;
@property (nonatomic, strong) NSString *bottomText;

@property (nonatomic, strong) UILabel *topLabel;
@property (nonatomic, strong) UILabel *midLabel;
@property (nonatomic, strong) UILabel *bottomLabel;

@end
