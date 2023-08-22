//
//  KLinePainterView.h
//  KLine-Chart-OC
//
//  Created by 何俊松 on 2020/3/10.
//  Copyright © 2020 hjs. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KLineModel.h"
#import "KLineState.h"

NS_ASSUME_NONNULL_BEGIN

@protocol KLinePainterViewDelegate <NSObject>

- (void)selectIndex:(NSString *)str;
- (void)fullScreen;

@end

@interface KLinePainterView : UIView

@property(nonatomic,strong) NSArray<KLineModel *> *datas;

@property(nonatomic,assign) CGFloat scrollX;

@property(nonatomic,assign) CGFloat startX;

@property(nonatomic,assign) BOOL isLine;

@property(nonatomic,assign) CGFloat scaleX;

@property(nonatomic,assign) BOOL isLongPress;

@property(nonatomic,assign) BOOL singleTagPress;

@property(nonatomic,assign) CGFloat singleTagX;

@property(nonatomic,assign) CGFloat longPressX;

@property(nonatomic,assign) MainState mainState;

@property(nonatomic,assign) VolState volState;

@property(nonatomic,assign) SecondaryState secondaryState;

@property(nonatomic,assign) KLineDirection direction;

@property(nonatomic,assign) BOOL isShowDrawPen;
@property(nonatomic,assign) BOOL isShowDrawRect;
@property(nonatomic,assign) BOOL isShowDXW;
@property(nonatomic,assign) BOOL isShowBDW;
@property(nonatomic,assign) BOOL isShowZLSQ;
@property(nonatomic,assign) BOOL isShowZLQS;

@property(nonatomic,assign) CGRect mainRect;
@property(nonatomic,assign) CGRect volRect;
@property(nonatomic,assign) CGRect secondaryRect;
@property(nonatomic,assign) CGRect dateRect;

@property(nonatomic,copy) void(^showInfoBlock)(KLineModel *model, BOOL isLeft);

@property(nonatomic,copy) void(^showTimeInfoBlock)(KLineModel *model, BOOL isLeft);

@property(nonatomic,copy) void(^updateKlineInfoBlock)(KLineModel *model);

@property(nonatomic,weak) id <KLinePainterViewDelegate> delegate;

@property(nonatomic,strong) UIButton *fullScreenBtn;

- (instancetype)initWithFrame:(CGRect)frame
                        datas:(NSArray<KLineModel *> *)datas
                      scrollX:(CGFloat)scrollX
                       isLine:(BOOL)isLine
                       scaleX:(CGFloat)scaleX
                  isLongPress:(BOOL)isLongPress
                    mainState:(MainState)mainState
               secondaryState:(SecondaryState)secondaryState;

@end

NS_ASSUME_NONNULL_END
