//
//  AlarmCell.m
//  JiaKeNengOC
//
//  Created by jkn-mac on 2023/6/16.
//

#import "AlarmCell.h"

@interface AlarmCell ()

@property (nonatomic, strong) UIButton *twistBtn;
@property (nonatomic, strong) UIButton *hdlyBtn;

@end

@implementation AlarmCell

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
        make.top.equalTo(self.contentView).offset(15);
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
        make.top.equalTo(self.contentView).offset(38);
    }];
    
    self.rightScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(tagLabelWidth, 0, screenW-tagLabelWidth, 64)];
    
    CGFloat x = 0;
    for (int i = 0; i < 3; i++) {
        if (i == 0) {
            self.timeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            [self.timeBtn setFrame:CGRectMake(x, 16, 75, 32)];
            [self.timeBtn setTitle:@"周期" forState:UIControlStateNormal];
            [self.timeBtn setTitleColor:[UIColor colorWithHexString:@"#7C818A"] forState:UIControlStateNormal];
            self.timeBtn.titleLabel.font = [UIFont systemFontOfSize:14];
            [self.timeBtn acs_radiusWithRadius:2 corner:UIRectCornerAllCorners];
            [self.timeBtn border:1 borderColor:[UIColor colorWithHexString:@"#555555"]];
            [self.timeBtn addTarget:self action:@selector(timeBtnClick:) forControlEvents:UIControlEventTouchUpInside];
            [self.rightScrollView addSubview:self.timeBtn];
        }else if (i == 1) {
            self.twistBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            [self.twistBtn setFrame:CGRectMake(x, 16, 75, 32)];
            [self.twistBtn setTitle:@"缠论" forState:UIControlStateNormal];
            [self.twistBtn setTitleColor:[UIColor colorWithHexString:@"#7C818A"] forState:UIControlStateNormal];
            self.twistBtn.titleLabel.font = [UIFont systemFontOfSize:14];
            [self.twistBtn acs_radiusWithRadius:2 corner:UIRectCornerAllCorners];
            [self.twistBtn border:1 borderColor:[UIColor colorWithHexString:@"#555555"]];
            [self.twistBtn addTarget:self action:@selector(twistBtnClick:) forControlEvents:UIControlEventTouchUpInside];
            [self.rightScrollView addSubview:self.twistBtn];
        }else {
            self.hdlyBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            [self.hdlyBtn setFrame:CGRectMake(x, 16, 75, 32)];
            [self.hdlyBtn setTitle:@"抄底" forState:UIControlStateNormal];
            [self.hdlyBtn setTitleColor:[UIColor colorWithHexString:@"#7C818A"] forState:UIControlStateNormal];
            self.hdlyBtn.titleLabel.font = [UIFont systemFontOfSize:14];
            [self.hdlyBtn acs_radiusWithRadius:2 corner:UIRectCornerAllCorners];
            [self.hdlyBtn border:1 borderColor:[UIColor colorWithHexString:@"#555555"]];
            [self.hdlyBtn addTarget:self action:@selector(hdlyBtnClick:) forControlEvents:UIControlEventTouchUpInside];
            [self.rightScrollView addSubview:self.hdlyBtn];;
        }
        x = (i+1)*80;;
    }
    
    UIButton *changBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [changBtn setFrame:CGRectMake(245, 16, 60, 32)];
    [changBtn setTitle:@"更改" forState:UIControlStateNormal];
    [changBtn setTitleColor:[UIColor colorWithHexString:@"#00B656"] forState:UIControlStateNormal];
    changBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [changBtn acs_radiusWithRadius:2 corner:UIRectCornerAllCorners];
    [changBtn border:1 borderColor:[UIColor colorWithHexString:@"#00B656"]];
    [changBtn addTarget:self action:@selector(changBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.rightScrollView addSubview:changBtn];
    
    UIButton *addBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [addBtn setFrame:CGRectMake(315, 16, 60, 32)];
    [addBtn setTitle:@"加入" forState:UIControlStateNormal];
    [addBtn setTitleColor:[UIColor colorWithHexString:@"#00B656"] forState:UIControlStateNormal];
    addBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [addBtn acs_radiusWithRadius:2 corner:UIRectCornerAllCorners];
    [addBtn border:1 borderColor:[UIColor colorWithHexString:@"#00B656"]];
    [addBtn addTarget:self action:@selector(addBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.rightScrollView addSubview:addBtn];
    
    UIButton *cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [cancelBtn setFrame:CGRectMake(385, 16, 60, 32)];
    [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
    [cancelBtn setTitleColor:[UIColor colorWithHexString:@"#FF303E"] forState:UIControlStateNormal];
    cancelBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [cancelBtn acs_radiusWithRadius:2 corner:UIRectCornerAllCorners];
    [cancelBtn border:1 borderColor:[UIColor colorWithHexString:@"#FF303E"]];
    [cancelBtn addTarget:self action:@selector(cancelBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.rightScrollView addSubview:cancelBtn];
    
    self.selectBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.selectBtn setFrame:CGRectMake(460, 21, 22, 22)];
    [self.selectBtn setImage:[UIImage imageNamed:@"z_btn_select_n"] forState:UIControlStateNormal];
    [self.selectBtn setImage:[UIImage imageNamed:@"z_btn_select_s"] forState:UIControlStateSelected];
    [self.selectBtn addTarget:self action:@selector(selectBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.rightScrollView addSubview:self.selectBtn];
    
    self.rightScrollView.showsVerticalScrollIndicator = NO;
    self.rightScrollView.showsHorizontalScrollIndicator = NO;
    self.rightScrollView.contentSize = CGSizeMake(490, 0);
    self.rightScrollView.delegate = self;
    
    [self.contentView addSubview:self.rightScrollView];
    
    self.lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 63, screenW, 0.5)];
    self.lineView.backgroundColor = [UIColor colorWithHexString:@"#2A2E37"];
    [self.contentView addSubview:self.lineView];
    
    UITapGestureRecognizer *tapGes = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
    [self.rightScrollView addGestureRecognizer:tapGes];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(scrollMove:) name:tapCellScrollNotification object:nil];
}

