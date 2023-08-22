//
//  KLinePainterView.m
//  KLine-Chart-OC
//
//  Created by 何俊松 on 2020/3/10.
//  Copyright © 2020 hjs. All rights reserved.
//

#import "KLinePainterView.h"
#import "MainChartRenderer.h"
#import "VolChartRenderer.h"
#import "SecondaryChartRenderer.h"
#import "ChartStyle.h"
#import "NSString+Rect.h"

@interface KLinePainterView()
@property(nonatomic,assign) CGFloat displayHeight;
@property(nonatomic,strong) MainChartRenderer *mainRenderer;
@property(nonatomic,strong) VolChartRenderer *volRenderer;
@property(nonatomic,strong) SecondaryChartRenderer *seconderyRender;

@property(nonatomic,assign) NSUInteger startIndex;
@property(nonatomic,assign) NSUInteger stopIndex;

@property(nonatomic,assign) NSUInteger mMainMaxIndex;
@property(nonatomic,assign) NSUInteger mMainMinIndex;

@property(nonatomic,assign) CGFloat mMainMaxValue;
@property(nonatomic,assign) CGFloat mMainMinValue;

@property(nonatomic,assign) CGFloat mVolMaxValue;
@property(nonatomic,assign) CGFloat mVolMinValue;

@property(nonatomic,assign) CGFloat mSecondaryMaxValue;
@property(nonatomic,assign) CGFloat mSecondaryMinValue;

@property(nonatomic,assign) CGFloat mMainHighMaxValue;
@property(nonatomic,assign) CGFloat mMainLowMinValue;

@property(nonatomic,assign) CGFloat candleWidth;

//var fromat: String = "yyyy-MM-dd"
@property(nonatomic,copy) NSString *fromat;

@property(nonatomic,strong) QMUIButton *selectIndexBtn;
@property(nonatomic,strong) QMUIPopupMenuView *popWindow;

@end

@implementation KLinePainterView

- (void)setDatas:(NSArray<KLineModel *> *)datas {
    _datas = datas;
    [self setNeedsDisplay];
}

-(void)setScrollX:(CGFloat)scrollX {
    _scrollX = scrollX;
    [self setNeedsDisplay];
}

-(void)setIsLine:(BOOL)isLine {
    _isLine = isLine;
    self.candleWidth = self.scaleX * ChartStyle_candleWidth;
    [self setNeedsDisplay];
}
-(void)setScaleX:(CGFloat)scaleX {
    _scaleX = scaleX;
    self.candleWidth = scaleX * ChartStyle_candleWidth;
    [self setNeedsDisplay];
}
- (void)setIsLongPress:(BOOL)isLongPress {
    _isLongPress = isLongPress;
    [self setNeedsDisplay];
}

- (void)setSingleTagPress:(BOOL)singleTagPress {
    _singleTagPress = singleTagPress;
    [self setNeedsDisplay];
}

-(void)setMainState:(MainState)mainState {
    _mainState = mainState;
    [self setNeedsDisplay];
}

- (void)setSecondaryState:(SecondaryState)secondaryState {
    _secondaryState = secondaryState;
    [self setNeedsDisplay];
}

- (void)setIsShowDrawPen:(BOOL)isShowDrawPen {
    _isShowDrawPen = isShowDrawPen;
    [self setNeedsDisplay];
}

- (void)setIsShowDrawRect:(BOOL)isShowDrawRect  {
    _isShowDrawRect = isShowDrawRect;
    [self setNeedsDisplay];
}

- (void)setIsShowDXW:(BOOL)isShowDXW {
    _isShowDXW = isShowDXW;
    [self setNeedsDisplay];
}

- (void)setIsShowBDW:(BOOL)isShowBDW {
    _isShowBDW = isShowBDW;
    [self setNeedsDisplay];
}

- (void)setIsShowZLSQ:(BOOL)isShowZLSQ {
    _isShowZLSQ = isShowZLSQ;
    [self setNeedsDisplay];
}

- (void)setIsShowZLQS:(BOOL)isShowZLQS {
    _isShowZLQS = isShowZLQS;
    [self setNeedsDisplay];
}

- (instancetype)initWithFrame:(CGRect)frame
                        datas:(NSArray<KLineModel *> *)datas
                      scrollX:(CGFloat)scrollX
                       isLine:(BOOL)isLine
                       scaleX:(CGFloat)scaleX
                  isLongPress:(BOOL)isLongPress
                    mainState:(MainState)mainState
               secondaryState:(SecondaryState)secondaryState
{
    self = [super initWithFrame:frame];
    if (self) {
        self.datas = datas;
        self.scrollX = scrollX;
        self.isLine = isLine;
        self.scaleX = scaleX;
        self.isLongPress = isLongPress;
        self.mainState = mainState;
        self.secondaryState = secondaryState;
        self.candleWidth = ChartStyle_candleWidth * self.scaleX;
        
        self.fullScreenBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.fullScreenBtn setFrame:CGRectMake(self.size.width - 30, self.size.height - ChartStyle_bottomDateHigh - 30, 36, 36)];
        [self.fullScreenBtn setImage:[UIImage imageNamed:@"full_screen_btn"] forState:UIControlStateNormal];
        [self.fullScreenBtn addTarget:self action:@selector(fullScreenBtnClick) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.fullScreenBtn];
        
        self.selectIndexBtn = [QMUIButton buttonWithType:UIButtonTypeCustom];
        //[self.selectIndexBtn setFrame:CGRectMake(5, CGRectGetMinY(self.secondaryRect), 50, 15)];
        [self.selectIndexBtn setTitle:@"MACD" forState:UIControlStateNormal];
        [self.selectIndexBtn setTitleColor:WhiteColor forState:UIControlStateNormal];
        self.selectIndexBtn.titleLabel.font = MFont(14);
        [self.selectIndexBtn setImage:[UIImage imageNamed:@"icon_gray_arrow"] forState:UIControlStateNormal];
        self.selectIndexBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        self.selectIndexBtn.imagePosition = QMUIButtonImagePositionRight;
        self.selectIndexBtn.spacingBetweenImageAndTitle = 4;
        [self.selectIndexBtn addTarget:self action:@selector(selectIndexBtnClick) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.selectIndexBtn];
        
        [self initPopWindow];
    }
    return self;
}

