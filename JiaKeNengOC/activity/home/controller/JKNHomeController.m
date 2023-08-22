//
//  JKNHomeController.m
//  JiaKeNengOC
//
//  Created by jkn-mac on 2023/6/14.
//

#import "JKNHomeController.h"
#import "UserInfo.h"
#import "LoginView.h"
#import "RiskWarningView.h"
#import "HomeAlarmCell.h"
#import "HomePondCell.h"
#import "HomeAlarmHeaderView.h"
#import "HomePondHeaderView.h"
#import "KLineMainVC.h"
#import "HomeAlarmListVC.h"
#import "HomePondListVC.h"
#import <JXCategoryView/JXCategoryView.h>
#import <JXPagingView/JXPagerView.h>
#import <JXPagingView/JXPagerListRefreshView.h>
#import "HomeIndexView.h"
#import "SearchStockVC.h"

@interface JKNHomeController () <RiskWarningViewDelegate, JXCategoryViewDelegate, JXPagerViewDelegate, JXPagerMainTableViewGestureDelegate, LoginViewDelegate, HomeIndexViewDelegate, UITextFieldDelegate> {
    NSDictionary *_indexDataDict;
}

@property (nonatomic, weak) IBOutlet UITextField *searchTextField;
@property (nonatomic, weak) IBOutlet UIImageView *arrowUpImage;
@property (nonatomic, weak) IBOutlet UIImageView *arrowDownImage;
@property (nonatomic, weak) IBOutlet UIView *searchView;
@property (nonatomic, weak) IBOutlet UIView *categoryTitleView;
@property (nonatomic, weak) IBOutlet UIView *topView;
@property (nonatomic, weak) IBOutlet UILabel *accountLabel;
@property (nonatomic, weak) IBOutlet UIView *sView;
@property (nonatomic, weak) IBOutlet UIButton *loginBtn;

@property (nonatomic, weak) IBOutlet UIView *bgView01;
@property (nonatomic, weak) IBOutlet UIView *bgView02;
@property (nonatomic, weak) IBOutlet UIView *bgView03;
@property (nonatomic, weak) IBOutlet UILabel *indexNameLabel01;
@property (nonatomic, weak) IBOutlet UILabel *indexNameLabel02;
@property (nonatomic, weak) IBOutlet UILabel *indexNameLabel03;
@property (nonatomic, weak) IBOutlet UILabel *totalPriceLabel01;
@property (nonatomic, weak) IBOutlet UILabel *totalPriceLabel02;
@property (nonatomic, weak) IBOutlet UILabel *totalPriceLabel03;
@property (nonatomic, weak) IBOutlet UILabel *increaseLabel01;
@property (nonatomic, weak) IBOutlet UILabel *increaseLabel02;
@property (nonatomic, weak) IBOutlet UILabel *increaseLabel03;
@property (nonatomic, weak) IBOutlet UILabel *amplitudeLabel01;
@property (nonatomic, weak) IBOutlet UILabel *amplitudeLabel02;
@property (nonatomic, weak) IBOutlet UILabel *amplitudeLabel03;
@property (nonatomic, weak) IBOutlet UILabel *upTotalLabel;
@property (nonatomic, weak) IBOutlet UILabel *downTotalLabel;
@property (nonatomic, weak) IBOutlet UILabel *mdTimeLabel;
@property (nonatomic, weak) IBOutlet UIStackView *stackView;

@property (nonatomic, strong) JXCategoryTitleView *categoryV;
//@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) NSArray *titleArray;
@property (nonatomic, strong) NSMutableArray *indexViewArray;
@property (nonatomic, assign) NSInteger timeAddUp;

@property (nonatomic, strong) NSTimer *pollTimer;

@end

@implementation JKNHomeController

