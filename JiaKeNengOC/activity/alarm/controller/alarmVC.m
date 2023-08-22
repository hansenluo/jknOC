//
//  alarmVC.m
//  JiaKeNengOC
//
//  Created by jkn-mac on 2023/6/14.
//

#import "alarmVC.h"
#import <MJRefresh/MJRefresh.h>
#import <DZNEmptyDataSet/UIScrollView+EmptyDataSet.h>
#import "AlarmCell.h"
#import "AlarmTimeSelectView.h"
#import "AlarmTwistSelectView.h"
#import "AlarmHdlySelectView.h"
#import "KLineMainVC.h"

@interface alarmVC () <UITableViewDataSource, UITableViewDelegate, UIScrollViewDelegate, AlarmCellDelegate, AlarmTimeSelectViewDelegate, AlarmTwistSelectViewDelegate, AlarmHdlySelectViewDelegate, DZNEmptyDataSetSource, DZNEmptyDataSetDelegate>

@property (nonatomic, weak) IBOutlet UITableView *tableView;
@property (nonatomic, weak) IBOutlet UIView *headerView;

@property (nonatomic, strong) AlarmCell *alarmCell;
@property (nonatomic, strong) QMUIButton *checkAllBtn;
@property (nonatomic, strong) StockAIModel *stockPondCell;
@property (nonatomic, strong) UIScrollView *topScrollView;
@property (nonatomic, assign) float cellLastX; //最后的cell的移动距离

@property (nonatomic, strong) NSMutableArray *array01;
@property (nonatomic, strong) NSMutableArray *array02;
@property (nonatomic, strong) NSMutableArray *array03;
@property (nonatomic, strong) NSMutableArray *array04;
@property (nonatomic, strong) NSMutableArray *markArray;
@property (nonatomic, strong) NSMutableArray *checkArray;
@property (nonatomic, strong) NSMutableArray *indexArray;
@property (nonatomic, strong) NSMutableArray *dataSourceArray;

@property (nonatomic, assign) BOOL isFristLoding;

@end

