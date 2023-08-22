//
//  AppDelegate.h
//  JiaKeNengOC
//
//  Created by jkn-mac on 2023/6/14.
//

#import <UIKit/UIKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (nonatomic, strong) UIWindow *window;
/// 通过AppDelegate是实现旋转，解决部分页面强制旋转
/// 屏幕支持的方法方向
@property (nonatomic, assign) UIInterfaceOrientationMask orientations;

@end

