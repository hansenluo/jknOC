//
//  KLineTimeInfoView.h
//  JiaKeNengOC
//
//  Created by jkn-mac on 2023/7/22.
//

#import <UIKit/UIKit.h>
#import "KLineModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface KLineTimeInfoView : UIView

@property(nonatomic,strong) KLineModel *model;
+(instancetype)kLineTimeInfoView;

@end

NS_ASSUME_NONNULL_END
