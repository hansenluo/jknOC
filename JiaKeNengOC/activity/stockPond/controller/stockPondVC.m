//
//  stockPondVC.m
//  JiaKeNengOC
//
//  Created by jkn-mac on 2023/6/14.
//

#import "stockPondVC.h"
#import <MJRefresh/MJRefresh.h>
#import <DZNEmptyDataSet/UIScrollView+EmptyDataSet.h>
#import "StockPondCell.h"
#import "SearchStockVC.h"
#import "KLineMainVC.h"

@interface stockPondVC () <UITableViewDelegate, UITableViewDataSource, StockPondCellDelegate, DZNEmptyDataSetSource, DZNEmptyDataSetDelegate, UITextFieldDelegate>

@property (nonatomic, weak) IBOutlet UITextField *searchTextField;
@property (nonatomic, weak) IBOutlet UIView *searchView;
@property (nonatomic, weak) IBOutlet UIView *headerView;
@property (nonatomic, weak) IBOutlet UITableView *tableView;

@property (nonatomic, strong) QMUIButton *btn01;
@property (nonatomic, strong) QMUIButton *btn02;
@property (nonatomic, strong) QMUIButton *btn03;
@property (nonatomic, strong) QMUIButton *checkAllBtn;
@property (nonatomic, strong) StockPondCell *stockPondCell;
@property (nonatomic, strong) UIScrollView *topScrollView;
@property (nonatomic, assign) float cellLastX; //最后的cell的移动距离

@property (nonatomic, strong) NSMutableArray *markArray;
@property (nonatomic, strong) NSMutableArray *checkArray; //存储当前选中的股票代码
@property (nonatomic, strong) NSMutableArray *indexArray;
@property (nonatomic, strong) NSMutableArray *dataSourceArray;

@property (nonatomic, assign) BOOL isTagBtn01Click;
@property (nonatomic, assign) BOOL isTagBtn02Click;
@property (nonatomic, assign) BOOL isTagBtn03Click;
@property (nonatomic, assign) BOOL isFristLoding;

@property (nonatomic, strong) NSTimer *pollTimer;

@end

@implementation stockPondVC

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
    
    [self.searchView acs_radiusWithRadius:18 corner:UIRectCornerAllCorners];
    self.searchTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"纳斯达克指数" attributes:@{NSForegroundColorAttributeName:[UIColor colorWithHexString:@"#999999"]}];
    self.tableView.emptyDataSetSource = self;
    self.tableView.emptyDataSetDelegate = self;
    [self settingHeaderView];
    
    // 注册一个
    extern NSString *tapCellScrollNotification;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(scrollMove:) name:stockPondScrollNotification object:nil];
    
    PXNotifiAdd(refreshPageData, LOGINSTATUSKEY, nil);
    PXNotifiAdd(refreshPageData, StockPoolOperateKey, nil);
    PXNotifiAdd(refreshPageData, StockAIOperateKey, nil);
    
    self.pollTimer = [NSTimer scheduledTimerWithTimeInterval:timeInterval target:self selector:@selector(autoUpdateData) userInfo:nil repeats:YES];
    
    //获取股票金池列表
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

- (void)refreshPageData {
    [self refreshingData:YES];
}

