//
//  JournalismListVC.h
//  JiaKeNengOC
//
//  Created by jkn-mac on 2023/6/27.
//

#import <UIKit/UIKit.h>
#import "MLPagerView.h"

NS_ASSUME_NONNULL_BEGIN

@interface JournalismListVC : BaseViewController <MLPagerViewListViewDelegate>

@property (nonatomic, strong) NSString *orderStatus;
@property (nonatomic, copy) void(^didScrollCallback)(UIScrollView *scrollView);

@end

NS_ASSUME_NONNULL_END
