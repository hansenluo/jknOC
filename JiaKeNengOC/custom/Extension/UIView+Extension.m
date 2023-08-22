//
//  UIView+Extension.m
//  HelperFramework
//
//  Created by 老欧 on 15/7/27.
//  Copyright (c) 2015年 com.canww. All rights reserved.
//

#import "UIView+Extension.h"
#import <QuartzCore/QuartzCore.h>
#import <objc/runtime.h>

/*
 *  CONFIGURE THESE VALUES TO ADJUST LOOK & FEEL,
 *  DISPLAY DURATION, ETC.
 */

// general appearance
static const CGFloat CSToastMaxWidth            = 0.8;      // 80% of parent view width
static const CGFloat CSToastMaxHeight           = 0.8;      // 80% of parent view height
static const CGFloat CSToastHorizontalPadding   = 10.0;
static const CGFloat CSToastVerticalPadding     = 10.0;
static const CGFloat CSToastCornerRadius        = 10.0;
static const CGFloat CSToastOpacity             = 0.8;
static const CGFloat CSToastFontSize            = 16.0;
static const CGFloat CSToastMaxTitleLines       = 0;
static const CGFloat CSToastMaxMessageLines     = 0;
static const NSTimeInterval CSToastFadeDuration = 1;
static const NSTimeInterval PopDuration = .25f;

// shadow appearance
static const CGFloat CSToastShadowOpacity       = 0.8;
static const CGFloat CSToastShadowRadius        = 6.0;
static const CGSize  CSToastShadowOffset        = { 4.0, 4.0 };
static const BOOL    CSToastDisplayShadow       = YES;

// display duration
static const NSTimeInterval CSToastDefaultDuration  = 3.0;

// image view size
static const CGFloat CSToastImageViewWidth      = 80.0;
static const CGFloat CSToastImageViewHeight     = 80.0;

// activity
static const CGFloat CSToastActivityWidth       = 100.0;
static const CGFloat CSToastActivityHeight      = 100.0;
static const NSString * CSToastActivityDefaultPosition = @"center";

// interaction
static const BOOL CSToastHidesOnTap             = YES;     // excludes activity views

// associative reference keys
static const NSString * CSToastTimerKey         = @"CSToastTimerKey";
static const NSString * CSProgressKey         = @"CSProgressKey";
static const NSString * CSCAShapeLayer         = @"CSCAShapeLayer";
static const NSString * CSToastActivityViewKey  = @"CSToastActivityViewKey";
static const NSString * CSToastTapCallbackKey   = @"CSToastTapCallbackKey";
static const NSString * MLPopCloseBlockKey   = @"PopCloseBlockKey";
static const NSString * MLayerClearKey   = @"MLayerClearKey";

// positions
NSString * const CSToastPositionTop             = @"top";
NSString * const CSToastPositionCenter          = @"center";
NSString * const CSToastPositionBottom          = @"bottom";

@implementation UIView (Extension)

+(UIView *)frame:(CGRect)frame bgColor:(UIColor *)bgColor{
    UIView *view = [[UIView alloc] initWithFrame:frame];
    view.backgroundColor = bgColor;
    return view;
}
+(UIView *)frame:(CGRect)frame bgColor:(UIColor *)bgColor cornerRadius:(CGFloat)cornerRadius{
    UIView *view = [[UIView alloc] initWithFrame:frame];
    view.backgroundColor = bgColor;
    view.layer.cornerRadius = cornerRadius;
    return view;
}
+(UIView *)frame:(CGRect)frame bgColor:(UIColor *)bgColor cornerRadius:(CGFloat)cornerRadius borderWidth:(CGFloat)borderWidth borderColor:(UIColor *)borderColor{
    UIView *view = [[UIView alloc] initWithFrame:frame];
    view.backgroundColor = bgColor;
    view.layer.cornerRadius = cornerRadius;
    view.layer.borderWidth = borderWidth;
    view.layer.borderColor = borderColor.CGColor;
    return view;
}

-(void)tagRadius
{
    self.layer.cornerRadius = 2.0f;
    self.layer.masksToBounds = YES;
}

-(void)cornerRadius:(CGFloat)radius
{
    self.layer.cornerRadius = radius;
    self.layer.masksToBounds = YES;
}

-(void)yuanjiao
{
    self.layer.cornerRadius = 5.0f;
    self.layer.masksToBounds = YES;
}

-(void)pop
{
    self.layer.cornerRadius = 9.0f;
    self.layer.masksToBounds = YES;
}

-(void)roundRadius
{
    self.layer.cornerRadius = self.height/2;
    self.layer.masksToBounds = YES;
}

-(void)border:(CGFloat)borderWidth borderColor:(UIColor *)borderColo
{
    self.layer.borderColor = borderColo.CGColor;
    self.layer.borderWidth = borderWidth;
}

- (void)dottedLine:(CGFloat)lineWidth lineColor:(UIColor *)lineColor dashPattern:(NSArray *)dashPattern position:(QMUIViewBorderPosition)position {
    //qmui_dashPhase表示虚线起始的偏移，qmui_dashPattern可以传一个数组，表示“lineWidth，lineSpacing，lineWidth，lineSpacing...”的顺序，至少传 2 个。

    self.qmui_borderWidth = lineWidth;
    self.qmui_borderColor = lineColor;
    self.qmui_dashPattern = dashPattern;
    self.qmui_dashPhase = 0;
    self.qmui_borderPosition = position;
}

-(CGFloat)width
{
    return self.frame.size.width;
}

-(CGFloat)height
{
    return self.frame.size.height;
}

-(CGFloat)x
{
    return self.frame.origin.x;
}

-(CGFloat)y
{
    return self.frame.origin.y;
}

-(CGFloat)BottomY
{
    return self.frame.size.height+self.frame.origin.y;
}

-(CGFloat)rightX
{
    return self.frame.size.width+self.frame.origin.x;
}

-(void)updateWidth:(CGFloat)newWidth
{
    self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, newWidth, self.frame.size.height);
}

