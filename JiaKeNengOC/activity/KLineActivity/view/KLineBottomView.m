//
//  KLineBottomView.m
//  JiaKeNengOC
//
//  Created by jkn-mac on 2023/8/16.
//

#import "KLineBottomView.h"

@implementation KLineBottomView

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.addPondBtn.imagePosition = QMUIButtonImagePositionLeft;
    self.addPondBtn.spacingBetweenImageAndTitle = 5;
    
    self.addAIBtn.imagePosition = QMUIButtonImagePositionLeft;
    self.addAIBtn.spacingBetweenImageAndTitle = 5;
}

- (IBAction)addPondBtnClick:(id)sender {
    [self.delegate addPondBtnAction];
}

- (IBAction)addAIBtnClick:(id)sender {
    [self.delegate addAIBtnAction];
}

@end
