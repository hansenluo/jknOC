//
//  AlarmTwistSelectView.h
//  JiaKeNengOC
//
//  Created by jkn-mac on 2023/8/4.
//

#import <UIKit/UIKit.h>
#import "StrategyModel.h"
#import "AlarmCell.h"

NS_ASSUME_NONNULL_BEGIN

@protocol AlarmTwistSelectViewDelegate <NSObject>

- (void)twistBtnAction:(NSInteger)twistId cell:(AlarmCell *)cell;

@end

@interface AlarmTwistSelectView : UIView

@property (nonatomic, strong) AlarmCell *cell;
@property (nonatomic, weak) id <AlarmTwistSelectViewDelegate> delegate;

- (void)setDataWithArray:(NSMutableArray *)array01 array02:(NSMutableArray *)array02;

@end

NS_ASSUME_NONNULL_END
