//
//  WKGoodsCollectionView.m
//  秀加加
//
//  Created by sks on 2016/10/13.
//  Copyright © 2016年 walkingtec. All rights reserved.
//

#import "WKGoodsCollectionView.h"
#import "WKHorizontalList.h"
#import "WKGoodsModel.h"
#import "WKAuctionPopView.h"
#import "WKAuctionStatusModel.h"
#import "WKAuctionStatusView.h"
#import "WKLiveRecordingView.h"
#import "PlayerManager.h"
#import "UIScrollView+PSRefresh.h"

#define WKCollectionViewHeight WKScreenW * 0.7 * 1.26

@interface WKGoodsCollectionView () <UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>
@property (nonatomic,strong) UIButton *maskBtn;
@property (nonatomic,strong) UICollectionView *collectionView;
@property (strong, nonatomic) NSDictionary * voiceDic;

@property (nonatomic,assign) WKGoodsLayoutType screenType;
@property (nonatomic,assign) WKGoodsType       goodsType;
@property (nonatomic,strong) NSMutableArray *dataArray;

@property (nonatomic,copy) void(^operation)(id);

@property (nonatomic,assign) WKClientType clientType;

@property (nonatomic,copy) NSNumber *currIdx;   // 当前页 1
@property (nonatomic,strong) NSMutableDictionary *parameters; // 请求参数

@end

static WKGoodsCollectionView *goodsView = nil;

static NSString *reusableCell = @"cell";

@implementation WKGoodsCollectionView

- (instancetype)init{
    if (self = [super init]) {
        self.dataArray = @[].mutableCopy;
    }
    return self;
}

