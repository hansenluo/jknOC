//
//  KLinePeriodView.m
//  JiaKeNengOC
//
//  Created by jkn-mac on 2023/6/28.
//

#import "KLinePeriodView.h"

@interface KLinePeriodView ()

@property (nonatomic, strong) QMUIPopupMenuView *popDateWindow;

@end

@implementation KLinePeriodView

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.aiBtn.spacingBetweenImageAndTitle = 5;
    self.aiBtn.imagePosition = QMUIButtonImagePositionRight;
    
    self.timeBtn02.selected = YES;
    self.currentButton = self.timeBtn02;
    self.currentButton.tag = 1;
    self.lineViewConstraintX.constant = ((screenW - 135)/5 - 30)/2 + (screenW - 135)/5;
    
    [self initPopDateWindow];
}

- (void)initPopDateWindow {
    //弹窗
    self.popDateWindow = [[QMUIPopupMenuView alloc] init];
    self.popDateWindow.backgroundColor = [UIColor colorWithHexString:@"#262626"];
    self.popDateWindow.automaticallyHidesWhenUserTap = YES;// 点击空白地方消失浮层
    self.popDateWindow.preferLayoutDirection = QMUIPopupContainerViewLayoutDirectionBelow;//
    self.popDateWindow.maximumWidth = 180;
    self.popDateWindow.itemHeight = 40;
    self.popDateWindow.arrowSize = CGSizeMake(8, 3);
    self.popDateWindow.maskViewBackgroundColor = [UIColor clearColor];
    //self.popDateWindow.shouldShowItemSeparator = YES;
    self.popDateWindow.itemTitleColor = [UIColor whiteColor];
    self.popDateWindow.itemTitleFont = MFont(16);
    self.popDateWindow.items = @[[QMUIPopupMenuButtonItem itemWithImage:nil title:@"1m" handler:^(QMUIPopupMenuButtonItem * _Nonnull aItem) {
        [aItem.menuView hideWithAnimated:YES];
        [self resetBtnStuatus:@"1m"];
    }],[QMUIPopupMenuButtonItem itemWithImage:nil title:@"3m" handler:^(QMUIPopupMenuButtonItem * _Nonnull aItem) {
        [aItem.menuView hideWithAnimated:YES];
        [self resetBtnStuatus:@"3m"];
    }],[QMUIPopupMenuButtonItem itemWithImage:nil title:@"10m" handler:^(QMUIPopupMenuButtonItem * _Nonnull aItem) {
        [aItem.menuView hideWithAnimated:YES];
        [self resetBtnStuatus:@"10m"];
    }],[QMUIPopupMenuButtonItem itemWithImage:nil title:@"1小时" handler:^(QMUIPopupMenuButtonItem * _Nonnull aItem) {
        [aItem.menuView hideWithAnimated:YES];
        [self resetBtnStuatus:@"1h"];
    }],[QMUIPopupMenuButtonItem itemWithImage:nil title:@"2小时" handler:^(QMUIPopupMenuButtonItem * _Nonnull aItem) {
        [aItem.menuView hideWithAnimated:YES];
        [self resetBtnStuatus:@"2h"];
    }],[QMUIPopupMenuButtonItem itemWithImage:nil title:@"3小时" handler:^(QMUIPopupMenuButtonItem * _Nonnull aItem) {
        [aItem.menuView hideWithAnimated:YES];
        [self resetBtnStuatus:@"3h"];
    }],[QMUIPopupMenuButtonItem itemWithImage:nil title:@"4小时" handler:^(QMUIPopupMenuButtonItem * _Nonnull aItem) {
        [aItem.menuView hideWithAnimated:YES];
        [self resetBtnStuatus:@"4h"];
    }],[QMUIPopupMenuButtonItem itemWithImage:nil title:@"周线" handler:^(QMUIPopupMenuButtonItem * _Nonnull aItem) {
        [aItem.menuView hideWithAnimated:YES];
        [self resetBtnStuatus:@"周线"];
    }],[QMUIPopupMenuButtonItem itemWithImage:nil title:@"月线" handler:^(QMUIPopupMenuButtonItem * _Nonnull aItem) {
        [aItem.menuView hideWithAnimated:YES];
        [self resetBtnStuatus:@"月线"];
    }],[QMUIPopupMenuButtonItem itemWithImage:nil title:@"季线" handler:^(QMUIPopupMenuButtonItem * _Nonnull aItem) {
        [aItem.menuView hideWithAnimated:YES];
        [self resetBtnStuatus:@"季线"];
    }]];
    self.popDateWindow.itemConfigurationHandler = ^(QMUIPopupMenuView *aMenuView, QMUIPopupMenuButtonItem *aItem, NSInteger section, NSInteger index) {
        // 利用 itemConfigurationHandler 批量设置所有 item 的样式
        aItem.highlightedBackgroundColor = [UIColor clearColor];
    };
    self.popDateWindow.sourceView = self.dateBtn;
}

