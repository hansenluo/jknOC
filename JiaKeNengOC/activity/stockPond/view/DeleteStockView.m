//
//  DeleteStockView.m
//  JiaKeNengOC
//
//  Created by jkn-mac on 2023/6/16.
//

#import "DeleteStockView.h"
#import "SelectDeleteStockCell.h"

@interface DeleteStockView () <UITableViewDelegate, UITableViewDataSource> 

@property (nonatomic, weak) IBOutlet UIButton *deleteBtn;
@property (nonatomic, weak) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) NSMutableArray *markArray;
@property (nonatomic, strong) NSMutableArray *checkArray;

@end

@implementation DeleteStockView

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    [self acs_radiusWithRadius:6 corner:UIRectCornerAllCorners];
    
    for (int i = 0; i < 5; i++) {
        [self.dataArray addObject:[NSString stringWithFormat:@"选中第%d行",i]];
        
        NSMutableDictionary *resultDict = [NSMutableDictionary dictionaryWithObject:@0 forKey:@"isChecked"];
        [self.markArray addObject:resultDict];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 64;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 5;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *cell_id = @"cell_id";
    SelectDeleteStockCell *cell = (SelectDeleteStockCell *)[tableView dequeueReusableCellWithIdentifier:cell_id];
    if (cell == nil) {
        cell= (SelectDeleteStockCell *)[[[NSBundle mainBundle] loadNibNamed:@"SelectDeleteStockCell" owner:self options:nil] lastObject];
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    NSDictionary *resultDict = self.markArray[indexPath.row];
    cell.isChecked = [resultDict[@"isChecked"] boolValue];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    SelectDeleteStockCell *cell = (SelectDeleteStockCell *)[tableView cellForRowAtIndexPath:indexPath];
     NSString *checkString  = self.dataArray[indexPath.row];
     NSMutableDictionary *checkedResult = self.markArray[indexPath.row];
    //isChecked为NO则表明要把这行置为选中状态
    if ([checkedResult[@"isChecked"] boolValue]==NO) {
        [checkedResult setValue:@1 forKey:@"isChecked"];
        cell.isChecked = YES;
        [self.checkArray addObject:checkString];

    }
    else{
        [checkedResult setValue:@0 forKey:@"isChecked"];
        cell.isChecked = NO;
        [self.checkArray removeObject:checkString];

    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    //刷新指定的行
    NSIndexPath *indexPath_Row=[NSIndexPath indexPathForRow:indexPath.row inSection:0];
    [tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath_Row,nil] withRowAnimation:UITableViewRowAnimationNone];
    
    if (self.checkArray.count == 0) {
        [self.deleteBtn setTitle:@"删除" forState:UIControlStateNormal];
    }else{
        [self.deleteBtn setTitle:[NSString stringWithFormat:@"删除(%ld)",self.checkArray.count] forState:UIControlStateNormal];
    }
    
}

- (IBAction)closeBtnDone:(id)sender
{
    [self.superview hidePopView:self];
}

- (NSMutableArray *)dataArray{

    if (!_dataArray) {
        _dataArray =[NSMutableArray array];
    }
    return _dataArray;
}

- (NSMutableArray *)markArray{
    
    if (!_markArray) {
        _markArray =[NSMutableArray array];
    }
    return _markArray;
}

- (NSMutableArray *)checkArray{
    
    if (!_checkArray) {
        _checkArray =[NSMutableArray array];
    }
    return _checkArray;
}

@end
