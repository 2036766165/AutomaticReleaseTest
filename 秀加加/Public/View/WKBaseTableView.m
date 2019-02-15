//
//  WKBaseTableView.m
//  wdbo
//
//  Created by lin on 16/6/23.
//  Copyright © 2016年 Walkingtec. All rights reserved.
//

#import "WKBaseTableView.h"
#import "GzwTableViewLoading.h"

@interface WKBaseTableView()

@property (nonatomic, assign) UITableViewStyle tableViewStyle;
@property (nonatomic, strong) UITableView *tableView;

@end

@implementation WKBaseTableView

- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style
{
    _tableViewStyle = style;
    return [[self.class alloc] initWithFrame:frame];
}

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        _pageNO = 1;
        _pageSize = 10;
        _isEmpty = NO;
        
        self.backgroundColor = [UIColor colorWithHexString:@"eeeeee"];
        [self addSubview:self.tableView];
    }
    return self;
}

- (void)setIsOpenHeaderRefresh:(BOOL)isOpenHeaderRefresh
{
    if (_isOpenHeaderRefresh != isOpenHeaderRefresh) {
        _isOpenHeaderRefresh = isOpenHeaderRefresh;
        WeakSelf(WKBaseTableView);
        if (isOpenHeaderRefresh) {
            //  设置头部刷新
            self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
                weakSelf.pageNO = 1;
//                weakSelf.pageSize = 10;
                [weakSelf headerRequestWithData];
            }];
        }
    }
}

- (void)setIsOpenFooterRefresh:(BOOL)isOpenFooterRefresh
{
    if (_isOpenFooterRefresh != isOpenFooterRefresh) {
        _isOpenFooterRefresh = isOpenFooterRefresh;
        WeakSelf(WKBaseTableView);
        if (isOpenFooterRefresh) {
            //  设置脚部刷新
            self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
                weakSelf.pageNO += 1;//weakSelf.pageSize;
//                weakSelf.pageSize += weakSelf.pageSize;
                [weakSelf footerRequestWithData];
            }];
        }
    }
}

- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:self.frame style:_tableViewStyle];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = [UIColor clearColor];
        
        //  去掉空白多余的行
        _tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    }
    return _tableView;
}

- (NSMutableArray *)dataArray
{
    if (!_dataArray) {
        _dataArray = [[NSMutableArray alloc] init];
    }
    return _dataArray;
}


- (instancetype)init
{
    self = [super init];
    if (self) {
        _pageNO = 1;
        _pageSize = 10;
    }
    return self;
}

- (void)reloadDataWithArray:(NSArray *)array
{
    if (self.pageNO == 1) {
        [self.dataArray removeAllObjects];
        if (array.count == 0) {
            self.isEmpty = YES;
        }
    }
    [self.dataArray addObjectsFromArray:array];
    
    [self.tableView reloadData];
    
    [self endRefreshing];
    
    if (array.count < 10) {
        [self.tableView.mj_footer endRefreshingWithNoMoreData];
    }else{
        [self.tableView.mj_footer resetNoMoreData];
    }
    
}

-(void)reloadData
{
    [self.tableView reloadData];
}

- (void)endRefreshing
{
    //  结束头部刷新
    [self.tableView.mj_header endRefreshing];
    //  结束尾部刷新
    [self.tableView.mj_footer endRefreshing];
}

- (void)noMoreData{
    [self.tableView.mj_footer endRefreshingWithNoMoreData];
}

- (void)resetFooterView{
    [self.tableView.mj_footer resetNoMoreData];
}
/*
 ///重新父类方法 分割线定格
 - (void)viewDidLayoutSubviews
 {
 if ([self.tableView respondsToSelector:@selector(setLayoutMargins:)]) {
 [self.tableView setLayoutMargins:UIEdgeInsetsMake(0, 0, 0, 0)];
 }
 }
 */

#pragma mark -- UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return nil;
}


#pragma mark -- UITableViewDelegate 分割线定格
/*
 - (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
 {
 if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
 [cell setLayoutMargins:UIEdgeInsetsZero];
 }
 }
 */
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, WKScreenW, 0.1)];
    label.backgroundColor = [UIColor colorWithHex:0xd9d9d9];
    return label;
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.5;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.01;
}

- (void)headerRequestWithData
{
    //  空操作
}

- (void)footerRequestWithData
{
    //  空操作
}

- (void)setRemindreImageName:(NSString *)imageName text:(NSString *)text completion:(void(^)())completionBlock
{
    self.tableView.loading = YES;
    
    self.tableView.buttonText = text;
    self.tableView.descriptionText = @"";
    self.tableView.buttonNormalColor = [UIColor colorWithHexString:@"7e879d"];
    self.tableView.loadedImageName = imageName;
    self.tableView.loading = NO;
    
    [self.tableView gzwLoading:^{
        if (completionBlock) {
            completionBlock();
        }
    }];
}

- (void)setRemindreImageName:(NSString *)imageName text:(NSString *)text offsetY:(CGFloat)offsetY completion:(void(^)())completionBlock
{
    self.tableView.loading = YES;
    self.tableView.dataVerticalOffset = offsetY;
    self.tableView.buttonText = text;
    self.tableView.descriptionText = @"";
    self.tableView.buttonNormalColor = [UIColor colorWithHexString:@"7e879d"];
    self.tableView.loadedImageName = imageName;
    self.tableView.loading = NO;
    
    [self.tableView gzwLoading:^{
        if (completionBlock) {
            completionBlock();
        }
    }];
}

@end
