//
//  KLineChartView.m
//  JiaKeNengOC
//
//  Created by jkn-mac on 2023/6/28.
//

#import "KLineChartView.h"
#import "ChartStyle.h"
#import "KLineInfoView.h"
#import "KLineTimeInfoView.h"

@interface KLineChartView() <KLinePainterViewDelegate>

//@property(nonatomic,strong) KLineInfoView *infoView;
//@property(nonatomic,strong) KLineTimeInfoView *kLineTimeInfoView;

@property(nonatomic,assign) CGFloat maxScroll;
@property(nonatomic,assign) CGFloat minScroll;

@property(nonatomic,assign) CGFloat lastScrollX;

@property(nonatomic,assign) CGFloat dragbeginX;
@property(nonatomic,assign) BOOL isDrag;
@property(nonatomic,assign) CGFloat speedX;
@property(nonatomic,strong) CADisplayLink *displayLink;

@property(nonatomic,assign) BOOL isScale;
@property(nonatomic,assign) CGFloat lastscaleX;

@property(nonatomic,assign) BOOL isAllowSlide;

@end

@implementation KLineChartView

- (void)setFrame:(CGRect)frame {
    [super setFrame:frame];
    self.painterView.frame = self.bounds;
    [self.painterView.fullScreenBtn setFrame:CGRectMake(self.size.width - 30, self.size.height - ChartStyle_bottomDateHigh - 30, 36, 36)];
    [self initIndicatirs];
}

- (void)setDatas:(NSArray<KLineModel *> *)datas {
    _datas = datas;
    [self initIndicatirs];
    self.painterView.datas = datas;
    //self.painterView.scaleX = _scaleX;    `
}

- (void)setIsLine:(BOOL)isLine {
    _isLine = isLine;
    self.painterView.isLine = isLine;
}

- (void)setIsLongPress:(BOOL)isLongPress {
    _isLongPress = isLongPress;
    self.painterView.isLongPress = isLongPress;
//    if(!isLongPress) {
//        [self.infoView removeFromSuperview];
//        [self.kLineTimeInfoView removeFromSuperview];
//    }
}

- (void)setSingleTagPress:(BOOL)singleTagPress {
    _singleTagPress = singleTagPress;
    self.painterView.singleTagPress = singleTagPress;
//    if (!singleTagPress) {
//        [self.infoView removeFromSuperview];
//        [self.kLineTimeInfoView removeFromSuperview];
//    }
}

-(void)setScrollX:(CGFloat)scrollX {
    _scrollX = scrollX;
    self.painterView.scrollX = scrollX;
}

- (void)setScaleX:(CGFloat)scaleX {
    _scaleX = scaleX;
    [self initIndicatirs];
    self.painterView.scaleX = scaleX;
}

- (void)setMainState:(MainState)mainState {
    _mainState = mainState;
    self.painterView.mainState = mainState;
}

-(void)setSecondaryState:(SecondaryState)secondaryState {
    _secondaryState = secondaryState;
    self.painterView.secondaryState = secondaryState;
}

- (void)setSingleTagX:(CGFloat)singleTagX {
    _singleTagX = singleTagX;
    self.painterView.singleTagX = singleTagX;
}

-(void)setLongPressX:(CGFloat)longPressX {
    _longPressX = longPressX;
    self.painterView.longPressX = longPressX;
}

-(void)setDirection:(KLineDirection)direction {
    _direction = direction;
    self.painterView.direction = direction;
}

- (void)setIsShowDrawPen:(BOOL)isShowDrawPen {
    _isShowDrawPen = isShowDrawPen;
    self.painterView.isShowDrawPen = isShowDrawPen;
}

- (void)setIsShowDrawRect:(BOOL)isShowDrawRect {
    _isShowDrawRect = isShowDrawRect;
    self.painterView.isShowDrawRect = isShowDrawRect;
}

- (void)setIsShowDXW:(BOOL)isShowDXW {
    _isShowDXW = isShowDXW;
    self.painterView.isShowDXW = isShowDXW;
}

- (void)setIsShowBDW:(BOOL)isShowBDW {
    _isShowBDW = isShowBDW;
    self.painterView.isShowBDW = isShowBDW;
}

- (void)setIsShowZLSQ:(BOOL)isShowZLSQ {
    _isShowZLSQ = isShowZLSQ;
    self.painterView.isShowZLSQ = isShowZLSQ;
}

