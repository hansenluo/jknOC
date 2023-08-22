//
//  QuotationListVC.m
//  JiaKeNengOC
//
//  Created by jkn-mac on 2023/6/14.
//

#import "QuotationListVC.h"
#import <MJRefresh/MJRefresh.h>
#import "QuotationListCell.h"
#import "KLineMainVC.h"
#import "SearchStockVC.h"

@interface QuotationListVC () <UITableViewDelegate, UITableViewDataSource, QuotationListCellDelegate, UITextFieldDelegate>

@property (nonatomic, weak) IBOutlet UITextField *searchTextField;
@property (nonatomic, weak) IBOutlet UIView *searchView;
@property (nonatomic, weak) IBOutlet UIView *headerView;
@property (nonatomic, weak) IBOutlet UITableView *tableView;
@property (nonatomic, weak) IBOutlet UIButton *button01;
@property (nonatomic, weak) IBOutlet UIButton *button02;
@property (nonatomic, weak) IBOutlet UIButton *button03;
@property (nonatomic, weak) IBOutlet UIButton *button04;

@property (nonatomic, strong) QMUIButton *btn01;
@property (nonatomic, strong) QMUIButton *btn02;
@property (nonatomic, strong) QMUIButton *btn03;
@property (nonatomic, strong) QuotationListCell *quotationListCell;
@property (nonatomic, strong) UIScrollView *topScrollView;
@property (nonatomic, assign) float cellLastX; //最后的cell的移动距离

@property (nonatomic, strong) NSMutableArray *dataSourceArray;
@property (nonatomic, assign) int page;
@property (nonatomic, assign) int totalCount;
@property (nonatomic, assign) NSInteger currentPaggeFirstCellIndex;
@property (nonatomic, strong) NSString *currentPaggeFirstCellStockCode;

@property (nonatomic, strong) NSString *sortName;
@property (nonatomic, strong) NSString *sortOrder;

@property (nonatomic, strong) NSTimer *pollTimer;

@end

@implementation QuotationListVC

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
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
    self.button01.selected = YES;
    self.currentPaggeFirstCellIndex = 0;
    //self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 40, 0);
    
    [self.searchView acs_radiusWithRadius:18 corner:UIRectCornerAllCorners];
    self.searchTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"纳斯达克指数" attributes:@{NSForegroundColorAttributeName:[UIColor colorWithHexString:@"#999999"]}];
    [self settingHeaderView];
    
    //默认参数
    self.sortName = @"code";
    self.sortOrder = @"";
    
    // 注册一个
    extern NSString *tapCellScrollNotification;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(scrollMove:) name:quotationListScrollNotification object:nil];
    
//    PXNotifiAdd(refreshPageData, StockPoolOperateKey, nil);
//    PXNotifiAdd(refreshPageData, StockAIOperateKey, nil);
    
    self.pollTimer = [NSTimer scheduledTimerWithTimeInterval:timeInterval target:self selector:@selector(autoUpdateData) userInfo:nil repeats:YES];
    
    //获取股票行情列表
    [self configTableView];
}

#pragma mark ---- 通知相关 ----
- (void)scrollMove:(NSNotification*)notification{
    NSDictionary *noticeInfo = notification.userInfo;
    NSObject *obj = notification.object;
    float x = [noticeInfo[@"cellOffX"] floatValue];
    self.cellLastX = x;
    CGPoint offSet = self.topScrollView.contentOffset;
    offSet.x = x;
    self.topScrollView.contentOffset = offSet;
    obj = nil;
}

//- (void)refreshPageData {
//    [self refreshingData:YES];
//}

#pragma mark ---- tableView加载刷新 -----
- (void)configTableView
{
    @weakify(self)
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        //下拉加载会自动调用这个block
        @strongify(self)
        [self refreshingData:YES];
    }];
    
//    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
//        //上拉加载会自动调用这个block
//        @strongify(self)
//        [self refreshingData:NO];
//    }];
    
    // 开始刷新加载新数据
    [self.tableView.mj_header beginRefreshing];
    //[self refreshingData:YES];
}

