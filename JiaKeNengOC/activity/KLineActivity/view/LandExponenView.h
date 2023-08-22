//
//  LandExponenView.h
//  JiaKeNengOC
//
//  Created by jkn-mac on 2023/7/26.
//

#import <UIKit/UIKit.h>
#import "KLineModel.h"

NS_ASSUME_NONNULL_BEGIN

@protocol LandExponenViewDelegate <NSObject>

- (void)backBtnAction;

@end

@interface LandExponenView : UIView

@property (nonatomic, weak) id <LandExponenViewDelegate> delegate;

- (void)setDataWithArray:(NSArray *)array title:(NSString *)title subTitle:(NSString *)subTitle;
- (void)setDataWithModel:(KLineModel *)model;

@end

NS_ASSUME_NONNULL_END