- (void)autoUpdateData {
    TMHttpParams *param = [[TMHttpParams alloc] init];
    [param setUrl:API_getPoolStocks_URL];
    param.requestType = POST;
    
    [DataRequest requestWithParam:param successed:^(NSDictionary *dict, NSError *error, int result, NSString *msg) {
        
        if (result == 1) {
            
            if (self.dataSourceArray.count > 0) {
                [self.dataSourceArray removeAllObjects];
            }
            
            NSArray *arr = dict[@"data"];
            for (int i = 0; i < arr.count; i++) {
                NSArray *array = arr[i];
                StockPondModel *model = [[StockPondModel alloc] init];
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
                model.aito = model.close - model.lasetDayclose;
                
                for (int j = 0; j < self.checkArray.count; j++) {
                    if ([model.stockCode isEqualToString:self.checkArray[j]]) {
                        model.selectStatus = YES;
                        break;
                    }
                }
                
                [self.dataSourceArray addObject:model];
            }
            
            if (self.isTagBtn01Click) {
                if (self.btn01.selected) {
                    NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"close" ascending:NO];//ascending后面YES表示升序，NO表示降序
                    self.dataSourceArray = [[self.dataSourceArray sortedArrayUsingDescriptors:@[sortDescriptor]] mutableCopy];
                }else {
                    NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"close" ascending:YES];//ascending后面YES表示升序，NO表示降序
                    self.dataSourceArray = [[self.dataSourceArray sortedArrayUsingDescriptors:@[sortDescriptor]] mutableCopy];
                }
            }
            
            if (self.isTagBtn02Click) {
                if (self.btn02.selected) {
                    NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"aito" ascending:NO];//ascending后面YES表示升序，NO表示降序
                    self.dataSourceArray = [[self.dataSourceArray sortedArrayUsingDescriptors:@[sortDescriptor]] mutableCopy];
                }else {
                    NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"aito" ascending:YES];//ascending后面YES表示升序，NO表示降序
                    self.dataSourceArray = [[self.dataSourceArray sortedArrayUsingDescriptors:@[sortDescriptor]] mutableCopy];
                }
            }
            
            if (self.isTagBtn03Click) {
                if (self.btn03.selected) {
                    NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"amount" ascending:NO];//ascending后面YES表示升序，NO表示降序
                    self.dataSourceArray = [[self.dataSourceArray sortedArrayUsingDescriptors:@[sortDescriptor]] mutableCopy];
                }else {
                    NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"amount" ascending:YES];//ascending后面YES表示升序，NO表示降序
                    self.dataSourceArray = [[self.dataSourceArray sortedArrayUsingDescriptors:@[sortDescriptor]] mutableCopy];
                }
            }
            
            [self.tableView reloadData];
        }
    }];
}

#pragma mark ---- tableView加载刷新 -----
- (void)configTableView
{
    @weakify(self)
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        //下拉加载会自动调用这个block
        @strongify(self)
        [self refreshingData:YES];
    }];
    
    // 开始刷新加载新数据
    [self.tableView.mj_header beginRefreshing];
}

