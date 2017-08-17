//
//  PercentageView.m
//  Grunwl
//
//  Created by mojingyu on 16/4/3.
//  Copyright © 2016年 Mojy. All rights reserved.
//

#import "PercentageView.h"

@interface PercentageView()



@end

@implementation PercentageView

- (id)init
{
    self = [super init];
    if (self) {
        //
        _processValue = 0;
        _maxValue = 1;
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        //
        self.backgroundColor = [UIColor clearColor];
        self.layer.borderColor = WhiteColor.CGColor;
        self.layer.borderWidth = 3;
    }
    return self;
}

- (void)drawRect:(CGRect)rect
{
    //[self drawBorder:rect];
    [self drawSlider:rect];
}

- (void)drawBorder:(CGRect)rect
{
    UIColor *color = WhiteColor;
    
    // 获取当前图形，视图推入堆栈的图形，相当于你所要绘制图形的图纸
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGContextSetLineWidth(ctx, 4);  //线宽
    
    //绘制边框
    CGContextSetRGBStrokeColor(ctx, 0.0, 176/255, 80/255, 1.0);
    CGContextMoveToPoint(ctx, rect.origin.x+1, rect.origin.y+1);
    CGContextMoveToPoint(ctx, rect.origin.x, rect.origin.y+rect.size.width);
    CGContextMoveToPoint(ctx, rect.origin.x+rect.size.width, rect.origin.y+rect.size.height);
    CGContextMoveToPoint(ctx, rect.origin.x, rect.origin.y+rect.size.height);
    CGContextClosePath(ctx);
    
    //绘制当前路径区域
    CGContextSetStrokeColorWithColor(ctx, color.CGColor);
    CGContextStrokePath(ctx);
}

- (void)drawSlider:(CGRect)rect
{
    CGFloat ratio = _processValue / _maxValue;
    CGFloat offsetY = rect.size.height * (1 - ratio) - 10;
    
    //绘制实心矩形
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGContextSetLineWidth(ctx, 2);
    
    // 设置实心填充颜色
    CGContextSetRGBFillColor(ctx, 0.0, 176.0/255.0, 80.0/255.0, 1.0);
    
    // 设置起始点和大小
    CGContextAddRect(ctx, CGRectMake(rect.origin.x, offsetY, rect.size.width, 20));
    
    // 绘制实心矩形
    CGContextFillPath(ctx);
}

- (void)setProcessValue:(CGFloat)processValue
{
    _processValue = processValue;
    [self setNeedsDisplay];
}

@end