-(void)updateHeight:(CGFloat)newHeight
{
    self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, newHeight);
}

-(void)updateX:(CGFloat)newX
{
    self.frame = CGRectMake(newX, self.frame.origin.y, self.frame.size.width, self.frame.size.height);
}

-(void)updateY:(CGFloat)newY
{
    self.frame = CGRectMake(self.frame.origin.x, newY, self.frame.size.width, self.frame.size.height);
}

-(void)updateSize:(CGSize)size
{
    self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, size.width, size.height);
}

-(void)updateOrigin:(CGPoint)origin
{
    self.frame = CGRectMake(origin.x, origin.y, self.frame.size.width, self.frame.size.height);
}

-(void)ratioOfWidth:(CGFloat)width
{
    CGSize size = self.frame.size;
    
    float bili = width/size.width;
    
    float newHeight = size.height*bili;
    
    [self updateSize:CGSizeMake(width, newHeight)];
}

-(void)ratioOfHeight:(CGFloat)height
{
    CGSize size = self.frame.size;
    
    float bili = height/size.height;
    
    float newWidth = size.width*bili;
    
    [self updateSize:CGSizeMake(newWidth, height)];
}

- (void)centerHrizontal
{
    UIView *superView = [self superview];
    self.frame = CGRectMake((superView.frame.size.width-self.frame.size.width)/2, self.frame.origin.y, self.frame.size.width, self.frame.size.height);
}

- (void)centerVertical
{
    UIView *superView = [self superview];
    self.frame = CGRectMake(self.frame.origin.x, (superView.frame.size.height-self.frame.size.height)/2, self.frame.size.width, self.frame.size.height);
}

- (void)centerInparent
{
    [self centerHrizontal];
    [self centerVertical];
}

- (void)above:(UIView *)view space:(CGFloat)space
{
    [self updateY:view.y-self.height-space];
}

- (void)below:(UIView *)view space:(CGFloat)space
{
    [self updateY:view.BottomY+space];
}

- (void)marginParentBottom:(CGFloat)margin
{
    [self updateY:[self superview].height-margin-self.height];
}

- (void)marginParentLeft:(CGFloat)margin
{
    [self updateX:margin];
}

- (void)marginParentRight:(CGFloat)margin
{
    [self updateX:[self superview].width-margin-self.width];
}

- (void)marginParentTop:(CGFloat)margin
{
    [self updateY:margin];
}


#pragma mark - Toast Methods
- (void)makeToast:(NSString *)message {
    
    [self makeToast:message duration:CSToastDefaultDuration position:CSToastPositionCenter];
}

- (void)makeToast:(NSString *)message duration:(NSTimeInterval)duration position:(id)position {
    UIView *toast = [self viewForMessage:message title:nil image:nil];
    [self showToast:toast duration:duration position:position];
}

- (void)makeToast:(NSString *)message duration:(NSTimeInterval)duration position:(id)position title:(NSString *)title {
    UIView *toast = [self viewForMessage:message title:title image:nil];
    [self showToast:toast duration:duration position:position];
}

- (void)makeToast:(NSString *)message duration:(NSTimeInterval)duration position:(id)position image:(UIImage *)image {
    UIView *toast = [self viewForMessage:message title:nil image:image];
    [self showToast:toast duration:duration position:position];
}

- (void)makeToast:(NSString *)message duration:(NSTimeInterval)duration  position:(id)position title:(NSString *)title image:(UIImage *)image {
    UIView *toast = [self viewForMessage:message title:title image:image];
    [self showToast:toast duration:duration position:position];
}

- (void)showToast:(UIView *)toast {
    [self showToast:toast duration:CSToastDefaultDuration position:nil];
}


- (void)showToast:(UIView *)toast duration:(NSTimeInterval)duration position:(id)position {
    [self showToast:toast duration:duration position:position tapCallback:nil];
    
}

-(void)showProgress:(NSString *)title
{
    __block UIView *bgView = [self viewWithTag:999];
    if (!bgView) {
        dispatch_async(dispatch_get_main_queue(), ^{
            bgView = [[UIButton alloc] initWithFrame:self.bounds];
        //    [bgView addTarget:self action:@selector(progressDiss) forControlEvents:UIControlEventTouchUpInside];
            bgView.tag = 999;
            [self addSubview:bgView];
            
            UIView *pView = [[UIView alloc] init];
            pView.backgroundColor = [UIColor colorWithHexString:@"#000000" alpha:.65f];
            [pView cornerRadius:6];
            
            float vw = isNilString(title)?80:90;
            float gw = isNilString(title)?48:40;
            float cw = self.frame.size.width;
            float ch = self.frame.size.height;
            pView.frame = CGRectMake((cw - vw)/2, (ch - vw)/2, vw, vw);
            [bgView addSubview:pView];
            
            CGFloat kPathLineWidth = 4;
            UIView *pgView = [[UIView alloc] init];
            pgView.frame = CGRectMake((vw - gw - kPathLineWidth)/2, 16 -kPathLineWidth/2, gw + kPathLineWidth, gw + kPathLineWidth);
            [pView addSubview:pgView];
            pgView.layer.borderColor = [UIColor colorWithHexString:@"#FFFFFF" alpha:.15f].CGColor;
            pgView.layer.borderWidth = kPathLineWidth;
            [pgView roundRadius];
            
            UIBezierPath *path = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(0,0, gw, gw)];
            CAShapeLayer *_shapeLayer1 = [CAShapeLayer layer];
            _shapeLayer1.strokeColor = WhiteColor.CGColor;
            _shapeLayer1.fillColor = [UIColor clearColor].CGColor;
            _shapeLayer1.lineCap = kCALineCapRound;
            _shapeLayer1.strokeStart = 0;
            _shapeLayer1.strokeEnd = 0.4;
            _shapeLayer1.lineWidth = kPathLineWidth;
            _shapeLayer1.frame = CGRectMake((vw - gw)/2, 16, gw, gw);
            _shapeLayer1.path = path.CGPath;
            [pView.layer addSublayer:_shapeLayer1];
            
            if (!isNilString(title)) {
                UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(5, 16 + gw + 8.5 + kPathLineWidth/2, vw - 10, 15)];
                label.font = [UIFont systemFontOfSize:16];
                label.textColor = WhiteColor;
                [label setTextAlignment:NSTextAlignmentCenter];
                label.text = title;
                [pView addSubview:label];
            }
            
            [self beginAnimation:_shapeLayer1];
        });
    }
    
}

