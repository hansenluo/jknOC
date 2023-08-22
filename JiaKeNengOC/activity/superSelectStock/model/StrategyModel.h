//
//  StrategyModel.h
//  JiaKeNengOC
//
//  Created by jkn-mac on 2023/8/3.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface StrategyModel : NSObject

@property (nonatomic, assign) NSInteger strategyId;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, assign) BOOL usable;

@end

NS_ASSUME_NONNULL_END
