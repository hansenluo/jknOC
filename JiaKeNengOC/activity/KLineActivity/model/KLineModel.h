//
//  KLineModel.h
//  KLine-Chart-OC
//
//  Created by 何俊松 on 2020/3/10.
//  Copyright © 2020 hjs. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface KLineModel : NSObject

@property(nonatomic,assign) CGFloat open;
@property(nonatomic,assign) CGFloat high;
@property(nonatomic,assign) CGFloat low;
@property(nonatomic,assign) CGFloat close;
@property(nonatomic,assign) CGFloat lasetDayclose;

@property(nonatomic,assign) CGFloat vol;
@property(nonatomic,assign) CGFloat amount;
@property(nonatomic,assign) CGFloat count;
@property(nonatomic,strong) NSString *date;

@property(nonatomic,assign) CGFloat MA5Price;
@property(nonatomic,assign) CGFloat MA10Price;
@property(nonatomic,assign) CGFloat MA20Price;
@property(nonatomic,assign) CGFloat MA30Price;
@property(nonatomic,assign) CGFloat MA55Price;
@property(nonatomic,assign) CGFloat MA60Price;
@property(nonatomic,assign) CGFloat MA65Price;
@property(nonatomic,assign) CGFloat MA120Price;
@property(nonatomic,assign) CGFloat MA250Price;

@property(nonatomic,assign) CGFloat mb;
@property(nonatomic,assign) CGFloat up;
@property(nonatomic,assign) CGFloat dn;

@property(nonatomic,assign) CGFloat dif;
@property(nonatomic,assign) CGFloat dea;
@property(nonatomic,assign) CGFloat macd;
@property(nonatomic,assign) CGFloat ema12;
@property(nonatomic,assign) CGFloat ema26;

@property(nonatomic,assign) CGFloat MA5Volume;
@property(nonatomic,assign) CGFloat MA10Volume;
@property(nonatomic,assign) CGFloat MA20Volume;
@property(nonatomic,assign) CGFloat MA30Volume;
@property(nonatomic,assign) CGFloat MA55Volume;
@property(nonatomic,assign) CGFloat MA60Volume;
@property(nonatomic,assign) CGFloat MA65Volume;
@property(nonatomic,assign) CGFloat MA120Volume;
@property(nonatomic,assign) CGFloat MA250Volume;

@property(nonatomic,assign) CGFloat rsi;
@property(nonatomic,assign) CGFloat rsiABSEma;
@property(nonatomic,assign) CGFloat rsiMaxEma;

@property(nonatomic,assign) CGFloat k;
@property(nonatomic,assign) CGFloat d;
@property(nonatomic,assign) CGFloat j;
@property(nonatomic,assign) CGFloat r;

@property(nonatomic,assign) CGFloat X0;
@property(nonatomic,assign) CGFloat S1;

@property(nonatomic,assign) BOOL isShowCurrentIndex; //数据不满屏的时候一个标记

//中枢相关属性
@property(nonatomic,assign) BOOL isNeedDrawRect; //需要画中枢
@property(nonatomic,assign) BOOL isNeedDrawMark; //需要画中枢标记
@property(nonatomic,assign) BOOL isPivotStartPoint;
@property(nonatomic,assign) BOOL isPivotEndPoint;
@property(nonatomic,assign) CGFloat rectHigh;
@property(nonatomic,assign) CGFloat rectLow;
@property(nonatomic,assign) NSInteger num;
@property(nonatomic,assign) NSInteger direction;
@property(nonatomic,assign) int marknum;  //中枢标记
@property(nonatomic,assign) int minRectSpansNum;  //中枢段数
@property(nonatomic,assign) NSInteger minRectTag;  //中枢段数

//扩展中枢相关
@property(nonatomic,assign) BOOL isNeedDrawExtendRect; //需要画扩展中枢
@property(nonatomic,assign) BOOL isNeedDrawExtendMark; //需要画中枢标记
@property(nonatomic,assign) BOOL isExtendStartPoint;
@property(nonatomic,assign) BOOL isExtendEndPoint;
@property(nonatomic,assign) CGFloat extendRectHigh;
@property(nonatomic,assign) CGFloat extendRectLow;
@property(nonatomic,assign) NSInteger extendRectNum;
@property(nonatomic,assign) NSInteger extendRectDirection;
@property(nonatomic,assign) int extendMarknum;  //中枢标记
@property(nonatomic,assign) int maxRectSpansNum;  //中枢段数
@property(nonatomic,assign) NSInteger maxRectTag;  //中枢段数

//买卖点相关
@property(nonatomic,assign) BOOL isNeedDrawSale1Point; //需要画买卖1点数据
@property(nonatomic,assign) CGFloat sale1PointHigh;
@property(nonatomic,assign) NSInteger sale1PointNum;
@property(nonatomic,assign) NSInteger sale1PointDirection;

@property(nonatomic,assign) BOOL isNeedDrawSale3Point; //需要画买卖3点数据
@property(nonatomic,assign) CGFloat sale3PointHigh;
@property(nonatomic,assign) NSInteger sale3PointNum;
@property(nonatomic,assign) NSInteger sale3PointDirection;

//海底捞月相关
@property(nonatomic,assign) CGFloat hdlyHigh;
@property(nonatomic,assign) CGFloat horizon;
@property(nonatomic,assign) CGFloat monthLine;

//画笔相关
@property(nonatomic,assign) int penStatus;
@property(nonatomic,assign) CGFloat penHigh;
@property(nonatomic,assign) BOOL isDrawPen;
@property(nonatomic,assign) BOOL isDrawLineDash; //最后一段需要判断画虚线还是直线

@end

NS_ASSUME_NONNULL_END
