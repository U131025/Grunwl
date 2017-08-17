//
//  LightView.m
//  Grunwl
//
//  Created by mojingyu on 16/1/30.
//  Copyright © 2016年 Mojy. All rights reserved.
//

#import "LightView.h"

@interface LightView()

@property (nonatomic, strong) UIButton *timeButton;
@property (strong, nonatomic) NSTimer *timer;
@property (nonatomic, strong) UIColor *preColor;    //闪烁前的颜色
@property (nonatomic, assign) CGFloat angleValue; //旋转角度
@property (nonatomic, assign) BOOL isFlicker;   //是否显示动画

@end

@implementation LightView

@synthesize textColor = _textColor;
@synthesize flickerText = _flickerText;

- (id)init
{
    self = [super init];
    if (self) {
        self.isShowText = YES;
    }
    return self;
}

- (void)setTimeText:(NSString *)timeText
{
    [_timeButton setTitle:timeText forState:UIControlStateNormal];
}

- (void)setTextColor:(UIColor *)textColor
{
    [_timeButton setTitleColor:textColor forState:UIControlStateNormal];
}

- (void)setFlickerText:(BOOL)flickerText
{
    if (flickerText) {
        [UIView beginAnimations:@"textFlicker" context:nil];
        [UIView setAnimationDuration:0.5];
        [UIView setAnimationRepeatCount:HUGE_VALF];
        [UIView setAnimationRepeatAutoreverses:YES];
        
        _timeButton.titleLabel.alpha = 0;
        
        [UIView commitAnimations];
    }
    else {
        _timeButton.titleLabel.alpha = 1;
        [_timeButton.titleLabel.layer removeAllAnimations];
    }
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.isFlicker = NO;
        self.isShowText = YES;
        self.isShowTip = NO;
        self.lightColor = GreenLightColor;
        self.flickerColor = [UIColor yellowColor];
        
        //
        self.backgroundColor = RGBAlphaColor(0, 112, 192, 1);
        self.layer.borderWidth = 1;
        self.layer.borderColor = BlackColor.CGColor;
        
        //
        _timeButton = [[UIButton alloc] initWithFrame:CGRectMake(20, CGRectGetHeight(frame)-35, CGRectGetWidth(frame)-40, 30)];
        
        if (APPDELEGATE.isPad) {
            _timeButton.frame = (CGRect){30, CGRectGetHeight(frame)-80, CGRectGetWidth(frame)-60, 60};
            _timeButton.titleLabel.font = Font(30);
        }
        
        _timeButton.layer.borderColor = BlackColor.CGColor;
        _timeButton.layer.borderWidth = 1;
        _timeButton.backgroundColor = RGBAlphaColor(187, 224, 227, 1);
        _timeButton.titleLabel.font = Font(21);
        [_timeButton setTitleColor:BlackColor forState:UIControlStateNormal];
        [self addSubview:_timeButton];
        
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(SingleClick:)];
        tapGesture.numberOfTapsRequired = 1;
        [self addGestureRecognizer:tapGesture];
        
        _tipLabel = [[UILabel alloc] init];
        _tipLabel.frame = (CGRect){30, CGRectGetHeight(frame)/2 - 20, CGRectGetWidth(frame)-60, 40};
        _tipLabel.font = Font(18);
        _tipLabel.textColor = WhiteColor;
        _tipLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:_tipLabel];
        
    }
    return self;
}

- (void)SingleClick:(UITapGestureRecognizer *)tapGresture
{
    if (_clickBlock) {
        _clickBlock();
    }
}

- (void)drawRect:(CGRect)rect
{
    // Drawing code
    
    [self drawLight];
}

- (void)drawLight
{
    CGPoint pt = CGPointMake(CGRectGetWidth(self.frame)/2, (self.frame.size.height-30) / 2);
    CGFloat ratio = 1.0;
    if (APPDELEGATE.isPad) {
        ratio = 2.0;
        pt = CGPointMake(CGRectGetWidth(self.frame)/2, (self.frame.size.height-60) / 2);
    }
    
    if (!_isShowText)
        pt = CGPointMake(CGRectGetWidth(self.frame)/2, (self.frame.size.height) / 2);
    
    if (!self.isShowTip) {
        [self drawCircleAtPoint:pt withRadius:10*ratio withColor:self.lightColor isFill:YES];
        [self drawCircleAtPoint:pt withRadius:11*ratio withColor:[UIColor blackColor] isFill:NO];
        [self drawCircleAtPoint:pt withRadius:24*ratio withLineWidth:1 withColor:[UIColor blackColor] isFill:NO];
    }
    
    if (self.isFlicker) {
        [self drawCircleAtPoint:pt withRadius:30*ratio withLineWidth:12*ratio withColor:BlueBackgroundColor isFill:NO];
        [self drawMoveIconAtPoint:pt withRadius:30*ratio withLineWidth:12*ratio withColor:self.lightColor];
    } else {
        [self drawCircleAtPoint:pt withRadius:30*ratio withLineWidth:12*ratio withColor:self.lightColor isFill:NO];
    }
    
    [self drawCircleAtPoint:pt withRadius:36*ratio withColor:[UIColor blackColor] isFill:NO];
}

