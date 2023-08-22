//
//  MainChartRenderer.m
//  KLine-Chart-OC
//
//  Created by 何俊松 on 2020/3/10.
//  Copyright © 2020 hjs. All rights reserved.
//

#import "MainChartRenderer.h"
#import "ChartStyle.h"
#import "NSString+Rect.h"

#define diameter 16 //中枢标记直径

@interface MainChartRenderer()

@property(nonatomic,assign) CGFloat contentPadding;
@property(nonatomic,assign) MainState state;

@end

@implementation MainChartRenderer

- (instancetype)initWithMaxValue:(CGFloat)maxValue minValue:(CGFloat)minValue chartRect:(CGRect)chartRect candleWidth:(CGFloat)candleWidth topPadding:(CGFloat)topPadding isLine:(BOOL)isLine state:(MainState)state {
    if (self = [super initWithMaxValue:maxValue minValue:minValue chartRect:chartRect candleWidth:candleWidth topPadding:topPadding isLine:isLine]) {
        self.contentPadding = 20;
        self.isLine = isLine;
        self.state = state;
        CGFloat diff = maxValue - minValue;
        CGFloat newscaly = 1;
        CGFloat newDiff = 0;
        CGFloat value = 0;
        if(diff != 0) {
            newscaly = (chartRect.size.height - _contentPadding)/ diff;
            newDiff = chartRect.size.height / newscaly;
            value = (newDiff - diff) / 2;
        }
        if(newDiff > diff) {
            self.scaleY = newscaly;
            self.maxValue += value;
            self.minValue -= value;
        }
    }
    return self;
}

- (void)drawGrid:(CGContextRef)context gridRows:(NSUInteger)gridRows gridColums:(NSUInteger)gridColums {
    CGContextSetStrokeColorWithColor(context, ChartColors_gridColor.CGColor);
    CGContextSetLineWidth(context, 0.5);
    CGFloat columsSpace = self.chartRect.size.width / (CGFloat)(gridColums);
    for (int index = 0;  index < gridColums; index++) {
        CGContextMoveToPoint(context, index * columsSpace, 0);
        CGContextAddLineToPoint(context, index * columsSpace, CGRectGetMaxY(self.chartRect));
        CGContextDrawPath(context, kCGPathFillStroke);
    }
    CGFloat rowSpace = self.chartRect.size.height / (CGFloat)gridRows;
    for (int index = 0;  index < gridRows; index++) {
         CGContextMoveToPoint(context, 0, index * rowSpace + ChartStyle_topPadding);
         CGContextAddLineToPoint(context, CGRectGetMaxX(self.chartRect), index * rowSpace + ChartStyle_topPadding);
         CGContextDrawPath(context, kCGPathFillStroke);
     }
    CGContextAddRect(context, self.chartRect);
    CGContextDrawPath(context, kCGPathStroke);
}

- (void)drawPen:(CGContextRef)context
     priorPoint:(KLineModel *)priorPoint
       curPoint:(KLineModel *)curPoint
           curX:(CGFloat)curX {
    if (!curPoint.isDrawPen) { return; }
    
    CGFloat curPenHigh = [self getY:curPoint.penHigh];
    CGFloat priorPenHigh = [self getY:priorPoint.penHigh];
    
    if (curPenHigh <= CGRectGetMaxY(self.chartRect) && priorPenHigh <= CGRectGetMaxY(self.chartRect)) {
        if (curPoint.isDrawLineDash && curPoint.penStatus == 0) {
            CGContextSetStrokeColorWithColor(context, [UIColor colorWithHexString:@"#FFFFFF"].CGColor);
            CGContextSetLineWidth(context, 1);
            CGFloat locations[] = {3,3};
            CGContextSetLineDash(context, 0, locations, 2);
            CGContextMoveToPoint(context, curX, curPenHigh);
            CGContextAddLineToPoint(context, curX - self.candleWidth - ChartStyle_canldeMargin, priorPenHigh);
            CGContextDrawPath(context, kCGPathStroke);
            
            //不加这句代码后面画的线全部变为虚线了
            CGFloat locations1[] = {};
            CGContextSetLineDash(context, 0, locations1, 0);
        }else {
            CGContextSetStrokeColorWithColor(context, [UIColor colorWithHexString:@"#FFFFFF"].CGColor);
            CGContextSetLineWidth(context, 1);
            CGContextMoveToPoint(context, curX, curPenHigh);
            CGContextAddLineToPoint(context, curX - self.candleWidth - ChartStyle_canldeMargin, priorPenHigh);
            CGContextDrawPath(context, kCGPathFillStroke);
        }
    }
}

