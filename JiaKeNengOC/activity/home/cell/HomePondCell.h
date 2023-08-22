//
//  HomePondCell.h
//  JiaKeNengOC
//
//  Created by jkn-mac on 2023/6/15.
//

#import <UIKit/UIKit.h>
#import "StockPondModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface HomePondCell : UITableViewCell

@property (strong, nonatomic) StockPondModel *model;
@property (weak, nonatomic) IBOutlet UIView *lineView;

@end

NS_ASSUME_NONNULL_END
