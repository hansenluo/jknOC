//
//  VolChartRenderer.m
//  KLine-Chart-OC
//
//  Created by 何俊松 on 2020/3/10.
//  Copyright © 2020 hjs. All rights reserved.
//

#import "VolChartRenderer.h"
#import "ChartStyle.h"
#import "NSString+Rect.h"

@implementation VolChartRenderer

- (void)drawGrid:(CGContextRef)context gridRows:(NSUInteger)gridRows gridColums:(NSUInteger)gridColums {
    CGContextSetStrokeColorWithColor(context, ChartColors_gridColor.CGColor);
    CGContextSetLineWidth(context, 0.5);
    CGFloat columsSpace = self.chartRect.size.width / (CGFloat)(gridColums);
    for (int index = 0;  index < gridColums; index++) {
        CGContextMoveToPoint(context, index * columsSpace, 0);
        CGContextAddLineToPoint(context, index * columsSpace, CGRectGetMaxY(self.chartRect));
        CGContextDrawPath(context, kCGPathFillStroke);
    }
    CGContextAddRect(context, self.chartRect);
    CGContextDrawPath(context, kCGPathStroke);
    
}
- (void)drawChart:(CGContextRef)context lastPoit:(KLineModel *)lastPoint curPoint:(KLineModel *)curPoint curX:(CGFloat)curX {
    [self drawHdly:context curPoint:curPoint curX:curX];
    if(lastPoint != nil){
        if(curPoint.horizon != 0) {
            [self drawLine:context lineWidth:1 lastValue:lastPoint.horizon curValue:curPoint.horizon curX:curX color:WhiteColor];
        }
        if(curPoint.monthLine != 0) {
            [self drawLine:context lineWidth:1 lastValue:lastPoint.monthLine curValue:curPoint.monthLine curX:curX color:[UIColor colorWithHexString:@"#FF0080"]];
        }
    }
}

- (void)drawHdly:(CGContextRef)context curPoint:(KLineModel *)curPoint curX:(CGFloat)curX {
    CGFloat high = [self getY:curPoint.hdlyHigh];
    //创建一个RGB的颜色空间
    CGColorSpaceRef rgb = CGColorSpaceCreateDeviceRGB();
    //定义渐变颜色数组
    CGFloat colors[] =
    {
        255.0 / 255.0, 0 / 255.0, 102.0 / 255.0, 1.00,
        255.0 / 255.0, 150.0 / 255.0, 186.0 / 255.0, 1.00,
        255.0 / 255.0, 0 / 255.0, 102.0 / 255.0, 1.00,
    };

    //创建一个渐变的色值 1:颜色空间 2:渐变的色数组 3:位置数组,如果为NULL,则为平均渐变,否则颜色和位置一一对应 4:位置的个数
    CGGradientRef gradient = CGGradientCreateWithColorComponents(rgb, colors, NULL, sizeof(colors)/(sizeof(colors[0])*4));
    
    CGContextSaveGState(context);
    CGContextMoveToPoint(context, curX - 1.5 * self.candleWidth, CGRectGetMaxY(self.chartRect));
    CGContextAddLineToPoint(context, curX + 1.5 * self.candleWidth, CGRectGetMaxY(self.chartRect));
    CGContextAddLineToPoint(context, curX + 1.5 * self.candleWidth, high);
    CGContextAddLineToPoint(context, curX - 1.5 * self.candleWidth, high);
    CGContextClip(context);//裁剪路径
    //说白了，开始坐标和结束坐标是控制渐变的方向和形状

    CGContextDrawLinearGradient(context, gradient,CGPointMake(curX - 1.5 * self.candleWidth, CGRectGetMaxY(self.chartRect)) ,CGPointMake(curX + 1.5 * self.candleWidth, CGRectGetMaxY(self.chartRect)),kCGGradientDrawsAfterEndLocation);
    CGContextRestoreGState(context);// 恢复到之前的context
    
    CGGradientRelease(gradient);
    CGColorSpaceRelease(rgb);
}

- (void)drawTopText:(CGContextRef)context curPoint:(KLineModel *)curPoint {
    [self drawText:@"海底捞月（抄底专用）" atPoint:CGPointMake(5, CGRectGetMinY(self.chartRect) + 2) fontSize:ChartStyle_defaultTextSize textColor:WhiteColor];
}

//- (void)drawRightText:(CGContextRef)context gridRows:(NSUInteger)gridRows gridColums:(NSUInteger)gridColums {
//    NSString *text = [self volFormat:self.maxValue];
//    CGRect rect = [text getRectWithFontSize:ChartStyle_reightTextSize];
//    [self drawText:text atPoint:CGPointMake(self.chartRect.size.width - rect.size.width, CGRectGetMinY(self.chartRect)) fontSize:ChartStyle_reightTextSize textColor:ChartColors_reightTextColor];
//}

@end