+ (void)showGoodsListOn:(UIView *)view WithScreenType:(WKGoodsLayoutType)type goodsType:(WKGoodsType)goodsType requestParameters:(NSDictionary *)dict clientType:(WKClientType)clientType selectedBlock:(void (^)(id obj))block{
    
    if (goodsView != nil) {
        [goodsView dismissView:goodsView.maskBtn];
    }
    
    if (goodsView == nil) {
        
        @synchronized (self) {
            
            WKHorizontalList *layout = [[WKHorizontalList alloc] init];
            goodsView = [[self alloc] init];
            goodsView.frame = view.bounds;
//            layout.sectionInset = UIEdgeInsetsMake(10, 10, -20, 10);
//            goodsView.screenType = type;
            [view addSubview:goodsView];
            
            UIButton *maskBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            maskBtn.backgroundColor = [UIColor clearColor];
            maskBtn.frame = view.bounds;
            [maskBtn addTarget:goodsView action:@selector(dismissView:) forControlEvents:UIControlEventTouchUpInside];
            [goodsView addSubview:maskBtn];
            goodsView.maskBtn = maskBtn;
            UIPanGestureRecognizer *panGR = [[UIPanGestureRecognizer alloc]init];
            [maskBtn addGestureRecognizer:panGR];
            [goodsView addGestureRecognizer:panGR];
            
//            CGFloat scale;
            CGRect frame = CGRectMake(0, WKScreenH, WKScreenW, WKScreenW * 0.7 * 1.26 + 10);
            layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;

//            if (type == WKGoodsLayoutTypeVertical) {
//                frame =
////                scale = 0.3;
//            }
//            else{
//                scale = 0.382;
//                layout.scrollDirection = UICollectionViewScrollDirectionVertical;
//                frame = CGRectMake(WKScreenW, 0, WKScreenW * scale, WKScreenH);
//            }
            
            goodsView.screenType = type;
            goodsView.goodsType = goodsType;
            goodsView.clientType = clientType;
    
            goodsView.collectionView = [[UICollectionView alloc] initWithFrame:frame collectionViewLayout:layout];
            goodsView.collectionView.backgroundColor = [UIColor clearColor];
            goodsView.collectionView.delegate = goodsView;
            goodsView.collectionView.dataSource = goodsView;
            [goodsView.collectionView registerClass:[WKGoodsHorCollectionViewCell class] forCellWithReuseIdentifier:reusableCell];
            goodsView.collectionView.showsVerticalScrollIndicator = NO;
            goodsView.collectionView.showsHorizontalScrollIndicator = NO;
            [goodsView addSubview:goodsView.collectionView];
            
//            if (type == WKGoodsLayoutTypeHoriztal) {
//                [UIView animateWithDuration:0.3 animations:^{
//                    goodsView.collectionView.frame = CGRectMake(WKScreenW - WKScreenW * scale, 0, WKScreenW * scale, WKScreenH);
//                }];
//                
//                MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
//                    goodsView.currIdx = @1;
//                    [goodsView.parameters setValue:goodsView.currIdx forKey:@"PageIndex"];
//                    [goodsView loadDataListWith:goodsView.parameters];
//                }];
//                
//                MJRefreshBackNormalFooter *footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
//                    goodsView.currIdx = [NSNumber numberWithInteger:goodsView.currIdx.integerValue + 1];
//                    [goodsView.parameters setValue:goodsView.currIdx forKey:@"PageIndex"];
//                    [goodsView loadDataListWith:goodsView.parameters];
//                }];
//                
//                header.stateLabel.textColor = [UIColor darkGrayColor];
//                footer.stateLabel.textColor = [UIColor darkGrayColor];
//                
//                goodsView.collectionView.mj_header = header;
//                goodsView.collectionView.mj_footer = footer;
//                
//            }
            if (type == WKGoodsLayoutTypeVertical){
                
                [goodsView.collectionView addRefreshHeaderWithClosure:^{
                    
                    goodsView.currIdx = @1;
                    [goodsView.parameters setValue:goodsView.currIdx forKey:@"PageIndex"];
                    [goodsView loadDataListWith:goodsView.parameters];
                    
                } addRefreshFooterWithClosure:^{
                    goodsView.currIdx = [NSNumber numberWithInteger:goodsView.currIdx.integerValue + 1];
                    [goodsView.parameters setValue:goodsView.currIdx forKey:@"PageIndex"];
                    [goodsView loadDataListWith:goodsView.parameters];
                }];
                
                [UIView animateWithDuration:0.3 animations:^{
                    goodsView.collectionView.frame = CGRectMake(0, WKScreenH - WKCollectionViewHeight, WKScreenW, WKCollectionViewHeight);
                }];
                
                goodsView.collectionView.refreshHeaderTextColor = [UIColor lightGrayColor];
                goodsView.collectionView.refreshFooterTextColor = [UIColor lightGrayColor];
                
            }
            
            // 加载数据
            [goodsView loadDataListWith:dict];
            
            if (block) {
                goodsView.operation = block;
            }
        }
    }
}

- (void)loadDataListWith:(NSDictionary *)parameters{
    
    [WKProgressHUD showLoadingGifText:@""];

    NSString *goodsList;
    
    if (goodsView.clientType == WKClientTypePushFlow) {
        goodsList = WKGoodsList; //主播端(临时备注)
    }else{
        goodsList = WKLiveGoodsList; //用户端
    }
    
    goodsView.parameters = parameters.mutableCopy;
    goodsView.currIdx = parameters[@"PageIndex"];
    
    [WKHttpRequest getGoodsList:HttpRequestMethodPost url:goodsList model:NSStringFromClass([WKGoodsListModel class]) param:parameters success:^(WKBaseResponse *response) {
        NSLog(@"response %@",response);
        
        [WKProgressHUD dismiss];
        WKGoodsListModel *md = response.Data;
        
        if (goodsView.currIdx.integerValue == 1) {
            [self.dataArray removeAllObjects];
            
            if (md.InnerList.count == 0) {
                // 没有商品或拍卖品;
                if (goodsView.goodsType != WKGoodsTypeAuction && goodsView.goodsType != WKGoodsTypeCrowd) {
                    [goodsView addNoDataReminder];
                }
            }
        }
        [self.dataArray addObjectsFromArray:md.InnerList];
        if (goodsView.screenType == WKGoodsLayoutTypeHoriztal) {
            [goodsView.collectionView.mj_header endRefreshing];
            [goodsView.collectionView.mj_footer endRefreshing];
            
            if (self.dataArray.count >= md.TotalPageCount.integerValue) {
                [goodsView.collectionView.mj_footer endRefreshingWithNoMoreData];
            }
        }else{
            if (md.InnerList.count < 10) {
                goodsView.collectionView.isLastPage = YES;
            }
            [goodsView.collectionView endRefreshing];
        }
        [goodsView.collectionView reloadData];
        
    } failure:^(WKBaseResponse *response) {
        [goodsView dismissView:goodsView.maskBtn];
        [WKPromptView showPromptView:response.ResultMessage];
    }];
}

