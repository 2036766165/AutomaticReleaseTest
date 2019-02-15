//
//  WKLiveShopTableView.m
//  秀加加
//  标题：直播 商品详情 竖屏
//  Created by lin on 2016/10/11.
//  Copyright © 2016年 walkingtec. All rights reserved.
//

#import "WKLiveShopTableView.h"
#import "WKLiveShopDetailTableViewCell.h"
#import "NSString+Size.h"
#import "NSObject+XWAdd.h"
#import "WKAuctionStatusModel.h"
#import "PlayerManager.h"
#import "UIImage+Gif.h"
#import "WKPlayTool.h"

@interface WKLiveShopTableView() <UITableViewDelegate,UITableViewDataSource,PlayingDelegate>{
    WKLiveShopListModel *_goodsDetail;
    WKHomePlayModel *_playModel;
    WKAuctionStatusModel *_auctionModel;
    NSTimer *_timer;
    NSInteger _currPage;
    BOOL _showGoods;
}

@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) UIButton *timeBtn;
@property (nonatomic,assign) NSUInteger currentTimeCount;
@property (nonatomic,strong) NSMutableArray *lastButtonArray;
@end

@implementation WKLiveShopTableView

-(instancetype)initWithFrame:(CGRect)frame withGoodsDetail:(WKLiveShopListModel *)goodsDetail playModel:(WKHomePlayModel *)playModel auctionModel:(WKAuctionStatusModel *)auctionMd showGoods:(BOOL)showGoods
{
    if (self =[super initWithFrame:frame])
    {
        _showGoods = showGoods;
        
        UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height - 64) style:UITableViewStyleGrouped];
        tableView.delegate = self;
        tableView.dataSource = self;
        tableView.separatorStyle = UITableViewCellSelectionStyleNone;
        [self addSubview:tableView];
        [tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.mas_offset(0);
            make.size.sizeOffset(CGSizeMake(frame.size.width, frame.size.height - 64));
        }];
        
        UIPanGestureRecognizer *panGR = [[UIPanGestureRecognizer alloc]init];
        [self addGestureRecognizer:panGR];
        
        _currPage = 1;
        tableView.mj_footer = [MJRefreshBackFooter footerWithRefreshingBlock:^{
            _currPage += 1;
            [self loadData];
        }];
        
        self.tableView = tableView;
        
        self.commentArray = @[].mutableCopy;
        
        self.lastButtonArray = @[].mutableCopy;
        
        _goodsDetail = goodsDetail;

        _playModel = playModel;
        
        _auctionModel = auctionMd;
        
        UIView *tableHeaderView = [self setupTableViewHeader];
        
        self.tableView.tableHeaderView = tableHeaderView;
        
        [tableView reloadData];
        
        [self initData];
        
        [self loadData];

    }
    
    return self;
}

