//
//  KLineTimeInfoView.m
//  JiaKeNengOC
//
//  Created by jkn-mac on 2023/7/22.
//

#import "KLineTimeInfoView.h"
#import "ChartStyle.h"

@interface KLineTimeInfoView()
@property (weak, nonatomic) IBOutlet UILabel *timeLable;

@property (weak, nonatomic) IBOutlet UILabel *openLable;
@property (weak, nonatomic) IBOutlet UILabel *highLable;

@end

@implementation KLineTimeInfoView

+(instancetype)kLineTimeInfoView {
    KLineTimeInfoView *view = [[NSBundle mainBundle] loadNibNamed:@"KLineTimeInfoView" owner:self options:nil].lastObject;
    view.frame = CGRectMake(0, 0, 90, 60);
    return view;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    self.backgroundColor = ChartColors_bgColor;
    self.layer.borderWidth = 1;
    self.layer.borderColor = ChartColors_gridColor.CGColor;
}

- (void)setModel:(KLineModel *)model {
    _model = model;
    
    _timeLable.text = model.date;
    
    _openLable.text = [NSString stringWithFormat:@"%.2f",model.close];
    _highLable.text = [NSString stringWithFormat:@"%.2f",model.vol];
    
}

@end
