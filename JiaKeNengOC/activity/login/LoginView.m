//
//  LoginView.m
//  JiaKeNengOC
//
//  Created by jkn-mac on 2023/6/15.
//

#import "LoginView.h"
#import "UserInfo.h"

@interface LoginView () <UITextFieldDelegate>

@property (nonatomic, weak) IBOutlet UIView *sView;
@property (nonatomic, weak) IBOutlet UITextField *accountTextField;
@property (nonatomic, weak) IBOutlet UITextField *passwordTextField;

@end

@implementation LoginView

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.backgroundColor = [UIColor clearColor];
    
    [self.sView acs_radiusWithRadius:8 corner:UIRectCornerAllCorners];
    
    [IQKeyboardManager sharedManager].enableAutoToolbar = NO;
    [IQKeyboardManager sharedManager].shouldResignOnTouchOutside = YES;
    
//    self.accountTextField.text = @"13926584012";
//    self.passwordTextField.text = @"12345678";
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if (textField.tag == 0) {
        [self.passwordTextField becomeFirstResponder];
    }else {
        [self loginBtnDone:nil];
    }
    return YES;
}

- (IBAction)closeBtnDone:(id)sender
{
    [self.superview hidePopView:self];
}

- (IBAction)loginBtnDone:(id)sender
{
    if (isNilString(self.accountTextField.text)) {
        [QMUITips showWithText:@"账号不能为空"];
    }else if (isNilString(self.passwordTextField.text)) {
        [QMUITips showWithText:@"密码不能为空"];
    }else {
        [self.accountTextField resignFirstResponder];
        [self.passwordTextField resignFirstResponder];
        
        [self showProgress:@"登录中..."];
        TMHttpParams *param = [[TMHttpParams alloc] init];
        [param setUrl:API_login_URL];
        [param addParams:self.accountTextField.text forKey:@"mobile"];
        [param addParams:self.passwordTextField.text forKey:@"password"];
        [param addParams:@"login" forKey:@"customKey"];
        param.requestType = POST;
        [DataRequest requestWithParam:param successed:^(NSDictionary *dict, NSError *error, int result, NSString *msg) {
            [self progressDiss];
            if (result == 1) {

                [QMUITips showWithText:@"登录成功"];
                [[UserInfo Instance] setUserName:self.accountTextField.text];
                [[UserInfo Instance] setPassword:self.passwordTextField.text];
                PXNotifiPost(LOGINSTATUSKEY, nil);
                [self.superview hidePopView:self];
                [self.delegate loginSucceed];

            } else {
                [QMUITips showWithText:msg];
            }
        }];
    }
}

@end
