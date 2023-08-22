//
//  HomeAlarmListVC.m
//  JiaKeNengOC
//
//  Created by jkn-mac on 2023/6/30.
//

#import "HomeAlarmListVC.h"
#import <MJRefresh/MJRefresh.h>
#import <DZNEmptyDataSet/UIScrollView+EmptyDataSet.h>
#import "KLineMainVC.h"
#import "HomeAlarmCell.h"
#import <JXPagingView/JXPagerListRefreshView.h>

@interface HomeAlarmListVC () <UITableViewDelegate, UITableViewDataSource, DZNEmptyDataSetSource, DZNEmptyDataSetDelegate>

@property (nonatomic, weak) IBOutlet UITableView *tableView;
@property (nonatomic, weak) IBOutlet UIImageView *arrowImage01;
@property (nonatomic, weak) IBOutlet UIImageView *arrowImage02;
@property (nonatomic, weak) IBOutlet UIButton *tagBtn01;
@property (nonatomic, weak) IBOutlet UIButton *tagBtn02;
@property (nonatomic, strong) NSMutableArray *dataSourceArray;

@property (nonatomic, assign) BOOL isFristLoding;

@property (nonatomic, copy) void(^scrollCallback)(UIScrollView *scrollView);

@end

@implementation HomeAlarmListVC

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.tableView.emptyDataSetSource = self;
    self.tableView.emptyDataSetDelegate = self;
    
//    PXNotifiAdd(refreshPageData, LOGINSTATUSKEY, nil);
//    PXNotifiAdd(refreshPageData, StockAIOperateKey, nil);
//
//    //获取报警列表
//    [self configTableView];
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
- (void)refreshingData:(BOOL)isHeaderRefresh
{
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
                    [self.dataSourceArray removeAllObjects];
                }
                
                NSArray *arr = dict[@"data"];
                for (int i = 0; i < arr.count; i++) {
                    NSArray *array = arr[i];
                    StockAIModel *model = [[StockAIModel alloc] init];
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

#pragma mark ---- DZNEmptyDataSetSource ----
//- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView {
//    if (!self.isFristLoding) { return nil; }
//
//    return [UIImage imageNamed:@"search_null"];
//}

- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView {
    if (!self.isFristLoding) { return nil; }
    
    NSString *title = @"";
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
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataSourceArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 64;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cell_id = @"cell_id";
    HomeAlarmCell *cell = (HomeAlarmCell *)[tableView dequeueReusableCellWithIdentifier:cell_id];
    if (cell == nil) {
        cell= (HomeAlarmCell *)[[[NSBundle mainBundle] loadNibNamed:@"HomeAlarmCell" owner:self options:nil] lastObject];
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.model = self.dataSourceArray[indexPath.row];
    
    if (indexPath.row == self.dataSourceArray.count - 1) {
        cell.lineView.hidden = YES;
    }else {
        cell.lineView.hidden = NO;
    }
    
    return cell;
}

#pragma mark ---- UITableViewDelegate ----
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    HomeAlarmCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    KLineMainVC *vc = [KLineMainVC new];
    vc.stockCode = cell.model.stockCode;
    vc.mainTitle = cell.model.stockCode;
    vc.subTitle = cell.model.stockName;
    //vc.dateSelectState = DateSelectStateDay;
    vc.dateSelectState = DateSelectStateMinute;
    vc.currentSelectMintue = @"30";
    PushController(vc);
}

#pragma mark ----- JXPagingViewListViewDelegate ----
- (UIView *)listView {
    return self.view;
}

- (UIScrollView *)listScrollView {
    return self.tableView;
}

- (void)listViewDidScrollCallback:(void (^)(UIScrollView *))callback {
    self.scrollCallback = callback;
}

#pragma mark ---- 按钮点击 ----
- (IBAction)priceBtnClick:(id)sender {
    
    self.tagBtn01.selected = !self.tagBtn01.selected;
    
    if (self.tagBtn01.selected) {
        [self.arrowImage01 setImage:UIImageMake(@"icon_down_green_arrow")];
    }else {
        [self.arrowImage01 setImage:UIImageMake(@"icon_up_green_arrow")];
    }
    
    [self.arrowImage02 setImage:UIImageMake(@"icon_normal_gray_arrow")];
}

- (IBAction)upAndDownBtnClick:(id)sender {
    
    self.tagBtn02.selected = !self.tagBtn02.selected;
    
    if (self.tagBtn02.selected) {
        [self.arrowImage02 setImage:UIImageMake(@"icon_down_green_arrow")];
    }else {
        [self.arrowImage02 setImage:UIImageMake(@"icon_up_green_arrow")];
    }
    
    [self.arrowImage01 setImage:UIImageMake(@"icon_normal_gray_arrow")];
}

#pragma mark ---- 懒加载 ----
- (NSMutableArray *)dataSourceArray {
    if (!_dataSourceArray) {
        _dataSourceArray = [[NSMutableArray alloc] init];
    }
    return _dataSourceArray;
}

@end