-(void)showProgressNoTitle
{
    UIView *progressView = [self viewWithTag:999];
    if (progressView) {
        [self removeProgressView:progressView];
    }
    UIButton *bgView = [[UIButton alloc] initWithFrame:self.bounds];
    [self addSubview:bgView];
    
    progressView = [[UIView alloc] init];
    progressView.backgroundColor = [UIColor colorWithRed:228/255.0 green:156/255.0 blue:146/255.0 alpha:1];
    float gw = 20;
    progressView.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    [progressView roundRadius];
    [bgView addSubview:progressView];
    
    CGFloat kPathLineWidth = 2;
    UIView *pgView = [[UIView alloc] init];
    pgView.frame = CGRectMake((progressView.frame.size.width - gw)/2, (progressView.frame.size.height - gw)/2, gw, gw);
    [progressView addSubview:pgView];
    pgView.layer.borderColor = [UIColor colorWithHexString:@"#EA3E38" alpha:0].CGColor;
    pgView.layer.borderWidth = kPathLineWidth;
    [pgView roundRadius];
    
    UIBezierPath *path = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(0,0, gw, gw)];
    CAShapeLayer *_shapeLayer1 = [CAShapeLayer layer];
    _shapeLayer1.strokeColor = WhiteColor.CGColor;
    _shapeLayer1.fillColor = [UIColor clearColor].CGColor;
    _shapeLayer1.lineCap = kCALineCapRound;
    _shapeLayer1.strokeStart = 0;
    _shapeLayer1.strokeEnd = 0.85;
    _shapeLayer1.lineWidth = kPathLineWidth;
    _shapeLayer1.frame = CGRectMake((progressView.frame.size.width - gw)/2, (progressView.frame.size.height - gw)/2, gw, gw);
    _shapeLayer1.path = path.CGPath;
//    objc_setAssociatedObject (self, &CSProgressKey, progressView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
//    objc_setAssociatedObject (self, &CSCAShapeLayer, _shapeLayer1, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    [progressView.layer addSublayer:_shapeLayer1];
    
    [self beginAnimation:_shapeLayer1];
}

- (void)beginAnimation:(CAShapeLayer *)_shapeLayer1{
    // layer1
//    CAShapeLayer *_shapeLayer1 = (CAShapeLayer *)objc_getAssociatedObject(self, &CSCAShapeLayer);
    if (_shapeLayer1) {
        CABasicAnimation *animation1 = [CABasicAnimation animationWithKeyPath:@"transform.rotation"];
        animation1.duration = 1.5;
        animation1.fromValue = @0;
        animation1.toValue = @(M_PI * 2);
        animation1.repeatCount = INFINITY; // HUGE
        [_shapeLayer1 addAnimation:animation1 forKey:nil];
    }
}

-(void)progressDiss
{
    dispatch_async(dispatch_get_main_queue(), ^{
        UIView *_progressView = [self viewWithTag:999];
        if (_progressView) {
            [UIView animateWithDuration:.15
                                  delay:0.0
                                options:(UIViewAnimationOptionCurveEaseIn | UIViewAnimationOptionBeginFromCurrentState)
                             animations:^{
                                _progressView.alpha = 0.0;
                             } completion:^(BOOL finished) {
                                 [self removeProgressView:_progressView];
                             }];
        }
    });
    
}

