//
//  UIView+Extension.h
//  HelperFramework
//
//  Created by 老欧 on 15/7/27.
//  Copyright (c) 2015年 com.canww. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    MLShadowTop = 0,
    MLShadowBottom,
    MLShadowLeft,
    MLShadowRight,
    MLShadowCommon,
    MLShadowAround,
} MLShadowPathType;

extern NSString * const CSToastPositionTop;
extern NSString * const CSToastPositionCenter;
extern NSString * const CSToastPositionBottom;

@interface UIView (Extension)

+(UIView *)frame:(CGRect)frame bgColor:(UIColor *)bgColor;
+(UIView *)frame:(CGRect)frame bgColor:(UIColor *)bgColor cornerRadius:(CGFloat)cornerRadius;
+(UIView *)frame:(CGRect)frame bgColor:(UIColor *)bgColor cornerRadius:(CGFloat)cornerRadius borderWidth:(CGFloat)borderWidth borderColor:(UIColor *)borderColor;

-(void)tagRadius;
-(void)cornerRadius:(CGFloat)radius;
-(void)roundRadius;
-(void)yuanjiao;
-(void)pop;

-(void)border:(CGFloat)borderWidth borderColor:(UIColor *)borderColor;

- (void)dottedLine:(CGFloat)lineWidth lineColor:(UIColor *)lineColor dashPattern:(NSArray *)dashPattern position:(QMUIViewBorderPosition)position;

-(CGFloat)width;

-(CGFloat)height;

-(CGFloat)x;

-(CGFloat)y;

-(CGFloat)BottomY;

-(CGFloat)rightX;

-(void)updateWidth:(CGFloat)newWidth;

-(void)updateHeight:(CGFloat)newHeight;

-(void)updateX:(CGFloat)newX;

-(void)updateY:(CGFloat)newY;

-(void)ratioOfWidth:(CGFloat)width;

-(void)ratioOfHeight:(CGFloat)height;

-(void)updateSize:(CGSize)size;

-(void)updateOrigin:(CGPoint)origin;

/***相对于父视图***/
//水平居中
- (void)centerHrizontal;
//垂直居中
- (void)centerVertical;
//相对于父元素完全居中
- (void)centerInparent;

- (void)above:(UIView *)view space:(CGFloat)space;

- (void)below:(UIView *)view space:(CGFloat)space;

- (void)marginParentBottom:(CGFloat)margin;

- (void)marginParentLeft:(CGFloat)margin;

- (void)marginParentRight:(CGFloat)margin;

- (void)marginParentTop:(CGFloat)margin;

// each makeToast method creates a view and displays it as toast
- (void)makeToast:(NSString *)message;
- (void)makeToast:(NSString *)message duration:(NSTimeInterval)interval position:(id)position;
- (void)makeToast:(NSString *)message duration:(NSTimeInterval)interval position:(id)position image:(UIImage *)image;
- (void)makeToast:(NSString *)message duration:(NSTimeInterval)interval position:(id)position title:(NSString *)title;
- (void)makeToast:(NSString *)message duration:(NSTimeInterval)interval position:(id)position title:(NSString *)title image:(UIImage *)image;

// displays toast with an activity spinner
- (void)makeToastActivity;
- (void)makeToastActivity:(id)position;
- (void)hideToastActivity;

// the showToast methods display any view as toast
- (void)showToast:(UIView *)toast;
- (void)showToastView:(UIView *)toast;
- (void)showToastText:(NSString *)text point:(CGFloat)y;

-(void)showViewInCenter:(UIView *)view WithSize:(CGSize)size;
-(void)showViewInCenter:(UIView *)view WithSize:(CGSize)size closeBlock:(void(^)(void))closeBlock;
-(void)showViewInCenter:(UIView *)view WithSize:(CGSize)size canClose:(BOOL)canClose;

//弹窗自带底部关闭按钮
-(void)popViewInCenter:(UIView *)view WithSize:(CGSize)size canClose:(BOOL)canClose;
-(void)popCenter:(UIView *)view WithSize:(CGSize)size canClose:(BOOL)canClose closeBlock:(void(^)(void))closeBlock;
-(void)popViewInCenter:(UIView *)view WithSize:(CGSize)size canClose:(BOOL)canClose closeBlock:(void(^)(void))closeBlock;
-(void)hidePopView:(UIView *)view;
-(void)closePopView;

- (void)showToast:(UIView *)toast duration:(NSTimeInterval)interval position:(id)point;
- (void)showToast:(UIView *)toast duration:(NSTimeInterval)interval position:(id)point
      tapCallback:(void(^)(void))tapCallback;
- (void)addDottedLineBorderWithLineWidth:(CGFloat)lineWidth lineMargin:(CGFloat)lineMargin lineLength:(CGFloat)lineLength lineColor:(UIColor *)lineColor;

- (UIView *)drawDotLineWithLineColor:(UIColor *)lineColor withFillColor:(UIColor *)fillColor withCornerRadius:(CGFloat)radius withLineWidth:(CGFloat)lineWidth AndLineType:(NSString *)type;

-(void)clearView;
- (void)acs_radiusWithRadius:(CGFloat)radius corner:(UIRectCorner)corner;

-(void)setRounderCornerWithRadius:(CGFloat)radius;
-(void)setTagRadius;

//渐变色
-(void)gradation:(NSArray *)colors startPoint:(CGPoint)startPoint endPoint:(CGPoint)endPoint;

-(void)gradation:(NSArray *)colors startPoint:(CGPoint)startPoint endPoint:(CGPoint)endPoint frame:(CGRect)frame isFront:(BOOL)isFront;
//阴影
- (void)addShadow:(UIColor *)color Offset:(CGSize)offSet Radius:(CGFloat)radius;
- (void)addShadowWithColor:(UIColor *)shadowColor shadowOpacity:(CGFloat)shadowOpacity shadowRadius:(CGFloat)shadowRadius shadowPathType:(MLShadowPathType)shadowPathType shadowPathWidth:(CGFloat)shadowWidth;
/*
 等待提示框
 */
-(void)showProgress:(NSString *)title;
-(void)showProgressNoTitle;
-(void)progressDiss;

@end
