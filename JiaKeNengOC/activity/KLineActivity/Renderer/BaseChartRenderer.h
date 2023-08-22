//
//  BaseChartRenderer.h
//  KLine-Chart-OC
//
//  Created by 何俊松 on 2020/3/10.
//  Copyright © 2020 hjs. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "KLineModel.h"
#import "RectPivotModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface BaseChartRenderer : NSObject

@property(nonatomic,assign) CGFloat maxValue;
@property(nonatomic,assign) CGFloat minValue;
@property(nonatomic,assign) CGRect chartRect;
@property(nonatomic,assign) CGFloat candleWidth;
@property(nonatomic,assign) CGFloat scaleY;
@property(nonatomic,assign) CGFloat topPadding;
@property(nonatomic,assign) BOOL isLine;

//初始化
- (instancetype)initWithMaxValue:(CGFloat)maxValue
                        minValue:(CGFloat)minValue
                       chartRect:(CGRect)chartRect
                     candleWidth:(CGFloat)candleWidth
                      topPadding:(CGFloat)topPadding
                         isLine:(BOOL)isLine;

//画表格
- (void)drawGrid:(CGContextRef)context
       gridRows:(NSUInteger)gridRows
     gridColums:(NSUInteger)gridColums;

//画右侧价格区间
- (void)drawRightText:(CGContextRef)context
            gridRows:(NSUInteger)gridRows
          gridColums:(NSUInteger)gridColums;

//画主副图顶部文字
- (void)drawTopText:(CGContextRef)context
          curPoint:(KLineModel *)curPoint;

//背景色
- (void)drawBg:(CGContextRef)context;

//画白色笔
- (void)drawPen:(CGContextRef)context
     priorPoint:(KLineModel *)priorPoint
       curPoint:(KLineModel *)curPoint
           curX:(CGFloat)curX;

//画分时图
- (void)drawTime:(CGContextRef)context
        lastPoit:(KLineModel *)lastPoint
        curPoint:(KLineModel *)curPoint
            curX:(CGFloat)curX;

//画蜡烛图
- (void)drawChart:(CGContextRef)context
        lastPoit:(KLineModel *)lastPoint
        curPoint:(KLineModel *)curPoint
            curX:(CGFloat)curX;

//画各种线
- (void)drawLine:(CGContextRef)context
       lineWidth:(NSInteger)lineWidth
      lastValue:(CGFloat)lastValue
       curValue:(CGFloat)curValue
           curX:(CGFloat)curX
          color:(UIColor *)color;

//画填充颜色的矩形中枢
- (void)drawcEntresDataRect:(CGContextRef)context
                curPoint:(KLineModel *)curPoint
                    curX:(CGFloat)curX
                isSameArea:(BOOL)isSameArea
                    color:(UIColor *)color;

//画中枢标记
- (void)drawcEntresMark:(CGContextRef)context
            curPoint:(KLineModel *)curPoint
               curX:(CGFloat)curX;

//画虚线边框的矩形中枢
- (void)drawcLineDashRect:(CGContextRef)context
                 curPoint:(KLineModel *)curPoint
                     curX:(CGFloat)curX
                 isSameArea:(BOOL)isSameArea
                     color:(UIColor *)color;

//画扩展中枢标记
- (void)drawExtendMark:(CGContextRef)context
            curPoint:(KLineModel *)curPoint
               curX:(CGFloat)curX
             isSameArea:(BOOL)isSameArea
                 color:(UIColor *)color;

//画买卖点标记
- (void)drawcSalePointMark:(CGContextRef)context
               curPoint:(KLineModel *)curPoint
                  curX:(CGFloat)curX;

- (CGFloat)getY:(CGFloat)value;

//下列提供给子类的工具方法
- (void)drawText:(NSString *)text
        atPoint:(CGPoint)point
       fontSize:(CGFloat)size
      textColor:(UIColor *)color;

- (NSString *)volFormat:(CGFloat)value;

@end

NS_ASSUME_NONNULL_END