- (void)drawTime:(CGContextRef)context
        lastPoit:(KLineModel *)lastPoint
        curPoint:(KLineModel *)curPoint
            curX:(CGFloat)curX {
    if (lastPoint != nil) {
        [self drawKLine:context lastValue:lastPoint.close curValue:curPoint.close curX:curX];
    }
}

- (void)drawChart:(CGContextRef)context lastPoit:(KLineModel *)lastPoint curPoint:(KLineModel *)curPoint curX:(CGFloat)curX {
    [self drawCandle:context curPoint:curPoint curX:curX];
}

- (void)drawCandle:(CGContextRef)context curPoint:(KLineModel *)curPoint curX:(CGFloat)curX {
    CGFloat high = [self getY:curPoint.high];
    CGFloat low = [self getY:curPoint.low];
    CGFloat open = [self getY:curPoint.open];
    CGFloat close = [self getY:curPoint.close];
    UIColor *color = ChartColors_upColor;
    
    CGFloat upDown = curPoint.close - curPoint.open;
    CGFloat upDownPercent = (curPoint.close - curPoint.lasetDayclose) / curPoint.lasetDayclose * 100;
    if(upDown > 0) {
        if (ABS(upDownPercent) >= 9) {
            color = ChartColors_max_upColor;
        }else {
            color = ChartColors_dnColor;
        }
    } else {
        if (ABS(upDownPercent) >= 9) {
            color = ChartColors_min_dnColor;
        }else {
            color = ChartColors_upColor;
        }
    }

    if (open == close) {
        close = open + 1;
        
        if (curPoint.close > curPoint.lasetDayclose) {
            color = ChartColors_dnColor;
        }else {
            color = ChartColors_upColor;
        }
    }
    
    CGContextSetStrokeColorWithColor(context, color.CGColor);
    if (self.candleWidth > ChartStyle_candleLineWidth) {
        CGContextSetLineWidth(context, ChartStyle_candleLineWidth);
    }else {
        CGContextSetLineWidth(context, self.candleWidth);
    }
    CGContextMoveToPoint(context, curX, high);
    CGContextAddLineToPoint(context, curX, low);
    CGContextDrawPath(context, kCGPathFillStroke);

    CGContextSetStrokeColorWithColor(context, color.CGColor);
    CGContextSetLineWidth(context, self.candleWidth);
    CGContextMoveToPoint(context, curX, open);
    CGContextAddLineToPoint(context, curX, close);
    CGContextDrawPath(context, kCGPathFillStroke);
}

- (void)drawcEntresDataRect:(CGContextRef)context
                curPoint:(KLineModel *)curPoint
                    curX:(CGFloat)curX
                isSameArea:(BOOL)isSameArea
                    color:(UIColor *)color{
    if (!self.isLine) {
        CGFloat high = [self getY:curPoint.rectHigh];
        CGFloat low = [self getY:curPoint.rectLow];
        
        if (high <= CGRectGetMaxY(self.chartRect)) {
            if (low > CGRectGetMaxY(self.chartRect)) {
                low = CGRectGetMaxY(self.chartRect);
            }
            
            CGContextSetFillColorWithColor(context, color.CGColor);
            if (curPoint.isPivotStartPoint) {
                CGContextAddRect(context,CGRectMake(curX, high, curPoint.minRectSpansNum * (self.candleWidth + ChartStyle_canldeMargin), low - high));//画方框
            }else if (curPoint.isPivotEndPoint) {
                CGContextAddRect(context,CGRectMake(curX - curPoint.minRectSpansNum * (self.candleWidth + ChartStyle_canldeMargin), high, curPoint.minRectSpansNum * (self.candleWidth + ChartStyle_canldeMargin), low - high));//画方框
            }else {
                if (isSameArea) {
                    CGContextAddRect(context,CGRectMake(0, high, screenW, low - high));//画方框
                }
            }
            CGContextDrawPath(context, kCGPathFill);
        }
    }
}