#pragma mark ---- 按钮点击 ----
- (void)resetBtnStuatus:(NSString *)str {
    self.currentButton = self.dateBtn;
    self.lineView01.hidden = YES;
    self.lineView02.hidden = NO;
    [self.dateBtn setTitle:str forState:UIControlStateNormal];
    [self.dateBtn setTitleColor:WhiteColor forState:UIControlStateNormal];
    self.timeBtn01.selected = NO;
    self.timeBtn02.selected = NO;
    self.timeBtn03.selected = NO;
    self.timeBtn04.selected = NO;
    self.timeBtn05.selected = NO;
    
    if (_delegate && [_delegate respondsToSelector:@selector(dateChatBtnClick:)]) {
        [_delegate dateChatBtnClick:str];
    }
}

- (IBAction)timeBtnClick:(id)sender {
    UIButton *btn = (UIButton *)sender;
    
    if (btn.tag == self.currentButton.tag) {
        return;
    }
    
    self.currentButton = sender;
    [UIView animateWithDuration:0.5 animations:^{
        self.lineViewConstraintX.constant = ((self.size.width - 135)/5 - 30)/2 + (self.size.width - 135)/5 * self.currentButton.tag;
    }];
    
    self.lineView01.hidden = NO;
    self.lineView02.hidden = YES;
    [self.dateBtn setTitle:@"更多" forState:UIControlStateNormal];
    [self.dateBtn setTitleColor:GrayColor forState:UIControlStateNormal];
    
    NSString *period = @"";
    if (btn.tag == 0) {
        period = @"分时";
        self.timeBtn01.selected = YES;
        self.timeBtn02.selected = NO;
        self.timeBtn03.selected = NO;
        self.timeBtn04.selected = NO;
        self.timeBtn05.selected = NO;
    }else if (btn.tag == 1) {
        period = @"日线";
        self.timeBtn01.selected = NO;
        self.timeBtn02.selected = YES;
        self.timeBtn03.selected = NO;
        self.timeBtn04.selected = NO;
        self.timeBtn05.selected = NO;
    }else if (btn.tag == 2) {
        period = @"30m";
        self.timeBtn01.selected = NO;
        self.timeBtn02.selected = NO;
        self.timeBtn03.selected = YES;
        self.timeBtn04.selected = NO;
        self.timeBtn05.selected = NO;
    }else if (btn.tag == 3) {
        period = @"15m";
        self.timeBtn01.selected = NO;
        self.timeBtn02.selected = NO;
        self.timeBtn03.selected = NO;
        self.timeBtn04.selected = YES;
        self.timeBtn05.selected = NO;
    }else if (btn.tag == 4) {
        period = @"5m";
        self.timeBtn01.selected = NO;
        self.timeBtn02.selected = NO;
        self.timeBtn03.selected = NO;
        self.timeBtn04.selected = NO;
        self.timeBtn05.selected = YES;
    }
    
    if (_delegate && [_delegate respondsToSelector:@selector(dateChatBtnClick:)]) {
        [_delegate dateChatBtnClick:period];
    }
}

- (IBAction)dateBtnAction:(UIButton *)btn{
    if (self.popDateWindow.isShowing) {
        [self.popDateWindow hideWithAnimated:YES];
    } else {
        [self.popDateWindow showWithAnimated:YES];
    }
}

- (IBAction)AISettingBtnClick:(UIButton *)btn{
    self.aiBtn.selected = !self.aiBtn.selected;
    
    [_delegate settingBtnAction:!self.aiBtn.selected];
}

@end
