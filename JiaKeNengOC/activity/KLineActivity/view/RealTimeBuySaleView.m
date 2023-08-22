//
//  RealTimeBuySaleView.m
//  JiaKeNengOC
//
//  Created by jkn-mac on 2023/7/19.
//

#import "RealTimeBuySaleView.h"
#import "RealTimeBuySaleCell.h"

@interface RealTimeBuySaleView () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSArray *dataArray;

@end

@implementation RealTimeBuySaleView

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setDataWithArray:(NSArray *)array {
    self.dataArray = array;
    
    [self.tableView reloadData];
}

#pragma mark - Table view data source
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 40;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cell_id = @"cell_id";
    RealTimeBuySaleCell *cell = (RealTimeBuySaleCell *)[tableView dequeueReusableCellWithIdentifier:cell_id];
    if (cell == nil) {
        cell= (RealTimeBuySaleCell *)[[[NSBundle mainBundle] loadNibNamed:@"RealTimeBuySaleCell" owner:self options:nil] lastObject];
    }

    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [cell setDataWithArray:self.dataArray[indexPath.row]];
    
    return cell;
}

- (NSArray *)dataArray {
    if (_dataArray == nil) {
        _dataArray = [NSArray array];
    }
    return _dataArray;
}

@end