- (void)initPopWindow {
    self.popWindow = [[QMUIPopupMenuView alloc] init];
    self.popWindow.backgroundColor = [UIColor colorWithHexString:@"#262626"];
    self.popWindow.automaticallyHidesWhenUserTap = YES;// 点击空白地方消失浮层
    self.popWindow.preferLayoutDirection = QMUIPopupContainerViewLayoutDirectionBelow;//
    self.popWindow.maximumWidth = 100;
    self.popWindow.itemHeight = 30;
    self.popWindow.arrowSize = CGSizeMake(8, 3);
    self.popWindow.maskViewBackgroundColor = [UIColor clearColor];
    //self.popWindow.shouldShowItemSeparator = YES;
    self.popWindow.itemTitleColor = [UIColor whiteColor];
    self.popWindow.itemTitleFont = MFont(14);
    self.popWindow.items = @[[QMUIPopupMenuButtonItem itemWithImage:nil title:@"VOL" handler:^(QMUIPopupMenuButtonItem * _Nonnull aItem) {
        [aItem.menuView hideWithAnimated:YES];
        [self.selectIndexBtn setTitle:@"VOL" forState:UIControlStateNormal];
        self.secondaryState = SecondaryStateVOL;
        [self.delegate selectIndex:@"VOL"];
    }],[QMUIPopupMenuButtonItem itemWithImage:nil title:@"MACD" handler:^(QMUIPopupMenuButtonItem * _Nonnull aItem) {
        [aItem.menuView hideWithAnimated:YES];
        self.secondaryState = SecondaryStateMacd;
        [self.selectIndexBtn setTitle:@"MACD" forState:UIControlStateNormal];
        [self.delegate selectIndex:@"MACD"];
    }],[QMUIPopupMenuButtonItem itemWithImage:nil title:@"买卖点位" handler:^(QMUIPopupMenuButtonItem * _Nonnull aItem) {
        [aItem.menuView hideWithAnimated:YES];
        self.secondaryState = SecondaryStateMMDW;
        [self.selectIndexBtn setTitle:@"买卖点位" forState:UIControlStateNormal];
        [self.delegate selectIndex:@"买卖点位"];
    }]];
    self.popWindow.itemConfigurationHandler = ^(QMUIPopupMenuView *aMenuView, QMUIPopupMenuButtonItem *aItem, NSInteger section, NSInteger index) {
        // 利用 itemConfigurationHandler 批量设置所有 item 的样式
        aItem.highlightedBackgroundColor = [UIColor clearColor];
    };
    self.popWindow.sourceView = self.selectIndexBtn;
}

- (void)drawRect:(CGRect)rect {
    _displayHeight = rect.size.height - ChartStyle_topPadding - ChartStyle_bottomDateHigh;
    CGContextRef context = UIGraphicsGetCurrentContext();
    if(context != NULL) {
        [self divisionRect];
        [self calculateValue];
        [self calculateFormats];
        [self initRenderer];
        [self drawBgColor:context rect:rect];
        [self drawGrid:context];
        if(self.datas.count == 0) { return; }
        [self drawcEntresDataRect:context];
        [self drawPen:context];
        [self drawChart:context];
        if (_isLine) {
            [self drawTime:context];
        }
        [self drawRightText:context];
        [self drawDate:context];
        [self drawMaxAndMin:context];
        [self drawcSalePointMark:context];
        if(_isLongPress) {
            [self drawLongPressCrossLine:context];
        }
        if(_singleTagPress) {
            [self drawTagPressCrossLine:context];
        }
        [self drawTopText:context curPoint:self.datas.firstObject];
        [self drawcLineDashRect:context];
        //[self drawRealTimePrice:context];
    }
}

- (void)selectIndexBtnClick {
    if (self.popWindow.isShowing) {
        [self.popWindow hideWithAnimated:YES];
    } else {
        [self.popWindow showWithAnimated:YES];
    }
}

- (void)fullScreenBtnClick {
    if (_delegate && [_delegate respondsToSelector:@selector(fullScreen)]) {
        [_delegate fullScreen];
    }
}

-(void)divisionRect {
    CGFloat mainHeight = self.displayHeight * 0.6;
    CGFloat volHeigt = self.displayHeight * 0.2;
    CGFloat secondaryHeight = self.displayHeight * 0.2;
    if(_volState == VolStateNONE && _secondaryState == SecondaryStateNONE) {
        mainHeight = self.displayHeight;
    } else if (_volState == VolStateNONE || _secondaryState == SecondaryStateNONE) {
        mainHeight = self.displayHeight * 0.8;
    }
    self.mainRect = CGRectMake(0, ChartStyle_topPadding, self.frame.size.width, mainHeight);
    if(_direction == KLineDirectionHorizontal) {
        self.dateRect = CGRectMake(0, CGRectGetMaxY(_mainRect), self.frame.size.width, ChartStyle_bottomDateHigh);
        if(_volState != VolStateNONE) {
            self.volRect = CGRectMake(0, CGRectGetMaxY(_dateRect), self.frame.size.width, volHeigt);
        }
        if(_secondaryState != SecondaryStateNONE) {
            CGFloat y =  CGRectGetMaxY(_volRect);
            self.secondaryRect = CGRectMake(0, y, self.frame.size.width, secondaryHeight);
        }
    } else {
        
        if(_volState != VolStateNONE) {
            self.volRect = CGRectMake(0, CGRectGetMaxY(_mainRect), self.frame.size.width, volHeigt);
        }
        if(_secondaryState != SecondaryStateNONE) {
            CGFloat y =  CGRectGetMaxY(_volRect);
            self.secondaryRect = CGRectMake(0, y, self.frame.size.width, secondaryHeight);
        }
        self.dateRect = CGRectMake(0,  self.displayHeight + ChartStyle_topPadding, self.frame.size.width, ChartStyle_bottomDateHigh);
    }
    
    [self.selectIndexBtn setFrame:CGRectMake(5, CGRectGetMinY(self.secondaryRect) + 2, 85, 15)];
}

-(void)calculateValue {
    if(self.datas.count == 0) { return; }
    CGFloat itemWidth;
    if (_isLine) {
        itemWidth = (screenW - SafeAreaInsetsConstantForDeviceWithNotch.left - SafeAreaInsetsConstantForDeviceWithNotch.right - ChartStyle_buySaleViewWidth) / ChartStyle_timeSection;
        
        self.startX = 0;
        self.startIndex = 0;
        if (_isLine) {
            for (int i = 0; i < self.datas.count; i++) {
                KLineModel *klineModel = self.datas[i];
                if (klineModel.isShowCurrentIndex) {
                    self.startIndex = i;
                    break;
                }
            }
        }
    }else {
        itemWidth = _candleWidth + ChartStyle_canldeMargin;
        
        if(_scrollX <= 0) {
            self.startX = -_scrollX;
            self.startIndex = 0;
        } else {
            CGFloat start = _scrollX / itemWidth;
            CGFloat offsetX = 0;
            if(floor(start) == ceil(start)) {
                _startIndex = (NSUInteger)floor(start);
            } else {
                _startIndex = (NSUInteger)(floor(_scrollX / itemWidth));
                offsetX = (CGFloat)_startIndex * itemWidth - _scrollX;
            }
            self.startX = offsetX;
        }
    }
    
    NSUInteger diffIndex = (NSUInteger)(ceil(self.frame.size.width - self.startX) / itemWidth);
    _stopIndex = MIN(_startIndex + diffIndex, self.datas.count - 1);
    
    //NSLog(@"xxxxx = %f",self.frame.size.width/itemWidth);
    _mMainMaxValue = -CGFLOAT_MAX;
    _mMainMinValue = CGFLOAT_MAX;
    _mMainHighMaxValue = -CGFLOAT_MAX;
    _mMainLowMinValue = CGFLOAT_MAX;
    _mVolMaxValue = -CGFLOAT_MAX;
    _mVolMinValue = CGFLOAT_MAX;
    _mSecondaryMaxValue = -CGFLOAT_MAX;
    _mSecondaryMinValue = CGFLOAT_MAX;
    for (NSUInteger index = _startIndex; index <= _stopIndex; index++) {
        KLineModel *item = self.datas[index];
        [self getMianMaxMinValue:item i:index];
        [self getVolMaxMinValue:item];
        [self getSecondaryMaxMinValue:item];
    }
    
    //NSLog(@"startIndex=%ld,endIndex=%ld",_startIndex, _stopIndex);
}

