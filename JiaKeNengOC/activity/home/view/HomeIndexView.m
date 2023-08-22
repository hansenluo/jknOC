//
//  HomeIndexView.m
//  JiaKeNengOC
//
//  Created by jkn-mac on 2023/7/31.
//

#import "HomeIndexView.h"

@interface HomeIndexView ()

@property (nonatomic, weak) IBOutlet UIView *bgView;
@property (nonatomic, weak) IBOutlet UILabel *nameLabel;
@property (nonatomic, weak) IBOutlet UILabel *priceLabel;
@property (nonatomic, weak) IBOutlet UILabel *IncreaseLabel;
@property (nonatomic, weak) IBOutlet UILabel *amplitudeLabel;
@property (nonatomic, weak) IBOutlet UIButton *bgBtn;

@end

@implementation HomeIndexView

- (void)setModel:(HomeIndexModel *)model {
    _model = model;
    
    self.nameLabel.text = model.stockName;
    self.priceLabel.text = [NSString stringWithFormat:@"%.2f",model.close];
    CGFloat upDown = model.close - model.lasetDayclose;
    NSString *symbol = @"-";
    if(upDown > 0) {
        symbol = @"+";
        self.priceLabel.textColor = ChartColors_dnColor;
        self.IncreaseLabel.textColor = ChartColors_dnColor;
        self.amplitudeLabel.textColor = ChartColors_dnColor;
        self.bgView.backgroundColor = [UIColor colorWithHexString:@"#1EB45E" alpha:0.1];
    } else {
        self.priceLabel.textColor = ChartColors_upColor;
        self.IncreaseLabel.textColor = ChartColors_upColor;
        self.amplitudeLabel.textColor = ChartColors_upColor;
        self.bgView.backgroundColor = [UIColor colorWithHexString:@"#F62D4B" alpha:0.1];
    }
    CGFloat upDownPercent = upDown / model.lasetDayclose * 100;
    self.IncreaseLabel.text = [NSString stringWithFormat:@"%@%.2f",symbol,ABS(upDown)];
    if (model.lasetDayclose == 0) {
        self.amplitudeLabel.text = @"-";
    }else {
        self.amplitudeLabel.text = [NSString stringWithFormat:@"%@%.2f%%",symbol,ABS(upDownPercent)];
    }
}

- (IBAction)bgBtnClick:(id)sender {
    [self.delegate selectIndexViewWithModel:self.model];
}

@end
