//
//  SelectStrategyView.m
//  JiaKeNengOC
//
//  Created by jkn-mac on 2023/8/2.
//

#import "SelectStrategyView.h"
#import "SelectStockModel.h"
#import <WMZDialog/WMZDialog.h>

@interface SelectStrategyView ()

@property (nonatomic, strong) UIView *titleView01;
@property (nonatomic, strong) UIView *titleView02;
@property (nonatomic, strong) UIView *titleView03;
@property (nonatomic, strong) UIView *titleView04;
@property (nonatomic, strong) UIView *titleView05;
@property (nonatomic, strong) UIView *titleView06;

@property (nonatomic, strong) QMUIButton *titleBtn01;
@property (nonatomic, strong) QMUIButton *titleBtn02;
@property (nonatomic, strong) QMUIButton *titleBtn03;
@property (nonatomic, strong) QMUIButton *titleBtn04;
@property (nonatomic, strong) QMUIButton *titleBtn05;
@property (nonatomic, strong) QMUIButton *titleBtn06;

@property (nonatomic, strong) UIButton *lastButtonA;
@property (nonatomic, strong) UIButton *lastButtonB;
@property (nonatomic, strong) UIButton *lastButtonC;
@property (nonatomic, strong) UIButton *lastButtonD;

@property (nonatomic, strong) UIButton *titleBtnBB;
@property (nonatomic, strong) UIButton *titleBtnCC;

@property (nonatomic, strong) QMUIFloatLayoutView *layoutView01;
@property (nonatomic, strong) QMUIFloatLayoutView *layoutView02;
@property (nonatomic, strong) QMUIFloatLayoutView *layoutView03;
@property (nonatomic, strong) QMUIFloatLayoutView *layoutView04;

@property (nonatomic, strong) NSMutableArray *buttonArray01;
@property (nonatomic, strong) NSMutableArray *buttonArray02;
@property (nonatomic, strong) NSMutableArray *buttonArray03;
@property (nonatomic, strong) NSMutableArray *buttonArray04;

@property (nonatomic, strong) UIScrollView *scrollView;

@property (nonatomic, strong) NSString *timeId;
@property (nonatomic, strong) NSString *twistId;
@property (nonatomic, strong) NSString *hdlyId;
@property (nonatomic, strong) NSString *zoneId;
@property (nonatomic, strong) NSString *startDate;
@property (nonatomic, strong) NSString *endDate;

@end

@implementation SelectStrategyView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initView];
    }
    return self;
}

