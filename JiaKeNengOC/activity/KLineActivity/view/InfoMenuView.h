//
//  InfoMenuView.h
//  JiaKeNengOC
//
//  Created by jkn-mac on 2023/6/27.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol InfoMenuViewDelegate <NSObject>

-(void)categoryClickIndex:(NSInteger)index;

@end

@interface InfoMenuView : UIView

@property (nonatomic, weak) id<InfoMenuViewDelegate> delegate;
@property (nonatomic, strong) UIView *indicatorLineView;
@property (nonatomic, strong) UICollectionView *collectionView;

- (void)categorySelectIndex:(NSInteger)index;
- (void)contentOffsetOfContentScrollViewDidChanged:(CGPoint)contentOffset;

@end


@interface InfoMenuItemCell : UICollectionViewCell

@property (nonatomic, strong) QMUILabel *title;

@end

NS_ASSUME_NONNULL_END
