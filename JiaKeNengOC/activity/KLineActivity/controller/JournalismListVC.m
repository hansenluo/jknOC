//
//  JournalismListVC.m
//  JiaKeNengOC
//
//  Created by jkn-mac on 2023/6/27.
//

#import "JournalismListVC.h"
#import "JournalismListCell.h"

@interface JournalismListVC () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, weak) IBOutlet UITableView *tableView;
@property (nonatomic, copy) void(^scrollCallback)(UIScrollView *scrollView);

@end

@implementation JournalismListVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    NSLog(@"orderStatus = %@",self.orderStatus);
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 45;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *cell_id = @"cell_id";
    JournalismListCell *cell = (JournalismListCell *)[tableView dequeueReusableCellWithIdentifier:cell_id];
    if (cell == nil) {
        cell = [[JournalismListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cell_id];
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

#pragma mark - JXPagingViewListViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    self.scrollCallback(scrollView);
}

- (UIScrollView *)listScrollView {
    return self.tableView;
}

- (UIView *)listView {
    return self.view;
}
- (void)listViewDidScrollCallback:(void (^)(UIScrollView *))callback {
    self.scrollCallback = callback;
}

#pragma mark ---- ChildScrollViewDidScrollDelegate ----
- (void)childScrollViewDidScroll:(UIScrollView *)scrollView
{
    
}

@end
