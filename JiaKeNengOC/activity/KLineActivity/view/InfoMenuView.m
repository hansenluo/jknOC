//
//  InfoMenuView.m
//  JiaKeNengOC
//
//  Created by jkn-mac on 2023/6/27.
//

#import "InfoMenuView.h"
#import "JXCategoryViewAnimator.h"
#import "JXCategoryFactory.h"

@interface InfoMenuView () <UICollectionViewDelegate,UICollectionViewDataSource>

@property (nonatomic, strong) QMUICollectionViewPagingLayout *collectionViewLayout;
@property (nonatomic, strong) NSMutableArray *dataArr;

@property (nonatomic, strong) UIView *indicatorView;

@property (nonatomic, assign) float indicatorLineWidth;
@property (nonatomic, assign) float indicatorLineHeight;//底部指示器高
@property (nonatomic, strong) JXCategoryViewAnimator *animator;
@property (nonatomic, assign) NSInteger selectIndex;

@end

@implementation InfoMenuView

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self initView];
    }
    return self;
}

-(void)initView{
    
    self.backgroundColor = [UIColor clearColor];
    
    self.selectIndex = 0;
    self.indicatorLineWidth = 30;
    self.indicatorLineHeight = 3;
    
    _dataArr = [[NSMutableArray alloc] initWithArray:@[@"新闻",@"资料",@"公告"]];
    _collectionViewLayout = [[QMUICollectionViewPagingLayout alloc] initWithStyle:QMUICollectionViewPagingLayoutStyleDefault];
    _collectionViewLayout.itemSize = CGSizeMake((screenW-20)/3, 25);

    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, screenW, 38) collectionViewLayout:_collectionViewLayout];
    self.collectionView.showsHorizontalScrollIndicator = NO;
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    self.collectionView.backgroundColor = [UIColor clearColor];
    [self.collectionView registerClass:[InfoMenuItemCell class] forCellWithReuseIdentifier:@"cell"];

    [self addSubview:self.collectionView];
    
    self.indicatorLineView = [[UIView alloc] initWithFrame:CGRectMake(0, self.collectionView.BottomY - 5, self.indicatorLineWidth, self.indicatorLineHeight)];
    self.indicatorLineView.backgroundColor = [UIColor colorWithHexString:@"#447CFE"];
    [self.indicatorLineView roundRadius];
    [self.collectionView addSubview:self.indicatorLineView];
    [self.indicatorLineView roundRadius];

    [self.collectionView layoutIfNeeded];
    dispatch_async(dispatch_get_main_queue(),^{
     //刷新完成，其他操作
        [self categorySelectIndex:0];
    });
}

#pragma mark - <UICollectionViewDelegate, UICollectionViewDataSource>
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _dataArr.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    InfoMenuItemCell *cell = (InfoMenuItemCell *)[self.collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    cell.title.text = _dataArr[indexPath.row];
    cell.title.textColor = self.selectIndex == indexPath.row ? WhiteColor : GrayColor;
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    [self categorySelectIndex:indexPath.row];
    [self.delegate categoryClickIndex:indexPath.row];
}

-(void)categorySelectIndex:(NSInteger)index
{
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:index inSection:0];
    InfoMenuItemCell *cell = (InfoMenuItemCell *)[self.collectionView cellForItemAtIndexPath:indexPath];
    NSIndexPath *indexPath2 = [NSIndexPath indexPathForRow:self.selectIndex inSection:0];
    static InfoMenuItemCell *cell2;
    cell2 = (InfoMenuItemCell *)[self.collectionView cellForItemAtIndexPath:indexPath2];
    
    if(self.selectIndex != index){
        if(!cell2){
            [self.collectionView reloadItemsAtIndexPaths:@[indexPath2]];
            [self.collectionView sendSubviewToBack:self.indicatorView];
            cell2 = (InfoMenuItemCell *)[self.collectionView cellForItemAtIndexPath:indexPath2];
        }
        cell2.title.textColor = GrayColor;
    }
    cell.title.textColor = WhiteColor;
    self.selectIndex = index;
    
    CGRect startFrame = self.indicatorLineView.frame;
    CGRect enFrame = CGRectMake(cell.centerX - self.indicatorLineWidth
                                /2, self.height - self.indicatorLineHeight,self.indicatorLineWidth , self.indicatorLineHeight);
    [self updateLine:startFrame toFrame:enFrame view:self.indicatorLineView];
    [self.collectionView scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
}