- (void)setIsShowZLQS:(BOOL)isShowZLQS {
    _isShowZLQS = isShowZLQS;
    self.painterView.isShowZLQS = isShowZLQS;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _scaleX = 1;
        _lastscaleX = 1;
        _mainState = MainStateMA;
        _secondaryState = SecondaryStateWR;
        _scrollX = -self.frame.size.width / 5 + ChartStyle_candleWidth / 2;
        [self initIndicatirs];
        _painterView = [[KLinePainterView alloc] initWithFrame:self.bounds datas:_datas scrollX:_scrollX isLine:_isLine scaleX:_scaleX isLongPress:_isLongPress mainState:_mainState secondaryState:_secondaryState];
        _painterView.delegate = self;
        [self addSubview:_painterView];
        __weak typeof(self) weakSelf = self;
        _painterView.updateKlineInfoBlock = ^(KLineModel * _Nonnull model) {
            if (weakSelf.delegate && [weakSelf.delegate respondsToSelector:@selector(updateStockInfoWithModel:)]) {
                [weakSelf.delegate updateStockInfoWithModel:model];
            }
        };
//        _painterView.showInfoBlock = ^(KLineModel * _Nonnull model, BOOL isLeft) {
//            weakSelf.infoView.model = model;
//            [weakSelf addSubview:weakSelf.infoView];
//            CGFloat padding = 5;
//            if(isLeft){
//                weakSelf.infoView.frame = CGRectMake(padding, 30,  weakSelf.infoView.frame.size.width,  weakSelf.infoView.frame.size.height);
//            } else {
//                weakSelf.infoView.frame = CGRectMake(weakSelf.frame.size.width - weakSelf.infoView.frame.size.width - padding, 30,  weakSelf.infoView.frame.size.width,  weakSelf.infoView.frame.size.height);
//            }
//        };
//
//        _painterView.showTimeInfoBlock = ^(KLineModel * _Nonnull model, BOOL isLeft) {
//            weakSelf.kLineTimeInfoView.model = model;
//            [weakSelf addSubview:weakSelf.kLineTimeInfoView];
//            CGFloat padding = 5;
//            if(isLeft){
//                weakSelf.kLineTimeInfoView.frame = CGRectMake(padding, 30,  weakSelf.kLineTimeInfoView.frame.size.width,  weakSelf.kLineTimeInfoView.frame.size.height);
//            } else {
//                weakSelf.kLineTimeInfoView.frame = CGRectMake(weakSelf.frame.size.width - weakSelf.kLineTimeInfoView.frame.size.width - padding, 30,  weakSelf.kLineTimeInfoView.frame.size.width,  weakSelf.kLineTimeInfoView.frame.size.height);
//            }
//        };
        UITapGestureRecognizer *tapRecognize = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tagEvent:)];
        UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(dragKlineEvent:)];
        UILongPressGestureRecognizer *longGresture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressKlineEvent:)];
        UIPinchGestureRecognizer *pinGesture = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(secalXEvent:)];
        [_painterView addGestureRecognizer:tapRecognize];
        [_painterView addGestureRecognizer:panGesture];
        [_painterView addGestureRecognizer:longGresture];
        [_painterView addGestureRecognizer:pinGesture];
        
        self.panGesture = panGesture;
    }
    return self;
}

-(void)initIndicatirs {
    
    CGFloat dataLength = ((CGFloat)_datas.count) * (ChartStyle_candleWidth * _scaleX + ChartStyle_canldeMargin) - ChartStyle_canldeMargin;
    _maxScroll = dataLength - self.frame.size.width;
    
    CGFloat dataScroll = self.frame.size.width - dataLength;

//    if (_datas.count > 0) {
//        if (dataLength > self.frame.size.width) {
//            _maxScroll = dataLength - self.frame.size.width;
//        }else {
//            // 处理数据量不够时,填充整个图表
//            _maxScroll = 0;
//            _scaleX = (self.frame.size.width - (_datas.count - 1) * ChartStyle_canldeMargin) / (_datas.count * ChartStyle_candleWidth);
//            dataScroll = 0;
//        }
//    }
    
    self.minScroll = MIN(0,-dataScroll);
    self.scrollX = [self clamp:_scrollX min:_minScroll max:_maxScroll];
    self.lastScrollX = self.scrollX;
    
    if (dataScroll >= 0 || _isLine) {
        self.isAllowSlide = NO;
    }else {
        self.isAllowSlide = YES;
    }
}

- (void)tagEvent:(UITapGestureRecognizer *)gesture{
    CGPoint point = [gesture locationInView:self.painterView];
//    NSLog(@"xxxxxx = %f",point.y);
//    NSLog(@"yyyyyyy = %f",CGRectGetMaxY(self.painterView.mainRect));
    
    if (point.y < CGRectGetMaxY(self.painterView.mainRect)) {
        self.singleTagX = point.x;
        self.singleTagPress = !self.singleTagPress;
        
        if (!self.singleTagPress) {
            [self.delegate showLatestStockBaseInfo];
        }
    }
}