#pragma mark ---- 网络请求 ----
- (void)refreshingData:(BOOL)isHeaderRefresh
{
    @weakify(self)
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        TMHttpParams *param = [[TMHttpParams alloc] init];
        [param setUrl:API_getPoolStocks_URL];
        param.requestType = POST;
        
        [DataRequest requestWithParam:param successed:^(NSDictionary *dict, NSError *error, int result, NSString *msg) {
            
            @strongify(self)
            self.isFristLoding = YES;
            if (result == 1) {
                
                if (isHeaderRefresh) {
                    self.checkAllBtn.selected = NO;
                    [self.dataSourceArray removeAllObjects];
                    [self.checkArray removeAllObjects];
                    [self.indexArray removeAllObjects];
                    [self.markArray removeAllObjects];
                }
                
                NSArray *arr = dict[@"data"];
                for (int i = 0; i < arr.count; i++) {
                    NSArray *array = arr[i];
                    StockPondModel *model = [[StockPondModel alloc] init];
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
                    model.aito = model.close - model.lasetDayclose;
                    
                    [self.dataSourceArray addObject:model];
                    
                    NSMutableDictionary *temDict = [NSMutableDictionary dictionaryWithObject:@0 forKey:@"isChecked"];
                    [self.markArray addObject:temDict];
                }
                
                if (self.isTagBtn01Click) {
                    if (self.btn01.selected) {
                        NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"close" ascending:NO];//ascending后面YES表示升序，NO表示降序
                        self.dataSourceArray = [[self.dataSourceArray sortedArrayUsingDescriptors:@[sortDescriptor]] mutableCopy];
                    }else {
                        NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"close" ascending:YES];//ascending后面YES表示升序，NO表示降序
                        self.dataSourceArray = [[self.dataSourceArray sortedArrayUsingDescriptors:@[sortDescriptor]] mutableCopy];
                    }
                }
                
                if (self.isTagBtn02Click) {
                    if (self.btn02.selected) {
                        NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"aito" ascending:NO];//ascending后面YES表示升序，NO表示降序
                        self.dataSourceArray = [[self.dataSourceArray sortedArrayUsingDescriptors:@[sortDescriptor]] mutableCopy];
                    }else {
                        NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"aito" ascending:YES];//ascending后面YES表示升序，NO表示降序
                        self.dataSourceArray = [[self.dataSourceArray sortedArrayUsingDescriptors:@[sortDescriptor]] mutableCopy];
                    }
                }
                
                if (self.isTagBtn03Click) {
                    if (self.btn03.selected) {
                        NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"amount" ascending:NO];//ascending后面YES表示升序，NO表示降序
                        self.dataSourceArray = [[self.dataSourceArray sortedArrayUsingDescriptors:@[sortDescriptor]] mutableCopy];
                    }else {
                        NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"amount" ascending:YES];//ascending后面YES表示升序，NO表示降序
                        self.dataSourceArray = [[self.dataSourceArray sortedArrayUsingDescriptors:@[sortDescriptor]] mutableCopy];
                    }
                }
                
                [self.tableView.mj_footer setState:MJRefreshStateNoMoreData];
                [self.tableView.mj_header endRefreshing];
                
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
    titleLbl02.text = @"+缠论报警";
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
    
    QMUIButton *batchCancelBtn = [QMUIButton buttonWithType:UIButtonTypeCustom];
    [batchCancelBtn setTitle:@"批量取消" forState:UIControlStateNormal];
    [batchCancelBtn setTitleColor:ChartColors_dnColor forState:UIControlStateNormal];
    batchCancelBtn.titleLabel.font = MFont(16);
    [batchCancelBtn border:1 borderColor:ChartColors_dnColor];
    [batchCancelBtn addTarget:self action:@selector(batchCancelBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.topScrollView addSubview:batchCancelBtn];
    [batchCancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.topScrollView).offset(380);
        make.width.equalTo(@80);
        make.height.equalTo(@25);
        make.centerY.equalTo(self.topScrollView);
    }];
    
    self.checkAllBtn = [QMUIButton buttonWithType:UIButtonTypeCustom];
    [self.checkAllBtn setImage:[UIImage imageNamed:@"z_btn_select_n"] forState:UIControlStateNormal];
    [self.checkAllBtn setImage:[UIImage imageNamed:@"z_btn_select_s"] forState:UIControlStateSelected];
    [self.checkAllBtn addTarget:self action:@selector(checkAllBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.topScrollView addSubview:self.checkAllBtn];
    [self.checkAllBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.topScrollView).offset(470);
        make.width.height.equalTo(@22);
        make.centerY.equalTo(self.topScrollView);
    }];
    
    self.topScrollView.contentSize = CGSizeMake(510, 0);
    self.topScrollView.delegate = self;
}

#pragma mark ---- DZNEmptyDataSetSource ----
//- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView {
//    if (!self.isFristLoding) { return nil; }
//
//    return [UIImage imageNamed:@"search_null"];
//}

- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView {
    if (!self.isFristLoding) { return nil; }
    
    NSString *title = @"这里什么都没有哦~";
    NSDictionary *attributes = @{
        NSFontAttributeName:[UIFont systemFontOfSize:16],
        NSForegroundColorAttributeName:GrayColor
    };
    return [[NSAttributedString alloc] initWithString:title attributes:attributes];
}

- (CGFloat)verticalOffsetForEmptyDataSet:(UIScrollView *)scrollView {
    return -Height_NavBar;
}