- (void)addNoDataReminder{
    
    UIImageView *bgImageV = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"auction_bg"]];
    [goodsView.collectionView addSubview:bgImageV];
//    [goodsView insertSubview:bgImageV atIndex:0];
    
    [bgImageV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_offset(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
//    goodsView
    if ([goodsView.collectionView viewWithTag:101]) {
        return;
    }
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectZero];
    bgView.tag = 101;
    [goodsView.collectionView addSubview:bgView];

    UIImage *image = [UIImage imageNamed:@"zanwushangpin"];
    
    UIImageView *imageV = [[UIImageView alloc] initWithImage:image];
    [bgView addSubview:imageV];
    
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.text = @"亲还没有直播展示的商品呢!";
    titleLabel.font = [UIFont systemFontOfSize:14.0f];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.textColor = [UIColor lightGrayColor];
    [bgView addSubview:titleLabel];
    
    NSString *reminderStr;
    if (goodsView.clientType == WKClientTypePushFlow) {
        reminderStr = @"尽快去添加,可以让更多小伙伴\n看到你的宝贝哟!";
    }else{
        reminderStr = @"去其他地方看看吧";
    }
    UILabel *reminderLabel = [[UILabel alloc] init];
    reminderLabel.text = reminderStr;
    reminderLabel.numberOfLines = 0;
    reminderLabel.font = [UIFont systemFontOfSize:14.0f];
    reminderLabel.textAlignment = NSTextAlignmentCenter;
    reminderLabel.textColor = [UIColor lightGrayColor];
    [bgView addSubview:reminderLabel];
    
    [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(goodsView.collectionView);
        make.size.mas_equalTo(CGSizeMake(image.size.width + 180, image.size.height + 80));
    }];
    
    [imageV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(image.size);
        make.centerX.mas_equalTo(bgView);
        make.top.mas_equalTo(bgView.mas_top).offset(5);
    }];
    
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.and.left.mas_equalTo(bgView);
        make.top.mas_equalTo(imageV.mas_bottom).offset(10);
        make.height.mas_equalTo(@20);
    }];
    
    [reminderLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(titleLabel.mas_bottom).offset(0);
        make.right.and.left.mas_equalTo(bgView);
        make.height.mas_equalTo(@50);
    }];
    
    goodsView.collectionView.frame = CGRectMake(10, WKScreenH - WKScreenW * 0.45 - 10, WKScreenW - 20, WKScreenW * 0.45);

//    [UIView animateWithDuration:0.4 animations:^{
//    }];
    
//    [UIView animateWithDuration:0.2 animations:^{
//        goodsView.frame = CGRectMake(10, WKScreenH - WKScreenW * 0.45 - 10, WKScreenW - 20, WKScreenW * 0.45);
//    }];
}

