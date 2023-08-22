//
//  QuotationListCell.m
//  JiaKeNengOC
//
//  Created by jkn-mac on 2023/6/15.
//

#import "QuotationListCell.h"

@implementation QuotationListCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        self.backgroundColor = [UIColor clearColor];
        
        [self createUI];
    }
    return self;
}

-(void)createUI
{
    self.nameLabel = [UILabel new];
    self.nameLabel.text = @"纳斯达克指数";
    self.nameLabel.font = [UIFont systemFontOfSize:18];
    self.nameLabel.textColor = WhiteColor;
    [self.contentView addSubview:self.nameLabel];
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(5);
        make.width.equalTo(@105);
        make.height.equalTo(@18);
        make.top.equalTo(self.contentView).offset(10);
    }];
    
    self.tagLabel = [UILabel new];
    self.tagLabel.text = @"-";
    self.tagLabel.font = [UIFont systemFontOfSize:14];
    self.tagLabel.textColor = [UIColor colorWithHexString:@"#7C818A"];
    [self.contentView addSubview:self.tagLabel];
    [self.tagLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(5);
        make.width.equalTo(@90);
        make.height.equalTo(@12);
        make.top.equalTo(self.contentView).offset(33);
    }];
    
    self.rightScrollView = [[UIScrollView alloc] init];
    self.rightScrollView.showsVerticalScrollIndicator = NO;
    self.rightScrollView.showsHorizontalScrollIndicator = NO;
    self.rightScrollView.contentSize = CGSizeMake(470, 0);
    self.rightScrollView.delegate = self;
    [self.contentView addSubview:self.rightScrollView];
    [self.rightScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(tagLabelWidth);
        make.right.equalTo(self.contentView);
        make.top.bottom.equalTo(self.contentView);
    }];
    
    self.priceLabel = [UILabel new];
    self.priceLabel.text = @"158.62";
    self.priceLabel.font = [UIFont systemFontOfSize:18];
    self.priceLabel.textColor = [UIColor colorWithHexString:@"#FF3D4C"];
    self.priceLabel.textAlignment = NSTextAlignmentCenter;
    [self.rightScrollView addSubview:self.priceLabel];
    [self.priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.rightScrollView).offset(5);
        make.width.equalTo(@80);
        make.height.equalTo(@25);
        make.centerY.equalTo(self.rightScrollView);
    }];
    
    UIView *priceView = [[UIView alloc] init];
    priceView.backgroundColor = [UIColor clearColor];
    [self.rightScrollView addSubview:priceView];
    [priceView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.rightScrollView).offset(95);
        make.width.equalTo(@80);
        make.height.equalTo(@28);
        make.centerY.equalTo(self.rightScrollView);
    }];
    
    self.temView = [[UIView alloc] init];
    self.temView.backgroundColor = [UIColor colorWithHexString:@"#FF3D4C"];
    [self.temView acs_radiusWithRadius:2 corner:UIRectCornerAllCorners];
    [priceView addSubview:self.temView];
    [self.temView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.bottom.equalTo(priceView);
    }];
    
    self.aitoLabel = [UILabel new];
    self.aitoLabel.text = @"-1.23%";
    self.aitoLabel.font = [UIFont systemFontOfSize:16 weight:UIFontWeightMedium];
    self.aitoLabel.textColor = WhiteColor;
    self.aitoLabel.textAlignment = NSTextAlignmentCenter;
    [priceView addSubview:self.aitoLabel];
    [self.aitoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.bottom.equalTo(priceView);
    }];
    
    self.priceCountLabel = [UILabel new];
    self.priceCountLabel.text = @"8685亿";
    self.priceCountLabel.font = [UIFont systemFontOfSize:18];
    self.priceCountLabel.textColor = WhiteColor;
    self.priceCountLabel.textAlignment = NSTextAlignmentCenter;
    [self.rightScrollView addSubview:self.priceCountLabel];
    [self.priceCountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.rightScrollView).offset(185);
        make.width.equalTo(@100);
        make.height.equalTo(@25);
        make.centerY.equalTo(self.rightScrollView);
    }];
    
    self.addPondBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.addPondBtn setTitle:@"加入" forState:UIControlStateNormal];
    [self.addPondBtn setTitleColor:[UIColor colorWithHexString:@"#00B656"] forState:UIControlStateNormal];
    self.addPondBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [self.addPondBtn acs_radiusWithRadius:2 corner:UIRectCornerAllCorners];
    [self.addPondBtn border:1 borderColor:[UIColor colorWithHexString:@"#00B656"]];
    [self.addPondBtn addTarget:self action:@selector(addPondBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.rightScrollView addSubview:self.addPondBtn];
    [self.addPondBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.rightScrollView).offset(300);
        make.width.equalTo(@60);
        make.height.equalTo(@32);
        make.centerY.equalTo(self.rightScrollView);
    }];
    
    self.addAIBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.addAIBtn setTitle:@"取消" forState:UIControlStateNormal];
    [self.addAIBtn setTitleColor:[UIColor colorWithHexString:@"#FF303E"] forState:UIControlStateNormal];
    self.addAIBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [self.addAIBtn acs_radiusWithRadius:2 corner:UIRectCornerAllCorners];
    [self.addAIBtn border:1 borderColor:[UIColor colorWithHexString:@"#FF303E"]];
    [self.addAIBtn addTarget:self action:@selector(addAIBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.rightScrollView addSubview:self.addAIBtn];
    [self.addAIBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.rightScrollView).offset(390);
        make.width.equalTo(@60);
        make.height.equalTo(@32);
        make.centerY.equalTo(self.rightScrollView);
    }];
    
    UIView *lineView = [[UIView alloc] init];
    lineView.backgroundColor = [UIColor colorWithHexString:@"#2A2E37"];
    [self.contentView addSubview:lineView];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.contentView);
        make.height.equalTo(@0.5);
        make.bottom.equalTo(self.contentView);
    }];
    
    UITapGestureRecognizer *tapGes = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
    [self.rightScrollView addGestureRecognizer:tapGes];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(scrollMove:) name:quotationListScrollNotification object:nil];
}