#pragma mark ---- 网络请求 ----
- (void)refreshingData:(BOOL)isHeaderRefresh
{
    @weakify(self)
    
    if (isHeaderRefresh) {
        self.page = 0;
    }else{
        self.page += pageSize;
    }
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        TMHttpParams *param = [[TMHttpParams alloc] init];
        [param setUrl:API_getStockList_URL];
        [param addParams:[NSString stringWithFormat:@"%d",pageSize] forKey:@"size"];
        [param addParams:[NSString stringWithFormat:@"%d",self.page] forKey:@"offset"];
        [param addParams:self.sortName forKey:@"sort_name"];
        [param addParams:self.sortOrder forKey:@"sort_order"];
        param.requestType = POST;
        
        [DataRequest requestWithParam:param successed:^(NSDictionary *dict, NSError *error, int result, NSString *msg) {
            
            @strongify(self)
            if (result == 1) {
                
                if (isHeaderRefresh) {
                    [self.dataSourceArray removeAllObjects];
                }
                
                NSArray *arr = dict[@"data"][@"stocks"];
                for (int i = 0; i < arr.count; i++) {
                    NSArray *array = arr[i];
                    QuotationListModel *model = [[QuotationListModel alloc] init];
                    model.close = [array[1] doubleValue];
                    model.high = [array[2] doubleValue];
                    model.low = [array[3] doubleValue];
                    model.open = [array[4] doubleValue];
                    model.lasetDayclose = [array[5] doubleValue];
                    model.vol = [array[6] doubleValue];
                    model.amount = [array[7] doubleValue];
                    model.totalValue = [array[8] doubleValue];
                    model.circulateValue = [array[9] doubleValue];
                    model.totalStock = [array[10] doubleValue];
                    model.circulateStock = [array[11] doubleValue];
                    model.turnoverRate = [array[12] doubleValue];
                    model.pegRatio = [array[13] doubleValue];
                    model.pbRatio = [array[14] doubleValue];
                    model.stockCode = array[15];
                    model.stockName = array[16];
                    model.stockChinaName = array[17];
                    model.plateName = array[18];
                    model.addPond = [array[19] integerValue];
                    model.addAI = [array[20] integerValue];
                    
                    [self.dataSourceArray addObject:model];
                }
                
                self.totalCount = [dict[@"data"][@"totalcount"] intValue];
                if (isHeaderRefresh) {
                    if (self.page >= [dict[@"data"][@"totalcount"] intValue]) {
                        [self.tableView.mj_footer setState:MJRefreshStateNoMoreData];
                    }else{
                        [self.tableView.mj_footer setState:MJRefreshStateIdle];
                    }
                    [self.tableView.mj_header endRefreshing];
                } else {
                    if (self.page >= [dict[@"data"][@"totalcount"] intValue]) {
                        [self.tableView.mj_footer setState:MJRefreshStateNoMoreData];
                    }else{
                        [self.tableView.mj_footer endRefreshing];
                    }
                }
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.tableView reloadData];
                });
            } else {
                [QMUITips showWithText:msg];
                
                if (isHeaderRefresh) {
                    [self.tableView.mj_header endRefreshing];
                } else {
                    [self.tableView.mj_footer endRefreshing];
                }
            }
        }];
    });
}

