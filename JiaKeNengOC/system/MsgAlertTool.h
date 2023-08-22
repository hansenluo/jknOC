//
//  MsgAlertTool.h
//  CallJiu8
//
//  Created by lele on 2018/5/29.
//  Copyright © 2018年 lele. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MsgAlertTool : NSObject

+ (void) showAlert:(NSString *)title content:(NSString *)content;

+ (void)showAlert:(NSString *)title
          message:(NSString *)message
       completion:(void (^)(BOOL cancelled, NSInteger buttonIndex))completion
cancelButtonTitle:(NSString *)cancelButtonTitle
otherButtonTitles:(NSString *)otherButtonTitle;

+ (void)showAlert:(NSString *)title
          message:(NSString *)message
       completion:(void (^)(BOOL cancelled, NSInteger buttonIndex))completion
   okButtonTitles:(NSString *)okButtonTitles;

+(void)showQMAlert:(NSString *)title
           message:(NSString *)message
        completion:(void (^)(BOOL cancelled, NSInteger buttonIndex))completion
    okButtonTitles:(NSString *)okButtonTitles;

+(void)showQMAlert:(NSString *)title
           message:(NSString *)message
        completion:(void (^)(BOOL cancelled, NSInteger buttonIndex))completion
 cancelButtonTitle:(NSString *)cancelButtonTitle
 otherButtonTitles:(NSString *)otherButtonTitle;

//带取消按钮
+(void)showQMCancelAlert:(NSString *)title
           message:(NSString *)message
        completion:(void (^)(BOOL cancelled, NSInteger buttonIndex))completion
           okButtonTitle:(NSString *)okButtonTitle;

+(void)ToastAlert:(NSString *)message completion:(void (^)(BOOL cancelled, NSInteger buttonIndex))completion
   okButtonTitles:(NSString *)okButtonTitles;
+ (void)showAlert:(NSString *)title
          message:(NSString *)message
           upView:(UIView *)upView
       completion:(void (^)(BOOL cancelled, NSInteger buttonIndex))completion
cancelButtonTitle:(NSString *)cancelButtonTitle
otherButtonTitles:(NSString *)otherButtonTitle;

+(void)ToastMainAlert:(NSString *)message completion:(void (^)(BOOL cancelled, NSInteger buttonIndex))completion
       okButtonTitles:(NSString *)okButtonTitles;

+(void)ToastLoginoutAlert:(NSString *)message completion:(void (^)(BOOL cancelled, NSInteger buttonIndex))completion
           okButtonTitles:(NSString *)okButtonTitles;
+(void)ToastAlert:(NSString *)message;

//选择相册
+ (void)showPhotoAlert:(NSString *)title
            completion:(void (^)(BOOL cancelled, NSInteger buttonIndex))completion;

+ (void)showBottomAlert:(NSString *)title actions:(NSArray *)actions completion:(void (^)(BOOL cancelled, NSInteger buttonIndex))completion;
+ (void)showQMBottomAlert:(NSString *)title actions:(NSArray *)actions completion:(void (^)(BOOL cancelled, NSInteger buttonIndex))completion;
@end
