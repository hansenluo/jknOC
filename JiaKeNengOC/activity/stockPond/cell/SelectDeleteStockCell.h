//
//  SelectDeleteStockCell.h
//  JiaKeNengOC
//
//  Created by jkn-mac on 2023/6/16.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SelectDeleteStockCell : UITableViewCell

@property (nonatomic, assign) BOOL isChecked;
@property (nonatomic, weak) IBOutlet UIImageView *checkImageView;

@end

NS_ASSUME_NONNULL_END
