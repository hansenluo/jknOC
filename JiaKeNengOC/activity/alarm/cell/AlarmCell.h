//
//  AlarmCell.h
//  JiaKeNengOC
//
//  Created by jkn-mac on 2023/6/16.
//

#import <UIKit/UIKit.h>
#import "StockAIModel.h"

@class AlarmCell;

NS_ASSUME_NONNULL_BEGIN

#define tagLabelWidth 115

typedef void(^TapCellClick)(NSIndexPath *indexPath);
static NSString *tapCellScrollNotification = @"tapCellScrollNotification";

@protocol AlarmCellDelegate <NSObject>

- (void)selectTime:(AlarmCell *)cell;
- (void)selectTwist:(AlarmCell *)cell;
- (void)selectHdly:(AlarmCell *)cell;
- (void)changeBtnAction:(NSIndexPath *)indexPath model:(StockAIModel *)model;
- (void)addAIBtnAction:(NSIndexPath *)indexPath model:(StockAIModel *)model;
- (void)removeBtnAction:(AlarmCell *)cell;
- (void)selectBtnAction:(NSIndexPath *)indexPath model:(StockAIModel *)model;

@end

@interface AlarmCell : UITableViewCell <UIScrollViewDelegate>

@property (assign, nonatomic) BOOL isChecked;
@property (strong, nonatomic) StockAIModel *model;
@property (strong, nonatomic) UIView *lineView;

@property (nonatomic, strong) UIButton *timeBtn;
@property (strong, nonatomic) UILabel *nameLabel;
@property (strong, nonatomic) UILabel *tagLabel;
@property (strong, nonatomic) NSIndexPath *indexPath;
@property (strong, nonatomic) UIScrollView *rightScrollView;
@property (strong, nonatomic) UIButton *selectBtn;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, assign) BOOL isNotification;
@property (nonatomic, copy) TapCellClick tapCellClick;

@property (nonatomic, weak) id <AlarmCellDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