- (BOOL)emptyDataSetShouldAllowScroll:(UIScrollView *)scrollView {
    return YES;
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
    
    _stockPondCell = [tableView dequeueReusableCellWithIdentifier:cellID];
    
    if (!_stockPondCell) {
        _stockPondCell = [[StockPondCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    
    _stockPondCell.tableView = self.tableView;
    _stockPondCell.indexPath = indexPath;
    _stockPondCell.delegate = self;
    _stockPondCell.model = self.dataSourceArray[indexPath.row];
    
//    NSDictionary *resultDict = self.markArray[indexPath.row];
//    _stockPondCell.isChecked = [resultDict[@"isChecked"] boolValue];
    
    if (indexPath.row == self.dataSourceArray.count - 1) {
        _stockPondCell.lineView.hidden = YES;
    }else {
        _stockPondCell.lineView.hidden = NO;
    }
    
    __weak typeof(self) weakSelf = self;
    _stockPondCell.tapCellClick = ^(NSIndexPath *indexPath) {
        [weakSelf tableView:tableView didSelectRowAtIndexPath:indexPath];
    };
    
    return _stockPondCell;
}

#pragma mark ---- UITableViewDelegate ----
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    StockPondCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    KLineMainVC *vc = [KLineMainVC new];
    vc.stockCode = cell.model.stockCode;
    vc.mainTitle = cell.model.stockCode;
    vc.subTitle = cell.model.stockName;
    vc.dateSelectState = DateSelectStateDay;
    PushController(vc);
}

#pragma mark ---- UIScrollViewDelegate ----
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if ([scrollView isEqual:self.topScrollView]) {
        CGPoint offSet = _stockPondCell.rightScrollView.contentOffset;
        offSet.x = scrollView.contentOffset.x;
        _stockPondCell.rightScrollView.contentOffset = offSet;
    }
    if ([scrollView isEqual:self.tableView]) {
        // 发送通知
        [[NSNotificationCenter defaultCenter] postNotificationName:stockPondScrollNotification object:self userInfo:@{@"cellOffX":@(self.cellLastX)}];
    }
}

#pragma mark ---- StockPondCellDelegate ----
- (void)addAIBtnAction:(NSIndexPath *)indexPath model:(StockPondModel *)model {
    if (model.addAI == 0) {
        [self.view showProgress:@""];
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
        [self.view showProgress:@""];
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

- (void)removePondBtnAction:(StockPondCell *)cell {
    [self.view showProgress:@""];
    TMHttpParams *param = [[TMHttpParams alloc] init];
    [param setUrl:API_removePool_URL];
    [param addParams:cell.model.stockCode forKey:@"code"];
    param.requestType = POST;
    [DataRequest requestWithParam:param successed:^(NSDictionary *dict, NSError *error, int result, NSString *msg) {
        
        [self.view progressDiss];
        if (result == 1) {
            
            NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
            [self.dataSourceArray removeObjectAtIndex:indexPath.row];
            [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
            
            PXNotifiPost(StockPoolOperateKey, nil);
        } else {
            [QMUITips showWithText:msg];
        }
    }];
}

- (void)selectBtnAction:(NSIndexPath *)indexPath model:(StockPondModel *)model{
    
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    //StockPondCell *cell = (StockPondCell *)[self.tableView cellForRowAtIndexPath:indexPath];
    NSMutableDictionary *checkedResult = self.markArray[indexPath.row];
    //isChecked为NO则表明要把这行置为选中状态
    if ([checkedResult[@"isChecked"] boolValue] == NO) {
        [checkedResult setValue:@1 forKey:@"isChecked"];
        model.selectStatus = YES;
        [self.checkArray addObject:model.stockCode];
        [self.indexArray addObject:[NSString stringWithFormat:@"%ld",indexPath.row]];
    } else{
        [checkedResult setValue:@0 forKey:@"isChecked"];
        model.selectStatus = NO;
        [self.checkArray removeObject:model.stockCode];
        [self.indexArray removeObject:[NSString stringWithFormat:@"%ld",indexPath.row]];
    }
    [self.tableView reloadData];
    
    //刷新指定的行(会有bug，所以先全局刷新)
//    NSIndexPath *indexPath_Row = [NSIndexPath indexPathForRow:indexPath.row inSection:0];
//    [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath_Row,nil] withRowAnimation:UITableViewRowAnimationNone];
    
    if (self.checkArray.count == self.dataSourceArray.count) {
        self.checkAllBtn.selected = YES;
    }else {
        self.checkAllBtn.selected = NO;
    }
}

#pragma mark ---- UITextFieldDelegate ----
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    SearchStockVC *vc = [[SearchStockVC alloc] init];
    PushController(vc);
    return YES;
}

#pragma mark ---- 按钮点击 ----
- (void)btn01Click:(id)sender {
    self.isTagBtn01Click = YES;
    self.isTagBtn02Click = NO;
    self.isTagBtn03Click = NO;
    
    self.btn01.selected = !self.btn01.selected;
    self.btn02.selected = NO;
    self.btn03.selected = NO;
    
    if (self.btn01.selected) {
        [self.btn01 setImage:UIImageMake(@"icon_down_green_arrow") forState:UIControlStateNormal];
        
        NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"close" ascending:NO];//ascending后面YES表示升序，NO表示降序
        self.dataSourceArray = [[self.dataSourceArray sortedArrayUsingDescriptors:@[sortDescriptor]] mutableCopy];
        [self.tableView reloadData];
    }else {
        [self.btn01 setImage:UIImageMake(@"icon_up_green_arrow") forState:UIControlStateNormal];
        
        NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"close" ascending:YES];//ascending后面YES表示升序，NO表示降序
        self.dataSourceArray = [[self.dataSourceArray sortedArrayUsingDescriptors:@[sortDescriptor]] mutableCopy];
        [self.tableView reloadData];
    }
    
    [self.btn02 setImage:UIImageMake(@"icon_normal_gray_arrow") forState:UIControlStateNormal];
    [self.btn03 setImage:UIImageMake(@"icon_normal_gray_arrow") forState:UIControlStateNormal];
}

- (void)btn02Click:(id)sender {
    self.isTagBtn01Click = NO;
    self.isTagBtn02Click = YES;
    self.isTagBtn03Click = NO;
    
    self.btn02.selected = !self.btn02.selected;
    self.btn01.selected = NO;
    self.btn03.selected = NO;
    
    if (self.btn02.selected) {
        [self.btn02 setImage:UIImageMake(@"icon_down_green_arrow") forState:UIControlStateNormal];
        
        NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"aito" ascending:NO];//ascending后面YES表示升序，NO表示降序
        self.dataSourceArray = [[self.dataSourceArray sortedArrayUsingDescriptors:@[sortDescriptor]] mutableCopy];
        [self.tableView reloadData];
    }else {
        [self.btn02 setImage:UIImageMake(@"icon_up_green_arrow") forState:UIControlStateNormal];
        
        NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"aito" ascending:YES];//ascending后面YES表示升序，NO表示降序
        self.dataSourceArray = [[self.dataSourceArray sortedArrayUsingDescriptors:@[sortDescriptor]] mutableCopy];
        [self.tableView reloadData];
    }
    
    [self.btn01 setImage:UIImageMake(@"icon_normal_gray_arrow") forState:UIControlStateNormal];
    [self.btn03 setImage:UIImageMake(@"icon_normal_gray_arrow") forState:UIControlStateNormal];
}

