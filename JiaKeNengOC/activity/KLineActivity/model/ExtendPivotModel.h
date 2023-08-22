//
//  ExtendPivotModel.h
//  JiaKeNengOC
//
//  Created by jkn-mac on 2023/7/14.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ExtendPivotModel : NSObject

@property(nonatomic,strong) NSString *startDate;
@property(nonatomic,strong) NSString *endDate;

@property(nonatomic,assign) CGFloat high;
@property(nonatomic,assign) CGFloat low;

@property(nonatomic,assign) NSInteger num;  //扩展级数
@property(nonatomic,assign) NSInteger direction;  //中枢方向

@end

NS_ASSUME_NONNULL_END
