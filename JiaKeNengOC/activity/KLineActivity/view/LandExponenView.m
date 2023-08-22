//
//  LandExponenView.m
//  JiaKeNengOC
//
//  Created by jkn-mac on 2023/7/26.
//

#import "LandExponenView.h"

@interface LandExponenView ()

@property (nonatomic, weak) IBOutlet UILabel *titleLabel;
@property (nonatomic, weak) IBOutlet UILabel *subTitleLabel;
@property (nonatomic, weak) IBOutlet UILabel *label01;
@property (nonatomic, weak) IBOutlet UILabel *label02;
@property (nonatomic, weak) IBOutlet UILabel *label03;
@property (nonatomic, weak) IBOutlet UILabel *label04;
@property (nonatomic, weak) IBOutlet UILabel *label05;
@property (nonatomic, weak) IBOutlet UILabel *label06;
@property (nonatomic, weak) IBOutlet UILabel *label07;
@property (nonatomic, weak) IBOutlet UILabel *label08;
@property (nonatomic, weak) IBOutlet UILabel *label09;
@property (nonatomic, weak) IBOutlet UIButton *backBtn;

@end

@implementation LandExponenView

- (void)awakeFromNib {
    [super awakeFromNib];
    [self.backBtn border:1 borderColor:ChartColors_dnColor];
    [self.backBtn setTitleColor:ChartColors_dnColor forState:UIControlStateNormal];
}

- (void)setDataWithArray:(NSArray *)array title:(NSString *)title subTitle:(NSString *)subTitle{
    
    self.titleLabel.text = isNilString(title) ? subTitle : title;
    self.subTitleLabel.text = subTitle;
    
    if (array.count == 0) {
        return;
    }
    
    CGFloat newPrice = [array[1] doubleValue];
    CGFloat highPrice = [array[2] doubleValue];
    CGFloat lowPrice = [array[3] doubleValue];
    CGFloat lasetDayclose = [array[5] doubleValue];
    //成交额
    CGFloat amount = [array[7] doubleValue];
    //总市值
    CGFloat totalValue = [array[8] doubleValue];
    //换手率
    CGFloat turnoverRate = [array[12] doubleValue];
    //市盈率
    CGFloat pegRatio = [array[13] doubleValue];
    
    //最新价
    if (newPrice > lasetDayclose) {
        self.label01.textColor = RiseColor;
    }else if (newPrice < lasetDayclose) {
        self.label01.textColor = DropColor;
    }else {
        self.label01.textColor = GrayColor;
    }
    self.label01.text = [NSString stringWithFormat:@"%.2f",newPrice];
    
    //涨幅价
    CGFloat upDownPrice = newPrice - lasetDayclose;
    if (upDownPrice > 0) {
        self.label02.textColor = RiseColor;
        self.label02.text = [NSString stringWithFormat:@"+%.2f",upDownPrice];
    }else if (upDownPrice < 0) {
        self.label02.textColor = DropColor;
        self.label02.text = [NSString stringWithFormat:@"%.2f",upDownPrice];
    }else {
        self.label02.textColor = GrayColor;
        self.label02.text = @"+0.00";
    }
    
    //涨幅百分比
    CGFloat upDown = newPrice - lasetDayclose;
    NSString *symbol = @"";
    if(upDown > 0) {
        symbol = @"+";
        self.label03.textColor = RiseColor;
    } else if (upDown < 0) {
        symbol = @"-";
        self.label03.textColor = DropColor;
    }else {
        self.label03.textColor = GrayColor;
    }
    CGFloat upDownPercent = upDown / lasetDayclose * 100;
    if (lasetDayclose == 0) {
        self.label03.text = @"-";
    }else {
        self.label03.text = [NSString stringWithFormat:@"%@%.2f%%",symbol,ABS(upDownPercent)];
    }
    
    //最高价
    if (highPrice > lasetDayclose) {
        self.label04.textColor = RiseColor;
    }else if (highPrice < lasetDayclose) {
        self.label04.textColor = DropColor;
    }else {
        self.label04.textColor = GrayColor;
    }
    self.label04.text = [NSString stringWithFormat:@"%.2f",highPrice];
    
    //最低价
    if (lowPrice > lasetDayclose) {
        self.label05.textColor = RiseColor;
    }else if (lowPrice < lasetDayclose) {
        self.label05.textColor = DropColor;
    }else {
        self.label05.textColor = GrayColor;
    }
    self.label05.text = [NSString stringWithFormat:@"%.2f",lowPrice];
    
    //换手率
    self.label06.text = [NSString stringWithFormat:@"%.2f%%",turnoverRate];
    
    //成交额
    if (amount >= 10000) {
        self.label07.text = [NSString stringWithFormat:@"%.0f亿",round(amount / 10000)];
    }else {
        self.label07.text = [NSString stringWithFormat:@"%.0f万",round(amount)];
    }
    
    //总市值
    if (totalValue >= 10000) {
        self.label08.text = [NSString stringWithFormat:@"%.0f亿",round(totalValue / 10000)];
    }else {
        self.label08.text = [NSString stringWithFormat:@"%.0f万",round(totalValue)];
    }
    
    //市盈率
    self.label09.text = [NSString stringWithFormat:@"%.2f",pegRatio];
}