-(void)initView{
    
    self.backgroundColor = ClearColor;
    
    self.timeId = @"";
    self.twistId = @"0";
    self.hdlyId = @"0";
    self.zoneId = @"0";
    self.startDate = @"2020/01/01";
    
    NSDate *date = [NSDate date];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy/MM/dd"];
    self.endDate = [formatter stringFromDate:date];
    
    self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, screenW, self.size.height - 55)];
    [self addSubview:self.scrollView];
    
    [self addTitleView];
    
    UIButton *cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [cancelBtn setFrame:CGRectMake(10, self.size.height - 45, (screenW - 30)/2, 35)];
    [cancelBtn setTitle:@"清空选择" forState:UIControlStateNormal];
    [cancelBtn setTitleColor:[UIColor colorWithHexString:@"#888888"] forState:UIControlStateNormal];
    cancelBtn.titleLabel.font = MFont(16);
    [cancelBtn border:1 borderColor:[UIColor colorWithHexString:@"#555555"]];
    [cancelBtn acs_radiusWithRadius:2 corner:UIRectCornerAllCorners];
    [cancelBtn addTarget:self action:@selector(cancelBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:cancelBtn];
    
    UIButton *confirmBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [confirmBtn setFrame:CGRectMake(cancelBtn.rightX + 10, self.size.height - 45, (screenW - 30)/2, 35)];
    [confirmBtn setTitle:@"确定" forState:UIControlStateNormal];
    [confirmBtn setTitleColor:WhiteColor forState:UIControlStateNormal];
    confirmBtn.backgroundColor = RiseColor;
    confirmBtn.titleLabel.font = MFont(16);
    [confirmBtn acs_radiusWithRadius:2 corner:UIRectCornerAllCorners];
    [confirmBtn addTarget:self action:@selector(confirmBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:confirmBtn];
}

- (void)addTitleView {
    //01
    self.titleView01 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, screenW, 45)];
    self.titleView01.backgroundColor = ClearColor;
    
    UILabel *titleLab01 = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, screenW - 150, 45)];
    titleLab01.text = @"一、选择周期";
    titleLab01.textColor = WhiteColor;
    titleLab01.font = MFont(16);
    [self.titleView01 addSubview:titleLab01];
    
    self.titleBtn01 = [QMUIButton buttonWithType:UIButtonTypeCustom];
    [self.titleBtn01 setFrame:CGRectMake(screenW - 130, 0, 120, 45)];
    //[self.titleBtn01 setImage:[UIImage imageNamed:@"icon_gray_arrow"] forState:UIControlStateNormal];
    [self.titleBtn01 setTitle:@"请选择" forState:UIControlStateNormal];
    [self.titleBtn01 setTitleColor:WhiteColor forState:UIControlStateNormal];
    self.titleBtn01.titleLabel.font = MFont(16);
    self.titleBtn01.imagePosition = QMUIButtonImagePositionRight;
    self.titleBtn01.spacingBetweenImageAndTitle = 5;
    self.titleBtn01.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    //[self.titleBtn01 addTarget:self action:@selector(titleBtn01Click:) forControlEvents:UIControlEventTouchUpInside];
    [self.titleView01 addSubview:self.titleBtn01];
    
    UIView *lineView01 = [[UIView alloc] initWithFrame:CGRectMake(0, self.titleView01.size.height - 1, screenW, 0.5)];
    lineView01.backgroundColor = [UIColor colorWithHexString:@"#2A2E37"];
    [self.titleView01 addSubview:lineView01];
    [self.scrollView addSubview:self.titleView01];
    
    self.layoutView01 = [[QMUIFloatLayoutView alloc] initWithFrame:CGRectMake(0, self.titleView01.BottomY, screenW, 0)];
    //self.layoutView01.hidden = YES;
    self.layoutView01.padding = UIEdgeInsetsMake(10, 10, 10, 10);
    self.layoutView01.itemMargins = UIEdgeInsetsMake(5, 10, 5, 0);
    self.layoutView01.backgroundColor = [UIColor colorWithHexString:@"#202122"];
    [self.scrollView addSubview:self.layoutView01];
    
    //02
    self.titleView02 = [[UIView alloc] initWithFrame:CGRectMake(0, self.titleBtn01.BottomY, screenW, 45)];
    self.titleView02.backgroundColor = ClearColor;
    
    UILabel *titleLab02 = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, screenW - 150, 45)];
    titleLab02.text = @"二、选股方式(1):多头策略";
    titleLab02.textColor = WhiteColor;
    titleLab02.font = MFont(16);
    [self.titleView02 addSubview:titleLab02];
    
    self.titleBtn02 = [QMUIButton buttonWithType:UIButtonTypeCustom];
    [self.titleBtn02 setFrame:CGRectMake(screenW - 150, 0, 140, 45)];
    //[self.titleBtn02 setImage:[UIImage imageNamed:@"icon_gray_arrow"] forState:UIControlStateNormal];
    [self.titleBtn02 setTitle:@"请选择" forState:UIControlStateNormal];
    [self.titleBtn02 setTitleColor:WhiteColor forState:UIControlStateNormal];
    self.titleBtn02.titleLabel.font = MFont(16);
    self.titleBtn02.imagePosition = QMUIButtonImagePositionRight;
    self.titleBtn02.spacingBetweenImageAndTitle = 5;
    self.titleBtn02.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    //[self.titleBtn02 addTarget:self action:@selector(titleBtn02Click:) forControlEvents:UIControlEventTouchUpInside];
    [self.titleView02 addSubview:self.titleBtn02];
    
    UIView *lineView02 = [[UIView alloc] initWithFrame:CGRectMake(0, self.titleView02.size.height - 1, screenW, 0.5)];
    lineView02.backgroundColor = [UIColor colorWithHexString:@"#2A2E37"];
    [self.titleView02 addSubview:lineView02];
    [self.scrollView addSubview:self.titleView02];
    
    self.layoutView02 = [[QMUIFloatLayoutView alloc] initWithFrame:CGRectMake(0, self.titleView02.BottomY, screenW, 0)];
    //self.layoutView02.hidden = YES;
    self.layoutView02.padding = UIEdgeInsetsMake(10, 10, 10, 10);
    self.layoutView02.itemMargins = UIEdgeInsetsMake(5, 10, 5, 0);
    self.layoutView02.backgroundColor = [UIColor colorWithHexString:@"#202122"];
    [self.scrollView addSubview:self.layoutView02];
    
    //3
    self.titleView03 = [[UIView alloc] initWithFrame:CGRectMake(0, self.titleView02.BottomY, screenW, 45)];
    self.titleView03.backgroundColor = ClearColor;
    
    UILabel *titleLab03 = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, screenW - 150, 45)];
    titleLab03.text = @"三、选股方式(2):空头策略";
    titleLab03.textColor = WhiteColor;
    titleLab03.font = MFont(16);
    [self.titleView03 addSubview:titleLab03];
    
    self.titleBtn03 = [QMUIButton buttonWithType:UIButtonTypeCustom];
    [self.titleBtn03 setFrame:CGRectMake(screenW - 150, 0, 140, 45)];
    //[self.titleBtn03 setImage:[UIImage imageNamed:@"icon_gray_arrow"] forState:UIControlStateNormal];
    [self.titleBtn03 setTitle:@"请选择" forState:UIControlStateNormal];
    [self.titleBtn03 setTitleColor:WhiteColor forState:UIControlStateNormal];
    self.titleBtn03.titleLabel.font = MFont(16);
    self.titleBtn03.imagePosition = QMUIButtonImagePositionRight;
    self.titleBtn03.spacingBetweenImageAndTitle = 5;
    self.titleBtn03.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    //[self.titleBtn03 addTarget:self action:@selector(titleBtn03Click:) forControlEvents:UIControlEventTouchUpInside];
    [self.titleView03 addSubview:self.titleBtn03];
    
    UIView *lineView03 = [[UIView alloc] initWithFrame:CGRectMake(0, self.titleView03.size.height - 1, screenW, 0.5)];
    lineView03.backgroundColor = [UIColor colorWithHexString:@"#2A2E37"];
    [self.titleView03 addSubview:lineView03];
    [self.scrollView addSubview:self.titleView03];
    
    self.layoutView03 = [[QMUIFloatLayoutView alloc] initWithFrame:CGRectMake(0, self.titleView03.BottomY, screenW, 0)];
    //self.layoutView03.hidden = YES;
    self.layoutView03.padding = UIEdgeInsetsMake(10, 10, 10, 10);
    self.layoutView03.itemMargins = UIEdgeInsetsMake(5, 10, 5, 0);
    self.layoutView03.backgroundColor = [UIColor colorWithHexString:@"#202122"];
    [self.scrollView addSubview:self.layoutView03];
    
    //4
    self.titleView04 = [[UIView alloc] initWithFrame:CGRectMake(0, self.titleView03.BottomY, screenW, 45)];
    self.titleView04.backgroundColor = ClearColor;
    
    UILabel *titleLab04 = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, screenW - 150, 45)];
    titleLab04.text = @"四、选股方式(3):抄底专用";
    titleLab04.textColor = WhiteColor;
    titleLab04.font = MFont(16);
    [self.titleView04 addSubview:titleLab04];
    
    self.titleBtn04 = [QMUIButton buttonWithType:UIButtonTypeCustom];
    [self.titleBtn04 setFrame:CGRectMake(screenW - 130, 0, 120, 45)];
    //[self.titleBtn04 setImage:[UIImage imageNamed:@"icon_gray_arrow"] forState:UIControlStateNormal];
    [self.titleBtn04 setTitle:@"请选择" forState:UIControlStateNormal];
    [self.titleBtn04 setTitleColor:WhiteColor forState:UIControlStateNormal];
    self.titleBtn04.titleLabel.font = MFont(16);
    self.titleBtn04.imagePosition = QMUIButtonImagePositionRight;
    self.titleBtn04.spacingBetweenImageAndTitle = 5;
    self.titleBtn04.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    //[self.titleBtn04 addTarget:self action:@selector(titleBtn04Click:) forControlEvents:UIControlEventTouchUpInside];
    [self.titleView04 addSubview:self.titleBtn04];
    
    UIView *lineView04 = [[UIView alloc] initWithFrame:CGRectMake(0, self.titleView04.size.height - 1, screenW, 0.5)];
    lineView04.backgroundColor = [UIColor colorWithHexString:@"#2A2E37"];
    [self.titleView04 addSubview:lineView04];
    [self.scrollView addSubview:self.titleView04];
    
    self.layoutView04 = [[QMUIFloatLayoutView alloc] initWithFrame:CGRectMake(0, self.titleView04.BottomY, screenW, 0)];
    //self.layoutView04.hidden = YES;
    self.layoutView04.padding = UIEdgeInsetsMake(10, 10, 10, 10);
    self.layoutView04.itemMargins = UIEdgeInsetsMake(5, 10, 5, 0);
    self.layoutView04.backgroundColor = [UIColor colorWithHexString:@"#202122"];
    [self.scrollView addSubview:self.layoutView04];
    
    //5
    self.titleView05 = [[UIView alloc] initWithFrame:CGRectMake(0, self.titleView04.BottomY, screenW, 45)];
    self.titleView05.backgroundColor = ClearColor;
    
    UILabel *titleLab05 = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, screenW - 150, 45)];
    titleLab05.text = @"五、开始时间";
    titleLab05.textColor = WhiteColor;
    titleLab05.font = MFont(16);
    [self.titleView05 addSubview:titleLab05];
    
    self.titleBtn05 = [QMUIButton buttonWithType:UIButtonTypeCustom];
    [self.titleBtn05 setFrame:CGRectMake(screenW - 130, 0, 120, 45)];
    [self.titleBtn05 setImage:[UIImage imageNamed:@"icon_gray_arrow"] forState:UIControlStateNormal];
    [self.titleBtn05 setTitle:self.startDate forState:UIControlStateNormal];
    [self.titleBtn05 setTitleColor:WhiteColor forState:UIControlStateNormal];
    self.titleBtn05.titleLabel.font = MFont(16);
    self.titleBtn05.imagePosition = QMUIButtonImagePositionRight;
    self.titleBtn05.spacingBetweenImageAndTitle = 5;
    self.titleBtn05.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    [self.titleBtn05 addTarget:self action:@selector(titleBtn05Click:) forControlEvents:UIControlEventTouchUpInside];
    [self.titleView05 addSubview:self.titleBtn05];
    
    UIView *lineView05 = [[UIView alloc] initWithFrame:CGRectMake(0, self.titleView05.size.height - 1, screenW, 0.5)];
    lineView05.backgroundColor = [UIColor colorWithHexString:@"#2A2E37"];
    [self.titleView05 addSubview:lineView05];
    [self.scrollView addSubview:self.titleView05];
    
    //6
    self.titleView06 = [[UIView alloc] initWithFrame:CGRectMake(0, self.titleView05.BottomY, screenW, 45)];
    self.titleView06.backgroundColor = ClearColor;
    
    UILabel *titleLab06 = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, screenW - 150, 45)];
    titleLab06.text = @"六、结束时间";
    titleLab06.textColor = WhiteColor;
    titleLab06.font = MFont(16);
    [self.titleView06 addSubview:titleLab06];
    
    self.titleBtn06 = [QMUIButton buttonWithType:UIButtonTypeCustom];
    [self.titleBtn06 setFrame:CGRectMake(screenW - 130, 0, 120, 45)];
    [self.titleBtn06 setImage:[UIImage imageNamed:@"icon_gray_arrow"] forState:UIControlStateNormal];
    [self.titleBtn06 setTitle:self.endDate forState:UIControlStateNormal];
    [self.titleBtn06 setTitleColor:WhiteColor forState:UIControlStateNormal];
    self.titleBtn06.titleLabel.font = MFont(16);
    self.titleBtn06.imagePosition = QMUIButtonImagePositionRight;
    self.titleBtn06.spacingBetweenImageAndTitle = 5;
    self.titleBtn06.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    [self.titleBtn06 addTarget:self action:@selector(titleBtn06Click:) forControlEvents:UIControlEventTouchUpInside];
    [self.titleView06 addSubview:self.titleBtn06];
    [self.scrollView addSubview:self.titleView06];
    
    self.scrollView.contentSize = CGSizeMake(0, self.titleView06.BottomY + 20);
}

