//
//  HomeAlarmCell.h
//  JiaKeNengOC
//
//  Created by jkn-mac on 2023/6/15.
//

#import <UIKit/UIKit.h>
#import "StockAIModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface HomeAlarmCell : UITableViewCell

@property (strong, nonatomic) StockAIModel *model;
@property (weak, nonatomic) IBOutlet UIView *lineView;

@end

NS_ASSUME_NONNULL_END