- (void)autoUpdateData {
    
    if (self.dataSourceArray.count == 0) {return;}
    
    //NSLog(@"当前页面第一个code = %@",self.currentPaggeFirstCellStockCode);
    
    TMHttpParams *param = [[TMHttpParams alloc] init];
    [param setUrl:API_getStockList_URL];
    [param addParams:[NSString stringWithFormat:@"%d",15] forKey:@"size"];
    [param addParams:[NSString stringWithFormat:@"%ld",self.currentPaggeFirstCellIndex] forKey:@"offset"];
    [param addParams:self.sortName forKey:@"sort_name"];
    [param addParams:self.sortOrder forKey:@"sort_order"];
    param.requestType = POST;
    
    [DataRequest requestWithParam:param successed:^(NSDictionary *dict, NSError *error, int result, NSString *msg) {
        
        if (result == 1) {
            
            NSArray *arr = dict[@"data"][@"stocks"];
            for (int i = 0; i < arr.count; i++) {
                NSArray *array = arr[i];
                QuotationListModel *model = [[QuotationListModel alloc] init];
                model.close = [array[1] doubleValue];
                model.high = [array[2] doubleValue];
                model.low = [array[3] doubleValue];
                model.open = [array[4] doubleValue];
                model.lasetDayclose = [array[5] doubleValue];
                model.vol = [array[6] doubleValue];
                model.amount = [array[7] doubleValue];
                model.totalValue = [array[8] doubleValue];
                model.circulateValue = [array[9] doubleValue];
                model.totalStock = [array[10] doubleValue];
                model.circulateStock = [array[11] doubleValue];
                model.turnoverRate = [array[12] doubleValue];
                model.pegRatio = [array[13] doubleValue];
                model.pbRatio = [array[14] doubleValue];
                model.stockCode = array[15];
                model.stockName = array[16];
                model.stockChinaName = array[17];
                model.plateName = array[18];
                model.addPond = [array[19] integerValue];
                model.addAI = [array[20] integerValue];
                
                //NSLog(@"股票名字 = %@",model.stockChinaName);
                if ((self.currentPaggeFirstCellIndex+i) >= self.dataSourceArray.count) {
                    break;
                }
                [self.dataSourceArray replaceObjectAtIndex:(self.currentPaggeFirstCellIndex+i) withObject:model];
            }
            
            [self.tableView reloadData];
        }
    }];
}

#pragma mark ---- 私有方法 ----
- (void)settingHeaderView {
    QMUILabel *titleLbl01 = [QMUILabel new];
    titleLbl01.text = @"名称代码";
    titleLbl01.textColor = [UIColor colorWithHexString:@"#7C818A"];
    titleLbl01.font = [UIFont systemFontOfSize:16];
    titleLbl01.textAlignment = NSTextAlignmentCenter;
    [self.headerView addSubview:titleLbl01];
    [titleLbl01 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.headerView).offset(5);
        make.width.equalTo(@80);
        make.height.equalTo(@25);
        make.centerY.equalTo(self.headerView);
    }];
    
    self.topScrollView = [[UIScrollView alloc] init];
    self.topScrollView.showsVerticalScrollIndicator = NO;
    self.topScrollView.showsHorizontalScrollIndicator = NO;
    [self.headerView addSubview:self.topScrollView];
    [self.topScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.headerView).offset(tagLabelWidth);
        make.right.equalTo(self.headerView);
        make.top.bottom.equalTo(self.headerView);
    }];

    self.btn01 = [QMUIButton buttonWithType:UIButtonTypeCustom];
    [self.btn01 setTitle:@"现价" forState:UIControlStateNormal];
    [self.btn01 setTitleColor:[UIColor colorWithHexString:@"#888888"] forState:UIControlStateNormal];
    self.btn01.titleLabel.font = MFont(16);
    [self.btn01 setImage:[UIImage imageNamed:@"icon_normal_gray_arrow"] forState:UIControlStateNormal];
    self.btn01.imagePosition = QMUIButtonImagePositionRight;
    self.btn01.spacingBetweenImageAndTitle = 2;
    [self.btn01 addTarget:self action:@selector(btn01Click:) forControlEvents:UIControlEventTouchUpInside];
    [self.topScrollView addSubview:self.btn01];
    [self.btn01 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.topScrollView).offset(15);
        make.width.equalTo(@60);
        make.height.equalTo(@25);
        make.centerY.equalTo(self.topScrollView);
    }];
    
    self.btn02 = [QMUIButton buttonWithType:UIButtonTypeCustom];
    [self.btn02 setTitle:@"涨跌幅" forState:UIControlStateNormal];
    [self.btn02 setTitleColor:[UIColor colorWithHexString:@"#888888"] forState:UIControlStateNormal];
    self.btn02.titleLabel.font = MFont(16);
    [self.btn02 setImage:[UIImage imageNamed:@"icon_normal_gray_arrow"] forState:UIControlStateNormal];
    self.btn02.imagePosition = QMUIButtonImagePositionRight;
    self.btn02.spacingBetweenImageAndTitle = 2;
    [self.btn02 addTarget:self action:@selector(btn02Click:) forControlEvents:UIControlEventTouchUpInside];
    [self.topScrollView addSubview:self.btn02];
    [self.btn02 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.topScrollView).offset(95);
        make.width.equalTo(@75);
        make.height.equalTo(@25);
        make.centerY.equalTo(self.topScrollView);
    }];
    
    self.btn03 = [QMUIButton buttonWithType:UIButtonTypeCustom];
    [self.btn03 setTitle:@"成交额" forState:UIControlStateNormal];
    [self.btn03 setTitleColor:[UIColor colorWithHexString:@"#888888"] forState:UIControlStateNormal];
    self.btn03.titleLabel.font = MFont(16);
    [self.btn03 setImage:[UIImage imageNamed:@"icon_normal_gray_arrow"] forState:UIControlStateNormal];
    self.btn03.imagePosition = QMUIButtonImagePositionRight;
    self.btn03.spacingBetweenImageAndTitle = 2;
    [self.btn03 addTarget:self action:@selector(btn03Click:) forControlEvents:UIControlEventTouchUpInside];
    [self.topScrollView addSubview:self.btn03];
    [self.btn03 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.topScrollView).offset(195);
        make.width.equalTo(@85);
        make.height.equalTo(@25);
        make.centerY.equalTo(self.topScrollView);
    }];
    
    QMUILabel *titleLbl02 = [QMUILabel new];
    titleLbl02.text = @"+股票金池";
    titleLbl02.textColor = [UIColor colorWithHexString:@"#7C818A"];
    titleLbl02.font = [UIFont systemFontOfSize:16];
    titleLbl02.textAlignment = NSTextAlignmentCenter;
    [self.topScrollView addSubview:titleLbl02];
    [titleLbl02 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.topScrollView).offset(290);
        make.width.equalTo(@80);
        make.height.equalTo(@25);
        make.centerY.equalTo(self.topScrollView);
    }];
    
    QMUILabel *titleLbl03 = [QMUILabel new];
    titleLbl03.text = @"+缠论报警";
    titleLbl03.textColor = [UIColor colorWithHexString:@"#7C818A"];
    titleLbl03.font = [UIFont systemFontOfSize:16];
    titleLbl03.textAlignment = NSTextAlignmentCenter;
    [self.topScrollView addSubview:titleLbl03];
    [titleLbl03 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.topScrollView).offset(380);
        make.width.equalTo(@80);
        make.height.equalTo(@25);
        make.centerY.equalTo(self.topScrollView);
    }];
    
    self.topScrollView.contentSize = CGSizeMake(470, 0);
    self.topScrollView.delegate = self;
}

