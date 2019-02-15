//
//  WKOrderTableView.m
//  wdbo
//
//  Created by lin on 16/6/23.
//  Copyright © 2016年 Walkingtec. All rights reserved.
//

#import "WKOrderTableView.h"
#import "WKOrderStatusModel.h"
#import "WKOrderTableViewCell.h"
#import "WKShowInputView.h"
#import "UIImage+Gif.h"

@interface WKOrderTableView()

@property (nonatomic,assign) BOOL click;

@property (nonatomic,strong) UIButton *removeStatus;

@end

@implementation WKOrderTableView

-(instancetype)initWithFrame:(CGRect)frame
{
    if (self =[super initWithFrame:frame])
    {
        self.isOpenHeaderRefresh = YES;
        self.isOpenFooterRefresh = YES;
        self.click = YES;
        self.tableView.showsVerticalScrollIndicator = NO;
        [self.tableView initWithFrame:frame style:UITableViewStyleGrouped];
        self.tableView.backgroundColor = [UIColor colorWithHex:0xF2F6FF];
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return self;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return ((WKOrderStatusItemModel*)self.dataArray[section]).Products.count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *cellIdentifier = @"cell";
    WKOrderTableViewCell  *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if(!cell)
    {
        cell = [[WKOrderTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    [cell productItem:((WKOrderStatusItemModel*)self.dataArray[indexPath.section]).Products[indexPath.row] type:((WKOrderStatusItemModel*)self.dataArray[indexPath.section]).OrderType];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if(((WKOrderProduct*)(((WKOrderStatusItemModel*)self.dataArray[indexPath.section]).Products[indexPath.row])).GoodsCode == 0)
    {
        cell.headImgaeView.image = [UIImage imageNamed:@"pingjiastore"];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(_clickCallBack)
    {
        _clickCallBack(ClickCell,indexPath.section);
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 85;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 50;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if(self.CustomType == 1)
    {
        return 40;
    }
    else if(self.CustomType == 2)
    {
        return 81;
    }
    return 0;
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *headbackGroundView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, WKScreenW, 50)];
    headbackGroundView.backgroundColor = [UIColor colorWithHex:0xF5F8FF];
    
    UIView *headView = [[UIView alloc] init];
    headView.backgroundColor = [UIColor whiteColor];
    [headbackGroundView addSubview:headView];
    [headView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(headbackGroundView).offset(0);
        make.right.equalTo(headbackGroundView.mas_right).offset(0);
        make.top.equalTo(headbackGroundView).offset(10);
        make.height.mas_equalTo(40);
    }];
    
    UIImage *headImage = [UIImage imageNamed:@"default_03"];
    UIImageView *headImageView = [[UIImageView alloc] init];
    headImageView.layer.cornerRadius = headImage.size.height/2;
    headImageView.layer.masksToBounds = YES;
    headImageView.layer.borderColor = [[UIColor colorWithHex:0xD97C39] CGColor];
    headImageView.layer.borderWidth = 1.0;
    [headView addSubview:headImageView];
    [headImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(headView).offset(10);
        make.top.equalTo(headView).offset((40-headImage.size.height)/2);
        make.size.mas_equalTo(CGSizeMake(headImage.size.width, headImage.size.height));
    }];
    
    
    UILabel *name = [[UILabel alloc] init];
    name.textColor = [UIColor colorWithHex:0x7e879d];
    name.font = [UIFont systemFontOfSize:12];
    
    [headView addSubview:name];
    if(self.CustomType == 1)//店铺
    {
        [headImageView sd_setImageWithURL:[NSURL URLWithString:((WKOrderStatusItemModel*)self.dataArray[section]).CustomerPicUrl] placeholderImage:[UIImage imageNamed:@"default_03"]];
        
        CGSize nameSize = [((WKOrderStatusItemModel*)self.dataArray[section]).CustomerName sizeOfStringWithFont:[UIFont boldSystemFontOfSize:12] withMaxSize:CGSizeMake(MAXFLOAT, 20)];
        name.text = [NSString stringWithFormat:@"%@",((WKOrderStatusItemModel*)self.dataArray[section]).CustomerName];
        [name mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(headImageView.mas_right).offset(5);
            make.top.equalTo(headView).offset(5);
            make.size.mas_equalTo(CGSizeMake(nameSize.width, 15));
        }];
        
        UILabel *orderCode = [[UILabel alloc] init];
        orderCode.font = [UIFont systemFontOfSize:12];
        orderCode.textColor = [UIColor colorWithHex:0x7e879d];
        orderCode.text = [NSString stringWithFormat:@"订单编号:%@",((WKOrderStatusItemModel*)self.dataArray[section]).OrderCode];
        [headView addSubview:orderCode];
        [orderCode mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(headImageView.mas_right).offset(5);
            make.top.equalTo(name.mas_bottom).offset(0);
            make.size.mas_equalTo(CGSizeMake(200, 15));
        }];
    }
    else if(self.CustomType == 2)//个人
    {
        [headImageView sd_setImageWithURL:[NSURL URLWithString:((WKOrderStatusItemModel*)self.dataArray[section]).ShopOwnerPicUrl] placeholderImage:[UIImage imageNamed:@"default_03"]];
        
        CGSize nameSize = [((WKOrderStatusItemModel*)self.dataArray[section]).ShopOwnerName sizeOfStringWithFont:[UIFont boldSystemFontOfSize:12] withMaxSize:CGSizeMake(MAXFLOAT, 20)];
        name.text = [NSString stringWithFormat:@"%@",((WKOrderStatusItemModel*)self.dataArray[section]).ShopOwnerName];
        [name mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(headImageView.mas_right).offset(10);
            make.top.equalTo(headView).offset(10);
            make.size.mas_equalTo(CGSizeMake(nameSize.width, 20));
        }];
    }
    
    UIImage *statusImage = [UIImage imageNamed:@"liveStatus"];
    UIImageView *LiveStatusView = [[UIImageView alloc] init];
    LiveStatusView.image = statusImage;
    [headView addSubview:LiveStatusView];
    [LiveStatusView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(name.mas_right).offset(10);
        make.top.equalTo(headView).offset((40-statusImage.size.height)/2);
        make.size.mas_equalTo(CGSizeMake(statusImage.size.width, statusImage.size.height));
    }];
    
    NSInteger isShow = ((WKOrderStatusItemModel*)self.dataArray[section]).IsShow;
    if(isShow == 1)//直播状态
    {
        NSString *path = [[NSBundle mainBundle] pathForResource:@"yuyin" ofType:@"gif"];
        LiveStatusView.image = [UIImage animatedImageWithAnimatedGIFURL:[NSURL fileURLWithPath:path]];
    }
    else
    {
        LiveStatusView.hidden = YES;
    }
    
    UILabel *status = [[UILabel alloc] init];
    status.font = [UIFont systemFontOfSize:12];
    status.textColor = [UIColor colorWithHex:0xFFAE75];
    status.textAlignment = NSTextAlignmentRight;
    status.text = ((WKOrderStatusItemModel*)self.dataArray[section]).CurrentOrderStatus;//@"已完成";
    [headView addSubview:status];
    [status mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(headView.mas_right).offset(-10);
        make.top.equalTo(headView).offset(3);
        make.size.mas_equalTo(CGSizeMake(100, 15));
    }];
    
    NSInteger ordertype = ((WKOrderStatusItemModel*)self.dataArray[section]).OrderType;
    if(ordertype > 1){
        UIImageView *ordertypeView = [[UIImageView alloc] init];
        if(ordertype == 2){
            ordertypeView.image = [UIImage imageNamed:@"Personal_paimai"];
        }
        if(ordertype == 6){
            ordertypeView.image = [UIImage imageNamed:@"Personal_lucky"];
        }
        [headView addSubview:ordertypeView];
        [ordertypeView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(headView.mas_right).offset(-10);
            make.top.equalTo(status.mas_bottom).offset(2);
            //make.bottom.equalTo(headView.mas_bottom).offset(-5);
        }];
    }
    return  headbackGroundView;
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section;
{
    UIView *footView = [[UIView alloc] init];
    if(self.CustomType == 1)
    {
        footView.frame = CGRectMake(0, 0, WKScreenW, 40);
    }
    else if(self.CustomType == 2)
    {
        footView.frame = CGRectMake(0, 0, WKScreenW, 81);
    }
    footView.backgroundColor = [UIColor whiteColor];
    
//    UIImage *removeImage = [UIImage imageNamed:@"pay_normal"];
    UIButton *removeStatus = [[UIButton alloc] init];
    removeStatus.titleLabel.font = [UIFont systemFontOfSize:14];
    removeStatus.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [removeStatus setTitle:@"删除订单" forState:UIControlStateNormal];
    [removeStatus setTitleColor:[UIColor colorWithHex:0xB3B5BC] forState:UIControlStateNormal];
    removeStatus.tag = section;
    [removeStatus addTarget:self action:@selector(removeEvent:) forControlEvents:UIControlEventTouchUpInside];
    self.removeStatus = removeStatus;
    [footView addSubview:removeStatus];
    [removeStatus mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(footView).offset(10);
        make.top.equalTo(footView).offset(10);
        make.size.mas_equalTo(CGSizeMake(150, 20));
    }];

    //店铺
    if(self.CustomType == 1)//店铺
    {
        UILabel *content = [[UILabel alloc] init];
        content.font = [UIFont systemFontOfSize:14];
        content.textColor = [UIColor colorWithHex:0x7e879d];
        content.textAlignment = NSTextAlignmentRight;
        NSString *money = ((WKOrderStatusItemModel*)self.dataArray[section]).PayAmount;

        if([((WKOrderStatusItemModel*)self.dataArray[section]).TranFeeAmount isEqualToString:@""] || ((WKOrderStatusItemModel*)self.dataArray[section]).TranFeeAmount.integerValue == 0)
        {
            content.text = [NSString stringWithFormat:@"合计￥%.2f",[money floatValue]];
        }
        else
        {
            content.text = [NSString stringWithFormat:@"合计￥%.2f(含运费￥%.2f)",[money floatValue],[((WKOrderStatusItemModel*)self.dataArray[section]).TranFeeAmount floatValue]];
        }
        [footView addSubview:content];
        [content mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(footView.mas_right).offset(-20);
            make.top.equalTo(footView).offset(10);
            make.size.mas_lessThanOrEqualTo(CGSizeMake(WKScreenW, 20));
        }];
        

            if([((WKOrderStatusItemModel*)self.dataArray[section]).CurrentOrderStatus isEqualToString:@"未支付"])
                {
                    removeStatus.hidden = YES;
                }
                else if([((WKOrderStatusItemModel*)self.dataArray[section]).CurrentOrderStatus isEqualToString:@"待发货"])
                {
                    removeStatus.hidden = YES;
                }
                else if([((WKOrderStatusItemModel*)self.dataArray[section]).CurrentOrderStatus isEqualToString:@"已发货"])
                {
                    removeStatus.hidden = YES;
                }
                else if([((WKOrderStatusItemModel*)self.dataArray[section]).CurrentOrderStatus isEqualToString:@"已完成"])
                {
                    
                }
                else if([((WKOrderStatusItemModel*)self.dataArray[section]).CurrentOrderStatus isEqualToString:@"已取消"])
                {
                    
                }


    }
    else if(self.CustomType == 2)//个人中心
    {
        UIView *upView = [[UIView alloc] init];
        [footView addSubview:upView];
        [upView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(footView).offset(0);
            make.right.equalTo(footView.mas_right).offset(0);
            make.top.equalTo(footView).offset(0);
            make.height.mas_equalTo(40);
        }];
        
        UIView *xianView = [[UIView alloc] init];
        xianView.backgroundColor = [UIColor colorWithHex:0xEFEFF1];
        [footView addSubview:xianView];
        [xianView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(footView).offset(0);
            make.right.equalTo(footView.mas_right).offset(0);
            make.top.equalTo(upView.mas_bottom).offset(0);
            make.height.mas_equalTo(1);
        }];
        
        
        UILabel *content = [[UILabel alloc] init];
        content.font = [UIFont systemFontOfSize:14];
        content.textColor = [UIColor colorWithHex:0x7e879d];
        content.textAlignment = NSTextAlignmentRight;
        
        NSString *money = ((WKOrderStatusItemModel*)self.dataArray[section]).PayAmount;
        
        if([((WKOrderStatusItemModel*)self.dataArray[section]).TranFeeAmount isEqualToString:@""] ||
           ((WKOrderStatusItemModel*)self.dataArray[section]).TranFeeAmount.integerValue == 0)
        {
            content.text = [NSString stringWithFormat:@"合计￥%.2f",[money floatValue]];
        }
        else
        {
            content.text = [NSString stringWithFormat:@"合计￥%.2f(含运费￥%.2f)",[money floatValue],[((WKOrderStatusItemModel*)self.dataArray[section]).TranFeeAmount floatValue]];
        }
        
        [footView addSubview:content];
        [content mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(upView.mas_right).offset(-20);
            make.top.equalTo(upView).offset(10);
            make.size.mas_lessThanOrEqualTo(CGSizeMake(WKScreenW, 20));
        }];
        
        UIButton *removeOrderBtn = [[UIButton alloc] init];
        removeOrderBtn.backgroundColor = [UIColor whiteColor];
        [removeOrderBtn setTitle:@"删除订单" forState:UIControlStateNormal];
        [removeOrderBtn setTitleColor:[UIColor colorWithHex:0xA2A5AA] forState:UIControlStateNormal];
        removeOrderBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        removeOrderBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        removeOrderBtn.tag = section;
        [removeOrderBtn addTarget:self action:@selector(removeEvent:) forControlEvents:UIControlEventTouchUpInside];
        [footView addSubview:removeOrderBtn];
        [removeOrderBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(footView).offset(10);
            make.top.equalTo(xianView.mas_bottom).offset(5);
            make.size.mas_equalTo(CGSizeMake(150, 30));
        }];
        
        UIButton *rightBtn = [[UIButton alloc] init];
        [rightBtn setTitleColor:[UIColor colorWithHex:0xE89862] forState:UIControlStateNormal];
        rightBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        rightBtn.layer.masksToBounds = YES;
        rightBtn.layer.cornerRadius = 4.0;
        rightBtn.layer.borderColor = [[UIColor colorWithHex:0xE68C4C] CGColor];
        rightBtn.layer.borderWidth = 1.0;
        rightBtn.tag = section;
        self.rightBtn = rightBtn;
        [rightBtn addTarget:self action:@selector(payEvent:) forControlEvents:UIControlEventTouchUpInside];
        [footView addSubview:rightBtn];
        [rightBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(footView.mas_right).offset(-15);
            make.top.equalTo(xianView.mas_bottom).offset(5);
            make.size.mas_equalTo(CGSizeMake(70, 30));
        }];
        
        UIButton *rightBtn2 = [[UIButton alloc] init];
        [rightBtn2 setTitleColor:[UIColor colorWithHex:0xE89862] forState:UIControlStateNormal];
        [rightBtn2 setTitle:@"确认收货" forState:UIControlStateNormal];
        rightBtn2.titleLabel.font = [UIFont systemFontOfSize:14];
        rightBtn2.layer.masksToBounds = YES;
        rightBtn2.layer.cornerRadius = 4.0;
        rightBtn2.layer.borderColor = [[UIColor colorWithHex:0xE68C4C] CGColor];
        rightBtn2.layer.borderWidth = 1.0;
        rightBtn2.tag = section;
        [rightBtn2 addTarget:self action:@selector(payEvent:) forControlEvents:UIControlEventTouchUpInside];
        [footView addSubview:rightBtn2];
        [rightBtn2 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(rightBtn.mas_left).offset(-15);
            make.top.equalTo(xianView.mas_bottom).offset(5);
            make.size.mas_equalTo(CGSizeMake(70, 30));
        }];
        
        UIButton *leftBtn = [[UIButton alloc] init];
        [leftBtn setTitle:@"取消订单" forState:UIControlStateNormal];
        [leftBtn setTitleColor:[UIColor colorWithHex:0xA2A5AA] forState:UIControlStateNormal];
        leftBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        leftBtn.layer.masksToBounds = YES;
        leftBtn.layer.cornerRadius = 4.0;
        leftBtn.layer.borderColor = [[UIColor colorWithHex:0xE9EAEC] CGColor];
        leftBtn.layer.borderWidth = 1.0;
        leftBtn.tag = section;
        [leftBtn addTarget:self action:@selector(cancelEvent:) forControlEvents:UIControlEventTouchUpInside];
        [footView addSubview:leftBtn];
        [leftBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(rightBtn.mas_left).offset(-10);
            make.top.equalTo(xianView.mas_bottom).offset(5);
            make.size.mas_equalTo(CGSizeMake(70, 30));
        }];
        rightBtn2.hidden = YES;

                 if([((WKOrderStatusItemModel*)self.dataArray[section]).CurrentOrderStatus isEqualToString:@"待付款"])
                {
                    [rightBtn setTitle:@"立即支付" forState:UIControlStateNormal];
                    removeStatus.hidden = YES;
                    removeOrderBtn.hidden = YES;
                    //                leftBtn.hidden = YES;
                }
                else if([((WKOrderStatusItemModel*)self.dataArray[section]).CurrentOrderStatus isEqualToString:@"待发货"])
                {
                    [rightBtn setTitle:@"查看详情" forState:UIControlStateNormal];
                    removeStatus.hidden = YES;
                    removeOrderBtn.hidden = YES;
                    leftBtn.hidden = YES;
                    rightBtn2.hidden = YES;
                }
                else if([((WKOrderStatusItemModel*)self.dataArray[section]).CurrentOrderStatus isEqualToString:@"待收货"])
                {
                    [rightBtn setTitle:@"查看物流" forState:UIControlStateNormal];
                    removeStatus.hidden = YES;
                    removeOrderBtn.hidden = YES;
                    leftBtn.hidden = YES;
                    rightBtn2.hidden = NO;

                }
                else if([((WKOrderStatusItemModel*)self.dataArray[section]).CurrentOrderStatus isEqualToString:@"交易成功"])
                {
                    if(((WKOrderStatusItemModel*)self.dataArray[section]).CommentStatus == 1)//已经评价过了
                    {
                        rightBtn.hidden = YES;
                        removeStatus.hidden = YES;
                        leftBtn.hidden = YES;
                    }
                    else
                    {
                        [rightBtn setTitle:@"评价晒单" forState:UIControlStateNormal];
                        removeStatus.hidden = YES;
                        leftBtn.hidden = YES;
                    }
                }
                else if([((WKOrderStatusItemModel*)self.dataArray[section]).CurrentOrderStatus isEqualToString:@"已取消"])
                {
                    rightBtn.hidden = YES;
                    removeStatus.hidden = YES;
                    leftBtn.hidden = YES;
                }

        
    }
    return  footView;
}

