//
//  HomeIndexView.h
//  JiaKeNengOC
//
//  Created by jkn-mac on 2023/7/31.
//

#import <UIKit/UIKit.h>
#import "HomeIndexModel.h"

NS_ASSUME_NONNULL_BEGIN

@protocol HomeIndexViewDelegate <NSObject>

- (void)selectIndexViewWithModel:(HomeIndexModel *)model;

@end

@interface HomeIndexView : UIView

@property (nonatomic, strong) HomeIndexModel *model;
@property (nonatomic, weak) id <HomeIndexViewDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
