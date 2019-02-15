//
//  WKVirtualWorldViewController.m
//  秀加加
//  标题：虚拟世界
//  Created by sks on 2017/2/14.
//  Copyright © 2017年 walkingtec. All rights reserved.
//

#import "WKVirtualWorldViewController.h"
#import "WKVirtualWorldModel.h"
#import "WKVirtualWorldTableViewCell.h"
#import "WKVirtualLayout.h"
#import "NSObject+WKImagePicker.h"
#import "WKImageModel.h"
#import "WKMemoViewController.h"

@interface WKVirtualWorldViewController () <UITableViewDelegate,UITableViewDataSource,WKVirtualDelegate>
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,assign) NSInteger currIdx;
@property (nonatomic,strong) NSMutableArray *dataArray;
@end

@implementation WKVirtualWorldViewController

- (NSMutableArray *)dataArray{
    if (!_dataArray) {
        _dataArray = @[].mutableCopy;
    }
    return _dataArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"虚拟世界";
    
    self.currIdx = 1;
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"back"] style:UIBarButtonItemStylePlain target:self action:@selector(bbiBack)];

    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, WKScreenW, WKScreenH - 64) style:UITableViewStyleGrouped];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
    
    __block __weak typeof(self) weakSelf = self;
    _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        weakSelf.currIdx = 1;
        [weakSelf loadDataList];
    }];
    
    _tableView.mj_footer = [MJRefreshAutoFooter footerWithRefreshingBlock:^{
        weakSelf.currIdx += 1;
        [weakSelf loadDataList];
    }];
    
    [_tableView registerClass:[WKVirtualWorldTableViewCell class] forCellReuseIdentifier:NSStringFromClass([WKVirtualWorldTableViewCell class])];
    [self loadDataList];
}

- (void)loadDataList{
    
    NSString *url = [NSString configUrl:WKVirtualList With:@[@"PageSize",@"PageIndex"] values:@[@(10),@(_currIdx)]];
    
    [WKHttpRequest auctionGoods:HttpRequestMethodPost url:url param:nil model:nil success:^(WKBaseResponse *response) {
//        NSLog(@"response : %@",response.json);
        [_tableView.mj_header endRefreshing];
        [_tableView.mj_footer endRefreshing];
        
        NSArray *pageArr = [NSArray yy_modelArrayWithClass:[WKVirtualWorldModel class] json:response.json[@"Data"][@"InnerList"]];

        if (self.currIdx == 1) {
            [self.dataArray removeAllObjects];
        }
        
        for (int i=0; i<pageArr.count; i++) {
            WKVirtualLayout *layout = [[WKVirtualLayout alloc] init];
            layout.dataModel = pageArr[i];
            [self.dataArray addObject:layout];
        }
        
        if(self.dataArray.count == 0){
            _tableView.loading = YES;
            _tableView.dataVerticalOffset = -50;
            _tableView.buttonText = @"";
            _tableView.descriptionText = @"您的虚拟世界空空如也\n快去购买虚拟商品吧";
            _tableView.buttonNormalColor = [UIColor colorWithHexString:@"7e879d"];
            _tableView.loadedImageName = @"virtualWorldNone";
            _tableView.loading = NO;
        }

        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
        });
        
    } failure:^(WKBaseResponse *response) {
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
    }];
    
}

//MARK: UITableView delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.dataArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.1f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    WKVirtualLayout *layout = self.dataArray[indexPath.section];
    return layout.height;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 7.0f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    WKVirtualWorldTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([WKVirtualWorldTableViewCell class])];
    [cell setLayout:self.dataArray[indexPath.section]];
    cell.delegate = self;
    return cell;
}

#pragma cell Delegate
- (void)deleteVirtual:(WKVirtualWorldModel *)virtualWorld{
    // 删除虚拟世界
    NSString *url = [NSString configUrl:WKDeleteVirtual With:@[@"OrderCode"] values:@[virtualWorld.OrderCode]];
    
    [WKHttpRequest getAuthCode:HttpRequestMethodPost url:url param:nil success:^(WKBaseResponse *response) {
        [WKPromptView showPromptView:@"删除成功"];
        [_dataArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            WKVirtualLayout *item = (WKVirtualLayout *)obj;
            if ([item.dataModel isEqual:virtualWorld]) {
                [_dataArray removeObject:item];
            }
        }];
        [_tableView reloadData];
    } failure:^(WKBaseResponse *response) {
        [WKPromptView showPromptView:@"删除失败"];
    }];
}

- (void)tapImageArr:(NSArray *)arr Idx:(NSInteger)idx{
    // 查看图片
    NSMutableArray *imageArr = @[].mutableCopy;

    for (int i=0; i <arr.count; i++)
    {
        WKImageModel *imageModel = arr[i];
        ZLPhotoPickerBrowserPhoto *photo = [[ZLPhotoPickerBrowserPhoto alloc] init];
        if (imageModel.image == nil) {
            
            if (imageModel.PicUrl) {
                photo.photoURL = [NSURL URLWithString:imageModel.PicUrl];
            }else{
                photo.photoURL = [NSURL URLWithString:imageModel.FileUrl];
            }
        }else{
            photo.photoImage = imageModel.image;
        }
        [imageArr addObject:photo];
    }
    
    [self showImageWith:imageArr index:idx];
}

-(void)tapMemoSelet:(NSString *)momeStr{
    WKMemoViewController *memoVC = [[WKMemoViewController alloc]init];
    memoVC.textStr = momeStr;
    [self.navigationController pushViewController:memoVC animated:YES];
}

- (void)bbiBack{
//    [self dismissViewControllerAnimated:YES completion:NULL];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)dealloc{
    NSLog(@"释放虚拟世界VC");
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