-(void)dragKlineEvent:(UIPanGestureRecognizer *)gesture{
    
    if (!self.isAllowSlide) { return; }
    
    if (self.singleTagPress) {
        self.singleTagPress = NO;
        [self.delegate showLatestStockBaseInfo];
    }
    
    if(_displayLink) {
        [_displayLink invalidate];
        _displayLink = nil;
    }
    switch (gesture.state) {
        case UIGestureRecognizerStateBegan:
        {
            CGPoint point = [gesture locationInView:self.painterView];
            _dragbeginX = point.x;
            _isDrag = true;
        } break;
        case UIGestureRecognizerStateChanged:
        {
            CGPoint point = [gesture locationInView:self.painterView];
            CGFloat dragX = point.x - _dragbeginX;
            self.scrollX = [self clamp:_lastScrollX + dragX min:_minScroll max:_maxScroll];
            //NSLog(@"拖动 = %f",self.scrollX);
        } break;
        case UIGestureRecognizerStateEnded:
        {
            CGPoint speed = [gesture velocityInView:self.painterView];
            self.speedX = speed.x;
            _isDrag = false;
            self.lastScrollX = self.scrollX;
            if(speed.x != 0) {
                _displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(refreshEvent:)];
                [_displayLink addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSRunLoopCommonModes];
            }
        }break;
        default:
            break;
    }
}

-(void)longPressKlineEvent:(UILongPressGestureRecognizer *)gesture {
    if (self.singleTagPress) {self.singleTagPress = NO;}
    
    switch (gesture.state) {
        case UIGestureRecognizerStateBegan:
        {
            CGPoint point = [gesture locationInView:self.painterView];
            self.longPressX = point.x;
            self.isLongPress = YES;
        } break;
        case UIGestureRecognizerStateChanged:
        {
            CGPoint point = [gesture locationInView:self.painterView];
            self.longPressX = point.x;
            self.isLongPress = YES;
        } break;
        case UIGestureRecognizerStateEnded:
            self.isLongPress = NO;
            [self.delegate showLatestStockBaseInfo];
        default:
            break;
    }
}

-(void)secalXEvent:(UIPinchGestureRecognizer *)gesture {
//    CGFloat velocity = gesture.velocity;
//    CGFloat scale = gesture.scale;
//    NSLog(@"用户捏合的速度为%g、比例为%g", velocity , scale);
//    //NSLog(@"self.lastscaleX = %f",self.lastscaleX);
//    NSLog(@"xxxxxxself.scaleX = %f \n",self.scaleX);
    if (self.singleTagPress) {self.singleTagPress = NO;}
    
    switch (gesture.state) {
        case UIGestureRecognizerStateBegan:
            _isScale = true;
            break;
        case UIGestureRecognizerStateChanged:
        {
            _isScale = true;
            self.scaleX = [self clamp:self.lastscaleX * gesture.scale min:0.03 max:3]; //设置最大最小缩放
        }
        case UIGestureRecognizerStateEnded:
        {
            _isScale = false;
            self.lastscaleX = _scaleX;
        }
        default:
            break;
    }
    
    gesture.scale = 1;
}

-(void)refreshEvent:(CADisplayLink *)displaylink {
    CGFloat space = 100;
    if(self.speedX < 0) {
        self.speedX = MIN(self.speedX + space,0);
        self.scrollX = [self clamp:self.scrollX - 5 min:_minScroll max:_maxScroll];
        //self.lastscaleX = self.scrollX;
    } else if (self.speedX > 0) {
        self.speedX = MAX(self.speedX - space,0);
        self.scrollX = [self clamp:self.scrollX + 5 min:_minScroll max:_maxScroll];
        self.lastScrollX = self.scrollX;
    } else {
        [_displayLink invalidate];
        _displayLink = nil;
    }
    if(self.scrollX == self.minScroll) {
        [_displayLink invalidate];
        _displayLink = nil;
    }
}

-(CGFloat)clamp:(CGFloat)value min:(CGFloat)min max:(CGFloat)max {
    if (value < min) {
        return min;
    } else if (value > max) {
        return max;
    } else {
        return value;
    }
}

#pragma mark ---- KLinePainterViewDelegate ----
- (void)selectIndex:(NSString *)str {
    if (_delegate && [_delegate respondsToSelector:@selector(selectIndex:)]) {
        [_delegate selectIndex:str];
    }
}

- (void)fullScreen {
    if (_delegate && [_delegate respondsToSelector:@selector(fullScreen)]) {
        [_delegate fullScreen];
    }
}


#pragma mark ---- 懒加载 ----
//- (KLineInfoView *)infoView {
//    if(_infoView == nil) {
//        _infoView = [KLineInfoView lineInfoView];
//    }
//    return _infoView;
//}
//
//- (KLineTimeInfoView *)kLineTimeInfoView {
//    if(_kLineTimeInfoView == nil) {
//        _kLineTimeInfoView = [KLineTimeInfoView kLineTimeInfoView];
//    }
//    return _kLineTimeInfoView;
//}

@end