- (UIView *)setupTableViewHeader{
    
    //整个头部背景
    UIView *headView = [[UIView alloc] init];
    headView.backgroundColor = [UIColor colorWithHex:0xEEF2FC];
    
    // 商品属性
    UIView *goodsItemView = [UIView new];
    goodsItemView.backgroundColor = [UIColor whiteColor];
    [headView addSubview:goodsItemView];
    
    // 名字
    UILabel *nameLabel = [UILabel new];
    nameLabel.font = [UIFont systemFontOfSize:14.0f];
    nameLabel.textAlignment = NSTextAlignmentLeft;
    nameLabel.textColor = [UIColor darkGrayColor];
    nameLabel.text = _goodsDetail.GoodsName;
    nameLabel.numberOfLines = 0;
    [goodsItemView addSubview:nameLabel];
    
    // 商品描述
    CGFloat itemHeight = 0;
    if (_showGoods) {
        // 规格
        UILabel *modeLabel = [UILabel new];
        modeLabel.numberOfLines = 0;
        modeLabel.font = [UIFont systemFontOfSize:14.0f];
        modeLabel.textColor = [UIColor darkTextColor];
        [goodsItemView addSubview:modeLabel];
        
        // 价格
        UILabel *priceLabel = [UILabel new];
        priceLabel.font = [UIFont systemFontOfSize:14.0f];
        priceLabel.text = [NSString stringWithFormat:@"￥%@",_goodsDetail.Price];
        priceLabel.textColor = [UIColor colorWithHexString:@"#FC6620"];
        [goodsItemView addSubview:priceLabel];
        
        // 名字高度
        CGFloat nameHeight = [_goodsDetail.GoodsName sizeOfStringWithFont:[UIFont systemFontOfSize:16.0] withMaxSize:CGSizeMake(WKScreenH * 2/3 - 10, CGFLOAT_MAX)].height;
        
        // 规格高度
        if (_goodsDetail.GoodsModelList.count == 1) {
            WKLiveShopListModelItem *modeItem = _goodsDetail.GoodsModelList[0];
            
            if (modeItem.ModelName.length == 0) {
                modeLabel.hidden = YES;
            }
        }
        NSMutableArray *modesArr = @[].mutableCopy;
        for (int i=0; i<_goodsDetail.GoodsModelList.count; i++) {
            WKLiveShopListModelItem *modeItem = _goodsDetail.GoodsModelList[i];
            [modesArr addObject:modeItem.ModelName];
        }
        
        NSString *modes = [modesArr componentsJoinedByString:@"、"];
        NSString *modeDescr = [@"商品型号  " stringByAppendingString:modes];
        
        NSMutableAttributedString *attr = [[NSMutableAttributedString alloc] initWithString:modeDescr];
        [attr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:16] range:NSMakeRange(0, 2)];
        [attr addAttribute:NSForegroundColorAttributeName value:[UIColor blueColor] range:NSMakeRange(0, 2)];
        
        modeLabel.text = modeDescr;
        
        CGFloat modeHeight = [modeDescr sizeOfStringWithFont:[UIFont systemFontOfSize:14.0] withMaxSize:CGSizeMake(WKScreenH * 2/3 - 10, CGFLOAT_MAX)].height;
        
        if (modeHeight < WKScreenH/4 - nameHeight - 60 - 20) {
            modeHeight = WKScreenH/4 - nameHeight - 60 - 20;
        }
        
        itemHeight = nameHeight + modeHeight + 60;

        [goodsItemView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(5);
            make.left.mas_equalTo(0);
            make.size.mas_equalTo(CGSizeMake(WKScreenW, itemHeight));
        }];
        
        [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_offset(5);
            make.left.mas_offset(WKScreenW/3 + 5);
            make.size.mas_offset(CGSizeMake(WKScreenW * 2/3 - 10, nameHeight));
        }];
        
        [modeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(nameLabel.mas_bottom).offset(5);
            make.left.mas_offset(WKScreenW/3 + 5);
            make.size.mas_offset(CGSizeMake(WKScreenW * 2/3 - 10, modeHeight + 20));
        }];
        
        [priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.mas_equalTo(goodsItemView.mas_bottom).offset(0);
            make.left.mas_offset(WKScreenW/3 + 5);
            make.right.equalTo(goodsItemView.mas_right).offset(-100);
            make.height.mas_equalTo(30);
        }];
        
        // 店铺位置
        if (_playModel.ShopAuthenticationStatus.integerValue == 1) {
            UIButton *locationBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            [locationBtn setTitle:@"店铺位置" forState:UIControlStateNormal];
            [locationBtn setTitleColor:[UIColor darkTextColor] forState:UIControlStateNormal];
            locationBtn.titleLabel.font = [UIFont systemFontOfSize:14];
            [locationBtn setImage:[UIImage imageNamed:@"liveaddress"] forState:UIControlStateNormal];
            CGSize lblSize = [locationBtn.titleLabel.text sizeOfStringWithFont:[UIFont systemFontOfSize:14] withMaxSize:CGSizeMake(MAXFLOAT, 15)];
            [locationBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, -locationBtn.imageView.image.size.width, 0, locationBtn.imageView.image.size.width)];
            [locationBtn setImageEdgeInsets:UIEdgeInsetsMake(0, lblSize.width + 5, 3, -lblSize.width - 5)];
            locationBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
            [locationBtn addTarget:self action:@selector(toShopLocation) forControlEvents:UIControlEventTouchUpInside];
            
            [goodsItemView addSubview:locationBtn];
            
            [locationBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.right.mas_equalTo(goodsItemView.mas_right).offset(-8);
                make.centerY.equalTo(priceLabel.mas_centerY);
                make.size.mas_equalTo(CGSizeMake(85, 30));
            }];
        }
        
    }else{
        
        // 起拍价
        UILabel *startPrice = [UILabel new];
        startPrice.font = [UIFont systemFontOfSize:14.0f];
        startPrice.textAlignment = NSTextAlignmentLeft;
        startPrice.textColor = [UIColor darkTextColor];
        
        [goodsItemView addSubview:startPrice];
        
        // 时间
        UIButton *durationBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [durationBtn setTitle:[NSString stringWithFormat:@"  %@s",_auctionModel.RemainTime] forState:UIControlStateNormal];
        durationBtn.titleLabel.font = [UIFont systemFontOfSize:14.0f];
        [durationBtn setImage:[UIImage imageNamed:@"clock"] forState:UIControlStateNormal];
        
        NSString *unit;
        NSUInteger remainTime;
        
        if (_auctionModel.RemainTime.integerValue >= 60) {
            remainTime = _auctionModel.RemainTime.doubleValue/60;
            unit = @"min";
        }else{
            remainTime = _auctionModel.RemainTime.doubleValue;
            unit = @"s";
        }
        
        if (_auctionModel.Status.integerValue != 1) {
            unit = @"min";
        }
        
        self.currentTimeCount = _auctionModel.RemainTime.integerValue;
        if (_auctionModel.Status.integerValue == 1) {
            _timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(timeCount:) userInfo:nil repeats:YES];
        }
        
        [durationBtn setTitle:[NSString stringWithFormat:@"  %zd%@",remainTime,unit] forState:UIControlStateNormal];
        durationBtn.titleLabel.font = [UIFont systemFontOfSize:14.0f];
        [durationBtn setTitleColor:[UIColor darkTextColor] forState:UIControlStateNormal];
        [goodsItemView addSubview:durationBtn];
        
        self.timeBtn = durationBtn;
        
        // 当前参数人数
        UILabel *joinLabel = [UILabel new];
        
        __block NSString *joinStr;
        
        joinLabel.textColor = [UIColor darkTextColor];
        joinLabel.textAlignment = NSTextAlignmentLeft;
        joinLabel.font = [UIFont systemFontOfSize:14.0f];
        [goodsItemView addSubview:joinLabel];
        
        UILabel *currentStatus = [UILabel new];
        currentStatus.textColor = [UIColor colorWithHexString:@"#FC6620"];
        currentStatus.font = [UIFont boldSystemFontOfSize:16.0f];
        
        UIImageView *statusImage = [UIImageView new];
        [goodsItemView addSubview:statusImage];
        
        NSString *successImageName;
        NSString *failImageName;
        if (_auctionModel.SaleType.integerValue == 1) {
            successImageName = @"auctionSuccess";
            failImageName = @"auctionFail";
        }else{
            successImageName = @"chenggong";
            failImageName = @"shibai";
        }
        
        UIImage *successImg = [UIImage imageNamed:successImageName];
        UIImage *failImage = [UIImage imageNamed:failImageName];
        
        [statusImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(goodsItemView);
            make.size.mas_offset(failImage.size);
            make.right.mas_equalTo(goodsItemView.mas_right).offset(-15);
        }];
        
        if (_auctionModel.Status.integerValue == 2) {
            currentStatus.text = @"流拍";
            statusImage.image = failImage;
            
        }else{
            NSString *name;
            if (_auctionModel.Status.integerValue != 1) {
                statusImage.image = successImg;
            }else{
                statusImage.hidden = YES;
            }
            
            if (_auctionModel.CurrentMemberName.length > 6) {
                name = [_auctionModel.CurrentMemberName substringWithRange:NSMakeRange(0, 6)];
            }else{
                name = _auctionModel.CurrentMemberName;
            }
            currentStatus.text = [NSString stringWithFormat:@"%@  ￥%@",name,_auctionModel.CurrentPrice];
        }
        [goodsItemView addSubview:currentStatus];

        
        if (_auctionModel.SaleType.integerValue == 1) {
            startPrice.text = [NSString stringWithFormat:@"起拍价 ￥%0.2f",[_auctionModel.GoodsStartPrice floatValue]];
            if (_auctionModel.Status.integerValue == 1) {
                joinStr = [NSString stringWithFormat:@"当前参与人数:%@",_auctionModel.Count];
            }else{
                joinStr = [NSString stringWithFormat:@"总参与人数:%@",_auctionModel.Count];
            }
            joinLabel.text = joinStr;
            
        }else{
            startPrice.text = [NSString stringWithFormat:@"商品金额 ￥%0.2f",[_auctionModel.GoodsStartPrice floatValue]];
            joinLabel.text = [NSString stringWithFormat:@"已购金额%@",_auctionModel.CurrentPrice];
            currentStatus.hidden = YES;
        }
        
        [_auctionModel xw_addObserverBlockForKeyPath:@"Count" block:^(id  _Nonnull obj, id  _Nonnull oldVal, id  _Nonnull newVal) {
            joinStr = [NSString stringWithFormat:@"当前参与人数:%@",newVal];
            joinLabel.text = joinStr;
        }];
        
        [_auctionModel xw_addObserverBlockForKeyPath:@"CurrentMemberName" block:^(id  _Nonnull obj, id  _Nonnull oldVal, id  _Nonnull newVal) {
            NSString *statusStr = [NSString stringWithFormat:@"%@  ￥%@",_auctionModel.CurrentMemberName,_auctionModel.CurrentPrice];
            currentStatus.text = statusStr;
        }];
        
        [_auctionModel xw_addObserverBlockForKeyPath:@"CurrentPrice" block:^(id  _Nonnull obj, id  _Nonnull oldVal, id  _Nonnull newVal) {
            NSString *statusStr = [NSString stringWithFormat:@"%@  ￥%@",_auctionModel.CurrentMemberName,_auctionModel.CurrentPrice];
            currentStatus.text = statusStr;
        }];
        
        [_auctionModel xw_addObserverBlockForKeyPath:@"RemainTime" block:^(id  _Nonnull obj, id  _Nonnull oldVal, id  _Nonnull newVal) {
            
            NSNumber *currentCountTime = newVal;
            self.currentTimeCount = currentCountTime.integerValue;
        }];
        
        itemHeight = WKScreenH/4 - 10;
        [goodsItemView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(5);
            make.left.mas_equalTo(0);
            make.size.mas_equalTo(CGSizeMake(WKScreenW, itemHeight));
        }];
        
        // 名字
        [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_offset(WKScreenW/3 + 5);
            make.top.mas_offset(5);
            make.right.mas_equalTo(goodsItemView.mas_right).offset(-5);
            make.height.mas_offset(30);
        }];
        
        // 起拍价
        [startPrice mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(nameLabel.mas_bottom).offset(5);
            make.left.mas_offset(WKScreenW/3 + 5);
            make.right.mas_equalTo(goodsItemView.mas_right).offset(-5);
            make.height.mas_offset(20);
        }];
        
        [durationBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(startPrice.mas_bottom).offset(5);
            make.right.mas_equalTo(goodsItemView.mas_right).offset(-5);
            make.size.mas_offset(CGSizeMake(80, 20));
        }];
        
        [joinLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(durationBtn.mas_centerY);
            make.right.mas_equalTo(durationBtn.mas_left).offset(5);
            make.left.mas_equalTo(WKScreenW/3 + 5);
            make.height.mas_offset(20);
        }];
        
        [currentStatus mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(joinLabel.mas_bottom).offset(10);
            make.left.mas_offset(WKScreenW/3 + 5);
            make.right.mas_equalTo(goodsItemView.mas_right).offset(-5);
            make.bottom.mas_equalTo(goodsItemView.mas_bottom).offset(-5);
        }];
    }
    
    UIView *descriptionView = [UIView new];
    descriptionView.backgroundColor = [UIColor whiteColor];
    [headView addSubview:descriptionView];
    
    
    NSString *descStr = [@"描述: " stringByAppendingString:_goodsDetail.Description];
    CGFloat descHeight = [descStr sizeOfStringWithFont:[UIFont systemFontOfSize:14.0f] withMaxSize:CGSizeMake(WKScreenW - 10, CGFLOAT_MAX)].height;
    
    NSMutableAttributedString *attr = [[NSMutableAttributedString alloc] initWithString:descStr];
    [attr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:16] range:NSMakeRange(0, 2)];
    [attr addAttribute:NSForegroundColorAttributeName value:[UIColor blueColor] range:NSMakeRange(0, 2)];
    
    UILabel *descLabel = [UILabel new];
    descLabel.attributedText = attr;
    descLabel.textColor = [UIColor darkGrayColor];
    descLabel.font = [UIFont systemFontOfSize:14.0f];
    descLabel.textAlignment = NSTextAlignmentLeft;
    descLabel.numberOfLines = 0;
    [descriptionView addSubview:descLabel];
    
    headView.frame = CGRectMake(0, 0, WKScreenW, itemHeight + descHeight + 30);

    [descriptionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(goodsItemView.mas_bottom).offset(5);
//        make.size.mas_equalTo(CGSizeMake(WKScreenW, descHeight + 10));
        make.width.mas_equalTo(WKScreenW);
        make.bottom.mas_equalTo(headView.mas_bottom).offset(0);
        make.left.mas_offset(0);
    }];
    
    [descLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(descriptionView.mas_top).offset(0);
        make.bottom.mas_equalTo(descriptionView.mas_bottom).offset(0);
        make.left.mas_offset(5);
        make.width.mas_equalTo(WKScreenW - 10);
//        make.height.mas_equalTo(descHeight + 10);
//        make.size.mas_offset(CGSizeMake(WKScreenW - 10, descHeight));
    }];
    
    return headView;

}

