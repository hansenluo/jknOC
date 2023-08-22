//
//  BaseViewController.m
//  JiaKeNengOC
//
//  Created by jkn-mac on 2023/6/27.
//

#import "BaseViewController.h"
#import <CoreTelephony/CTCellularData.h>
#import <MJRefresh/MJRefresh.h>

#define NETWORKCHANGEKEY @"NETWORKCHANGEKEY"

@interface BaseViewController ()

@end

@implementation BaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.isFristNet = YES;
    self.titleView.needsLoadingView = YES;
    [self setbackImage:[UIImage imageNamed:@"icon_back_btn"]];
    
    [self adjustFonts];
    [self initDataHandleAction];
    [self initUIHandleAction];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(networkingStatusChange) name:NETWORKCHANGEKEY object:nil];
}

- (void)setTitle:(NSString *)title {
    [super setTitle:title];
    if (NSProcessInfo.processInfo.environment[@"isUITest"].boolValue && self.isViewLoaded) {
        self.view.accessibilityLabel = [NSString stringWithFormat:@"viewController-%@", self.title];
    }
}

- (BOOL)shouldCustomizeNavigationBarTransitionIfHideable {
    return YES;
}

//设置返回按钮
-(void)setbackImage:(UIImage *)image
{
    if(_hidebackBtn){
        return;
    }
    
    UIButton *bBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
    [bBtn setImage:image forState:UIControlStateNormal];
    [bBtn setImage:image forState:UIControlStateHighlighted];
    [bBtn setImageEdgeInsets:UIEdgeInsetsMake(0, image.size.width - 44, 0, 0)];
    bBtn.contentEdgeInsets = UIEdgeInsetsMake(0, -10, 0, 0);
    
    [bBtn addTarget:self action:@selector(handleBackButtonEvent) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:bBtn];
    
    // 3.使UIButton能够靠左，不向右侧便移
        UIBarButtonItem *spaceItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
        spaceItem.width = -10;
    
//    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithImage:image style:UIBarButtonItemStylePlain target:self action:@selector(handleBackButtonEvent)];
    self.navigationItem.leftBarButtonItems = @[spaceItem,item];
    self.forceEnableBackGesture = YES;
    self.navigationItem.rightBarButtonItems = nil;
}

- (void)hiddenbackBtn{
    self.navigationItem.leftBarButtonItems = nil;
    self.navigationItem.hidesBackButton = YES;
    self.forceEnableBackGesture = NO;
    _hidebackBtn = YES;
}

//添加右边按钮
-(void)setrightNavItem:(NSArray *)items{
    NSMutableArray *itemsArr = [NSMutableArray array];
    for (int i = 0;i < items.count;i ++) {
        id item  = items[i];
        if([item isKindOfClass:[NSString class]]){
            UIBarButtonItem *bar = [UIBarButtonItem qmui_itemWithButton:[[QMUINavigationButton alloc] initWithType:QMUINavigationButtonTypeNormal title:item] target:self action:@selector(navRightButtonEvent:)];
            bar.tag = i;
            [itemsArr addObject:bar];
        }else if([item isKindOfClass:[UIImage class]]){
            UIBarButtonItem *bar = [UIBarButtonItem qmui_itemWithImage:item target:self action:@selector(navRightButtonEvent:)];
            bar.tag = i;
            [itemsArr addObject:bar];
        }
    }
    self.navigationItem.rightBarButtonItems = itemsArr;
}

//返回
- (void)handleBackButtonEvent{
    [self.navigationController popViewControllerAnimated:YES];
}

- (BOOL)forceEnableInteractivePopGestureRecognizer {
    return self.forceEnableBackGesture;
}

//nav右边按钮
-(void)navRightButtonEvent:(UIBarButtonItem *)item
{
    
}

#pragma mark - QMUINavigationControllerDelegate
- (BOOL)preferredNavigationBarHidden {
    return self.navigationBarHidden;
}

- (void)setNavigationBarHidden:(BOOL)navigationBarHidden {
    [self.navigationController setNavigationBarHidden:navigationBarHidden animated:NO];
    _navigationBarHidden = navigationBarHidden;
}

