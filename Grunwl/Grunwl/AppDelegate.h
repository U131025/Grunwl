//
//  AppDelegate.h
//  Grunwl
//
//  Created by mojingyu on 16/1/29.
//  Copyright © 2016年 Mojy. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum
{
    Text_Zh,    //中文
    Text_En,    //英文
    Text_Ru,  //俄文
    Text_Tr,    //土耳其文
    Text_Ko,    //韩语
    Text_It,   //意大利语
    Text_Pt,   //葡萄牙语
    Text_Es,   //西班牙语
    Text_Ar,   //阿拉伯语
    
}TextLanguageType;

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) NSDictionary *TextDictionary;
@property (strong, nonatomic) NSDictionary *logoDictionary;

@property (assign, nonatomic) TextLanguageType languageType;
@property (assign, nonatomic) BOOL enableButtons;
@property (assign, nonatomic) BOOL isLogin;
@property (assign, nonatomic) BOOL isPad;

@property (nonatomic, strong) NSMutableDictionary *monitorDictionary;   //d1 ~ d8

- (NSString*)getPreferredLanguage;
- (void)playMp3WithName:(NSString *)fileName;

@end

