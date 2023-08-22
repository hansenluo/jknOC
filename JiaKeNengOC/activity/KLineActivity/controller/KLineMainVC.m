//
//
//  KLineMainVC.m
//  JiaKeNengOC
//
//  Created by jkn-mac on 2023/6/27.
//

#import "KLineMainVC.h"
#import "AppDelegate.h"
#import "ChartStyle.h"
#import "InfoMenuView.h"
#import "MLPagerView.h"
#import "MLPagerListRefreshView.h"
#import "KLineTabHeadView.h"
#import "JournalismListVC.h"
#import "ExponentView.h"
#import "LandExponenView.h"
#import "RealTimeBuySaleView.h"
#import "KLinePeriodView.h"
#import "KLineChartView.h"
#import "KLineAISettingView.h"
#import "KLineBottomView.h"
#import "DataUtil.h"
#import "KLineStateManager.h"
#import "RectPivotModel.h"
#import "ExtendPivotModel.h"
#import "BuySalePointModel.h"

@interface KLineMainVC () <MLPagerViewDelegate,JXPagerMainTableViewGestureDelegate,InfoMenuViewDelegate,KLineTabHeadViewDelegate,KLinePeriodViewDelegate,KLineChartViewDelegate,LandExponenViewDelegate,KLineBottomViewDelegate,KLineAISettingViewDelegate> {
    NSDictionary *_lastStockBaseDict;
}

@property (nonatomic, strong) InfoMenuView *menView;
@property (nonatomic, strong) MLPagerView *pagingView;
@property (nonatomic, strong) KLineTabHeadView *kLineTabHeadView;
@property (nonatomic, strong) ExponentView *exponentView;
@property (nonatomic, strong) LandExponenView *landExponenView;
@property (nonatomic, strong) RealTimeBuySaleView *realTimeBuySaleView;
@property (nonatomic, strong) KLinePeriodView *kLinePeriodView;
@property (nonatomic, strong) KLineChartView *klineCharView;
@property (nonatomic, strong) KLineAISettingView *kLineAISettingView;
@property (nonatomic, strong) KLineBottomView *kLineBottomView;
@property (nonatomic, strong) UIView *tableViewHeadView;
@property (nonatomic, strong) UIView *loadingView;
@property (nonatomic, assign) int minRectSpansNum;  //小的中枢矩包含多少段蜡烛，即每一个小矩形的长度
@property (nonatomic, assign) int maxRectSpansNum;  //大的中枢矩包含多少段蜡烛，即每一个大矩形的长度
@property (nonatomic, assign) BOOL isSelectLine;  //当前选择的是分时图
@property (nonatomic, strong) KLineModel *minRectLastKlineModel;
@property (nonatomic, strong) KLineModel *maxRectLastKlineModel;

@property (nonatomic, strong) NSMutableArray *historyArray;
@property (nonatomic, strong) NSMutableArray *stockTimeArray;
@property (nonatomic, strong) NSString *md5String;
@property (nonatomic, assign) NSInteger currentSelectType; //当前选择个股数据类型
//@property (nonatomic, assign) NSInteger lastSelectType; //上一次选择个股数据类型，防止请求失败后6秒刷新数据错误
//@property (nonatomic, strong) NSString *lastSelectMintue;

@property (nonatomic, strong) NSTimer *pollTimer;

@end

@implementation KLineMainVC

- (void)dealloc {
    NSLog(@"dealloc");
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
//    [self.pollTimer invalidate];
//    self.pollTimer = nil;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    NSLog(@"viewWillDisappear");
    [DataRequest cancelRequest];
//    [self.pollTimer setFireDate:[NSDate distantFuture]];
    
    [self.pollTimer invalidate];
    self.pollTimer = nil;
}
 
//- (void)viewWillAppear:(BOOL)animated {
//    [super viewWillAppear:animated];
//
//    [self.pollTimer setFireDate:[NSDate date]];
//}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationBarHidden = YES;
    self.view.backgroundColor = PrimaryColor;
    
    self.md5String = @"";
    self.currentSelectType = self.dateSelectState;
    //self.lastSelectType = self.dateSelectState;
    //self.lastSelectMintue = self.currentSelectMintue;
    [self initView];
    NSLog(@"股票代码 = %@",self.stockCode);
    
    [self queueRequestData];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(orderListScrollToTop:) name:@"OrderListScrollTopNotification" object:nil];
}

- (void)autoUpdateData {
    //NSLog(@"开始刷新");
    //获取个股基本数据
    
    TMHttpParams *param = [[TMHttpParams alloc] init];
    [param setUrl:API_getStockBaseData_URL];
    [param addParams:self.stockCode forKey:@"code"];
    param.requestType = POST;
    [DataRequest requestWithParam:param successed:^(NSDictionary *dict, NSError *error, int result, NSString *msg) {
        
        if (result == 1) {
            self->_lastStockBaseDict = dict;
            if (!self.klineCharView.singleTagPress && !self.klineCharView.isLongPress) {
                [self.exponentView setDataWithArray:dict[@"basic"]];
                [self.landExponenView setDataWithArray:dict[@"basic"] title:self.mainTitle subTitle:self.subTitle];
                [self.realTimeBuySaleView setDataWithArray:dict[@"sale"]];
            }
        }
    }];
    
    TMHttpParams *param_1 = [[TMHttpParams alloc] init];
    [param_1 setUrl:API_getStockStatus_URL];
    [param_1 addParams:self.stockCode forKey:@"code"];
    param_1.requestType = POST;
    
    [DataRequest requestWithParam:param_1 successed:^(NSDictionary *dict, NSError *error, int result, NSString *msg) {
        
        if (result == 1) {
            if ([dict[@"alarm"] intValue] == 1) {
                [self.kLineBottomView.addAIBtn setImage:[UIImage imageNamed:@"icon_delete"] forState:UIControlStateNormal];
            }else {
                [self.kLineBottomView.addAIBtn setImage:[UIImage imageNamed:@"icon_add"] forState:UIControlStateNormal];
            }
            self.kLineBottomView.addAIBtn.tag = [dict[@"alarm"] intValue];
          
            if ([dict[@"pool"] intValue] == 1) {
                [self.kLineBottomView.addPondBtn setImage:[UIImage imageNamed:@"icon_delete"] forState:UIControlStateNormal];
            }else {
                [self.kLineBottomView.addPondBtn setImage:[UIImage imageNamed:@"icon_add"] forState:UIControlStateNormal];
            }
            self.kLineBottomView.addPondBtn.tag = [dict[@"pool"] intValue];
        }
    }];
    
    if (self.currentSelectType == DateSelectStateDay) {
        [self requestStockDayData:YES];
    }else if (self.currentSelectType == DateSelectStateWeek) {
        [self requestStockWeekData:YES];
    }else if (self.currentSelectType == DateSelectStateMonth) {
        [self requestStockMonthData:YES];
    }else if (self.currentSelectType == DateSelectStateQuarter) {
        [self requestStockQuarterData:YES];
    }else if (self.currentSelectType == DateSelectStateMinute) {
        [self requestStockMinuteData:self.currentSelectMintue repeats:YES];
    }else if (self.currentSelectType == DateSelectStateTimeShare) {
        [self requestStockTimeData:YES];
    }
}

