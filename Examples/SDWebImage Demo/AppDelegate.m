//
//  AppDelegate.m
//  SDWebImage Demo
//
//  Created by Olivier Poitrey on 09/05/12.
//  Copyright (c) 2012 Dailymotion. All rights reserved.
//

#import "AppDelegate.h"

#import "MasterViewController.h"

#import <SDWebImage/SDImageCache.h>

@implementation AppDelegate
// 自动生成get,set方法
@synthesize window = _window;
@synthesize navigationController = _navigationController;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // 添加一个自定义的只读缓存路径 (SD缓存里面就有两个缓存路劲了,一个是默认的一个是自己添加的)
    NSString *bundledPath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"CustomPathImages"];
    [[SDImageCache sharedImageCache] addReadOnlyCachePath:bundledPath];

    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    // 应用程序启动后自定义的覆盖点.
    MasterViewController *masterViewController = [[MasterViewController alloc] initWithNibName:@"MasterViewController" bundle:nil];
    self.navigationController = [[UINavigationController alloc] initWithRootViewController:masterViewController];
    self.window.rootViewController = self.navigationController;
    [self.window makeKeyAndVisible];
    return YES;
}

@end