- (void)drawcEntresMark:(CGContextRef)context
            curPoint:(KLineModel *)curPoint
                   curX:(CGFloat)curX {
    
    if (!self.isLine) {
        CGFloat high = [self getY:curPoint.rectHigh];
        CGFloat markHigh = high - 20;

        UIColor *color = nil;
        if (curPoint.direction == 1) {
            if (curPoint.num <= 7) {
                color = rangesColors_up_min_bgColor;
            }else {
                color = rangesColors_up_max_bgColor;
            }
        }else {
            if (curPoint.num <= 7) {
                color = rangesColors_down_min_bgColor;
            }else {
                color = rangesColors_down_max_bgColor;
            }
        }

        NSString *letterStr = [NSString stringWithFormat:@"%c", curPoint.marknum + 64];
        
        if (curPoint.direction == 1) {
            if (curPoint.num >= 9) {
                [self drawText:[NSString stringWithFormat:@"+%@²",letterStr] atPoint:CGPointMake(curX, markHigh) fontSize:18 textColor:color];
            }else {
                [self drawText:[NSString stringWithFormat:@"+%@",letterStr] atPoint:CGPointMake(curX, markHigh) fontSize:18 textColor:color];
            }
        }else {
            if (curPoint.num >= 9) {
                [self drawText:[NSString stringWithFormat:@"-%@²",letterStr] atPoint:CGPointMake(curX, markHigh) fontSize:18 textColor:color];
            }else {
                [self drawText:[NSString stringWithFormat:@"-%@",letterStr] atPoint:CGPointMake(curX, markHigh) fontSize:18 textColor:color];
            }
        }
    }
}

- (void)drawcLineDashRect:(CGContextRef)context
                 curPoint:(KLineModel *)curPoint
                     curX:(CGFloat)curX
                 isSameArea:(BOOL)isSameArea
                     color:(UIColor *)color {
    if (!self.isLine) {
        CGFloat high = [self getY:curPoint.extendRectHigh];
        CGFloat low = [self getY:curPoint.extendRectLow];
        
        if (high <= CGRectGetMaxY(self.chartRect)) {
            if (low > CGRectGetMaxY(self.chartRect)) {
                low = CGRectGetMaxY(self.chartRect);
            }
            
            CGContextSetLineWidth(context, 2);
            CGContextSetStrokeColorWithColor(context, color.CGColor);
            CGFloat lengths[] = {5,5};
            CGContextSetLineDash(context, 0, lengths,2);
            
            if (curPoint.isExtendStartPoint) {
                CGContextAddRect(context,CGRectMake(curX - ChartStyle_pivotPadding, high - ChartStyle_pivotPadding, curPoint.maxRectSpansNum * (self.candleWidth + ChartStyle_canldeMargin) + 2*ChartStyle_pivotPadding, low - high + 2*ChartStyle_pivotPadding));
            }else if (curPoint.isExtendEndPoint) {
                CGContextAddRect(context,CGRectMake(curX - curPoint.maxRectSpansNum * (self.candleWidth + ChartStyle_canldeMargin) + ChartStyle_pivotPadding, high - ChartStyle_pivotPadding, curPoint.maxRectSpansNum * (self.candleWidth + ChartStyle_canldeMargin), low - high + 2*ChartStyle_pivotPadding));
            }else {
                if (isSameArea) {
                    CGContextAddRect(context,CGRectMake(-5, high - ChartStyle_pivotPadding, screenW + 10, low - high + 2*ChartStyle_pivotPadding));//画方框
                }
            }
            CGContextDrawPath(context, kCGPathStroke);
            
            //不加这句代码后面画的线全部变为虚线了
            CGFloat locations1[] = {};
            CGContextSetLineDash(context, 0, locations1, 0);
        }
    }
}

