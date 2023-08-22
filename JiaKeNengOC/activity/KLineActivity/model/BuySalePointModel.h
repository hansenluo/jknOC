//
//  BuySalePointModel.h
//  JiaKeNengOC
//
//  Created by jkn-mac on 2023/7/17.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface BuySalePointModel : NSObject

@property(nonatomic,strong) NSString *date;

@property(nonatomic,assign) CGFloat high;

@property(nonatomic,assign) NSInteger num;  //段数
@property(nonatomic,assign) NSInteger direction;  //中枢方向

@end

NS_ASSUME_NONNULL_END
