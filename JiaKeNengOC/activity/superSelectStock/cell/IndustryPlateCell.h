//
//  IndustryPlateCell.h
//  JiaKeNengOC
//
//  Created by jkn-mac on 2023/6/20.
//

#import <UIKit/UIKit.h>
#import "SelectStockModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface IndustryPlateCell : UITableViewCell

@property (nonatomic, strong) SelectStockModel *model;

@property (nonatomic, assign) BOOL isChecked;
@property (nonatomic, weak) IBOutlet UIView *lineView;
@property (nonatomic, weak) IBOutlet UIImageView *checkImageView;

@end

NS_ASSUME_NONNULL_END