#pragma mark ---- UITableViewDataSource ----
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSourceArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 64;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellID = @"cellID";
    
    _quotationListCell = [tableView dequeueReusableCellWithIdentifier:cellID];
    
    if (!_quotationListCell) {
        _quotationListCell = [[QuotationListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    
    _quotationListCell.tableView = self.tableView;
    _quotationListCell.indexPath = indexPath;
    _quotationListCell.delegate = self;
    _quotationListCell.model = self.dataSourceArray[indexPath.row];
    
    __weak typeof(self) weakSelf = self;
    _quotationListCell.tapCellClick = ^(NSIndexPath *indexPath) {
        [weakSelf tableView:tableView didSelectRowAtIndexPath:indexPath];
    };
    return _quotationListCell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
 
    NSInteger row = [indexPath row];
    /*
     * _NumberOfUserRequestData 是当前你请求成功了多少页的数据。
     * _NumberOfOption 是数据的总数。
     * 该if语句判断是否还有可以刷新的数据
    */
    if (self.dataSourceArray.count < self.totalCount) {
 
        if (row == (self.dataSourceArray.count-5)) {
            /*
             * (numberOfCell-5) 如果当用户滑动到倒数第五个。
             * [_request isFinished] _request设置为全局变量，而且当前请求已经结束的时候
             * 该句判断当用户滑动到第5个cell，并且当上次数据加载完成、
                */
            [self refreshingData:NO]; //获取更多数据方法、
        }
    }
}

#pragma mark ---- UITableViewDelegate ----
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    QuotationListModel *model = self.dataSourceArray[indexPath.row];
    KLineMainVC *vc = [[KLineMainVC alloc] init];
    vc.stockCode = model.stockCode;
    vc.mainTitle = model.stockCode;
    vc.subTitle = model.stockName;
    vc.dateSelectState = DateSelectStateDay;
    PushController(vc);
}

#pragma mark ---- UIScrollViewDelegate ----
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if ([scrollView isEqual:self.topScrollView]) {
        CGPoint offSet = _quotationListCell.rightScrollView.contentOffset;
        offSet.x = scrollView.contentOffset.x;
        _quotationListCell.rightScrollView.contentOffset = offSet;
    }
    
    if ([scrollView isEqual:self.tableView]) {
        // 发送通知
        [[NSNotificationCenter defaultCenter] postNotificationName:quotationListScrollNotification object:self userInfo:@{@"cellOffX":@(self.cellLastX)}];
        
        QuotationListCell *cell = [self.tableView visibleCells].firstObject;
        NSIndexPath *index = [self.tableView indexPathForCell:cell];
        self.currentPaggeFirstCellIndex = index.row;
        self.currentPaggeFirstCellStockCode = cell.model.stockCode;
        //NSLog(@"xxxxxx = %ld",self.currentPaggeFirstCellIndex);
    }
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    [self.pollTimer setFireDate:[NSDate distantFuture]];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    [self.pollTimer setFireDate:[NSDate date]];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    if(!decelerate){
        [self.pollTimer setFireDate:[NSDate date]];
    }
}

