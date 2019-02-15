//
//  WKGoodsListView.m
//  秀加加
//
//  Created by sks on 2016/9/13.
//  Copyright © 2016年 walkingtec. All rights reserved.
//

#import "WKGoodsListView.h"
#import "WKGoodsModel.h"
#import "WKGoodsListTableViewCell.h"
#import "WKAuctionTableViewCell.h"
#import "WKAddGoodsViewController.h"
#import "WKGoodsItemProtocol.h"
#import "WKShareView.h"
#import "WKShowInputView.h"
#import "WKGoodsVC.h"

static NSString *cellId = @"cellId";

@interface WKGoodsListView () <WKGoodsItemProtocol>  {
    WKGoodsType _type;
}
@end

@implementation WKGoodsListView

- (instancetype)initWithFrame:(CGRect)frame with:(WKGoodsType)type{
    if (self = [super initWithFrame:frame]) {
        _type = type;
        self.isOpenHeaderRefresh = YES;
        self.isOpenFooterRefresh = YES;
        self.tableView.showsVerticalScrollIndicator = NO;
          }
    return self;
}

#pragma mark - UITableView delegate/DataSouce
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (_type == WKGoodsTypeSale) {
        //普通商品
        WKGoodsListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
        if (!cell) {
            cell = [[WKGoodsListTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
        }
        cell.delegate = self;
        [cell setModel:self.dataArray[indexPath.row]];
        return cell;
    }else{
        //拍卖商品
        WKAuctionTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
        if (!cell) {
            cell = [[WKAuctionTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
        }
        cell.delegate = self;
        [cell setModel:self.dataArray[indexPath.row]];
        return cell;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 130;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.selectedIndex)
    {
        self.selectedIndex(indexPath.row);
    }
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete)
    {
        [self deleteGoodsWith:indexPath];
    }
}

//MARK: 操作商品
- (void)operateGoods:(WKOperateType)type obj:(WKGoodsListItem *)model{
    
    //如果已经是下架状态，且不是上架操作，不进行任何操作
    if(!model.IsMarketable && type != WKOperateTypeUp)
    {
        return;
    }
    
    //分享操作
    if (type == WKOperateTypeShare)
    {
        WKShareModel *shareModel = [[WKShareModel alloc]init];
        shareModel.shareImageArr = @[[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:model.PicUrl]]]];
        shareModel.shareTitle = @"秀加加,让直播更有价值!";
        NSString *shareContent;
        if (_type == WKGoodsTypeAuction) {
            shareContent = [NSString stringWithFormat:@"%@正在拍卖，赶紧来围观吧！",model.GoodsName];
        }else{
            shareContent = [NSString stringWithFormat:@"%@向您推荐了一款商品%@，快来看看吧！",User.MemberName,model.GoodsName];
        }
        shareModel.shareContent = shareContent;
        NSString *str = shareGoodsUrl(User.MemberID,User.BPOID,model.GoodsCode);
        shareModel.shareUrl = str;
        [WKShareView shareViewWithModel:shareModel];
    }
    else
    {
        NSString *Msg = @"";
        if(type == WKOperateTypeUp)
        {
            Msg = @"是否确认上架商品？";
        }
        else if(type==WKOperateTypeDown)
        {
            Msg = @"是否确认下架商品？";
        }
        
        if(![Msg isEqualToString:@""])
        {
            [WKShowInputView showInputWithPlaceString:Msg type:LABELTYPE andBlock:^(NSString * Count) {
                [self operateWith:type goods:model];
            }];
        }
        else
        {
            [self operateWith:type goods:model];
        }
    }
}
-(void)createPromptView{
    self.promptView = [[UIView alloc]initWithFrame:CGRectMake(0, 32,WKScreenW,40)];
    self.promptView.backgroundColor = [UIColor clearColor];
    self.promptLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 0, WKScreenW-40, 40)];
    self.promptLabel.font = [UIFont systemFontOfSize:14];
    self.promptLabel.textColor = [UIColor whiteColor];
    self.promptLabel.textAlignment = NSTextAlignmentCenter;
    [self.promptView addSubview:self.promptLabel];
    [self addSubview:self.promptView];
}