//删除订单
-(void)removeEvent:(UIButton *)sender
{
    if(_clickCallBack)
    {
        _clickCallBack(ClickRemove,sender.tag);
//        _clickCallBack(ClickRemove,sender.tag);
//        if(self.CustomType == 1)
//        {
//            _clickCallBack(ClickRemove,sender.tag);
////            if(self.click)
////            {
////                [sender setImage:[UIImage imageNamed:@"pay_select"] forState:UIControlStateNormal];
////            }
////            else
////            {
////                [sender setImage:[UIImage imageNamed:@"pay_normal"] forState:UIControlStateNormal];
////            }
////            _clickCallBack(ClickOffinePay,sender.tag);
//        }
//        else if(self.CustomType == 2)//删除订单
//        {
//            _clickCallBack(ClickRemove,sender.tag);
//        }
    }
//    self.click = !self.click;
}


//取消订单
-(void)cancelEvent:(UIButton *)sender
{
    if(_clickCallBack)
    {
        _clickCallBack(ClickCancelOrder,sender.tag);
    }
}

//立即支付，查看详情，查看物流
-(void)payEvent:(UIButton *)sender
{
    if([sender.titleLabel.text isEqualToString:@"立即支付"])
    {
        _clickCallBack(ClickPayOrder,sender.tag);
    }
    else if([sender.titleLabel.text isEqualToString:@"查看详情"])
    {
        _clickCallBack(ClickLookDetail,sender.tag);
    }
    else if([sender.titleLabel.text isEqualToString:@"查看物流"])
    {
        _clickCallBack(ClickLookGoods,sender.tag);
    }
    else if([sender.titleLabel.text isEqualToString:@"评价晒单"])
    {
        _clickCallBack(CLickLookOrder,sender.tag);
    }
    else if([sender.titleLabel.text isEqualToString:@"确认收货"])
    {
        _clickCallBack(ClickFinish,sender.tag);
    }
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
