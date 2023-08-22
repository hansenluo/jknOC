//
//  JournalismListCell.m
//  JiaKeNengOC
//
//  Created by jkn-mac on 2023/6/27.
//

#import "JournalismListCell.h"

@interface JournalismListCell ()

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *timeLabel;

@end

@implementation JournalismListCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = ClearColor;
        
        self.titleLabel = [UILabel new];
        self.titleLabel.text = @"鲍威尔若成“沃尔克”，强势美元将起飞";
        self.titleLabel.textColor = [UIColor colorWithHexString:@"#CCCCCC"];
        self.titleLabel.font = MFont(14);
        [self addSubview:self.titleLabel];
        
        self.timeLabel = [UILabel new];
        self.timeLabel.text = @"14:52";
        self.timeLabel.textColor = GrayColor;
        self.timeLabel.font = MFont(14);
        self.timeLabel.textAlignment = NSTextAlignmentRight;
        [self addSubview:self.timeLabel];
        
        //添加约束
        [self mask];
    }
    return self;
}

- (void)mask
{
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.mas_right).offset(-12);
        make.centerY.equalTo(self);
        make.height.equalTo(@12);
        make.width.equalTo(@45);
    }];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(12);
        make.right.equalTo(self.timeLabel).offset(-5);
        make.centerY.equalTo(self);
        make.height.equalTo(@12);
    }];
}

@end
