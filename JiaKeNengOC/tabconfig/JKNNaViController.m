//
//  JKNNaViController.m
//  JiaKeNengOC
//
//  Created by jkn-mac on 2023/6/14.
//

#import "JKNNaViController.h"

@interface JKNNaViController () <UIGestureRecognizerDelegate>

@end

@implementation JKNNaViController

+(void)initialize
{
    // 获取哪个类下面的导航条
    UINavigationBar *bar = [UINavigationBar appearanceWhenContainedIn:self, nil];
    bar.tintColor = [UIColor whiteColor];
}

-(void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationBar.translucent = YES;
    [self.navigationBar setShadowImage:[UIImage new]];

    // 禁止使用系统自带的滑动手势
    self.interactivePopGestureRecognizer.enabled = YES;
}

#pragma mark - ---- 解决全屏手势和左滑删除冲突,禁止右滑 ----
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer{

    if ([gestureRecognizer isKindOfClass:[UIPanGestureRecognizer class]]) {
        
        if (self.childViewControllers.count == 1 ) {
            return NO;
        }
        
        if (self.interactivePopGestureRecognizer &&
            [[self.interactivePopGestureRecognizer.view gestureRecognizers] containsObject:gestureRecognizer]) {
            
            CGPoint tPoint = [(UIPanGestureRecognizer *)gestureRecognizer translationInView:gestureRecognizer.view];
            
            if (tPoint.x >= 0) {
                CGFloat y = fabs(tPoint.y);
                CGFloat x = fabs(tPoint.x);
                CGFloat af = 30.0f/180.0f * M_PI;
                CGFloat tf = tanf(af);
                if ((y/x) <= tf) {
                    return YES;
                }
                return NO;
            }else{
                return NO;
            }
        }
    }
    
    return YES;
}

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    if ([self.viewControllers count] > 0){
        viewController.hidesBottomBarWhenPushed = YES;
        //[viewController TTLeftBarImage:@"NVBack"];
        viewController.edgesForExtendedLayout = UIRectEdgeBottom;
//        viewController.view.backgroundColor = PXColorFromHexadecimalRGB(0xF8F8F8);
    }
    [super pushViewController:viewController animated:animated];
}

-(UIViewController *)popViewControllerAnimated:(BOOL)animated
{
    if (self.viewControllers.count == 2) {
        self.tabBarController.tabBar.hidden = NO;
    }
    return [super popViewControllerAnimated:animated];
}

@end