#pragma mark ---- 内部方法 ----
- (void)initView{
    self.kLineTabHeadView = [[KLineTabHeadView alloc] init];
    self.kLineTabHeadView.frame = CGRectMake(0, 0, screenW, Height_NavBar);
    self.kLineTabHeadView.delegate = self;
    self.kLineTabHeadView.hidden = NO;
    self.kLineTabHeadView.mainTitleLabel.text = isNilString(self.mainTitle) ? self.subTitle : self.mainTitle;
    self.kLineTabHeadView.subTitleLabel.text = self.subTitle;
    [self.view addSubview:self.kLineTabHeadView];
    
    self.tableViewHeadView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, screenW, screenH - Height_NavBar)];
    self.tableViewHeadView.backgroundColor = ClearColor;
    
    //股票基本数据视图
    self.exponentView = [[NSBundle mainBundle] loadNibNamed:@"ExponentView" owner:self options:nil].lastObject;
    self.exponentView.frame = CGRectMake(0, 0, screenW, 140);
    [self.tableViewHeadView addSubview:self.exponentView];
    
    //周期选择视图
    self.kLinePeriodView = [[NSBundle mainBundle] loadNibNamed:@"KLinePeriodView" owner:self options:nil].lastObject;
    self.kLinePeriodView.frame = CGRectMake(0, self.exponentView.BottomY + 8, screenW, 44);
    self.kLinePeriodView.delegate = self;
    [self.tableViewHeadView addSubview:self.kLinePeriodView];
    
    //实时买卖视图
    self.realTimeBuySaleView = [[NSBundle mainBundle] loadNibNamed:@"RealTimeBuySaleView" owner:self options:nil].lastObject;
    self.realTimeBuySaleView.frame = CGRectMake(screenW - ChartStyle_buySaleViewWidth, 192, ChartStyle_buySaleViewWidth, self.tableViewHeadView.height - 192 - 60);
    [self.tableViewHeadView addSubview:self.realTimeBuySaleView];
    
    //ai系统设置视图
    self.kLineAISettingView = [[KLineAISettingView alloc] initWithFrame:CGRectMake(0, self.kLinePeriodView.BottomY, screenW, 40)];
    self.kLineAISettingView.delegate = self;
    [self.tableViewHeadView addSubview:self.kLineAISettingView];
    
    //k线图
    self.klineCharView = [[KLineChartView alloc] initWithFrame:CGRectMake(0, 192, screenW, self.tableViewHeadView.height - 192 - 60)];
    self.klineCharView.delegate = self;
    [KLineStateManager manager].klineChart = self.klineCharView;
    [self.tableViewHeadView addSubview:self.klineCharView];
    
    self.loadingView = [[UIView alloc] initWithFrame:CGRectMake(0, 192, screenW, self.tableViewHeadView.height - 192 - 60)];
    self.loadingView.backgroundColor = MinorColor;
    [self.tableViewHeadView addSubview:self.loadingView];
    //[self getStockDayData];
    
    //底部按钮视图
    self.kLineBottomView = [[NSBundle mainBundle] loadNibNamed:@"KLineBottomView" owner:self options:nil].lastObject;
    self.kLineBottomView.frame = CGRectMake(0, self.tableViewHeadView.height - 60, screenW, 60);
    self.kLineBottomView.delegate = self;
    [self.tableViewHeadView addSubview:self.kLineBottomView];
    
    //新闻标题视图
    self.menView = [[InfoMenuView alloc] init];
    self.menView.frame = CGRectMake(0, 0, screenW, 36);
    self.menView.delegate = self;
    
    self.pagingView = [self preferredPagingView];
    self.pagingView.frame = CGRectMake(0, Height_NavBar, screenW, screenH - Height_NavBar);
    self.pagingView.backgroundColor = [UIColor clearColor];
    self.pagingView.mainTableView.backgroundColor = [UIColor clearColor];
    self.pagingView.mainTableView.contentInset = UIEdgeInsetsMake(0, 0, Height_TabBar, 0);
    self.pagingView.mainTableView.gestureDelegate = self;
    self.pagingView.mainTableView.scrollEnabled = NO;
    [self.view addSubview:self.pagingView];
    
    //横屏状态下的一些视图
    self.landExponenView = [[NSBundle mainBundle] loadNibNamed:@"LandExponenView" owner:self options:nil].lastObject;
    self.landExponenView.hidden = YES;
    self.landExponenView.delegate = self;
    [self.view addSubview:self.landExponenView];
    //[self verticalLayout];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(chageRotate:) name:UIApplicationDidChangeStatusBarFrameNotification object:nil];
    
    if (self.dateSelectState == DateSelectStateDay) {
        self.kLinePeriodView.lineViewConstraintX.constant = ((self.kLinePeriodView.frame.size.width - 135)/5 - 30)/2 + (self.kLinePeriodView.frame.size.width - 135)/5 * 1;
    }else if (self.dateSelectState == DateSelectStateWeek || self.dateSelectState == DateSelectStateMonth || self.dateSelectState == DateSelectStateQuarter) {
        self.kLinePeriodView.lineView01.hidden = YES;
        self.kLinePeriodView.lineView02.hidden = NO;
        if (self.dateSelectState == DateSelectStateWeek) {
            [self.kLinePeriodView.dateBtn setTitle:@"周线" forState:UIControlStateNormal];
        }else if (self.dateSelectState == DateSelectStateMonth) {
            [self.kLinePeriodView.dateBtn setTitle:@"月线" forState:UIControlStateNormal];
        }else if (self.dateSelectState == DateSelectStateQuarter) {
            [self.kLinePeriodView.dateBtn setTitle:@"季线" forState:UIControlStateNormal];
        }
        [self.kLinePeriodView.dateBtn setTitleColor:WhiteColor forState:UIControlStateNormal];
        self.kLinePeriodView.timeBtn01.selected = NO;
        self.kLinePeriodView.timeBtn02.selected = NO;
        self.kLinePeriodView.timeBtn03.selected = NO;
        self.kLinePeriodView.timeBtn04.selected = NO;
        self.kLinePeriodView.timeBtn05.selected = NO;
    }else if (self.dateSelectState == DateSelectStateMinute) {
        if ([self.currentSelectMintue isEqualToString:@"30"]) {
            self.kLinePeriodView.timeBtn02.selected = NO;
            self.kLinePeriodView.timeBtn03.selected = YES;
            self.kLinePeriodView.lineViewConstraintX.constant = ((self.kLinePeriodView.frame.size.width - 135)/5 - 30)/2 + (self.kLinePeriodView.frame.size.width - 135)/5 * 2;
        }else if ([self.currentSelectMintue isEqualToString:@"15"]) {
            self.kLinePeriodView.timeBtn02.selected = NO;
            self.kLinePeriodView.timeBtn04.selected = YES;
            self.kLinePeriodView.lineViewConstraintX.constant = ((self.kLinePeriodView.frame.size.width - 135)/5 - 30)/2 + (self.kLinePeriodView.frame.size.width - 135)/5 * 3;
        }else if ([self.currentSelectMintue isEqualToString:@"5"]) {
            self.kLinePeriodView.timeBtn02.selected = NO;
            self.kLinePeriodView.timeBtn05.selected = YES;
            self.kLinePeriodView.lineViewConstraintX.constant = ((self.kLinePeriodView.frame.size.width - 135)/5 - 30)/2 + (self.kLinePeriodView.frame.size.width - 135)/5 * 4;
        }else {
            self.kLinePeriodView.lineView01.hidden = YES;
            self.kLinePeriodView.lineView02.hidden = NO;
            if ([self.currentSelectMintue isEqualToString:@"1"]) {
                [self.kLinePeriodView.dateBtn setTitle:@"1m" forState:UIControlStateNormal];
            }else if ([self.currentSelectMintue isEqualToString:@"3"]) {
                [self.kLinePeriodView.dateBtn setTitle:@"3m" forState:UIControlStateNormal];
            }else if ([self.currentSelectMintue isEqualToString:@"10"]) {
                [self.kLinePeriodView.dateBtn setTitle:@"10m" forState:UIControlStateNormal];
            }else if ([self.currentSelectMintue isEqualToString:@"15"]) {
                [self.kLinePeriodView.dateBtn setTitle:@"15m" forState:UIControlStateNormal];
            }else if ([self.currentSelectMintue isEqualToString:@"60"]) {
                [self.kLinePeriodView.dateBtn setTitle:@"1h" forState:UIControlStateNormal];
            }else if ([self.currentSelectMintue isEqualToString:@"240"]) {
                [self.kLinePeriodView.dateBtn setTitle:@"4h" forState:UIControlStateNormal];
            }
            [self.kLinePeriodView.dateBtn setTitleColor:WhiteColor forState:UIControlStateNormal];
            self.kLinePeriodView.timeBtn01.selected = NO;
            self.kLinePeriodView.timeBtn02.selected = NO;
            self.kLinePeriodView.timeBtn03.selected = NO;
            self.kLinePeriodView.timeBtn04.selected = NO;
            self.kLinePeriodView.timeBtn05.selected = NO;
        }
    }
}

