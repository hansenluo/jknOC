//
//  QuotationListCell.h
//  JiaKeNengOC
//
//  Created by jkn-mac on 2023/6/15.
//

#import <UIKit/UIKit.h>
#import "QuotationListModel.h"

NS_ASSUME_NONNULL_BEGIN

#define tagLabelWidth 115

typedef void(^TapCellClick)(NSIndexPath *indexPath);
static NSString *quotationListScrollNotification = @"quotationListCellScrollNotification";

@protocol QuotationListCellDelegate <NSObject>

- (void)addPondBtnAction:(NSIndexPath *)indexPath model:(QuotationListModel *)model;
- (void)addAIBtnAction:(NSIndexPath *)indexPath model:(QuotationListModel *)model;

@end

@interface QuotationListCell : UITableViewCell <UIScrollViewDelegate>

@property (strong, nonatomic) QuotationListModel *model;
@property (strong, nonatomic) UILabel *nameLabel;
@property (strong, nonatomic) UILabel *tagLabel;
@property (strong, nonatomic) UILabel *priceLabel;
@property (strong, nonatomic) UIView *temView;
@property (strong, nonatomic) UILabel *aitoLabel;
@property (strong, nonatomic) UILabel *priceCountLabel;
@property (strong, nonatomic) UIButton *addPondBtn;
@property (strong, nonatomic) UIButton *addAIBtn;
@property (strong, nonatomic) UIScrollView *rightScrollView;
@property (strong, nonatomic) NSIndexPath *indexPath;
@property (weak, nonatomic) id <QuotationListCellDelegate> delegate;

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, assign) BOOL isNotification;
@property (nonatomic, copy) TapCellClick tapCellClick;

@end

NS_ASSUME_NONNULL_END