- (void)setDataWithArray:(NSMutableArray *)array01 array02:(NSMutableArray *)array02 array03:(NSMutableArray *)array03 array04:(NSMutableArray *)array04 {
    
    [self cancelBtnClick:nil];
    [self.layoutView01 removeAllSubviews];
    [self.layoutView02 removeAllSubviews];
    [self.layoutView03 removeAllSubviews];
    [self.layoutView04 removeAllSubviews];
    [self.buttonArray01 removeAllObjects];
    [self.buttonArray02 removeAllObjects];
    [self.buttonArray03 removeAllObjects];
    [self.buttonArray04 removeAllObjects];
    
    for (NSInteger idx = 0; idx < array01.count; idx++) {
        StrategyModel *model = array01[idx];
        UIView *view = [self setupAViewWithModel:model idx:idx];
        [self.layoutView01 addSubview:view];
    }
    [self.layoutView01 updateHeight:QMUIViewSelfSizingHeight];
    
    for (NSInteger idx = 0; idx < array02.count; idx++) {
        StrategyModel *model = array02[idx];
        UIView *view = [self setupBViewWithModel:model idx:idx];
        [self.layoutView02 addSubview:view];
    }
    [self.layoutView02 updateHeight:QMUIViewSelfSizingHeight];
    
    for (NSInteger idx = 0; idx < array03.count; idx++) {
        StrategyModel *model = array03[idx];
        UIView *view = [self setupCViewWithModel:model idx:idx];
        [self.layoutView03 addSubview:view];
    }
    [self.layoutView03 updateHeight:QMUIViewSelfSizingHeight];
    
    for (NSInteger idx = 0; idx < array04.count; idx++) {
        StrategyModel *model = array04[idx];
        UIView *view = [self setupDViewWithModel:model idx:idx];
        [self.layoutView04 addSubview:view];
    }
    [self.layoutView04 updateHeight:QMUIViewSelfSizingHeight];
    
    self.titleView02.frame = CGRectMake(0, self.layoutView01.BottomY, screenW, 45);
    self.layoutView02.frame = CGRectMake(0, self.titleView02.BottomY, screenW, self.layoutView02.frame.size.height);
    self.titleView03.frame = CGRectMake(0, self.layoutView02.BottomY, screenW, 45);
    self.layoutView03.frame = CGRectMake(0, self.titleView03.BottomY, screenW, self.layoutView03.frame.size.height);
    self.titleView04.frame = CGRectMake(0, self.layoutView03.BottomY, screenW, 45);
    self.layoutView04.frame = CGRectMake(0, self.titleView04.BottomY, screenW, self.layoutView04.frame.size.height);
    self.titleView05.frame = CGRectMake(0, self.layoutView04.BottomY, screenW, 45);
    self.titleView06.frame = CGRectMake(0, self.titleView05.BottomY, screenW, 45);
    
    self.scrollView.contentSize = CGSizeMake(0, self.titleView06.BottomY + 20);
}

- (UIView *)setupAViewWithModel:(StrategyModel *)model idx:(NSInteger)idx {
    UIView *view  = [[UIView alloc] init];
    view.frame = CGRectMake(0, 0, (screenW - 50)/4, 40);
    view.backgroundColor = ClearColor;
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setFrame:CGRectMake(0, 0, (screenW - 50)/4, 40)];
    button.tag = model.strategyId;
    button.enabled = model.usable;
    if (!model.usable) {
        button.alpha = 0.3;
    }
    [button setTitle:model.name forState:UIControlStateNormal];
    [button setTitleColor:[UIColor colorWithHexString:@"#9096A0"] forState:UIControlStateNormal];
    button.titleLabel.font = MFont(15);
    [button acs_radiusWithRadius:2 corner:UIRectCornerAllCorners];
    [button border:1 borderColor:[UIColor colorWithHexString:@"#9096A0"]];
    [button addTarget:self action:@selector(buttonAClick:) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:button];
    
    [self.buttonArray01 addObject:button];
    
    return view;
}

- (UIView *)setupBViewWithModel:(StrategyModel *)model idx:(NSInteger)idx {
    UIView *view  = [[UIView alloc] init];
    view.frame = CGRectMake(0, 0, (screenW - 50)/4, 40);
    view.backgroundColor = ClearColor;
    
    if (idx == 11) {
        self.titleBtnBB = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.titleBtnBB setFrame:CGRectMake(0, 0, (screenW - 50)/4, 40)];
        self.titleBtnBB.tag = model.strategyId;
        self.titleBtnBB.enabled = model.usable;
        if (!model.usable) {
            self.titleBtnBB.alpha = 0.3;
        }
        [self.titleBtnBB setTitle:model.name forState:UIControlStateNormal];
        [self.titleBtnBB setTitleColor:[UIColor colorWithHexString:@"#9096A0"] forState:UIControlStateNormal];
        self.titleBtnBB.titleLabel.font = MFont(15);
        [self.titleBtnBB acs_radiusWithRadius:2 corner:UIRectCornerAllCorners];
        [self.titleBtnBB border:1 borderColor:[UIColor colorWithHexString:@"#9096A0"]];
        [self.titleBtnBB addTarget:self action:@selector(buttonBBClick:) forControlEvents:UIControlEventTouchUpInside];
        [view addSubview:self.titleBtnBB];
    }else {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setFrame:CGRectMake(0, 0, (screenW - 50)/4, 40)];
        button.tag = model.strategyId;
        button.enabled = model.usable;
        if (!model.usable) {
            button.alpha = 0.3;
        }
        [button setTitle:model.name forState:UIControlStateNormal];
        [button setTitleColor:[UIColor colorWithHexString:@"#9096A0"] forState:UIControlStateNormal];
        button.titleLabel.font = MFont(15);
        [button acs_radiusWithRadius:2 corner:UIRectCornerAllCorners];
        [button border:1 borderColor:[UIColor colorWithHexString:@"#9096A0"]];
        [button addTarget:self action:@selector(buttonBClick:) forControlEvents:UIControlEventTouchUpInside];
        [view addSubview:button];
        
        [self.buttonArray02 addObject:button];
    }
    
    return view;
}