#pragma mark - CollectionView Delegate / dataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{

    if (goodsView.goodsType == WKGoodsTypeAuction || goodsView.goodsType == WKGoodsTypeCrowd) {
        return goodsView.dataArray.count + 1;

    }
    return goodsView.dataArray.count;

}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if (goodsView.clientType == WKClientTypePushFlow) { // 推流端
        
        if (goodsView.goodsType == WKGoodsTypeSale) { // 商品
            WKGoodsListItem *item = self.dataArray[indexPath.item];
            if (item.IsRecommend) {
                [self deleteRecommendWith:item];
            }else{
                [self recommendWith:item];
            }
        }else{                                        // 拍卖品
            if (indexPath.item != 0) {
                WKGoodsListItem *md = self.dataArray[indexPath.item - 1];
                // 拍卖
                md.isSelected = !md.isSelected;
                
                [WKAuctionPopView showAuctionViewWithPrice:md.Price goodsType:goodsView.goodsType Completion:^(NSString *price, NSString *time) {
                    NSLog(@"price : %@ time : %@",price,time);
                    
                    NSString *timeStr = [time substringWithRange:NSMakeRange(0, 2)];
                    NSDictionary *parameters = @{
                                                 @"SaleType":@(goodsView.goodsType),
                                                 @"GoodsCode":md.GoodsCode,
                                                 @"GoodsName":md.GoodsName,
                                                 @"GoodsPic":md.PicUrl,
                                                 @"StartPrice":price,
                                                 @"Duration":timeStr
                                                 };
                    [self auctionGoods:parameters];
                }];

                [collectionView reloadData];
            }else{
                [[NSNotificationCenter defaultCenter]postNotificationName:@"startSalr" object:nil];
            }
        }
    }else{
        // 观看端 商品
        if (goodsView.operation) {
            WKGoodsListItem *item = self.dataArray[indexPath.item];
            goodsView.operation(item);
        }
    }
}
-(void)uploadVoice{
    NSData *data = [NSData dataWithContentsOfFile:self.voiceDic[@"filePath"]];
    [WKHttpRequest uploadImages:HttpRequestMethodPost url:WKUploadImage fileArr:@[data] success:^(WKBaseResponse *response) {
        [WKAuctionPopView showAuctionViewWithPrice:@(1) goodsType:goodsView.goodsType Completion:^(NSString *price, NSString *time) {
            NSString *timeStr = [time substringWithRange:NSMakeRange(0, 2)];
            NSDictionary *parameters = @{
                                         @"SaleType":@(goodsView.goodsType),
                                         @"GoodsCode":@"0",
                                         @"GoodsName":@"",
                                         @"GoodsPic":response.Data[0],
                                         @"StartPrice":price,
                                         @"Duration":timeStr,
                                         @"VoiceDuration":self.voiceDic[@"timeLong"]
                                         };
            [self auctionGoods:parameters];
        }];
    } failure:^(WKBaseResponse *response) {
        
    }];
}

- (void)auctionGoods:(NSDictionary *)parameters{
    
    [WKProgressHUD showLoadingGifText:@""];
    
    [WKHttpRequest auctionGoods:HttpRequestMethodPost url:WKSpecialSale param:parameters model:NSStringFromClass([WKAuctionStatusModel class]) success:^(WKBaseResponse *response) {
        NSLog(@"json : %@",response.json);
        
        [WKProgressHUD dismiss];
//        WKAuctionStatusModel *md = response.Data;
        
        [goodsView dismissView:goodsView.maskBtn];
        
//        [WKAuctionStatusView showWithModel:response.Data screenOrientation:goodsView.screenType clientType:WKAuctionTypePushFlow completionBlock:^{
//            if (md.Status.integerValue == 0) {
//                goodsView.operation(md);
//            }
//        }];
        
    } failure:^(WKBaseResponse *response) {
        [WKPromptView showPromptView:response.ResultMessage];
    }];
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    WKGoodsHorCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reusableCell forIndexPath:indexPath];
    WeakSelf(WKGoodsCollectionView);
    if (goodsView.goodsType == WKGoodsTypeSale) {
        // 商品
        WKGoodsListItem *md = goodsView.dataArray[indexPath.item];
        [cell setModel:md type:goodsView.screenType clientType:goodsView.clientType];
    }else{
        // 拍卖品
        if (indexPath.item == 0) {
            for (int i = 0 ; i < [cell.contentView.subviews count]; i++) {
                UIView *view = [cell.contentView.subviews objectAtIndex:i];
                view.hidden = YES;
            }
            cell.recordView.hidden = NO;
            if (goodsView.screenType == WKGoodsLayoutTypeHoriztal) {
                [cell.recordView refreshLayoutWityHorizontal];
            }
            cell.recordView.type = goodsView.goodsType;
            cell.recordView.startSaleBlock = ^(NSString *timeLong,NSString *filePath){
                //开始拍卖回调
                weakSelf.voiceDic = @{@"timeLong":timeLong,@"filePath":filePath};
                [weakSelf uploadVoice];
            };
        }else{
            for (int i = 0 ; i < [cell.contentView.subviews count]; i++) {
                UIView *view = [cell.contentView.subviews objectAtIndex:i];
                view.hidden = NO;
            }
            cell.recordView.hidden = YES;
            [cell setModel:goodsView.dataArray[indexPath.item-1] type:goodsView.screenType clientType:goodsView.clientType];
        }
    }
    
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    if (goodsView.screenType == WKGoodsLayoutTypeHoriztal) {
        return CGSizeMake(WKScreenW * 0.382 - 10,  WKScreenH/4 + 10);
    }else{
        return CGSizeMake(WKScreenW * 0.7,  WKScreenW * 0.7 * 1.26 - 10);
    }
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsMake(10, 10, 20, 10);
}

