//
//  WKAllOnlineViewController.m
//  秀加加
//
//  Created by sks on 2017/2/26.
//  Copyright © 2017年 walkingtec. All rights reserved.
//

#import "WKAllOnlineViewController.h"
#import "WKOnlineTableViewCell.h"

@interface WKAllOnlineViewController ()<UITableViewDelegate,UITableViewDataSource> {
    UITableView *_tableView;
    NSMutableArray *_dataArray;
    NSString *_memberNo;
}

@end

static NSString *cellId = @"cell";

@implementation WKAllOnlineViewController

- (instancetype)initWithMemberNo:(NSString *)memberNo{
    if (self = [super init]) {
        _memberNo = memberNo;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"在线观众";
    
    _dataArray = @[].mutableCopy;
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"back"] style:UIBarButtonItemStylePlain target:self action:@selector(bbiBack)];
    _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
    
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_offset(UIEdgeInsetsMake(64, 0, 0, 0));
    }];
    
    _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self loadDataList];
    }];
    
    [_tableView registerClass:[WKOnlineTableViewCell class] forCellReuseIdentifier:cellId];
    
    [self loadDataList];
}

- (void)loadDataList {
    NSString *url = [NSString configUrl:WKOnlineList With:@[@"mNo"] values:@[_memberNo]];
    
    [WKHttpRequest getAuthCode:HttpRequestMethodGet url:url param:nil success:^(WKBaseResponse *response) {
        NSLog(@"response %@",response);
        NSArray *arr = [NSArray yy_modelArrayWithClass:[WKOnlineListMd class] json:response.json[@"Data"][@"InnerList"]];
        [_dataArray removeAllObjects];
        [_dataArray addObjectsFromArray:arr];
        for (int i=0; i<_dataArray.count; i++) {
            WKOnlineListMd *md = _dataArray[i];
            md.no = [NSString stringWithFormat:@"%d",i];
        }
        
        [_tableView.mj_header endRefreshing];
        [_tableView reloadData];
    } failure:^(WKBaseResponse *response) {
        [_tableView.mj_header endRefreshing];
    }];
}

- (void)bbiBack{
    [self.navigationController popViewControllerAnimated:YES];
//    [self dismissViewControllerAnimated:YES completion:NULL];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _dataArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 5.0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 70;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    WKOnlineTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    [cell setOnlineListMd:_dataArray[indexPath.row]];
    return cell;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

@implementation WKOnlineListMd



@end