- (UIView *)setupCViewWithModel:(StrategyModel *)model idx:(NSInteger)idx {
    UIView *view  = [[UIView alloc] init];
    view.frame = CGRectMake(0, 0, (screenW - 50)/4, 40);
    view.backgroundColor = ClearColor;
    
    if (idx == 11) {
        self.titleBtnCC = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.titleBtnCC setFrame:CGRectMake(0, 0, (screenW - 50)/4, 40)];
        self.titleBtnCC.tag = model.strategyId;
        self.titleBtnCC.enabled = model.usable;
        if (!model.usable) {
            self.titleBtnCC.alpha = 0.3;
        }
        [self.titleBtnCC setTitle:model.name forState:UIControlStateNormal];
        [self.titleBtnCC setTitleColor:[UIColor colorWithHexString:@"#9096A0"] forState:UIControlStateNormal];
        self.titleBtnCC.titleLabel.font = MFont(15);
        [self.titleBtnCC acs_radiusWithRadius:2 corner:UIRectCornerAllCorners];
        [self.titleBtnCC border:1 borderColor:[UIColor colorWithHexString:@"#9096A0"]];
        [self.titleBtnCC addTarget:self action:@selector(buttonCCClick:) forControlEvents:UIControlEventTouchUpInside];
        [view addSubview:self.titleBtnCC];
    }else {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setFrame:CGRectMake(0, 0, (screenW - 50)/4, 40)];
        button.tag = model.strategyId - 12;
        button.enabled = model.usable;
        if (!model.usable) {
            button.alpha = 0.3;
        }
        [button setTitle:model.name forState:UIControlStateNormal];
        [button setTitleColor:[UIColor colorWithHexString:@"#9096A0"] forState:UIControlStateNormal];
        button.titleLabel.font = MFont(15);
        [button acs_radiusWithRadius:2 corner:UIRectCornerAllCorners];
        [button border:1 borderColor:[UIColor colorWithHexString:@"#9096A0"]];
        [button addTarget:self action:@selector(buttonCClick:) forControlEvents:UIControlEventTouchUpInside];
        [view addSubview:button];
        
        [self.buttonArray03 addObject:button];
    }
    
    return view;
}

- (UIView *)setupDViewWithModel:(StrategyModel *)model idx:(NSInteger)idx {
    UIView *view  = [[UIView alloc] init];
    view.frame = CGRectMake(0, 0, (screenW - 50)/4, 40);
    view.backgroundColor = ClearColor;
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setFrame:CGRectMake(0, 0, (screenW - 50)/4, 40)];
    button.tag = model.strategyId;
    button.enabled = model.usable;
    if (!model.usable) {
        button.alpha = 0.3;
    }
    [button setTitle:model.name forState:UIControlStateNormal];
    [button setTitleColor:[UIColor colorWithHexString:@"#9096A0"] forState:UIControlStateNormal];
    button.titleLabel.font = MFont(15);
    [button acs_radiusWithRadius:2 corner:UIRectCornerAllCorners];
    [button border:1 borderColor:[UIColor colorWithHexString:@"#9096A0"]];
    [button addTarget:self action:@selector(buttonDClick:) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:button];
    
    [self.buttonArray04 addObject:button];
    
    return view;
}

#pragma mark ---- 按钮点击 ----
- (void)cancelBtnClick:(id)sender {
    for (int i = 0; i < self.buttonArray01.count; i++) {
        [(UIButton *)self.buttonArray01[i] setTitleColor:[UIColor colorWithHexString:@"#9096A0"] forState:UIControlStateNormal];
        [(UIButton *)self.buttonArray01[i] border:1 borderColor:[UIColor colorWithHexString:@"#9096A0"]];
    }
    
    for (int i = 0; i < self.buttonArray02.count; i++) {
        [(UIButton *)self.buttonArray02[i] setTitleColor:[UIColor colorWithHexString:@"#9096A0"] forState:UIControlStateNormal];
        [(UIButton *)self.buttonArray02[i] border:1 borderColor:[UIColor colorWithHexString:@"#9096A0"]];
    }
    
    for (int i = 0; i < self.buttonArray03.count; i++) {
        [(UIButton *)self.buttonArray03[i] setTitleColor:[UIColor colorWithHexString:@"#9096A0"] forState:UIControlStateNormal];
        [(UIButton *)self.buttonArray03[i] border:1 borderColor:[UIColor colorWithHexString:@"#9096A0"]];
    }
    
    for (int i = 0; i < self.buttonArray04.count; i++) {
        [(UIButton *)self.buttonArray04[i] setTitleColor:[UIColor colorWithHexString:@"#9096A0"] forState:UIControlStateNormal];
        [(UIButton *)self.buttonArray04[i] border:1 borderColor:[UIColor colorWithHexString:@"#9096A0"]];
    }
    
    [self.titleBtnBB setTitleColor:[UIColor colorWithHexString:@"#9096A0"] forState:UIControlStateNormal];
    [self.titleBtnBB border:1 borderColor:[UIColor colorWithHexString:@"#9096A0"]];
    self.titleBtnBB.selected = NO;
    
    [self.titleBtnCC setTitleColor:[UIColor colorWithHexString:@"#9096A0"] forState:UIControlStateNormal];
    [self.titleBtnCC border:1 borderColor:[UIColor colorWithHexString:@"#9096A0"]];
    self.titleBtnCC.selected = NO;
    
    self.timeId = @"";
    self.twistId = @"0";
    self.hdlyId = @"0";
    self.zoneId = @"0";
    
    self.lastButtonA = nil;
    self.lastButtonB = nil;
    self.lastButtonC = nil;
    self.lastButtonD = nil;
    
    [self.titleBtn01 setTitle:@"请选择" forState:UIControlStateNormal];
    [self.titleBtn02 setTitle:@"请选择" forState:UIControlStateNormal];
    [self.titleBtn03 setTitle:@"请选择" forState:UIControlStateNormal];
    [self.titleBtn04 setTitle:@"请选择" forState:UIControlStateNormal];
    [self.titleBtn01 setTitleColor:WhiteColor forState:UIControlStateNormal];
    [self.titleBtn02 setTitleColor:WhiteColor forState:UIControlStateNormal];
    [self.titleBtn03 setTitleColor:WhiteColor forState:UIControlStateNormal];
    [self.titleBtn04 setTitleColor:WhiteColor forState:UIControlStateNormal];
}

- (void)confirmBtnClick:(id)sender {
    //NSLog(@"self.timeId = %@, self.twistId = %@, self.zoneId = %@, self.hdlyId = %@, self.startDate = %@, self.endDate = %@",self.timeId,self.twistId,self.zoneId,self.hdlyId,self.startDate,self.endDate);
    [self.delegate confirmBtnAction:self.timeId twistId:self.twistId hdlyId:self.hdlyId zoneId:self.zoneId startDate:self.startDate endDate:self.endDate];
}