- (void)btn03Click:(id)sender {
    self.isTagBtn01Click = NO;
    self.isTagBtn02Click = NO;
    self.isTagBtn03Click = YES;
    
    self.btn03.selected = !self.btn03.selected;
    self.btn01.selected = NO;
    self.btn02.selected = NO;
    
    if (self.btn03.selected) {
        [self.btn03 setImage:UIImageMake(@"icon_down_green_arrow") forState:UIControlStateNormal];
        
        NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"amount" ascending:NO];//ascending后面YES表示升序，NO表示降序
        self.dataSourceArray = [[self.dataSourceArray sortedArrayUsingDescriptors:@[sortDescriptor]] mutableCopy];
        [self.tableView reloadData];
    }else {
        [self.btn03 setImage:UIImageMake(@"icon_up_green_arrow") forState:UIControlStateNormal];
        
        NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"amount" ascending:YES];//ascending后面YES表示升序，NO表示降序
        self.dataSourceArray = [[self.dataSourceArray sortedArrayUsingDescriptors:@[sortDescriptor]] mutableCopy];
        [self.tableView reloadData];
    }
    
    [self.btn01 setImage:UIImageMake(@"icon_normal_gray_arrow") forState:UIControlStateNormal];
    [self.btn02 setImage:UIImageMake(@"icon_normal_gray_arrow") forState:UIControlStateNormal];
}

