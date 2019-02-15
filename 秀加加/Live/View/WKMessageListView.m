//
//  WKMessageListView.m
//  秀加加
//
//  Created by sks on 2016/10/20.
//  Copyright © 2016年 walkingtec. All rights reserved.
//

#import "WKMessageListView.h"
#import "WKChatCell.h"
#import "WKMessage.h"
#import "WKUserMessage.h"
#import "NSObject+XWAdd.h"

static NSString *cellID = @"cellId";

const NSUInteger seenTime = 3;

@interface WKMessageListView () <UITableViewDelegate,UITableViewDataSource,WKChatDelegate>{
    BOOL _isScrollDirectTop;
    NSTimer *_timer;
    NSUInteger _countTime;
    CGPoint _lastContentOffset;
}

@property (nonatomic,strong) UITableView *messageList;
@property (nonatomic,strong) NSMutableArray *dataArray;

@end

@implementation WKMessageListView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        // 聊天列表
        _isScrollDirectTop = NO;
        
        _countTime = seenTime;
        
        UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        tableView.delegate = self;
        tableView.dataSource = self;
        tableView.showsVerticalScrollIndicator = NO;
        tableView.showsHorizontalScrollIndicator = NO;
        tableView.backgroundColor = [UIColor clearColor];
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [self addSubview:tableView];
        [tableView registerClass:[WKChatCell class] forCellReuseIdentifier:cellID];
        
        [tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_offset(UIEdgeInsetsMake(0, 0, 0, 0));
        }];

        self.messageList = tableView;
        self.messageList = tableView;
        self.dataArray = @[].mutableCopy;
    }
    return self;
}

#pragma mark - UITableView delegate/DataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.01f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.01;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    WKMessage *message = self.dataArray[indexPath.row];
    return message.cellHeight;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    WKChatCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    [cell setMessage:self.dataArray[indexPath.row]];
    cell.delegate = self;
    return cell;
}

- (void)chatClick:(id)cell type:(WKMessageClickType)type{
    WKChatCell *clkCell = cell;
    NSIndexPath *indexPath = [self.messageList indexPathForCell:clkCell];
    WKMessage *message = self.dataArray[indexPath.row];
    if (message.bpoid) {
        if ([_delegate respondsToSelector:@selector(selectedMessage:type:)]) {
            [_delegate selectedMessage:message type:type];
        }
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    CGPoint translation = [scrollView.panGestureRecognizer translationInView:scrollView.superview];
    
    if (translation.y > 0) {
        // 上滑动
        if (_timer) {
            [_timer invalidate];
            _timer = nil;
            _countTime = seenTime;
        }
        
        _timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(seenToStopScroll:) userInfo:nil repeats:YES];
        [[NSRunLoop currentRunLoop] addTimer:_timer forMode:NSRunLoopCommonModes];
        
    }else{
        _isScrollDirectTop = NO;
    }
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    _isScrollDirectTop = YES;
    _lastContentOffset = scrollView.contentOffset;
}

- (void)seenToStopScroll:(NSTimer *)timer{
    
    if (_countTime <= seenTime) {
        _isScrollDirectTop = NO;
        
        [_timer invalidate];
        _timer = nil;
    }else{
        _isScrollDirectTop = YES;
    }
    
    _countTime--;

}

// 插入聊天消息
- (void)insertMessageWith:(id)message{
    
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(1);
    
    dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
    [self.dataArray addObject:message];
    dispatch_semaphore_signal(semaphore);
    
    [self.messageList reloadData];

    if (!_isScrollDirectTop) {
        
        [self.messageList scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:self.dataArray.count-1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
        
        [self.messageList setScrollsToTop:YES];
    }
    
}

-(void)dealloc{
    [_timer invalidate];
}
@end
