//
//  AppDelegate.m
//  AqiApiForIOS
//
//  Created by xu yannan on 13-3-25.
//  Copyright (c) 2013年 BLUETIGER. All rights reserved.
//

#import "AppDelegate.h"
#import "ApiTestViewController.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    ApiTestViewController *apiTestVC = [[ApiTestViewController alloc]initWithNibName:@"ApiTestViewController" bundle:nil];
    self.window.rootViewController  = apiTestVC;
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];

    return YES;
}


@end