- (void)networkingStatusChange {
//    int64_t status = [MMKVDefault getInt64ForKey:AFNetworkStatus];
//
//    if (status == AFNetworkReachabilityStatusUnknown || status == AFNetworkReachabilityStatusNotReachable) {
//        self.isNetWorking = NO;
//    } else if (status == AFNetworkReachabilityStatusReachableViaWWAN || status == AFNetworkReachabilityStatusReachableViaWiFi) {
//        self.isNetWorking = YES;
//    }
//    [self reloadNetworkUI];
//
//    if (!self.isFristNet) {
//        [self refreshBtnAction];
//    }
//    self.isFristNet = NO;
}
//网络判断
- (void)reloadNetworkUI {
//    if (self.isNetWorking) {
//        [self.netWorkEmptyView removeFromSuperview];
//    } else {
//        [[[UIApplication sharedApplication] keyWindow] addSubview:self.netWorkEmptyView];
//    }
}

-(void)refreshBtnAction {
    
}

-(void)viewDidDisappear:(BOOL)animated{
    [self.view progressDiss];
}

//- (NetWorkView *)netWorkEmptyView {
//    if(!_netWorkEmptyView && self.isViewLoaded){
//        _netWorkEmptyView = [[NetWorkView alloc] init];
//        _netWorkEmptyView.frame = CGRectMake(0, 0, screenW, screenH);
//        _netWorkEmptyView.delegate = self;
//    }
//    return _netWorkEmptyView;
//}

- (UIStatusBarStyle)preferredStatusBarStyle {
  // 如果app绝大多数页面要设置黑色样式，可以不写此方法，因为默认样式就是黑色的。
  // return UIStatusBarStyleDefault;
    // 白色样式
    return UIStatusBarStyleLightContent;
}


#pragma mark -- 点击网络刷新按钮
-(void)refreshNetBtnAction {
//    if (self.isNetWorking) {
//        [self.netWorkEmptyView removeFromSuperview];
//    } else {
//        [QMUITips showWithText:@"当前网络不可用，请稍后重试"];
//    }
}

/** 使用与类名相同的标识从Storyboard创建控制器*/
+ (instancetype)instanceWithSb:(NSString *)sbName {
    NSString *identifier = NSStringFromClass(self);
    return [self instanceWithSb:sbName identifier:identifier];
}

/** @abstract 从Storyboard创建控制器*/
+ (instancetype)instanceWithSb:(NSString *)sbName identifier:(NSString *)identifier {
    UIStoryboard *sb = [UIStoryboard storyboardWithName:sbName bundle:nil];
    return [sb instantiateViewControllerWithIdentifier:identifier];
}

- (void)adjustFonts {
    //字体调整
}

- (void)initDataHandleAction {
    //先处理数据
}

- (void)initUIHandleAction {
    //后根据数据跟初始化的UI赋值
}

- (void)mjRefreshEndIsHeaderRefresh:(BOOL)isHeader TotalPages:(NSInteger)totalPages CurrentPage:(NSInteger)currentPage Object:(UIScrollView *)object {
    if (isHeader) {
        [object.mj_footer setState:currentPage >= totalPages?MJRefreshStateNoMoreData:MJRefreshStateIdle];
        [object.mj_header endRefreshing];
    } else {
        if (currentPage >= totalPages) {
            [object.mj_footer setState:MJRefreshStateNoMoreData];
        }else{
            [object.mj_footer endRefreshing];
        }
    }
}

- (void)mjRefreshEndIsHeaderRefreshIfRequestFailed:(BOOL)isHeader Object:(UIScrollView *)object {
    if (isHeader) {
        [object.mj_header endRefreshing];
    } else {
        [object.mj_footer endRefreshing];
    }
}

#pragma mark - lazy
- (UIImage *)backBtnImageBlack {
    if (!_backBtnImageBlack) {
        _backBtnImageBlack = [UIImageMake(@"navi_icon_back") qmui_imageWithTintColor:BlackColor];
    }
    return _backBtnImageBlack;
}

- (UIImage *)backBtnImageWhite {
    if (!_backBtnImageWhite) {
        _backBtnImageWhite = [UIImageMake(@"navi_icon_back") qmui_imageWithTintColor:WhiteColor];
    }
    return _backBtnImageWhite;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
