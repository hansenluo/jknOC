//
//  LoginView.h
//  JiaKeNengOC
//
//  Created by jkn-mac on 2023/6/15.
//

#import <UIKit/UIKit.h>
#import "IQKeyboardManager.h"

NS_ASSUME_NONNULL_BEGIN

@protocol LoginViewDelegate <NSObject>

- (void)loginSucceed;

@end

@interface LoginView : UIView

@property (nonatomic, weak) id <LoginViewDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
