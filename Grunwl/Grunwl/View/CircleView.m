//
//  CircleView.m
//  Grunwl
//
//  Created by mojingyu on 16/7/4.
//  Copyright © 2016年 Mojy. All rights reserved.
//

#import "CircleView.h"

@implementation CircleView

@synthesize lineWidth = _lineWidth;

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        
        _lineWidth = 2.0;
    }
    return self;
}

- (void)setLineWidth:(CGFloat)lineWidth
{
    _lineWidth = lineWidth;
    [self setNeedsDisplay];
}

#pragma mark - Draw
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
    
    //1.获取图形上下文
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    //draw
    [self drawCircle:context topleftPoint:CGPointMake(5, 5) raduis:self.width/2- 5];
    [self drawTriangle:context startPoint:CGPointMake(self.width/2-5, 5) endPoint:CGPointMake(self.width/2, 5)];
}

- (void)drawCircle:(CGContextRef)context topleftPoint:(CGPoint)topleftPoint raduis:(CGFloat)raduis
{
    //2.绘制图形
    CGFloat zStrokeColour[4]    = {255.0/255,255.0/255.0,255.0/255.0,1.0};
    CGFloat zFillColor[4] = {0.0/255,112.0/255.0,192.0/255.0,1.0};
    CGContextSetStrokeColor(context, zStrokeColour );
    CGContextSetFillColor(context, zFillColor);
    CGContextSetLineWidth(context, _lineWidth);
    
    CGContextAddEllipseInRect(context, CGRectMake(topleftPoint.x, topleftPoint.y, raduis*2, raduis*2));
    
    //3.显示在View上
    CGContextDrawPath(context, kCGPathFillStroke);
    
}

- (void)drawTriangle:(CGContextRef)context startPoint:(CGPoint)startPoint endPoint:(CGPoint)endPoint
{
    
    CGFloat width = fabs(endPoint.x - startPoint.x);
    
    //    //2.添加绘图路径
    CGFloat zStrokeColour[4]    = {255.0/255,255.0/255.0,255.0/255.0,1.0};
    CGContextSetStrokeColor(context, zStrokeColour );
    CGContextSetFillColor(context, zStrokeColour);
    CGContextSetLineWidth(context, _lineWidth);
    
    CGContextBeginPath(context);//标记
    
    //    CGContextMoveToPoint(context, startPoint.x, startPoint.y - width/2);//起始点
    //    CGContextAddLineToPoint(context, startPoint.x, startPoint.y + width); //终点
    //    CGContextAddLineToPoint(context, startPoint.x + width, startPoint.y - width/2); //终点
    //    CGContextAddLineToPoint(context, startPoint.x, startPoint.y - width/2); //终点
    
    CGPoint sPoints[3];//坐标点
    sPoints[0] =CGPointMake(startPoint.x, startPoint.y - width/2);//坐标1
    sPoints[1] =CGPointMake(startPoint.x, startPoint.y + width/2);//坐标2
    sPoints[2] =CGPointMake(endPoint.x, endPoint.y);//坐标3
    
    CGContextAddLines(context, sPoints, 3);//添加线
    CGContextClosePath(context);//封起来
    
    CGContextDrawPath(context, kCGPathFillStroke); //根据坐标绘制路径
}

@end