#pragma mark ---- QuotationListCellDelegate ----
- (void)addPondBtnAction:(NSIndexPath *)indexPath model:(QuotationListModel *)model {
    
    if (isNilString([[UserInfo Instance] getAccess_token])) {
        [QMUITips showWithText:@"请先登录"];
        return;
    }
    
    [self.view showProgress:@""];
    
    if (model.addPond == 0) {
        TMHttpParams *param = [[TMHttpParams alloc] init];
        [param setUrl:API_addPool_URL];
        [param addParams:model.stockCode forKey:@"code"];
        param.requestType = POST;
        [DataRequest requestWithParam:param successed:^(NSDictionary *dict, NSError *error, int result, NSString *msg) {
            
            [self.view progressDiss];
            if (result == 1) {
                
                model.addPond = 1;
                [self.tableView reloadData];
                
                PXNotifiPost(StockPoolOperateKey, nil);
            } else {
                [QMUITips showWithText:msg];
            }
        }];
    }else {
        TMHttpParams *param = [[TMHttpParams alloc] init];
        [param setUrl:API_removePool_URL];
        [param addParams:model.stockCode forKey:@"code"];
        param.requestType = POST;
        [DataRequest requestWithParam:param successed:^(NSDictionary *dict, NSError *error, int result, NSString *msg) {
            
            [self.view progressDiss];
            if (result == 1) {
                
                model.addPond = 0;
                [self.tableView reloadData];
                
                PXNotifiPost(StockPoolOperateKey, nil);
            } else {
                [QMUITips showWithText:msg];
            }
        }];
    }
}

- (void)addAIBtnAction:(NSIndexPath *)indexPath model:(QuotationListModel *)model {
    if (isNilString([[UserInfo Instance] getAccess_token])) {
        [QMUITips showWithText:@"请先登录"];
        return;
    }
    
    [self.view showProgress:@""];
    
    if (model.addAI == 0) {
        TMHttpParams *param = [[TMHttpParams alloc] init];
        [param setUrl:API_addTwist_URL];
        [param addParams:model.stockCode forKey:@"code"];
        [param addParams:@"1" forKey:@"time"];
        [param addParams:@"0" forKey:@"hdly"];
        [param addParams:@"0" forKey:@"twist"];
        param.requestType = POST;
        [DataRequest requestWithParam:param successed:^(NSDictionary *dict, NSError *error, int result, NSString *msg) {
            
            [self.view progressDiss];
            if (result == 1) {
                
                model.addAI = 1;
                [self.tableView reloadData];
                
                PXNotifiPost(StockAIOperateKey, nil);
            } else {
                [QMUITips showWithText:msg];
            }
        }];
    }else {
        TMHttpParams *param = [[TMHttpParams alloc] init];
        [param setUrl:API_removeByCodeTwist_URL];
        [param addParams:model.stockCode forKey:@"code"];
        param.requestType = POST;
        [DataRequest requestWithParam:param successed:^(NSDictionary *dict, NSError *error, int result, NSString *msg) {
            
            [self.view progressDiss];
            if (result == 1) {
                
                model.addAI = 0;
                [self.tableView reloadData];
                
                PXNotifiPost(StockAIOperateKey, nil);
            } else {
                [QMUITips showWithText:msg];
            }
        }];
    }
}

