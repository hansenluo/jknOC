//
//  KLineBottomView.h
//  JiaKeNengOC
//
//  Created by jkn-mac on 2023/8/16.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol KLineBottomViewDelegate <NSObject>

- (void)addPondBtnAction;
- (void)addAIBtnAction;

@end

@interface KLineBottomView : UIView

@property (nonatomic, weak) IBOutlet QMUIButton *addPondBtn;
@property (nonatomic, weak) IBOutlet QMUIButton *addAIBtn;
@property (nonatomic, weak) id <KLineBottomViewDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
