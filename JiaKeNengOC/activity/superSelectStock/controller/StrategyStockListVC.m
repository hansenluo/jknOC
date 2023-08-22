//
//  StrategyStockListVC.m
//  JiaKeNengOC
//
//  Created by jkn-mac on 2023/8/3.
//

#import "StrategyStockListVC.h"
#import "StockPondModel.h"
#import "StrategyStockListCell.h"
#import "KLineMainVC.h"

@interface StrategyStockListVC () <UITableViewDelegate, UITableViewDataSource, StrategyStockListCellDelegate>

@property (nonatomic, weak) IBOutlet UIView *headerView;
@property (nonatomic, weak) IBOutlet UITableView *tableView;

@property (nonatomic, strong) QMUIButton *btn01;
@property (nonatomic, strong) QMUIButton *btn02;
@property (nonatomic, strong) QMUIButton *btn03;
@property (nonatomic, strong) StrategyStockListCell *strategyStockListCell;
@property (nonatomic, strong) UIScrollView *topScrollView;
@property (nonatomic, assign) float cellLastX; //最后的cell的移动距离

@end

@implementation StrategyStockListVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.title = @"超级选股";
    [self settingHeaderView];
    
    // 注册一个
    extern NSString *tapCellScrollNotification;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(scrollMove:) name:strategyStockScrollNotification object:nil];
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
        make.left.equalTo(self.topScrollView).offset(200);
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
    
    self.topScrollView.contentSize = CGSizeMake(480, 0);
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
    
    _strategyStockListCell = [tableView dequeueReusableCellWithIdentifier:cellID];
    
    if (!_strategyStockListCell) {
        _strategyStockListCell = [[StrategyStockListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    
    _strategyStockListCell.tableView = self.tableView;
    _strategyStockListCell.indexPath = indexPath;
    _strategyStockListCell.delegate = self;
    _strategyStockListCell.model = self.dataSourceArray[indexPath.row];
    
    if (indexPath.row == self.dataSourceArray.count - 1) {
        _strategyStockListCell.lineView.hidden = YES;
    }else {
        _strategyStockListCell.lineView.hidden = NO;
    }
    
    __weak typeof(self) weakSelf = self;
    _strategyStockListCell.tapCellClick = ^(NSIndexPath *indexPath) {
        [weakSelf tableView:tableView didSelectRowAtIndexPath:indexPath];
    };
    
    return _strategyStockListCell;
}

#pragma mark ---- UITableViewDelegate ----
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    StrategyStockListCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    KLineMainVC *vc = [KLineMainVC new];
    vc.stockCode = cell.model.stockCode;
    vc.mainTitle = cell.model.stockCode;
    vc.subTitle = cell.model.stockName;
    if ([self.timeStr isEqualToString:@"日线"]) {
        vc.dateSelectState = DateSelectStateDay;
    }else if ([self.timeStr isEqualToString:@"周线"]) {
        vc.dateSelectState = DateSelectStateWeek;
    }else if ([self.timeStr isEqualToString:@"月线"]) {
        vc.dateSelectState = DateSelectStateMonth;
    }else {
        vc.dateSelectState = DateSelectStateMinute;
        
        if ([self.timeStr isEqualToString:@"1分"]) {
            vc.currentSelectMintue = @"1";
        }else if ([self.timeStr isEqualToString:@"3分"]) {
            vc.currentSelectMintue = @"3";
        }else if ([self.timeStr isEqualToString:@"5分"]) {
            vc.currentSelectMintue = @"5";
        }else if ([self.timeStr isEqualToString:@"10分"]) {
            vc.currentSelectMintue = @"10";
        }else if ([self.timeStr isEqualToString:@"15分"]) {
            vc.currentSelectMintue = @"15";
        }else if ([self.timeStr isEqualToString:@"30分"]) {
            vc.currentSelectMintue = @"30";
        }else if ([self.timeStr isEqualToString:@"60分"]) {
            vc.currentSelectMintue = @"60";
        }else if ([self.timeStr isEqualToString:@"240分"]) {
            vc.currentSelectMintue = @"240";
        }
    }
    PushController(vc);
}

#pragma mark ---- UIScrollViewDelegate ----
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if ([scrollView isEqual:self.topScrollView]) {
        CGPoint offSet = _strategyStockListCell.rightScrollView.contentOffset;
        offSet.x = scrollView.contentOffset.x;
        _strategyStockListCell.rightScrollView.contentOffset = offSet;
    }
    if ([scrollView isEqual:self.tableView]) {
        // 发送通知
        [[NSNotificationCenter defaultCenter] postNotificationName:strategyStockScrollNotification object:self userInfo:@{@"cellOffX":@(self.cellLastX)}];
    }
}

#pragma mark ---- StrategyStockListCellDelegate ----
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

- (void)addPondBtnAction:(NSIndexPath *)indexPath model:(StockPondModel *)model {
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

#pragma mark ---- 按钮点击 ----
- (void)btn01Click:(id)sender {
    self.btn01.selected = !self.btn01.selected;
    
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
    self.btn02.selected = !self.btn02.selected;
    
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
    self.btn03.selected = !self.btn03.selected;
    
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

@end