- (void)setHistoryData:(NSDictionary *)dicts historyDataArray:(NSArray *)historyDataArray lastDataArray:(NSArray *)lastDataArray repeats:(BOOL)repeats type:(NSString *)type mintue:(NSString *)mintue{
    //NSLog(@"---- 当前选择type = %@",type);
    if ([type isEqualToString:@"day"] && self.currentSelectType != DateSelectStateDay) { return; }
    if ([type isEqualToString:@"week"] && self.currentSelectType != DateSelectStateWeek) { return; }
    if ([type isEqualToString:@"month"] && self.currentSelectType != DateSelectStateMonth) { return; }
    if ([type isEqualToString:@"quarter"] && self.currentSelectType != DateSelectStateQuarter) { return; }
    if ([type isEqualToString:@"minute"]) {
        if (self.currentSelectType != DateSelectStateMinute) {
            return;
        }else {
            if (![self.currentSelectMintue isEqualToString:mintue]) {
                return;
            }
        }
    }
    
    [self.view progressDiss];
    
    __block BOOL iso = NO;
    __block BOOL iss = NO;
    
    //买一卖一数据
    NSArray *tempArray01 = dicts[@"centresData"][@"sale1_points"];
    NSMutableArray *sale1PointArray = [NSMutableArray array];
    [tempArray01 enumerateObjectsWithOptions:NSEnumerationReverse usingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        BuySalePointModel *buySalePointModel = [[BuySalePointModel alloc] init];
        
//        NSString *dateStr = obj[0];
//        NSArray *arr = [dateStr componentsSeparatedByString:@" "];
//        if (arr.count > 1) {
//            buySalePointModel.date = arr[1];
//        }else {
//            buySalePointModel.date = obj[0];
//        }
        
        buySalePointModel.date = obj[0];
        buySalePointModel.high = [obj[1] doubleValue];
        buySalePointModel.num = [obj[2] integerValue];
        buySalePointModel.direction = [obj[3] integerValue];
        [sale1PointArray addObject:buySalePointModel];
    }];
    
    //买三卖三数据
    NSArray *tempArray02 = dicts[@"centresData"][@"sale3_points"];
    NSMutableArray *sale3PointArray = [NSMutableArray array];
    [tempArray02 enumerateObjectsWithOptions:NSEnumerationReverse usingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        BuySalePointModel *buySalePointModel = [[BuySalePointModel alloc] init];
        
//        NSString *dateStr = obj[0];
//        NSArray *arr = [dateStr componentsSeparatedByString:@" "];
//        if (arr.count > 1) {
//            buySalePointModel.date = arr[1];
//        }else {
//            buySalePointModel.date = obj[0];
//        }
        
        buySalePointModel.date = obj[0];
        buySalePointModel.high = [obj[1] doubleValue];
        buySalePointModel.num = [obj[2] integerValue];
        buySalePointModel.direction = [obj[3] integerValue];
        [sale3PointArray addObject:buySalePointModel];
    }];
    
    //小的中枢矩形框数据
    NSArray *tempArray03 = dicts[@"centresData"][@"marks"];
    NSMutableArray *minRectArray = [NSMutableArray array];
    [tempArray03 enumerateObjectsWithOptions:NSEnumerationReverse usingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        RectPivotModel *rectPivotModel = [[RectPivotModel alloc] init];
        
//        NSString *dateStr01 = obj[0];
//        NSArray *arr01 = [dateStr01 componentsSeparatedByString:@" "];
//        if (arr01.count > 1) {
//            rectPivotModel.startDate = arr01[1];
//        }else {
//            rectPivotModel.startDate = obj[0];
//        }
//
//        NSString *dateStr02 = obj[1];
//        NSArray *arr02 = [dateStr02 componentsSeparatedByString:@" "];
//        if (arr02.count > 1) {
//            rectPivotModel.endDate = arr02[1];
//        }else {
//            rectPivotModel.endDate = obj[1];
//        }
        
        rectPivotModel.startDate = obj[0];
        rectPivotModel.endDate = obj[1];
        rectPivotModel.low = [obj[2] doubleValue];
        rectPivotModel.high = [obj[3] doubleValue];
        rectPivotModel.num = [obj[4] integerValue];
        rectPivotModel.direction = [obj[5] integerValue];
        rectPivotModel.marknum = [obj[6] intValue];
        [minRectArray addObject:rectPivotModel];
    }];
    
    //大的中枢矩形框
    NSArray *tempArray04 = dicts[@"centresData"][@"extands"];
    NSMutableArray *maxRectArray = [NSMutableArray array];
    [tempArray04 enumerateObjectsWithOptions:NSEnumerationReverse usingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        
        ExtendPivotModel *extendPivotModel = [[ExtendPivotModel alloc] init];
        
//        NSString *dateStr01 = obj[0];
//        NSArray *arr01 = [dateStr01 componentsSeparatedByString:@" "];
//        if (arr01.count > 1) {
//            extendPivotModel.startDate = arr01[1];
//        }else {
//            extendPivotModel.startDate = obj[0];
//        }
//
//        NSString *dateStr02 = obj[1];
//        NSArray *arr02 = [dateStr02 componentsSeparatedByString:@" "];
//        if (arr02.count > 1) {
//            extendPivotModel.endDate = arr02[1];
//        }else {
//            extendPivotModel.endDate = obj[1];
//        }
        
        extendPivotModel.startDate = obj[0];
        extendPivotModel.endDate = obj[1];
        extendPivotModel.low = [obj[2] doubleValue];
        extendPivotModel.high = [obj[3] doubleValue];
        extendPivotModel.direction = [obj[4] integerValue];
        extendPivotModel.num = [obj[5] integerValue];
        [maxRectArray addObject:extendPivotModel];
    }];
    
    //个股蜡烛数据
    NSMutableArray *tempArray05 = [NSMutableArray array];
    //NSArray *tempArray06 = dicts[@"history_data"];
    [historyDataArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [tempArray05 addObject:[obj mutableCopy]];
    }];
    
    if ([type isEqualToString:@"day"]) {
        if (lastDataArray.count > 0) {
            [tempArray05 addObject:lastDataArray];
        }
    }else if ([type isEqualToString:@"minute"]) {
        if (lastDataArray.count > 0) {
            if ([lastDataArray[0] isKindOfClass:[NSArray class]]) {
                [lastDataArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    [tempArray05 addObject:obj];
                }];
            }else {
                [tempArray05 addObject:lastDataArray];
            }
        }
    }else if ([type isEqualToString:@"week"]) {
        if (lastDataArray.count > 0) {
            if ([self isSameWeekWithDate1:lastDataArray[0] date2:tempArray05.lastObject[0]]) {
                tempArray05.lastObject[0] = lastDataArray[0];
                tempArray05.lastObject[1] = lastDataArray[1];
                
                if ([tempArray05.lastObject[2] doubleValue] < [lastDataArray[2] doubleValue]) {
                    tempArray05.lastObject[2] = lastDataArray[2];
                }
                
                if ([tempArray05.lastObject[3] doubleValue] >= [lastDataArray[3] doubleValue]) {
                    tempArray05.lastObject[3] = lastDataArray[3];
                }
                
                tempArray05.lastObject[6] = [NSString stringWithFormat:@"%.2f",([tempArray05.lastObject[6] doubleValue] + [lastDataArray[6] doubleValue])];
                tempArray05.lastObject[7] = [NSString stringWithFormat:@"%.2f",([tempArray05.lastObject[7] doubleValue] + [lastDataArray[7] doubleValue])];
            }else {
                [tempArray05 addObject:lastDataArray];
            }
        }
    }else if ([type isEqualToString:@"month"]) {
        if (lastDataArray.count > 0) {
            if ([self isSameMonthWithDate1:lastDataArray[0] date2:tempArray05.lastObject[0]]) {
                tempArray05.lastObject[0] = lastDataArray[0];
                tempArray05.lastObject[1] = lastDataArray[1];
                
                if ([tempArray05.lastObject[2] doubleValue] < [lastDataArray[2] doubleValue]) {
                    tempArray05.lastObject[2] = lastDataArray[2];
                }
                
                if ([tempArray05.lastObject[3] doubleValue] >= [lastDataArray[3] doubleValue]) {
                    tempArray05.lastObject[3] = lastDataArray[3];
                }
                
                tempArray05.lastObject[6] = [NSString stringWithFormat:@"%.2f",([tempArray05.lastObject[6] doubleValue] + [lastDataArray[6] doubleValue])];
                tempArray05.lastObject[7] = [NSString stringWithFormat:@"%.2f",([tempArray05.lastObject[7] doubleValue] + [lastDataArray[7] doubleValue])];
            }else {
                [tempArray05 addObject:lastDataArray];
            }
        }
    }else if ([type isEqualToString:@"quarter"]) {
        if (lastDataArray.count > 0) {
            if ([self isSameQuarterWithDate1:lastDataArray[0] date2:tempArray05.lastObject[0]]) {
                tempArray05.lastObject[0] = lastDataArray[0];
                tempArray05.lastObject[1] = lastDataArray[1];
                
                if ([tempArray05.lastObject[2] doubleValue] < [lastDataArray[2] doubleValue]) {
                    tempArray05.lastObject[2] = lastDataArray[2];
                }
                
                if ([tempArray05.lastObject[3] doubleValue] >= [lastDataArray[3] doubleValue]) {
                    tempArray05.lastObject[3] = lastDataArray[3];
                }
                
                tempArray05.lastObject[6] = [NSString stringWithFormat:@"%.2f",([tempArray05.lastObject[6] doubleValue] + [lastDataArray[6] doubleValue])];
                tempArray05.lastObject[7] = [NSString stringWithFormat:@"%.2f",([tempArray05.lastObject[7] doubleValue] + [lastDataArray[7] doubleValue])];
            }else {
                [tempArray05 addObject:lastDataArray];
            }
        }
    }
    
    [tempArray05 enumerateObjectsWithOptions:NSEnumerationReverse usingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        KLineModel *klineModel = [[KLineModel alloc] init];
        
//        NSString *dateStr = obj[0];
//        NSArray *arr = [dateStr componentsSeparatedByString:@" "];
//        if (arr.count > 1) {
//            klineModel.date = arr[1];
//        }else {
//            klineModel.date = obj[0];
//        }
        
        klineModel.date = obj[0];
        klineModel.close = [obj[1] doubleValue];
        klineModel.high = [obj[2] doubleValue];
        klineModel.low = [obj[3] doubleValue];
        klineModel.open = [obj[4] doubleValue];
        klineModel.lasetDayclose = [obj[5] doubleValue];
        klineModel.vol = [obj[6] doubleValue];
        klineModel.amount = [obj[7] doubleValue];
        
        for (int i = 0; i < sale1PointArray.count; i++) {
            BuySalePointModel *buySalePointModel = sale1PointArray[i];
            
            if ([klineModel.date isEqualToString:buySalePointModel.date]) {
                klineModel.isNeedDrawSale1Point = YES;
                klineModel.sale1PointHigh = buySalePointModel.high;
                klineModel.sale1PointNum = buySalePointModel.num;
                klineModel.sale1PointDirection = buySalePointModel.direction;
                [sale1PointArray removeObjectAtIndex:0];
                break;
            }
        }
        
        for (int i = 0; i < sale3PointArray.count; i++) {
            BuySalePointModel *buySalePointModel = sale3PointArray[i];
            
            if ([klineModel.date isEqualToString:buySalePointModel.date]) {
                klineModel.isNeedDrawSale3Point = YES;
                klineModel.sale3PointHigh = buySalePointModel.high;
                klineModel.sale3PointNum = buySalePointModel.num;
                klineModel.sale3PointDirection = buySalePointModel.direction;
                [sale3PointArray removeObjectAtIndex:0];
                break;
            }
        }
        
        for (int i = 0; i < minRectArray.count; i++) {
            RectPivotModel *rectPivotModel = minRectArray[i];
            
            if ([klineModel.date isEqualToString:rectPivotModel.startDate]) {
                iso = NO;
                klineModel.isPivotStartPoint = YES;
                klineModel.isNeedDrawRect = YES;
                klineModel.rectLow = rectPivotModel.low;
                klineModel.rectHigh = rectPivotModel.high;
                klineModel.num = rectPivotModel.num;
                klineModel.direction = rectPivotModel.direction;
                klineModel.minRectSpansNum = self.minRectSpansNum;
                self.minRectLastKlineModel.minRectSpansNum = self.minRectSpansNum;
                klineModel.minRectTag = minRectArray.count;
                
                klineModel.isNeedDrawMark = YES;
                klineModel.marknum = rectPivotModel.marknum;
                [minRectArray removeObjectAtIndex:0];
            }
            
            if ([klineModel.date isEqualToString:rectPivotModel.endDate]) {
                iso = YES;
                klineModel.isPivotEndPoint = YES;
                self.minRectLastKlineModel = klineModel;
                self.minRectSpansNum = 0;
            }
            
            if (iso) {
                klineModel.isNeedDrawRect = YES;
                klineModel.rectLow = rectPivotModel.low;
                klineModel.rectHigh = rectPivotModel.high;
                klineModel.num = rectPivotModel.num;
                klineModel.direction = rectPivotModel.direction;
                klineModel.minRectTag = minRectArray.count;
                self.minRectSpansNum++;
                break;
            }
        }
        
        for (int i = 0; i < maxRectArray.count; i++) {
            ExtendPivotModel *extendPivotModel = maxRectArray[i];
            
            if ([klineModel.date isEqualToString:extendPivotModel.startDate]) {
                iss = NO;
                klineModel.isExtendStartPoint = YES;
                klineModel.isNeedDrawExtendRect = YES;
                klineModel.extendRectLow = extendPivotModel.low;
                klineModel.extendRectHigh = extendPivotModel.high;
                klineModel.extendRectNum = extendPivotModel.num;
                klineModel.extendRectDirection = extendPivotModel.direction;
                klineModel.maxRectSpansNum = self.maxRectSpansNum;
                self.maxRectLastKlineModel.maxRectSpansNum = self.maxRectSpansNum;
                klineModel.maxRectTag = maxRectArray.count;
                
                klineModel.isNeedDrawExtendMark = YES;
                [maxRectArray removeObjectAtIndex:0];
            }
            
            if ([klineModel.date isEqualToString:extendPivotModel.endDate]) {
                iss = YES;
                klineModel.isExtendEndPoint = YES;
                self.maxRectLastKlineModel = klineModel;
                klineModel.isNeedDrawExtendMark = YES;
                self.maxRectSpansNum = 0;
            }
            
            if (iss) {
                klineModel.isNeedDrawExtendRect = YES;
                klineModel.extendRectLow = extendPivotModel.low;
                klineModel.extendRectHigh = extendPivotModel.high;
                klineModel.extendRectNum = extendPivotModel.num;
                klineModel.extendRectDirection = extendPivotModel.direction;
                klineModel.maxRectTag = maxRectArray.count;
                self.maxRectSpansNum++;
                break;
            }
        }
        
        [self.historyArray addObject:klineModel];
    }];
    
    //海底捞月数据
    NSArray *hdlyDataArray = dicts[@"hdlyData"];
    [hdlyDataArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        KLineModel *klineModel = self.historyArray[hdlyDataArray.count - idx - 1];
        klineModel.hdlyHigh = [obj doubleValue];
    }];
    
    NSArray *horizonArray = dicts[@"horizon"];
    [horizonArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        KLineModel *klineModel = self.historyArray[horizonArray.count - idx - 1];
        klineModel.horizon = [obj doubleValue];
    }];
    
    NSArray *monthLineArray = dicts[@"monthLine"];
    [monthLineArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        KLineModel *klineModel = self.historyArray[monthLineArray.count - idx - 1];
        klineModel.monthLine = [obj doubleValue];
    }];
    
    //笔画数据
    NSArray *pointsArray = dicts[@"pen_data"][@"points"];
    if (pointsArray.count > 0) {
        NSMutableArray *tempArray07 = [NSMutableArray array];
        [tempArray07 addObjectsFromArray:pointsArray];
        
        BOOL isLastPen = YES;
        NSInteger addUp = 0;
        NSArray *tempArray08 = tempArray07[tempArray07.count - 1];
        if (tempArray08.count > 0) {
            addUp = self.historyArray.count - [tempArray08[0] integerValue] - 1;
        }
        for (NSUInteger i = 0; i < tempArray07.count; i++) {
            if (i == (tempArray07.count - 1)) {
                break;
            }
            
            NSArray *array01 = tempArray07[tempArray07.count - i - 1];
            NSArray *array02 = tempArray07[tempArray07.count - i - 2];
            
            NSInteger aIndex = self.historyArray.count - [array01[0] integerValue] - 1;
            NSInteger bIndex = self.historyArray.count - [array02[0] integerValue] - 1;
            
            KLineModel *aKLineModel;
            KLineModel *bKLineModel;
            if ([array01[1] integerValue] == 0) {
                aKLineModel = self.historyArray[aIndex];
                bKLineModel = self.historyArray[bIndex];
            }else {
                bKLineModel = self.historyArray[aIndex];
                aKLineModel = self.historyArray[bIndex];
            }
            
            CGFloat k = (bKLineModel.high - aKLineModel.low) / (bIndex - aIndex);
            
            NSInteger ragn = bIndex - aIndex;
            for (NSInteger j = 0; j < ragn; j++) {
                KLineModel *cKLineModel = self.historyArray[addUp + j];
                cKLineModel.isDrawPen = YES;
                if ([array01[1] integerValue] == 0) {
                    cKLineModel.penHigh = aKLineModel.low + k * (addUp + j - aIndex);
                }else {
                    cKLineModel.penHigh = bKLineModel.high - k * (addUp + j - aIndex);
                }
                
                if (isLastPen) {
                    //这些都是最后一段线的数据
                    cKLineModel.isDrawLineDash = YES;
                    cKLineModel.penStatus = [dicts[@"pen_data"][@"status"] intValue];
                }
            }
            
            isLastPen = NO;
            addUp = addUp + ragn;
            KLineModel *cKLineModel = self.historyArray[addUp];
            if ([array01[1] integerValue] == 1) {
                cKLineModel.penHigh = aKLineModel.low;
            }else {
                cKLineModel.penHigh = bKLineModel.high;
            }
        }
    }
    
    //买卖点位数据
    if (self.historyArray.count > 0) {
        __block CGFloat WY1001 = 0.0;
        KLineModel *model = self.historyArray[self.historyArray.count - 1];
        WY1001 = ((2 * model.close + model.low + model.high)) / 4;
        
        __block CGFloat WY1002 = WY1001;
        __block CGFloat WY1003 = WY1002;
        __block CGFloat WY1004 = WY1003;
        __block CGFloat x0 = 0.0;
        
        int n = 4;
        [self.historyArray enumerateObjectsWithOptions:NSEnumerationReverse usingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            KLineModel *klineMode = obj;
            WY1001 = ((2 * klineMode.close + klineMode.low + klineMode.high)) / 4;
            WY1002 = (2 * WY1001 + (n - 1) * WY1002) / (n + 1);
            WY1003 = (2 * WY1002 + (n - 1) * WY1003) / (n + 1);

            CGFloat WY1004_REF = WY1004;
            WY1004 = (2 * WY1003 + (n - 1) * WY1004) / (n + 1);

            CGFloat XO_REF = x0;
            if (WY1004_REF < 0.001) {
                x0 = 0;
            }else {
                x0 = (WY1004 - WY1004_REF) / WY1004_REF * 100;
            }

            klineMode.X0 = x0;
            klineMode.S1 = (XO_REF + x0) / 2;
        }];
    }
    
    if (self.historyArray.count > 0) {
        if([UIApplication sharedApplication].statusBarOrientation == UIInterfaceOrientationLandscapeLeft || [UIApplication sharedApplication].statusBarOrientation == UIInterfaceOrientationLandscapeRight) {
            if (self.kLinePeriodView.aiBtn.selected) {
                self.klineCharView.frame = CGRectMake(0, 40, screenW - SafeAreaInsetsConstantForDeviceWithNotch.left - SafeAreaInsetsConstantForDeviceWithNotch.right, screenH - SafeAreaInsetsConstantForDeviceWithNotch.bottom - 65 - 45 - 40);
            }else {
                self.klineCharView.frame = CGRectMake(0, 0, screenW - SafeAreaInsetsConstantForDeviceWithNotch.left - SafeAreaInsetsConstantForDeviceWithNotch.right, screenH - SafeAreaInsetsConstantForDeviceWithNotch.bottom - 65 - 45);
            }
        } else {
            if (self.kLinePeriodView.aiBtn.selected) {
                self.klineCharView.frame = CGRectMake(0, 192 + 40, screenW, self.tableViewHeadView.height - 192 - 60 - 40);
            }else {
                self.klineCharView.frame = CGRectMake(0, 192, screenW, self.tableViewHeadView.height - 192 - 60);
            }
        }
        
        self.kLineAISettingView.hidden = NO;
        [DataUtil calculate:self.historyArray];
        if (!repeats) {
            [KLineStateManager manager].scrollX = 0;
        }
        [KLineStateManager manager].isLine = NO;
        [KLineStateManager manager].datas = [self.historyArray mutableCopy];
    }
}