- (void)drawExtendMark:(CGContextRef)context
            curPoint:(KLineModel *)curPoint
               curX:(CGFloat)curX
             isSameArea:(BOOL)isSameArea
                  color:(UIColor *)color {
    if (!self.isLine) {
        CGFloat high = [self getY:curPoint.extendRectHigh];
        CGFloat low = [self getY:curPoint.extendRectLow];
        
        if (high <= CGRectGetMaxY(self.chartRect)) {
            if (low > CGRectGetMaxY(self.chartRect)) {
                low = CGRectGetMaxY(self.chartRect);
            }
            
            if (curPoint.extendRectDirection == 1) {
                if (curPoint.isExtendEndPoint) {
                    if (curPoint.extendRectNum == 2) {
                        [self drawText:@"A²" atPoint:CGPointMake(curX - 20, low - 20) fontSize:18 textColor:color];
                    }else if (curPoint.extendRectNum == 4) {
                        [self drawText:@"A⁴" atPoint:CGPointMake(curX - 20, low - 20) fontSize:18 textColor:color];
                    }else if (curPoint.extendRectNum == 6) {
                        [self drawText:@"A⁶" atPoint:CGPointMake(curX - 20, low - 20) fontSize:18 textColor:color];
                    }else if (curPoint.extendRectNum == 8) {
                        [self drawText:@"A⁸" atPoint:CGPointMake(curX - 20, low - 20) fontSize:18 textColor:color];
                    }
                }
            }else {
                if (curPoint.isExtendStartPoint) {
                    if (curPoint.extendRectNum == 2) {
                        [self drawText:@"A²" atPoint:CGPointMake(curX, low - 20) fontSize:18 textColor:color];
                    }else if (curPoint.extendRectNum == 4) {
                        [self drawText:@"A⁴" atPoint:CGPointMake(curX, low - 20) fontSize:18 textColor:color];
                    }else if (curPoint.extendRectNum == 6) {
                        [self drawText:@"A⁶" atPoint:CGPointMake(curX, low - 20) fontSize:18 textColor:color];
                    }else if (curPoint.extendRectNum == 8) {
                        [self drawText:@"A⁸" atPoint:CGPointMake(curX, low - 20) fontSize:18 textColor:color];
                    }
                }
            }
        }
    }
}