-(void)updateLine:(CGRect)startFrame toFrame:(CGRect)toFrame view:(UIView *)view
{
    CGFloat leftX = 0;
    CGFloat rightX = 0;
    CGFloat leftWidth = 0;
    CGFloat rightWidth = 0;
    BOOL isNeedReversePercent = NO;
    if (startFrame.origin.x > toFrame.origin.x) {
        leftWidth = toFrame.size.width;
        rightWidth = startFrame.size.width;
        leftX = toFrame.origin.x + (toFrame.size.width - leftWidth)/2;;
        rightX = startFrame.origin.x;
        isNeedReversePercent = YES;
    }else {
        leftWidth = startFrame.size.width;
        rightWidth = toFrame.size.width;
        leftX = startFrame.origin.x;
        rightX = toFrame.origin.x + (toFrame.size.width - rightWidth)/2;
    }
    CGFloat offsetX = 0;//x的少量偏移量
    CGFloat maxWidth = rightX - leftX + rightWidth - offsetX*2;
    self.animator = [[JXCategoryViewAnimator alloc] init];
    self.animator.progressCallback = ^(CGFloat percent) {
        if (isNeedReversePercent) {
            percent = 1 - percent;
        }
        CGFloat targetX = 0;
        CGFloat targetWidth = 0;
        if (percent <= 0.5) {
            targetX = [JXCategoryFactory interpolationFrom:leftX to:leftX + offsetX percent:percent*2];
            targetWidth = [JXCategoryFactory interpolationFrom:leftWidth to:maxWidth percent:percent*2];
        }else {
            targetX = [JXCategoryFactory interpolationFrom:(leftX + offsetX) to:rightX percent:(percent - 0.5)*2];
            targetWidth = [JXCategoryFactory interpolationFrom:maxWidth to:rightWidth percent:(percent - 0.5)*2];
        }
        CGRect endFrame = view.frame;
        endFrame.origin.x = targetX;
        endFrame.size.width = targetWidth;
        view.frame = endFrame;
    };
    [self.animator start];
}

- (void)contentOffsetOfContentScrollViewDidChanged:(CGPoint)contentOffset {
    
    CGFloat ratio = contentOffset.x/self.collectionView.bounds.size.width;
    if (ratio > _dataArr.count - 1 || ratio < 0) {
        //超过了边界，不需要处理
        return;
    }
    ratio = MAX(0, MIN(_dataArr.count - 1, ratio));
    NSInteger baseIndex = floorf(ratio);
    if (baseIndex + 1 >= _dataArr.count) {
        //右边越界了，不需要处理
        return;
    }
    CGFloat remainderRatio = ratio - baseIndex;
    if (self.animator.isExecuting) {
        [self.animator invalid];
        self.animator = nil;
    }
    
    CGRect rightCellFrame = [self indicatorFrame:baseIndex+1];
    CGRect leftCellFrame =  [self indicatorFrame:baseIndex];
    CGFloat percent = remainderRatio;
    CGFloat targetX = leftCellFrame.origin.x;
    CGFloat targetWidth = self.indicatorLineWidth;

    CGFloat leftWidth = targetWidth;
    CGFloat rightWidth = self.indicatorLineWidth;
    CGFloat leftX = leftCellFrame.origin.x + (leftCellFrame.size.width - leftWidth)/2;
    CGFloat rightX = rightCellFrame.origin.x + (rightCellFrame.size.width - rightWidth)/2;

    CGFloat offsetX = 0;//x的少量偏移量
    CGFloat maxWidth = rightX - leftX + rightWidth - offsetX*2;
    //前50%，只增加width；后50%，移动x并减小width
    if (percent <= 0.5) {
        targetX = [JXCategoryFactory interpolationFrom:leftX to:leftX + offsetX percent:percent*2];
        targetWidth = [JXCategoryFactory interpolationFrom:leftWidth to:maxWidth percent:percent*2];
    }else {
        targetX = [JXCategoryFactory interpolationFrom:(leftX + offsetX) to:rightX percent:(percent - 0.5)*2];
        targetWidth = [JXCategoryFactory interpolationFrom:maxWidth to:rightWidth percent:(percent - 0.5)*2];
    }
    //允许变动frame的情况：1、允许滚动；2、不允许滚动，但是已经通过手势滚动切换一页内容了；
    CGRect frame = self.indicatorLineView.frame;
    frame.origin.x = targetX;
    frame.size.width = targetWidth;
    self.indicatorLineView.frame = frame;
}

-(CGRect)indicatorFrame:(NSInteger)index
{
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:index inSection:0];
    UICollectionViewCell *cell = (UICollectionViewCell *)[self.collectionView cellForItemAtIndexPath:indexPath];
    CGRect enFrame = CGRectMake(cell.centerX - self.indicatorLineWidth
                                /2, self.height - self.indicatorLineHeight,self.indicatorLineWidth , self.indicatorLineHeight);
    return enFrame;
}

@end

@implementation InfoMenuItemCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initView];
    }
    return self;
}

-(void)initView{
    self.title = [[QMUILabel alloc] init];
    self.title.font = [UIFont systemFontOfSize:16];
    self.title.text = @"";
    self.title.textColor = WhiteColor;
    self.title.textAlignment = NSTextAlignmentCenter;
    [self.contentView addSubview:self.title];
    
    [self.title mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.bottom.equalTo(self);
    }];
}

@end