- (void)dealloc {
    [self.pollTimer invalidate];
    self.pollTimer = nil;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [self.pollTimer setFireDate:[NSDate distantFuture]];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.pollTimer setFireDate:[NSDate date]];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.navigationBarHidden = YES;
    self.view.backgroundColor = [UIColor colorWithHexString:@"#000000"];
    
    [self.searchView acs_radiusWithRadius:18 corner:UIRectCornerAllCorners];
    [self.arrowUpImage setImage:[UIImageMake(@"icon_down_arrow") qmui_imageWithTintColor:RiseColor]];
    self.arrowUpImage.transform = CGAffineTransformMakeRotation(M_PI);
    [self.arrowDownImage setImage:[UIImageMake(@"icon_down_arrow") qmui_imageWithTintColor:DropColor]];
    self.searchTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"纳斯达克指数" attributes:@{NSForegroundColorAttributeName:[UIColor colorWithHexString:@"#999999"]}];
    
    [self.bgView01 acs_radiusWithRadius:4 corner:UIRectCornerAllCorners];
    [self.bgView02 acs_radiusWithRadius:4 corner:UIRectCornerAllCorners];
    [self.bgView03 acs_radiusWithRadius:4 corner:UIRectCornerAllCorners];
    
    //网络请求
    [self getIndexesData];
    //[self setupScrollView];
    [self getAllStockCode];
    
    //后台自动登录
    if (!isNilString([[UserInfo Instance] getUserName])) {
        self.accountLabel.hidden = NO;
        self.accountLabel.text = [[UserInfo Instance] getUserName];
        [self.loginBtn setTitle:@"退出" forState:UIControlStateNormal];
        
        TMHttpParams *param = [[TMHttpParams alloc] init];
        [param setUrl:API_login_URL];
        [param addParams:[[UserInfo Instance] getUserName] forKey:@"mobile"];
        [param addParams:[[UserInfo Instance] getPassword] forKey:@"password"];
        [param addParams:@"login" forKey:@"customKey"];
        param.requestType = POST;
        [DataRequest requestWithParam:param successed:^(NSDictionary *dict, NSError *error, int result, NSString *msg) {
            
            if (result == 1) {
                NSLog(@"后台登录成功");
                PXNotifiPost(LOGINSTATUSKEY, nil);
            }else {
                self.accountLabel.hidden = YES;
                [self.loginBtn setTitle:@"登录" forState:UIControlStateNormal];
            }
        }];
    }
    
    //    NSLog(@"屏幕宽度 = %f",screenW);
    //    NSLog(@"左边安全距离 = %f，顶部安全距离 = %f，右边安全距离 = %f，底部安全距离 = %f",SafeAreaInsetsConstantForDeviceWithNotch.left,SafeAreaInsetsConstantForDeviceWithNotch.top,SafeAreaInsetsConstantForDeviceWithNotch.right,SafeAreaInsetsConstantForDeviceWithNotch.bottom);
}

- (void)autoUpdateData {
    //    if (self.indexViewArray.count == 0) {
    //        return;
    //    }
    
    TMHttpParams *param = [[TMHttpParams alloc] init];
    [param setUrl:API_getIndexesData_URL];
    param.requestType = POST;
    
    [DataRequest requestWithParam:param successed:^(NSDictionary *dict, NSError *error, int result, NSString *msg) {
        
        if (result == 1) {
            
            [self setStackViewDataWithDict:dict[@"data"]];
            
            //            NSArray *array = dict[@"data"];
            //            for (int i = 0; i < array.count; i++) {
            //                HomeIndexModel *model = [[HomeIndexModel alloc] init];
            //                model.stockCode = [array[i] objectForKey:@"code"];
            //                model.stockName = [array[i] objectForKey:@"name"];
            //                model.close = [[array[i] objectForKey:@"price"] doubleValue];
            //                model.high = [[array[i] objectForKey:@"high"] doubleValue];
            //                model.low = [[array[i] objectForKey:@"low"] doubleValue];
            //                model.open = [[array[i] objectForKey:@"open"] doubleValue];
            //                model.lasetDayclose = [[array[i] objectForKey:@"pre_close"] doubleValue];
            //                model.vol = [[array[i] objectForKey:@"volume"] doubleValue];
            //                model.amount = [[array[i] objectForKey:@"amount"] doubleValue];
            //
            //                HomeIndexView *view = (HomeIndexView *)self.indexViewArray[i];
            //                view.model = model;
            //            }
        }
    }];
}

#pragma mark ---- 初始化方法 ----
//- (void)setupScrollView {
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, self.searchView.BottomY + 15, screenW, 90)];
//        self.scrollView.backgroundColor = ClearColor;
//        self.scrollView.showsVerticalScrollIndicator = NO;
//        self.scrollView.showsHorizontalScrollIndicator = NO;
//        [self.view addSubview:self.scrollView];
//
//        [self getIndexesData];
//    });
//}