- (void)drawcSalePointMark:(CGContextRef)context
               curPoint:(KLineModel *)curPoint
                      curX:(CGFloat)curX {
    if (!self.isLine) {
        CGFloat startHigh = 0.0;
        CGFloat endHigh = 0.0;
        CGFloat roundHigh = 0.0;
        NSString *pointStr = @"";
        UIColor *color = nil;
        
        if (curPoint.isNeedDrawSale1Point) {
            startHigh = [self getY:curPoint.sale1PointHigh];
            if (curPoint.sale1PointDirection == 1) {
                if (curPoint.sale1PointNum <= 7) {
                    color = rangesColors_down_min_bgColor;
                }else {
                    color = rangesColors_down_max_bgColor;
                }
                
                endHigh = startHigh - 20;
                roundHigh = endHigh - diameter;
                pointStr = @"1S";
            }else {
                if (curPoint.sale1PointNum <= 7) {
                    color = rangesColors_up_min_bgColor;
                }else {
                    color = rangesColors_up_max_bgColor;
                }
                
                endHigh = startHigh + 20;
                roundHigh = endHigh;
                pointStr = @"1B";
            }
        }
        
        if (curPoint.isNeedDrawSale3Point) {
            startHigh = [self getY:curPoint.sale3PointHigh];
            if (curPoint.sale3PointDirection == 1) {
                if (curPoint.sale3PointNum <= 7) {
                    color = rangesColors_up_min_bgColor;
                }else {
                    color = rangesColors_up_max_bgColor;
                }
                
                endHigh = startHigh + 20;
                roundHigh = endHigh;
                pointStr = @"3B";
            }else {
                if (curPoint.sale3PointNum <= 7) {
                    color = rangesColors_down_min_bgColor;
                }else {
                    color = rangesColors_down_max_bgColor;
                }
                
                endHigh = startHigh - 20;
                roundHigh = endHigh - diameter;
                pointStr = @"3S";
            }
        }
        
        CGContextSetLineWidth(context, 1.5);
        CGContextSetStrokeColorWithColor(context, color.CGColor);
        CGContextMoveToPoint(context, curX, startHigh);
        CGFloat lengths[] = {3,3};
        CGContextSetLineDash(context, 0, lengths,2);
        CGContextAddLineToPoint(context, curX,endHigh);
        CGContextStrokePath(context);
        
        CGContextSetFillColorWithColor(context, color.CGColor);
        CGContextAddEllipseInRect(context, CGRectMake(curX - diameter/2, roundHigh, diameter, diameter));
        CGContextDrawPath(context, kCGPathFill);
        
        //不加这句代码后面画的线全部变为虚线了
        CGFloat locations1[] = {};
        CGContextSetLineDash(context, 0, locations1, 0);
        
        [self drawText:pointStr atPoint:CGPointMake(curX - diameter/2, roundHigh) fontSize:12 textColor:WhiteColor];
    }
}

- (void)drawKLine:(CGContextRef)context lastValue:(CGFloat)lastValue curValue:(CGFloat)curValue curX:(CGFloat)curX  {
    CGFloat x1 = curX;
    CGFloat y1 = [self getY:curValue];
    CGFloat x2 = curX + (CGRectGetMaxX(self.chartRect) - ChartStyle_buySaleViewWidth)/ChartStyle_timeSection + 1;
    CGFloat y2 = [self getY:lastValue];
    //NSLog(@"x1 = %f -> y1 = %f -> x2 = %f -> y2 = %f",x1,y1,x2,y2);
    
//    CGContextSetStrokeColorWithColor(context, [UIColor colorWithHexString:@"#FFFFFF"].CGColor);
//    CGContextSetLineWidth(context, 1);
//    CGContextMoveToPoint(context, x1, y1);
//    CGContextAddLineToPoint(context, x2 , y2);
//    CGContextDrawPath(context, kCGPathFillStroke);
    
    CGContextSetLineWidth(context, 1);
    CGContextSetStrokeColorWithColor(context, [UIColor colorWithHexString:@"#3CC864" alpha:0.5].CGColor);
    CGContextMoveToPoint(context, x1, y1);
    CGContextAddCurveToPoint(context, (x1 + x2) / 2.0, y1,  (x1 + x2) / 2.0, y2, x2, y2);
    CGContextDrawPath(context, kCGPathFillStroke);

    CGMutablePathRef path = CGPathCreateMutable();
    CGPathMoveToPoint(path, &CGAffineTransformIdentity, x1, CGRectGetMaxY(self.chartRect));
    CGPathAddLineToPoint(path, &CGAffineTransformIdentity, x1, y1);
    CGPathAddCurveToPoint(path, &CGAffineTransformIdentity, (x1 + x2) / 2.0, y1, (x1 + x2) / 2.0, y2, x2, y2);
    CGPathAddLineToPoint(path,  &CGAffineTransformIdentity, x2, CGRectGetMaxY(self.chartRect));
    CGPathCloseSubpath(path);
    CGContextAddPath(context, path);

    CGContextClip(context);
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGFloat locations[] = {0,1};
    //3CC864  AFEEEE
    NSArray *colors = @[(__bridge id)[UIColor colorWithHexString:@"#3CC864" alpha:0.5].CGColor, (__bridge id)[UIColor colorWithHexString:@"#7FFFD4" alpha:0.5].CGColor];
    CGGradientRef gradient = CGGradientCreateWithColors(colorSpace, (CFArrayRef) colors, locations);
    CGColorSpaceRelease(colorSpace);
    CGPoint start = CGPointMake((x1 + x2) / 2, CGRectGetMinY(self.chartRect));
    CGPoint end = CGPointMake((x1 + x2) / 2, CGRectGetMaxY(self.chartRect));
    CGContextDrawLinearGradient(context, gradient, start, end, 0);
    CGContextResetClip(context);

    CGColorSpaceRelease(colorSpace);
    CGPathRelease(path);
    CGGradientRelease(gradient);
}