- (void)dismissView:(UIButton *)btn{
//    [[PlayerManager sharedManager] stopPlaying];
    
    if (goodsView.screenType == WKGoodsLayoutTypeHoriztal) {
        [UIView animateWithDuration:0.2 animations:^{
            goodsView.collectionView.frame = CGRectMake(WKScreenW, 0, WKScreenW * 0.382, WKScreenH);
        }];
    }else{
        [UIView animateWithDuration:0.2 animations:^{
            goodsView.collectionView.frame = CGRectMake(0, WKScreenH, WKScreenW, 0);
        }];
    }
    
    [UIView animateWithDuration:0.2 animations:^{
        goodsView.alpha = 0.0;

    } completion:^(BOOL finished) {
        [goodsView removeFromSuperview];
        goodsView.operation = nil;
        goodsView.maskBtn = nil;
        goodsView = nil;
    }];
}

// MARK: 推荐和取消推荐
- (void)deleteRecommendWith:(WKGoodsListItem *)goodsId{
    
    NSString *url = [NSString configUrl:WKGoodsDeleteRecommend With:@[@"goodsCode"] values:@[[NSString stringWithFormat:@"%@",goodsId.GoodsCode]]];
    [WKHttpRequest deleteRecommendGoods:HttpRequestMethodGet url:url param:@{} success:^(WKBaseResponse *response) {
//        goodsId.IsRecommend = NO;
        [goodsView loadDataListWith:goodsView.parameters];
        
    } failure:^(WKBaseResponse *response) {
        
    }];
}

- (void)recommendWith:(WKGoodsListItem *)md{
    
    NSString *url = [NSString configUrl:WKGoodsRecomend With:@[@"goodsCode"] values:@[[NSString stringWithFormat:@"%@",md.GoodsCode]]];
    
    [WKHttpRequest recommendGoods:HttpRequestMethodGet url:url param:@{} success:^(WKBaseResponse *response) {
//        for (WKGoodsListItem *item in goodsView.dataArray) {
//            item.IsRecommend = NO;
//            
//            if ([item.GoodsCode isEqualToNumber:md.GoodsCode]) {
//                item.IsRecommend = YES;
//            }
//        }
        [goodsView loadDataListWith:goodsView.parameters];
        
        
//        [goodsView.collectionView reloadData];
    } failure:^(WKBaseResponse *response) {
        
    }];
    
}

+ (void)dismiss{
    if (goodsView != nil) {
        [goodsView dismissView:goodsView.maskBtn];
    }

}

- (void)dealloc{
    NSLog(@"释放的商品的弹窗");
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
