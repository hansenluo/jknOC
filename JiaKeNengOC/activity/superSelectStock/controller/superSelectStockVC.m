//
//  superSelectStockVC.m
//  JiaKeNengOC
//
//  Created by jkn-mac on 2023/6/14.
//

#import "superSelectStockVC.h"
#import "StrategyStockListVC.h"
#import "IndustryPlateCell.h"
#import <MJRefresh/MJRefresh.h>
#import "SelectStrategyView.h"
#import "StockPondModel.h"

@interface superSelectStockVC () <UITableViewDelegate, UITableViewDataSource, SelectStrategyViewDelegate> {
    NSArray *_timePermissionsArray;
    NSArray *_twistPermissionsArray;
    NSArray *_hdlyPermissionsArray;
}

@property (nonatomic, weak) IBOutlet UIButton *plateBtn;
@property (nonatomic, weak) IBOutlet UIButton *pondBtn;
@property (nonatomic, weak) IBOutlet UITableView *mainTableView;
@property (nonatomic, weak) IBOutlet UIView *lineView01;
@property (nonatomic, weak) IBOutlet UIView *lineView02;
@property (nonatomic, weak) IBOutlet UIView *bottomView;

@property (nonatomic, assign) int currentTableIndex;

@property (nonatomic, strong) SelectStrategyView *selectStrategyView;
@property (nonatomic, strong) IBOutlet UIButton *checkAllBtn;
@property (nonatomic, strong) NSMutableArray *strategyStockArray;
@property (nonatomic, strong) NSMutableArray *dataSourceArray;
@property (nonatomic, strong) NSMutableArray *markArray;
@property (nonatomic, strong) NSMutableArray *checkArray;

@property (nonatomic, strong) NSString *token;

@end

@implementation superSelectStockVC

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    if (isNilString([[UserInfo Instance] getAccess_token])) {
        //获取用户的选股权限
        [self getPermissons];
    }else {
        if (![self.token isEqualToString:[[UserInfo Instance] getAccess_token]]) {
            self.token = [[UserInfo Instance] getAccess_token];
            //获取用户的选股权限
            [self getPermissons];
        }
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.navigationBarHidden = YES;
    self.view.backgroundColor = [UIColor colorWithHexString:@"#000000"];
    
    [self.bottomView addSubview:self.selectStrategyView];
    [self setDataForSelectStrategyView];
    
    self.plateBtn.selected = YES;
    self.currentTableIndex = 0;
    
    PXNotifiAdd(refreshPageData, StockPoolOperateKey, nil);
    PXNotifiAdd(refreshPageData, LOGINSTATUSKEY, nil);
    
    //获取数据
    [self configMainTableView];
}

- (void)refreshPageData {
    if (self.currentTableIndex == 1) {
        [self refreshingData:YES];
    }
}

- (void)getPermissons {
    TMHttpParams *param = [[TMHttpParams alloc] init];
    [param setUrl:API_getPermissons_URL];
    param.requestType = POST;
    [DataRequest requestWithParam:param successed:^(NSDictionary *dict, NSError *error, int result, NSString *msg) {
       
         if (result == 1) {
            self->_timePermissionsArray = dict[@"data"][@"time_permissions"];
            self->_twistPermissionsArray = dict[@"data"][@"twist_permissions"];
            self->_hdlyPermissionsArray = dict[@"data"][@"hdly_permissions"];
            
            [self setDataForSelectStrategyView];
        }else {
            [QMUITips showWithText:msg];
        }
    }];
}

#pragma mark ---- tableView加载刷新 -----
- (void)configMainTableView
{
    @weakify(self)
    self.mainTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        //下拉加载会自动调用这个block
        @strongify(self)
        [self refreshingData:YES];
    }];
    
    // 开始刷新加载新数据
    [self.mainTableView.mj_header beginRefreshing];
}