- (void)drawTopText:(CGContextRef)context curPoint:(KLineModel *)curPoint {
    NSMutableAttributedString *topAttributeText = [[NSMutableAttributedString alloc] init];
    if(curPoint.MA5Price != 0) {
        NSString *str = [NSString stringWithFormat:@"MA5:%.2f   ",curPoint.MA5Price];
        NSAttributedString *attr = [[NSAttributedString alloc] initWithString:str attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:ChartStyle_defaultTextSize],NSForegroundColorAttributeName: ChartColors_ma5Color}];
        [topAttributeText appendAttributedString:attr];
    }
    if(curPoint.MA10Price != 0) {
        NSString *str = [NSString stringWithFormat:@"MA10:%.2f    ",curPoint.MA10Price];
        NSAttributedString *attr = [[NSAttributedString alloc] initWithString:str attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:ChartStyle_defaultTextSize],NSForegroundColorAttributeName: ChartColors_ma10Color}];
        [topAttributeText appendAttributedString:attr];
    }
    if(curPoint.MA30Price != 0) {
        NSString *str = [NSString stringWithFormat:@"MA30:%.2f   ",curPoint.MA30Price];
        NSAttributedString *attr = [[NSAttributedString alloc] initWithString:str attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:ChartStyle_defaultTextSize],NSForegroundColorAttributeName: ChartColors_ma30Color}];
        [topAttributeText appendAttributedString:attr];
    }
    [topAttributeText drawAtPoint:CGPointMake(5, 6)];
}

- (void)drawRightText:(CGContextRef)context gridRows:(NSUInteger)gridRows gridColums:(NSUInteger)gridColums {
    CGFloat rowSpace = self.chartRect.size.height / (CGFloat)gridRows;
    for (int i = 0; i <= gridRows; i++) {
        CGFloat position = 0;
        position = (CGFloat)(gridRows - i) * rowSpace;
        CGFloat value = position / self.scaleY + self.minValue;
        NSString *valueStr = [NSString stringWithFormat:@"%.2f",value];
        CGRect rect = [valueStr getRectWithFontSize:ChartStyle_reightTextSize];
        CGFloat y = 0;
        if(i == 0) {
            y = [self getY:value];
        } else {
            y = [self getY:value] - rect.size.height;
        }
        [self drawText:valueStr atPoint:CGPointMake(0, y) fontSize:ChartStyle_reightTextSize textColor:WhiteColor];
        //[self drawText:valueStr atPoint:CGPointMake(self.chartRect.size.width - rect.size.width, y) fontSize:ChartStyle_reightTextSize textColor:ChartColors_reightTextColor];
    }
}

- (CGFloat)getY:(CGFloat)value {
    //NSLog(@"self.scaleY = %f --- self.maxValue = %f ---- value = %f ---- self.chartRect = %f",self.scaleY,self.maxValue,value,CGRectGetMinY(self.chartRect));
    return self.scaleY * (self.maxValue - value) + CGRectGetMinY(self.chartRect);
}

@end