-(void)removeProgressView:(UIView *)progressView
{
    [progressView.layer removeAllAnimations];
    [progressView clearView];
    [progressView removeFromSuperview];
    progressView = nil;
    objc_setAssociatedObject (self, &CSProgressKey, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    objc_setAssociatedObject (self, &CSCAShapeLayer, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void)showToastText:(NSString *)text point:(CGFloat)y
{
    UILabel *label = [[UILabel alloc] init];
    label.textColor = WhiteColor;
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont systemFontOfSize:15.85];
    label.text = text;
    CGSize size =  [label sizeThatFits:CGSizeMake(screenW, 44.85)];
    [label updateSize:CGSizeMake(0, 0)];
    label.frame = CGRectMake((self.frame.size.width - size.width - 30)/2, y, size.width + 30, 44.85);
    [label setBackgroundColor:[UIColor colorWithHexString:@"#000000" alpha:.65f]];
    [label roundRadius];
    [self showToastView:label];
}

-(void)showViewInCenter:(UIView *)view WithSize:(CGSize)size {
    view.alpha = 0.0;
    UIButton *bgBtn = [[UIButton alloc] initWithFrame:self.bounds];
    bgBtn.backgroundColor = [UIColor colorWithHexString:@"#000000" alpha:.50f];
    [bgBtn addTarget:self action:@selector(closeAction:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:bgBtn];
    [bgBtn addSubview:view];
    view.size = size;
    view.center = bgBtn.center;
    [self layoutIfNeeded];
    [UIView animateWithDuration:PopDuration
                          delay:0.0
                        options:(UIViewAnimationOptionCurveEaseOut | UIViewAnimationOptionAllowUserInteraction)
                     animations:^{
                        view.alpha = 1.0;
                     } completion:^(BOOL finished) {
                         objc_setAssociatedObject (self, &CSToastActivityViewKey, view, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
                     }];
}

-(void)showViewInCenter:(UIView *)view WithSize:(CGSize)size closeBlock:(void(^)(void))closeBlock{
    view.alpha = 0.0;
    UIButton *bgBtn = [[UIButton alloc] initWithFrame:self.bounds];
    bgBtn.backgroundColor = [UIColor colorWithHexString:@"#000000" alpha:.50f];
    [bgBtn addTarget:self action:@selector(closeAction:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:bgBtn];
    [bgBtn addSubview:view];
    view.size = size;
    view.center = bgBtn.center;
    [self layoutIfNeeded];
    [UIView animateWithDuration:PopDuration
                          delay:0.0
                        options:(UIViewAnimationOptionCurveEaseOut | UIViewAnimationOptionAllowUserInteraction)
                     animations:^{
                        view.alpha = 1.0;
                     } completion:^(BOOL finished) {
                         objc_setAssociatedObject (self, &CSToastActivityViewKey, view, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
                         objc_setAssociatedObject (view, &MLPopCloseBlockKey, closeBlock, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
                     }];

}

/*
 size 弹窗大小
 canClose 点击背景是否可关闭
 */
-(void)showViewInCenter:(UIView *)view WithSize:(CGSize)size canClose:(BOOL)canClose{
    view.alpha = 0.0;
    UIButton *bgBtn = [[UIButton alloc] initWithFrame:self.bounds];
    bgBtn.backgroundColor = [UIColor colorWithHexString:@"#000000" alpha:.50f];
    if (canClose) {
        [bgBtn addTarget:self action:@selector(closeAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    [self addSubview:bgBtn];
    [bgBtn addSubview:view];
    view.size = size;
    view.center = bgBtn.center;
    [self layoutIfNeeded];
    [UIView animateWithDuration:PopDuration
                          delay:0.0
                        options:(UIViewAnimationOptionCurveEaseOut | UIViewAnimationOptionAllowUserInteraction)
                     animations:^{
                        view.alpha = 1.0;
                     } completion:^(BOOL finished) {
                         objc_setAssociatedObject (self, &CSToastActivityViewKey, view, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
                     }];
}

-(void)popCenter:(UIView *)view WithSize:(CGSize)size canClose:(BOOL)canClose closeBlock:(void(^)(void))closeBlock{
    view.alpha = 0.0;
    UIButton *bgBtn = [[UIButton alloc] initWithFrame:self.bounds];
    bgBtn.backgroundColor = [UIColor colorWithHexString:@"#000000" alpha:.50f];
    if (canClose) {
        [bgBtn addTarget:self action:@selector(closeAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    [self addSubview:bgBtn];
    [bgBtn addSubview:view];
    view.size = size;
    view.center = CGPointMake(bgBtn.center.x, bgBtn.center.y - 57/2);
    [self layoutIfNeeded];
    
    CGFloat icw = 28;
    UIButton *closeBtn = [[UIButton alloc] initWithFrame:CGRectMake((CGRectGetWidth(bgBtn.frame) - icw)/2, CGRectGetMaxY(view.frame) + 25, icw, icw)];
    [closeBtn addTarget:self action:@selector(closeAction:) forControlEvents:UIControlEventTouchUpInside];
    [closeBtn setBackgroundImage:[UIImage imageNamed:@"icon_close_alpha45"] forState:UIControlStateNormal];
    [bgBtn addSubview:closeBtn];
    
    [UIView animateWithDuration:PopDuration
                          delay:0.0
                        options:(UIViewAnimationOptionCurveEaseOut | UIViewAnimationOptionAllowUserInteraction)
                     animations:^{
                        view.alpha = 1.0;
                     } completion:^(BOOL finished) {
                         objc_setAssociatedObject (self, &CSToastActivityViewKey, view, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
                         objc_setAssociatedObject (view, &MLPopCloseBlockKey, closeBlock, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
                     }];
}

-(void)popViewInCenter:(UIView *)view WithSize:(CGSize)size canClose:(BOOL)canClose closeBlock:(void(^)(void))closeBlock{
    view.alpha = 0.0;
    UIButton *bgBtn = [[UIButton alloc] initWithFrame:self.bounds];
    bgBtn.backgroundColor = [UIColor colorWithHexString:@"#000000" alpha:.50f];
    if (canClose) {
        [bgBtn addTarget:self action:@selector(closeAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    [self addSubview:bgBtn];
    [bgBtn addSubview:view];
    view.size = size;
    view.center = CGPointMake(bgBtn.center.x, bgBtn.center.y - 57/2);
    [self layoutIfNeeded];
    
    CGFloat icw = 28;
    UIButton *closeBtn = [[UIButton alloc] initWithFrame:CGRectMake((CGRectGetWidth(bgBtn.frame) - icw)/2, CGRectGetMaxY(view.frame) + 25, icw, icw)];
    [closeBtn addTarget:self action:@selector(closeAction:) forControlEvents:UIControlEventTouchUpInside];
    [closeBtn setBackgroundImage:[UIImage imageNamed:@"home_icon_close"] forState:UIControlStateNormal];
    [bgBtn addSubview:closeBtn];
    
    [UIView animateWithDuration:PopDuration
                          delay:0.0
                        options:(UIViewAnimationOptionCurveEaseOut | UIViewAnimationOptionAllowUserInteraction)
                     animations:^{
                        view.alpha = 1.0;
                     } completion:^(BOOL finished) {
                         objc_setAssociatedObject (self, &CSToastActivityViewKey, view, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
                         objc_setAssociatedObject (view, &MLPopCloseBlockKey, closeBlock, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
                     }];
}

-(void)popViewInCenter:(UIView *)view WithSize:(CGSize)size canClose:(BOOL)canClose{
    view.alpha = 0.0;
    UIButton *bgBtn = [[UIButton alloc] initWithFrame:self.bounds];
    bgBtn.backgroundColor = [UIColor colorWithHexString:@"#000000" alpha:.50f];
    if (canClose) {
        [bgBtn addTarget:self action:@selector(closeAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    [self addSubview:bgBtn];
    [bgBtn addSubview:view];
    view.size = size;
    view.center = bgBtn.center;
    [self layoutIfNeeded];
    
    UIButton *closeBtn = [[UIButton alloc] initWithFrame:CGRectMake((CGRectGetWidth(bgBtn.frame) - 32)/2, CGRectGetMaxY(view.frame) + 25, 32, 32)];
    [closeBtn addTarget:self action:@selector(closeAction:) forControlEvents:UIControlEventTouchUpInside];
    [closeBtn setBackgroundImage:[UIImage imageNamed:@"home_icon_close"] forState:UIControlStateNormal];
    [bgBtn addSubview:closeBtn];
    
    [UIView animateWithDuration:PopDuration
                          delay:0.0
                        options:(UIViewAnimationOptionCurveEaseOut | UIViewAnimationOptionAllowUserInteraction)
                     animations:^{
                        view.alpha = 1.0;
                     } completion:^(BOOL finished) {
                         objc_setAssociatedObject (self, &CSToastActivityViewKey, view, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
                     }];
}




- (void)showToastView:(UIView *)toast{
    toast.alpha = 0.0;
    
    if (CSToastHidesOnTap) {
        UITapGestureRecognizer *recognizer = [[UITapGestureRecognizer alloc] initWithTarget:toast action:@selector(handleToastTapped:)];
        [toast addGestureRecognizer:recognizer];
        toast.userInteractionEnabled = YES;
        toast.exclusiveTouch = YES;
    }
    
    [self addSubview:toast];
    
    [UIView animateWithDuration:CSToastFadeDuration
                          delay:0.0
                        options:(UIViewAnimationOptionCurveEaseOut | UIViewAnimationOptionAllowUserInteraction)
                     animations:^{
                         toast.alpha = 1.0;
                     } completion:^(BOOL finished) {
                         NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:CSToastDefaultDuration target:self selector:@selector(toastTimerDidFinish:) userInfo:toast repeats:NO];
                         // associate the timer with the toast view
                         objc_setAssociatedObject (toast, &CSToastTimerKey, timer, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
                     }];
}

- (void)showToast:(UIView *)toast duration:(NSTimeInterval)duration position:(id)position
      tapCallback:(void(^)(void))tapCallback
{
    toast.center = [self centerPointForPosition:position withToast:toast];
    toast.alpha = 0.0;
    
    if (CSToastHidesOnTap) {
        UITapGestureRecognizer *recognizer = [[UITapGestureRecognizer alloc] initWithTarget:toast action:@selector(handleToastTapped:)];
        [toast addGestureRecognizer:recognizer];
        toast.userInteractionEnabled = YES;
        toast.exclusiveTouch = YES;
    }
    
    [self addSubview:toast];
    
    [UIView animateWithDuration:CSToastFadeDuration
                          delay:0.0
                        options:(UIViewAnimationOptionCurveEaseOut | UIViewAnimationOptionAllowUserInteraction)
                     animations:^{
                         toast.alpha = 1.0;
                     } completion:^(BOOL finished) {
                         NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:duration target:self selector:@selector(toastTimerDidFinish:) userInfo:toast repeats:NO];
                         // associate the timer with the toast view
                         objc_setAssociatedObject (toast, &CSToastTimerKey, timer, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
                         objc_setAssociatedObject (toast, &CSToastTapCallbackKey, tapCallback, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
                     }];
}


- (void)hideToast:(UIView *)toast {
    [UIView animateWithDuration:CSToastFadeDuration
                          delay:0.0
                        options:(UIViewAnimationOptionCurveEaseIn | UIViewAnimationOptionBeginFromCurrentState)
                     animations:^{
                         toast.alpha = 0.0;
                     } completion:^(BOOL finished) {
                         [toast removeFromSuperview];
                     }];
}

-(void)closeAction:(UIButton *)btn
{
    UIView *existingActivityView = (UIView *)objc_getAssociatedObject(self, &CSToastActivityViewKey);
    [self hidePopView:existingActivityView];
}

-(void)hidePopView:(UIView *)view
{
    
    void (^closeBlock)(void) = objc_getAssociatedObject(view, &MLPopCloseBlockKey);
    
    [UIView animateWithDuration:PopDuration
                          delay:0.0
                        options:(UIViewAnimationOptionCurveEaseIn | UIViewAnimationOptionBeginFromCurrentState)
                     animations:^{
                        view.alpha = 0.0;
                     } completion:^(BOOL finished) {
                         if (closeBlock) {
                             closeBlock();
                         }
                         [view.superview removeFromSuperview];
                     }];
}

-(void)closePopView{
    UIView *existingActivityView = (UIView *)objc_getAssociatedObject(self, &CSToastActivityViewKey);
    void (^closeBlock)(void) = objc_getAssociatedObject(existingActivityView, &MLPopCloseBlockKey);
    [UIView animateWithDuration:PopDuration
                          delay:0.0
                        options:(UIViewAnimationOptionCurveEaseIn | UIViewAnimationOptionBeginFromCurrentState)
                     animations:^{
                        self.alpha = 0.0;
                     } completion:^(BOOL finished) {
                         if (closeBlock) {
                             closeBlock();
                         }
                         [self.superview removeFromSuperview];
                     }];
}

#pragma mark - Events

- (void)toastTimerDidFinish:(NSTimer *)timer {
    [self hideToast:(UIView *)timer.userInfo];
}

- (void)handleToastTapped:(UITapGestureRecognizer *)recognizer {
    NSTimer *timer = (NSTimer *)objc_getAssociatedObject(self, &CSToastTimerKey);
    [timer invalidate];
    
    void (^callback)(void) = objc_getAssociatedObject(self, &CSToastTapCallbackKey);
    if (callback) {
        callback();
    }
    [self hideToast:recognizer.view];
}

#pragma mark - Toast Activity Methods

- (void)makeToastActivity {
    [self makeToastActivity:CSToastActivityDefaultPosition];
}

- (void)makeToastActivity:(id)position {
    // sanity
    UIView *existingActivityView = (UIView *)objc_getAssociatedObject(self, &CSToastActivityViewKey);
    if (existingActivityView != nil) return;
    
    UIView *activityView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CSToastActivityWidth, CSToastActivityHeight)];
    activityView.center = [self centerPointForPosition:position withToast:activityView];
    activityView.backgroundColor = [BlackColor colorWithAlphaComponent:CSToastOpacity];
    activityView.alpha = 0.0;
    activityView.autoresizingMask = (UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin);
    activityView.layer.cornerRadius = CSToastCornerRadius;
    
    if (CSToastDisplayShadow) {
        activityView.layer.shadowColor = BlackColor.CGColor;
        activityView.layer.shadowOpacity = CSToastShadowOpacity;
        activityView.layer.shadowRadius = CSToastShadowRadius;
        activityView.layer.shadowOffset = CSToastShadowOffset;
    }
    
    UIActivityIndicatorView *activityIndicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    activityIndicatorView.center = CGPointMake(activityView.bounds.size.width / 2, activityView.bounds.size.height / 2);
    [activityView addSubview:activityIndicatorView];
    [activityIndicatorView startAnimating];
    
    // associate the activity view with self
    objc_setAssociatedObject (self, &CSToastActivityViewKey, activityView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
    [self addSubview:activityView];
    
    [UIView animateWithDuration:CSToastFadeDuration
                          delay:0.0
                        options:UIViewAnimationOptionCurveEaseOut
                     animations:^{
                         activityView.alpha = 1.0;
                     } completion:nil];
}

- (void)hideToastActivity {
    UIView *existingActivityView = (UIView *)objc_getAssociatedObject(self, &CSToastActivityViewKey);
    if (existingActivityView != nil) {
        [UIView animateWithDuration:CSToastFadeDuration
                              delay:0.0
                            options:(UIViewAnimationOptionCurveEaseIn | UIViewAnimationOptionBeginFromCurrentState)
                         animations:^{
                             existingActivityView.alpha = 0.0;
                         } completion:^(BOOL finished) {
                             [existingActivityView removeFromSuperview];
                             objc_setAssociatedObject (self, &CSToastActivityViewKey, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
                         }];
    }
}

#pragma mark - Helpers

- (CGPoint)centerPointForPosition:(id)point withToast:(UIView *)toast {
    if([point isKindOfClass:[NSString class]]) {
        if([point caseInsensitiveCompare:CSToastPositionTop] == NSOrderedSame) {
            return CGPointMake(self.bounds.size.width/2, (toast.frame.size.height / 2) + CSToastVerticalPadding);
        } else if([point caseInsensitiveCompare:CSToastPositionCenter] == NSOrderedSame) {
            return CGPointMake(self.bounds.size.width / 2, self.bounds.size.height / 2);
        }
    } else if ([point isKindOfClass:[NSValue class]]) {
        return [point CGPointValue];
    }
    
    // default to bottom
    return CGPointMake(self.bounds.size.width/2, (self.bounds.size.height - (toast.frame.size.height / 2)) - CSToastVerticalPadding);
}

- (CGSize)sizeForString:(NSString *)string font:(UIFont *)font constrainedToSize:(CGSize)constrainedSize lineBreakMode:(NSLineBreakMode)lineBreakMode {
    if ([string respondsToSelector:@selector(boundingRectWithSize:options:attributes:context:)]) {
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        paragraphStyle.lineBreakMode = lineBreakMode;
        NSDictionary *attributes = @{NSFontAttributeName:font, NSParagraphStyleAttributeName:paragraphStyle};
        CGRect boundingRect = [string boundingRectWithSize:constrainedSize options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil];
        return CGSizeMake(ceilf(boundingRect.size.width), ceilf(boundingRect.size.height));
    }
    
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
    return [string sizeWithFont:font constrainedToSize:constrainedSize lineBreakMode:lineBreakMode];
#pragma clang diagnostic pop
}

- (UIView *)viewForMessage:(NSString *)message title:(NSString *)title image:(UIImage *)image {
    // sanity
    if((message == nil) && (title == nil) && (image == nil)) return nil;
    
    // dynamically build a toast view with any combination of message, title, & image.
    UILabel *messageLabel = nil;
    UILabel *titleLabel = nil;
    UIImageView *imageView = nil;
    
    // create the parent view
    UIView *wrapperView = [[UIView alloc] init];
    wrapperView.autoresizingMask = (UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin);
    wrapperView.layer.cornerRadius = CSToastCornerRadius;
    
    if (CSToastDisplayShadow) {
        wrapperView.layer.shadowColor = BlackColor.CGColor;
        wrapperView.layer.shadowOpacity = CSToastShadowOpacity;
        wrapperView.layer.shadowRadius = CSToastShadowRadius;
        wrapperView.layer.shadowOffset = CSToastShadowOffset;
    }
    
    wrapperView.backgroundColor = [BlackColor colorWithAlphaComponent:CSToastOpacity];
    
    if(image != nil) {
        imageView = [[UIImageView alloc] initWithImage:image];
        imageView.contentMode = UIViewContentModeScaleAspectFit;
        imageView.frame = CGRectMake(CSToastHorizontalPadding, CSToastVerticalPadding, CSToastImageViewWidth, CSToastImageViewHeight);
    }
    
    CGFloat imageWidth, imageHeight, imageLeft;
    
    // the imageView frame values will be used to size & position the other views
    if(imageView != nil) {
        imageWidth = imageView.bounds.size.width;
        imageHeight = imageView.bounds.size.height;
        imageLeft = CSToastHorizontalPadding;
    } else {
        imageWidth = imageHeight = imageLeft = 0.0;
    }
    
    if (title != nil) {
        titleLabel = [[UILabel alloc] init];
        titleLabel.numberOfLines = CSToastMaxTitleLines;
        titleLabel.font = [UIFont boldSystemFontOfSize:CSToastFontSize];
        titleLabel.textAlignment = NSTextAlignmentLeft;
        titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
        titleLabel.textColor = WhiteColor;
        titleLabel.backgroundColor = [UIColor clearColor];
        titleLabel.alpha = 1.0;
        titleLabel.text = title;
        
        // size the title label according to the length of the text
        CGSize maxSizeTitle = CGSizeMake((self.bounds.size.width * CSToastMaxWidth) - imageWidth, self.bounds.size.height * CSToastMaxHeight);
        CGSize expectedSizeTitle = [self sizeForString:title font:titleLabel.font constrainedToSize:maxSizeTitle lineBreakMode:titleLabel.lineBreakMode];
        titleLabel.frame = CGRectMake(0.0, 0.0, expectedSizeTitle.width, expectedSizeTitle.height);
    }
    
    if (message != nil) {
        messageLabel = [[UILabel alloc] init];
        messageLabel.numberOfLines = CSToastMaxMessageLines;
        messageLabel.font = [UIFont systemFontOfSize:CSToastFontSize];
        messageLabel.lineBreakMode = NSLineBreakByWordWrapping;
        messageLabel.textColor = WhiteColor;
        messageLabel.backgroundColor = [UIColor clearColor];
        messageLabel.alpha = 1.0;
        messageLabel.text = message;
        
        // size the message label according to the length of the text
        CGSize maxSizeMessage = CGSizeMake((self.bounds.size.width * CSToastMaxWidth) - imageWidth, self.bounds.size.height * CSToastMaxHeight);
        CGSize expectedSizeMessage = [self sizeForString:message font:messageLabel.font constrainedToSize:maxSizeMessage lineBreakMode:messageLabel.lineBreakMode];
        messageLabel.frame = CGRectMake(0.0, 0.0, expectedSizeMessage.width, expectedSizeMessage.height);
    }
    
    // titleLabel frame values
    CGFloat titleWidth, titleHeight, titleTop, titleLeft;
    
    if(titleLabel != nil) {
        titleWidth = titleLabel.bounds.size.width;
        titleHeight = titleLabel.bounds.size.height;
        titleTop = CSToastVerticalPadding;
        titleLeft = imageLeft + imageWidth + CSToastHorizontalPadding;
    } else {
        titleWidth = titleHeight = titleTop = titleLeft = 0.0;
    }
    
    // messageLabel frame values
    CGFloat messageWidth, messageHeight, messageLeft, messageTop;
    
    if(messageLabel != nil) {
        messageWidth = messageLabel.bounds.size.width;
        messageHeight = messageLabel.bounds.size.height;
        messageLeft = imageLeft + imageWidth + CSToastHorizontalPadding;
        messageTop = titleTop + titleHeight + CSToastVerticalPadding;
    } else {
        messageWidth = messageHeight = messageLeft = messageTop = 0.0;
    }
    
    CGFloat longerWidth = MAX(titleWidth, messageWidth);
    CGFloat longerLeft = MAX(titleLeft, messageLeft);
    
    // wrapper width uses the longerWidth or the image width, whatever is larger. same logic applies to the wrapper height
    CGFloat wrapperWidth = MAX((imageWidth + (CSToastHorizontalPadding * 2)), (longerLeft + longerWidth + CSToastHorizontalPadding));
    CGFloat wrapperHeight = MAX((messageTop + messageHeight + CSToastVerticalPadding), (imageHeight + (CSToastVerticalPadding * 2)));
    
    wrapperView.frame = CGRectMake(0.0, 0.0, wrapperWidth, wrapperHeight);
    
    if(titleLabel != nil) {
        titleLabel.frame = CGRectMake(titleLeft, titleTop, titleWidth, titleHeight);
        [wrapperView addSubview:titleLabel];
    }
    
    if(messageLabel != nil) {
        messageLabel.frame = CGRectMake(messageLeft, messageTop, messageWidth, messageHeight);
        [wrapperView addSubview:messageLabel];
    }
    
    if(imageView != nil) {
        [wrapperView addSubview:imageView];
    }
    
    return wrapperView;
}

/**
 *  给视图添加虚线边框
 *
 *  @param lineWidth  线宽
 *  @param lineMargin 每条虚线之间的间距
 *  @param lineLength 每条虚线的长度
 *  @param lineColor 每条虚线的颜色
 */
- (void)addDottedLineBorderWithLineWidth:(CGFloat)lineWidth lineMargin:(CGFloat)lineMargin lineLength:(CGFloat)lineLength lineColor:(UIColor *)lineColor;
{
    CAShapeLayer *border = [CAShapeLayer layer];
    
    border.strokeColor = lineColor.CGColor;
    
    border.fillColor = nil;
    
    border.path = [UIBezierPath bezierPathWithRect:self.bounds].CGPath;
    
    border.frame = self.bounds;
    
    border.lineWidth = lineWidth;
    
    border.lineCap = @"round";
    
    border.lineDashPattern = @[@(lineLength), @(lineMargin)];
    
    [self.layer addSublayer:border];
}

/**
    虚线
 @param lineColor 虚线颜色
 @param fillColor 填充色
 @param radius 虚线圆角
 @param lineWidth 虚线宽度
 @param type 虚线类型 "butt", "round" and "square"
 
 */
- (UIView *)drawDotLineWithLineColor:(UIColor *)lineColor withFillColor:(UIColor *)fillColor withCornerRadius:(CGFloat)radius withLineWidth:(CGFloat)lineWidth AndLineType:(NSString *)type {
    
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    shapeLayer.strokeColor = lineColor.CGColor;
    shapeLayer.fillColor = fillColor.CGColor;
    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:self.bounds cornerRadius:radius];
    shapeLayer.path = path.CGPath;
    shapeLayer.frame = self.bounds;
    shapeLayer.lineWidth = lineWidth;
    if (type) {
        shapeLayer.lineCap = type;
    }else{
        shapeLayer.lineCap = @"square";
    }
    //虚线每段长度和间隔
    shapeLayer.lineDashPattern = @[@(3), @(2)];
    [self layoutIfNeeded];
    [self.layer addSublayer:shapeLayer];
    return self;
}


/**
 清除子iView
 */
-(void)clearView {
    [self.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
}

/**
 圆角
 使用自动布局，需要在layoutsubviews 中使用
 @param radius 圆角尺寸
 @param corner 圆角位置
 */
- (void)acs_radiusWithRadius:(CGFloat)radius corner:(UIRectCorner)corner {
    if (@available(iOS 11.0, *)) {
        self.layer.cornerRadius = radius;
        self.layer.maskedCorners = (CACornerMask)corner;
    } else {
        UIBezierPath * path = [UIBezierPath bezierPathWithRoundedRect:self.bounds byRoundingCorners:corner cornerRadii:CGSizeMake(radius, radius)];
        CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
        maskLayer.frame = self.bounds;
        maskLayer.path = path.CGPath;
        self.layer.mask = maskLayer;
    }
    self.layer.masksToBounds = YES;
}

-(void)setTagRadius
{
    [self setRounderCornerWithRadius:2.0f];
}

-(void)setRounderCornerWithRadius:(CGFloat)radius
{
    CGSize size = self.frame.size;
    UIColor *color = [UIColor clearColor];
    UIGraphicsBeginImageContextWithOptions(size, NO, 0);
    CGContextRef ref = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(ref, color.CGColor);
    CGContextSetStrokeColorWithColor(ref, [UIColor redColor].CGColor);
    
    CGContextMoveToPoint(ref, size.width, size.height-radius);
    CGContextAddArcToPoint(ref, size.width, size.height, size.width-radius, size.height, radius);//右下角
    CGContextAddArcToPoint(ref, 0, size.height, 0, size.height-radius, radius);//左下角
    CGContextAddArcToPoint(ref, 0, 0, radius, 0, radius);//左上角
    CGContextAddArcToPoint(ref, size.width, 0, size.width, radius, radius);//右上角
    CGContextClosePath(ref);
    CGContextDrawPath(ref, kCGPathFillStroke);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, size.width, size.height)];
    [imageView setImage:image];
    [self insertSubview:imageView atIndex:0];
}


/// 渐变色
/// @param colors 颜色数组
-(void)gradation:(NSArray *)colors startPoint:(CGPoint)startPoint endPoint:(CGPoint)endPoint
{
    if (!colors) {
        return;
    }
    
    CAGradientLayer *gl = (CAGradientLayer *)objc_getAssociatedObject(self, &MLayerClearKey);
    if (gl) {
        [gl removeFromSuperlayer];
    }
    
    NSMutableArray *colorArr = [NSMutableArray array];
    for (UIColor *color in colors) {
        [colorArr addObject:(__bridge id)color.CGColor];
    }
    gl = [CAGradientLayer layer];
    gl.frame = self.bounds;
    gl.startPoint = startPoint;
    gl.endPoint = endPoint;
    gl.colors = colorArr;
    gl.locations = @[@(0.0),@(1.0f)];
    objc_setAssociatedObject (self, &MLayerClearKey, gl, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    [self.layer insertSublayer:gl atIndex:0];
}

-(void)gradation:(NSArray *)colors startPoint:(CGPoint)startPoint endPoint:(CGPoint)endPoint frame:(CGRect)frame isFront:(BOOL)isFront {
    if (!colors) {
        return;
    }
    NSMutableArray *colorArr = [NSMutableArray array];
    for (UIColor *color in colors) {
        [colorArr addObject:(__bridge id)color.CGColor];
    }
    CAGradientLayer *gl = [CAGradientLayer layer];
    gl.frame = frame;
    gl.startPoint = startPoint;
    gl.endPoint = endPoint;
    gl.colors = colorArr;
    gl.locations = @[@(0.0),@(1.0f)];

    if (isFront) {
        [self.layer addSublayer:gl];
    } else {
        [self.layer insertSublayer:gl atIndex:0];
    }
}

- (void)addShadow:(UIColor *)color Offset:(CGSize)offSet Radius:(CGFloat)radius {
    self.layer.shadowColor = color.CGColor;
    self.layer.shadowOffset = offSet;
    self.layer.shadowOpacity = 1;
    self.layer.shadowRadius = radius;
}

- (void)addShadowWithColor:(UIColor *)shadowColor shadowOpacity:(CGFloat)shadowOpacity shadowRadius:(CGFloat)shadowRadius shadowPathType:(MLShadowPathType)shadowPathType shadowPathWidth:(CGFloat)shadowWidth{
    
    self.layer.masksToBounds = NO;//必须要等于NO否则会把阴影切割隐藏掉
    self.layer.shadowColor = shadowColor.CGColor;// 阴影颜色
    self.layer.shadowOpacity = shadowOpacity;// 阴影透明度，默认0
    self.layer.shadowOffset = CGSizeZero;//shadowOffset阴影偏移，默认(0, -3),这个跟shadowRadius配合使用
    self.layer.shadowRadius = shadowRadius;//阴影半径，默认3
    CGRect shadowRect = CGRectZero;
    CGFloat originX,originY,sizeWith,sizeHeight;
    originX = 0;
    originY = 0;
    sizeWith = self.bounds.size.width;
    sizeHeight = self.bounds.size.height;
    
    if (shadowPathType == MLShadowTop) {
        shadowRect = CGRectMake(originX, originY-shadowWidth/2, sizeWith, shadowWidth);
    }else if (shadowPathType == MLShadowBottom){
        shadowRect = CGRectMake(originY, sizeHeight-shadowWidth/2, sizeWith, shadowWidth);
    }else if (shadowPathType == MLShadowLeft){
        shadowRect = CGRectMake(originX-shadowWidth/2, originY, shadowWidth, sizeHeight);
    }else if (shadowPathType == MLShadowRight){
        shadowRect = CGRectMake(sizeWith-shadowWidth/2, originY, shadowWidth, sizeHeight);
    }else if (shadowPathType == MLShadowCommon){
        shadowRect = CGRectMake(originX-shadowWidth/2, 2, sizeWith+shadowWidth, sizeHeight+shadowWidth/2);
    }else if (shadowPathType == MLShadowAround){
        shadowRect = CGRectMake(originX-shadowWidth/2, originY-shadowWidth/2, sizeWith+shadowWidth, sizeHeight+shadowWidth);
    }
    UIBezierPath *bezierPath = [UIBezierPath bezierPathWithRect:shadowRect];
    self.layer.shadowPath = bezierPath.CGPath;//阴影路径
}





@end