- (void)titleBtn01Click:(id)sender {
    self.titleBtn01.selected = !self.titleBtn01.selected;
    self.titleBtn02.selected = NO;
    self.titleBtn03.selected = NO;
    self.titleBtn04.selected = NO;
    self.titleBtn02.imageView.transform = CGAffineTransformIdentity;
    self.titleBtn03.imageView.transform = CGAffineTransformIdentity;
    self.titleBtn04.imageView.transform = CGAffineTransformIdentity;
    
    self.layoutView02.hidden = YES;
    self.layoutView03.hidden = YES;
    self.layoutView04.hidden = YES;
    
    if (self.titleBtn01.selected) {
        self.layoutView01.hidden = NO;
        self.titleView02.frame = CGRectMake(0, self.layoutView01.BottomY, screenW, 45);
        self.titleView03.frame = CGRectMake(0, self.titleView02.BottomY, screenW, 45);
        self.titleView04.frame = CGRectMake(0, self.titleView03.BottomY, screenW, 45);
        self.titleView05.frame = CGRectMake(0, self.titleView04.BottomY, screenW, 45);
        self.titleView06.frame = CGRectMake(0, self.titleView05.BottomY, screenW, 45);
        self.titleBtn01.imageView.transform = CGAffineTransformMakeRotation(M_PI);
    }else {
        self.layoutView01.hidden = YES;
        self.titleView02.frame = CGRectMake(0, self.titleView01.BottomY, screenW, 45);
        self.titleView03.frame = CGRectMake(0, self.titleView02.BottomY, screenW, 45);
        self.titleView04.frame = CGRectMake(0, self.titleView03.BottomY, screenW, 45);
        self.titleView05.frame = CGRectMake(0, self.titleView04.BottomY, screenW, 45);
        self.titleView06.frame = CGRectMake(0, self.titleView05.BottomY, screenW, 45);
        self.titleBtn01.imageView.transform = CGAffineTransformIdentity;
    }
    self.scrollView.contentSize = CGSizeMake(0, self.titleView06.BottomY + 20);
}

- (void)titleBtn02Click:(id)sender {
    self.titleBtn02.selected = !self.titleBtn02.selected;
    self.titleBtn01.selected = NO;
    self.titleBtn03.selected = NO;
    self.titleBtn04.selected = NO;
    self.titleBtn01.imageView.transform = CGAffineTransformIdentity;
    self.titleBtn03.imageView.transform = CGAffineTransformIdentity;
    self.titleBtn04.imageView.transform = CGAffineTransformIdentity;
    
    self.layoutView01.hidden = YES;
    self.layoutView03.hidden = YES;
    self.layoutView04.hidden = YES;
    
    if (self.titleBtn02.selected) {
        self.layoutView02.hidden = NO;
        self.titleView02.frame = CGRectMake(0, self.titleView01.BottomY, screenW, 45);
        self.titleView03.frame = CGRectMake(0, self.layoutView02.BottomY, screenW, 45);
        self.titleView04.frame = CGRectMake(0, self.titleView03.BottomY, screenW, 45);
        self.titleView05.frame = CGRectMake(0, self.titleView04.BottomY, screenW, 45);
        self.titleView06.frame = CGRectMake(0, self.titleView05.BottomY, screenW, 45);
        self.titleBtn02.imageView.transform = CGAffineTransformMakeRotation(M_PI);
    }else {
        self.layoutView02.hidden = YES;
        self.titleView02.frame = CGRectMake(0, self.titleView01.BottomY, screenW, 45);
        self.titleView03.frame = CGRectMake(0, self.titleView02.BottomY, screenW, 45);
        self.titleView04.frame = CGRectMake(0, self.titleView03.BottomY, screenW, 45);
        self.titleView05.frame = CGRectMake(0, self.titleView04.BottomY, screenW, 45);
        self.titleView06.frame = CGRectMake(0, self.titleView05.BottomY, screenW, 45);
        self.titleBtn02.imageView.transform = CGAffineTransformIdentity;
    }
    self.scrollView.contentSize = CGSizeMake(0, self.titleView06.BottomY + 20);
}

- (void)titleBtn03Click:(id)sender {
    self.titleBtn03.selected = !self.titleBtn03.selected;
    self.titleBtn01.selected = NO;
    self.titleBtn02.selected = NO;
    self.titleBtn04.selected = NO;
    self.titleBtn01.imageView.transform = CGAffineTransformIdentity;
    self.titleBtn02.imageView.transform = CGAffineTransformIdentity;
    self.titleBtn04.imageView.transform = CGAffineTransformIdentity;
    
    self.layoutView01.hidden = YES;
    self.layoutView02.hidden = YES;
    self.layoutView04.hidden = YES;
    
    if (self.titleBtn03.selected) {
        self.layoutView03.hidden = NO;
        self.titleView02.frame = CGRectMake(0, self.titleView01.BottomY, screenW, 45);
        self.titleView03.frame = CGRectMake(0, self.titleView02.BottomY, screenW, 45);
        self.titleView04.frame = CGRectMake(0, self.layoutView03.BottomY, screenW, 45);
        self.titleView05.frame = CGRectMake(0, self.titleView04.BottomY, screenW, 45);
        self.titleView06.frame = CGRectMake(0, self.titleView05.BottomY, screenW, 45);
        self.titleBtn03.imageView.transform = CGAffineTransformMakeRotation(M_PI);
    }else {
        self.layoutView03.hidden = YES;
        self.titleView02.frame = CGRectMake(0, self.titleView01.BottomY, screenW, 45);
        self.titleView03.frame = CGRectMake(0, self.titleView02.BottomY, screenW, 45);
        self.titleView04.frame = CGRectMake(0, self.titleView03.BottomY, screenW, 45);
        self.titleView05.frame = CGRectMake(0, self.titleView04.BottomY, screenW, 45);
        self.titleView06.frame = CGRectMake(0, self.titleView05.BottomY, screenW, 45);
        self.titleBtn03.imageView.transform = CGAffineTransformIdentity;
    }
    self.scrollView.contentSize = CGSizeMake(0, self.titleView06.BottomY + 20);
}

- (void)titleBtn04Click:(id)sender {
    self.titleBtn04.selected = !self.titleBtn04.selected;
    self.titleBtn01.selected = NO;
    self.titleBtn02.selected = NO;
    self.titleBtn03.selected = NO;
    self.titleBtn01.imageView.transform = CGAffineTransformIdentity;
    self.titleBtn02.imageView.transform = CGAffineTransformIdentity;
    self.titleBtn03.imageView.transform = CGAffineTransformIdentity;
    
    self.layoutView01.hidden = YES;
    self.layoutView02.hidden = YES;
    self.layoutView03.hidden = YES;
    
    if (self.titleBtn04.selected) {
        self.layoutView04.hidden = NO;
        self.titleView02.frame = CGRectMake(0, self.titleView01.BottomY, screenW, 45);
        self.titleView03.frame = CGRectMake(0, self.titleView02.BottomY, screenW, 45);
        self.titleView04.frame = CGRectMake(0, self.titleView03.BottomY, screenW, 45);
        self.titleView05.frame = CGRectMake(0, self.layoutView04.BottomY, screenW, 45);
        self.titleView06.frame = CGRectMake(0, self.titleView05.BottomY, screenW, 45);
        self.titleBtn04.imageView.transform = CGAffineTransformMakeRotation(M_PI);
    }else {
        self.layoutView04.hidden = YES;
        self.titleView02.frame = CGRectMake(0, self.titleView01.BottomY, screenW, 45);
        self.titleView03.frame = CGRectMake(0, self.titleView02.BottomY, screenW, 45);
        self.titleView04.frame = CGRectMake(0, self.titleView03.BottomY, screenW, 45);
        self.titleView05.frame = CGRectMake(0, self.titleView04.BottomY, screenW, 45);
        self.titleView06.frame = CGRectMake(0, self.titleView05.BottomY, screenW, 45);
        self.titleBtn04.imageView.transform = CGAffineTransformIdentity;
    }
    self.scrollView.contentSize = CGSizeMake(0, self.titleView06.BottomY + 20);
}