@implementation alarmVC

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.navigationBarHidden = YES;
    self.view.backgroundColor = [UIColor colorWithHexString:@"#000000"];
    
    self.tableView.emptyDataSetSource = self;
    self.tableView.emptyDataSetDelegate = self;
    [self settingHeaderView];
    [self initArray];
    
    // 注册一个
    extern NSString *tapCellScrollNotification;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(scrollMove:) name:tapCellScrollNotification object:nil];
    
    PXNotifiAdd(refreshPageData, LOGINSTATUSKEY, nil);
    PXNotifiAdd(refreshPageData, StockAIOperateKey, nil);
    
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
- (void)refreshingData:(BOOL)isHeaderRefresh {
    @weakify(self)
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        TMHttpParams *param = [[TMHttpParams alloc] init];
        [param setUrl:API_getAlarmStocks_URL];
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
                    StockAIModel *model = [[StockAIModel alloc] init];
                    model.num = [NSString stringWithFormat:@"%d",i+1];
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
                    model.onlyId = [array[21] integerValue];
                    model.timeId = [array[22] integerValue];
                    model.duotouId = [array[23] integerValue];
                    model.kongtouId = [array[24] integerValue];
                    model.hdlyId = [array[25] integerValue];
                    
                    [self.dataSourceArray addObject:model];
                
                    NSMutableDictionary *temDict = [NSMutableDictionary dictionaryWithObject:@0 forKey:@"isChecked"];
                    [self.markArray addObject:temDict];
                }
                
                [self.tableView.mj_footer setState:MJRefreshStateNoMoreData];
                [self.tableView.mj_header endRefreshing];
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.tableView reloadData];
                    [[NSNotificationCenter defaultCenter] postNotificationName:tapCellScrollNotification object:self userInfo:@{@"cellOffX":@(self.cellLastX)}];
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
    
    self.topScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(tagLabelWidth, 0, screenW - tagLabelWidth, 45)];
    self.topScrollView.showsVerticalScrollIndicator = NO;
    self.topScrollView.showsHorizontalScrollIndicator = NO;
    [self.headerView addSubview:self.topScrollView];
    
    UILabel *titleLbl03 = [UILabel new];
    titleLbl03.frame = CGRectMake(0, 15, 3*75 + 10, 15);
    titleLbl03.text = @"+缠论报警";
    titleLbl03.textColor = [UIColor colorWithHexString:@"#7C818A"];
    titleLbl03.font = [UIFont systemFontOfSize:16];
    titleLbl03.textAlignment = NSTextAlignmentCenter;
    [self.topScrollView addSubview:titleLbl03];
    
    UILabel *titleLbl04 = [UILabel new];
    titleLbl04.frame = CGRectMake(245, 15, 60, 15);
    titleLbl04.text = @"更改";
    titleLbl04.textColor = [UIColor colorWithHexString:@"#7C818A"];
    titleLbl04.font = [UIFont systemFontOfSize:16];
    titleLbl04.textAlignment = NSTextAlignmentCenter;
    [self.topScrollView addSubview:titleLbl04];
    
    UILabel *titleLbl05 = [UILabel new];
    titleLbl05.frame = CGRectMake(315, 15, 60, 15);
    titleLbl05.text = @"操作";
    titleLbl05.textColor = [UIColor colorWithHexString:@"#7C818A"];
    titleLbl05.font = [UIFont systemFontOfSize:16];
    titleLbl05.textAlignment = NSTextAlignmentCenter;
    [self.topScrollView addSubview:titleLbl05];
    
    QMUIButton *batchCancelBtn = [QMUIButton buttonWithType:UIButtonTypeCustom];
    [batchCancelBtn setTitle:@"批量取消" forState:UIControlStateNormal];
    [batchCancelBtn setTitleColor:ChartColors_dnColor forState:UIControlStateNormal];
    batchCancelBtn.titleLabel.font = MFont(16);
    [batchCancelBtn border:1 borderColor:ChartColors_dnColor];
    [batchCancelBtn addTarget:self action:@selector(batchCancelBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.topScrollView addSubview:batchCancelBtn];
    [batchCancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.topScrollView).offset(375);
        make.width.equalTo(@80);
        make.height.equalTo(@25);
        make.centerY.equalTo(self.topScrollView);
    }];
    
    self.checkAllBtn = [QMUIButton buttonWithType:UIButtonTypeCustom];
    [self.checkAllBtn setFrame:CGRectMake(460, 11.5, 22, 22)];
    [self.checkAllBtn setImage:[UIImage imageNamed:@"z_btn_select_n"] forState:UIControlStateNormal];
    [self.checkAllBtn setImage:[UIImage imageNamed:@"z_btn_select_s"] forState:UIControlStateSelected];
    [self.checkAllBtn addTarget:self action:@selector(checkAllBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.topScrollView addSubview:self.checkAllBtn];
    
    self.topScrollView.contentSize = CGSizeMake(490, 0);
    self.topScrollView.delegate = self;
}

