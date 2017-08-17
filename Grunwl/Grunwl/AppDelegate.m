//
//  AppDelegate.m
//  Grunwl
//
//  Created by mojingyu on 16/1/29.
//  Copyright © 2016年 Mojy. All rights reserved.
//

#import "AppDelegate.h"
#import "HomeViewController.h"
#import "MonitorViewController.h"
#import "HelpViewController.h"
#import "SettingViewController.h"
#import "MainViewController.h"
#import <AVFoundation/AVFoundation.h>
#import "BluetoothManager.h"
#import <Bugly/Bugly.h>

#define BUGLY_APP_ID @"900045996"

@interface AppDelegate ()

@property (nonatomic, strong) AVAudioPlayer *player;
@property (nonatomic, strong) NSTimer *countdownTimer;

@end

@implementation AppDelegate

@synthesize languageType = _languageType;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.

    // 初始化bugly 需要异步，否则会阻塞
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        [self setupBugly];
    });
    
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    
//    MainViewController *mainVC = [[MainViewController alloc] init];
//    self.window.rootViewController = mainVC;
    
    self.isPad = NO;
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        self.isPad = NO;
    } else if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
        self.isPad = YES;
    }
    
    UITabBarController *tabBarController = [[UITabBarController alloc] init];
    self.window.rootViewController = tabBarController;
    
    HomeViewController *homeVC = [[HomeViewController alloc] init];
    UINavigationController *homeNaveigationController = [[UINavigationController alloc] initWithRootViewController:homeVC];
    homeNaveigationController.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"主页" image:nil tag:0];
    
    MonitorViewController *monitorVC = [[MonitorViewController alloc] init];
    UINavigationController *monitorNaveigationController = [[UINavigationController alloc] initWithRootViewController:monitorVC];
    monitorNaveigationController.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"主控" image:nil tag:1];
    
    HelpViewController *helpVC = [[HelpViewController alloc] init];
    UINavigationController *helpNaveigationController = [[UINavigationController alloc] initWithRootViewController:helpVC];
    helpNaveigationController.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"帮助" image:nil tag:2];
    
    SettingViewController *settingVC = [[SettingViewController alloc] init];
    UINavigationController *settingNaveigationController = [[UINavigationController alloc] initWithRootViewController:settingVC];
    settingNaveigationController.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"设置" image:nil tag:3];
    
    tabBarController.viewControllers = @[homeNaveigationController, monitorNaveigationController, helpNaveigationController, settingNaveigationController];
    
    //语言初始化
    if ([[self getPreferredLanguage] isEqualToString:@"ru-CN"]) {
        self.languageType = Text_Ru;
    } else if ([[self getPreferredLanguage] isEqualToString:@"tr-CN"]) {
        self.languageType = Text_Tr;
    } else if ([[self getPreferredLanguage] isEqualToString:@"it-CN"]) {
        self.languageType = Text_It;
    } else if ([[self getPreferredLanguage] isEqualToString:@"pt-PT"]
               || [[self getPreferredLanguage] isEqualToString:@"pt-BR"]) {
        self.languageType = Text_Pt;
    } else if ([[self getPreferredLanguage] isEqualToString:@"es-CN"]) {
        self.languageType = Text_Es;
    } else if ([[self getPreferredLanguage] isEqualToString:@"ar-CN"]) {
        self.languageType = Text_Ar;
    } else if ([[self getPreferredLanguage] isEqualToString:@"ko-CN"]) {
        self.languageType = Text_Ko;
    } else {
        self.languageType = Text_En;
    }
    
#ifdef USE_ZH
    if ([[self getPreferredLanguage] isEqualToString:@"zh-Hans-CN"]) {
        self.languageType = Text_Zh;
    }
#endif
    
    self.enableButtons = NO;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeLanuageAction:) name:Notify_Change_Lanuage object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateMonitorData:) name:Notify_Update_MonitorData object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(exitApplication) name:Notify_ExitApp object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(countdownStart) name:Notify_Operation object:nil];
    
    //连接成功播放语音
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(discoverDevice:) name:Notify_Connected object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(disconnectDevice:) name:Notify_Disconnect object:nil];
    
//    NSString *passwordStr = [[NSUserDefaults standardUserDefaults] objectForKey:PASSWORD];
//    if (passwordStr && [passwordStr isEqualToString:DEFAULT_PASSWORD]) {
//        self.isLogin = YES;
//    } else {
//        self.isLogin = NO;
//    }
    