// 判断两个日期字符串是否属于同一周
- (BOOL)isSameWeekWithDate1:(NSString *)dateString1 date2:(NSString *)dateString2 {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"yyyy-MM-dd";
    
    NSDate *date1 = [dateFormatter dateFromString:dateString1];
    NSDate *date2 = [dateFormatter dateFromString:dateString2];
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    calendar.firstWeekday = 2;  // 设置每周的第一天是周一
    
    NSDateComponents *components1 = [calendar components:NSCalendarUnitWeekOfYear | NSCalendarUnitYearForWeekOfYear fromDate:date1];
    NSDateComponents *components2 = [calendar components:NSCalendarUnitWeekOfYear | NSCalendarUnitYearForWeekOfYear fromDate:date2];
    
    return (components1.weekOfYear == components2.weekOfYear && components1.yearForWeekOfYear == components2.yearForWeekOfYear);
}

// 判断两个日期字符串是否属于同一月份
- (BOOL)isSameMonthWithDate1:(NSString *)dateString1 date2:(NSString *)dateString2 {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"yyyy-MM-dd";
    
    NSDate *date1 = [dateFormatter dateFromString:dateString1];
    NSDate *date2 = [dateFormatter dateFromString:dateString2];
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
    NSDateComponents *components1 = [calendar components:NSCalendarUnitMonth | NSCalendarUnitYear fromDate:date1];
    NSDateComponents *components2 = [calendar components:NSCalendarUnitMonth | NSCalendarUnitYear fromDate:date2];
    
    return (components1.month == components2.month && components1.year == components2.year);
}

// 判断两个日期字符串是否属于同一季度
- (BOOL)isSameQuarterWithDate1:(NSString *)dateString1 date2:(NSString *)dateString2 {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"yyyy-MM-dd";
    
    NSDate *date1 = [dateFormatter dateFromString:dateString1];
    NSDate *date2 = [dateFormatter dateFromString:dateString2];
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
    NSDateComponents *components1 = [calendar components:NSCalendarUnitQuarter | NSCalendarUnitYear fromDate:date1];
    NSDateComponents *components2 = [calendar components:NSCalendarUnitQuarter | NSCalendarUnitYear fromDate:date2];
    
    return (components1.quarter == components2.quarter && components1.year == components2.year);
}