- (void)initArray {
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
        
        [self.array01 addObject:model];
    }
    
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
        
        [self.array02 addObject:model];
    }
    
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
        
        [self.array03 addObject:model];
    }
    
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
        
        [self.array04 addObject:model];
    }
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
    
    _alarmCell = [tableView dequeueReusableCellWithIdentifier:cellID];
    
    if (!_alarmCell) {
        _alarmCell = [[AlarmCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    
    _alarmCell.tableView = self.tableView;
    _alarmCell.indexPath = indexPath;
    _alarmCell.delegate = self;
    _alarmCell.model = self.dataSourceArray[indexPath.row];
    
    NSDictionary *resultDict = self.markArray[indexPath.row];
    _alarmCell.isChecked = [resultDict[@"isChecked"] boolValue];
    
    if (indexPath.row == self.dataSourceArray.count - 1) {
        _alarmCell.lineView.hidden = YES;
    }else {
        _alarmCell.lineView.hidden = NO;
    }
    
    __weak typeof(self) weakSelf = self;
    _alarmCell.tapCellClick = ^(NSIndexPath *indexPath) {
        [weakSelf tableView:tableView didSelectRowAtIndexPath:indexPath];
    };
    return _alarmCell;
}

#pragma mark ---- UITableViewDelegate ----
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    AlarmCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    KLineMainVC *vc = [KLineMainVC new];
    vc.stockCode = cell.model.stockCode;
    vc.mainTitle = cell.model.stockCode;
    vc.subTitle = cell.model.stockName;
    if ([cell.timeBtn.titleLabel.text isEqualToString:@"日线"] || [cell.timeBtn.titleLabel.text isEqualToString:@"周期"]) {
        vc.dateSelectState = DateSelectStateDay;
    }else if ([cell.timeBtn.titleLabel.text isEqualToString:@"周线"]) {
        vc.dateSelectState = DateSelectStateWeek;
    }else if ([cell.timeBtn.titleLabel.text isEqualToString:@"月线"]) {
        vc.dateSelectState = DateSelectStateMonth;
    }else {
        vc.dateSelectState = DateSelectStateMinute;
        
        if ([cell.timeBtn.titleLabel.text isEqualToString:@"1分"]) {
            vc.currentSelectMintue = @"1";
        }else if ([cell.timeBtn.titleLabel.text isEqualToString:@"3分"]) {
            vc.currentSelectMintue = @"3";
        }else if ([cell.timeBtn.titleLabel.text isEqualToString:@"5分"]) {
            vc.currentSelectMintue = @"5";
        }else if ([cell.timeBtn.titleLabel.text isEqualToString:@"10分"]) {
            vc.currentSelectMintue = @"10";
        }else if ([cell.timeBtn.titleLabel.text isEqualToString:@"15分"]) {
            vc.currentSelectMintue = @"15";
        }else if ([cell.timeBtn.titleLabel.text isEqualToString:@"30分"]) {
            vc.currentSelectMintue = @"30";
        }else if ([cell.timeBtn.titleLabel.text isEqualToString:@"60分"]) {
            vc.currentSelectMintue = @"60";
        }else if ([cell.timeBtn.titleLabel.text isEqualToString:@"240分"]) {
            vc.currentSelectMintue = @"240";
        }
    }
    PushController(vc);
}

#pragma mark ---- UIScrollViewDelegate ----
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if ([scrollView isEqual:self.topScrollView]) {
        CGPoint offSet = _alarmCell.rightScrollView.contentOffset;
        offSet.x = scrollView.contentOffset.x;
        _alarmCell.rightScrollView.contentOffset = offSet;
    }
    if ([scrollView isEqual:self.tableView]) {
        // 发送通知
        [[NSNotificationCenter defaultCenter] postNotificationName:tapCellScrollNotification object:self userInfo:@{@"cellOffX":@(self.cellLastX)}];
    }
}

#pragma mark ---- AlarmCellDelegate ----
- (void)selectTime:(AlarmCell *)cell {
    AlarmTimeSelectView *view = [[[NSBundle mainBundle] loadNibNamed:@"AlarmTimeSelectView" owner:self options:nil] objectAtIndex:0];
    view.cell = cell;
    view.delegate = self;
    [view setDataWithArray:self.array01];
    [self.view.window showViewInCenter:view WithSize:CGSizeMake(screenW - 30, view.height)];
}

- (void)selectTwist:(AlarmCell *)cell {
    AlarmTwistSelectView *view = [[[NSBundle mainBundle] loadNibNamed:@"AlarmTwistSelectView" owner:self options:nil] objectAtIndex:0];
    view.cell = cell;
    view.delegate = self;
    [view setDataWithArray:self.array02 array02:self.array03];
    [self.view.window showViewInCenter:view WithSize:CGSizeMake(screenW - 30, view.height)];
}

- (void)selectHdly:(AlarmCell *)cell {
    AlarmHdlySelectView *view = [[[NSBundle mainBundle] loadNibNamed:@"AlarmHdlySelectView" owner:self options:nil] objectAtIndex:0];
    view.cell = cell;
    view.delegate = self;
    [view setDataWithArray:self.array04];
    [self.view.window showViewInCenter:view WithSize:CGSizeMake(screenW - 30, view.height)];
}