-(void)getMianMaxMinValue:(KLineModel *)item i:(NSUInteger)i {
    if (_isLine == true) {
        if (item.close != 0) {
            _mMainMaxValue = MAX(_mMainMaxValue, item.close);
            _mMainMinValue = MIN(_mMainMinValue, item.close);
        }
    } else {
        CGFloat maxPrice = item.high;
        CGFloat minPrice = item.low;
        if (_mainState == MainStateMA) {
            if(item.MA5Price != 0){
                maxPrice = MAX(maxPrice, item.MA5Price);
                minPrice = MIN(minPrice, item.MA5Price);
            }
            if(item.MA10Price != 0){
                maxPrice = MAX(maxPrice, item.MA10Price);
                minPrice = MIN(minPrice, item.MA10Price);
            }
            if(item.MA20Price != 0){
                maxPrice = MAX(maxPrice, item.MA20Price);
                minPrice = MIN(minPrice, item.MA20Price);
            }
            if(item.MA30Price != 0){
                maxPrice = MAX(maxPrice, item.MA30Price);
                minPrice = MIN(minPrice, item.MA30Price);
            }
        } else if (_mainState == MainStateBOLL) {
            if(item.up != 0){
                maxPrice = MAX(item.up, item.high);
            }
            if(item.dn != 0){
                minPrice = MIN(item.dn, item.low);
            }
        }
        _mMainMaxValue = MAX(_mMainMaxValue, maxPrice);
        _mMainMinValue = MIN(_mMainMinValue, minPrice);
        
        if (_mMainHighMaxValue < item.high) {
            _mMainHighMaxValue = item.high;
            _mMainMaxIndex = i;
        }
        if (_mMainLowMinValue > item.low) {
            _mMainLowMinValue = item.low;
            _mMainMinIndex = i;
        }
    }
}
-(void)getVolMaxMinValue:(KLineModel *)item {
    _mVolMaxValue = MAX(_mVolMaxValue, MAX(item.hdlyHigh, MAX(item.horizon, item.monthLine)));
    _mVolMinValue = MIN(_mVolMinValue, MIN(item.hdlyHigh, MIN(item.horizon, item.monthLine)));
}

-(void)getSecondaryMaxMinValue:(KLineModel *)item {
    if (_secondaryState == SecondaryStateMacd) {
        _mSecondaryMaxValue = MAX(_mSecondaryMaxValue, MAX(item.macd, MAX(item.dif, item.dea)));
        _mSecondaryMinValue = MIN(_mSecondaryMinValue, MIN(item.macd, MIN(item.dif, item.dea)));
    }else if (_secondaryState == SecondaryStateVOL) {
        _mSecondaryMaxValue = MAX(_mSecondaryMaxValue, MAX(item.vol, MAX(item.MA5Volume, item.MA10Volume)));
        _mSecondaryMinValue = MIN(_mSecondaryMinValue, MIN(item.vol, MIN(item.MA5Volume, item.MA10Volume)));
    }else if (_secondaryState == SecondaryStateMMDW) {
        _mSecondaryMaxValue = MAX(_mSecondaryMaxValue, item.X0);
        _mSecondaryMinValue = MIN(_mSecondaryMinValue, item.X0);
    }
    else if (_secondaryState == SecondaryStateKDJ) {
        _mSecondaryMaxValue = MAX(_mSecondaryMaxValue, MAX(item.k, MAX(item.d, item.j)));
        _mSecondaryMinValue = MIN(_mSecondaryMinValue, MIN(item.k, MIN(item.d, item.j)));
    } else if (_secondaryState == SecondaryStateRSI) {
        _mSecondaryMaxValue = MAX(_mSecondaryMaxValue, item.rsi);
        _mSecondaryMinValue = MIN(_mSecondaryMinValue, item.rsi);
    } else {
        _mSecondaryMaxValue = MAX(_mSecondaryMaxValue, item.r);
        _mSecondaryMinValue = MIN(_mSecondaryMinValue, item.r);
    }
}

-(void)calculateFormats {
    if(self.datas.count < 2) { return; }
    NSTimeInterval fristtime = 0;
    NSTimeInterval secondTime = 0;
    NSTimeInterval time = ABS(fristtime - secondTime);
    if(time >= 24 * 60 * 60 * 28) {
        self.fromat = @"yyyy-MM";
    } else if(time >= 24 * 60 * 60) {
        self.fromat = @"yyyy-MM-dd";
    } else {
        self.fromat = @"MM-dd HH:mm";
    }
}

-(void)initRenderer {
    if (_isLine) {
        _candleWidth = (screenW - SafeAreaInsetsConstantForDeviceWithNotch.left - SafeAreaInsetsConstantForDeviceWithNotch.right - ChartStyle_buySaleViewWidth)/ChartStyle_timeSection;
    }else {
        _candleWidth = ChartStyle_candleWidth * self.scaleX;
    }
    _mainRenderer = [[MainChartRenderer alloc] initWithMaxValue:_mMainMaxValue minValue:_mMainMinValue chartRect:_mainRect candleWidth:_candleWidth topPadding:ChartStyle_topPadding isLine:_isLine state:_mainState];
    if(_volState != VolStateNONE) {
        _volRenderer = [[VolChartRenderer alloc] initWithMaxValue:_mVolMaxValue minValue:_mVolMinValue chartRect:_volRect candleWidth:_candleWidth topPadding:ChartStyle_childPadding isLine:_isLine];
    }
    if(_secondaryState != SecondaryStateNONE) {
        _seconderyRender = [[SecondaryChartRenderer alloc] initWithMaxValue:_mSecondaryMaxValue minValue:_mSecondaryMinValue chartRect:_secondaryRect candleWidth:_candleWidth topPadding:ChartStyle_childPadding state:_secondaryState isLine:_isLine];
    }
}

