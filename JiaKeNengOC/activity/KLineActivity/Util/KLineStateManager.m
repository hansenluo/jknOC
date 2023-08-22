//
//  KLineStateManager.m
//  KLine-Chart-OC
//
//  Created by 何俊松 on 2020/3/10.
//  Copyright © 2020 hjs. All rights reserved.
//

#import "KLineStateManager.h"
#import "DataUtil.h"

static KLineStateManager *_manager = nil;
@implementation KLineStateManager

- (instancetype)init
{
    self = [super init];
    if (self) {
        _mainState = MainStateMA;
        _secondaryState = SecondaryStateMacd;
        _isLine = false;
    }
    return self;
}

+(instancetype)manager {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _manager = [[self alloc] init];
    });
    return _manager;
}

- (void)setKlineChart:(KLineChartView *)klineChart {
    _klineChart = klineChart;
    _klineChart.mainState = _mainState;
    _klineChart.secondaryState = _secondaryState;
    _klineChart.isLine = _isLine;
    _klineChart.datas = _datas;
    _klineChart.isShowDrawPen = _isShowDrawPen;
    _klineChart.isShowDrawRect = _isShowDrawRect;
    _klineChart.isShowDXW = _isShowDXW;
    _klineChart.isShowBDW = _isShowBDW;
    _klineChart.isShowZLSQ = _isShowZLSQ;
    _klineChart.isShowZLQS = _isShowZLQS;
}

- (void)setDict:(NSDictionary *)dict {
    _dict = dict;
}

- (void)setDatas:(NSArray *)datas {
    _datas = datas;
    _klineChart.datas = datas;
}

- (void)setScrollX:(CGFloat)scrollX {
    _scrollX = scrollX;
    _klineChart.scrollX = scrollX;
}

- (void)setScaleX:(CGFloat)scaleX {
    _scaleX = scaleX;
    _klineChart.scaleX = scaleX;
}

- (void)setMainState:(MainState)mainState {
    _mainState = mainState;
    _klineChart.mainState = mainState;
}
-(void)setSecondaryState:(SecondaryState)secondaryState {
    _secondaryState = secondaryState;
    _klineChart.secondaryState = secondaryState;
}

-(void)setIsLine:(BOOL)isLine {
    _isLine = isLine;
    _klineChart.isLine = isLine;
}

- (void)setIsShowDrawPen:(BOOL)isShowDrawPen {
    _isShowDrawPen = isShowDrawPen;
    _klineChart.isShowDrawPen = isShowDrawPen;
}

- (void)setIsShowDrawRect:(BOOL)isShowDrawRect {
    _isShowDrawRect = isShowDrawRect;
    _klineChart.isShowDrawRect = isShowDrawRect;
}

- (void)setIsShowDXW:(BOOL)isShowDXW {
    _isShowDXW = isShowDXW;
    _klineChart.isShowDXW = isShowDXW;
}

- (void)setIsShowBDW:(BOOL)isShowBDW {
    _isShowBDW = isShowBDW;
    _klineChart.isShowBDW = isShowBDW;
}

- (void)setIsShowZLSQ:(BOOL)isShowZLSQ {
    _isShowZLSQ = isShowZLSQ;
    _klineChart.isShowZLSQ = isShowZLSQ;
}

- (void)setIsShowZLQS:(BOOL)isShowZLQS {
    _isShowZLQS = isShowZLQS;
    _klineChart.isShowZLQS = isShowZLQS;
}

-(void)setPeriod:(NSString *)period {
    _period = period;
}



@end