- (void)setupCategoryTitleView {
    
    self.titleArray = @[@"股票金池", @"AI报警"];
    self.categoryV = [[JXCategoryTitleView alloc] initWithFrame:CGRectMake(0, 0, screenW, 44)];
    [self.categoryTitleView addSubview:self.categoryV];
    self.categoryV.titles = self.titleArray;
    self.categoryV.backgroundColor = PrimaryColor;
    self.categoryV.delegate = self;
    self.categoryV.titleLabelVerticalOffset = -3;
    self.categoryV.titleColor = GrayColor;
    //self.categoryV.titleSelectedFont = [CJXCustom adjustFontWithSize:15.85 WithWeight:Medium];
    self.categoryV.titleSelectedColor = WhiteColor;
    self.categoryV.titleColorGradientEnabled = YES;
    
    JXCategoryIndicatorLineView *lineV = [[JXCategoryIndicatorLineView alloc] init];
    lineV.indicatorColor = [UIColor colorWithHexString:@"#447CFE"];
    lineV.indicatorWidth = 30;
    lineV.indicatorHeight = 3;
    lineV.verticalMargin = 5;
    self.categoryV.indicators = @[lineV];
    
    JXPagerView *pagerV = [[JXPagerListRefreshView alloc] initWithDelegate:self];
    pagerV.mainTableView.backgroundColor = ClearColor;
    pagerV.mainTableView.gestureDelegate = self;
    pagerV.isListHorizontalScrollEnabled = NO;
    self.categoryV.listContainer = (id<JXCategoryViewListContainer>)pagerV.listContainerView;
    [self.view insertSubview:pagerV aboveSubview:self.categoryV];
    [pagerV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.categoryTitleView.mas_bottom);
        make.left.right.equalTo(self.view);
        make.bottom.equalTo(self.view);
    }];
}

#pragma mark ---- 网络请求 ----
- (void)getIndexesData {
    [self.view showProgress:@""];
    TMHttpParams *param = [[TMHttpParams alloc] init];
    [param setUrl:API_getIndexesData_URL];
    param.requestType = POST;
    [DataRequest requestWithParam:param successed:^(NSDictionary *dict, NSError *error, int result, NSString *msg) {
        
        [self.view progressDiss];
        self.pollTimer = [NSTimer scheduledTimerWithTimeInterval:timeInterval target:self selector:@selector(autoUpdateData) userInfo:nil repeats:YES];
        [self setupCategoryTitleView];
        self.categoryTitleView.hidden = NO;
        self.sView.hidden = NO;
        self.stackView.hidden = NO;
        
        if (result == 1) {
            
            [self setStackViewDataWithDict:dict[@"data"]];
        
            //            if (self.indexViewArray.count > 0) {
            //                [self.indexViewArray removeAllObjects];
            //            }
            //
            //            NSArray *array = dict[@"data"];
            //            for (int i = 0; i < array.count; i++) {
            //                HomeIndexModel *model = [[HomeIndexModel alloc] init];
            //                model.stockCode = [array[i] objectForKey:@"code"];
            //                model.stockName = [array[i] objectForKey:@"name"];
            //                model.close = [[array[i] objectForKey:@"price"] doubleValue];
            //                model.high = [[array[i] objectForKey:@"high"] doubleValue];
            //                model.low = [[array[i] objectForKey:@"low"] doubleValue];
            //                model.open = [[array[i] objectForKey:@"open"] doubleValue];
            //                model.lasetDayclose = [[array[i] objectForKey:@"pre_close"] doubleValue];
            //                model.vol = [[array[i] objectForKey:@"volume"] doubleValue];
            //                model.amount = [[array[i] objectForKey:@"amount"] doubleValue];
            //
            //                HomeIndexView *view = [[[NSBundle mainBundle] loadNibNamed:@"HomeIndexView" owner:self options:nil] objectAtIndex:0];
            //                view.frame = CGRectMake(5 + 125 * i , 0, 120, 90);
            //                [view acs_radiusWithRadius:4 corner:UIRectCornerAllCorners];
            //                view.model = model;
            //                view.delegate = self;
            //                [self.scrollView addSubview:view];
            //
            //                [self.indexViewArray addObject:view];
            //            }
            //
            //            self.scrollView.contentSize = CGSizeMake(array.count*120 + (array.count+1)*5, 0);
        }else {
            //[self getIndexesData];
        }
    }];
}

