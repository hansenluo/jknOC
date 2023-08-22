//
//  RealTimeBuySaleCell.m
//  JiaKeNengOC
//
//  Created by jkn-mac on 2023/7/19.
//

#import "RealTimeBuySaleCell.h"

@interface RealTimeBuySaleCell ()

@property (nonatomic, weak) IBOutlet UILabel *label01;
@property (nonatomic, weak) IBOutlet UILabel *label02;
@property (nonatomic, weak) IBOutlet UILabel *label03;
@property (nonatomic, weak) IBOutlet UILabel *label04;
@property (nonatomic, weak) IBOutlet UILabel *label05;
@property (nonatomic, weak) IBOutlet UILabel *label06;
@property (nonatomic, weak) IBOutlet UILabel *label07;
@property (nonatomic, weak) IBOutlet UILabel *label08;

@end

@implementation RealTimeBuySaleCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setDataWithArray:(NSArray *)array {
    self.label01.text = array[0];
    self.label05.text = array[0];
    
    CGFloat sale1Price = [array[1] doubleValue];
    CGFloat buy1Price = [array[3] doubleValue];
    NSInteger sale1Num = [array[2] integerValue];
    NSInteger buy1Num = [array[4] integerValue];
    
    self.label02.text = [NSString stringWithFormat:@"%.2f",buy1Price];
    self.label06.text = [NSString stringWithFormat:@"%.2f",sale1Price];
    self.label03.text = [NSString stringWithFormat:@"%ld",buy1Num];
    self.label07.text = [NSString stringWithFormat:@"%ld",sale1Num];
}

@end
