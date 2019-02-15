//
//  WKMessageBookTableView.m
//  秀加加
//
//  Created by lin on 2016/9/20.
//  Copyright © 2016年 walkingtec. All rights reserved.
//

#import "WKMessageBookTableView.h"
#import "WKHistoryTableViewCell.h"
#import "UIImage+Gif.h"

@implementation WKMessageBookTableView

-(instancetype)initWithFrame:(CGRect)frame
{
    if (self =[super initWithFrame:frame])
    {
        self.isOpenHeaderRefresh = NO;
        self.isOpenFooterRefresh = NO;
        self.tableView.showsVerticalScrollIndicator = NO;
        [self.tableView initWithFrame:frame style:UITableViewStyleGrouped];
    }
    [self initData];
    return self;
}

-(void)initData
{
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *cellIdentifier = @"cell";
    WKHistoryTableViewCell  *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if(!cell)
    {
        cell = [[WKHistoryTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    cell.item = self.dataArray[indexPath.row];
    NSString *path = [[NSBundle mainBundle] pathForResource:@"video" ofType:@"gif"];
    UIImage *image = [UIImage animatedImageWithAnimatedGIFURL:[NSURL fileURLWithPath:path]];
    cell.share.image = image;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_selectClickType) {
        _selectClickType(indexPath.row);
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 65;
}


- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

//- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    if (editingStyle == UITableViewCellEditingStyleDelete)
//    {
//        
//        
//    }
//}

@end
