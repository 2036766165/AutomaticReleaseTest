 //
//  WKOnlinePersonListView.m
//  秀加加
//
//  Created by sks on 2016/10/20.
//  Copyright © 2016年 walkingtec. All rights reserved.
//

#import "WKOnlinePersonListView.h"
//#import "HorizontalTableView.h"
#import "WKOnlinePerson.h"
#import "WKOnLineMd.h"
#import "WKButton.h"

static NSString *cellId = @"cellId";

@interface WKOnlinePersonListView () <UICollectionViewDelegate,UICollectionViewDataSource>{
    NSInteger _totalAudience;
}

@property (nonatomic,strong) UICollectionView *onlineListView;   // 在线人数列表
@property (nonatomic,strong) NSMutableArray *allAudience;           // 在线人数

@property (nonatomic,copy) void(^block)();

@end

static NSString *cellID = @"cellID";

@implementation WKOnlinePersonListView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        layout.itemSize = CGSizeMake(30, 30);
        layout.sectionInset = UIEdgeInsetsMake(2, 2, 2, 2);
        
        self.onlineListView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        self.onlineListView.dataSource = self;
        self.onlineListView.delegate = self;
        
        self.onlineListView.backgroundColor = [UIColor clearColor];
        self.onlineListView.showsVerticalScrollIndicator = NO;
        self.onlineListView.showsHorizontalScrollIndicator = NO;
        [self addSubview:self.onlineListView];
        
        [self.onlineListView registerClass:[WKOnlinePerson class] forCellWithReuseIdentifier:cellID];
        
        [self.onlineListView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_offset(UIEdgeInsetsMake(0, 0, 0, 0));
        }];
        
        self.allAudience = @[].mutableCopy;
        
        _totalAudience = 0;
        
//        self.audience_queue = dispatch_queue_create("cn.walkingtec.wdboshow.audience", DISPATCH_QUEUE_SERIAL);
    }
    
    return self;
}

- (void)operateAPerson:(id)result operateType:(WKOperateType)type totalCount:(NSUInteger)totalCount completionBlock:(void(^)())block;
{
    _totalAudience = totalCount;
    if (block) {
        self.block = block;
    }
    
    switch (type) {
        case WKOperateTypeGetList:
            [self setOnlineUsers:result];
            break;
            
        case WKOperateTypeOnline:
            [self addUsers:result];
            break;
            
        case WKOperateTypeOffline:
            [self removeUsers:result];
            break;
            
        default:
            break;
    }
    
}

#pragma mark - 用户上线
- (void)addUsers:(WKOnLineMd *)onlineUser{
    
    for (WKOnLineMd *md in self.allAudience) {
        if ([md.BPOID isEqualToString:onlineUser.BPOID]) {
            return;
        }
    }
    if (onlineUser.idx <= self.allAudience.count) {
        [self.allAudience insertObject:onlineUser atIndex:onlineUser.idx];
    }else{
        [self.allAudience addObject:onlineUser];
    }
    [self updateState];
}

- (void)setOnlineUsers:(NSArray *)users{
    [self.allAudience removeAllObjects];
    [self.allAudience addObjectsFromArray:users];
    [self updateState];
}

#pragma mark - 用户下线
- (void)removeUsers:(WKOnLineMd *)offlineUser{
    if (offlineUser.idx >= self.allAudience.count) {
        [self.allAudience removeLastObject];
    }else{
        [self.allAudience removeObjectAtIndex:offlineUser.idx];
    }
    [self updateState];
}

- (void)updateState{
    if (_totalAudience > 20) {
        // insert add icon
        for (WKOnLineMd *md in self.allAudience) {
            if (md.isAddItem) {
                md.totalPerson = _totalAudience;
                [self.onlineListView reloadData];
                return;
            }
        }
        
        WKOnLineMd *addMd = [[WKOnLineMd alloc] init];
        addMd.isAddItem = YES;
        addMd.totalPerson = _totalAudience;
        [self.allAudience addObject:addMd];
    }
    
    if (self.block) {
        self.block(self.allAudience.count,_totalAudience);
    }
    
    [self.onlineListView reloadData];

    //dispatch_async(dispatch_get_main_queue(), ^{
    //});
    
}

#pragma mark - horitable
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.allAudience.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    WKOnlinePerson *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellID forIndexPath:indexPath];
    [cell setPerson:self.allAudience[indexPath.row]];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    if ([_delegate respondsToSelector:@selector(selectedPerson:)]) {
        [_delegate selectedPerson:self.allAudience[indexPath.row]];
    }
}

//- (NSInteger)numberOfRowsWithHorizontalTableView:(HorizontalTableView *)horizontalTableView{
//    return self.allAudience.count;
//}
//
//- (CGFloat)horizontalTableView:(HorizontalTableView *)horizontalTableView widthForRow:(NSInteger)row{
//    return 40.0f;
//}
//
//- (HorizontalTableViewCell *)horizontalTableView:(HorizontalTableView *)horizontalTableView cellForRow:(NSInteger)row{
//    WKOnlinePerson *cell = [horizontalTableView dequeueReusableCellWithIdentifier:cellID];
//    if (!cell) {
//        cell = [[WKOnlinePerson alloc] initWithReuseIdentifier:cellID];
//    }
//    
//    [cell setPerson:self.allAudience[row]];
//    return cell;
//}
//
//- (void)horizontalTableView:(HorizontalTableView *)horizontalTableView didSelectedIndex:(NSInteger)selectedIndex{
//    if ([_delegate respondsToSelector:@selector(selectedPerson:)]) {
//        [_delegate selectedPerson:self.allAudience[selectedIndex]];
//    }
////}

- (void)setItemStateWithBPOID:(NSString *)bpoid type:(NSInteger)type{
    for (int i=0; i<self.allAudience.count; i++) {
        WKOnLineMd *person = self.allAudience[i];
        
        if ([person.BPOID isEqualToString:bpoid]) {
            person.BanType = @(type);
            [self.onlineListView reloadData];
        }
    }
}

//- (void)updateAudience{
//    dispatch_async(dispatch_get_main_queue(), ^{
//        [self.onlineListView reloadData];
//        //_onLineLabel.text = [NSString stringWithFormat:@"在线%ld",(long)(_allOnlineUsers.count)];
//    });
//}

@end
