//
//  RectPivotModel.h
//  JiaKeNengOC
//
//  Created by jkn-mac on 2023/7/13.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface RectPivotModel : NSObject

@property(nonatomic,strong) NSString *startDate;
@property(nonatomic,strong) NSString *endDate;

@property(nonatomic,assign) CGFloat high;
@property(nonatomic,assign) CGFloat low;

@property(nonatomic,assign) NSInteger num;  //段数
@property(nonatomic,assign) NSInteger direction;  //中枢方向
@property(nonatomic,assign) int marknum;  //中枢标记

@end

NS_ASSUME_NONNULL_END
