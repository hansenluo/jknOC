//
//  BaseModel.h
//  JiaKeNengOC
//
//  Created by jkn-mac on 2023/7/28.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface BaseModel : NSObject

@property (nonatomic, strong) NSString *time; //时间
@property (nonatomic, assign) CGFloat close; //收盘价 (最新价)
@property (nonatomic, assign) CGFloat high; //最高价
@property (nonatomic, assign) CGFloat low; //最低价
@property (nonatomic, assign) CGFloat open; //开盘价
@property (nonatomic, assign) CGFloat lasetDayclose; //前收盘价

@property (nonatomic, assign) CGFloat vol; //成交量
@property (nonatomic, assign) CGFloat amount; //成交额
@property (nonatomic, assign) CGFloat totalValue; //总市值
@property (nonatomic, assign) CGFloat circulateValue; //流通市值
@property (nonatomic, assign) CGFloat totalStock; //总股本
@property (nonatomic, assign) CGFloat circulateStock; //流通股本
@property (nonatomic, assign) CGFloat turnoverRate; //换手率
@property (nonatomic, assign) CGFloat pegRatio; //市盈率
@property (nonatomic, assign) CGFloat pbRatio; //市净率

@property (nonatomic, assign) CGFloat aito; //涨跌幅

@end

NS_ASSUME_NONNULL_END
