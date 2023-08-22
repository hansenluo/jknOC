//
//  MsgAlertTool.m
//  CallJiu8
//
//  Created by lele on 2018/5/29.
//  Copyright © 2018年 lele. All rights reserved.
//

#import "MsgAlertTool.h"
#import "AppDelegate.h"

@implementation MsgAlertTool

+ (void) showAlert:(NSString *)title content:(NSString *)content {
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:content preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *ok = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    NSMutableAttributedString *titleText = [[NSMutableAttributedString alloc] initWithString:content];
    [titleText addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:14] range:NSMakeRange(0, content.length)];
    [alert setValue:titleText forKey:@"attributedMessage"];
    
    [alert addAction:ok];
    UIViewController *rootViewController = [[[UIApplication sharedApplication] keyWindow] rootViewController];
    [rootViewController presentViewController:alert animated:YES completion:nil];
}

+ (void)showAlert:(NSString *)title
            message:(NSString *)message
         completion:(void (^)(BOOL cancelled, NSInteger buttonIndex))completion
  cancelButtonTitle:(NSString *)cancelButtonTitle
  otherButtonTitles:(NSString *)otherButtonTitle
{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:cancelButtonTitle style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
//        if (self->completion!=nil)
//            self->completion(YES,0);
        completion(YES,0);
    }];
    [cancel setValue:[System colorWithHexString:@"#8E8E94"]  forKey:@"titleTextColor"];
    [alert addAction:cancel];
    UIAlertAction *other = [UIAlertAction actionWithTitle:otherButtonTitle style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        completion(NO,1);
    }];
    [other setValue:[System colorWithHexString:@"#2898FF"]  forKey:@"titleTextColor"];
    [alert addAction:other];
    
    NSMutableAttributedString *titleText = [[NSMutableAttributedString alloc] initWithString:message];
    [titleText addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:14] range:NSMakeRange(0, message.length)];
    [alert setValue:titleText forKey:@"attributedMessage"];
    
//    UIViewController *rootViewController = [[[UIApplication sharedApplication] keyWindow] rootViewController];
//    [rootViewController presentViewController:alert animated:YES completion:nil];
    [[QMUIHelper visibleViewController] presentViewController:alert animated:YES completion:nil];
}

+ (void)showAlert:(NSString *)title
          message:(NSString *)message
           upView:(UIView *)upView
       completion:(void (^)(BOOL cancelled, NSInteger buttonIndex))completion
cancelButtonTitle:(NSString *)cancelButtonTitle
otherButtonTitles:(NSString *)otherButtonTitle
{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:cancelButtonTitle style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        //        if (self->completion!=nil)
        //            self->completion(YES,0);
        completion(YES,0);
    }];
//    [cancel setValue:MainTextColor  forKey:@"titleTextColor"];
    [alert addAction:cancel];
    UIAlertAction *other = [UIAlertAction actionWithTitle:otherButtonTitle style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        completion(NO,1);
    }];
    [other setValue:[System colorWithHexString:@"#fe2742"]  forKey:@"titleTextColor"];
    [alert addAction:other];
    
    NSMutableAttributedString *titleText = [[NSMutableAttributedString alloc] initWithString:message];
    [titleText addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:14] range:NSMakeRange(0, message.length)];
    [alert setValue:titleText forKey:@"attributedMessage"];
    
    AppDelegate *delegate =(id)[UIApplication sharedApplication].delegate;
    
    UIViewController *vc = [[UIViewController alloc] init];//实例化一个vc
    vc.view = upView;//self.typeView这个是添加在window上面的view
    [delegate.window addSubview:vc.view];//添加
    [vc presentViewController:alert animated:YES completion:nil];
}

+ (void)showAlert:(NSString *)title
          message:(NSString *)message
       completion:(void (^)(BOOL cancelled, NSInteger buttonIndex))completion
okButtonTitles:(NSString *)okButtonTitles
{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *other = [UIAlertAction actionWithTitle:okButtonTitles style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        completion(NO,1);
    }];
    NSMutableAttributedString *titleText = [[NSMutableAttributedString alloc] initWithString:message];
    [titleText addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:14] range:NSMakeRange(0, message.length)];
    [alert setValue:titleText forKey:@"attributedMessage"];
    
    [alert addAction:other];
    UIViewController *rootViewController = [[[UIApplication sharedApplication] keyWindow] rootViewController];
    [rootViewController presentViewController:alert animated:YES completion:nil];
}

+(void)showQMAlert:(NSString *)title
           message:(NSString *)message
        completion:(void (^)(BOOL cancelled, NSInteger buttonIndex))completion
 cancelButtonTitle:(NSString *)cancelButtonTitle
 otherButtonTitles:(NSString *)otherButtonTitle{
    QMUIAlertAction *action1 = [QMUIAlertAction actionWithTitle:cancelButtonTitle style:QMUIAlertActionStyleCancel handler:^(__kindof QMUIAlertController * _Nonnull aAlertController, QMUIAlertAction * _Nonnull action) {
        completion(YES,0);
    }];
    QMUIAlertAction *action2 = [QMUIAlertAction actionWithTitle:otherButtonTitle style:QMUIAlertActionStyleDefault handler:^(__kindof QMUIAlertController * _Nonnull aAlertController, QMUIAlertAction * _Nonnull action) {
        completion(NO,1);
    }];
    QMUIAlertController *alertController = [QMUIAlertController alertControllerWithTitle:title message:message preferredStyle:QMUIAlertControllerStyleAlert];
    alertController.alertTitleMessageSpacing = 10;
    [alertController addAction:action1];
    [alertController addAction:action2];
    [alertController showWithAnimated:YES];
}

