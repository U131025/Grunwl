//
//  WebContrlViewController.m
//  Grunwl
//
//  Created by Mojy on 2017/8/17.
//  Copyright © 2017年 Mojy. All rights reserved.
//

#import "WebContrlViewController.h"
#import <ETILinkSDK/ETILinkSDK.h>

@interface WebContrlViewController ()

@end

@implementation WebContrlViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [ETILink addUserWithAppKey:@"" secretKey:@"" host:@"" port:8085 username:@"" nickname:@"" handler:^(ETUser * _Nullable, NSError * _Nullable) {
        
        
    }];
    

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
