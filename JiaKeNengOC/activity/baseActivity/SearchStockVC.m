//
//  SearchStockVC.m
//  JiaKeNengOC
//
//  Created by jkn-mac on 2023/8/1.
//

#import "SearchStockVC.h"
#import "SearchStockCell.h"
#import "KLineMainVC.h"

@interface SearchStockVC () <UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate> {
    NSArray *_originalArray;
}

@property (nonatomic, weak) IBOutlet NSLayoutConstraint *naviBarH;
@property (nonatomic, weak) IBOutlet UITableView *tableView;
@property (nonatomic, weak) IBOutlet UIView *searchView;
@property (nonatomic, weak) IBOutlet UITextField *searchTextField;

@property (nonatomic, strong) NSMutableArray *dataSourceArray;
@property (nonatomic, strong) NSMutableArray *dataSourceNameArray;
@property (nonatomic, strong) NSMutableArray *predicateArr;
@property (nonatomic, strong) NSMutableArray *tempPredicateArr;

@end

@implementation SearchStockVC

- (void)dealloc {
    NSLog(@"dealloc");
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.navigationBarHidden = YES;
    self.naviBarH.constant = Height_NavBar;
    [self.searchView acs_radiusWithRadius:18 corner:UIRectCornerAllCorners];
    self.searchTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"纳斯达克指数" attributes:@{NSForegroundColorAttributeName:[UIColor colorWithHexString:@"#999999"]}];
    [self.searchTextField becomeFirstResponder];
    
    NSURL *cacheDirectory = [[[NSFileManager defaultManager] URLsForDirectory:NSCachesDirectory inDomains:NSUserDomainMask] firstObject];
    NSURL *cacheURL = [cacheDirectory URLByAppendingPathComponent:@"allcode.json"];
    
    NSData *jsonData;
    NSError *error;
    NSData *data = [NSData dataWithContentsOfURL:cacheURL options:NSDataReadingMappedIfSafe error:&error];
    if (data != nil) {
        jsonData = data;
    }else {
        NSString *path = [[NSBundle mainBundle] pathForResource:@"getStockCodes" ofType:@""];
        NSDate *data = [[NSData alloc] initWithContentsOfURL: [[NSURL alloc] initFileURLWithPath:path]];
        _originalArray = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingFragmentsAllowed error:nil];
    }

    if (jsonData != nil) {
        NSError *error;
        NSArray<NSArray<NSString *> *> *jsonArray = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:&error];
        if (jsonArray != nil) {
            _originalArray = jsonArray;
        }
    }

    [_originalArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
//        [self.predicateArr addObject:[NSString stringWithFormat:@"%@   %@",obj[0],obj[1]]];
//        [self.tempPredicateArr addObject:[NSString stringWithFormat:@"%@ %@ {%@",obj[0],obj[1],obj[2]]];
        
        [self.predicateArr addObject:[NSString stringWithFormat:@"%@",obj[0]]];
        [self.tempPredicateArr addObject:[NSString stringWithFormat:@"%@",obj[1]]];
    }];
}

#pragma mark ---- UITableViewDataSource ----
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataSourceArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 64;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cell_id = @"cell_id";
    SearchStockCell *cell = (SearchStockCell *)[tableView dequeueReusableCellWithIdentifier:cell_id];
    if (cell == nil) {
        cell= (SearchStockCell *)[[[NSBundle mainBundle] loadNibNamed:@"SearchStockCell" owner:self options:nil] lastObject];
    }
    
    cell.stockCodeLabel.text = self.dataSourceArray[indexPath.row];
    cell.stockNameLabel.text = self.dataSourceNameArray[indexPath.row];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

#pragma mark ---- UITableViewDelegate ----
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    KLineMainVC *vc = [KLineMainVC new];
//    NSArray *arr01 = [self.tempDataSourceArray[indexPath.row] componentsSeparatedByString:@"{"];
//    NSArray *arr02 = [self.tempDataSourceArray[indexPath.row] componentsSeparatedByString:@" "];
//    if (isNilString(arr01[1])) {
//        vc.mainTitle = @"-";
//    }else {
//        vc.mainTitle = arr01[1];
//    }
    vc.mainTitle = self.dataSourceArray[indexPath.row];
    vc.stockCode = self.dataSourceArray[indexPath.row];
    vc.subTitle = self.dataSourceNameArray[indexPath.row];
    vc.dateSelectState = DateSelectStateDay;
    PushController(vc);
}

#pragma mark ---- UITextFieldDelegate ----
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    
    return YES;
}

- (IBAction)textFieldChange {
    if (self.dataSourceArray.count > 0) {
        [self.dataSourceArray removeAllObjects];
        [self.dataSourceNameArray removeAllObjects];
    }
    
    [self.predicateArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
//        [self.predicateArr addObject:[NSString stringWithFormat:@"%@   %@",obj[0],obj[1]]];
//        [self.tempPredicateArr addObject:[NSString stringWithFormat:@"%@ %@ {%@",obj[0],obj[1],obj[2]]];
        
        if ([obj hasPrefix:self.searchTextField.text.uppercaseString]) {
            [self.dataSourceArray addObject:obj];
            [self.dataSourceNameArray addObject:self.tempPredicateArr[idx]];
        }
    }];
    
//    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF CONTAINS %@", self.searchTextField.text.uppercaseString];
//    [self.dataSourceArray addObjectsFromArray:[self.predicateArr filteredArrayUsingPredicate:predicate]];
    //[self.tempDataSourceArray addObjectsFromArray:[self.tempPredicateArr filteredArrayUsingPredicate:predicate]];
    [self.tableView reloadData];
}

- (IBAction)backBtnClick:(id)sender {
    PopViewController;
}

#pragma mark ---- 懒加载 ----
- (NSMutableArray *)dataSourceArray {
    if (_dataSourceArray == nil) {
        _dataSourceArray = [NSMutableArray array];
    }
    return _dataSourceArray;
}

- (NSMutableArray *)predicateArr {
    if (_predicateArr == nil) {
        _predicateArr = [NSMutableArray array];
    }
    return _predicateArr;
}

- (NSMutableArray *)dataSourceNameArray {
    if (_dataSourceNameArray == nil) {
        _dataSourceNameArray = [NSMutableArray array];
    }
    return _dataSourceNameArray;
}

- (NSMutableArray *)tempPredicateArr {
    if (_tempPredicateArr == nil) {
        _tempPredicateArr = [NSMutableArray array];
    }
    return _tempPredicateArr;
}

@end
