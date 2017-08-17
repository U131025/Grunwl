//
//  StatusView.m
//  Grunwl
//
//  Created by mojingyu on 16/1/31.
//  Copyright © 2016年 Mojy. All rights reserved.
//

#import "StatusView.h"

@interface StatusView()

@end

@implementation StatusView

- (void)setTopText:(NSString *)topText
{
    if (_topLabel) {
        _topLabel.text = topText;
    }
}

- (void)setMidText:(NSString *)midText
{
    if (_midLabel) {
        _midLabel.text = midText;
    }
}

- (void)setBottomText:(NSString *)bottomText
{
    if (_bottomLabel) {
        _bottomLabel.text = bottomText;
    }
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        //
        self.layer.borderColor = BlackColor.CGColor;
        self.layer.borderWidth = 1;
        self.backgroundColor = BlueBackgroundColor;
        
        CGFloat cellHeight = CGRectGetHeight(frame) / 3;
        CGFloat fontSize = APPDELEGATE.languageType == Text_Zh ? 20 : 16;
        if (APPDELEGATE.isPad)
            fontSize = 30;
        
        _topLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.width, cellHeight)];
        _topLabel.textColor = WhiteColor;
        _topLabel.font = Font(fontSize);
        _topLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:_topLabel];
        
        _midLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, cellHeight, self.width, cellHeight)];
        _midLabel.textColor = WhiteColor;
        _midLabel.font = Font(fontSize);
        _midLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:_midLabel];

        _bottomLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_midLabel.frame), self.width, cellHeight)];
        _bottomLabel.textColor = WhiteColor;
        _bottomLabel.font = Font(fontSize);
        _bottomLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:_bottomLabel];

    }
    return self;
}

@end
