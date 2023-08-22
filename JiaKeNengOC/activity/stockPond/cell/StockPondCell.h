//
//  StockPondCell.h
//  JiaKeNengOC
//
//  Created by jkn-mac on 2023/6/16.
//

#import <UIKit/UIKit.h>
#import "StockPondModel.h"

@class StockPondCell;

NS_ASSUME_NONNULL_BEGIN

#define tagLabelWidth 115

typedef void(^TapCellClick)(NSIndexPath *indexPath);
static NSString *stockPondScrollNotification = @"stockPondScrollNotification";

@protocol StockPondCellDelegate <NSObject>

- (void)addAIBtnAction:(NSIndexPath *)indexPath model:(StockPondModel *)model;
- (void)removePondBtnAction:(StockPondCell *)cell;
- (void)selectBtnAction:(NSIndexPath *)indexPath model:(StockPondModel *)model;

@end

@interface StockPondCell : UITableViewCell <UIScrollViewDelegate>

//@property (assign, nonatomic) BOOL isChecked;
@property (strong, nonatomic) StockPondModel *model;
@property (strong, nonatomic) UILabel *nameLabel;
@property (strong, nonatomic) UILabel *tagLabel;
@property (strong, nonatomic) UILabel *priceLabel;
@property (strong, nonatomic) UIView *temView;
@property (strong, nonatomic) UILabel *aitoLabel;
@property (strong, nonatomic) UILabel *priceCountLabel;
@property (strong, nonatomic) UIButton *removePondBtn;
@property (strong, nonatomic) UIButton *addAIBtn;
@property (strong, nonatomic) UIButton *selectBtn;
@property (strong, nonatomic) UIView *lineView;
@property (strong, nonatomic) UIScrollView *rightScrollView;
@property (strong, nonatomic) NSIndexPath *indexPath;
@property (weak, nonatomic) id <StockPondCellDelegate> delegate;

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, assign) BOOL isNotification;
@property (nonatomic, copy) TapCellClick tapCellClick;

@end

NS_ASSUME_NONNULL_END