- (void)changeBtnAction:(NSIndexPath *)indexPath model:(StockAIModel *)model {
    if (model.timeId == 0) {
        [QMUITips showWithText:@"请选择一个时间周期!"];
        return;
    }
    
    [self.view showProgress:@""];
    TMHttpParams *param = [[TMHttpParams alloc] init];
    [param setUrl:API_modifyTwist_URL];
    [param addParams:[NSString stringWithFormat:@"%ld",model.onlyId] forKey:@"id"];
    [param addParams:[NSString stringWithFormat:@"%ld",model.timeId] forKey:@"time"];
    [param addParams:[NSString stringWithFormat:@"%ld",model.hdlyId] forKey:@"hdly"];
    if (model.duotouId == 0 && model.kongtouId == 0) {
        [param addParams:@"0" forKey:@"twist"];
    }else if (model.duotouId != 0) {
        [param addParams:[NSString stringWithFormat:@"%ld",model.duotouId] forKey:@"twist"];
    }else {
        [param addParams:[NSString stringWithFormat:@"%ld",model.kongtouId] forKey:@"twist"];
    }
    param.requestType = POST;
    [DataRequest requestWithParam:param successed:^(NSDictionary *dict, NSError *error, int result, NSString *msg) {
        
        [self.view progressDiss];
        if (result == 1) {
            
            [QMUITips showSucceed:@"修改成功"];
            [self refreshingData:YES];
            
        } else {
            [QMUITips showWithText:msg];
        }
    }];
}

- (void)addAIBtnAction:(NSIndexPath *)indexPath model:(StockAIModel *)model {
    
    if (model.duotouId == 0 && model.kongtouId == 0 && model.hdlyId == 0) {
        [QMUITips showWithText:@"请选择缠论或海底捞月"];
        return;
    }
    
    [self.view showProgress:@""];
    TMHttpParams *param = [[TMHttpParams alloc] init];
    [param setUrl:API_addTwist_URL];
    [param addParams:model.stockCode forKey:@"code"];
    [param addParams:[NSString stringWithFormat:@"%ld",model.timeId] forKey:@"time"];
    [param addParams:[NSString stringWithFormat:@"%ld",model.hdlyId] forKey:@"hdly"];
    if (model.duotouId == 0 && model.kongtouId == 0) {
        [param addParams:@"0" forKey:@"twist"];
    }else if (model.duotouId != 0) {
        [param addParams:[NSString stringWithFormat:@"%ld",model.duotouId] forKey:@"twist"];
    }else {
        [param addParams:[NSString stringWithFormat:@"%ld",model.kongtouId] forKey:@"twist"];
    }
    param.requestType = POST;
    [DataRequest requestWithParam:param successed:^(NSDictionary *dict, NSError *error, int result, NSString *msg) {
        
        [self.view progressDiss];
        if (result == 1) {
            
            [self refreshingData:YES];
            
        } else {
            [QMUITips showWithText:msg];
        }
    }];
}

