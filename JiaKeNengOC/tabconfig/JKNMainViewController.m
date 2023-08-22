//
//  JKNMainViewController.m
//  JiaKeNengOC
//
//  Created by jkn-mac on 2023/6/14.
//

#import "JKNMainViewController.h"
#import "JKNNaViController.h"

@interface JKNMainViewController ()

@end

@implementation JKNMainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor colorWithHexString:@"#17181C"];
    
    //添加子控制器
    [self addChildViewControllers];
}

- (void)addChildViewControllers{
    //图片大小建议32*32
    [self addChildrenViewController:[[NSClassFromString(@"JKNHomeController") alloc] init] andTitle:@"首页" andImageName:@"icon_home_select_n" andSelectImage:@"icon_home_select_s"];
    
    [self addChildrenViewController:[[NSClassFromString(@"QuotationListVC") alloc] init] andTitle:@"行情列表" andImageName:@"icon_course_select_n" andSelectImage:@"icon_course_select_s"];
    
    [self addChildrenViewController:[[NSClassFromString(@"stockPondVC") alloc] init] andTitle:@"股票金池" andImageName:@"icon_stock_select_n" andSelectImage:@"icon_stock_select_s"];

    [self addChildrenViewController:[[NSClassFromString(@"superSelectStockVC") alloc] init] andTitle:@"超级选股" andImageName:@"icon_stockselect_select_n" andSelectImage:@"icon_stockselect_select_s"];
    
    [self addChildrenViewController:[[NSClassFromString(@"alarmVC") alloc] init] andTitle:@"AI报警" andImageName:@"icon_call_select_n" andSelectImage:@"icon_call_select_s"];
}

- (void)addChildrenViewController:(UIViewController *)childVC andTitle:(NSString *)title andImageName:(NSString *)imageName andSelectImage:(NSString *)selectedImage{
    
    childVC.tabBarItem.image = [UIImage imageNamed:imageName];
    childVC.tabBarItem.selectedImage = [[UIImage imageNamed:selectedImage] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    childVC.title = title;
    
    UIColor *colorNormal = [UIColor colorWithHexString:@"#9096A0"];
    UIColor *colorSelect = [UIColor colorWithHexString:@"#447CFE"];
    
    //适配iOS13
    if (@available(iOS 13.0, *)) {
        // iOS13 及以上
        self.tabBar.tintColor = colorSelect;
        self.tabBar.unselectedItemTintColor = colorNormal;
        
        if (@available(iOS 15.0, *)) {
            self.tabBar.standardAppearance.backgroundColor = [UIColor colorWithHexString:@"#17181C"];
            ///用这个方法的，这个一定要加，否则15.0系统下会出问题，一滑动tabbar就变透明!!!
            self.tabBar.scrollEdgeAppearance = self.tabBar.standardAppearance;
        }
    }else {
        // iOS13 以下
        //UITabBarItem *item = [UITabBarItem appearance];
        [childVC.tabBarItem setTitleTextAttributes:@{ NSForegroundColorAttributeName:colorNormal} forState:UIControlStateNormal];
        [childVC.tabBarItem setTitleTextAttributes:@{ NSForegroundColorAttributeName:colorSelect} forState:UIControlStateSelected];
    }
    
    //childVC.view.backgroundColor = PXColorFromHexadecimalRGB(0xF8F8F8);
    JKNNaViController *baseNav = [[JKNNaViController alloc] initWithRootViewController:childVC];
    childVC.edgesForExtendedLayout = UIRectEdgeNone;
    
    [self addChildViewController:baseNav];
}


@end
