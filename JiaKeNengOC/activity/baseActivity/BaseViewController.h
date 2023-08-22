//
//  BaseViewController.h
//  JiaKeNengOC
//
//  Created by jkn-mac on 2023/6/27.
//

#import <QMUIKit/QMUIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface BaseViewController : QMUICommonViewController <QMUIModalPresentationContentViewControllerProtocol>

//@property (nonatomic, strong) NetWorkView *netWorkEmptyView;
@property (nonatomic, assign) BOOL navigationBarHidden;//是否隐藏标题
@property (nonatomic, assign) BOOL isNetWorking;//网路是否可用
@property (nonatomic, assign) BOOL hidebackBtn;
@property (nonatomic, assign) BOOL isFristNet;
@property (nonatomic, assign) BOOL forceEnableBackGesture;

//自定义返回键用qmuibutton，统一尺寸11x20，然后使用qmui_outside扩大点击范围
//返回键的2个不同颜色的版本，用于滑动时的切换；
//由于切换时可能会频繁调用切换方法，懒加载一次
@property (nonatomic, strong) UIImage *backBtnImageBlack;
@property (nonatomic, strong) UIImage *backBtnImageWhite;

//返回事假
-(void)handleBackButtonEvent;
//设置返回按钮
-(void)setbackImage:(UIImage *)image;
//添加右侧按钮
-(void)setrightNavItem:(NSArray *)items;
//右侧按钮点击事件 根据tag辨识
-(void)navRightButtonEvent:(UIBarButtonItem *)item;
//隐藏返回按钮
- (void)hiddenbackBtn;
/**
 * 便利构造器
 * @abstract 使用与类名相同的标识从Storyboard创建控制器
 * @param sbName Storyboard名字
 * @return 视图控制器实例
 */
+ (instancetype)instanceWithSb:(NSString *)sbName;

/**
 * 便利构造器
 * @abstract 从Storyboard创建控制器
 * @param sbName Storyboard名字
 * @param identifier sb ID
 * @return 视图控制器实例
 */
+ (instancetype)instanceWithSb:(NSString *)sbName identifier:(NSString *)identifier;
- (void)adjustFonts;
- (void)initDataHandleAction;
- (void)initUIHandleAction;
- (void)mjRefreshEndIsHeaderRefresh:(BOOL)isHeader TotalPages:(NSInteger)totalPages CurrentPage:(NSInteger)currentPage Object:(UIScrollView *)object;
- (void)mjRefreshEndIsHeaderRefreshIfRequestFailed:(BOOL)isHeader Object:(UIScrollView *)object;

@end

NS_ASSUME_NONNULL_END
