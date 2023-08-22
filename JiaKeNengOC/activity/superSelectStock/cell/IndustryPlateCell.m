//
//  IndustryPlateCell.m
//  JiaKeNengOC
//
//  Created by jkn-mac on 2023/6/20.
//

#import "IndustryPlateCell.h"

@interface IndustryPlateCell ()

@property (nonatomic, weak) IBOutlet UILabel *serialLabel;
@property (nonatomic, weak) IBOutlet UILabel *nameLabel;

@end

@implementation IndustryPlateCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setModel:(SelectStockModel *)model {
    _model = model;
    
    self.serialLabel.text = model.serialNumber;
    self.nameLabel.text = model.titleName;
}

- (void)setIsChecked:(BOOL)isChecked
{
    _isChecked = isChecked;
    
    if (_isChecked) {
        self.checkImageView.image = [UIImage imageNamed:@"z_btn_select_s"];
    }else{
        self.checkImageView.image = [UIImage imageNamed:@"z_btn_select_n"];
    }

}

@end
