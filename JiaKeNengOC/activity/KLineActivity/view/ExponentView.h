//
//  ExponentView.h
//  JiaKeNengOC
//
//  Created by jkn-mac on 2023/6/28.
//

#import <UIKit/UIKit.h>
#import "KLineModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface ExponentView : UIView

- (void)setDataWithArray:(NSArray *)array;
- (void)setDataWithModel:(KLineModel *)model;

@end

NS_ASSUME_NONNULL_END