- (void)setStackViewDataWithDict:(NSDictionary *)dict {
    _indexDataDict = dict;
    
    NSDictionary *dict01 = dict[@"DIA"];
    self.indexNameLabel01.text = dict01[@"name"];
    self.totalPriceLabel01.text = [NSString stringWithFormat:@"%.2f",[dict01[@"price"] doubleValue]];
//    CGFloat upDown01 = [[array[0] objectForKey:@"price"] doubleValue] - [[array[0] objectForKey:@"pre_close"] doubleValue];
    NSString *symbol01 = @"-";
    if([dict01[@"chg"] doubleValue] > 0) {
        symbol01 = @"+";
        self.totalPriceLabel01.textColor = ChartColors_dnColor;
        self.increaseLabel01.textColor = ChartColors_dnColor;
        self.amplitudeLabel01.textColor = ChartColors_dnColor;
        self.bgView01.backgroundColor = [UIColor colorWithHexString:@"#1EB45E"];
    } else {
        self.totalPriceLabel01.textColor = ChartColors_upColor;
        self.increaseLabel01.textColor = ChartColors_upColor;
        self.amplitudeLabel01.textColor = ChartColors_upColor;
        self.bgView01.backgroundColor = [UIColor colorWithHexString:@"#F62D4B"];
    }
    //CGFloat upDownPercent01 = upDown01 / [[array[0] objectForKey:@"pre_close"] doubleValue] * 100;
    self.increaseLabel01.text = [NSString stringWithFormat:@"%@%.2f",symbol01,[dict01[@"chg"] doubleValue]];
    if ([dict01[@"pct-chg"] doubleValue] == 0) {
        self.amplitudeLabel01.text = @"-";
    }else {
        self.amplitudeLabel01.text = [NSString stringWithFormat:@"%@%.2f%%",symbol01,[dict01[@"pct-chg"] doubleValue]];
    }
    
    NSDictionary *dict02 = dict[@"QQQ"];
    self.indexNameLabel02.text = dict02[@"name"];
    self.totalPriceLabel02.text = [NSString stringWithFormat:@"%.2f",[dict02[@"price"] doubleValue]];
    //CGFloat upDown02 = [[array[1] objectForKey:@"price"] doubleValue] - [[array[1] objectForKey:@"pre_close"] doubleValue];
    NSString *symbol02 = @"-";
    if([dict02[@"chg"] doubleValue] > 0) {
        symbol02 = @"+";
        self.totalPriceLabel02.textColor = ChartColors_dnColor;
        self.increaseLabel02.textColor = ChartColors_dnColor;
        self.amplitudeLabel02.textColor = ChartColors_dnColor;
        self.bgView02.backgroundColor = [UIColor colorWithHexString:@"#1EB45E"];
    } else {
        self.totalPriceLabel02.textColor = ChartColors_upColor;
        self.increaseLabel02.textColor = ChartColors_upColor;
        self.amplitudeLabel02.textColor = ChartColors_upColor;
        self.bgView02.backgroundColor = [UIColor colorWithHexString:@"#F62D4B"];
    }
    //CGFloat upDownPercent02 = upDown02 / [[array[1] objectForKey:@"pre_close"] doubleValue] * 100;
    self.increaseLabel02.text = [NSString stringWithFormat:@"%@%.2f",symbol02,[dict02[@"chg"] doubleValue]];
    if ([dict02[@"pct-chg"] doubleValue] == 0) {
        self.amplitudeLabel02.text = @"-";
    }else {
        self.amplitudeLabel02.text = [NSString stringWithFormat:@"%@%.2f%%",symbol02,[dict02[@"pct-chg"] doubleValue]];
    }

    NSDictionary *dict03 = dict[@"SPY"];
    self.indexNameLabel03.text = dict03[@"name"];
    self.totalPriceLabel03.text = [NSString stringWithFormat:@"%.2f",[dict03[@"price"] doubleValue]];
    //CGFloat upDown03 = [[array[2] objectForKey:@"price"] doubleValue] - [[array[2] objectForKey:@"pre_close"] doubleValue];
    NSString *symbol03 = @"-";
    if([dict03[@"chg"] doubleValue] > 0) {
        symbol03 = @"+";
        self.totalPriceLabel03.textColor = ChartColors_dnColor;
        self.increaseLabel03.textColor = ChartColors_dnColor;
        self.amplitudeLabel03.textColor = ChartColors_dnColor;
        self.bgView03.backgroundColor = [UIColor colorWithHexString:@"#1EB45E"];
    } else {
        self.totalPriceLabel03.textColor = ChartColors_upColor;
        self.increaseLabel03.textColor = ChartColors_upColor;
        self.amplitudeLabel03.textColor = ChartColors_upColor;
        self.bgView03.backgroundColor = [UIColor colorWithHexString:@"#F62D4B"];
    }
    //CGFloat upDownPercent03 = upDown03 / [[array[2] objectForKey:@"pre_close"] doubleValue] * 100;
    self.increaseLabel03.text = [NSString stringWithFormat:@"%@%.2f",symbol03,[dict03[@"chg"] doubleValue]];
    if ([dict03[@"pct-chg"] doubleValue] == 0) {
        self.amplitudeLabel03.text = @"-";
    }else {
        self.amplitudeLabel03.text = [NSString stringWithFormat:@"%@%.2f%%",symbol03,[dict03[@"pct-chg"] doubleValue]];
    }
    
    self.upTotalLabel.text = [NSString stringWithFormat:@"上涨 %d",[dict[@"rise"] intValue]];
    self.downTotalLabel.text = [NSString stringWithFormat:@"下跌 %d",[dict[@"fall"] intValue]];
    self.mdTimeLabel.text = [NSString stringWithFormat:@"%@ 美东",dict[@"time"]];
}

