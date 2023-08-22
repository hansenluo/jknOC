//
//  AlarmHdlySelectView.m
//  JiaKeNengOC
//
//  Created by jkn-mac on 2023/8/4.
//

#import "AlarmHdlySelectView.h"

@interface AlarmHdlySelectView ()

@property (nonatomic, weak) IBOutlet QMUIFloatLayoutView *layoutView;
@property (nonatomic, weak) IBOutlet NSLayoutConstraint *heiForFlv;

@property (nonatomic, strong) NSMutableArray *buttonArray;

@end

@implementation AlarmHdlySelectView

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    [self acs_radiusWithRadius:5 corner:UIRectCornerAllCorners];
    self.layoutView.itemMargins = UIEdgeInsetsMake(5, 5, 5, 5);
}

- (void)setDataWithArray:(NSMutableArray *)array {
    for (NSInteger idx = 0; idx < array.count; idx++) {
        StrategyModel *model = array[idx];
        UIView *view = [self setupViewWithModel:model idx:idx];
        [self.layoutView addSubview:view];
    }
    [self.layoutView updateHeight:QMUIViewSelfSizingHeight];
    self.heiForFlv.constant = self.layoutView.qmui_height;
    self.frame = CGRectMake(0, 0, screenW - 50, self.layoutView.qmui_bottom + 10);
}

- (UIView *)setupViewWithModel:(StrategyModel *)model idx:(NSInteger)idx {
    UIView *view  = [[UIView alloc] init];
    view.frame = CGRectMake(0, 0, (screenW - 70)/3, 40);
    view.backgroundColor = ClearColor;
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setFrame:CGRectMake(0, 0, (screenW - 70)/3, 40)];
    button.tag = model.strategyId;
    [button setTitle:model.name forState:UIControlStateNormal];
    [button setTitleColor:WhiteColor forState:UIControlStateNormal];
    button.titleLabel.font = MFont(15);
    if (self.cell.model.hdlyId != button.tag) {
        button.backgroundColor = [UIColor colorWithHexString:@"#555555"];
    }else {
        button.backgroundColor = RiseColor;
    }
    [button acs_radiusWithRadius:2 corner:UIRectCornerAllCorners];
    [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:button];
    
    [self.buttonArray addObject:button];
    
    return view;
}

- (void)buttonClick:(id)sender {
    UIButton *button = (UIButton *)sender;
    
    if (self.cell.model.hdlyId != button.tag) {
        [self.delegate hdlyBtnAction:button.tag cell:self.cell];
    }else {
        [self.delegate hdlyBtnAction:0 cell:self.cell];
    }
    
    [self.superview hidePopView:self];
}

@end
