//
//  KLineChartView.h
//  JiaKeNengOC
//
//  Created by jkn-mac on 2023/6/28.
//

#import <UIKit/UIKit.h>
#import "KLineModel.h"
#import "KLineState.h"
#import "KLinePainterView.h"

NS_ASSUME_NONNULL_BEGIN

@protocol KLineChartViewDelegate <NSObject>

- (void)updateStockInfoWithModel:(KLineModel *)model;
- (void)showLatestStockBaseInfo;
- (void)selectIndex:(NSString *)str;
- (void)fullScreen;

@end

@interface KLineChartView : UIView

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

@property(nonatomic,strong) UIPanGestureRecognizer *panGesture;

@property(nonatomic,weak) id <KLineChartViewDelegate> delegate;

@property(nonatomic,strong) KLinePainterView *painterView;

@end

NS_ASSUME_NONNULL_END
