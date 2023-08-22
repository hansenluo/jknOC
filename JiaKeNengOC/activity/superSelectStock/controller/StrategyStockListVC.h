//
//  StrategyStockListVC.h
//  JiaKeNengOC
//
//  Created by jkn-mac on 2023/8/3.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface StrategyStockListVC : BaseViewController

@property (nonatomic, strong) NSMutableArray *dataSourceArray;

@property (nonatomic, strong) NSString *timeStr;

@end

NS_ASSUME_NONNULL_END