//    self.window.rootViewController = naveigationController;
    [self.window makeKeyAndVisible];
    [self countdownStart];
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (NSDictionary *)TextDictionary
{
    if (!_TextDictionary) {
        
        //获取系统语言信息，中英文
        [self updateLanguageText];
    }
    return _TextDictionary;
}

- (NSDictionary *)logoDictionary
{
    if (!_logoDictionary) {
        NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"Logo" ofType:@"plist"];
        _logoDictionary = [[NSDictionary alloc] initWithContentsOfFile:plistPath];
    }
    return _logoDictionary;
}

//- (TextLanguageType)languageType
//{
//    if ([[self getPreferredLanguage] isEqualToString:@"zh-Hans-CN"]) {
//        return Text_Zh;
//    } else {
//        return Text_En;
//    }
//}

- (NSString*)getPreferredLanguage
{
    NSUserDefaults* defs = [NSUserDefaults standardUserDefaults];
    NSArray* languages = [defs objectForKey:@"AppleLanguages"];
    NSString* preferredLang = [languages objectAtIndex:0];
    NSLog(@"\n=========== Preferred Language:%@ ===============\n", preferredLang);
    return preferredLang;
}

- (void)changeLanuageAction:(NSNotification *)notify
{
    [self updateLanguageText];
}

- (void)updateLanguageText
{
    NSString *textName = [self getLanguageTextName];
    NSString *plistPath = [[NSBundle mainBundle] pathForResource:textName ofType:@"plist"];
    _TextDictionary = [[NSDictionary alloc] initWithContentsOfFile:plistPath];
}

- (NSString *)getLanguageTextName
{
    
#ifdef USE_ZH
    if (self.languageType == Text_Zh)
        return @"Text_zh";
#endif
    
    if (self.languageType == Text_Ru)
        return @"Text_ru";
    else if (self.languageType == Text_Tr)
        return @"Text_tr";
    else if (self.languageType == Text_Ko)
        return @"Text_ko";
    else if (self.languageType == Text_It)
        return @"Text_it";
    else if (self.languageType == Text_Pt)
        return @"Text_pt";
    else if (self.languageType == Text_Es)
        return @"Text_es";
    else if (self.languageType == Text_Ar)
        return @"Text_ar";
    
    return @"Text_en";
}

- (void)updateMonitorData:(NSNotification *)notify
{
    self.monitorDictionary = [notify.userInfo copy];
}

- (NSMutableDictionary *)monitorDictionary
{
    if (!_monitorDictionary) {
        _monitorDictionary = [[NSMutableDictionary alloc] init];
        
#ifdef DEBUG
        [_monitorDictionary setObject:@"10.5" forKey:@"D1"];
        [_monitorDictionary setObject:@"5.5" forKey:@"D2"];
        [_monitorDictionary setObject:@"2" forKey:@"D3"];
        [_monitorDictionary setObject:@"20" forKey:@"D4"];
        [_monitorDictionary setObject:@"1.5" forKey:@"D5"];
        [_monitorDictionary setObject:@"2" forKey:@"D6"];
        [_monitorDictionary setObject:@"1.5" forKey:@"D7"];
        [_monitorDictionary setObject:@"1.5" forKey:@"D8"];
        [_monitorDictionary setObject:@"1" forKey:@"D9"];
#endif
        
    }
    return _monitorDictionary;
}

- (void)exitApplication
{
#ifdef TestImitateBluetoolDevice
    return;
#else
    
    [UIView animateWithDuration:0.4f animations:^{
        self.window.alpha = 0;
        CGFloat y = self.window.bounds.size.height;
        CGFloat x = self.window.bounds.size.width / 2;
        self.window.frame = CGRectMake(x, y, 0, 0);
    } completion:^(BOOL finished) {
        exit(0);
    }];
    
#endif
    
//    [UIView beginAnimations:@"exitApplication" context:nil];
//    [UIView setAnimationDuration:0.5];
//    [UIView setAnimationDelegate:self];
//    [UIView setAnimationTransition:UIViewAnimationTransitionCurlDown forView:self.window cache:NO];
//    [UIView setAnimationDidStopSelector:@selector(animationFinished:finished:context:)];
//    self.window.bounds = CGRectMake(0, 0, 0, 0);
//    [UIView commitAnimations];
}
- (void)animationFinished:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context {
    if ([animationID compare:@"exitApplication"] == 0) {
        exit(0);
    }
}

#pragma mark -消息处理

- (void)discoverDevice:(NSNotification *)notify
{
    static BOOL playedMp3 = NO;
    
    if (playedMp3)
        return;
    
    if ([BluetoothManager sharedInstance].peripheral.state == CBPeripheralStateConnected) {
        
        [[BluetoothManager sharedInstance] sendDataWithCommandType:Command_ReadSerialNumber];
        [self playMp3WithName:@"Connected.mp3"];
        playedMp3 = YES;
    }
    
}