-(void)drawBgColor:(CGContextRef)context rect:(CGRect)rect {
    CGContextSetFillColorWithColor(context, MinorColor.CGColor);
    CGContextFillRect(context, rect);
    [_mainRenderer drawBg:context];
    if(_volRenderer != nil) {
        [_volRenderer drawBg:context];
    }
    if(_seconderyRender != nil) {
        [_seconderyRender drawBg:context];
    }
}
-(void)drawGrid:(CGContextRef)context {
    [_mainRenderer drawGrid:context gridRows:ChartStyle_gridRows gridColums:ChartStyle_gridColumns];
    if(_volRenderer != nil) {
        [_volRenderer drawGrid:context gridRows:ChartStyle_gridRows gridColums:ChartStyle_gridColumns];
    }
    if(_seconderyRender != nil) {
        [_seconderyRender drawGrid:context gridRows:ChartStyle_gridRows gridColums:ChartStyle_gridColumns];
    }
    CGContextSetLineWidth(context, 1);
    CGContextAddRect(context, self.bounds);
    CGContextDrawPath(context, kCGPathStroke);
}

-(void)drawcEntresDataRect:(CGContextRef)context {
    if(_isLine || !_isShowDrawRect) { return; }
    for (NSUInteger index = _startIndex; index <= _stopIndex; index++) {
        KLineModel *startPoint = self.datas[_startIndex];
        KLineModel *stopPoint = self.datas[_stopIndex];
        KLineModel *curPoint = self.datas[index];
        
        CGFloat itemWidth = _candleWidth + ChartStyle_canldeMargin;
        CGFloat curX = (CGFloat)(index - _startIndex) * itemWidth + _startX;
        CGFloat _curX = self.frame.size.width - curX - _candleWidth / 2;
        
        if (curPoint.isNeedDrawRect) {
            UIColor *curColor = nil;
            if (curPoint.direction == 1) {
                if (curPoint.num <= 7) {
                    curColor = rectColors_up_min_bgColor;
                }else {
                    curColor = rectColors_up_max_bgColor;
                }
            }else {
                if (curPoint.num <= 7) {
                    curColor = rectColors_down_min_bgColor;
                }else {
                    curColor = rectColors_down_max_bgColor;
                }
            }
            
            if (startPoint.minRectTag == stopPoint.minRectTag && startPoint.minRectTag != 0 && stopPoint.minRectTag != 0) {
                [_mainRenderer drawcEntresDataRect:context curPoint:curPoint curX:_curX isSameArea:YES color:curColor];
            }else {
                [_mainRenderer drawcEntresDataRect:context curPoint:curPoint curX:_curX isSameArea:NO color:curColor];
            }
        }
        
        if (curPoint.isNeedDrawMark) {
            [_mainRenderer drawcEntresMark:context curPoint:curPoint curX:_curX];
        }
    }
}

-(void)drawPen:(CGContextRef)context {
    if(_isLine || !_isShowDrawPen) { return; }
    for (NSUInteger index = _startIndex; index <= _stopIndex; index++) {
        if (index < (self.datas.count-1)){
            KLineModel *priorPoint = self.datas[index+1];
            KLineModel *curPoint = self.datas[index];
            CGFloat itemWidth = _candleWidth + ChartStyle_canldeMargin;
            CGFloat curX = (CGFloat)(index - _startIndex) * itemWidth + _startX;
            CGFloat _curX = self.frame.size.width - curX - _candleWidth / 2;
            
            [_mainRenderer drawPen:context priorPoint:priorPoint curPoint:curPoint curX:_curX];
        }
    }
}

-(void)drawTime:(CGContextRef)context {
    for (NSUInteger index = _startIndex; index <= _stopIndex; index++) {
        KLineModel *curPoint = self.datas[index];
        
        CGFloat _curX = self.frame.size.width - index * (screenW - SafeAreaInsetsConstantForDeviceWithNotch.left - SafeAreaInsetsConstantForDeviceWithNotch.right - ChartStyle_buySaleViewWidth)/ChartStyle_timeSection;
        KLineModel *lastPoint;
        if(index != _startIndex) {
            lastPoint = self.datas[index - 1];
        }
        
        [_mainRenderer drawTime:context lastPoit:lastPoint curPoint:curPoint curX:_curX];
        
        if(_volRenderer != nil) {
            [_volRenderer drawChart:context lastPoit:lastPoint curPoint:curPoint curX:_curX];
        }
        if(_seconderyRender != nil) {
            [_seconderyRender drawChart:context lastPoit:lastPoint curPoint:curPoint curX:_curX];
        }
    }
}

-(void)drawChart:(CGContextRef)context {
    if(_isLine) { return; }
    
    for (NSUInteger index = _startIndex; index <= _stopIndex; index++) {
        KLineModel *curPoint = self.datas[index];
        CGFloat itemWidth = _candleWidth + ChartStyle_canldeMargin;
        CGFloat curX = (CGFloat)(index - _startIndex) * itemWidth + _startX;
        CGFloat _curX = self.frame.size.width - curX - _candleWidth / 2;
        KLineModel *lastPoint;
        if(index != _startIndex) {
            lastPoint = self.datas[index - 1];
        }
        
        [_mainRenderer drawChart:context lastPoit:lastPoint curPoint:curPoint curX:_curX];
        if(_volRenderer != nil) {
            [_volRenderer drawChart:context lastPoit:lastPoint curPoint:curPoint curX:_curX];
        }
        if(_seconderyRender != nil) {
            [_seconderyRender drawChart:context lastPoit:lastPoint curPoint:curPoint curX:_curX];
        }
        
        if (lastPoint != nil) {
            if (_isShowDXW) {
                if(curPoint.MA20Price != 0) {
                    [_mainRenderer drawLine:context lineWidth:1 lastValue:lastPoint.MA20Price curValue:curPoint.MA20Price curX:_curX color:[UIColor colorWithHexString:@"#C4407F"]];
                }
                if(curPoint.MA30Price != 0) {
                    [_mainRenderer drawLine:context lineWidth:1 lastValue:lastPoint.MA30Price curValue:curPoint.MA30Price curX:_curX color:[UIColor colorWithHexString:@"#9CABE8"]];
                }
            }
            
            if (_isShowBDW) {
                if(curPoint.MA30Price != 0) {
                    [_mainRenderer drawLine:context lineWidth:1 lastValue:lastPoint.MA30Price curValue:curPoint.MA30Price curX:_curX color:[UIColor colorWithHexString:@"#C4407F"]];
                }
                if(curPoint.MA60Price != 0) {
                    [_mainRenderer drawLine:context lineWidth:1 lastValue:lastPoint.MA60Price curValue:curPoint.MA60Price curX:_curX color:[UIColor colorWithHexString:@"#9CABE8"]];
                }
            }
            
            if (_isShowZLSQ) {
                if(curPoint.MA120Price != 0) {
                    [_mainRenderer drawLine:context lineWidth:1 lastValue:lastPoint.MA120Price curValue:curPoint.MA120Price curX:_curX color:[UIColor colorWithHexString:@"#009ECA"]];
                }
                if(curPoint.MA250Price != 0) {
                    [_mainRenderer drawLine:context lineWidth:1 lastValue:lastPoint.MA250Price curValue:curPoint.MA250Price curX:_curX color:[UIColor colorWithHexString:@"#CB9E81"]];
                }
            }
            
            if (_isShowZLQS) {
                if(curPoint.MA55Price != 0) {
                    [_mainRenderer drawLine:context lineWidth:1 lastValue:lastPoint.MA55Price curValue:curPoint.MA55Price curX:_curX color:[UIColor colorWithHexString:@"#FA1C13"]];
                }
                if(curPoint.MA60Price != 0) {
                    [_mainRenderer drawLine:context lineWidth:1 lastValue:lastPoint.MA60Price curValue:curPoint.MA60Price curX:_curX color:[UIColor colorWithHexString:@"#FFFFFF"]];
                }
                if(curPoint.MA65Price != 0) {
                    [_mainRenderer drawLine:context lineWidth:1 lastValue:lastPoint.MA65Price curValue:curPoint.MA65Price curX:_curX color:[UIColor colorWithHexString:@"#33FB29"]];
                }
                if(curPoint.MA120Price != 0) {
                    [_mainRenderer drawLine:context lineWidth:4 lastValue:lastPoint.MA120Price curValue:curPoint.MA120Price curX:_curX color:[UIColor colorWithHexString:@"#33FB29"]];
                }
                if(curPoint.MA250Price != 0) {
                    [_mainRenderer drawLine:context lineWidth:6 lastValue:lastPoint.MA250Price curValue:curPoint.MA250Price curX:_curX color:[UIColor colorWithHexString:@"#F92AFB"]];
                }
            }
        }
    }
}

