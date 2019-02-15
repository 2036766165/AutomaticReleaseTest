//
//  WKLiveTableView.m
//  wdbo
//
//  Created by lin on 16/6/30.
//  Copyright © 2016年 Walkingtec. All rights reserved.
//

#import "WKLiveTableView.h"
#import "WKLiveTableViewCell.h"
#import "WKLiveMessageTableViewCell.h"
#import "UITableView+Gzw.h"

@interface WKLiveTableView()

@property (nonatomic,assign) NSInteger typeNum;

@end

@implementation WKLiveTableView

-(instancetype)initWithFrame:(CGRect)frame
{
    if (self =[super initWithFrame:frame])
    {
        self.isOpenHeaderRefresh = NO;
        self.isOpenFooterRefresh = NO;
        self.tableView.showsVerticalScrollIndicator = NO;
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return self;
}

-(void)setType:(NSInteger)type
{
    self.typeNum = type;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (self.typeNum == 2) {
        return self.dataArray.count;
    }
    return 10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
//    WeakSelf(WKLiveTableView);
    if(self.typeNum == 1)
    {
        NSString *cellIdentifier = @"cell";
        WKLiveTableViewCell  *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if(!cell)
        {
            cell = [[WKLiveTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    else if(self.typeNum == 2)
    {
        NSString *cellIdentifier = @"livecell";
        WKLiveMessageTableViewCell  *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if(!cell)
        {
            cell = [[WKLiveMessageTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        for (WKListNoticeInfo *item in self.dataArray) {
//            NSLog(@"%@",item.NoticeType);
        }
        cell.model = self.dataArray[indexPath.section];
        return cell;
    }
    return nil;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(self.typeNum == 1)
    {
        return 120;
    }
    else if(self.typeNum == 2)
    {
        return 80;
    }
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 10;
}


#pragma mark -- refreshing
- (void)headerRequestWithData
{
    if (self.requestBlock) {
        self.requestBlock();
    }
}

- (void)footerRequestWithData
{
    if (self.requestBlock) {
        self.requestBlock();
    }
}


@end