#pragma mark ---- UITextFieldDelegate ----
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    SearchStockVC *vc = [[SearchStockVC alloc] init];
    PushController(vc);
    
    return YES;
}

#pragma mark ---- 按钮点击 ----
- (IBAction)buttonClick:(id)sender {
    UIButton *button = (UIButton *)sender;
    if (button.tag == 0) {
        self.button01.selected = YES;
        self.button02.selected = NO;
        self.button03.selected = NO;
        self.button04.selected = NO;
    }else if (button.tag == 1) {
        self.button01.selected = NO;
        self.button02.selected = YES;
        self.button03.selected = NO;
        self.button04.selected = NO;
    }else if (button.tag == 2) {
        self.button01.selected = NO;
        self.button02.selected = NO;
        self.button03.selected = YES;
        self.button04.selected = NO;
    }else {
        self.button01.selected = NO;
        self.button02.selected = NO;
        self.button03.selected = NO;
        self.button04.selected = YES;
    }
}

- (void)btn01Click:(id)sender {
    self.btn01.selected = !self.btn01.selected;
    
    self.sortName = @"price";
    if (self.btn01.selected) {
        self.sortOrder = @"desc";
        [self.btn01 setImage:UIImageMake(@"icon_down_green_arrow") forState:UIControlStateNormal];
    }else {
        self.sortOrder = @"asc";
        [self.btn01 setImage:UIImageMake(@"icon_up_green_arrow") forState:UIControlStateNormal];
    }
    
    [self.btn02 setImage:UIImageMake(@"icon_normal_gray_arrow") forState:UIControlStateNormal];
    [self.btn03 setImage:UIImageMake(@"icon_normal_gray_arrow") forState:UIControlStateNormal];
    
    [self refreshingData:YES];
}

- (void)btn02Click:(id)sender {
    self.btn02.selected = !self.btn02.selected;
    
    self.sortName = @"pct_chg";
    if (self.btn02.selected) {
        self.sortOrder = @"desc";
        [self.btn02 setImage:UIImageMake(@"icon_down_green_arrow") forState:UIControlStateNormal];
    }else {
        self.sortOrder = @"asc";
        [self.btn02 setImage:UIImageMake(@"icon_up_green_arrow") forState:UIControlStateNormal];
    }
    
    [self.btn01 setImage:UIImageMake(@"icon_normal_gray_arrow") forState:UIControlStateNormal];
    [self.btn03 setImage:UIImageMake(@"icon_normal_gray_arrow") forState:UIControlStateNormal];
    
    [self refreshingData:YES];
}

- (void)btn03Click:(id)sender {
    self.btn03.selected = !self.btn03.selected;
    
    self.sortName = @"amount";
    if (self.btn03.selected) {
        self.sortOrder = @"desc";
        [self.btn03 setImage:UIImageMake(@"icon_down_green_arrow") forState:UIControlStateNormal];
    }else {
        self.sortOrder = @"asc";
        [self.btn03 setImage:UIImageMake(@"icon_up_green_arrow") forState:UIControlStateNormal];
    }
    
    [self.btn01 setImage:UIImageMake(@"icon_normal_gray_arrow") forState:UIControlStateNormal];
    [self.btn02 setImage:UIImageMake(@"icon_normal_gray_arrow") forState:UIControlStateNormal];
    
    [self refreshingData:YES];
}

#pragma mark ---- 懒加载 ----
- (NSMutableArray *)dataSourceArray {
    if (!_dataSourceArray) {
        _dataSourceArray = [[NSMutableArray alloc] init];
    }
    return _dataSourceArray;
}

@end
