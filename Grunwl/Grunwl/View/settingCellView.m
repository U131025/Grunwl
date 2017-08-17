//
//  settingCellView.m
//  Grunwl
//
//  Created by mojingyu on 16/1/31.
//  Copyright © 2016年 Mojy. All rights reserved.
//

#import "settingCellView.h"
#import "UIDefine.h"


@interface settingCellView()

@property (nonatomic, strong) UIButton *titleButton;
@property (nonatomic, strong) UIButton *valueButton;
@property (nonatomic, strong) UIButton *okButton;



@end

@implementation settingCellView

- (void)setTitleText:(NSString *)titleText
{
    if (_titleButton) {
        [_titleButton setTitle:titleText forState:UIControlStateNormal];
    }
}

- (void)setValueText:(NSString *)valueText
{
    if (_valueButton) {
        [_valueButton setTitle:valueText forState:UIControlStateNormal];
    }
}

- (void)setPlaceholder:(NSString *)placeholder
{
    if (_valueTextField) {
        _valueTextField.placeholder = placeholder;
    }
}

- (void)setKeyboardType:(ValidationType)keyboardType
{
    if (_valueTextField) {
        [inputHelper setupValidationType:keyboardType forInputField:_valueTextField];
    }
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        _keyboardType = ValidationTypeNumberPoint;
        NSInteger fontSize = IS_IPHONE_5_OR_LESS ? 12 : 16;
//        if (APPDELEGATE.languageType == Text_En) {
//            fontSize -= 3;
//        }
        
        CGFloat ratio = 1.0;
        if (APPDELEGATE.isPad) {
            fontSize = 25;
            ratio = 1.5;
        }

        _okButton = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetWidth(frame)-70*ratio, 2, 60*ratio, CGRectGetHeight(frame)-4)];
        _okButton.layer.borderWidth = 1;
        _okButton.layer.borderColor = BlackColor.CGColor;
        _okButton.backgroundColor = DarkGreenBackgroundColor;
        _okButton.titleLabel.font = Font(fontSize);
        
        [_okButton addTarget:self action:@selector(okClickAction:) forControlEvents:UIControlEventTouchUpInside];
        [_okButton setTitleColor:BlackColor forState:UIControlStateNormal];
        [_okButton setTitle:@"ok" forState:UIControlStateNormal];
        [self addSubview:_okButton];
        
        UIView *borderView = [[UIView alloc] initWithFrame:CGRectMake(CGRectGetMinX(_okButton.frame)-82*ratio, CGRectGetMinY(_okButton.frame), 80*ratio, CGRectGetHeight(_okButton.frame))];
        borderView.layer.borderWidth = 1;
        borderView.layer.borderColor = BlackColor.CGColor;
        borderView.backgroundColor = DarkGreenBackgroundColor;
        
        _valueTextField = [[UITextField alloc] initWithFrame:CGRectMake(10, 5, CGRectGetWidth(borderView.frame)-20, CGRectGetHeight(borderView.frame)-10)];
        [borderView addSubview:_valueTextField];
        _valueTextField.textColor = BlackColor;
        _valueTextField.font = Font(fontSize);
        _valueTextField.keyboardType = UIKeyboardTypeDecimalPad;
//        [inputHelper setupValidationType:_keyboardType forInputField:_valueTextField];
        [self addSubview:borderView];
        
        _valueButton = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetMinX(borderView.frame)-82*ratio, CGRectGetMinY(borderView.frame), 80*ratio, CGRectGetHeight(borderView.frame))];
        _valueButton.layer.borderWidth = 1;
        _valueButton.layer.borderColor = BlackColor.CGColor;
        _valueButton.backgroundColor = DarkGreenBackgroundColor;
        _valueButton.titleLabel.font = Font(fontSize);
        [_valueButton setTitleColor:BlackColor forState:UIControlStateNormal];
        [self addSubview:_valueButton];
        
        //title
        _titleButton = [[UIButton alloc] initWithFrame:CGRectMake(5*ratio, 2, CGRectGetMinX(_valueButton.frame) - 7*ratio, CGRectGetHeight(frame)-4)];
        
        _titleButton.titleLabel.font = Font(fontSize);
        _titleButton.titleLabel.numberOfLines = 0;
        _titleButton.titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleButton.layer.borderWidth = 1;
        _titleButton.layer.borderColor = BlackColor.CGColor;
        _titleButton.backgroundColor = LightBlueBackgroundColor;
        [_titleButton setTitleColor:WhiteColor forState:UIControlStateNormal];
        [self addSubview:_titleButton];
      
    }
    return self;
}

- (void)okClickAction:(UIButton *)button
{
    if ([self.delegate respondsToSelector:@selector(settingCellViewButtonClick: withValue:)]) {
        MyLog(@"value : %@", self.valueTextField.text);
        [self.delegate settingCellViewButtonClick:self.tag withValue:self.valueTextField.text];
    }
}

- (void)enableOKButton
{
    _okButton.backgroundColor = DarkGreenBackgroundColor;
    _okButton.enabled = YES;
    [_okButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];

}
- (void)disableOKButton
{
    _okButton.backgroundColor = [UIColor lightGrayColor];
    _okButton.enabled = NO;
    [_okButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];

}

@end