- (void)setModel:(StockAIModel *)model {
    _model = model;
    
    self.nameLabel.text = isNilString(model.stockCode) ? @"-" : model.stockCode;
    self.tagLabel.text = isNilString(model.stockName) ? @"-" : model.stockName;
    
    [self timeBtnTitle:model];
    [self twistBtnTitle:model];
    [self hdlyBtnTitle:model];
    
    self.selectBtn.selected = model.selectStatus;
}

- (void)timeBtnTitle:(StockAIModel *)model {
    switch (model.timeId) {
        case 0:
            [self.timeBtn setTitle:@"周期" forState:UIControlStateNormal];
            break;
        case 1:
            [self.timeBtn setTitle:@"1分" forState:UIControlStateNormal];
            break;
        case 2:
            [self.timeBtn setTitle:@"3分" forState:UIControlStateNormal];
            break;
        case 3:
            [self.timeBtn setTitle:@"5分" forState:UIControlStateNormal];
            break;
        case 4:
            [self.timeBtn setTitle:@"10分" forState:UIControlStateNormal];
            break;
        case 5:
            [self.timeBtn setTitle:@"15分" forState:UIControlStateNormal];
            break;
        case 6:
            [self.timeBtn setTitle:@"30分" forState:UIControlStateNormal];
            break;
        case 7:
            [self.timeBtn setTitle:@"60分" forState:UIControlStateNormal];
            break;
        case 8:
            [self.timeBtn setTitle:@"240分" forState:UIControlStateNormal];
            break;
        case 9:
            [self.timeBtn setTitle:@"日线" forState:UIControlStateNormal];
            break;
        case 10:
            [self.timeBtn setTitle:@"周线" forState:UIControlStateNormal];
            break;
        case 11:
            [self.timeBtn setTitle:@"月线" forState:UIControlStateNormal];
            break;
        default:
            break;
    }
}

- (void)twistBtnTitle:(StockAIModel *)model {
    if (model.duotouId == 0 && model.kongtouId == 0) {
        [self.twistBtn setTitle:@"缠论" forState:UIControlStateNormal];
    }else if (model.duotouId != 0) {
        switch (model.duotouId) {
            case 1:
                [self.twistBtn setTitle:@"小1买" forState:UIControlStateNormal];
                break;
            case 2:
                [self.twistBtn setTitle:@"大1买" forState:UIControlStateNormal];
                break;
            case 3:
                [self.twistBtn setTitle:@"小3买" forState:UIControlStateNormal];
                break;
            case 4:
                [self.twistBtn setTitle:@"大3买" forState:UIControlStateNormal];
                break;
            case 5:
                [self.twistBtn setTitle:@"潜力七段" forState:UIControlStateNormal];
                break;
            case 6:
                [self.twistBtn setTitle:@"亮绿九段" forState:UIControlStateNormal];
                break;
            case 7:
                [self.twistBtn setTitle:@"虚线扩展" forState:UIControlStateNormal];
                break;
            case 8:
                [self.twistBtn setTitle:@"混合扩展" forState:UIControlStateNormal];
                break;
            case 9:
                [self.twistBtn setTitle:@"小连环马" forState:UIControlStateNormal];
                break;
            case 10:
                [self.twistBtn setTitle:@"大连环马" forState:UIControlStateNormal];
                break;
            case 11:
                [self.twistBtn setTitle:@"超强核裂变" forState:UIControlStateNormal];
                break;
            case 12:
                [self.twistBtn setTitle:@"1区" forState:UIControlStateNormal];
                break;
            default:
                break;
        }
    }else {
        switch (model.kongtouId) {
            case 13:
                [self.twistBtn setTitle:@"小1卖" forState:UIControlStateNormal];
                break;
            case 14:
                [self.twistBtn setTitle:@"大1卖" forState:UIControlStateNormal];
                break;
            case 15:
                [self.twistBtn setTitle:@"小3卖" forState:UIControlStateNormal];
                break;
            case 16:
                [self.twistBtn setTitle:@"大3卖" forState:UIControlStateNormal];
                break;
            case 17:
                [self.twistBtn setTitle:@"潜力七段" forState:UIControlStateNormal];
                break;
            case 18:
                [self.twistBtn setTitle:@"紫色空头" forState:UIControlStateNormal];
                break;
            case 19:
                [self.twistBtn setTitle:@"虚线扩展" forState:UIControlStateNormal];
                break;
            case 20:
                [self.twistBtn setTitle:@"混合扩展" forState:UIControlStateNormal];
                break;
            case 21:
                [self.twistBtn setTitle:@"小连环马" forState:UIControlStateNormal];
                break;
            case 22:
                [self.twistBtn setTitle:@"大连环马" forState:UIControlStateNormal];
                break;
            case 23:
                [self.twistBtn setTitle:@"超强核裂变" forState:UIControlStateNormal];
                break;
            case 24:
                [self.twistBtn setTitle:@"-1区" forState:UIControlStateNormal];
                break;
            default:
                break;
        }
    }
}