#pragma mark ---- 网络请求 ----
- (void)queueRequestData {
//    NSString *path = [[NSBundle mainBundle] pathForResource:@"kk33" ofType:@"json"];
//    NSDate *data = [[NSData alloc] initWithContentsOfURL: [[NSURL alloc] initFileURLWithPath:path]];
//    NSDictionary *dicts = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingFragmentsAllowed error:nil];
//    [self setHistoryData:dicts lastDataArray:[NSArray array]];
//    return;
    
    NSLog(@"---- 当前选择时间 = %@ ----",self.currentSelectMintue);
    
    [self.view showProgress:@""];
    dispatch_group_t group = dispatch_group_create();
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    
    dispatch_group_enter(group);
    dispatch_async(queue, ^{
        //获取个股基本数据
        TMHttpParams *param = [[TMHttpParams alloc] init];
        [param setUrl:API_getStockBaseData_URL];
        [param addParams:self.stockCode forKey:@"code"];
        param.requestType = POST;
        [DataRequest requestWithParam:param successed:^(NSDictionary *dict, NSError *error, int result, NSString *msg) {
            
            if (result == 1) {
                self->_lastStockBaseDict = dict;
                [self.exponentView setDataWithArray:dict[@"basic"]];
                [self.landExponenView setDataWithArray:dict[@"basic"] title:self.mainTitle subTitle:self.subTitle];
                [self.realTimeBuySaleView setDataWithArray:dict[@"sale"]];
            }
            
            dispatch_group_leave(group);
        }];
    });
    
    dispatch_group_enter(group);
    dispatch_async(queue, ^{
        TMHttpParams *param = [[TMHttpParams alloc] init];
        if (self.dateSelectState == DateSelectStateDay) {
            [param setUrl:API_getStockDayData_URL];
        }else if (self.dateSelectState == DateSelectStateWeek) {
            [param setUrl:API_getStockWeekData_URL];
        }else if (self.dateSelectState == DateSelectStateMonth) {
            [param setUrl:API_getStockMonthData_URL];
        }else if (self.dateSelectState == DateSelectStateQuarter) {
            [param setUrl:API_getStockQuarterData_URL];
        }else {
            [param setUrl:API_getStockMinuteData_URL];
            [param addParams:self.currentSelectMintue forKey:@"minute"];
        }
        [param addParams:self.stockCode forKey:@"code"];
        [param addParams:self.md5String forKey:@"md5"];
        [param addParams:@"GZIP" forKey:@"customKey"];
        param.requestType = POST;
        [DataRequest requestWithParam:param successed:^(NSDictionary *dict, NSError *error, int result, NSString *msg) {
            
            if (result == 1) {
                [KLineStateManager manager].dict = dict;
                if (self.dateSelectState == DateSelectStateDay) {
                    [self setHistoryData:dict historyDataArray:dict[@"history_data"] lastDataArray:dict[@"latest_data"] repeats:NO type:@"day" mintue:@""];
                }else if (self.dateSelectState == DateSelectStateWeek) {
                    [self setHistoryData:dict historyDataArray:dict[@"history_data"] lastDataArray:dict[@"latest_data"] repeats:NO type:@"week" mintue:@""];
                }else if (self.dateSelectState == DateSelectStateMonth) {
                    [self setHistoryData:dict historyDataArray:dict[@"history_data"] lastDataArray:dict[@"latest_data"] repeats:NO type:@"month" mintue:@""];
                }else if (self.dateSelectState == DateSelectStateQuarter) {
                    [self setHistoryData:dict historyDataArray:dict[@"history_data"] lastDataArray:dict[@"latest_data"] repeats:NO type:@"quarter" mintue:@""];
                }else {
                    [self setHistoryData:dict historyDataArray:dict[@"history_data"] lastDataArray:dict[@"latest_data"] repeats:NO type:@"minute" mintue:self.currentSelectMintue];
                }
                self.md5String = dict[@"md5"];
                
                self.pollTimer = [NSTimer scheduledTimerWithTimeInterval:timeInterval target:self selector:@selector(autoUpdateData) userInfo:nil repeats:YES];
            } else {
                //[QMUITips showWithText:msg];
            }
            
            dispatch_group_leave(group);
        }];
    });
    
    dispatch_group_enter(group);
    dispatch_async(queue, ^{
        //获取个股金池报警状态
        TMHttpParams *param = [[TMHttpParams alloc] init];
        [param setUrl:API_getStockStatus_URL];
        [param addParams:self.stockCode forKey:@"code"];
        param.requestType = POST;
        
        [DataRequest requestWithParam:param successed:^(NSDictionary *dict, NSError *error, int result, NSString *msg) {
            
            if (result == 1) {
                
                if ([dict[@"alarm"] intValue] == 1) {
                    [self.kLineBottomView.addAIBtn setImage:[UIImage imageNamed:@"icon_delete"] forState:UIControlStateNormal];
                }else {
                    [self.kLineBottomView.addAIBtn setImage:[UIImage imageNamed:@"icon_add"] forState:UIControlStateNormal];
                }
                self.kLineBottomView.addAIBtn.tag = [dict[@"alarm"] intValue];
              
                if ([dict[@"pool"] intValue] == 1) {
                    [self.kLineBottomView.addPondBtn setImage:[UIImage imageNamed:@"icon_delete"] forState:UIControlStateNormal];
                }else {
                    [self.kLineBottomView.addPondBtn setImage:[UIImage imageNamed:@"icon_add"] forState:UIControlStateNormal];
                }
                self.kLineBottomView.addPondBtn.tag = [dict[@"pool"] intValue];
            }
            
            dispatch_group_leave(group);
        }];
    });
    
    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
        [self.view progressDiss];
        self.loadingView.hidden = YES;
        [KLineStateManager manager].isShowDrawPen = YES;
        [KLineStateManager manager].isShowDrawRect = YES;
        NSLog(@"请求完成");
    });
}

- (void)requestStockTimeData:(BOOL)repeats {
    self.currentSelectType = DateSelectStateTimeShare;
    self.isSelectLine = YES;
    
//    if (self.stockTimeArray.count > 0) {
//
//        if([UIApplication sharedApplication].statusBarOrientation == UIInterfaceOrientationLandscapeLeft || [UIApplication sharedApplication].statusBarOrientation == UIInterfaceOrientationLandscapeRight) {
//            self.klineCharView.frame = CGRectMake(0, 0, screenW - SafeAreaInsetsConstantForDeviceWithNotch.left - SafeAreaInsetsConstantForDeviceWithNotch.right - ChartStyle_buySaleViewWidth, screenH - SafeAreaInsetsConstantForDeviceWithNotch.bottom - 65 - 45);
//            self.realTimeBuySaleView.frame = CGRectMake(screenW - SafeAreaInsetsConstantForDeviceWithNotch.left - SafeAreaInsetsConstantForDeviceWithNotch.right - ChartStyle_buySaleViewWidth, 0, ChartStyle_buySaleViewWidth, screenH - SafeAreaInsetsConstantForDeviceWithNotch.bottom - 65 - 45);
//        } else {
//            self.klineCharView.frame = CGRectMake(0, 192, screenW - ChartStyle_buySaleViewWidth, self.tableViewHeadView.height - 192 - 60);
//            self.realTimeBuySaleView.frame = CGRectMake(screenW - ChartStyle_buySaleViewWidth, 192, ChartStyle_buySaleViewWidth, self.tableViewHeadView.height - 192 - 60);
//        }
//
//        [DataUtil calculate:self.stockTimeArray];
//        [KLineStateManager manager].isLine = YES;
//        [KLineStateManager manager].datas = self.stockTimeArray;
//        return;
//    }
    
    if (!repeats) {
        self.md5String = @"";
        [self.view showProgress:@""];
    }
    
    TMHttpParams *param = [[TMHttpParams alloc] init];
    [param setUrl:API_getStockTimeData_URL];
    [param addParams:self.stockCode forKey:@"code"];
    [param addParams:@"GZIP" forKey:@"customKey"];
    param.requestType = POST;
    [DataRequest requestWithParam:param successed:^(NSDictionary *dict, NSError *error, int result, NSString *msg) {
        [self.view progressDiss];
        if (result == 1) {
            
            //self.lastSelectType = self.currentSelectType;
            if (self.stockTimeArray.count > 0) {
                [self.stockTimeArray removeAllObjects];
            }
            
            NSMutableArray *tempArray01 = [NSMutableArray array];
            tempArray01 = dict[@"timeData"][@"times"];
            
            NSMutableArray *tempArray02 = [NSMutableArray array];
            tempArray02 = dict[@"timeData"][@"closes"];

            NSMutableArray *tempArray03 = [NSMutableArray array];
            tempArray03 = dict[@"timeData"][@"precloses"];

            NSMutableArray *tempArray04 = [NSMutableArray array];
            tempArray04 = dict[@"timeData"][@"volumes"];
            
            //测试代码
//            NSMutableArray *tempArray02 = [NSMutableArray array];
//            NSMutableArray *tempArray03 = [NSMutableArray array];
//            NSMutableArray *tempArray04 = [NSMutableArray array];
//
//            NSArray *xxxxx = dict[@"timeData"][@"closes"];
//            [tempArray02 addObjectsFromArray:xxxxx];
//            for (NSInteger i = xxxxx.count; i > 195; i--) {
//                [tempArray02 removeObjectAtIndex:i-1];
//            }
//
//            NSArray *xxxxx1111 = dict[@"timeData"][@"precloses"];
//            [tempArray03 addObjectsFromArray:xxxxx1111];
//            for (NSInteger i = xxxxx.count; i > 195; i--) {
//                [tempArray03 removeObjectAtIndex:i-1];
//            }
//            NSArray *xxxxx222 = dict[@"timeData"][@"volumes"];
//            [tempArray04 addObjectsFromArray:xxxxx222];
//            for (NSInteger i = xxxxx.count; i > 195; i--) {
//                [tempArray04 removeObjectAtIndex:i-1];
//            }
            
            [tempArray01 enumerateObjectsWithOptions:NSEnumerationReverse usingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                KLineModel *klineModel = [[KLineModel alloc] init];
                
                klineModel.date = tempArray01[idx];
                
                if (tempArray02.count > idx) {
                    klineModel.isShowCurrentIndex = YES;
                    klineModel.close = [tempArray02[idx] doubleValue];
                    klineModel.lasetDayclose = [tempArray03[idx] doubleValue];
                    klineModel.vol = [tempArray04[idx] doubleValue];
                }
                
                [self.stockTimeArray addObject:klineModel];
            }];
            
            //海底捞月数据
            NSMutableArray *hdlyDataArray = [NSMutableArray array];
            [hdlyDataArray addObjectsFromArray:dict[@"hdlyData"]];
            if (hdlyDataArray.count > tempArray01.count) {
                [hdlyDataArray removeLastObject];
            }
            [hdlyDataArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                KLineModel *klineModel = self.stockTimeArray[self.stockTimeArray.count - idx - 1];
                klineModel.hdlyHigh = [obj doubleValue];
            }];
            
            NSMutableArray *horizonArray = [NSMutableArray array];
            [horizonArray addObjectsFromArray:dict[@"horizon"]];
            if (horizonArray.count > tempArray01.count) {
                [horizonArray removeLastObject];
            }
            [horizonArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                KLineModel *klineModel = self.stockTimeArray[self.stockTimeArray.count - idx - 1];
                klineModel.horizon = [obj doubleValue];
            }];
            
            NSMutableArray *monthLineArray = [NSMutableArray array];
            [monthLineArray addObjectsFromArray:dict[@"monthLine"]];
            if (monthLineArray.count > tempArray01.count) {
                [monthLineArray removeLastObject];
            }
            [monthLineArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                KLineModel *klineModel = self.stockTimeArray[self.stockTimeArray.count - idx - 1];
                klineModel.monthLine = [obj doubleValue];
            }];
            
            if([UIApplication sharedApplication].statusBarOrientation == UIInterfaceOrientationLandscapeLeft || [UIApplication sharedApplication].statusBarOrientation == UIInterfaceOrientationLandscapeRight) {
                self.klineCharView.frame = CGRectMake(0, 0, screenW - SafeAreaInsetsConstantForDeviceWithNotch.left - SafeAreaInsetsConstantForDeviceWithNotch.right - ChartStyle_buySaleViewWidth, screenH - SafeAreaInsetsConstantForDeviceWithNotch.bottom - 65 - 45);
                self.realTimeBuySaleView.frame = CGRectMake(screenW - SafeAreaInsetsConstantForDeviceWithNotch.left - SafeAreaInsetsConstantForDeviceWithNotch.right - ChartStyle_buySaleViewWidth, 0, ChartStyle_buySaleViewWidth, screenH - SafeAreaInsetsConstantForDeviceWithNotch.bottom - 65 - 45);
            } else {
                self.klineCharView.frame = CGRectMake(0, 192, screenW - ChartStyle_buySaleViewWidth, self.tableViewHeadView.height - 192 - 60);
                self.realTimeBuySaleView.frame = CGRectMake(screenW - ChartStyle_buySaleViewWidth, 192, ChartStyle_buySaleViewWidth, self.tableViewHeadView.height - 192 - 60);
            }
            
            self.kLinePeriodView.aiBtn.selected = NO;
            self.kLineAISettingView.hidden = YES;
            [DataUtil calculate:self.stockTimeArray];
            [KLineStateManager manager].isLine = YES;
            [KLineStateManager manager].datas = self.stockTimeArray;
            
        } else {
            //self.currentSelectType = self.lastSelectType;
            if (!repeats) {
                [QMUITips showWithText:msg];
            }
        }
    }];
}

