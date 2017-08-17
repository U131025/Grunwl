//
//  WaitingView.m
//  Grunwl
//
//  Created by mojingyu on 16/4/25.
//  Copyright © 2016年 Mojy. All rights reserved.
//

#import "WaitingView.h"
#import "UIView+Extension.h"

@interface WaitingView()

@property (strong, nonatomic) NSTimer *timer;
@property (strong, nonatomic) UIImageView *imageView;
@property (nonatomic, assign) CGFloat angleValue;
@property (nonatomic, strong) UILabel *tipLabel;
@end

@implementation WaitingView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _color = WhiteColor;
        _angleValue = 0.0;
        _isStartAnimation = NO;
        
#ifdef FLOTEQ
        self.backgroundColor = [UIColor clearColor];
#else
        self.backgroundColor = RGBAlphaColor(0, 112, 192, 1);
        
#endif

        CGFloat radius = 50.0;
        if (APPDELEGATE.isPad)
            radius = 80.0;
        
        _imageView = [[UIImageView alloc] initWithFrame:(CGRect){CGRectGetWidth(frame)/2-radius, CGRectGetHeight(frame)/2-radius, 2*radius, 2*radius}];
        _imageView.image = [UIImage imageNamed:@"Waiting"];
        [self addSubview:_imageView];
        
        _tipLabel = [[UILabel alloc] init];
        _tipLabel.frame = (CGRect){10, 0, CGRectGetWidth(frame)-20, CGRectGetHeight(frame)};
        _tipLabel.font = Font(13);
        if (APPDELEGATE.isPad) {
            _tipLabel.frame = (CGRect){20, 0, CGRectGetWidth(frame)-40, CGRectGetHeight(frame)};
            _tipLabel.font = Font(20);
        }
        
        _tipLabel.textColor = WhiteColor;
        _tipLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:_tipLabel];
        
    }
    return self;
}

//- (void)drawRect:(CGRect)rect
//{
//    //draw
//    CGContextRef ctx = UIGraphicsGetCurrentContext();    
//    CGContextSetLineWidth(ctx, 5);  //线宽
//    
//    //画圆
//    CGContextAddEllipseInRect(ctx,CGRectMake(self.centerX, self.centerY,self.width,self.height));
//    
//    CGContextSetStrokeColorWithColor(ctx, _color.CGColor);
//    CGContextStrokePath(ctx);
//    
//    //绘制箭头
//}

- (void)startAnimation
{
    //
    self.isStartAnimation = YES;
    
    if (!self.timer)
        self.timer = [NSTimer scheduledTimerWithTimeInterval:0.2 target:self selector:@selector(animationTimer) userInfo:nil repeats:YES];
}

- (void)stopAnimation
{
    self.isStartAnimation = NO;
    if (self.timer) {
        [self.timer invalidate];
        self.timer = nil;
    }
    
    [self setNeedsDisplay];
}

- (void)animationTimer
{
    //
    _angleValue += 10;
    if (_angleValue > 360)
        _angleValue = _angleValue - 360;
    
    CGAffineTransform transform = CGAffineTransformMakeRotation(_angleValue * M_PI / 180);
    [_imageView setTransform:transform];
    
    [self setNeedsDisplay];
}

- (void)setTipText:(NSString *)tipText
{
    _tipText = tipText;
    if (_tipLabel) {
        _tipLabel.text = tipText;
    }
}

@end
