//
//  HomeIndexModel.h
//  JiaKeNengOC
//
//  Created by jkn-mac on 2023/7/31.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface HomeIndexModel : NSObject

@property (nonatomic, strong) NSString *stockCode; //股票代码
@property (nonatomic, strong) NSString *stockName; //股票名称

@property (nonatomic, assign) CGFloat close; //收盘价 (最新价)
@property (nonatomic, assign) CGFloat high; //最高价
@property (nonatomic, assign) CGFloat low; //最低价
@property (nonatomic, assign) CGFloat open; //开盘价
@property (nonatomic, assign) CGFloat lasetDayclose; //前收盘价
@property (nonatomic, assign) CGFloat vol; //成交量
@property (nonatomic, assign) CGFloat amount; //成交额

@end

NS_ASSUME_NONNULL_END
