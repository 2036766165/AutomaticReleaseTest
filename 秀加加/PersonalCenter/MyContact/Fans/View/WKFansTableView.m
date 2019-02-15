//
//  WKFansTableView.m
//  秀加加
//
//  Created by lin on 16/9/6.
//  Copyright © 2016年 walkingtec. All rights reserved.
//

#import "WKFansTableView.h"

@implementation WKFansTableView

-(instancetype)initWithFrame:(CGRect)frame
{
    if (self =[super initWithFrame:frame])
    {
        self.isOpenHeaderRefresh = YES;
        self.isOpenFooterRefresh = YES;
        self.tableView.showsVerticalScrollIndicator = NO;
        [self.tableView initWithFrame:frame style:UITableViewStyleGrouped];
    }
    return self;
}

-(void)setModel:(WKAttentionModel *)model
{
    _model = model;
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
    WKFocusAndFansTableViewCell  *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if(!cell)
    {
        cell = [[WKFocusAndFansTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    
    WKAttentionItemModel *itemModel = self.dataArray[indexPath.row];
    if(itemModel.IsFollow == 1){
//      [cell.shareAnFocus setImage:[UIImage imageNamed:@"fensi"] forState:UIControlStateNormal] ;
    }
    else
    {
//        [cell.shareAnFocus setImage:[UIImage imageNamed:@"fensiweiguan"] forState:UIControlStateNormal] ;
    }
  
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [cell getItem:self.dataArray[indexPath.row] type:_type];

    cell.clickCallBack = ^(ClickType type)
    {
        _selectClickType(indexPath.row,type);
    };
    return cell;
}
//-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
//    return true;
//}

-(NSArray *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(nonnull NSIndexPath *)indexPath{
    WKAttentionItemModel *model = self.dataArray[indexPath.row];
    NSString *titleStr = @"";
    if (model.IsFollow) {
        titleStr = @"取消关注";
    }else{
        titleStr = @"关注";
    }
    UITableViewRowAction *action1 = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleNormal title:titleStr handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
        if (self.selectClickType) {
            if (model.IsFollow) {
                self.selectClickType(indexPath.row,ClickFocusNot);
            }else{
                self.selectClickType(indexPath.row,ClickFocus);
            }
        }
    }];
    if ([titleStr isEqualToString:@"关注"]) {
        action1.backgroundColor = [UIColor colorWithHexString:@"#FDB657"];
    }
    
    UITableViewRowAction *action2 = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDestructive title:@"私信"handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
        if (self.selectClickType) {
            self.selectClickType(indexPath.row,ClickMessage);
        }
    }];
    action2.backgroundColor = [UIColor orangeColor];

    return@[action2,action1];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(_selectClickType)
    {
        _selectClickType(indexPath.row,ClickLive);
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 65;
}

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