-(void)promptViewShow:(NSString *)message{
    self.promptLabel.text = message;
    [UIView animateWithDuration:0.3 animations:^{
        self.promptView.frame = CGRectMake(0, 32,WKScreenW,40);
        self.promptView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
    } completion:^(BOOL finished) {
        dispatch_time_t time = dispatch_time(DISPATCH_TIME_NOW, 1.5 *NSEC_PER_SEC);
        dispatch_after(time, dispatch_get_main_queue(), ^{
            [UIView animateWithDuration:0.3 animations:^{
                self.promptView.frame = CGRectMake(0, 0,WKScreenW,40);
                self.promptView.backgroundColor = [UIColor clearColor];
                self.promptLabel.text=@"";
                            }];
        });
    }];
}


//MARK: 删除商品
- (void)deleteGoodsWith:(NSIndexPath *)index{
    WKGoodsListItem *item = self.dataArray[index.row];
    NSString *url = [NSString configUrl:WKGoodsDelete With:@[@"goodsID"] values:@[item.ID]];
    [WKHttpRequest goodsBatch:HttpRequestMethodPost url:url param:@{} success:^(WKBaseResponse *response) {
        [self.dataArray removeObject:item];
        if(self.dataArray.count == 0)
        {
            [self headerRequestWithData];
        }
        [self.tableView reloadData];
    } failure:^(WKBaseResponse *response) {
        
    }];
}

- (void)operateWith:(WKOperateType)type goods:(WKGoodsListItem *)goods{
    NSString *url;
    NSInteger index = [self.dataArray indexOfObject:goods];
    NSDictionary *dict;
    
    if (type == WKOperateTypeTop)
    {
        url = [NSString configUrl:WKGoodsTop With:@[@"goodsID"] values:@[goods.ID]];
        [WKHttpRequest goodsTop:HttpRequestMethodGet url:url param:@{} success:^(WKBaseResponse *response)
        {
            [self.dataArray removeObjectAtIndex:index];
            [self.dataArray insertObject:goods atIndex:0];
            
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:index inSection:0];
            
            [self.tableView moveRowAtIndexPath:indexPath toIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
            
            [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:YES];
            
            [self createPromptView];
            [self promptViewShow:@"置顶成功,商品已放置商店第一位"];
        } failure:^(WKBaseResponse *response) {
            
        }];
        
    }else if (type == WKOperateTypeUp){
        url = WKGoodsBatchUp;
        dict = @{@"GoodsCodes":[@[goods.GoodsCode] yy_modelToJSONString]};
        [WKHttpRequest goodsBatch:HttpRequestMethodPost url:url param:dict success:^(WKBaseResponse *response) {
            
            goods.IsMarketable = !goods.IsMarketable;
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:index inSection:0];
            WKGoodsListTableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
            [cell setModel:goods];
            
        } failure:^(WKBaseResponse *response) {
            
        }];
        
    }else if (type == WKOperateTypeDown){
        url = WKGoodsBatchDown;
        dict = @{@"GoodsCodes":[@[goods.GoodsCode] yy_modelToJSONString]};
        
        [WKHttpRequest goodsBatch:HttpRequestMethodPost url:url param:dict success:^(WKBaseResponse *response) {
            goods.IsMarketable = !goods.IsMarketable;
            
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:index inSection:0];
            WKGoodsListTableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
            
            [cell setModel:goods];
            
        } failure:^(WKBaseResponse *response) {
            
        }];
    }
    
}

- (void)downOrUpWith:(NSString *)url parameter:(NSDictionary *)dict{
    
}

- (void)headerRequestWithData{
    self.pageNO = 1;
    if (self.requestBlock) {
        self.requestBlock();
    }
}

- (void)footerRequestWithData{
    //self.pageNO += 1;
    self.pageSize = 10;
    if (self.requestBlock) {
        self.requestBlock();
    }
}
@end