-(void)drawRightText:(CGContextRef)context {
    [_mainRenderer drawRightText:context gridRows:ChartStyle_gridRows gridColums:ChartStyle_gridColumns];
    if(_volRenderer != nil) {
        [_volRenderer drawRightText:context gridRows:ChartStyle_gridRows gridColums:ChartStyle_gridColumns];
    }
    if(_seconderyRender != nil) {
        [_seconderyRender drawRightText:context gridRows:ChartStyle_gridRows gridColums:ChartStyle_gridColumns];
    }
}
-(void)drawDate:(CGContextRef)context {
    if (_isLine) {
        CGFloat cloumSpace = self.frame.size.width / (CGFloat)TimeStyle_gridColumns;
        for (int i = 0; i < TimeStyle_gridColumns + 1; i++) {
            NSUInteger index = [self calculateIndexWithSelectX: cloumSpace * (CGFloat)i];
            if (index != 0) { index -= 1;}
            if([self outRangeIndex:index]) { continue; }
            KLineModel *data = self.datas[index];
            CGRect rect = [data.date getRectWithFontSize:ChartStyle_bottomDatefontSize];
            CGFloat y = CGRectGetMinY(self.dateRect) + (ChartStyle_bottomDateHigh - rect.size.height) / 2;
            
            if (i == 0) {
                [self.mainRenderer drawText:data.date atPoint:CGPointMake(0, y) fontSize:ChartStyle_bottomDatefontSize textColor:ChartColors_bottomDateTextColor];
            }else if (i == TimeStyle_gridColumns) {
                [self.mainRenderer drawText:data.date atPoint:CGPointMake(cloumSpace * i - rect.size.width , y) fontSize:ChartStyle_bottomDatefontSize textColor:ChartColors_bottomDateTextColor];
            }else {
                [self.mainRenderer drawText:data.date atPoint:CGPointMake(cloumSpace * i - rect.size.width / 2, y) fontSize:ChartStyle_bottomDatefontSize textColor:ChartColors_bottomDateTextColor];
            }
        }
    }else {
        CGFloat cloumSpace = self.frame.size.width / (CGFloat)ChartStyle_gridColumns;
        for (int i = 0; i < ChartStyle_gridColumns + 1; i++) {
            NSUInteger index = [self calculateIndexWithSelectX: cloumSpace * (CGFloat)i];
            if([self outRangeIndex:index]) { continue; }
            KLineModel *data = self.datas[index];
            
            NSString *timeStr = @"";
            //分钟线不显示年份，否则显示不完
            NSArray *arr = [data.date componentsSeparatedByString:@" "];
            if (arr.count > 1) {
                NSArray *array = [arr[0] componentsSeparatedByString:@"-"];
                if (array.count > 2) {
                    timeStr = [NSString stringWithFormat:@"%@-%@ %@",array[1],array[2],arr[1]];
                }else {
                    timeStr = data.date;
                }
            }else {
                timeStr = data.date;
            }
            CGRect rect = [timeStr getRectWithFontSize:ChartStyle_bottomDatefontSize];
            CGFloat y = CGRectGetMinY(self.dateRect) + (ChartStyle_bottomDateHigh - rect.size.height) / 2;
            
            if (i == 0) {
                [self.mainRenderer drawText:timeStr atPoint:CGPointMake(0, y) fontSize:ChartStyle_bottomDatefontSize textColor:ChartColors_bottomDateTextColor];
            }else if (i == ChartStyle_gridColumns) {
                [self.mainRenderer drawText:timeStr atPoint:CGPointMake(cloumSpace * i - rect.size.width , y) fontSize:ChartStyle_bottomDatefontSize textColor:ChartColors_bottomDateTextColor];
            }else {
                [self.mainRenderer drawText:timeStr atPoint:CGPointMake(cloumSpace * i - rect.size.width / 2, y) fontSize:ChartStyle_bottomDatefontSize textColor:ChartColors_bottomDateTextColor];
            }
        }
    }
}
-(void)drawMaxAndMin:(CGContextRef)context {
    if(_isLine) { return; }
    CGFloat itemWidth = self.candleWidth + ChartStyle_canldeMargin;
    CGFloat y1 = [self.mainRenderer getY:_mMainHighMaxValue];
    CGFloat x1 = self.frame.size.width - ((self.mMainMaxIndex - self.startIndex) * itemWidth + self.startX + self.candleWidth / 2);
    if(x1 < self.frame.size.width / 2) {
        NSString *text = [NSString stringWithFormat:@"——%.2f",_mMainHighMaxValue];
        CGRect rect = [text getRectWithFontSize:ChartStyle_defaultTextSize];
        [self.mainRenderer drawText:text atPoint:CGPointMake(x1, y1 - rect.size.height / 2) fontSize:ChartStyle_defaultTextSize textColor:[UIColor whiteColor]];
    } else {
        NSString *text = [NSString stringWithFormat:@"%.2f——",_mMainHighMaxValue];
        CGRect rect = [text getRectWithFontSize:ChartStyle_defaultTextSize];
        [self.mainRenderer drawText:text atPoint:CGPointMake(x1 - rect.size.width, y1 - rect.size.height / 2) fontSize:ChartStyle_defaultTextSize textColor:[UIColor whiteColor]];
    }
    
    CGFloat y2 = [self.mainRenderer getY:_mMainLowMinValue];
    CGFloat x2 = self.frame.size.width - ((self.mMainMinIndex - self.startIndex) * itemWidth + self.startX + self.candleWidth / 2);
    if(x2 < self.frame.size.width / 2) {
        NSString *text = [NSString stringWithFormat:@"——%.2f",_mMainLowMinValue];
        CGRect rect = [text getRectWithFontSize:ChartStyle_defaultTextSize];
        [self.mainRenderer drawText:text atPoint:CGPointMake(x2, y2 - rect.size.height / 2) fontSize:ChartStyle_defaultTextSize textColor:[UIColor whiteColor]];
    } else {
        NSString *text = [NSString stringWithFormat:@"%.2f——",_mMainLowMinValue];
        CGRect rect = [text getRectWithFontSize:ChartStyle_defaultTextSize];
        [self.mainRenderer drawText:text atPoint:CGPointMake(x2 - rect.size.width, y2 - rect.size.height / 2) fontSize:ChartStyle_defaultTextSize textColor:[UIColor whiteColor]];
    }
}