#pragma mark ---- 网络请求 ----
- (void)refreshingData:(BOOL)isHeaderRefresh
{
    @weakify(self)
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        TMHttpParams *param = [[TMHttpParams alloc] init];
        if (self.currentTableIndex == 0) {
            [param setUrl:API_getPlateData_URL];
        }else {
            [param setUrl:API_getPoolStocks_URL];
        }
        param.requestType = POST;
        
        [DataRequest requestWithParam:param successed:^(NSDictionary *dict, NSError *error, int result, NSString *msg) {
            
            @strongify(self)
            if (result == 1) {
                
                if (isHeaderRefresh) {
                    self.checkAllBtn.selected = NO;
                    [self.dataSourceArray removeAllObjects];
                    [self.checkArray removeAllObjects];
                    [self.markArray removeAllObjects];
                }
                
                NSArray *arr = dict[@"data"];
                for (int i = 0; i < arr.count; i++) {
                    NSArray *array = arr[i];
                    SelectStockModel *model = [[SelectStockModel alloc] init];
                    model.serialNumber = [NSString stringWithFormat:@"%d",i+1];
                    if (self.currentTableIndex == 0) {
                        model.code = array[0];
                        model.titleName = array[1];
                    }else {
                        model.code = array[15];
                        model.titleName = array[16];
                    }
                    
                    [self.dataSourceArray addObject:model];
                    
                    NSMutableDictionary *temDict = [NSMutableDictionary dictionaryWithObject:@0 forKey:@"isChecked"];
                    [self.markArray addObject:temDict];
                }
                
                [self.mainTableView.mj_footer setState:MJRefreshStateNoMoreData];
                [self.mainTableView.mj_header endRefreshing];
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.mainTableView reloadData];
                });
            } else {
                [QMUITips showWithText:msg];
                
                if (isHeaderRefresh) {
                    [self.mainTableView.mj_header endRefreshing];
                } else {
                    [self.mainTableView.mj_footer endRefreshing];
                }
            }
        }];
    });
}

#pragma mark ---- Table view data source ----
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSourceArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 40;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cell_id = @"cell_id";
    IndustryPlateCell *cell = (IndustryPlateCell *)[tableView dequeueReusableCellWithIdentifier:cell_id];
    if (cell == nil) {
        cell= (IndustryPlateCell *)[[[NSBundle mainBundle] loadNibNamed:@"IndustryPlateCell" owner:self options:nil] lastObject];
    }
    
    cell.model = self.dataSourceArray[indexPath.row];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    NSDictionary *resultDict = self.markArray[indexPath.row];
    cell.isChecked = [resultDict[@"isChecked"] boolValue];
    
//    if (indexPath.row == self.dataSourceArray.count - 1) {
//        cell.lineView.hidden = YES;
//    }else {
//        cell.lineView.hidden = NO;
//    }
    cell.lineView.hidden = YES;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    IndustryPlateCell *cell = (IndustryPlateCell *)[self.mainTableView cellForRowAtIndexPath:indexPath];
    NSMutableDictionary *checkedResult = self.markArray[indexPath.row];
    //isChecked为NO则表明要把这行置为选中状态
    if ([checkedResult[@"isChecked"] boolValue] == NO) {
        [checkedResult setValue:@1 forKey:@"isChecked"];
        cell.isChecked = YES;
        [self.checkArray addObject:cell.model.code];
    } else{
        [checkedResult setValue:@0 forKey:@"isChecked"];
        cell.isChecked = NO;
        [self.checkArray removeObject:cell.model.code];
    }
    //[self.tableView reloadData];
    
    //刷新指定的行(会有bug，所以先全局刷新)
    NSIndexPath *indexPath_Row = [NSIndexPath indexPathForRow:indexPath.row inSection:0];
    [self.mainTableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath_Row,nil] withRowAnimation:UITableViewRowAnimationNone];
    
    if (self.checkArray.count == self.dataSourceArray.count) {
        self.checkAllBtn.selected = YES;
    }else {
        self.checkAllBtn.selected = NO;
    }
}