- (void)drawMoveIconAtPoint:(CGPoint)pt withRadius:(CGFloat)radius withLineWidth:(CGFloat)width withColor:(UIColor *)color
{
    // 获取当前图形，视图推入堆栈的图形，相当于你所要绘制图形的图纸
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    CGContextSetLineWidth(ctx, width);  //线宽
   
    CGFloat from = self.angleValue * M_PI * 2;
    CGFloat to = from + 0.4;
    CGContextAddArc(ctx, pt.x, pt.y, radius, from, to, 1);
    
    //绘制当前路径区域
    CGContextSetStrokeColorWithColor(ctx, color.CGColor);
    CGContextStrokePath(ctx);
}

//绘制圆形
- (void)drawCircleAtPoint:(CGPoint)pt withRadius:(CGFloat)radius withLineWidth:(CGFloat)width withColor:(UIColor *)color isFill:(BOOL)isFill
{
    // 获取当前图形，视图推入堆栈的图形，相当于你所要绘制图形的图纸
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    CGContextSetLineWidth(ctx, width);  //线宽
    
    /**
     *  @brief 在当前路径添加圆弧 参数按顺序说明
     *
     *  @param c           当前图形
     *  @param x           圆弧的中心点坐标x
     *  @param y           曲线控制点的y坐标
     *  @param radius      指定点的x坐标值
     *  @param startAngle  弧的起点与正X轴的夹角，
     *  @param endAngle    弧的终点与正X轴的夹角
     *  @param clockwise   指定1创建一个顺时针的圆弧，或是指定0创建一个逆时针圆弧
     *
     */
    CGContextAddArc(ctx, pt.x, pt.y, radius, 0, 2 * M_PI, 1);
    
    //绘制当前路径区域
    if (isFill) {
        // 创建一个新的空图形路径。
        CGContextSetFillColorWithColor(ctx, color.CGColor);
        CGContextFillPath(ctx);
    } else {
        CGContextSetStrokeColorWithColor(ctx, color.CGColor);
        CGContextStrokePath(ctx);
    }
    
}

//以指定中心点绘制圆弧
- (void)drawCircleAtPoint:(CGPoint)pt withRadius:(CGFloat)radius withColor:(UIColor *)color isFill:(BOOL)isFill
{
    [self drawCircleAtPoint:pt withRadius:radius withLineWidth:1 withColor:color isFill:isFill];
}

- (void)startLightFlicker
{
    [self stopLightFlicker];
    
    self.isFlicker = YES;
    self.preColor = self.lightColor;    
    self.timer = [NSTimer scheduledTimerWithTimeInterval:0.2 target:self selector:@selector(lightFlickerAction) userInfo:nil repeats:YES];
}

- (void)startLightFlickerWithColor:(UIColor *)color
{
    self.flickerColor = color;
    [self startLightFlicker];
}

- (void)lightFlickerAction
{
    if (self.angleValue > 1) {
        self.angleValue = self.angleValue-1;
    }
    self.angleValue += 0.1;
    self.lightColor = self.flickerColor;
    
//    if ([self.lightColor isEqual:self.flickerColor]) {
//        self.lightColor = GrayLineColor;
//    } else {
//        self.lightColor = self.flickerColor;
//    }
    [self setNeedsDisplay];
}

- (void)stopLightFlicker
{
    self.isFlicker = NO;
    if (self.timer) {
        [self.timer invalidate];
    }
    
//    if (self.preColor) {
//        self.lightColor = self.preColor;
//    }
    [self setNeedsDisplay];
}

- (void)setIsShowText:(BOOL)isShowText
{
    _isShowText = isShowText;
    if (!isShowText) {
        _timeButton.hidden = YES;
        self.layer.borderWidth = 0;
    } else {
        _timeButton.hidden = NO;
        self.layer.borderWidth = 1;
    }
    [self setNeedsDisplay];
}

- (void)setIsShowTip:(BOOL)isShowTip
{
    _isShowTip = isShowTip;
    if (!isShowTip) {
        _tipLabel.hidden = YES;
    } else {
        _tipLabel.hidden = NO;
    }
    [self setNeedsDisplay];
}

@end
