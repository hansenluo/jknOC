//
//  AlarmTwistSelectView.m
//  JiaKeNengOC
//
//  Created by jkn-mac on 2023/8/4.
//

#import "AlarmTwistSelectView.h"

@interface AlarmTwistSelectView ()

@property (nonatomic, weak) IBOutlet QMUIFloatLayoutView *layoutView01;
@property (nonatomic, weak) IBOutlet QMUIFloatLayoutView *layoutView02;
@property (nonatomic, weak) IBOutlet NSLayoutConstraint *heiForFlv01;
@property (nonatomic, weak) IBOutlet NSLayoutConstraint *heiForFlv02;

@property (nonatomic, strong) NSMutableArray *dataArray01;
@property (nonatomic, strong) NSMutableArray *dataArray02;

@end

@implementation AlarmTwistSelectView

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    [self acs_radiusWithRadius:5 corner:UIRectCornerAllCorners];
    self.layoutView01.itemMargins = UIEdgeInsetsMake(5, 5, 5, 5);
    self.layoutView02.itemMargins = UIEdgeInsetsMake(5, 5, 5, 5);
}

- (void)setDataWithArray:(NSMutableArray *)array01 array02:(NSMutableArray *)array02 {
    for (NSInteger idx = 0; idx < array01.count; idx++) {
        StrategyModel *model = array01[idx];
        UIView *view = [self setupViewAWithModel:model idx:idx];
        [self.layoutView01 addSubview:view];
    }
    [self.layoutView01 updateHeight:QMUIViewSelfSizingHeight];
    self.heiForFlv01.constant = self.layoutView01.qmui_height;
    
    for (NSInteger idx = 0; idx < array02.count; idx++) {
        StrategyModel *model = array02[idx];
        UIView *view = [self setupViewBWithModel:model idx:idx];
        [self.layoutView02 addSubview:view];
    }
    [self.layoutView02 updateHeight:QMUIViewSelfSizingHeight];
    self.heiForFlv02.constant = self.layoutView02.qmui_height;
    
    [self layoutIfNeeded];
    self.frame = CGRectMake(0, 0, screenW - 50, self.layoutView02.qmui_bottom + 10);
}

- (UIView *)setupViewAWithModel:(StrategyModel *)model idx:(NSInteger)idx {
    UIView *view  = [[UIView alloc] init];
    view.frame = CGRectMake(0, 0, (screenW - 70)/3, 40);
    view.backgroundColor = ClearColor;
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setFrame:CGRectMake(0, 0, (screenW - 70)/3, 40)];
    button.tag = model.strategyId;
    [button setTitle:model.name forState:UIControlStateNormal];
    [button setTitleColor:WhiteColor forState:UIControlStateNormal];
    button.titleLabel.font = MFont(15);
    if (self.cell.model.duotouId != button.tag) {
        button.backgroundColor = [UIColor colorWithHexString:@"#555555"];
    }else {
        button.backgroundColor = RiseColor;
    }
    [button acs_radiusWithRadius:2 corner:UIRectCornerAllCorners];
    [button addTarget:self action:@selector(button01Click:) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:button];
    
    [self.dataArray01 addObject:button];
    
    return view;
}

- (UIView *)setupViewBWithModel:(StrategyModel *)model idx:(NSInteger)idx {
    UIView *view  = [[UIView alloc] init];
    view.frame = CGRectMake(0, 0, (screenW - 70)/3, 40);
    view.backgroundColor = ClearColor;
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setFrame:CGRectMake(0, 0, (screenW - 70)/3, 40)];
    button.tag = model.strategyId;
    [button setTitle:model.name forState:UIControlStateNormal];
    [button setTitleColor:WhiteColor forState:UIControlStateNormal];
    button.titleLabel.font = MFont(15);
    if (self.cell.model.kongtouId != button.tag) {
        button.backgroundColor = [UIColor colorWithHexString:@"#555555"];
    }else {
        button.backgroundColor = RiseColor;
    }
    [button acs_radiusWithRadius:2 corner:UIRectCornerAllCorners];
    [button addTarget:self action:@selector(button02Click:) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:button];
    
    [self.dataArray02 addObject:button];
    
    return view;
}

- (void)button01Click:(id)sender {
    UIButton *button = (UIButton *)sender;
    
    for (int i = 0; i < self.dataArray02.count; i++) {
        ((UIButton *)self.dataArray02[i]).backgroundColor = [UIColor colorWithHexString:@"#555555"];
    }
    
    if (self.cell.model.duotouId != button.tag) {
        [self.delegate twistBtnAction:button.tag cell:self.cell];
    }else {
        [self.delegate twistBtnAction:0 cell:self.cell];
    }
    [self.superview hidePopView:self];
}

- (void)button02Click:(id)sender {
    UIButton *button = (UIButton *)sender;
    
    for (int i = 0; i < self.dataArray01.count; i++) {
        ((UIButton *)self.dataArray01[i]).backgroundColor = [UIColor colorWithHexString:@"#555555"];
    }
    
    if (self.cell.model.kongtouId != button.tag) {
        [self.delegate twistBtnAction:button.tag cell:self.cell];
    }else {
        [self.delegate twistBtnAction:0 cell:self.cell];
    }
    
    [self.superview hidePopView:self];
}

- (NSMutableArray *)dataArray01 {
    if(!_dataArray01) {
        _dataArray01 = [NSMutableArray array];
    }
    return _dataArray01;
}

- (NSMutableArray *)dataArray02 {
    if(!_dataArray02) {
        _dataArray02 = [NSMutableArray array];
    }
    return _dataArray02;
}

@end