- (void)requestStockDayData:(BOOL)repeats {
//    if (self.historyArray.count > 0) {
//        [self.historyArray removeAllObjects];
//    }
//    NSString *path = [[NSBundle mainBundle] pathForResource:@"kk33" ofType:@"json"];
//    NSDate *data = [[NSData alloc] initWithContentsOfURL: [[NSURL alloc] initFileURLWithPath:path]];
//    NSDictionary *dicts = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingFragmentsAllowed error:nil];
//    [self setHistoryData:dicts lastDataArray:[NSArray array]];
//    return;
    
    self.currentSelectType = DateSelectStateDay;
    
    if (!repeats) {
        self.md5String = @"";
        [self.view showProgress:@""];
    }
    TMHttpParams *param = [[TMHttpParams alloc] init];
    [param setUrl:API_getStockDayData_URL];
    [param addParams:self.stockCode forKey:@"code"];
    [param addParams:self.md5String forKey:@"md5"];
    [param addParams:@"GZIP" forKey:@"customKey"];
    param.requestType = POST;
    [DataRequest requestWithParam:param successed:^(NSDictionary *dict, NSError *error, int result, NSString *msg) {
        
        if (result == 1) {
            //NSLog(@"正常请求成功");
            if (self.historyArray.count > 0) {
                [self.historyArray removeAllObjects];
            }
            
            //self.lastSelectType = self.currentSelectType;
            NSArray *arr01 = dict[@"history_data"];
            NSArray *arr02 = dict[@"latest_data"];
            if (arr01.count == 0 && !IsNull([KLineStateManager manager].dict)) {
                if (arr02.count > 0) {
                    [self setHistoryData:dict historyDataArray:[KLineStateManager manager].dict[@"history_data"] lastDataArray:dict[@"latest_data"] repeats:repeats type:@"day" mintue:@""];
                }else {
                    [self setHistoryData:[KLineStateManager manager].dict historyDataArray:[KLineStateManager manager].dict[@"history_data"] lastDataArray:dict[@"latest_data"] repeats:repeats type:@"day" mintue:@""];
                }
            }else {
                [KLineStateManager manager].dict = dict;
                [self setHistoryData:dict historyDataArray:dict[@"history_data"] lastDataArray:dict[@"latest_data"] repeats:repeats type:@"day" mintue:@""];
            }
            
            self.md5String = dict[@"md5"];
        } else {
            [self.view progressDiss];
            //NSLog(@"主动取消请求失败");
            //self.currentSelectType = self.lastSelectType;
            if (!repeats) {
                [QMUITips showWithText:msg];
            }
        }
    }];
}

- (void)requestStockWeekData:(BOOL)repeats {
    self.currentSelectType = DateSelectStateWeek;
    
    if (!repeats) {
        self.md5String = @"";
        [self.view showProgress:@""];
    }
    
    TMHttpParams *param = [[TMHttpParams alloc] init];
    [param setUrl:API_getStockWeekData_URL];
    [param addParams:self.stockCode forKey:@"code"];
    [param addParams:self.md5String forKey:@"md5"];
    [param addParams:@"GZIP" forKey:@"customKey"];
    param.requestType = POST;
    [DataRequest requestWithParam:param successed:^(NSDictionary *dict, NSError *error, int result, NSString *msg) {
        
        if (result == 1) {
            
            if (self.historyArray.count > 0) {
                [self.historyArray removeAllObjects];
            }
            
            //self.lastSelectType = self.currentSelectType;
            NSArray *arr01 = dict[@"history_data"];
            NSArray *arr02 = dict[@"latest_data"];
            if (arr01.count == 0 && !IsNull([KLineStateManager manager].dict)) {
                if (arr02.count > 0) {
                    [self setHistoryData:dict historyDataArray:[KLineStateManager manager].dict[@"history_data"] lastDataArray:dict[@"latest_data"] repeats:repeats type:@"week" mintue:@""];
                }else {
                    [self setHistoryData:[KLineStateManager manager].dict historyDataArray:[KLineStateManager manager].dict[@"history_data"] lastDataArray:dict[@"latest_data"] repeats:repeats type:@"week" mintue:@""];
                }
            }else {
                [KLineStateManager manager].dict = dict;
                [self setHistoryData:dict historyDataArray:dict[@"history_data"] lastDataArray:dict[@"latest_data"] repeats:repeats type:@"week" mintue:@""];
            }
            
            self.md5String = dict[@"md5"];
        } else {
            [self.view progressDiss];
            //self.currentSelectType = self.lastSelectType;
            if (!repeats) {
                [QMUITips showWithText:msg];
            }
        }
    }];
}

- (void)requestStockMonthData:(BOOL)repeats {
    self.currentSelectType = DateSelectStateMonth;
    
    if (!repeats) {
        self.md5String = @"";
        [self.view showProgress:@""];
    }
    
    TMHttpParams *param = [[TMHttpParams alloc] init];
    [param setUrl:API_getStockMonthData_URL];
    [param addParams:self.stockCode forKey:@"code"];
    [param addParams:self.md5String forKey:@"md5"];
    [param addParams:@"GZIP" forKey:@"customKey"];
    param.requestType = POST;
    [DataRequest requestWithParam:param successed:^(NSDictionary *dict, NSError *error, int result, NSString *msg) {
        
        if (result == 1) {
            
            if (self.historyArray.count > 0) {
                [self.historyArray removeAllObjects];
            }
            
            //self.lastSelectType = self.currentSelectType;
            NSArray *arr01 = dict[@"history_data"];
            NSArray *arr02 = dict[@"latest_data"];
            if (arr01.count == 0 && !IsNull([KLineStateManager manager].dict)) {
                if (arr02.count > 0) {
                    [self setHistoryData:dict historyDataArray:[KLineStateManager manager].dict[@"history_data"] lastDataArray:dict[@"latest_data"] repeats:repeats type:@"month" mintue:@""];
                }else {
                    [self setHistoryData:[KLineStateManager manager].dict historyDataArray:[KLineStateManager manager].dict[@"history_data"] lastDataArray:dict[@"latest_data"] repeats:repeats type:@"month" mintue:@""];
                }
            }else {
                [KLineStateManager manager].dict = dict;
                [self setHistoryData:dict historyDataArray:dict[@"history_data"] lastDataArray:dict[@"latest_data"] repeats:repeats type:@"month" mintue:@""];
            }
            
            self.md5String = dict[@"md5"];
        } else {
            [self.view progressDiss];
            //self.currentSelectType = self.lastSelectType;
            if (!repeats) {
                [QMUITips showWithText:msg];
            }
        }
    }];
}

- (void)requestStockQuarterData:(BOOL)repeats {
    self.currentSelectType = DateSelectStateQuarter;
    
    if (!repeats) {
        self.md5String = @"";
        [self.view showProgress:@""];
    }
    
    TMHttpParams *param = [[TMHttpParams alloc] init];
    [param setUrl:API_getStockQuarterData_URL];
    [param addParams:self.stockCode forKey:@"code"];
    [param addParams:self.md5String forKey:@"md5"];
    [param addParams:@"GZIP" forKey:@"customKey"];
    param.requestType = POST;
    [DataRequest requestWithParam:param successed:^(NSDictionary *dict, NSError *error, int result, NSString *msg) {
        
        if (result == 1) {
            
            if (self.historyArray.count > 0) {
                [self.historyArray removeAllObjects];
            }
            
            //self.lastSelectType = self.currentSelectType;
            NSArray *arr01 = dict[@"history_data"];
            NSArray *arr02 = dict[@"latest_data"];
            if (arr01.count == 0 && !IsNull([KLineStateManager manager].dict)) {
                if (arr02.count > 0) {
                    [self setHistoryData:dict historyDataArray:[KLineStateManager manager].dict[@"history_data"] lastDataArray:dict[@"latest_data"] repeats:repeats type:@"quarter" mintue:@""];
                }else {
                    [self setHistoryData:[KLineStateManager manager].dict historyDataArray:[KLineStateManager manager].dict[@"history_data"] lastDataArray:dict[@"latest_data"] repeats:repeats type:@"quarter" mintue:@""];
                }
            }else {
                [KLineStateManager manager].dict = dict;
                [self setHistoryData:dict historyDataArray:dict[@"history_data"] lastDataArray:dict[@"latest_data"] repeats:repeats type:@"quarter" mintue:@""];
            }
            
            self.md5String = dict[@"md5"];
        } else {
            [self.view progressDiss];
            //self.currentSelectType = self.lastSelectType;
            if (!repeats) {
                [QMUITips showWithText:msg];
            }
        }
    }];
}

- (void)requestStockMinuteData:(NSString *)minute repeats:(BOOL)repeats {
    self.currentSelectType = DateSelectStateMinute;
    self.currentSelectMintue = minute;
    //NSLog(@"---- 当前选择时间 = %@ ----",minute);
    
    if (!repeats) {
        self.md5String = @"";
        [self.view showProgress:@""];
    }
    
    TMHttpParams *param = [[TMHttpParams alloc] init];
    [param setUrl:API_getStockMinuteData_URL];
    [param addParams:self.stockCode forKey:@"code"];
    [param addParams:minute forKey:@"minute"];
    [param addParams:self.md5String forKey:@"md5"];
    [param addParams:@"GZIP" forKey:@"customKey"];
    param.requestType = POST;
    [DataRequest requestWithParam:param successed:^(NSDictionary *dict, NSError *error, int result, NSString *msg) {
        
        if (result == 1) {
            
            if (self.historyArray.count > 0) {
                [self.historyArray removeAllObjects];
            }
            
            //self.lastSelectType = self.currentSelectType;
            //self.lastSelectMintue = self.currentSelectMintue;
            NSArray *arr01 = dict[@"history_data"];
            NSArray *arr02 = dict[@"latest_data"];
            if (arr01.count == 0 && !IsNull([KLineStateManager manager].dict)) {
                if (arr02.count > 0) {
                    [self setHistoryData:dict historyDataArray:[KLineStateManager manager].dict[@"history_data"] lastDataArray:dict[@"latest_data"] repeats:repeats type:@"minute" mintue:minute];
                }else {
                    [self setHistoryData:[KLineStateManager manager].dict historyDataArray:[KLineStateManager manager].dict[@"history_data"] lastDataArray:dict[@"latest_data"] repeats:repeats type:@"minute" mintue:minute];
                }
            }else {
                [KLineStateManager manager].dict = dict;
                [self setHistoryData:dict historyDataArray:dict[@"history_data"] lastDataArray:dict[@"latest_data"] repeats:repeats type:@"minute" mintue:minute];
            }
            
            self.md5String = dict[@"md5"];
        } else {
            [self.view progressDiss];
            //self.currentSelectType = self.lastSelectType;
            //self.currentSelectMintue = self.lastSelectMintue;
            if (!repeats) {
                [QMUITips showWithText:msg];
            }
        }
    }];
}