- (void)titleBtn05Click:(id)sender {
    NSDateFormatter * dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"yyyy/MM/dd"];
    NSDate *dateNotFormatted = [dateFormatter dateFromString:self.startDate];
    
    Dialog()
    .wDefaultDateSet(dateNotFormatted)
    .wDateTimeTypeSet(@"yyyy/MM/dd")
    .wTitleSet(@"")
    .wMessageColorSet(BlackColor)
    .wLineColorSet([UIColor colorWithHexString:@"#CECECE"])
    .wOKColorSet([UIColor colorWithHexString:@"#2898FF"])
    .wOKFontSet(18.11 * screenW/414)
    .wCancelColorSet([UIColor colorWithHexString:@"#2898FF"])
    .wCancelFontSet(18.11 * screenW/414)
    .wHeightSet(300)
    .wPickRepeatSet(NO)
    .wTypeSet(DialogTypeDatePicker)
    .wEventOKFinishSet(^(id anyID, id otherData) {
        
        [self.titleBtn05 setTitle:(NSString *)otherData forState:UIControlStateNormal];
        self.startDate = (NSString *)otherData;
    })
    .wStart();
}

- (void)titleBtn06Click:(id)sender {
    NSDateFormatter * dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"yyyy/MM/dd"];
    NSDate *dateNotFormatted = [dateFormatter dateFromString:self.endDate];
    
    Dialog()
    .wDefaultDateSet(dateNotFormatted)
    .wDateTimeTypeSet(@"yyyy/MM/dd")
    .wTitleSet(@"")
    .wMessageColorSet(BlackColor)
    .wLineColorSet([UIColor colorWithHexString:@"#CECECE"])
    .wOKColorSet([UIColor colorWithHexString:@"#2898FF"])
    .wOKFontSet(18.11 * screenW/414)
    .wCancelColorSet([UIColor colorWithHexString:@"#2898FF"])
    .wCancelFontSet(18.11 * screenW/414)
    .wHeightSet(300)
    .wPickRepeatSet(NO)
    .wTypeSet(DialogTypeDatePicker)
    .wEventOKFinishSet(^(id anyID, id otherData) {
        
        [self.titleBtn06 setTitle:(NSString *)otherData forState:UIControlStateNormal];
        self.endDate = (NSString *)otherData;
    })
    .wStart();
}

- (void)buttonAClick:(id)sender {
    UIButton *button = (UIButton *)sender;
    
    for (int i = 0; i < self.buttonArray01.count; i++) {
        [(UIButton *)self.buttonArray01[i] setTitleColor:[UIColor colorWithHexString:@"#9096A0"] forState:UIControlStateNormal];
        [(UIButton *)self.buttonArray01[i] border:1 borderColor:[UIColor colorWithHexString:@"#9096A0"]];
    }
    
    if (self.lastButtonA.tag != button.tag) {
        [(UIButton *)self.buttonArray01[button.tag-1] setTitleColor:RiseColor forState:UIControlStateNormal];
        [(UIButton *)self.buttonArray01[button.tag-1] border:1 borderColor:RiseColor];
        self.lastButtonA = button;
        
        switch (button.tag) {
            case 1:
                [self.titleBtn01 setTitle:@"1分" forState:UIControlStateNormal];
                break;
            case 2:
                [self.titleBtn01 setTitle:@"3分" forState:UIControlStateNormal];
                break;
            case 3:
                [self.titleBtn01 setTitle:@"5分" forState:UIControlStateNormal];
                break;
            case 4:
                [self.titleBtn01 setTitle:@"10分" forState:UIControlStateNormal];
                break;
            case 5:
                [self.titleBtn01 setTitle:@"15分" forState:UIControlStateNormal];
                break;
            case 6:
                [self.titleBtn01 setTitle:@"30分" forState:UIControlStateNormal];
                break;
            case 7:
                [self.titleBtn01 setTitle:@"60分" forState:UIControlStateNormal];
                break;
            case 8:
                [self.titleBtn01 setTitle:@"240分" forState:UIControlStateNormal];
                break;
            case 9:
                [self.titleBtn01 setTitle:@"日线" forState:UIControlStateNormal];
                break;
            case 10:
                [self.titleBtn01 setTitle:@"周线" forState:UIControlStateNormal];
                break;
            case 11:
                [self.titleBtn01 setTitle:@"月线" forState:UIControlStateNormal];
                break;
            default:
                break;
        }
        
        [self.titleBtn01 setTitleColor:RiseColor forState:UIControlStateNormal];
        self.timeId = [NSString stringWithFormat:@"%ld",button.tag];
    }else {
        self.lastButtonA = nil;
        
        [self.titleBtn01 setTitle:@"请选择" forState:UIControlStateNormal];
        [self.titleBtn01 setTitleColor:WhiteColor forState:UIControlStateNormal];
        self.timeId = @"0";
    }
}
    