- (void)insertCommentArr:(NSArray *)arr{
    [self.commentArray addObjectsFromArray:arr];
    [self.tableView reloadData];
}

// MARK: 跳转查看店铺位置
- (void)toShopLocation{
    if (self.clickAddress) {
        self.clickAddress(1);
    }
}

- (void)timeCount:(NSTimer *)timer{
    
    NSString *unit;
    NSUInteger remainTime;
    
    if (self.currentTimeCount >= 60)
    {
        remainTime = self.currentTimeCount/60;
        unit = @"min";
    }
    else
    {
        if(self.currentTimeCount <= 0)
        {
            remainTime = 0;
            unit = @"min";
        }
        else
        {
            remainTime = self.currentTimeCount;
            unit = @"s";
        }
    }
    [self.timeBtn setTitle:[NSString stringWithFormat:@"  %zd%@",remainTime,unit] forState:UIControlStateNormal];
    
    if (self.currentTimeCount <= 0)
    {
        [_timer invalidate];
        _timer = nil;
    }
    
    self.currentTimeCount--;
    
}


-(void)initData
{
    self.picarray = [NSArray array];
}


-(void)loadData
{
    NSDictionary *param = @{
                            @"GoodsCode":[NSNumber numberWithInteger:_goodsDetail.GoodsCode],
                            @"LevelType":@(3),
                            @"PageIndex":@(_currPage),
                            @"PageSize":@(10)
                            };
    
    [WKProgressHUD showLoadingGifText:@""];
    [WKHttpRequest GoodsCommentList:HttpRequestMethodPost url:WKLiveGoodsComment model:@"WKLiveShopCommentModel" param:param success:^(WKBaseResponse *response) {
        [WKProgressHUD dismiss];
        
        [self.tableView.mj_footer endRefreshing];
        
        
//        NSLog(@"response : %@",response.json);
        WKLiveShopCommentModel *md = response.Data;
        
        if (md.InnerList.count < 10) {
            [self.tableView.mj_footer endRefreshingWithNoMoreData];
        }
        
        [self.commentArray addObjectsFromArray:md.InnerList];
        [self.tableView reloadData];
        
    } failure:^(WKBaseResponse *response) {
        [WKProgressHUD showTopMessage:response.ResultMessage];
        _currPage -= 1;
    }];
}