#pragma mark ---- SelectStrategyViewDelegate ----
- (void)confirmBtnAction:(NSString *)timeId twistId:(NSString *)twistId hdlyId:(NSString *)hdlyId zoneId:(NSString *)zoneId startDate:(NSString *)startDate endDate:(NSString *)endDate {
    if (isNilString([[UserInfo Instance] getAccess_token])) {
        [QMUITips showWithText:@"请先登录"];
        return;
    }
    
    if (self.checkArray.count == 0) {
        [QMUITips showWithText:@"请选择至少一个指数！"];
        return;
    }
    
    if (self.currentTableIndex == 0) {
        if (self.checkArray.count > 3) {
            [MsgAlertTool showAlert:@"温馨提示" message:@"至多只可选择三个指数！" completion:^(BOOL cancelled, NSInteger buttonIndex) {
                
            } okButtonTitles:@"我了解了"];
            return;
        };
    }
    
    if (isNilString(timeId)) {
        [QMUITips showWithText:@"请选择时间周期!"];
        return;
    }
    
    NSMutableArray *dictArray = [NSMutableArray array];
    for (int i = 0; i < self.checkArray.count; i++) {
        [dictArray addObject:self.checkArray[i]];
    }
    
    [self.view showProgress:@""];
    TMHttpParams *param = [[TMHttpParams alloc] init];
    [param setUrl:API_getStocksFilter_URL];
    [param addParams:timeId forKey:@"time_id"];
    [param addParams:twistId forKey:@"twist_id"];
    [param addParams:hdlyId forKey:@"hdly_id"];
    [param addParams:zoneId forKey:@"zone_id"];
    [param addParams:startDate forKey:@"time_start"];
    [param addParams:endDate forKey:@"time_end"];
    if (self.plateBtn.selected) {
        [param addParams:[dictArray mj_JSONString] forKey:@"plate_codes"];
    }else {
        [param addParams:[dictArray mj_JSONString] forKey:@"codes"];
    }
    param.requestType = POST;
    
    [DataRequest requestWithParam:param successed:^(NSDictionary *dict, NSError *error, int result, NSString *msg) {
        [self.view progressDiss];
        if (result == 1) {
            
            if (self.strategyStockArray.count > 0) {
                [self.strategyStockArray removeAllObjects];
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
                
                [self.strategyStockArray addObject:model];
            }
            
            if (self.strategyStockArray.count == 0) {
                [QMUITips showWithText:@"未找到符合条件的股票"];
            }else {
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    StrategyStockListVC *vc = [[StrategyStockListVC alloc] init];
                    vc.dataSourceArray = self.strategyStockArray;
                    switch ([timeId intValue]) {
                        case 1:
                            vc.timeStr = @"1分";
                            break;
                        case 2:
                            vc.timeStr = @"3分";
                            break;
                        case 3:
                            vc.timeStr = @"5分";
                            break;
                        case 4:
                            vc.timeStr = @"10分";
                            break;
                        case 5:
                            vc.timeStr = @"15分";
                            break;
                        case 6:
                            vc.timeStr = @"30分";
                            break;
                        case 7:
                            vc.timeStr = @"60分";
                            break;
                        case 8:
                            vc.timeStr = @"240分";
                            break;
                        case 9:
                            vc.timeStr = @"日线";
                            break;
                        case 10:
                            vc.timeStr = @"周线";
                            break;
                        case 11:
                            vc.timeStr = @"月线";
                            break;
                        default:
                            break;
                    }
                    PushController(vc);
                });
            }
        } else {
            [QMUITips showWithText:msg];
        }
    }];
}

#pragma mark ---- 按钮点击 ----
- (IBAction)plateBtnClick:(id)sender {
    if (self.plateBtn.selected) { return; }
    
    self.plateBtn.selected = YES;
    self.pondBtn.selected = NO;
    self.lineView01.hidden = NO;
    self.lineView02.hidden = YES;
    self.currentTableIndex = 0;
    
    [self.mainTableView.mj_header beginRefreshing];
}

- (IBAction)pondBtnClick:(id)sender {
    if (self.pondBtn.selected) { return; }
    
    self.plateBtn.selected = NO;
    self.pondBtn.selected = YES;
    self.lineView01.hidden = YES;
    self.lineView02.hidden = NO;
    self.currentTableIndex = 1;
    
    [self.mainTableView.mj_header beginRefreshing];
}

- (IBAction)checkAllBtnClick:(id)sender {
    
    self.checkAllBtn.selected = !self.checkAllBtn.selected;
    if (self.checkArray.count > 0) {
        [self.checkArray removeAllObjects];
    }
    
    for (int i = 0; i < self.dataSourceArray.count; i++) {
        SelectStockModel *model = self.dataSourceArray[i];
        
        if (self.checkAllBtn.selected) {
            NSMutableDictionary *checkedResult = self.markArray[i];
            [checkedResult setValue:@1 forKey:@"isChecked"];
            [self.checkArray addObject:model.code];
        }else {
            NSMutableDictionary *checkedResult = self.markArray[i];
            [checkedResult setValue:@0 forKey:@"isChecked"];
        }
    }
    [self.mainTableView reloadData];
}

#pragma mark ---- 懒加载 ----
- (NSMutableArray *)dataSourceArray {
    if (!_dataSourceArray) {
        _dataSourceArray = [[NSMutableArray alloc] init];
    }
    return _dataSourceArray;
}