#pragma mark - JXPagerSmoothViewDataSource
- (void)orderListScrollToTop:(NSNotification *)notification{
    [self.pagingView.currentScrollingListView setContentOffset:CGPointZero animated:NO];
    [self.pagingView.mainTableView setContentOffset:CGPointZero animated:NO];
}

- (MLPagerView *)preferredPagingView {
    return [[MLPagerListRefreshView alloc] initWithDelegate:self];
}

- (UIView *)tableHeaderViewInPagerView:(MLPagerView *)pagerView {
    return self.tableViewHeadView;
}

- (NSUInteger)tableHeaderViewHeightInPagerView:(MLPagerView *)pagerView {
    return self.tableViewHeadView.height;
}

- (NSUInteger)heightForPinSectionHeaderInPagerView:(MLPagerView *)pagerView {
    //return self.menView.height;
    return 0.01f;
}

- (UIView *)viewForPinSectionHeaderInPagerView:(MLPagerView *)pagerView {
    //return self.menView;
    return [UIView new];
}

- (NSInteger)numberOfListsInPagerView:(MLPagerView *)pagerView {
    return 3;
}

- (id<MLPagerViewListViewDelegate>)pagerView:(MLPagerView *)pagerView initListAtIndex:(NSInteger)index {
    JournalismListVC *vc = [[JournalismListVC alloc] init];
    vc.orderStatus = [NSString stringWithFormat:@"%ld",index];
    return vc;
}

-(void)pagerScrollViewSelectIndex:(NSInteger)index{
    [self.menView categorySelectIndex:index];
}

-(void)contentScrollViewVillChanged:(CGPoint)contentOffset
{
    [self.menView contentOffsetOfContentScrollViewDidChanged:contentOffset];
}

//self.pagerView.mainTableView.gestureDelegate = self; 成为mainTableView的手势代理
//当otherGestureRecognizer时轮播视图collectionView.panGestureRecognizer返回NO，即可
- (BOOL)mainTableViewGestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    //禁止banner左右滑动的时候，上下和左右都可以滚动
    //禁止categoryView左右滑动的时候，上下和左右都可以滚动
//    if (otherGestureRecognizer == self.menView.collectionView.panGestureRecognizer || otherGestureRecognizer == self.klineCharView.panGesture) {
//        return NO;
//    }
//    return [gestureRecognizer isKindOfClass:[UIPanGestureRecognizer class]] && [otherGestureRecognizer isKindOfClass:[UIPanGestureRecognizer class]];
    return NO;
}

#pragma mark ---- 横竖屏相关 ----
-(void)chageRotate:(NSNotification *)noti {
    if([UIApplication sharedApplication].statusBarOrientation == UIInterfaceOrientationLandscapeLeft || [UIApplication sharedApplication].statusBarOrientation == UIInterfaceOrientationLandscapeRight) {
        [self horizontalLayout];
        //self.pagingView.mainTableView.scrollEnabled = NO;
        self.klineCharView.painterView.fullScreenBtn.hidden = YES;
    } else {
        [self verticalLayout];
        //self.pagingView.mainTableView.scrollEnabled = YES;
        self.klineCharView.painterView.fullScreenBtn.hidden = NO;
    }
}

-(void)verticalLayout {
    self.klineCharView.direction = KLineDirectionVertical;
    [self.pagingView.mainTableView setContentOffset:CGPointMake(0,0) animated:NO];
    
    self.kLineTabHeadView.hidden = NO;
    self.landExponenView.hidden = YES;
    
    self.pagingView.frame = CGRectMake(0, Height_NavBar, screenW, screenH - Height_NavBar);
    self.realTimeBuySaleView.frame = CGRectMake(screenW - ChartStyle_buySaleViewWidth, 192, ChartStyle_buySaleViewWidth, self.tableViewHeadView.height - 192 - 60);
    self.kLinePeriodView.frame = CGRectMake(0, self.exponentView.BottomY + 8, screenW, 44);
    self.kLinePeriodView.lineViewConstraintX.constant = ((self.kLinePeriodView.frame.size.width - 135)/5 - 30)/2 + (self.kLinePeriodView.frame.size.width - 135)/5 * self.kLinePeriodView.currentButton.tag;
    self.kLineAISettingView.frame = CGRectMake(0, self.kLinePeriodView.BottomY, screenW, 40);
    self.kLineAISettingView.scrollView.frame = CGRectMake(0, 0, self.kLineAISettingView.width, self.kLineAISettingView.height);
    
    if (self.isSelectLine) {
        self.klineCharView.frame = CGRectMake(0, 192, screenW - ChartStyle_buySaleViewWidth, self.tableViewHeadView.height - 192 - 60);
    }else {
        if (self.kLinePeriodView.aiBtn.selected) {
            self.klineCharView.frame = CGRectMake(0, 192 + 40, screenW, self.tableViewHeadView.height - 192 - 60 - 40);
        }else {
            self.klineCharView.frame = CGRectMake(0, 192, screenW, self.tableViewHeadView.height - 192 - 60);
        }
    }
}

-(void)horizontalLayout {
    //NSLog(@"左边安全距离 = %f，顶部安全距离 = %f，右边安全距离 = %f，底部安全距离 = %f",SafeAreaInsetsConstantForDeviceWithNotch.left,SafeAreaInsetsConstantForDeviceWithNotch.top,SafeAreaInsetsConstantForDeviceWithNotch.right,SafeAreaInsetsConstantForDeviceWithNotch.bottom);
    self.klineCharView.direction = KLineDirectionHorizontal;
    //[self.pagingView.mainTableView setContentOffset:CGPointMake(0,0) animated:NO];
    
    self.kLineTabHeadView.hidden = YES;
    self.landExponenView.hidden = NO;
    
    self.landExponenView.frame = CGRectMake(SafeAreaInsetsConstantForDeviceWithNotch.left, 0, screenW - SafeAreaInsetsConstantForDeviceWithNotch.left - SafeAreaInsetsConstantForDeviceWithNotch.right, 65);
    self.pagingView.frame = CGRectMake(SafeAreaInsetsConstantForDeviceWithNotch.left, 65, screenW - SafeAreaInsetsConstantForDeviceWithNotch.left - SafeAreaInsetsConstantForDeviceWithNotch.right, screenH - SafeAreaInsetsConstantForDeviceWithNotch.bottom - 65);
    self.kLineAISettingView.frame = CGRectMake(0, 0, screenW - SafeAreaInsetsConstantForDeviceWithNotch.left - SafeAreaInsetsConstantForDeviceWithNotch.right, 40);
    self.kLineAISettingView.scrollView.frame = CGRectMake(0, 0, self.kLineAISettingView.width, self.kLineAISettingView.height);
    if (self.isSelectLine) {
        self.klineCharView.frame = CGRectMake(0, 0, screenW - SafeAreaInsetsConstantForDeviceWithNotch.left - SafeAreaInsetsConstantForDeviceWithNotch.right - ChartStyle_buySaleViewWidth, screenH - SafeAreaInsetsConstantForDeviceWithNotch.bottom - 65 - 45);
    }else {
        if (self.kLinePeriodView.aiBtn.selected) {
            self.klineCharView.frame = CGRectMake(0, 40, screenW - SafeAreaInsetsConstantForDeviceWithNotch.left - SafeAreaInsetsConstantForDeviceWithNotch.right, screenH - SafeAreaInsetsConstantForDeviceWithNotch.bottom - 65 - 45 - 40);
        }else {
            self.klineCharView.frame = CGRectMake(0, 0, screenW - SafeAreaInsetsConstantForDeviceWithNotch.left - SafeAreaInsetsConstantForDeviceWithNotch.right, screenH - SafeAreaInsetsConstantForDeviceWithNotch.bottom - 65 - 45);
        }
    }
    self.realTimeBuySaleView.frame = CGRectMake(screenW - SafeAreaInsetsConstantForDeviceWithNotch.left - SafeAreaInsetsConstantForDeviceWithNotch.right - ChartStyle_buySaleViewWidth, 0, ChartStyle_buySaleViewWidth, screenH - SafeAreaInsetsConstantForDeviceWithNotch.bottom - 65 - 45);
    self.kLinePeriodView.frame = CGRectMake(0, self.klineCharView.BottomY, self.pagingView.bounds.size.width, 44);
    self.kLinePeriodView.lineViewConstraintX.constant = ((self.kLinePeriodView.frame.size.width - 135)/5 - 30)/2 + (self.kLinePeriodView.frame.size.width - 135)/5 * self.kLinePeriodView.currentButton.tag;
}

