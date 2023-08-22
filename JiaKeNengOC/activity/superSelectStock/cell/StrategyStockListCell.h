//
//  StrategyStockListCell.h
//  JiaKeNengOC
//
//  Created by jkn-mac on 2023/8/3.
//

#import <UIKit/UIKit.h>
#import "StockPondModel.h"

@class StockPondCell;

NS_ASSUME_NONNULL_BEGIN

#define tagLabelWidth 115

typedef void(^TapCellClick)(NSIndexPath *indexPath);
static NSString *strategyStockScrollNotification = @"strategyStockScrollNotification";

@protocol StrategyStockListCellDelegate <NSObject>

- (void)addAIBtnAction:(NSIndexPath *)indexPath model:(StockPondModel *)model;
- (void)addPondBtnAction:(NSIndexPath *)indexPath model:(StockPondModel *)model;

@end

@interface StrategyStockListCell : UITableViewCell <UIScrollViewDelegate>

@property (strong, nonatomic) StockPondModel *model;
@property (strong, nonatomic) UILabel *nameLabel;
@property (strong, nonatomic) UILabel *tagLabel;
@property (strong, nonatomic) UILabel *priceLabel;
@property (strong, nonatomic) UIView *temView;
@property (strong, nonatomic) UILabel *aitoLabel;
@property (strong, nonatomic) UILabel *priceCountLabel;
@property (strong, nonatomic) UIButton *addPondBtn;
@property (strong, nonatomic) UIButton *addAIBtn;
@property (strong, nonatomic) UIView *lineView;
@property (strong, nonatomic) UIScrollView *rightScrollView;
@property (strong, nonatomic) NSIndexPath *indexPath;
@property (weak, nonatomic) id <StrategyStockListCellDelegate> delegate;

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, assign) BOOL isNotification;
@property (nonatomic, copy) TapCellClick tapCellClick;

@end

NS_ASSUME_NONNULL_END
