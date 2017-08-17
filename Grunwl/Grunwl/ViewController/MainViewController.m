//
//  MainViewController.m
//  Grunwl
//
//  Created by mojingyu on 16/3/2.
//  Copyright © 2016年 Mojy. All rights reserved.
//

#import "MainViewController.h"
#import "HomeViewController.h"
#import "MonitorViewController.h"
#import "HelpViewController.h"
#import "SettingViewController.h"

@implementation MainViewController

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
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
    
    UITabBarController *tabBarController = [[UITabBarController alloc] init];
    tabBarController.viewControllers = @[homeNaveigationController, monitorNaveigationController, helpNaveigationController, settingNaveigationController];
    
    self.tabBarController.selectedIndex = 0;
    
    [self.navigationController pushViewController:tabBarController animated:YES];
}

@end
