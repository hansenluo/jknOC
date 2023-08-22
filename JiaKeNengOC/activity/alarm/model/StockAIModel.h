//
//  StockAIModel.h
//  JiaKeNengOC
//
//  Created by jkn-mac on 2023/8/3.
//

#import <Foundation/Foundation.h>
#import "BaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface StockAIModel : BaseModel

@property (nonatomic, assign) BOOL selectStatus;
@property (nonatomic, strong) NSString *num; //序号
@property (nonatomic, strong) NSString *stockCode; //股票代码
@property (nonatomic, strong) NSString *stockName; //股票名称
@property (nonatomic, strong) NSString *plateName; //板块名称
@property (nonatomic, strong) NSString *stockChinaName; //股票中文名称

@property (nonatomic, assign) NSInteger addPond; //是否加入股票金池
@property (nonatomic, assign) NSInteger addAI; //是否加入股票报警
@property (nonatomic, assign) NSInteger onlyId; //当前记录的唯一标识
@property (nonatomic, assign) NSInteger timeId; //时间级别id
@property (nonatomic, assign) NSInteger duotouId; //多头策略id
@property (nonatomic, assign) NSInteger kongtouId; //空头策略id
@property (nonatomic, assign) NSInteger hdlyId; //海底捞月id

@end

NS_ASSUME_NONNULL_END
