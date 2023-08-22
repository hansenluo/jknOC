//
//  KLineMainVC.h
//  JiaKeNengOC
//
//  Created by jkn-mac on 2023/6/27.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef enum : NSUInteger {
    DateSelectStateDay,
    DateSelectStateWeek,
    DateSelectStateMonth,
    DateSelectStateQuarter,
    DateSelectStateMinute,
//    DateSelectState1Minute,
//    DateSelectState3Minute,
//    DateSelectState5Minute,
//    DateSelectState10Minute,
//    DateSelectState15Minute,
//    DateSelectState30Minute,
//    DateSelectState60Minute,
//    DateSelectState120Minute,
//    DateSelectState180Minute,
//    DateSelectState240Minute,
    DateSelectStateTimeShare,
} DateSelectState;

@interface KLineMainVC : BaseViewController

@property (nonatomic, strong) NSString *stockCode;
@property (nonatomic, strong) NSString *mainTitle;
@property (nonatomic, strong) NSString *subTitle;
@property (nonatomic, strong) NSString *currentSelectMintue;

@property (nonatomic, assign) DateSelectState dateSelectState;

@end

NS_ASSUME_NONNULL_END