- (void)batchCancelBtnClick:(id)sender {
    if (self.checkArray.count == 0) {
        [QMUITips showWithText:@"请选择股票"];
        return;
    }
    
    NSMutableArray *dictArray = [NSMutableArray array];
    for (int i = 0; i < self.checkArray.count; i++) {
        [dictArray addObject:self.checkArray[i]];
    }
    
    [MsgAlertTool showAlert:@"" message:[NSString stringWithFormat:@"确定将所选的%ld支股票移出股票金池？",self.checkArray.count] completion:^(BOOL cancelled, NSInteger buttonIndex) {
        if(!cancelled){
            [self.view showProgress:@""];
            TMHttpParams *param = [[TMHttpParams alloc] init];
            [param setUrl:API_batchRemovePool_URL];
            [param addParams:[dictArray mj_JSONString] forKey:@"codes"];
            param.requestType = POST;
            
            [DataRequest requestWithParam:param successed:^(NSDictionary *dict, NSError *error, int result, NSString *msg) {
                [self.view progressDiss];
                if (result == 1) {
                    
                    NSMutableArray *modelArray = [NSMutableArray array];
                    for (int i = 0; i < self.indexArray.count; i++) {
                        StockPondModel *model = [self.dataSourceArray objectAtIndex:[self.indexArray[i] intValue]];
                        [modelArray addObject:model];
                    }
                    
                    for (int i = 0; i < modelArray.count; i++) {
                        StockPondModel *model = modelArray[i];
                        [self.dataSourceArray removeObject:model];
                    }
                    [self.tableView reloadData];
                    
                    PXNotifiPost(StockPoolOperateKey, nil);
                    
                } else {
                    [QMUITips showWithText:msg];
                }
            }];
        }
    } cancelButtonTitle:@"取消" otherButtonTitles:@"确定"];
}

- (void)checkAllBtnClick:(id)sender {
    
    self.checkAllBtn.selected = !self.checkAllBtn.selected;
    if (self.checkArray.count > 0) {
        [self.checkArray removeAllObjects];
    }
    
    for (int i = 0; i < self.dataSourceArray.count; i++) {
        StockPondModel *model = self.dataSourceArray[i];
        model.selectStatus = self.checkAllBtn.selected;
        
        if (self.checkAllBtn.selected) {
            NSMutableDictionary *checkedResult = self.markArray[i];
            [checkedResult setValue:@1 forKey:@"isChecked"];
            [self.checkArray addObject:model.stockCode];
        }else {
            NSMutableDictionary *checkedResult = self.markArray[i];
            [checkedResult setValue:@0 forKey:@"isChecked"];
        }
    }
    [self.tableView reloadData];
}

#pragma mark ---- 懒加载 ----
- (NSMutableArray *)dataSourceArray {
    if (!_dataSourceArray) {
        _dataSourceArray = [[NSMutableArray alloc] init];
    }
    return _dataSourceArray;
}

- (NSMutableArray *)markArray{
    
    if (!_markArray) {
        _markArray =[NSMutableArray array];
    }
    return _markArray;
}

- (NSMutableArray *)checkArray{
    
    if (!_checkArray) {
        _checkArray =[NSMutableArray array];
    }
    return _checkArray;
}

- (NSMutableArray *)indexArray{
    
    if (!_indexArray) {
        _indexArray =[NSMutableArray array];
    }
    return _indexArray;
}

@end