- (void)buttonBClick:(id)sender {
    UIButton *button = (UIButton *)sender;
    
    for (int i = 0; i < self.buttonArray03.count; i++) {
        [(UIButton *)self.buttonArray03[i] setTitleColor:[UIColor colorWithHexString:@"#9096A0"] forState:UIControlStateNormal];
        [(UIButton *)self.buttonArray03[i] border:1 borderColor:[UIColor colorWithHexString:@"#9096A0"]];
    }
    [self.titleBtn03 setTitle:@"请选择" forState:UIControlStateNormal];
    [self.titleBtn03 setTitleColor:WhiteColor forState:UIControlStateNormal];
    
    self.titleBtnCC.selected = NO;
    [self.titleBtnCC setTitleColor:[UIColor colorWithHexString:@"#9096A0"] forState:UIControlStateNormal];
    [self.titleBtnCC border:1 borderColor:[UIColor colorWithHexString:@"#9096A0"]];
    
    for (int i = 0; i < self.buttonArray02.count; i++) {
        [(UIButton *)self.buttonArray02[i] setTitleColor:[UIColor colorWithHexString:@"#9096A0"] forState:UIControlStateNormal];
        [(UIButton *)self.buttonArray02[i] border:1 borderColor:[UIColor colorWithHexString:@"#9096A0"]];
    }
    self.lastButtonC = nil;
    
    if (self.lastButtonB.tag != button.tag) {
        [(UIButton *)self.buttonArray02[button.tag-1] setTitleColor:RiseColor forState:UIControlStateNormal];
        [(UIButton *)self.buttonArray02[button.tag-1] border:1 borderColor:RiseColor];
        self.lastButtonB = button;
        
        switch (button.tag) {
            case 1:
                [self.titleBtn02 setTitle:@"小1买" forState:UIControlStateNormal];
                break;
            case 2:
                [self.titleBtn02 setTitle:@"大1买" forState:UIControlStateNormal];
                break;
            case 3:
                [self.titleBtn02 setTitle:@"小3买" forState:UIControlStateNormal];
                break;
            case 4:
                [self.titleBtn02 setTitle:@"大3买" forState:UIControlStateNormal];
                break;
            case 5:
                [self.titleBtn02 setTitle:@"潜力七段" forState:UIControlStateNormal];
                break;
            case 6:
                [self.titleBtn02 setTitle:@"亮绿九段" forState:UIControlStateNormal];
                break;
            case 7:
                [self.titleBtn02 setTitle:@"虚线扩展" forState:UIControlStateNormal];
                break;
            case 8:
                [self.titleBtn02 setTitle:@"混合扩展" forState:UIControlStateNormal];
                break;
            case 9:
                [self.titleBtn02 setTitle:@"小连环马" forState:UIControlStateNormal];
                break;
            case 10:
                [self.titleBtn02 setTitle:@"大连环马" forState:UIControlStateNormal];
                break;
            case 11:
                [self.titleBtn02 setTitle:@"超强核裂变" forState:UIControlStateNormal];
                break;
            case 12:
                [self.titleBtn02 setTitle:@"1区" forState:UIControlStateNormal];
                break;
            default:
                break;
        }
        
        if (self.titleBtnBB.selected) {
            [self.titleBtn02 setTitle:[NSString stringWithFormat:@"%@,%@",self.titleBtn02.titleLabel.text,self.titleBtnBB.titleLabel.text] forState:UIControlStateNormal];
        }
        
        [self.titleBtn02 setTitleColor:RiseColor forState:UIControlStateNormal];
        self.twistId = [NSString stringWithFormat:@"%ld",button.tag];
    }else {
        self.lastButtonB = nil;
        self.twistId = @"0";
        
        if (self.titleBtnBB.selected) {
            [self.titleBtn02 setTitle:[NSString stringWithFormat:@"%@",self.titleBtnBB.titleLabel.text] forState:UIControlStateNormal];

            [self.titleBtn02 setTitleColor:RiseColor forState:UIControlStateNormal];
        }else {
            [self.titleBtn02 setTitle:@"请选择" forState:UIControlStateNormal];
            [self.titleBtn02 setTitleColor:WhiteColor forState:UIControlStateNormal];
        }
    }
}

- (void)buttonCClick:(id)sender {
    UIButton *button = (UIButton *)sender;
    
    for (int i = 0; i < self.buttonArray02.count; i++) {
        [(UIButton *)self.buttonArray02[i] setTitleColor:[UIColor colorWithHexString:@"#9096A0"] forState:UIControlStateNormal];
        [(UIButton *)self.buttonArray02[i] border:1 borderColor:[UIColor colorWithHexString:@"#9096A0"]];
    }
    [self.titleBtn02 setTitle:@"请选择" forState:UIControlStateNormal];
    [self.titleBtn02 setTitleColor:WhiteColor forState:UIControlStateNormal];
    
    self.titleBtnBB.selected = NO;
    [self.titleBtnBB setTitleColor:[UIColor colorWithHexString:@"#9096A0"] forState:UIControlStateNormal];
    [self.titleBtnBB border:1 borderColor:[UIColor colorWithHexString:@"#9096A0"]];
    
    for (int i = 0; i < self.buttonArray03.count; i++) {
        [(UIButton *)self.buttonArray03[i] setTitleColor:[UIColor colorWithHexString:@"#9096A0"] forState:UIControlStateNormal];
        [(UIButton *)self.buttonArray03[i] border:1 borderColor:[UIColor colorWithHexString:@"#9096A0"]];
    }
    self.lastButtonB = nil;
    
    if (self.lastButtonC.tag != button.tag) {
        [(UIButton *)self.buttonArray03[button.tag-1] setTitleColor:RiseColor forState:UIControlStateNormal];
        [(UIButton *)self.buttonArray03[button.tag-1] border:1 borderColor:RiseColor];
        self.lastButtonC = button;
        
        switch (button.tag+12) {
            case 13:
                [self.titleBtn03 setTitle:@"小1卖" forState:UIControlStateNormal];
                break;
            case 14:
                [self.titleBtn03 setTitle:@"大1卖" forState:UIControlStateNormal];
                break;
            case 15:
                [self.titleBtn03 setTitle:@"小3卖" forState:UIControlStateNormal];
                break;
            case 16:
                [self.titleBtn03 setTitle:@"大3卖" forState:UIControlStateNormal];
                break;
            case 17:
                [self.titleBtn03 setTitle:@"潜力七段" forState:UIControlStateNormal];
                break;
            case 18:
                [self.titleBtn03 setTitle:@"紫色空头" forState:UIControlStateNormal];
                break;
            case 19:
                [self.titleBtn03 setTitle:@"虚线扩展" forState:UIControlStateNormal];
                break;
            case 20:
                [self.titleBtn03 setTitle:@"混合扩展" forState:UIControlStateNormal];
                break;
            case 21:
                [self.titleBtn03 setTitle:@"小连环马" forState:UIControlStateNormal];
                break;
            case 22:
                [self.titleBtn03 setTitle:@"大连环马" forState:UIControlStateNormal];
                break;
            case 23:
                [self.titleBtn03 setTitle:@"超强核裂变" forState:UIControlStateNormal];
                break;
            case 24:
                [self.titleBtn03 setTitle:@"-1区" forState:UIControlStateNormal];
                break;
            default:
                break;
        }
        
        if (self.titleBtnCC.selected) {
            [self.titleBtn03 setTitle:[NSString stringWithFormat:@"%@,%@",self.titleBtn03.titleLabel.text,self.titleBtnCC.titleLabel.text] forState:UIControlStateNormal];
        }
        
        [self.titleBtn03 setTitleColor:DropColor forState:UIControlStateNormal];
        self.twistId = [NSString stringWithFormat:@"%ld",button.tag+12];
    }else {
        self.lastButtonC = nil;
        self.twistId = @"0";
        
        if (self.titleBtnCC.selected) {
            [self.titleBtn03 setTitle:[NSString stringWithFormat:@"%@",self.titleBtnCC.titleLabel.text] forState:UIControlStateNormal];
            [self.titleBtn03 setTitleColor:DropColor forState:UIControlStateNormal];
        }else {
            [self.titleBtn03 setTitle:@"请选择" forState:UIControlStateNormal];
            [self.titleBtn03 setTitleColor:WhiteColor forState:UIControlStateNormal];
        }
    }
}