+(void)showQMCancelAlert:(NSString *)title
           message:(NSString *)message
        completion:(void (^)(BOOL cancelled, NSInteger buttonIndex))completion
 okButtonTitle:(NSString *)okButtonTitle{
    QMUIAlertAction *action = [QMUIAlertAction actionWithTitle:@"取消" style:QMUIAlertActionStyleCancel handler:^(__kindof QMUIAlertController * _Nonnull aAlertController, QMUIAlertAction * _Nonnull action) {
        completion(YES,0);
    }];
    QMUIAlertAction *action1 = [QMUIAlertAction actionWithTitle:okButtonTitle style:QMUIAlertActionStyleDefault handler:^(__kindof QMUIAlertController * _Nonnull aAlertController, QMUIAlertAction * _Nonnull action) {
        completion(NO,1);
    }];
    QMUIAlertController *alertController = [QMUIAlertController alertControllerWithTitle:title message:message preferredStyle:QMUIAlertControllerStyleAlert];
    alertController.alertTitleMessageSpacing = 10;
    [alertController addAction:action];
    [alertController addAction:action1];
    [alertController showWithAnimated:YES];
}

+(void)showQMAlert:(NSString *)title
           message:(NSString *)message
        completion:(void (^)(BOOL cancelled, NSInteger buttonIndex))completion
 okButtonTitles:(NSString *)okButtonTitles{
    QMUIAlertAction *action1 = [QMUIAlertAction actionWithTitle:okButtonTitles style:QMUIAlertActionStyleDefault handler:^(__kindof QMUIAlertController * _Nonnull aAlertController, QMUIAlertAction * _Nonnull action) {
        completion(NO,1);
    }];
    QMUIAlertController *alertController = [QMUIAlertController alertControllerWithTitle:title message:message preferredStyle:QMUIAlertControllerStyleAlert];
    alertController.alertTitleMessageSpacing = 10;
    [alertController addAction:action1];
    [alertController showWithAnimated:YES];
}

+(void)ToastAlert:(NSString *)message completion:(void (^)(BOOL cancelled, NSInteger buttonIndex))completion
   okButtonTitles:(NSString *)okButtonTitles
{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"" message:message preferredStyle:UIAlertControllerStyleAlert];
    
    NSMutableAttributedString *titleText = [[NSMutableAttributedString alloc] initWithString:message];
    [titleText addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:14] range:NSMakeRange(0, message.length)];
    [alert setValue:titleText forKey:@"attributedMessage"];
//    [UIFont fontWithName:@"ArialMT" size:14]
//    attributedTitle
    
    UIAlertAction *other = [UIAlertAction actionWithTitle:okButtonTitles style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        completion(NO,1);
    }];
    [alert addAction:other];
//    [other setValue:MainTextColor  forKey:@"titleTextColor"];
    
    UIViewController *rootViewController = [[[UIApplication sharedApplication] keyWindow] rootViewController];
    [rootViewController presentViewController:alert animated:YES completion:nil];
}

+(void)ToastMainAlert:(NSString *)message completion:(void (^)(BOOL cancelled, NSInteger buttonIndex))completion
   okButtonTitles:(NSString *)okButtonTitles
{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"" message:message preferredStyle:UIAlertControllerStyleAlert];
    
    NSMutableAttributedString *titleText = [[NSMutableAttributedString alloc] initWithString:message];
    [titleText addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:14] range:NSMakeRange(0, message.length)];
    [alert setValue:titleText forKey:@"attributedMessage"];
    //    [UIFont fontWithName:@"ArialMT" size:14]
    //    attributedTitle
    
    UIAlertAction *other = [UIAlertAction actionWithTitle:okButtonTitles style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        completion(NO,1);
    }];
    [other setValue:WhiteColor  forKey:@"titleTextColor"];
    [alert addAction:other];
    


    UIViewController *rootViewController = [[[UIApplication sharedApplication] keyWindow] rootViewController];
    [rootViewController presentViewController:alert animated:YES completion:nil];
}

+(void)ToastLoginoutAlert:(NSString *)message completion:(void (^)(BOOL cancelled, NSInteger buttonIndex))completion
   okButtonTitles:(NSString *)okButtonTitles
{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"" message:message preferredStyle:UIAlertControllerStyleAlert];
    
    NSMutableAttributedString *titleText = [[NSMutableAttributedString alloc] initWithString:message];
    
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    // 设置文字居中
    paragraphStyle.alignment = NSTextAlignmentLeft;
    [titleText addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [message length])];
    
    [titleText addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:14] range:NSMakeRange(0, message.length)];
    [alert setValue:titleText forKey:@"attributedMessage"];
    //    [UIFont fontWithName:@"ArialMT" size:14]
    //    attributedTitle
    
    UIAlertAction *other = [UIAlertAction actionWithTitle:okButtonTitles style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        completion(NO,1);
    }];
    [alert addAction:other];
