//
//  Macros.h
//  JiaKeNengOC
//
//  Created by jkn-mac on 2023/6/14.
//

#ifndef Macros_h
#define Macros_h

//列表分页的每页数
#define pageSize 20

//轮询刷新的时间间隔
#define timeInterval 6

// 注册通知
#define PXNotifiAdd(_noParamsFunc, _notifyName, _notifyObject)  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(_noParamsFunc) name:_notifyName object:_notifyObject];

// 发送通知
#define PXNotifiPost(_notifyName, _notifyObject)   [[NSNotificationCenter defaultCenter]postNotificationName:_notifyName object:_notifyObject];

//判断字符串去空格后是否为空
#define isNilString(_x) (_x==nil || [_x isEqual:[NSNull null]] || [[toString(_x) stringByReplacingOccurrencesOfString:@" " withString:@""] length]==0 || [_x isEqual:@"<null>"])
#define IsNull(text) (text==nil|| [text isEqual:[NSNull null]])
#define toString(_x) [NSString stringWithFormat:@"%@",_x]

//全局
#define APP ((AppDelegate *)[[UIApplication sharedApplication] delegate])
//屏幕相关
#define screenW [[UIScreen mainScreen] bounds].size.width
#define screenH [[UIScreen mainScreen] bounds].size.height
#define Height_NavBar (IS_NOTCHED_SCREEN?88.0f:64.0f)
#define Height_TabBar (IS_NOTCHED_SCREEN?83.0f:49.0f)
//tableView contentInset
#define TABCONTENTINSETH (IS_NOTCHED_SCREEN?88:64)

//设置字体大小
#define MFont(a) [UIFont systemFontOfSize:(a)]
#define MWFont(s,w) [UIFont systemFontOfSize:s weight:w]

//主色调
#define PrimaryColor [System colorWithHexString:@"#101010"]
//背景颜色
#define MinorColor [System colorWithHexString:@"#17181C"]
//白色
#define WhiteColor [System colorWithHexString:@"#FFFFFF"]
//黑色
#define BlackColor [System colorWithHexString:@"#000000"]
//灰色
#define GrayColor [System colorWithHexString:@"#9096A0"]
//涨幅绿色
#define RiseColor [System colorWithHexString:@"#00BE4C"]
//跌幅红色
#define DropColor [System colorWithHexString:@"#FF3D4C"]
//透明
#define ClearColor [UIColor clearColor];

//设置颜色值
#define PXColorFromRGB(r, g, b) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1]
#define PXColorFromRGBA(r, g, b, a) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:a]

//返回上一级页面
#define PopViewController [[QMUIHelper visibleViewController].navigationController popViewControllerAnimated:YES]
//跳转
#define PushController(_vc) [[QMUIHelper visibleViewController].navigationController pushViewController:_vc animated:YES];

//通知相关
//登录成功退出登录key
#define LOGINSTATUSKEY @"LOGINSTATUSKEY"

//股票金池操作key
#define StockPoolOperateKey @"StockPoolOperateKey"

//缠论报警操作key
#define StockAIOperateKey @"StockAIOperateKey"

#endif /* Macros_h */

