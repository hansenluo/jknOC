//
//  RiskWarningView.h
//  JiaKeNengOC
//
//  Created by jkn-mac on 2023/6/15.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol RiskWarningViewDelegate <NSObject>

- (void)hiddenView;

@end

@interface RiskWarningView : UIView

@property (nonatomic, weak) id <RiskWarningViewDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