#pragma mark - tableView Delegate/DataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(section == 0)
    {
        return _goodsDetail.GoodsPicList.count;
    }
    else if(section == 1)
    {
        return self.commentArray.count;
    }
    return 0;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section == 0)
    {
        NSString *cellIdentifier = @"liveShopCell";
        WKLiveShopDetailTableViewCell  *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if(!cell)
        {
            cell = [[WKLiveShopDetailTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.item = _goodsDetail.GoodsPicList[indexPath.row];        
        return cell;
    }
    else if(indexPath.section == 1)
    {
        NSString *cellIdentifier = @"liveShopEvaCell";
        WKLiveShopEvaluateTableViewCell  *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if(!cell)
        {
            cell = [[WKLiveShopEvaluateTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        }
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell setModelItem:self.commentArray[indexPath.row] setRowIndex:indexPath.row];

        cell.clickLiveShopType = ^(LiveShopAudioType type){
            _showPicBlock(type,indexPath.row);
        };
        
        //收听评论
        cell.listenBlock = ^(UIButton *sender)
        {
            //定义是否需要开始收听
            BOOL NeedListen = true;
            
            //停止其他的按钮播放
            if(self.lastButtonArray.count > 0)
            {
                //获得上一次播放的按钮
                UIButton *btnLast = self.lastButtonArray[0];
                
                UIButton *btnAudio1 = (UIButton *)[btnLast viewWithTag:100001];
                [btnAudio1 setImage:[UIImage imageNamed:@"audiono"] forState:UIControlStateNormal];
                
                UIButton *btnAudio2 = (UIButton *)[btnLast viewWithTag:100002];
                [btnAudio2 setImage:[UIImage imageNamed:@"audiono"] forState:UIControlStateNormal];
                
                [[PlayerManager sharedManager] stopPlaying];
                
                //如果相等，证明点击的是同一个按钮，关闭，并设置不需要开始收听
                if([btnLast.titleLabel.text isEqualToString:sender.titleLabel.text])
                {
                    NeedListen = false;
                }

                [self.lastButtonArray removeAllObjects];
            }
            
            if(NeedListen)
            {
                NSString *path = [[NSBundle mainBundle] pathForResource:@"reply" ofType:@"gif"];
                UIImage *gifImage = [UIImage animatedImageWithAnimatedGIFURL:[NSURL fileURLWithPath:path]];
                
                if(sender.tag == ClickLiveShopAudioType)
                {
                    UIButton *btn = (UIButton *)[sender viewWithTag:100001];
                    [btn setImage:gifImage forState:UIControlStateNormal];
                    //_showPicBlock(ClickLiveShopAudioType,indexPath.row);
                }
                else if(sender.tag == ClickLiveShopReplyAudioType)
                {
                    UIButton *btn = (UIButton *)[sender viewWithTag:100002];
                    [btn setImage:gifImage forState:UIControlStateNormal];
                    //_showPicBlock(ClickLiveShopReplyAudioType,indexPath.row);
                }
                
                [self listenType:sender.tag listenRow:indexPath.row];
                
                [self.lastButtonArray addObject:sender];
            }
        };
        
        return cell;
    }
    return nil;
}

-(void)listenType:(NSInteger)type listenRow:(NSInteger)row
{
    NSString *content = @"";
    
    if(type == ClickLiveShopAudioType)
    {
        content = ((WKLiveShopCommentModelItem*)self.commentArray[row]).Content;
    }
    else if(type == ClickLiveShopReplyAudioType)
    {
        content = ((WKLiveShopCommentModelItem*)self.commentArray[row]).Reply;
    }
    
    if(![content isEqualToString:@""])
    {
        [WKPlayTool writeFileWithStr:content :^(NSString *voicePath, NSString *requestMessage)
        {
            if ([requestMessage isEqualToString:@"写入成功"])
            {
                [[PlayerManager sharedManager] playAudioWithFileName:voicePath delegate:self];
            }
        }];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section == 0)
    {
        WKLiveShopPicModelItem *item = _goodsDetail.GoodsPicList[indexPath.row];
       return item.cellHeight;
    }
    else if(indexPath.section == 1)
    {
        WKLiveShopCommentModelItem *model = self.commentArray[indexPath.row];
        if(model.Reply.length == 0)
        {
            return 120 + 70 + 10;
        }
        else
        {
            return 120 + 70 + 95;
        }
    }
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if(section == 0)
    {
        if(self.commentArray.count <= 0)//代表没有评论信息
        {
            return 50;
        }
        return 0.1;
    }
    return 0.1;
}


- (nullable UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    if(section == 0)
    {
        if(self.commentArray.count <= 0)
        {
            UIButton *footView = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, WKScreenW, 45)];
            [footView setImage:[UIImage imageNamed:@"zanwupinglun"] forState:UIControlStateNormal];
            [footView setTitle:@"暂无买家评论" forState:UIControlStateNormal];
            [footView setTitleColor:[UIColor colorWithHex:0x9AA0AC] forState:UIControlStateNormal];
            footView.backgroundColor = [UIColor colorWithHex:0xEEF2FB];
            footView.titleEdgeInsets = UIEdgeInsetsMake(0, 15, 0, 0);
            return footView;
        }
        return nil;
    }
    return nil;
}

-(void)addressEvent
{
    if(_clickAddress)
    {
        _clickAddress(1);
    }
}

-(void)addressEventName
{
    if(_clickAddress)
    {
        _clickAddress(1);
    }
}

- (void)dealloc{
    [_timer invalidate];
    _timer = nil;
}

-(void)playingStoped
{
    if(self.lastButtonArray.count > 0)
    {
        //获得上一次播放的按钮
        UIButton *btnLast = self.lastButtonArray[0];
        
        UIButton *btnAudio1 = (UIButton *)[btnLast viewWithTag:100001];
        [btnAudio1 setImage:[UIImage imageNamed:@"audiono"] forState:UIControlStateNormal];
        
        UIButton *btnAudio2 = (UIButton *)[btnLast viewWithTag:100002];
        [btnAudio2 setImage:[UIImage imageNamed:@"audiono"] forState:UIControlStateNormal];
                
        [self.lastButtonArray removeAllObjects];
        
    }
}

@end
