//
//  WKLiveShopHorTableView.m
//  秀加加
//
//  Created by lin on 2016/10/18.
//  Copyright © 2016年 walkingtec. All rights reserved.
//

#import "WKLiveShopHorTableView.h"
#import "WKLiveShopDetailTableViewCell.h"
#import "WKLiveShopEvaluateTableViewCell.h"

@implementation WKLiveShopHorTableView

-(instancetype)initWithFrame:(CGRect)frame
{
    if (self =[super initWithFrame:frame])
    {
        self.isOpenHeaderRefresh = YES;
        self.isOpenFooterRefresh = YES;
        self.tableView.showsVerticalScrollIndicator = NO;
        self.commentArray = @[].mutableCopy;
//        [self.tableView initWithFrame:frame style:UITableViewStylePlain];
    }
    return self;
}

//-(void)setShopCommentModel:(WKLiveShopCommentModel *)shopCommentModel
//{
//    _shopCommentModel = shopCommentModel;
//}
//
//-(void)setLiveshopListModel:(WKLiveShopListModel *)liveshopListModel
//{
//    _liveshopListModel = liveshopListModel;
//}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
//    if(section == 0)
//    {
//        return 2;//self.dataArray.count;
//    }
//    else if(section == 1)
//    {
//        if(self.shopCommentModel.InnerList.count > 0)
//        {
//            return self.shopCommentModel.InnerList.count;
//        }
//        else
//        {
//            return 0;
//        }
//    }
    return 20;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
//    if(indexPath.section == 0)
//    {
//        NSString *cellIdentifier = @"liveShopCell";
//        WKLiveShopDetailTableViewCell  *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
//        if(!cell)
//        {
//            cell = [[WKLiveShopDetailTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
//        }
//        cell.selectionStyle = UITableViewCellSelectionStyleNone;
////        cell.item = self.dataArray[indexPath.row];
//        return cell;
//    }
//    else if(indexPath.section == 1)
//    {
//        NSString *cellIdentifier = @"liveShopEvaCell";
//        WKLiveShopEvaluateTableViewCell  *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
//        if(!cell)
//        {
//            cell = [[WKLiveShopEvaluateTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier item:self.shopCommentModel.InnerList[indexPath.row]];
//        }
//        cell.selectionStyle = UITableViewCellSelectionStyleNone;
//        return cell;
//    }
    UITableViewCell *cell = [[UITableViewCell alloc] init];
    cell.detailTextLabel.text = @"adadda";
    if(indexPath.row %2 == 1)
    {
        cell.backgroundColor = [UIColor redColor];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 15;
}

@end