//    [other setValue:MainTextColor  forKey:@"titleTextColor"];
    
    UIViewController *rootViewController = [[[UIApplication sharedApplication] keyWindow] rootViewController];
    [rootViewController presentViewController:alert animated:YES completion:nil];
}

+(void)ToastAlert:(NSString *)message
{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"" message:message preferredStyle:UIAlertControllerStyleAlert];
    
    NSMutableAttributedString *titleText = [[NSMutableAttributedString alloc] initWithString:message];
    [titleText addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:14] range:NSMakeRange(0, message.length)];
    [alert setValue:titleText forKey:@"attributedMessage"];
    //    attributedTitle
    
    UIAlertAction *other = [UIAlertAction actionWithTitle:@"关闭" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
    }];
    [alert addAction:other];
//    [other setValue:MainTextColor  forKey:@"titleTextColor"];
    
    UIViewController *rootViewController = [[[UIApplication sharedApplication] keyWindow] rootViewController];
    [rootViewController presentViewController:alert animated:YES completion:nil];
}

+ (void)showPhotoAlert:(NSString *)title
completion:(void (^)(BOOL cancelled, NSInteger buttonIndex))completion
{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:isNilString(title)?nil:title message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *other1 = [UIAlertAction actionWithTitle:@"拍照" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        completion(NO,0);
       }];
    [other1 setValue:[System colorWithHexString:@"#1a1a1a"]  forKey:@"titleTextColor"];
    [alert addAction:other1];
    UIAlertAction *other2 = [UIAlertAction actionWithTitle:@"我的相册" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        completion(NO,1);
       }];
    [other2 setValue:[System colorWithHexString:@"#1a1a1a"]  forKey:@"titleTextColor"];
    [alert addAction:other2];
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        completion(YES,2);
       }];
    [cancel setValue:[System colorWithHexString:@"#1a1a1a"]  forKey:@"titleTextColor"];
    [alert addAction:cancel];
    UIViewController *rootViewController = [[[UIApplication sharedApplication] keyWindow] rootViewController];
    [rootViewController presentViewController:alert animated:YES completion:nil];
    
}

+ (void)showBottomAlert:(NSString *)title actions:(NSArray *)actions completion:(void (^)(BOOL cancelled, NSInteger buttonIndex))completion
{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:isNilString(title)?nil:title message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    for (int i = 0 ; i < actions.count; i++) {
        UIAlertAction *other = [UIAlertAction actionWithTitle:actions[i] style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            completion(NO,i);
           }];
        [other setValue:[System colorWithHexString:@"#1a1a1a"]  forKey:@"titleTextColor"];
        [alert addAction:other];
    }
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        completion(YES,-1);
       }];
    [cancel setValue:[System colorWithHexString:@"#1a1a1a"]  forKey:@"titleTextColor"];
    [alert addAction:cancel];
    UIViewController *rootViewController = [[[UIApplication sharedApplication] keyWindow] rootViewController];
    [rootViewController presentViewController:alert animated:YES completion:nil];
    
}


+ (void)showQMBottomAlert:(NSString *)title actions:(NSArray *)actions completion:(void (^)(BOOL cancelled, NSInteger buttonIndex))completion
{
    QMUIAlertController *alertController = [QMUIAlertController alertControllerWithTitle:title message:@"" preferredStyle:QMUIAlertControllerStyleActionSheet];
    
    for (int i = 0 ; i < actions.count; i++) {
        QMUIAlertAction *action = [QMUIAlertAction actionWithTitle:actions[i] style:QMUIAlertActionStyleDefault handler:^(__kindof QMUIAlertController * _Nonnull aAlertController, QMUIAlertAction * _Nonnull action) {
            completion(NO,i);
        }];
        [alertController addAction:action];
    }
    
    QMUIAlertAction *action1 = [QMUIAlertAction actionWithTitle:@"取消" style:QMUIAlertActionStyleCancel handler:^(__kindof QMUIAlertController * _Nonnull aAlertController, QMUIAlertAction * _Nonnull action) {
        completion(YES,-1);
    }];
    [alertController addAction:action1];
    
    NSMutableDictionary *buttonAttributes = [[NSMutableDictionary alloc] initWithDictionary:alertController.sheetButtonAttributes];
    buttonAttributes[NSForegroundColorAttributeName] = [System colorWithHexString:@"#1a1a1a"];
    buttonAttributes[NSFontAttributeName] = MFont(18);
    alertController.sheetButtonAttributes = buttonAttributes;
    alertController.sheetCancelButtonAttributes = buttonAttributes;
    alertController.alertTitleMessageSpacing = 10;
    [alertController showWithAnimated:YES];
}
@end