-(void)drawcSalePointMark:(CGContextRef)context {
    if(_isLine) { return; }
    for (NSUInteger index = _startIndex; index <= _stopIndex; index++) {
        KLineModel *curPoint = self.datas[index];
        
        CGFloat itemWidth = _candleWidth + ChartStyle_canldeMargin;
        CGFloat curX = (CGFloat)(index - _startIndex) * itemWidth + _startX;
        CGFloat _curX = self.frame.size.width - curX - _candleWidth / 2;
        
        if (curPoint.isNeedDrawSale1Point || curPoint.isNeedDrawSale3Point) {
            [_mainRenderer drawcSalePointMark:context curPoint:curPoint curX:_curX];
        }
    }
}

-(void)drawcLineDashRect:(CGContextRef)context {
    if(_isLine || !_isShowDrawRect) { return; }
    for (NSUInteger index = _startIndex; index <= _stopIndex; index++) {
        KLineModel *startPoint = self.datas[_startIndex];
        KLineModel *stopPoint = self.datas[_stopIndex];
        KLineModel *curPoint = self.datas[index];
        
        CGFloat itemWidth = _candleWidth + ChartStyle_canldeMargin;
        CGFloat curX = (CGFloat)(index - _startIndex) * itemWidth + _startX;
        CGFloat _curX = self.frame.size.width - curX - _candleWidth / 2;
        
        if (curPoint.isNeedDrawExtendRect) {
            
            UIColor *curColor = nil;
            
            if (curPoint.extendRectDirection == 1) {
                if (curPoint.extendRectNum <= 7) {
                    curColor = rangesColors_up_min_bgColor;
                }else {
                    curColor = rangesColors_up_max_bgColor;
                }
            }else {
                if (curPoint.extendRectNum <= 7) {
                    curColor = rangesColors_down_min_bgColor;
                }else {
                    curColor = rangesColors_down_max_bgColor;
                }
            }
            
            if (startPoint.maxRectTag == stopPoint.maxRectTag && startPoint.maxRectTag != 0 && stopPoint.maxRectTag != 0) {
                [_mainRenderer drawcLineDashRect:context curPoint:curPoint curX:_curX isSameArea:YES color:curColor];
            }else {
                [_mainRenderer drawcLineDashRect:context curPoint:curPoint curX:_curX isSameArea:NO color:curColor];
            }
        }
        
        if (curPoint.isNeedDrawExtendMark) {
            
            UIColor *curColor = nil;
            
            if (curPoint.extendRectDirection == 1) {
                if (curPoint.extendRectNum == 2) {
                    curColor = rangesColors_up_min_bgColor;
                }else {
                    curColor = rangesColors_up_max_bgColor;
                }
            }else {
                if (curPoint.extendRectNum == 2) {
                    curColor = rangesColors_down_min_bgColor;
                }else {
                    curColor = rangesColors_down_max_bgColor;
                }
            }
            
            if (startPoint.maxRectTag == stopPoint.maxRectTag && startPoint.maxRectTag != 0 && stopPoint.maxRectTag != 0) {
                [_mainRenderer drawExtendMark:context curPoint:curPoint curX:_curX isSameArea:YES color:curColor];
            }else {
                [_mainRenderer drawExtendMark:context curPoint:curPoint curX:_curX isSameArea:NO color:curColor];
            }
        }
    }
}

-(void)drawTagPressCrossLine:(CGContextRef)context {
    if (_isLine) {
        NSUInteger index = [self calculateIndexWithSelectX:self.singleTagX];
        if (index != 0) { index -= 1;}
        if([self outRangeIndex:index]) { return; }
        KLineModel *point = self.datas[index];
        CGFloat itemWidth = (screenW - SafeAreaInsetsConstantForDeviceWithNotch.left - SafeAreaInsetsConstantForDeviceWithNotch.right - ChartStyle_buySaleViewWidth) / ChartStyle_timeSection;
        CGFloat curX = (self.stopIndex - self.startIndex) * itemWidth - ((index - self.startIndex) * itemWidth + self.startX + itemWidth / 2);
        //CGFloat curX = self.frame.size.width - ((index - self.startIndex) * itemWidth + self.startX + itemWidth / 2);
        CGContextSetStrokeColorWithColor(context, [UIColor whiteColor].CGColor);
        CGContextSetLineWidth(context, 1);
        CGContextMoveToPoint(context, curX, 0);
        CGContextAddLineToPoint(context, curX, self.frame.size.height);
        CGContextDrawPath(context, kCGPathStroke);
        
        CGFloat y = [self.mainRenderer getY:point.close];
        
        CGContextSetStrokeColorWithColor(context, [UIColor whiteColor].CGColor);
        CGContextSetLineWidth(context, 0.5);
        CGContextMoveToPoint(context, 0, y);
        CGContextAddLineToPoint(context, self.frame.size.width, y);
        CGContextDrawPath(context, kCGPathStroke);
        
        CGContextSetFillColorWithColor(context, [UIColor whiteColor].CGColor);
        CGContextAddArc(context, curX, y, 2, 0, M_PI_2, true);
        CGContextDrawPath(context, kCGPathFill);
        [self drawLongPressCrossLineText:context curPoint:point curX:curX y:y];
    }else {
        NSUInteger index = [self calculateIndexWithSelectX:self.singleTagX];
        if([self outRangeIndex:index]) { return; }
        KLineModel *point = self.datas[index];
        CGFloat itemWidth = _candleWidth + ChartStyle_canldeMargin;
        CGFloat curX = self.frame.size.width - ((index - self.startIndex) * itemWidth + self.startX + self.candleWidth / 2);
        CGContextSetStrokeColorWithColor(context, [UIColor whiteColor].CGColor);
        CGContextSetLineWidth(context, 0.5);
        CGContextMoveToPoint(context, curX, 0);
        CGContextAddLineToPoint(context, curX, self.frame.size.height);
        CGContextDrawPath(context, kCGPathStroke);
        
        CGFloat y = [self.mainRenderer getY:point.close];
        
        CGContextSetStrokeColorWithColor(context, [UIColor whiteColor].CGColor);
        CGContextSetLineWidth(context, 0.5);
        CGContextMoveToPoint(context, 0, y);
        CGContextAddLineToPoint(context, self.frame.size.width, y);
        CGContextDrawPath(context, kCGPathStroke);
        
        CGContextSetFillColorWithColor(context, [UIColor whiteColor].CGColor);
        CGContextAddArc(context, curX, y, 2, 0, M_PI_2, true);
        CGContextDrawPath(context, kCGPathFill);
        [self drawLongPressCrossLineText:context curPoint:point curX:curX y:y];
    }
}

