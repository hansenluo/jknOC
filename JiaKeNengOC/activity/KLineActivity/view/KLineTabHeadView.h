//
//  KLineTabHeadView.h
//  JiaKeNengOC
//
//  Created by jkn-mac on 2023/6/27.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol KLineTabHeadViewDelegate <NSObject>

- (void)searchBtnClick;

@end

@interface KLineTabHeadView : UIView

@property (nonatomic, strong) UILabel *mainTitleLabel;
@property (nonatomic, strong) UILabel *subTitleLabel;
@property (nonatomic, weak) id <KLineTabHeadViewDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