- (NSMutableArray *)strategyStockArray {
    if (!_strategyStockArray) {
        _strategyStockArray = [[NSMutableArray alloc] init];
    }
    return _strategyStockArray;
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

- (SelectStrategyView *)selectStrategyView {
    if (_selectStrategyView == nil) {
        _selectStrategyView = [[SelectStrategyView alloc] initWithFrame:self.bottomView.bounds];
        _selectStrategyView.delegate = self;
    }
    return _selectStrategyView;
}

- (void)setDataForSelectStrategyView {
    NSMutableArray *array01 = [NSMutableArray array];
    for (int i = 0; i < 11; i++) {
        StrategyModel *model = [[StrategyModel alloc] init];
        model.strategyId = i + 1;
        switch (i) {
            case 0:
                model.name = @"1分";
                break;
            case 1:
                model.name = @"3分";
                break;
            case 2:
                model.name = @"5分";
                break;
            case 3:
                model.name = @"10分";
                break;
            case 4:
                model.name = @"15分";
                break;
            case 5:
                model.name = @"30分";
                break;
            case 6:
                model.name = @"60分";
                break;
            case 7:
                model.name = @"240分";
                break;
            case 8:
                model.name = @"日线";
                break;
            case 9:
                model.name = @"周线";
                break;
            case 10:
                model.name = @"月线";
                break;
            default:
                break;
        }
        
        if (!isNilString([[UserInfo Instance] getAccess_token])) {
            for (int j = 0; j < _timePermissionsArray.count; j++) {
                if (model.strategyId == [_timePermissionsArray[j] integerValue]) {
                    model.usable = YES;
                    break;
                }
            }
        }
        
        [array01 addObject:model];
    }
    
    NSMutableArray *array02 = [NSMutableArray array];
    for (int i = 0; i < 12; i++) {
        StrategyModel *model = [[StrategyModel alloc] init];
        model.strategyId = i + 1;
        switch (i) {
            case 0:
                model.name = @"小1买";
                break;
            case 1:
                model.name = @"大1买";
                break;
            case 2:
                model.name = @"小3买";
                break;
            case 3:
                model.name = @"大3买";
                break;
            case 4:
                model.name = @"潜力七段";
                break;
            case 5:
                model.name = @"亮绿九段";
                break;
            case 6:
                model.name = @"虚线扩展";
                break;
            case 7:
                model.name = @"混合扩展";
                break;
            case 8:
                model.name = @"小连环马";
                break;
            case 9:
                model.name = @"大连环马";
                break;
            case 10:
                model.name = @"超强核裂变";
                break;
            case 11:
                model.name = @"1区";
                break;
            default:
                break;
        }
        
        if (!isNilString([[UserInfo Instance] getAccess_token])) {
            for (int j = 0; j < _twistPermissionsArray.count; j++) {
                if (model.strategyId == [_twistPermissionsArray[j] integerValue]) {
                    model.usable = YES;
                    break;
                }
            }
        }
        
        [array02 addObject:model];
    }
    
    NSMutableArray *array03 = [NSMutableArray array];
    for (int i = 0; i < 12; i++) {
        StrategyModel *model = [[StrategyModel alloc] init];
        model.strategyId = i + 13;
        switch (i) {
            case 0:
                model.name = @"小1卖";
                break;
            case 1:
                model.name = @"大1卖";
                break;
            case 2:
                model.name = @"小3卖";
                break;
            case 3:
                model.name = @"大3卖";
                break;
            case 4:
                model.name = @"潜力七段";
                break;
            case 5:
                model.name = @"紫色空头";
                break;
            case 6:
                model.name = @"虚线扩展";
                break;
            case 7:
                model.name = @"混合扩展";
                break;
            case 8:
                model.name = @"小连环马";
                break;
            case 9:
                model.name = @"大连环马";
                break;
            case 10:
                model.name = @"超强核裂变";
                break;
            case 11:
                model.name = @"-1区";
                break;
            default:
                break;
        }
        
        if (!isNilString([[UserInfo Instance] getAccess_token])) {
            for (int j = 0; j < _twistPermissionsArray.count; j++) {
                if (model.strategyId == [_twistPermissionsArray[j] integerValue]) {
                    model.usable = YES;
                    break;
                }
            }
        }
        
        [array03 addObject:model];
    }
    
    NSMutableArray *array04 = [NSMutableArray array];
    for (int i = 0; i < 4; i++) {
        StrategyModel *model = [[StrategyModel alloc] init];
        model.strategyId = i + 1;
        switch (i) {
            case 0:
                model.name = @"小底";
                break;
            case 1:
                model.name = @"中底";
                break;
            case 2:
                model.name = @"大底";
                break;
            case 3:
                model.name = @"超大底";
                break;
            default:
                break;
        }
        
        if (!isNilString([[UserInfo Instance] getAccess_token])) {
            for (int j = 0; j < _hdlyPermissionsArray.count; j++) {
                if (model.strategyId == [_hdlyPermissionsArray[j] integerValue]) {
                    model.usable = YES;
                    break;
                }
            }
        }
        
        [array04 addObject:model];
    }
    
    [self.selectStrategyView setDataWithArray:array01 array02:array02 array03:array03 array04:array04];
}

@end