- (void)buttonDClick:(id)sender {
    UIButton *button = (UIButton *)sender;
    
    for (int i = 0; i < self.buttonArray04.count; i++) {
        [(UIButton *)self.buttonArray04[i] setTitleColor:[UIColor colorWithHexString:@"#9096A0"] forState:UIControlStateNormal];
        [(UIButton *)self.buttonArray04[i] border:1 borderColor:[UIColor colorWithHexString:@"#9096A0"]];
    }
    
    if (self.lastButtonD.tag != button.tag) {
        [(UIButton *)self.buttonArray04[button.tag-1] setTitleColor:RiseColor forState:UIControlStateNormal];
        [(UIButton *)self.buttonArray04[button.tag-1] border:1 borderColor:RiseColor];
        self.lastButtonD = button;
        
        switch (button.tag) {
            case 1:
                [self.titleBtn04 setTitle:@"小底" forState:UIControlStateNormal];
                break;
            case 2:
                [self.titleBtn04 setTitle:@"中底" forState:UIControlStateNormal];
                break;
            case 3:
                [self.titleBtn04 setTitle:@"大底" forState:UIControlStateNormal];
                break;
            case 4:
                [self.titleBtn04 setTitle:@"超大底" forState:UIControlStateNormal];
                break;
            default:
                break;
        }
        
        [self.titleBtn04 setTitleColor:RiseColor forState:UIControlStateNormal];
        self.hdlyId = [NSString stringWithFormat:@"%ld",button.tag];
    }else {
        self.lastButtonD = nil;
        
        [self.titleBtn04 setTitle:@"请选择" forState:UIControlStateNormal];
        [self.titleBtn04 setTitleColor:WhiteColor forState:UIControlStateNormal];
        self.hdlyId = @"0";
    }
}

- (void)buttonBBClick:(id)sender {
    self.titleBtnBB.selected = !self.titleBtnBB.selected;
    self.titleBtnCC.selected = NO;
    [self.titleBtn03 setTitle:@"请选择" forState:UIControlStateNormal];
    [self.titleBtn03 setTitleColor:WhiteColor forState:UIControlStateNormal];
    self.lastButtonC = nil;
    
    for (int i = 0; i < self.buttonArray03.count; i++) {
        [(UIButton *)self.buttonArray03[i] setTitleColor:[UIColor colorWithHexString:@"#9096A0"] forState:UIControlStateNormal];
        [(UIButton *)self.buttonArray03[i] border:1 borderColor:[UIColor colorWithHexString:@"#9096A0"]];
    }
    [self.titleBtnCC setTitleColor:[UIColor colorWithHexString:@"#9096A0"] forState:UIControlStateNormal];
    [self.titleBtnCC border:1 borderColor:[UIColor colorWithHexString:@"#9096A0"]];
    
    if (self.titleBtnBB.selected) {
        [self.titleBtnBB setTitleColor:RiseColor forState:UIControlStateNormal];
        [self.titleBtnBB border:1 borderColor:RiseColor];
    }else {
        [self.titleBtnBB setTitleColor:[UIColor colorWithHexString:@"#9096A0"] forState:UIControlStateNormal];
        [self.titleBtnBB border:1 borderColor:[UIColor colorWithHexString:@"#9096A0"]];
    }
    
    if (self.titleBtnBB.selected) {
        if ([self.titleBtn02.titleLabel.text isEqualToString:@"请选择"]) {
            [self.titleBtn02 setTitle:self.titleBtnBB.titleLabel.text forState:UIControlStateNormal];
        }else {
            [self.titleBtn02 setTitle:[NSString stringWithFormat:@"%@,%@",self.titleBtn02.titleLabel.text,self.titleBtnBB.titleLabel.text] forState:UIControlStateNormal];
        }
        
        [self.titleBtn02 setTitleColor:RiseColor forState:UIControlStateNormal];
        self.zoneId = [NSString stringWithFormat:@"%ld",self.titleBtnBB.tag];
    }else {
        if ([self.titleBtn02.titleLabel.text isEqualToString:self.titleBtnBB.titleLabel.text]) {
            [self.titleBtn02 setTitle:@"请选择" forState:UIControlStateNormal];
            [self.titleBtn02 setTitleColor:WhiteColor forState:UIControlStateNormal];
        }else {
            NSArray *arr = [self.titleBtn02.titleLabel.text componentsSeparatedByString:@","];
            [self.titleBtn02 setTitle:arr[0] forState:UIControlStateNormal];
            [self.titleBtn02 setTitleColor:RiseColor forState:UIControlStateNormal];
        }
        self.zoneId = @"0";
    }
}

- (void)buttonCCClick:(id)sender {
    self.titleBtnCC.selected = !self.titleBtnCC.selected;
    self.titleBtnBB.selected = NO;
    [self.titleBtn02 setTitle:@"请选择" forState:UIControlStateNormal];
    [self.titleBtn02 setTitleColor:WhiteColor forState:UIControlStateNormal];
    self.lastButtonB = nil;
    
    for (int i = 0; i < self.buttonArray02.count; i++) {
        [(UIButton *)self.buttonArray02[i] setTitleColor:[UIColor colorWithHexString:@"#9096A0"] forState:UIControlStateNormal];
        [(UIButton *)self.buttonArray02[i] border:1 borderColor:[UIColor colorWithHexString:@"#9096A0"]];
    }
    [self.titleBtnBB setTitleColor:[UIColor colorWithHexString:@"#9096A0"] forState:UIControlStateNormal];
    [self.titleBtnBB border:1 borderColor:[UIColor colorWithHexString:@"#9096A0"]];
    
    if (self.titleBtnCC.selected) {
        [self.titleBtnCC setTitleColor:RiseColor forState:UIControlStateNormal];
        [self.titleBtnCC border:1 borderColor:RiseColor];
    }else {
        [self.titleBtnCC setTitleColor:[UIColor colorWithHexString:@"#9096A0"] forState:UIControlStateNormal];
        [self.titleBtnCC border:1 borderColor:[UIColor colorWithHexString:@"#9096A0"]];
    }
    
    if (self.titleBtnCC.selected) {
        if ([self.titleBtn03.titleLabel.text isEqualToString:@"请选择"]) {
            [self.titleBtn03 setTitle:self.titleBtnCC.titleLabel.text forState:UIControlStateNormal];
        }else {
            [self.titleBtn03 setTitle:[NSString stringWithFormat:@"%@,%@",self.titleBtn03.titleLabel.text,self.titleBtnCC.titleLabel.text] forState:UIControlStateNormal];
        }
        
        [self.titleBtn03 setTitleColor:DropColor forState:UIControlStateNormal];
        self.zoneId = [NSString stringWithFormat:@"%ld",self.titleBtnBB.tag+12];
    }else {
        if ([self.titleBtn03.titleLabel.text isEqualToString:self.titleBtnCC.titleLabel.text]) {
            [self.titleBtn03 setTitle:@"请选择" forState:UIControlStateNormal];
            [self.titleBtn03 setTitleColor:WhiteColor forState:UIControlStateNormal];
        }else {
            NSArray *arr = [self.titleBtn03.titleLabel.text componentsSeparatedByString:@","];
            [self.titleBtn03 setTitle:arr[0] forState:UIControlStateNormal];
            [self.titleBtn03 setTitleColor:DropColor forState:UIControlStateNormal];
        }
        self.zoneId = @"0";
    }
}

#pragma mark ---- 懒加载 ----
- (NSMutableArray *)buttonArray01 {
    if (!_buttonArray01) {
        _buttonArray01 = [NSMutableArray array];
    }
    return _buttonArray01;
}

- (NSMutableArray *)buttonArray02 {
    if (!_buttonArray02) {
        _buttonArray02 = [NSMutableArray array];
    }
    return _buttonArray02;
}

- (NSMutableArray *)buttonArray03 {
    if (!_buttonArray03) {
        _buttonArray03 = [NSMutableArray array];
    }
    return _buttonArray03;
}

- (NSMutableArray *)buttonArray04 {
    if (!_buttonArray04) {
        _buttonArray04 = [NSMutableArray array];
    }
    return _buttonArray04;
}

@end
