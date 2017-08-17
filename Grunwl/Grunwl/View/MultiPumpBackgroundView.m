//
//  MultiPumpBackgroundView.m
//  Grunwl
//
//  Created by mojingyu on 16/7/3.
//  Copyright © 2016年 Mojy. All rights reserved.
//

#import "MultiPumpBackgroundView.h"

@interface MultiPumpBackgroundView()

@property (nonatomic, assign) CGFloat arrowOffsetX;
@property (nonatomic, strong) NSTimer *timer;

@end

@implementation MultiPumpBackgroundView

@synthesize arrowOffsetX = _arrowOffsetX;
@synthesize timer = _timer;
@synthesize count = _count;

#pragma mark - init datas
- (NSTimer *)timer
{
    if (!_timer) {
        _timer = [NSTimer scheduledTimerWithTimeInterval:0.2 target:self selector:@selector(runTimer:) userInfo:nil repeats:YES];
        [_timer setFireDate:[NSDate distantFuture]];
    }
    return _timer;
}

- (void)setCount:(NSInteger)count
{
    _count = count;
    [self setNeedsDisplay];
}


#pragma mark - UI Life cycle
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = RGBAlphaColor(0, 112, 192, 1);
        
        _count = 6;
        _arrowOffsetX = 100;
//        self.backgroundColor = [UIColor redColor];
    }
    return self;
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGFloat spacing = (ScreenHeight - 350) / 6 ;
    CGFloat top = 150 + (6 - _count)*spacing;
    CGFloat offsetY = ScreenHeight - 200;
    CGFloat offsetX = 100;
    
    [self drawLine:context startPoint:CGPointMake(0, offsetY) endPoint:CGPointMake(50, offsetY)];
    [self drawLine:context startPoint:CGPointMake(50, offsetY) endPoint:CGPointMake(50, top)];
    
    [self drawLine:context startPoint:CGPointMake(offsetX, offsetY) endPoint:CGPointMake(ScreenWidth, offsetY)];
    [self drawLine:context startPoint:CGPointMake(offsetX, offsetY) endPoint:CGPointMake(offsetX, top)];
    
    [self drawTriangle:context startPoint:CGPointMake(_arrowOffsetX, offsetY) endPoint:CGPointMake(_arrowOffsetX + 5, offsetY)];
    [self drawTriangle:context startPoint:CGPointMake(_arrowOffsetX + 10, offsetY) endPoint:CGPointMake(_arrowOffsetX + 15, offsetY)];
    [self drawTriangle:context startPoint:CGPointMake(_arrowOffsetX + 20, offsetY) endPoint:CGPointMake(_arrowOffsetX + 25, offsetY)];
    [self drawTriangle:context startPoint:CGPointMake(_arrowOffsetX + 30, offsetY) endPoint:CGPointMake(_arrowOffsetX + 35, offsetY)];
    
    for (int i = 0; i < _count; i++) {
        [self drawLine:context startPoint:CGPointMake(50, top) endPoint:CGPointMake(offsetX, top)];
        top += spacing + 3;
    }
    
}

- (void)drawLine:(CGContextRef)context startPoint:(CGPoint)startPt endPoint:(CGPoint)endPoint
{
    CGPoint aPoints[2];
    aPoints[0] = startPt;
    aPoints[1] = endPoint;
    
    //设置画笔线条粗细
    CGContextSetLineWidth(context, 2.0);
    //设置线条样式
    CGContextSetLineCap(context, kCGLineCapRound);
    //设置画笔颜色：white
    CGContextSetRGBStrokeColor(context, 1, 1, 1, 1);
    //画点连线
    CGContextAddLines(context, aPoints, 2);
    //执行绘画
    CGContextStrokePath(context);
}

//绘制左右三角形
- (void)drawTriangle:(CGContextRef)context startPoint:(CGPoint)startPoint endPoint:(CGPoint)endPoint
{
    CGFloat width = fabs(endPoint.x - startPoint.x);
    if (startPoint.x > ScreenWidth) {
        startPoint.x = 100 + startPoint.x - ScreenWidth;
        endPoint.x = startPoint.x + width;
    }
    
//    //2.添加绘图路径
    CGFloat zStrokeColour[4]    = {255.0/255,255.0/255.0,255.0/255.0,1.0};
    CGContextSetStrokeColor(context, zStrokeColour );
    CGContextSetFillColor(context, zStrokeColour);
    CGContextSetLineWidth(context, 2.0);
    
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

- (void)run
{
    [self.timer setFireDate:[NSDate distantPast]];
}

- (void)stop
{
    [self.timer setFireDate:[NSDate distantFuture]];
}

- (void)runTimer:(NSTimer *)timer
{
    _arrowOffsetX += 5;
    if (_arrowOffsetX > ScreenWidth)
        _arrowOffsetX = 105;
    
    [self setNeedsDisplay];
}

@end
