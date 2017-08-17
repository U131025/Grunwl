//
//  UIDefine.h
//  Grunwl
//
//  Created by mojingyu on 16/1/30.
//  Copyright © 2016年 Mojy. All rights reserved.
//

#ifndef UIDefine_h
#define UIDefine_h

#define APPDELEGATE         ((AppDelegate *)[UIApplication sharedApplication].delegate)

#define kStatusBarHeight [[UIApplication sharedApplication] statusBarFrame].size.height

//判断是否是ios7
#define kIsIos7 ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0)
//判断是否是iPhone5
#define kIsiPhone5 ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone && [[UIScreen mainScreen] bounds].size.height > 481.0f)

#define ScreenScale()     [[UIScreen mainScreen] scale]

#define ScreenWidth [[UIScreen mainScreen] bounds].size.width

// 屏幕高度，去状态栏高度20
#define ScreenHeight (kIsIos7?[UIScreen mainScreen].bounds.size.height:([UIScreen mainScreen].bounds.size.height-20))

#define NavBarHeight (kIsIos7?64:44)//导航条高度

//#define Font(F) [UIFont systemFontOfSize:(F)]
#define Font(F) [UIFont fontWithName:@"TrebuchetMS-Bold" size:(F)]
#define FontNoBold(F) [UIFont systemFontOfSize:(F)]

#define IS_IPAD (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
#define IS_IPHONE (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
#define IS_RETINA ([[UIScreen mainScreen] scale] >= 2.0)

#define SCREEN_WIDTH ([[UIScreen mainScreen] bounds].size.width)
#define SCREEN_HEIGHT ([[UIScreen mainScreen] bounds].size.height)
#define SCREEN_MAX_LENGTH (MAX(SCREEN_WIDTH, SCREEN_HEIGHT))
#define SCREEN_MIN_LENGTH (MIN(SCREEN_WIDTH, SCREEN_HEIGHT))

#define IS_IPHONE_4_OR_LESS (IS_IPHONE && SCREEN_MAX_LENGTH < 568.0)
#define IS_IPHONE_5_OR_LESS (IS_IPHONE && SCREEN_MAX_LENGTH <= 568.0)
#define IS_IPHONE_5 (IS_IPHONE && SCREEN_MAX_LENGTH == 568.0)
#define IS_IPHONE_6 (IS_IPHONE && SCREEN_MAX_LENGTH == 667.0)
#define IS_IPHONE_6P (IS_IPHONE && SCREEN_MAX_LENGTH == 736.0)

#define ReturnControlPageTimeOutVlaue 60

//适配因子，以6P为准
#define SYRealValue(value) ((value)/414.0f*[UIScreen mainScreen].bounds.size.width)

#endif /* UIDefine_h */
