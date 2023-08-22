//
//  SearchStockCell.h
//  JiaKeNengOC
//
//  Created by jkn-mac on 2023/8/2.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SearchStockCell : UITableViewCell

@property (nonatomic, weak) IBOutlet UILabel *stockCodeLabel;
@property (nonatomic, weak) IBOutlet UILabel *stockNameLabel;

@end

NS_ASSUME_NONNULL_END