//进入全屏
-(void)begainFullScreen
{
   //AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;

   // 当前是否横屏
   if ([UIApplication sharedApplication].statusBarOrientation == UIInterfaceOrientationLandscapeLeft || [UIApplication sharedApplication].statusBarOrientation == UIInterfaceOrientationLandscapeRight) {
       // 已经横屏，AppDelegate中锁定为当前屏幕状态
       APP.orientations = (1 << [UIApplication sharedApplication].statusBarOrientation);
   } else {
       // 竖屏-强制屏幕横屏
       // AppDelegate中锁定为横屏
       APP.orientations = UIInterfaceOrientationMaskLandscapeRight;
       // 强制旋转
       if (@available(iOS 16.0, *)) {
#if defined(__IPHONE_16_0)
           // 避免没有更新Xcode14的同事报错
           // iOS16新API，让控制器刷新方向，新方向为上面设置的orientations
           [self setNeedsUpdateOfSupportedInterfaceOrientations];
#endif
       } else {
           // iOS16以下
           NSNumber *orientationPortrait = [NSNumber numberWithInt:UIInterfaceOrientationLandscapeRight];
           [[UIDevice currentDevice] setValue:orientationPortrait forKey:@"orientation"];
       }
   }
}
// 退出全屏
-(void)endFullScreen
{
    //AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
    APP.orientations = UIInterfaceOrientationMaskPortrait;
    // 强制旋转
    if (@available(iOS 16.0, *)) {
#if defined(__IPHONE_16_0)
        // 避免没有更新Xcode14的同事报错
        // iOS16新API，让控制器刷新方向，新方向为上面设置的orientations
        [self setNeedsUpdateOfSupportedInterfaceOrientations];
#endif
    } else {
        // iOS16以下
        NSNumber *orientationPortrait = [NSNumber numberWithInt:UIInterfaceOrientationMaskPortrait];
        [[UIDevice currentDevice] setValue:orientationPortrait forKey:@"orientation"];
    }
}

#pragma mark - InfoMenuViewDelegate
-(void)categoryClickIndex:(NSInteger)index
{
    [self.pagingView.listContainerView selectPagerIndex:index];
}

#pragma mark ---- KLineTabHeadViewDelegate ----
- (void)searchBtnClick {
    
}

#pragma mark ---- KLinePeriodViewDelegate ----
- (void)dateChatBtnClick:(NSString *)period {
    self.isSelectLine = NO;
    if (self.klineCharView.singleTagPress) {
        self.klineCharView.singleTagPress = NO;
        [self.exponentView setDataWithArray:_lastStockBaseDict[@"basic"]];
        [self.landExponenView setDataWithArray:_lastStockBaseDict[@"basic"] title:self.mainTitle subTitle:self.subTitle];
    }
    //[DataRequest cancelRequest];
    
    //dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if ([period isEqualToString:@"分时"]){
            [self requestStockTimeData:NO];
        }else if ([period isEqualToString:@"日线"]) {
            [self requestStockDayData:NO];
        }else if ([period isEqualToString:@"周线"]) {
            [self requestStockWeekData:NO];
        }else if ([period isEqualToString:@"月线"]) {
            [self requestStockMonthData:NO];
        }else if ([period isEqualToString:@"季线"]) {
            [self requestStockQuarterData:NO];
        }else if ([period isEqualToString:@"1m"]) {
            [self requestStockMinuteData:@"1" repeats:NO];
        }else if ([period isEqualToString:@"3m"]) {
            [self requestStockMinuteData:@"3" repeats:NO];
        }else if ([period isEqualToString:@"5m"]) {
            [self requestStockMinuteData:@"5" repeats:NO];
        }else if ([period isEqualToString:@"10m"]) {
            [self requestStockMinuteData:@"10" repeats:NO];
        }else if ([period isEqualToString:@"15m"]) {
            [self requestStockMinuteData:@"15" repeats:NO];
        }else if ([period isEqualToString:@"30m"]) {
            [self requestStockMinuteData:@"30" repeats:NO];
        }else if ([period isEqualToString:@"1h"]) {
            [self requestStockMinuteData:@"60" repeats:NO];
        }else if ([period isEqualToString:@"2h"]) {
            [self requestStockMinuteData:@"120" repeats:NO];
        }else if ([period isEqualToString:@"3h"]) {
            [self requestStockMinuteData:@"180" repeats:NO];
        }else if ([period isEqualToString:@"4h"]) {
            [self requestStockMinuteData:@"240" repeats:NO];
        }
    //});
}

- (void)settingBtnAction:(BOOL)isHidden {
    if (self.isSelectLine) {
        self.kLinePeriodView.aiBtn.selected = NO;
        [QMUITips showWithText:@"分时图模式下不可用"];
        return;
    }

    CGRect frame = self.klineCharView.frame;
    if (isHidden) {
        frame.origin.y = frame.origin.y - 40;
        frame.size.height += 40;
    }else{
        frame.origin.y = frame.origin.y + 40;
        frame.size.height -= 40;
    }
    self.klineCharView.frame = frame;
}

#pragma mark ---- KLineAISettingViewDelegate ----
- (void)settingAIIndex:(NSInteger)index hidden:(BOOL)hidden {
    if (index == 0) {
        [KLineStateManager manager].isShowDrawPen = hidden;
    }else if (index == 1) {
        [KLineStateManager manager].isShowDrawRect = hidden;
    }else if (index == 2) {
        [KLineStateManager manager].isShowDXW = hidden;
    }else if (index == 3) {
        [KLineStateManager manager].isShowBDW = hidden;
    }else if (index == 4) {
        [KLineStateManager manager].isShowZLSQ = hidden;
    }else if (index == 5) {
        [KLineStateManager manager].isShowZLQS = hidden;
    }
}

#pragma mark ---- KLineChartViewDelegate ----
- (void)updateStockInfoWithModel:(KLineModel *)model {
    [self.exponentView setDataWithModel:model];
    [self.landExponenView setDataWithModel:model];
}

- (void)showLatestStockBaseInfo {
    [self.exponentView setDataWithArray:_lastStockBaseDict[@"basic"]];
    [self.landExponenView setDataWithArray:_lastStockBaseDict[@"basic"] title:self.mainTitle subTitle:self.subTitle];
}

- (void)selectIndex:(NSString *)str {
    //切换MACD和VOL的方法
    if ([KLineStateManager manager].isLine) {
        [KLineStateManager manager].datas = self.stockTimeArray;
    }else {
        [KLineStateManager manager].datas = self.historyArray;
    }
}

- (void)fullScreen {
    if (self.klineCharView.singleTagPress) {
        self.klineCharView.singleTagPress = NO;
        [self.exponentView setDataWithArray:_lastStockBaseDict[@"basic"]];
        [self.landExponenView setDataWithArray:_lastStockBaseDict[@"basic"] title:self.mainTitle subTitle:self.subTitle];
    }
    [self begainFullScreen];
}

#pragma mark ---- LandExponenViewDelegate ----
- (void)backBtnAction {
    if (self.klineCharView.singleTagPress) {
        self.klineCharView.singleTagPress = NO;
        [self.exponentView setDataWithArray:_lastStockBaseDict[@"basic"]];
        [self.landExponenView setDataWithArray:_lastStockBaseDict[@"basic"] title:self.mainTitle subTitle:self.subTitle];
    }
    [self endFullScreen];
}

#pragma mark ---- KLineBottomViewDelegate ----
- (void)addPondBtnAction {
    [self.view showProgress:@""];
    
    if (self.kLineBottomView.addPondBtn.tag == 1) {
        TMHttpParams *param = [[TMHttpParams alloc] init];
        [param setUrl:API_removePool_URL];
        [param addParams:self.stockCode forKey:@"code"];
        param.requestType = POST;
        [DataRequest requestWithParam:param successed:^(NSDictionary *dict, NSError *error, int result, NSString *msg) {
            
            [self.view progressDiss];
            if (result == 1) {
                
                self.kLineBottomView.addPondBtn.tag = 0;
                [self.kLineBottomView.addPondBtn setImage:[UIImage imageNamed:@"icon_add"] forState:UIControlStateNormal];
                PXNotifiPost(StockPoolOperateKey, nil);
            } else {
                [QMUITips showWithText:msg];
            }
        }];
    }else {
        TMHttpParams *param = [[TMHttpParams alloc] init];
        [param setUrl:API_addPool_URL];
        [param addParams:self.stockCode forKey:@"code"];
        param.requestType = POST;
        [DataRequest requestWithParam:param successed:^(NSDictionary *dict, NSError *error, int result, NSString *msg) {
            
            [self.view progressDiss];
            if (result == 1) {
                
                self.kLineBottomView.addPondBtn.tag = 1;
                [self.kLineBottomView.addPondBtn setImage:[UIImage imageNamed:@"icon_delete"] forState:UIControlStateNormal];
                PXNotifiPost(StockPoolOperateKey, nil);
            } else {
                [QMUITips showWithText:msg];
            }
        }];
    }
}

- (void)addAIBtnAction {
    if (self.kLineBottomView.addAIBtn.tag == 1) {
        [MsgAlertTool showAlert:@"" message:[NSString stringWithFormat:@"确定将%@移出缠论报警？",self.stockCode] completion:^(BOOL cancelled, NSInteger buttonIndex) {
            if(!cancelled){
                [self.view showProgress:@""];
                TMHttpParams *param = [[TMHttpParams alloc] init];
                [param setUrl:API_removeByCodeTwist_URL];
                [param addParams:self.stockCode forKey:@"code"];
                param.requestType = POST;
                [DataRequest requestWithParam:param successed:^(NSDictionary *dict, NSError *error, int result, NSString *msg) {
                    
                    [self.view progressDiss];
                    if (result == 1) {
                        
                        self.kLineBottomView.addAIBtn.tag = 0;
                        [self.kLineBottomView.addAIBtn setImage:[UIImage imageNamed:@"icon_add"] forState:UIControlStateNormal];
                        PXNotifiPost(StockAIOperateKey, nil);
                    } else {
                        [QMUITips showWithText:msg];
                    }
                }];
            }
        } cancelButtonTitle:@"取消" otherButtonTitles:@"确定"];
    }else {
        [self.view showProgress:@""];
        TMHttpParams *param = [[TMHttpParams alloc] init];
        [param setUrl:API_addTwist_URL];
        [param addParams:self.stockCode forKey:@"code"];
        [param addParams:@"1" forKey:@"time"];
        [param addParams:@"0" forKey:@"hdly"];
        [param addParams:@"0" forKey:@"twist"];
        param.requestType = POST;
        [DataRequest requestWithParam:param successed:^(NSDictionary *dict, NSError *error, int result, NSString *msg) {
            
            [self.view progressDiss];
            if (result == 1) {
                
                self.kLineBottomView.addAIBtn.tag = 1;
                [self.kLineBottomView.addAIBtn setImage:[UIImage imageNamed:@"icon_delete"] forState:UIControlStateNormal];
                PXNotifiPost(StockAIOperateKey, nil);
            } else {
                [QMUITips showWithText:msg];
            }
        }];
    }
}

#pragma mark ---- 懒加载 ----
- (NSMutableArray *)historyArray {
    if (_historyArray == nil) {
        _historyArray = [NSMutableArray array];
    }
    return _historyArray;
}

- (NSMutableArray *)stockTimeArray {
    if (_stockTimeArray == nil) {
        _stockTimeArray = [NSMutableArray array];
    }
    return _stockTimeArray;
}

@end
