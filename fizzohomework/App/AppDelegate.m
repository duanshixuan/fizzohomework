//
//  AppDelegate.m
//  fizzohomework
//
//  Created by 段世宜 on 2018/9/2.
//  Copyright © 2018年 段世宜. All rights reserved.
//

#import "AppDelegate.h"
#import "FYHeader.h"
#import <IQKeyboardManager/IQKeyboardManager.h>
#import "FYFirstComeInViewController.h"
#import "FYAppContext.h"
#import "FYRootViewController.h"
@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    NSDictionary * dic = [launchOptions mutableCopy];
    void (^gotoRootVC)() = ^{
        FYAppContext *appContext = [FYAppContext sharedInstance];
        appContext.navigationHeight = kDevice_Is_iPhoneX ? 88.0 : 64.0;
        appContext.statusBarHeight = kDevice_Is_iPhoneX ? 44.0 : 20.0;
        appContext.tabBarHeight = kDevice_Is_iPhoneX ? 83.0 : 49.0;
        appContext.bottomMargin = kDevice_Is_iPhoneX ? 34.0 : 0.0;
        
        
        if (@available(iOS 11.0,*)) {
            UITableView.appearance.estimatedSectionHeaderHeight = 0;
            UITableView.appearance.estimatedSectionFooterHeight = 0;
            UITableView.appearance.estimatedRowHeight = 0;
            UITableView.appearance.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }
        
        
        
        
        
        if ([FYAppContext isHighWithVersion:[FYUserDefaults sharedInstance].showComeInVersion newVersion:[FYAppContext sharedInstance].appVersion]) {
            //第一次启动
            __weak typeof(self) weakSelf = self;
            FYFirstComeInViewController*vc = [[FYFirstComeInViewController alloc]init];
            vc.finishBlock = ^() {
                //                if ([NSString isEmpty:[FYUserDefaults sharedInstance].accessToken]){
                //                    [[FYRouter sharedRouter] clearUserInfoAndgotoLogin];
                //                    [weakSelf configuration:launchOptions];
                //                }else {
                [weakSelf defaultRootAndConfiguration:launchOptions];
                //                }
            };
            UINavigationController * nav = [[UINavigationController alloc] initWithRootViewController:vc];
            [nav setNavigationBarHidden:YES animated:NO];
            self.window.rootViewController = nav;
            
            [FYUserDefaults sharedInstance].showComeInVersion = [FYAppContext sharedInstance].appVersion;
        }else {
            [self defaultRootAndConfiguration:dic];
        }
        
        [self.window makeKeyAndVisible];
        [self setupFrameworksWithApplication:application options:launchOptions];
    };
    
    //    选择测试服务器
    //    [self setDebugDomain:gotoRootVC];
    gotoRootVC();
    
    
    return YES;
}
/**
 三方库配置及初始化
 */
- (void)setupFrameworksWithApplication:(UIApplication *)application options:(NSDictionary *)launchOptions {
    //  IQKeyboardManager 初始化
    IQKeyboardManager *keyboardManager = [IQKeyboardManager sharedManager];
    //    shouldShowTextFieldPlaceholder
    keyboardManager.shouldShowToolbarPlaceholder= NO;
    //设置IQKeyboardManager 失效的界面
    //    [[IQKeyboardManager sharedManager].disabledDistanceHandlingClasses addObject:[QYSessionViewController class]];
    
}
- (void)defaultRootAndConfiguration:(NSDictionary *)launchOptions {
    
    FYRootViewController * vc;
        vc = [[FYRootViewController alloc] init];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vc];
    [nav setNavigationBarHidden:YES animated:NO];
    self.window.rootViewController = nav;
    [self configuration:launchOptions];
}
/**
 优先级最高的全局配置或初始化
 */
- (void)configuration:(NSDictionary *)launchOptions{
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