- (void)getAllStockCode {
    // 加载所有股票代码
    NSTimeInterval currentTime = [[NSDate date] timeIntervalSince1970];
    NSInteger lastLoadAllCode = [[NSUserDefaults standardUserDefaults] integerForKey:@"lastLoadAllCoode"];
    if (currentTime - lastLoadAllCode > 86400) {
        TMHttpParams *param = [[TMHttpParams alloc] init];
        [param setUrl:API_getStockCodes_URL];
        param.requestType = POST;
        [DataRequest requestWithParam:param successed:^(NSDictionary *dict, NSError *error, int result, NSString *msg) {
            
            if (result == 1) {
                
                NSArray<NSArray<NSString *> *> *list = dict[@"data"];
                NSString *str = [list mj_JSONString];
                
                NSURL *cacheDirectory = [[[NSFileManager defaultManager] URLsForDirectory:NSCachesDirectory inDomains:NSUserDomainMask] firstObject];
                NSURL *cacheURL = [cacheDirectory URLByAppendingPathComponent:@"allcode.json"];
                
                if ([str writeToURL:cacheURL atomically:YES encoding:NSUTF8StringEncoding error:&error]) {
                    [[NSUserDefaults standardUserDefaults] setInteger:currentTime forKey:@"lastLoadAllCoode"];
                    [[NSUserDefaults standardUserDefaults] synchronize];
                } else {
                    NSLog(@"write all code Error: %@", [error localizedDescription]);
                }
            }
        }];
    }
}

#pragma mark ---- JXPagerViewDelegate ----
- (UIView *)tableHeaderViewInPagerView:(JXPagerView *)pagerView {
    return [[UIView alloc] init];
}

- (NSUInteger)tableHeaderViewHeightInPagerView:(JXPagerView *)pagerView {
    return CGFLOAT_MIN;
}

- (UIView *)viewForPinSectionHeaderInPagerView:(JXPagerView *)pagerView {
    return [[UIView alloc] init];
}

- (NSUInteger)heightForPinSectionHeaderInPagerView:(JXPagerView *)pagerView {
    return CGFLOAT_MIN;
}

- (NSInteger)numberOfListsInPagerView:(JXPagerView *)pagerView {
    return self.titleArray.count;
}

- (id<JXPagerViewListViewDelegate>)pagerView:(JXPagerView *)pagerView initListAtIndex:(NSInteger)index {
    if (index == 1) {
        HomeAlarmListVC *vc = [HomeAlarmListVC new];
        return vc;
    } else {
        HomePondListVC *vc = [HomePondListVC new];
        return vc;
    }
}

#pragma mark ---- JXPagerMainTableViewGestureDelegate ----
- (BOOL)mainTableViewGestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    if (otherGestureRecognizer == self.categoryV.collectionView.panGestureRecognizer) {
        return NO;
    }
    
    return [gestureRecognizer isKindOfClass:[UIPanGestureRecognizer class]] && [otherGestureRecognizer isKindOfClass:[UIPanGestureRecognizer class]];
}