-(void)drawLongPressCrossLine:(CGContextRef)context {
    if (_isLine) {
        NSUInteger index = [self calculateIndexWithSelectX:self.longPressX];
        if (index != 0) { index -= 1;}
        if([self outRangeIndex:index]) { return; }
        KLineModel *point = self.datas[index];
        CGFloat itemWidth = (screenW - SafeAreaInsetsConstantForDeviceWithNotch.left - SafeAreaInsetsConstantForDeviceWithNotch.right - ChartStyle_buySaleViewWidth) / ChartStyle_timeSection;
        CGFloat curX = (self.stopIndex - self.startIndex) * itemWidth - ((index - self.startIndex) * itemWidth + self.startX + itemWidth / 2);
        //CGFloat curX = self.frame.size.width - ((index - self.startIndex) * itemWidth + self.startX + itemWidth / 2);
        CGContextSetStrokeColorWithColor(context, [UIColor whiteColor].CGColor);
        CGContextSetLineWidth(context, 1);
        CGContextMoveToPoint(context, curX, 0);
        CGContextAddLineToPoint(context, curX, self.frame.size.height);
        CGContextDrawPath(context, kCGPathStroke);
        
        CGFloat y = [self.mainRenderer getY:point.close];
        
        CGContextSetStrokeColorWithColor(context, [UIColor whiteColor].CGColor);
        CGContextSetLineWidth(context, 0.5);
        CGContextMoveToPoint(context, 0, y);
        CGContextAddLineToPoint(context, self.frame.size.width, y);
        CGContextDrawPath(context, kCGPathStroke);
        
        CGContextSetFillColorWithColor(context, [UIColor whiteColor].CGColor);
        CGContextAddArc(context, curX, y, 2, 0, M_PI_2, true);
        CGContextDrawPath(context, kCGPathFill);
        [self drawLongPressCrossLineText:context curPoint:point curX:curX y:y];
    }else {
        NSUInteger index = [self calculateIndexWithSelectX:self.longPressX];
        if([self outRangeIndex:index]) { return; }
        KLineModel *point = self.datas[index];
        CGFloat itemWidth = _candleWidth + ChartStyle_canldeMargin;
        CGFloat curX = self.frame.size.width - ((index - self.startIndex) * itemWidth + self.startX + self.candleWidth / 2);
        CGContextSetStrokeColorWithColor(context, [UIColor whiteColor].CGColor);
        CGContextSetLineWidth(context, 0.5);
        CGContextMoveToPoint(context, curX, 0);
        CGContextAddLineToPoint(context, curX, self.frame.size.height);
        CGContextDrawPath(context, kCGPathStroke);
        
        CGFloat y = [self.mainRenderer getY:point.close];
        
        CGContextSetStrokeColorWithColor(context, [UIColor whiteColor].CGColor);
        CGContextSetLineWidth(context, 0.5);
        CGContextMoveToPoint(context, 0, y);
        CGContextAddLineToPoint(context, self.frame.size.width, y);
        CGContextDrawPath(context, kCGPathStroke);
        
        CGContextSetFillColorWithColor(context, [UIColor whiteColor].CGColor);
        CGContextAddArc(context, curX, y, 2, 0, M_PI_2, true);
        CGContextDrawPath(context, kCGPathFill);
        [self drawLongPressCrossLineText:context curPoint:point curX:curX y:y];
    }
}

-(void)drawLongPressCrossLineText:(CGContextRef)context curPoint:(KLineModel *)curPoint curX:(CGFloat)curX y:(CGFloat)y {
    NSString *text = [NSString stringWithFormat:@"%.2f",curPoint.close];
    CGRect rect = [text getRectWithFontSize:ChartStyle_defaultTextSize];
    CGFloat padding = 3;
    CGFloat textHeight = rect.size.height + padding * 2;
    CGFloat textWdith = rect.size.width;
    BOOL isLeft = false;
    if(curX > self.frame.size.width / 2) {
        isLeft = true;
        CGContextMoveToPoint(context, self.frame.size.width, y - textHeight / 2);
        CGContextAddLineToPoint(context, self.frame.size.width, y + textHeight / 2);
        
        CGContextAddLineToPoint(context, self.frame.size.width - textWdith, y + textHeight / 2);
        CGContextAddLineToPoint(context, self.frame.size.width - textWdith - 10, y);
        CGContextAddLineToPoint(context, self.frame.size.width - textWdith, y - textHeight / 2);
        CGContextAddLineToPoint(context, self.frame.size.width, y - textHeight / 2);
        CGContextSetLineWidth(context, 1);
        CGContextSetStrokeColorWithColor(context, ChartColors_markerBorderColor.CGColor);
        CGContextSetFillColorWithColor(context, ChartColors_markerBgColor.CGColor);
        CGContextDrawPath(context, kCGPathFillStroke);
        [self.mainRenderer drawText:text atPoint:CGPointMake(self.frame.size.width - textWdith - 2, y - rect.size.height / 2) fontSize:ChartStyle_defaultTextSize textColor: [UIColor whiteColor]];
    } else {
        isLeft = false;
        CGContextMoveToPoint(context, 0, y - textHeight / 2);
        CGContextAddLineToPoint(context, 0, y + textHeight / 2);
        
        CGContextAddLineToPoint(context, textWdith, y + textHeight / 2);
        CGContextAddLineToPoint(context,textWdith + 10, y);
        CGContextAddLineToPoint(context,textWdith, y - textHeight / 2);
        CGContextAddLineToPoint(context, 0, y - textHeight / 2);
        CGContextSetLineWidth(context, 1);
        CGContextSetStrokeColorWithColor(context, ChartColors_markerBorderColor.CGColor);
        CGContextSetFillColorWithColor(context, ChartColors_markerBgColor.CGColor);
        CGContextDrawPath(context, kCGPathFillStroke);
        [self.mainRenderer drawText:text atPoint:CGPointMake(2, y - rect.size.height / 2) fontSize:ChartStyle_defaultTextSize textColor: [UIColor whiteColor]];
    }
    
    //NSString *dateText = [self calculateDateText:curPoint.id];
    CGRect dateRect = [curPoint.date getRectWithFontSize:ChartStyle_defaultTextSize];
    CGFloat datepadding = 3;
    CGContextSetStrokeColorWithColor(context, [UIColor whiteColor].CGColor);
    CGContextSetFillColorWithColor(context, ChartColors_bgColor.CGColor);
    CGContextAddRect(context, CGRectMake(curX - dateRect.size.width / 2 - datepadding, CGRectGetMinY(self.dateRect), dateRect.size.width + datepadding * 2, dateRect.size.height + datepadding * 2));
    CGContextDrawPath(context, kCGPathFillStroke);
    [self.mainRenderer drawText:curPoint.date atPoint:CGPointMake(curX - dateRect.size.width  / 2, CGRectGetMinY(self.dateRect) + datepadding) fontSize:ChartStyle_defaultTextSize textColor: [UIColor whiteColor]];
//    if (_isLine) {
//        self.showTimeInfoBlock(curPoint, isLeft);
//    }else {
//        self.showInfoBlock(curPoint, isLeft);
//    }
    self.updateKlineInfoBlock(curPoint);
    [self drawTopText:context curPoint:curPoint];
}