- (void)hdlyBtnTitle:(StockAIModel *)model {
    switch (model.hdlyId) {
        case 0:
            [self.hdlyBtn setTitle:@"抄底" forState:UIControlStateNormal];
            break;
        case 1:
            [self.hdlyBtn setTitle:@"小底" forState:UIControlStateNormal];
            break;
        case 2:
            [self.hdlyBtn setTitle:@"中底" forState:UIControlStateNormal];
            break;
        case 3:
            [self.hdlyBtn setTitle:@"大底" forState:UIControlStateNormal];
            break;
        case 4:
            [self.hdlyBtn setTitle:@"超大底" forState:UIControlStateNormal];
            break;
        default:
            break;
    }
}

#pragma mark - UIScrollViewDelegate
-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    _isNotification = NO;
}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    if (!_isNotification) {
        // 发送通知
        [[NSNotificationCenter defaultCenter] postNotificationName:tapCellScrollNotification object:self userInfo:@{@"cellOffX":@(scrollView.contentOffset.x)}];
    }
    _isNotification = NO;
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    // 避开自己发的通知，只有手指拨动才会是自己的滚动
    if (!_isNotification) {
        // 发送通知
        [[NSNotificationCenter defaultCenter] postNotificationName:tapCellScrollNotification object:self userInfo:@{@"cellOffX":@(scrollView.contentOffset.x)}];
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

- (void)setIsChecked:(BOOL)isChecked
{
    _isChecked = isChecked;
    
    self.selectBtn.selected = isChecked;
}

#pragma mark - 点击事件
- (void)tapAction:(UITapGestureRecognizer *)gesture
{
    __weak typeof (self) weakSelf = self;
    if (self.tapCellClick) {
        NSIndexPath *indexPath = [weakSelf.tableView indexPathForCell:weakSelf];
        weakSelf.tapCellClick(indexPath);
    }
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    if ([NSStringFromClass([touch.view class]) isEqualToString:@"UITableViewCellContentView"]) {
        return NO;
    }
    return YES;
}

- (void)timeBtnClick:(UIButton *)btn {
    if (btn.tag == 0) {
        if (_delegate && [_delegate respondsToSelector:@selector(selectTime:)]) {
            [_delegate selectTime:self];
        }
    }
}

- (void)twistBtnClick:(UIButton *)btn {
    if (btn.tag == 0) {
        if (_delegate && [_delegate respondsToSelector:@selector(selectTwist:)]) {
            [_delegate selectTwist:self];
        }
    }
}

- (void)hdlyBtnClick:(UIButton *)btn {
    if (btn.tag == 0) {
        if (_delegate && [_delegate respondsToSelector:@selector(selectHdly:)]) {
            [_delegate selectHdly:self];
        }
    }
}

- (void)changBtnClick:(id)sender {
    [self.delegate changeBtnAction:self.indexPath model:self.model];
}

- (void)addBtnClick:(id)sender {
    [self.delegate addAIBtnAction:self.indexPath model:self.model];
}

- (void)cancelBtnClick:(id)sender {
    [self.delegate removeBtnAction:self];
}

- (void)selectBtnClick:(UIButton *)sender {
    [self.delegate selectBtnAction:self.indexPath model:self.model];
}

@end
