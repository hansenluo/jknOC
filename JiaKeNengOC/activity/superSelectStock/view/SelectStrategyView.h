//
//  SelectStrategyView.h
//  JiaKeNengOC
//
//  Created by jkn-mac on 2023/8/2.
//

#import <UIKit/UIKit.h>
#import "StrategyModel.h"

NS_ASSUME_NONNULL_BEGIN

@protocol SelectStrategyViewDelegate <NSObject>

- (void)confirmBtnAction:(NSString *)timeId twistId:(NSString *)twistId hdlyId:(NSString *)hdlyId zoneId:(NSString *)zoneId startDate:(NSString *)startDate endDate:(NSString *)endDate;

@end

@interface SelectStrategyView : UIView

@property (nonatomic, weak) id <SelectStrategyViewDelegate> delegate;

- (void)setDataWithArray:(NSMutableArray *)array01 array02:(NSMutableArray *)array02 array03:(NSMutableArray *)array03 array04:(NSMutableArray *)array04;

@end

NS_ASSUME_NONNULL_END