- (void)setModel:(QuotationListModel *)model {
    _model = model;
    
    self.nameLabel.text = isNilString(model.stockCode) ? @"-" : model.stockCode;
    self.tagLabel.text = isNilString(model.stockName) ? @"-" : model.stockName;
    
    //现价
    if (model.close > model.lasetDayclose) {
        self.priceLabel.textColor = ChartColors_dnColor;
    }else if (model.close < model.lasetDayclose) {
        self.priceLabel.textColor = ChartColors_upColor;
    }else {
        self.priceLabel.textColor = WhiteColor;
    }
    self.priceLabel.text = [NSString stringWithFormat:@"%.2f",model.close];
    
    //涨跌幅
    CGFloat upDown = model.close - model.lasetDayclose;
    NSString *symbol = @"";
    if(upDown > 0) {
        symbol = @"+";
        self.temView.backgroundColor = ChartColors_dnColor;
    } else if (upDown < 0) {
        symbol = @"-";
        self.temView.backgroundColor = ChartColors_upColor;
    }else {
        self.temView.backgroundColor = GrayColor;
    }
    
    if (model.lasetDayclose == 0) {
        self.temView.backgroundColor = GrayColor;
        self.aitoLabel.text = @"-";
    }else {
        CGFloat upDownPercent = upDown / model.lasetDayclose * 100;
        self.aitoLabel.text = [NSString stringWithFormat:@"%@%.2f%%",symbol,ABS(upDownPercent)];
    }
    
    if (model.close <= 0) {
        self.priceLabel.text = @"-";
        self.aitoLabel.text = @"-";
    }
    
    //成交额
    self.priceCountLabel.textColor = ChartColors_dnColor;
   // NSLog(@"xxxx = %f",model.amount / 10000);
    if (model.amount >= 10000) {
        self.priceCountLabel.text = [NSString stringWithFormat:@"%.2f亿",model.amount / 10000];
    }else {
        self.priceCountLabel.text = [NSString stringWithFormat:@"%.2f万",model.amount];
    }
    
    //是否加入股票金池
    if (model.addPond == 0) {
        [self.addPondBtn setTitle:@"加入" forState:UIControlStateNormal];
        [self.addPondBtn setTitleColor:ChartColors_dnColor forState:UIControlStateNormal];
        [self.addPondBtn border:1 borderColor:ChartColors_dnColor];
    }else {
        [self.addPondBtn setTitle:@"取消" forState:UIControlStateNormal];
        [self.addPondBtn setTitleColor:ChartColors_upColor forState:UIControlStateNormal];
        [self.addPondBtn border:1 borderColor:ChartColors_upColor];
    }
        
    //是否报警
    if (model.addAI == 0) {
        [self.addAIBtn setTitle:@"加入" forState:UIControlStateNormal];
        [self.addAIBtn setTitleColor:ChartColors_dnColor forState:UIControlStateNormal];
        [self.addAIBtn border:1 borderColor:ChartColors_dnColor];
    }else {
        [self.addAIBtn setTitle:@"取消" forState:UIControlStateNormal];
        [self.addAIBtn setTitleColor:ChartColors_upColor forState:UIControlStateNormal];
        [self.addAIBtn border:1 borderColor:ChartColors_upColor];
    }
}

#pragma mark - UIScrollViewDelegate
-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    _isNotification = NO;
}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    if (!_isNotification) {
        // 发送通知
        [[NSNotificationCenter defaultCenter] postNotificationName:quotationListScrollNotification object:self userInfo:@{@"cellOffX":@(scrollView.contentOffset.x)}];
    }
    _isNotification = NO;
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    // 避开自己发的通知，只有手指拨动才会是自己的滚动
    if (!_isNotification) {
        // 发送通知
        [[NSNotificationCenter defaultCenter] postNotificationName:quotationListScrollNotification object:self userInfo:@{@"cellOffX":@(scrollView.contentOffset.x)}];
    }
    _isNotification = NO;
}

-(void)scrollMove:(NSNotification*)notification
{
    NSDictionary *noticeInfo = notification.userInfo;
    NSObject *obj = notification.object;
    float x = [noticeInfo[@"cellOffX"] floatValue];
    if (obj!=self) {
        _isNotification = YES;
        [_rightScrollView setContentOffset:CGPointMake(x, 0) animated:NO];
    }else{
        _isNotification = NO;
    }
    obj = nil;
}

#pragma mark - 点击事件
- (void)addPondBtnClick:(UIButton *)sender {
    [self.delegate addPondBtnAction:self.indexPath model:self.model];
}

- (void)addAIBtnClick:(UIButton *)sender {
    [self.delegate addAIBtnAction:self.indexPath model:self.model];
}

- (void)tapAction:(UITapGestureRecognizer *)gesture {
    __weak typeof (self) weakSelf = self;
    if (self.tapCellClick) {
        NSIndexPath *indexPath = [weakSelf.tableView indexPathForCell:weakSelf];
        weakSelf.tapCellClick(indexPath);
    }
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    if ([NSStringFromClass([touch.view class]) isEqualToString:@"UITableViewCellContentView"]) {
        return NO;
    }
    return YES;
}

@end