#pragma mark ---- UITextFieldDelegate ----
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    SearchStockVC *vc = [[SearchStockVC alloc] init];
    PushController(vc);
    return YES;
}

#pragma mark ---- HomeIndexViewDelegate ----
- (void)selectIndexViewWithModel:(HomeIndexModel *)model {
    KLineMainVC *vc = [[KLineMainVC alloc] init];
    vc.stockCode = model.stockCode;
    vc.mainTitle = model.stockCode;
    vc.subTitle = model.stockName;
    vc.dateSelectState = DateSelectStateDay;
    PushController(vc);
}

#pragma mark ---- 按钮点击 ----
- (IBAction)loginBtnClick:(id)sender {
    if ([self.loginBtn.titleLabel.text isEqualToString:@"退出"]) {
        [MsgAlertTool showAlert:@"" message:@"确认退出吗？" completion:^(BOOL cancelled, NSInteger buttonIndex) {
            if(!cancelled){
                [[UserInfo Instance] setUserName:@""];
                [[UserInfo Instance] setPassword:@""];
                [[UserInfo Instance] setAccess_token:@""];
                
                self.accountLabel.hidden = YES;
                [self.loginBtn setTitle:@"登录" forState:UIControlStateNormal];
                
                PXNotifiPost(LOGINSTATUSKEY, nil);
            }
        } cancelButtonTitle:@"取消" otherButtonTitles:@"确认"];
    }else {
        if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"markRead"] isEqualToString:@"yes"]) {
            LoginView *view = [[[NSBundle mainBundle] loadNibNamed:@"LoginView" owner:self options:nil] objectAtIndex:0];
            view.delegate = self;
            [self.view.window showViewInCenter:view WithSize:CGSizeMake(screenW - 64, 380) canClose:NO];
            return;
        }
        
        RiskWarningView *view = [[[NSBundle mainBundle] loadNibNamed:@"RiskWarningView" owner:self options:nil] objectAtIndex:0];
        view.delegate = self;
        [self.view.window showViewInCenter:view WithSize:CGSizeMake(screenW - 64, 520)];
    }
}

- (IBAction)indexBtn01Click:(id)sender {
    KLineMainVC *vc = [[KLineMainVC alloc] init];
    vc.stockCode = _indexDataDict[@"DIA"][@"code"];
    vc.mainTitle = _indexDataDict[@"DIA"][@"name"];
    vc.subTitle = _indexDataDict[@"DIA"][@"code"];
    vc.dateSelectState = DateSelectStateDay;
    PushController(vc);
}

- (IBAction)indexBtn02Click:(id)sender {
    KLineMainVC *vc = [[KLineMainVC alloc] init];
    vc.stockCode = _indexDataDict[@"QQQ"][@"code"];
    vc.mainTitle = _indexDataDict[@"QQQ"][@"name"];
    vc.subTitle = _indexDataDict[@"QQQ"][@"code"];
    vc.dateSelectState = DateSelectStateDay;
    PushController(vc);
}

- (IBAction)indexBtn03Click:(id)sender {
    KLineMainVC *vc = [[KLineMainVC alloc] init];
    vc.stockCode = _indexDataDict[@"SPY"][@"code"];
    vc.mainTitle = _indexDataDict[@"SPY"][@"name"];
    vc.subTitle = _indexDataDict[@"SPY"][@"code"];
    vc.dateSelectState = DateSelectStateDay;
    PushController(vc);
}

#pragma mark ---- RiskWarningViewDelegate ----
- (void)hiddenView{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        LoginView *view = [[[NSBundle mainBundle] loadNibNamed:@"LoginView" owner:self options:nil] objectAtIndex:0];
        view.delegate = self;
        [self.view.window showViewInCenter:view WithSize:CGSizeMake(screenW - 64, 380) canClose:NO];
    });
}

#pragma mark ---- LoginViewDelegate ----
- (void)loginSucceed {
    self.accountLabel.hidden = NO;
    self.accountLabel.text = [[UserInfo Instance] getUserName];
    [self.loginBtn setTitle:@"退出" forState:UIControlStateNormal];
}

#pragma mark ---- 懒加载 ----
- (NSMutableArray *)indexViewArray {
    if (!_indexViewArray) {
        _indexViewArray = [NSMutableArray array];
    }
    return _indexViewArray;
}
@end
