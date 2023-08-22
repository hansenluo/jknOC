//
//  HomePondCell.m
//  JiaKeNengOC
//
//  Created by jkn-mac on 2023/6/15.
//

#import "HomePondCell.h"

@interface HomePondCell ()

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *tagLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UIView *temView;
@property (weak, nonatomic) IBOutlet UILabel *aitoLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceCountLabel;

@end

@implementation HomePondCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [self.temView acs_radiusWithRadius:2 corner:UIRectCornerAllCorners];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setModel:(StockPondModel *)model {
    _model = model;
    
    self.nameLabel.text = isNilString(model.stockCode) ? @"-" : model.stockCode;
    self.tagLabel.text = isNilString(model.stockName) ? @"-" : model.stockName;
    
    //现价
    if (model.close > model.lasetDayclose) {
        self.priceLabel.textColor = ChartColors_dnColor;
    }else if (model.close < model.lasetDayclose) {
        self.priceLabel.textColor = ChartColors_upColor;
    }else {
        self.priceLabel.textColor = WhiteColor;
    }
    self.priceLabel.text = [NSString stringWithFormat:@"%.2f",model.close];
    
    //涨跌幅
    CGFloat upDown = model.close - model.lasetDayclose;
    NSString *symbol = @"";
    if(upDown > 0) {
        symbol = @"+";
        self.temView.backgroundColor = ChartColors_dnColor;
    } else if (upDown < 0) {
        symbol = @"-";
        self.temView.backgroundColor = ChartColors_upColor;
    }else {
        self.temView.backgroundColor = GrayColor;
    }
    
    if (model.lasetDayclose == 0) {
        self.temView.backgroundColor = GrayColor;
        self.aitoLabel.text = @"-";
    }else {
        CGFloat upDownPercent = upDown / model.lasetDayclose * 100;
        self.aitoLabel.text = [NSString stringWithFormat:@"%@%.2f%%",symbol,ABS(upDownPercent)];
    }
    
    if (model.close <= 0) {
        self.priceLabel.text = @"-";
        self.aitoLabel.text = @"-";
    }
    
    //成交额
    self.priceCountLabel.textColor = ChartColors_dnColor;
   // NSLog(@"xxxx = %f",model.amount / 10000);
    if (model.amount >= 10000) {
        self.priceCountLabel.text = [NSString stringWithFormat:@"%.2f亿",model.amount / 10000];
    }else {
        //self.priceCountLabel.text = [NSString stringWithFormat:@"%.2f万",round(model.amount)];
        self.priceCountLabel.text = [NSString stringWithFormat:@"%.2f万",model.amount];
    }
}

@end
