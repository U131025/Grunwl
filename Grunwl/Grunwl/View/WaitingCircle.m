//
//  WaitingCircle.m
//  Grunwl
//
//  Created by mojingyu on 16/7/4.
//  Copyright © 2016年 Mojy. All rights reserved.
//

#import "WaitingCircle.h"
#import "CircleView.h"
#import "myUILabel.h"

@interface WaitingCircle ()

@property (nonatomic, assign) NSInteger angle;
@property (nonatomic, readonly, strong) NSTimer *timer;
@property (nonatomic, readonly, strong) CircleView *circleView;
@property (nonatomic, strong) myUILabel *textLabel;

@end

@implementation WaitingCircle

@synthesize angle = _angle;
@synthesize timer = _timer;
@synthesize circleView = _circleView;

- (void)setText:(NSString *)text
{
    if (self.textLabel) {
        self.textLabel.text = text;
    }
}

- (myUILabel *)textLabel
{
    if (!_textLabel) {
        _textLabel = [[myUILabel alloc] initWithFrame:CGRectMake(0, 0, self.width, self.height)];
        
        if (IS_IPHONE_5_OR_LESS) {
            _textLabel.font = Font(20);
        }
        else {
            _textLabel.font = Font(23);
        }
        
        _textLabel.textColor = [UIColor whiteColor];
        _textLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _textLabel;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _angle = 0;
        self.backgroundColor = [UIColor clearColor];
        
        [self addSubview:self.textLabel];
        
    }
    return self;
}

- (void)dealloc
{
    [_timer invalidate];
    _timer = nil;
}

#pragma mark - init Datas
- (NSTimer *)timer
{
    if (!_timer) {
        _timer = [NSTimer scheduledTimerWithTimeInterval:0.2 target:self selector:@selector(runTimer:) userInfo:nil repeats:YES];
        [_timer setFireDate:[NSDate distantFuture]];
    }
    return _timer;
}

#pragma mark - NSTimer
- (void)run
{
    [_circleView removeFromSuperview];
    _circleView = nil;
    _circleView = [self createCircleViewWithLineWidth:4.0];
    
    [self addSubview:_circleView];
    [self bringSubviewToFront:self.textLabel];
    
    [self.timer setFireDate:[NSDate distantPast]];
}

- (void)stop
{
    [_circleView removeFromSuperview];
    _circleView = nil;
    _circleView = [self createCircleViewWithLineWidth:2.0];
    
    [self addSubview:_circleView];
    [self bringSubviewToFront:self.textLabel];
    
    [self.timer setFireDate:[NSDate distantFuture]];
}

- (CircleView *)createCircleViewWithLineWidth:(CGFloat)lineWidth
{
    CGFloat width = MIN(self.width, self.height);
    CGFloat offsetX = (MAX(self.width, self.height) - width) / 2;
    CGFloat offsetY = (self.height - width) / 2;
    
    CircleView *view = [[CircleView alloc] initWithFrame:CGRectMake(offsetX, offsetY, width, width)];
    view.lineWidth = lineWidth;
    return view;
}

- (void)runTimer:(NSTimer *)timer
{
    _angle += 10;
    if (_angle > 360)
        _angle = _angle - 360;
    
    CGAffineTransform transform = CGAffineTransformMakeRotation(_angle * M_PI / 180);
    [self.circleView setTransform:transform];
    [self setNeedsDisplay];
}


@end
