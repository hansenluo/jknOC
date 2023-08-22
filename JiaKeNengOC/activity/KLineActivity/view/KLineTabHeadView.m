//
//  KLineTabHeadView.m
//  JiaKeNengOC
//
//  Created by jkn-mac on 2023/6/27.
//

#import "KLineTabHeadView.h"

@interface KLineTabHeadView()

@property (nonatomic, strong) QMUIButton *backBtn;
@property (nonatomic, strong) QMUIButton *searchBtn;
@property (nonatomic, strong) QMUIButton *leftBtn;
@property (nonatomic, strong) QMUIButton *rightBtn;

@end

@implementation KLineTabHeadView

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self initView];
    }
    return self;
}

- (void)initView{
    
    self.layer.masksToBounds = YES;
    self.backgroundColor = PrimaryColor;
    
    //返回按钮
    self.backBtn = [QMUIButton buttonWithType:UIButtonTypeCustom];
    [self.backBtn setImage:[UIImage imageNamed:@"icon_back_btn"] forState:UIControlStateNormal];
    [self.backBtn addTarget:self action:@selector(backBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.backBtn];
    
    //搜索按钮
//    UIImageView *searchImageView = [UIImageView new];
//    [searchImageView setImage:[UIImage imageNamed:@"icon_search"]];
//    searchImageView.image = [UIImage qmui_imageWithColor:WhiteColor];
    
//    self.searchBtn = [QMUIButton buttonWithType:UIButtonTypeCustom];
//    self.searchBtn.hidden = YES;
//    [self.searchBtn setImage:[UIImage imageNamed:@"icon_search"] forState:UIControlStateNormal];
//    [self.searchBtn addTarget:self action:@selector(searchBtnClick) forControlEvents:UIControlEventTouchUpInside];
//    [self addSubview:self.searchBtn];
    
    //主标题
    self.mainTitleLabel = [UILabel new];
    self.mainTitleLabel.text = @"苹果";
    self.mainTitleLabel.textColor = WhiteColor;
    self.mainTitleLabel.font = MWFont(18, UIFontWeightMedium);
    self.mainTitleLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:self.mainTitleLabel];
    
    //副标题
    self.subTitleLabel = [UILabel new];
    self.subTitleLabel.text = @"AAPL";
    self.subTitleLabel.textColor = GrayColor;
    self.subTitleLabel.font = MFont(14);
    self.subTitleLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:self.subTitleLabel];
    
    //左右箭头
//    self.leftBtn = [QMUIButton buttonWithType:UIButtonTypeCustom];
//    self.leftBtn.hidden = YES;
//    [self.leftBtn setImage:[UIImage imageNamed:@"icon_left_arrow"] forState:UIControlStateNormal];
//    [self.leftBtn addTarget:self action:@selector(leftBtnClick) forControlEvents:UIControlEventTouchUpInside];
//    [self addSubview:self.leftBtn];
//
//    self.rightBtn = [QMUIButton buttonWithType:UIButtonTypeCustom];
//    self.rightBtn.hidden = YES;
//    [self.rightBtn setImage:[UIImage imageNamed:@"icon_right_arrow"] forState:UIControlStateNormal];
//    [self.rightBtn addTarget:self action:@selector(rightBtnClick) forControlEvents:UIControlEventTouchUpInside];
//    [self addSubview:self.rightBtn];

    [self mask];
}

- (void)mask{
    [self.backBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(5);
        make.width.height.equalTo(@40);
        make.bottom.equalTo(self);
    }];
    
    [self.subTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.mas_bottom).offset(-5);
//        make.centerX.equalTo(self);
//        make.width.equalTo(@270);
        make.left.equalTo(self.backBtn.mas_right).offset(0);
        make.right.equalTo(self).offset(-45);
        make.height.equalTo(@12);
    }];
    
    [self.mainTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.subTitleLabel.mas_top).offset(-2);
//        make.centerX.equalTo(self);
//        make.width.equalTo(@270);
        make.left.equalTo(self.backBtn.mas_right).offset(0);
        make.right.equalTo(self).offset(-45);
        make.height.equalTo(@18);
    }];
    
//    [self.leftBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.width.height.equalTo(@22);
//        make.right.equalTo(self.mainTitleLabel.mas_left);
//        make.centerY.equalTo(self.backBtn.mas_centerY);
//    }];
//
//    [self.rightBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.width.height.equalTo(@22);
//        make.left.equalTo(self.mainTitleLabel.mas_right);
//        make.centerY.equalTo(self.backBtn.mas_centerY);
//    }];
//
//    [self.searchBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.width.height.equalTo(@22);
//        make.right.equalTo(self.mas_right).offset(-15);
//        make.centerY.equalTo(self.backBtn.mas_centerY);
//    }];
}

#pragma mark ---- 按钮点击 ----
- (void)backBtnClick {
    PopViewController;
}

- (void)leftBtnClick {
    NSLog(@"搜索");
}

- (void)rightBtnClick {
    NSLog(@"搜索");
}

- (void)searchBtnClick {
    if (_delegate && [_delegate respondsToSelector:@selector(searchBtnClick)]) {
        [_delegate searchBtnClick];
    }
}

@end
