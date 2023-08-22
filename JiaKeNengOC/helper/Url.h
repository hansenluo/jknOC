//
//  Url.h
//  JiaKeNengOC
//
//  Created by jkn-mac on 2023/7/11.
//

#define API_BASE_URL @"https://api.usjkn.com"
//#define API_A_BASE_URL @"https://yunchan.chinajkn.com"

// 登录
#define API_login_URL [API_BASE_URL stringByAppendingString:@"/login/user?"]

// 获取所有股票代码
#define API_getStockCodes_URL [API_BASE_URL stringByAppendingString:@"/main/getStockCodes?"]

// 获取首页指数
#define API_getIndexesData_URL [API_BASE_URL stringByAppendingString:@"/market/indexDatas?"]

// 获取个股基本数据
#define API_getStockBaseData_URL [API_BASE_URL stringByAppendingString:@"/usstock/stockBasicData?"]

// 获取个股分钟线数据
#define API_getStockMinuteData_URL [API_BASE_URL stringByAppendingString:@"/usstock/stockMinuteData?"]

// 获取个股日线数据
#define API_getStockDayData_URL [API_BASE_URL stringByAppendingString:@"/usstock/stockDayData?"]

// 获取个股周线数据
#define API_getStockWeekData_URL [API_BASE_URL stringByAppendingString:@"/usstock/stockWeekData?"]

// 获取个股月线数据
#define API_getStockMonthData_URL [API_BASE_URL stringByAppendingString:@"/usstock/stockMonthData?"]

// 获取个股季线数据
#define API_getStockQuarterData_URL [API_BASE_URL stringByAppendingString:@"/usstock/stockQuarterData?"]

// 获取个股分时图数据
#define API_getStockTimeData_URL [API_BASE_URL stringByAppendingString:@"/usstock/stockTimeData?"]

// 获取个股在缠论报警和股票金池的状态
#define API_getStockStatus_URL [API_BASE_URL stringByAppendingString:@"/usstock/stockStatus?"]

// 获取股票行情列表
#define API_getStockList_URL [API_BASE_URL stringByAppendingString:@"/usstocklist/getStocks?"]

// 添加股票到股票金池
#define API_addPool_URL [API_BASE_URL stringByAppendingString:@"/pools/add?"]

// 股票金池中移除股票
#define API_removePool_URL [API_BASE_URL stringByAppendingString:@"/pools/remove?"]

// 批量移除股票金池中的某些股票
#define API_batchRemovePool_URL [API_BASE_URL stringByAppendingString:@"/pools/batchRemove?"]

// 获取股票金池列表
#define API_getPoolStocks_URL [API_BASE_URL stringByAppendingString:@"/pools/getPoolStocks?"]

// 获取板块数据
#define API_getPlateData_URL [API_BASE_URL stringByAppendingString:@"/usstockBoard/getIndexes?"]

// 选股
#define API_getStocksFilter_URL [API_BASE_URL stringByAppendingString:@"/filters/stocksFilter?"]

// 获取用户的选股权限
#define API_getPermissons_URL [API_BASE_URL stringByAppendingString:@"/filters/getPermissons?"]

// 添加股票到缠论报警
#define API_addTwist_URL [API_BASE_URL stringByAppendingString:@"/twist/add?"]

// 股票金池中移除报警股票
#define API_removeByCodeTwist_URL [API_BASE_URL stringByAppendingString:@"/twist/removeByCode?"]

// 缠论报警中移除股票
#define API_removeTwist_URL [API_BASE_URL stringByAppendingString:@"/twist/remove?"]

// 批量移除缠论报警中的某些股票
#define API_batchRemoveTwist_URL [API_BASE_URL stringByAppendingString:@"/twist/batchRemove?"]

// 修改缠论报警中的股票
#define API_modifyTwist_URL [API_BASE_URL stringByAppendingString:@"/twist/modify?"]

// 获取缠论股票列表
#define API_getAlarmStocks_URL [API_BASE_URL stringByAppendingString:@"/twist/getAlarmStocks?"]
