//
//  AppDelegate.m
//  JiaKeNengOC
//
//  Created by jkn-mac on 2023/6/14.
//

#import "AppDelegate.h"
#import "JKNMainViewController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    self.window = [[UIWindow alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
    self.window.backgroundColor = [UIColor whiteColor];
    self.window.rootViewController = [[JKNMainViewController alloc] init];
    [self.window makeKeyAndVisible];
    
    [UITabBar appearance].translucent = NO;
    if(@available(iOS 11.0,*)){
        UIScrollView.appearance.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }
    
    if (@available(iOS 15.0, *)) {
        UITableView.appearance.sectionHeaderTopPadding = 0;
        UITableView.appearance.estimatedSectionHeaderHeight = 0;
        UITableView.appearance.estimatedSectionFooterHeight = 0;
    }

    self.orientations = UIInterfaceOrientationMaskPortrait;
    
    return YES;
}

/// 切换横竖屏：返回支持方向
- (UIInterfaceOrientationMask)application:(UIApplication *)application supportedInterfaceOrientationsForWindow:(UIWindow *)window {
    return self.orientations;
}

//- (UIInterfaceOrientationMask)application:(UIApplication *)application supportedInterfaceOrientationsForWindow:(UIWindow *)window {
//    if (self.allowRotation) {//如果设置了allowRotation属性，支持全屏
//        return UIInterfaceOrientationMaskAll;
//    }
//    return UIInterfaceOrientationMaskPortrait;//默认全局不支持横屏
//}

#pragma mark - UISceneSession lifecycle




@end