-(void)drawTopText:(CGContextRef)context curPoint:(KLineModel *)curPoint {
    //[_mainRenderer drawTopText:context curPoint:curPoint];
    if(_volRenderer != nil) {
        [_volRenderer drawTopText:context curPoint:curPoint];
    }
//    if(_seconderyRender != nil) {
//        [_seconderyRender drawTopText:context curPoint:curPoint];
//    }
}
-(void)drawRealTimePrice:(CGContextRef)context {
    KLineModel *point = self.datas.firstObject;
    NSString *text = [NSString stringWithFormat:@"%.2f",point.close];
    CGFloat fontSize = 10;
    CGRect rect = [text getRectWithFontSize:fontSize];
    CGFloat y = [self.mainRenderer getY:point.close];
    if(point.close > self.mMainMaxValue) {
        y = [self.mainRenderer getY:self.mMainMaxValue];
    } else if (point.close < self.mMainMinValue) {
        y = [self.mainRenderer getY:self.mMainMinValue];
    }
    if((-_scrollX - rect.size.width) > 0) {
        CGContextSetStrokeColorWithColor(context, ChartColors_realTimeLongLineColor.CGColor);
        CGContextSetLineWidth(context, 0.5);
        CGFloat locations[] = {5,5};
        CGContextSetLineDash(context, 0, locations, 2);
        CGContextMoveToPoint(context,self.frame.size.width + _scrollX, y);
        CGContextAddLineToPoint(context, self.frame.size.width, y);
        CGContextDrawPath(context, kCGPathStroke);
        CGContextAddRect(context, CGRectMake(self.frame.size.width - rect.size.width, y - rect.size.height / 2, rect.size.width, rect.size.height));
        CGContextSetFillColorWithColor(context, ChartColors_bgColor.CGColor);
        CGContextDrawPath(context, kCGPathFill);
        [self.mainRenderer drawText:text atPoint:CGPointMake(self.frame.size.width - rect.size.width, y - rect.size.height / 2) fontSize:fontSize textColor:ChartColors_reightTextColor];
        if(_isLine) {
            CGContextSetFillColorWithColor(context, [UIColor whiteColor].CGColor);
            CGContextAddArc(context, self.frame.size.width + _scrollX - _candleWidth / 2, y, 2, 0, M_PI_2, true);
            CGContextDrawPath(context, kCGPathFill);
        }
    } else {
        CGContextSetStrokeColorWithColor(context, ChartColors_realTimeLongLineColor.CGColor);
        CGContextSetLineWidth(context, 0.5);
        CGFloat locations[] = {5,5};
        CGContextSetLineDash(context, 0, locations, 2);
        CGContextMoveToPoint(context,0, y);
        CGContextAddLineToPoint(context, self.frame.size.width, y);
        CGContextDrawPath(context, kCGPathStroke);
        
        CGFloat r = 8;
        CGFloat w = rect.size.width + 16;
        CGContextSetLineWidth(context, 0.5);
        CGFloat locations1[] = {};
        CGContextSetLineDash(context, 0, locations1, 0);
        CGContextSetFillColorWithColor(context, ChartColors_bgColor.CGColor);
        CGContextMoveToPoint(context,self.frame.size.width * 0.8, y - r);

        CGFloat curX = self.frame.size.width * 0.8;
        CGRect arcRect = CGRectMake(curX - w / 2, y - r, w, 2 * r);
        CGFloat minX = CGRectGetMinX(arcRect);
        CGFloat midX = CGRectGetMidX(arcRect);
        CGFloat maxX = CGRectGetMaxX(arcRect);

        CGFloat minY = CGRectGetMinY(arcRect);
        CGFloat midY = CGRectGetMidY(arcRect);
        CGFloat maxY = CGRectGetMaxY(arcRect);

        CGContextMoveToPoint(context,minX, midY);
        CGContextAddArcToPoint(context, minX, minY, midX, minY, r);
        CGContextAddArcToPoint(context, maxX, minY, maxX, midY, r);
        CGContextAddArcToPoint(context, maxX, maxY, midX, maxY, r);
        CGContextAddArcToPoint(context, minX, maxY, minX, midY, r);
        CGContextClosePath(context);
        CGContextDrawPath(context, kCGPathFillStroke);

        CGFloat startX = CGRectGetMaxX(arcRect) - 4;
        CGContextSetFillColorWithColor(context, ChartColors_reightTextColor.CGColor);
        CGContextMoveToPoint(context,startX, y);
        CGContextAddLineToPoint(context, startX - 3, y - 3);
        CGContextAddLineToPoint(context, startX - 3, y + 3);
        CGContextClosePath(context);
        CGContextDrawPath(context, kCGPathFill);
        [self.mainRenderer drawText:text atPoint:CGPointMake(curX - rect.size.width / 2 - 4, y - rect.size.height / 2) fontSize:fontSize textColor:ChartColors_reightTextColor];
    }
}

-(NSUInteger)calculateIndexWithSelectX:(CGFloat)selectX {
    if (_isLine) {
        NSInteger index = (self.frame.size.width - selectX) / ((screenW - SafeAreaInsetsConstantForDeviceWithNotch.left - SafeAreaInsetsConstantForDeviceWithNotch.right - ChartStyle_buySaleViewWidth) / ChartStyle_timeSection);
        return index;
    }else {
        NSInteger index = (self.frame.size.width - _startX - selectX) / (_candleWidth + ChartStyle_canldeMargin) + _startIndex;
        return index;
    }
    
}

-(BOOL)outRangeIndex:(NSUInteger)index {
    if(index < 0 || index >= self.datas.count) {
        return true;
    } else {
        return false;
    }
}

-(NSString *)calculateDateText:(NSTimeInterval)time {
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:time];
    NSDateFormatter *formater = [[NSDateFormatter alloc] init];
    formater.dateFormat = self.fromat;
    return [formater stringFromDate:date];
}

@end
