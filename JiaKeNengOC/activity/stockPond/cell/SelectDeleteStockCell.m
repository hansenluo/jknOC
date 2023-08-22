//
//  SelectDeleteStockCell.m
//  JiaKeNengOC
//
//  Created by jkn-mac on 2023/6/16.
//

#import "SelectDeleteStockCell.h"

@implementation SelectDeleteStockCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setIsChecked:(BOOL)isChecked
{
    _isChecked = isChecked;
    
    if (_isChecked) {
        self.checkImageView.image = [UIImage imageNamed:@"icon_gou_s"];
    }else{
        self.checkImageView.image = [UIImage imageNamed:@"icon_gou_n"];
    }

}

@end