- (void)removeBtnAction:(AlarmCell *)cell {
    [MsgAlertTool showAlert:@"" message:[NSString stringWithFormat:@"确定将%@移出缠论报警？",cell.model.stockCode] completion:^(BOOL cancelled, NSInteger buttonIndex) {
        if(!cancelled){
            [self.view showProgress:@""];
            TMHttpParams *param = [[TMHttpParams alloc] init];
            [param setUrl:API_removeTwist_URL];
            [param addParams:[NSString stringWithFormat:@"%ld",cell.model.onlyId] forKey:@"id"];
            param.requestType = POST;
            [DataRequest requestWithParam:param successed:^(NSDictionary *dict, NSError *error, int result, NSString *msg) {
                
                [self.view progressDiss];
                if (result == 1) {
                    
                    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
                    [self.dataSourceArray removeObjectAtIndex:indexPath.row];
                    [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
                    
                    PXNotifiPost(StockAIOperateKey, nil);
                } else {
                    [QMUITips showWithText:msg];
                }
            }];
        }
    } cancelButtonTitle:@"取消" otherButtonTitles:@"确定"];
}

- (void)selectBtnAction:(NSIndexPath *)indexPath model:(StockAIModel *)model {
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    AlarmCell *cell = (AlarmCell *)[self.tableView cellForRowAtIndexPath:indexPath];
    NSMutableDictionary *checkedResult = self.markArray[indexPath.row];
    //isChecked为NO则表明要把这行置为选中状态
    if ([checkedResult[@"isChecked"] boolValue] == NO) {
        [checkedResult setValue:@1 forKey:@"isChecked"];
        cell.isChecked = YES;
        [self.checkArray addObject:[NSString stringWithFormat:@"%ld",model.onlyId]];
        [self.indexArray addObject:[NSString stringWithFormat:@"%ld",indexPath.row]];
    } else{
        [checkedResult setValue:@0 forKey:@"isChecked"];
        cell.isChecked = NO;
        [self.checkArray removeObject:[NSString stringWithFormat:@"%ld",model.onlyId]];
        [self.indexArray removeObject:[NSString stringWithFormat:@"%ld",indexPath.row]];
    }
    [self.tableView reloadData];
    
    if (self.checkArray.count == self.dataSourceArray.count) {
        self.checkAllBtn.selected = YES;
    }else {
        self.checkAllBtn.selected = NO;
    }
}

#pragma mark ---- AlarmTimeSelectViewDelegate ----
- (void)timeBtnAction:(NSInteger)timeId cell:(AlarmCell *)cell{
    StockAIModel *model = cell.model;
    model.timeId = timeId;
    cell.model = model;
}

#pragma mark ---- AlarmTwistSelectViewDelegate ----
- (void)twistBtnAction:(NSInteger)twistId cell:(AlarmCell *)cell{
    StockAIModel *model = cell.model;
    if (twistId == 0) {
        model.duotouId = 0;
        model.kongtouId = 0;
    }else if (twistId <= 12) {
        model.duotouId = twistId;
        model.kongtouId = 0;
    }else {
        model.duotouId = 0;
        model.kongtouId = twistId;
    }
    cell.model = model;
}

#pragma mark ---- AlarmHdlySelectViewDelegate ----
- (void)hdlyBtnAction:(NSInteger)hdlyId cell:(AlarmCell *)cell{
    StockAIModel *model = cell.model;
    model.hdlyId = hdlyId;
    cell.model = model;
}

#pragma mark ---- 按钮点击 ----
- (void)batchCancelBtnClick:(id)sender {
    if (self.checkArray.count == 0) {
        [QMUITips showWithText:@"请选择股票"];
        return;
    }
    
    NSMutableArray *dictArray = [NSMutableArray array];
    for (int i = 0; i < self.checkArray.count; i++) {
        [dictArray addObject:self.checkArray[i]];
    }
    
    [MsgAlertTool showAlert:@"" message:[NSString stringWithFormat:@"确定将所选的%ld支股票移出缠论报警？",self.checkArray.count] completion:^(BOOL cancelled, NSInteger buttonIndex) {
        if(!cancelled){
            [self.view showProgress:@""];
            TMHttpParams *param = [[TMHttpParams alloc] init];
            [param setUrl:API_batchRemoveTwist_URL];
            [param addParams:[dictArray mj_JSONString] forKey:@"records"];
            param.requestType = POST;
            
            [DataRequest requestWithParam:param successed:^(NSDictionary *dict, NSError *error, int result, NSString *msg) {
                [self.view progressDiss];
                if (result == 1) {
                    
                    NSMutableArray *modelArray = [NSMutableArray array];
                    for (int i = 0; i < self.indexArray.count; i++) {
                        StockAIModel *model = [self.dataSourceArray objectAtIndex:[self.indexArray[i] intValue]];
                        [modelArray addObject:model];
                    }
                    
                    for (int i = 0; i < modelArray.count; i++) {
                        StockAIModel *model = modelArray[i];
                        [self.dataSourceArray removeObject:model];
                    }
                    [self.tableView reloadData];
                    
                    PXNotifiPost(StockAIOperateKey, nil);
                    
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
        StockAIModel *model = self.dataSourceArray[i];
        model.selectStatus = self.checkAllBtn.selected;
        
        if (self.checkAllBtn.selected) {
            NSMutableDictionary *checkedResult = self.markArray[i];
            [checkedResult setValue:@1 forKey:@"isChecked"];
            [self.checkArray addObject:[NSString stringWithFormat:@"%ld",model.onlyId]];
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

- (NSMutableArray *)array01{
    
    if (!_array01) {
        _array01 =[NSMutableArray array];
    }
    return _array01;
}

- (NSMutableArray *)array02{
    
    if (!_array02) {
        _array02 =[NSMutableArray array];
    }
    return _array02;
}

- (NSMutableArray *)array03{
    
    if (!_array03) {
        _array03 =[NSMutableArray array];
    }
    return _array03;
}

- (NSMutableArray *)array04{
    
    if (!_array04) {
        _array04 =[NSMutableArray array];
    }
    return _array04;
}

@end
