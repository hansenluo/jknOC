//
//  AlarmTimeSelectView.h
//  JiaKeNengOC
//
//  Created by jkn-mac on 2023/6/16.
//

#import <UIKit/UIKit.h>
#import "StrategyModel.h"
#import "AlarmCell.h"

NS_ASSUME_NONNULL_BEGIN

@protocol AlarmTimeSelectViewDelegate <NSObject>

- (void)timeBtnAction:(NSInteger)timeId cell:(AlarmCell *)cell;

@end

@interface AlarmTimeSelectView : UIView

@property (nonatomic, strong) AlarmCell *cell;
@property (nonatomic, weak) id <AlarmTimeSelectViewDelegate> delegate;

- (void)setDataWithArray:(NSMutableArray *)array;

@end

NS_ASSUME_NONNULL_END