- (void)setDataWithModel:(KLineModel *)model {
    //最新价
    if (model.close > model.lasetDayclose) {
        self.label01.textColor = RiseColor;
    }else if (model.close < model.lasetDayclose) {
        self.label01.textColor = DropColor;
    }else {
        self.label01.textColor = GrayColor;
    }
    self.label01.text = [NSString stringWithFormat:@"%.2f",model.close];
    
    //涨幅价
    CGFloat upDownPrice = model.close - model.lasetDayclose;
    if (upDownPrice > 0) {
        self.label02.textColor = RiseColor;
        self.label02.text = [NSString stringWithFormat:@"+%.2f",upDownPrice];
    }else if (upDownPrice < 0) {
        self.label02.textColor = DropColor;
        self.label02.text = [NSString stringWithFormat:@"%.2f",upDownPrice];
    }else {
        self.label02.textColor = GrayColor;
        self.label02.text = @"+0.00";
    }
    
    //涨幅百分比
    CGFloat upDown = model.close - model.lasetDayclose;
    NSString *symbol = @"";
    if(upDown > 0) {
        symbol = @"+";
        self.label03.textColor = RiseColor;
    } else if (upDown < 0) {
        symbol = @"-";
        self.label03.textColor = DropColor;
    }else {
        self.label03.textColor = GrayColor;
    }
    CGFloat upDownPercent = upDown / model.lasetDayclose * 100;
    if (model.lasetDayclose == 0) {
        self.label03.text = @"-";
    }else {
        self.label03.text = [NSString stringWithFormat:@"%@%.2f%%",symbol,ABS(upDownPercent)];
    }
    
    //最高价
    if (model.high > model.lasetDayclose) {
        self.label04.textColor = RiseColor;
    }else if (model.high < model.lasetDayclose) {
        self.label04.textColor = DropColor;
    }else {
        self.label04.textColor = GrayColor;
    }
    self.label04.text = [NSString stringWithFormat:@"%.2f",model.high];
    
    //最低价
    if (model.low > model.lasetDayclose) {
        self.label05.textColor = RiseColor;
    }else if (model.low < model.lasetDayclose) {
        self.label05.textColor = DropColor;
    }else {
        self.label05.textColor = GrayColor;
    }
    self.label05.text = [NSString stringWithFormat:@"%.2f",model.low];
    
    //换手率
    //self.label06.text = [NSString stringWithFormat:@"%.2f%%",turnoverRate];
    
    //成交额
    if (model.amount >= 10000) {
        self.label07.text = [NSString stringWithFormat:@"%.0f亿",round(model.amount / 10000)];
    }else {
        self.label07.text = [NSString stringWithFormat:@"%.0f万",round(model.amount)];
    }
}

- (IBAction)backBtnClick:(id)sender {
    [self.delegate backBtnAction];
}

@end
