//
//  StockPondModel.h
//  JiaKeNengOC
//
//  Created by jkn-mac on 2023/7/28.
//

#import <Foundation/Foundation.h>
#import "BaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface StockPondModel : BaseModel

@property (nonatomic, assign) BOOL selectStatus;
@property (nonatomic, strong) NSString *stockCode; //股票代码
@property (nonatomic, strong) NSString *stockName; //股票名称
@property (nonatomic, strong) NSString *plateName; //板块名称
@property (nonatomic, strong) NSString *stockChinaName; //股票中文名称
@property (nonatomic, assign) NSInteger addPond; //是否加入股票金池
@property (nonatomic, assign) NSInteger addAI; //是否加入股票报警

@end

NS_ASSUME_NONNULL_END
