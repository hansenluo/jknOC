//
//  KLinePeriodView.h
//  JiaKeNengOC
//
//  Created by jkn-mac on 2023/6/28.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol KLinePeriodViewDelegate <NSObject>

- (void)dateChatBtnClick:(NSString *)period;
- (void)settingBtnAction:(BOOL)isHidden;

@end

@interface KLinePeriodView : UIView

@property (nonatomic, weak) IBOutlet UIView *lineView01;
@property (nonatomic, weak) IBOutlet UIView *lineView02;
@property (nonatomic, weak) IBOutlet UIButton *timeBtn01;
@property (nonatomic, weak) IBOutlet UIButton *timeBtn02;
@property (nonatomic, weak) IBOutlet UIButton *timeBtn03;
@property (nonatomic, weak) IBOutlet UIButton *timeBtn04;
@property (nonatomic, weak) IBOutlet UIButton *timeBtn05;
@property (nonatomic, weak) IBOutlet QMUIButton *dateBtn;
@property (nonatomic, weak) IBOutlet QMUIButton *aiBtn;
@property (nonatomic, weak) IBOutlet UIView *sView;
@property (nonatomic, weak) IBOutlet NSLayoutConstraint *lineViewConstraintX;
@property (nonatomic, weak) id <KLinePeriodViewDelegate> delegate;
@property (nonatomic, strong) UIButton *currentButton;


@end

NS_ASSUME_NONNULL_END
