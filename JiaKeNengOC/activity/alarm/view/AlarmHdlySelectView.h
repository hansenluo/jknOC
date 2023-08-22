//
//  AlarmHdlySelectView.h
//  JiaKeNengOC
//
//  Created by jkn-mac on 2023/8/4.
//

#import <UIKit/UIKit.h>
#import "StrategyModel.h"
#import "AlarmCell.h"

NS_ASSUME_NONNULL_BEGIN

@protocol AlarmHdlySelectViewDelegate <NSObject>

- (void)hdlyBtnAction:(NSInteger)hdlyId cell:(AlarmCell *)cell;

@end

@interface AlarmHdlySelectView : UIView

@property (nonatomic, strong) AlarmCell *cell;
@property (nonatomic, weak) id <AlarmHdlySelectViewDelegate> delegate;

- (void)setDataWithArray:(NSMutableArray *)array;

@end

NS_ASSUME_NONNULL_END
