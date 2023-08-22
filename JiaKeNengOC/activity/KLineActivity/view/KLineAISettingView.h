//
//  KLineAISettingView.h
//  JiaKeNengOC
//
//  Created by jkn-mac on 2023/8/16.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol KLineAISettingViewDelegate <NSObject>

- (void)settingAIIndex:(NSInteger)index hidden:(BOOL)hidden;

@end

@interface KLineAISettingView : UIView

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, weak) id<KLineAISettingViewDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
