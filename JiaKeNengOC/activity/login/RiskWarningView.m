//
//  RiskWarningView.m
//  JiaKeNengOC
//
//  Created by jkn-mac on 2023/6/15.
//

#import "RiskWarningView.h"

@interface RiskWarningView ()

@property (nonatomic, weak) IBOutlet UIButton *gouBtn;

@end

@implementation RiskWarningView

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    [self acs_radiusWithRadius:8 corner:UIRectCornerAllCorners];
}

- (IBAction)checkBtnClick:(id)sender
{
    self.gouBtn.selected = !self.gouBtn.selected;
}

- (IBAction)agreeBtnDone:(id)sender
{
    if (!self.gouBtn.selected) {
        [self makeToast:@"请先勾选同意按钮"];
        return;
    }
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:@"yes" forKey:@"markRead"];
    [defaults synchronize];
    
    [self.superview hidePopView:self];
    if (_delegate && [_delegate respondsToSelector:@selector(hiddenView)]) {
        [_delegate hiddenView];
    }
}

@end
