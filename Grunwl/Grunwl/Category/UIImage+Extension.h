//
//  UIImage+Extension.h
//  Grunwl
//
//  Created by mojingyu on 16/1/30.
//  Copyright © 2016年 Mojy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Extension)

//等比例缩放
- (UIImage *)scaleToSize:(CGSize)size;

//计算对应的尺寸
- (CGSize)calculateTargetSize:(CGSize)size;

@end