- (void)disconnectDevice:(NSNotification *)notify
{
    //重新扫描
    if ([BluetoothManager sharedInstance].peripheral == CBPeripheralStateDisconnected) {
        [[BluetoothManager sharedInstance] scanDevice];       
    }
}

- (void)playMp3WithName:(NSString *)fileName
{
    @try {
        if (_player) {
            [_player stop];
        }
        
        NSString *soundPath = [NSString stringWithFormat:@"%@/%@", [[NSBundle mainBundle]resourcePath], fileName];
        //    NSString *soundPath=[[NSBundle mainBundle] pathForResource:@"Scaning" ofType:@"mp3"];
        //把音频文件转换成url格式
        NSURL *url = [NSURL fileURLWithPath:soundPath];
        AVAudioPlayer *newAudioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:nil];
        self.player = newAudioPlayer;
        //    _player.volume = 1;
        _player.numberOfLoops = 0;
        [_player prepareToPlay];
        
        
        [_player play];
    } @catch (NSException *exception) {
        ;
    } @finally {
        ;
    }
    
}

- (void)countdownStart
{
    if (self.countdownTimer) {
        [self.countdownTimer invalidate];
        self.countdownTimer = nil;
    }
    
    //没有收到操作消息则5分钟后退出
    self.countdownTimer = [NSTimer scheduledTimerWithTimeInterval:300 target:self selector:@selector(exitApplication) userInfo:nil repeats:NO];
}

#pragma mark - Bugly
- (void)setupBugly
{
    // Get the default config
    BuglyConfig * config = [[BuglyConfig alloc] init];
    
    // Open the debug mode to print the sdk log message.
    // Default value is NO, please DISABLE it in your RELEASE version.
#if DEBUG
    config.debugMode = YES;
#endif
    
    // Open the customized log record and report, BuglyLogLevelWarn will report Warn, Error log message.
    // Default value is BuglyLogLevelSilent that means DISABLE it.
    // You could change the value according to you need.
    config.reportLogLevel = BuglyLogLevelWarn;
    
    // Open the STUCK scene data in MAIN thread record and report.
    // Default value is NO
    config.blockMonitorEnable = YES;
    
    // Set the STUCK THRESHOLD time, when STUCK time > THRESHOLD it will record an event and report data when the app launched next time.
    // Default value is 3.5 second.
    config.blockMonitorTimeout = 1.5;
    
    // Set the app channel to deployment
    config.channel = @"Bugly";
    
    // NOTE:Required
    // Start the Bugly sdk with APP_ID and your config
    [Bugly startWithAppId:BUGLY_APP_ID config:config];
    
    // Set the customizd tag thats config in your APP registerd on the  bugly.qq.com
    [Bugly setTag:1799];
    
    [Bugly setUserIdentifier:[NSString stringWithFormat:@"User: %@", [NSProcessInfo processInfo].hostName]];
    
    [Bugly setUserValue:[NSProcessInfo processInfo].processName forKey:@"App"];
    
    // NOTE: This is only TEST code for BuglyLog , please UNCOMMENT it in your code.
    //    [self performSelectorInBackground:@selector(testLogOnBackground) withObject:nil];
    
//        [self testNSException];
}

/**
 *    @brief TEST method for BuglyLog
 */
- (void)testLogOnBackground {
    int cnt = 0;
    while (1) {
        cnt++;
        
        switch (cnt % 5) {
            case 0:
                BLYLogError(@"Test Log Print %d", cnt);
                break;
            case 4:
                BLYLogWarn(@"Test Log Print %d", cnt);
                break;
            case 3:
                BLYLogInfo(@"Test Log Print %d", cnt);
                BLYLogv(BuglyLogLevelWarn, @"BLLogv: Test", NULL);
                break;
            case 2:
                BLYLogDebug(@"Test Log Print %d", cnt);
                BLYLog(BuglyLogLevelError, @"BLLog : %@", @"Test BLLog");
                break;
            case 1:
            default:
                BLYLogVerbose(@"Test Log Print %d", cnt);
                break;
        }
        
        // print log interval 1 sec.
        sleep(1);
    }
}

- (void)testNSException {
    dispatch_async(dispatch_get_main_queue(), ^{
        NSLog(@"it will throw an NSException ");
        NSArray * array = @[];
        NSLog(@"the element is %@", array[1]);
    });
    
}

@end
