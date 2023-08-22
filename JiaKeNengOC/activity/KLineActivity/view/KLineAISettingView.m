//
//  KLineAISettingView.m
//  JiaKeNengOC
//
//  Created by jkn-mac on 2023/8/16.
//

#import "KLineAISettingView.h"
#import "NSString+Rect.h"

@interface KLineAISettingView ()

@end

@implementation KLineAISettingView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initView];
    }
    return self;
}

-(void)initView{
    
    self.backgroundColor = PrimaryColor;
    
    self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    self.scrollView.backgroundColor = ClearColor;
    self.scrollView.showsVerticalScrollIndicator = NO;
    self.scrollView.showsHorizontalScrollIndicator = NO;
    [self addSubview:self.scrollView];
    
    CGFloat offsetX = 10;
    for (int i = 0; i < 6; i++) {
        QMUIButton *btn = [QMUIButton buttonWithType:UIButtonTypeCustom];
        btn.tag = i;
        btn.titleLabel.font = MFont(12);
        [btn setTitleColor:GrayColor forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor colorWithHexString:@"#447CFE"] forState:UIControlStateSelected];
        [btn acs_radiusWithRadius:10 corner:UIRectCornerAllCorners];
        [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        if (i == 0) {
            btn.selected = YES;
            [btn setTitle:@"笔" forState:UIControlStateNormal];
            [btn border:1 borderColor:[UIColor colorWithHexString:@"#447CFE"]];
            CGRect rect = [@"笔" getRectWithFontSize:12];
            [btn setFrame:CGRectMake(offsetX, (self.height - 20)/2, rect.size.width + 20, 20)];
        }else if (i == 1) {
            btn.selected = YES;
            [btn setTitle:@"笔中枢" forState:UIControlStateNormal];
            [btn border:1 borderColor:[UIColor colorWithHexString:@"#447CFE"]];
            CGRect rect = [@"笔中枢" getRectWithFontSize:12];
            [btn setFrame:CGRectMake(offsetX, (self.height - 20)/2, rect.size.width + 20, 20)];
        }else if (i == 2) {
            btn.selected = NO;
            [btn setTitle:@"短线王" forState:UIControlStateNormal];
            [btn border:1 borderColor:GrayColor];
            CGRect rect = [@"短线王" getRectWithFontSize:12];
            [btn setFrame:CGRectMake(offsetX, (self.height - 20)/2, rect.size.width + 20, 20)];
        }else if (i == 3) {
            btn.selected = NO;
            [btn setTitle:@"波段王" forState:UIControlStateNormal];
            [btn border:1 borderColor:GrayColor];
            CGRect rect = [@"波段王" getRectWithFontSize:12];
            [btn setFrame:CGRectMake(offsetX, (self.height - 20)/2, rect.size.width + 20, 20)];
        }else if (i == 4) {
            btn.selected = NO;
            [btn setTitle:@"主力三区" forState:UIControlStateNormal];
            [btn border:1 borderColor:GrayColor];
            CGRect rect = [@"主力三区" getRectWithFontSize:12];
            [btn setFrame:CGRectMake(offsetX, (self.height - 20)/2, rect.size.width + 20, 20)];
        }else if (i == 5) {
            btn.selected = NO;
            [btn setTitle:@"主力趋势" forState:UIControlStateNormal];
            [btn border:1 borderColor:GrayColor];
            CGRect rect = [@"主力趋势" getRectWithFontSize:12];
            [btn setFrame:CGRectMake(offsetX, (self.height - 20)/2, rect.size.width + 20, 20)];
        }
        offsetX = btn.rightX + 10;
        
        [self.scrollView addSubview:btn];
    }
    
    self.scrollView.contentSize = CGSizeMake(offsetX + 20, 0);
}

- (void)btnClick:(id)sender {
    UIButton *button = (UIButton *)sender;
    button.selected = !button.selected;
    
    if (button.selected) {
        [button border:1 borderColor:[UIColor colorWithHexString:@"#447CFE"]];
    }else {
        [button border:1 borderColor:GrayColor];
    }
    
    [_delegate settingAIIndex:button.tag hidden:button.selected];
}

@end
