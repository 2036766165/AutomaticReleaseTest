//
//  WKOrderDetailTableView.m
//  秀加加
//
//  Created by lin on 16/9/12.
//  Copyright © 2016年 walkingtec. All rights reserved.
//

#import "WKOrderDetailTableView.h"
#import "WKOrderDetailTableViewCell.h"
#import "WKOrderShopMessageTableViewCell.h"
#import "WKOrderDetailModel.h"
#import "WKOrderTableView.h"
#import "WKOrderAuctionTableViewCell.h"
#import "WKMessageTalkViewController.h"
#import "NSObject+WKImagePicker.h"

@interface WKOrderDetailTableView()

@property (nonatomic,strong) NSTimer *timer;

@property (nonatomic,strong) UIButton *sendBtn;

@end

@implementation WKOrderDetailTableView

-(instancetype)initWithFrame:(CGRect)frame
{
    if (self =[super initWithFrame:frame])
    {
        self.isOpenHeaderRefresh = NO;
        self.isOpenFooterRefresh = NO;
        self.tableView.showsVerticalScrollIndicator = NO;
        [self.tableView initWithFrame:frame style:UITableViewStyleGrouped];
        self.tableView.backgroundColor = [UIColor colorWithHex:0xF2F6FF];
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return self;
}

-(void)setModel:(WKOrderDetailModel *)model
{
    _model = model;
    if(_model.ExpressCode == nil){
        _model.ExpressCode = @"";
    }
    if(_model.ExpressCompanyName == nil){
        _model.ExpressCompanyName = @"";
    }
    self.expressNum = _model.ExpressCode;
    self.expressName = _model.ExpressCompanyName;
    if([_model.CurrentOrderStatus isEqualToString:@"待发货"]){
        self.expressNum = @"";
        self.expressName = @"";
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(section == 0)
    {
        return 0;   //没有cell
    }
    else if(section == 1)
    {
        return self.dataArray.count;
    }
    else if(section == 2)
    {
        if([_model.CurrentOrderStatus isEqualToString:@"已取消"] || [_model.CurrentOrderStatus isEqualToString:@"未支付"])
        {
            return 1;
        }
        else
        {
            if(_type == 1){
                return 3;
            }
            else{
                return 2;
                
            }
        }
    }
    else if(section == 3)
    {
        if(_type == 1)
        {
            return 1;
        }
        else
        {
            if([_model.CurrentOrderStatus isEqualToString:@"已取消"]){
                return 1;
            }
            else{
                return 2;
            }
        }
    }
    else if(section == 4)
    {
        return 0;   //没有cell
    }
    return 0;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 5;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 1) {
        NSString *cellIdentifier = @"cell";
        WKOrderDetailTableViewCell  *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if(!cell)
        {
            cell = [[WKOrderDetailTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        }
        [cell setItem:self.dataArray[indexPath.row] model:_model type:_model.OrderType];
        
//        cell.selectType = ^(NSInteger type)
//        {
//            if(_sendCallBack)
//            {
//                _sendCallBack(type,indexPath.section);
//            }
//        };
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    else if(indexPath.section == 2)
    {
        NSString *cellIdentifier = @"cellorder";
        WKOrderShopMessageTableViewCell  *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if(!cell)
        {
            cell = [[WKOrderShopMessageTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        }
        
        if(_type == 1)//普通商品
        {
            if([_model.CurrentOrderStatus isEqualToString:@"未支付"] || [_model.CurrentOrderStatus isEqualToString:@"已取消"])
            {
                if(indexPath.row == 0)
                {
                    cell.name.text = [NSString stringWithFormat:@"运费 ￥%.2f",[self.model.TranFeeAmount floatValue]];
                    cell.statusBtn.hidden = YES;
                    if([_model.CurrentOrderStatus isEqualToString:@"未支付"]){
                        cell.statusBtn.hidden = NO;
                        cell.clickTypeOrderShop = ^(){
                            if(_sendCallBack)
                            {
                                _sendCallBack(3,indexPath.row);
                            }
                        };
                    }
                }
            }
            else if([_model.CurrentOrderStatus isEqualToString:@"待发货"])
            {
                if(indexPath.row == 0)
                {
                    cell.name.text = [NSString stringWithFormat:@"物流单号:%@",self.expressNum];//@"物流单号:123456";
                    [cell.statusBtn setImage:[UIImage imageNamed:@"saoma"] forState:UIControlStateNormal];
                    [cell.statusBtn setTitle:@"" forState:UIControlStateNormal];
                    cell.clickTypeOrderShop = ^(){
                        if(_sendCallBack)
                        {
                            _sendCallBack(6,indexPath.row);
                        }
                    };
                }
                else if(indexPath.row == 1)
                {
                    cell.name.text = [NSString stringWithFormat:@"物流公司:%@",self.expressName];//@"物流公司:";
                    [cell.statusBtn setImage:[UIImage imageNamed:@"go"] forState:UIControlStateNormal];
                    [cell.statusBtn setTitle:@"" forState:UIControlStateNormal];
                    cell.clickTypeOrderShop = ^(){
                        if(_sendCallBack)
                        {
                            _sendCallBack(5,indexPath.row);
                        }
                    };
                }
                else if(indexPath.row == 2)
                {
                    cell.name.text = [NSString stringWithFormat:@"运费 ￥%.2f",[self.model.TranFeeAmount floatValue]];
                    cell.statusBtn.hidden = YES;
                }
            }
            else
            {
                if(indexPath.row == 0)
                {
                    cell.name.text = [NSString stringWithFormat:@"物流单号:%@",self.model.ExpressCode];
                    cell.statusBtn.hidden = YES;
                }
                else if(indexPath.row == 1)
                {
                    cell.name.text = [NSString stringWithFormat:@"物流公司:%@",self.model.ExpressCompanyName];
                    cell.statusBtn.hidden = YES;
                }
                else if(indexPath.row == 2)
                {
                    cell.name.text = [NSString stringWithFormat:@"运费 ￥%.2f",[self.model.TranFeeAmount floatValue]];//@"运费:￥122";
                    cell.statusBtn.hidden = YES;
                }
            }
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }
        else
        {
            if([_model.CurrentOrderStatus isEqualToString:@"未支付"] || [_model.CurrentOrderStatus isEqualToString:@"已取消"])
            {
                if(indexPath.row == 0)
                {
                    cell.name.text = @"无";
                    cell.statusBtn.hidden = YES;
                }

            }
            else if([_model.CurrentOrderStatus isEqualToString:@"待发货"])
            {
                if(indexPath.row == 0)
                {
                    cell.name.text = [NSString stringWithFormat:@"物流单号:%@",self.expressNum];//@"物流单号:123456";
                    [cell.statusBtn setImage:[UIImage imageNamed:@"saoma"] forState:UIControlStateNormal];
                    [cell.statusBtn setTitle:@"" forState:UIControlStateNormal];
                    cell.clickTypeOrderShop = ^(){
                        if(_sendCallBack)
                        {
                            _sendCallBack(6,indexPath.row);
                        }
                    };
                }
                else if(indexPath.row == 1)
                {
                    cell.name.text = [NSString stringWithFormat:@"物流公司:%@",self.expressName];//@"物流公司:";
                    [cell.statusBtn setImage:[UIImage imageNamed:@"go"] forState:UIControlStateNormal];
                    [cell.statusBtn setTitle:@"" forState:UIControlStateNormal];
                    cell.clickTypeOrderShop = ^(){
                        if(_sendCallBack)
                        {
                            _sendCallBack(5,indexPath.row);
                        }
                    };
                }
            }
            else
            {
                if(indexPath.row == 0)
                {
                    cell.name.text = [NSString stringWithFormat:@"物流单号:%@",self.model.ExpressCode];
                    cell.statusBtn.hidden = YES;
                }
                else if(indexPath.row == 1)
                {
                    cell.name.text = [NSString stringWithFormat:@"物流公司:%@",self.model.ExpressCompanyName];
                    cell.statusBtn.hidden = YES;
                }
            }
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }
    }
    else if(indexPath.section == 3)
    {
        NSString *cellIdentifier = @"paicellorder";
        WKOrderAuctionTableViewCell  *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if(!cell)
        {
            cell = [[WKOrderAuctionTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        }
               if(indexPath.row == 0)
                {
                    cell.name.text = @"服务费:";
                    cell.value.text = [NSString stringWithFormat:@"￥%.2f",[_model.ServiceAmount floatValue]];
                }
                else if(indexPath.row == 1)
                {
                    cell.name.text = @"实际收入:";
                    cell.value.text = [NSString stringWithFormat:@"￥%.2f",[_model.PayAmount floatValue]-[_model.ServiceAmount floatValue]];
                }


        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section == 1)
    {
        return 85;
    }
    else if(indexPath.section == 2)
    {
        return 40;
    }
    else if(indexPath.section == 3)
    {
        return 40;
    }
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if(section == 0)
    {
        if(_type == 2 && ([_model.CurrentOrderStatus isEqualToString:@"已取消"] || [_model.CurrentOrderStatus isEqualToString:@"未支付"]))
        {
            return 0.1;
        }
        else{
            return 60;
        }
    }
    else if(section == 1)
    {
        return 55;
    }
    else if(section == 2)
    {
        return 35;
    }
    else if(section == 3)
    {
        return 0.1;
    }
    else if(section == 4)
    {
        if(_type == 1)
        {
            if([_model.CurrentOrderStatus isEqualToString:@"未支付"])
            {
                return 60;
            }
            else if([_model.CurrentOrderStatus isEqualToString:@"待发货"])
            {
                return 80;
            }
            else if([_model.CurrentOrderStatus isEqualToString:@"已发货"])
            {
                return 80;//100;
            }
            else if([_model.CurrentOrderStatus isEqualToString:@"已完成"])
            {
                return 100;//125;
            }
            else if([_model.CurrentOrderStatus isEqualToString:@"已取消"])
            {
                return 60;
            }
        }
        else
        {
            if([_model.CurrentOrderStatus isEqualToString:@"已完成"])
            {
                return 100;
            }
            else
                return 80;
        }
    }
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if(section == 0)
    {
        return 0.1;
    }
    else if(section == 1)
    {
        return  120;
    }
    else if(section == 2)
    {
        return 10;
    }
    else if(section == 3){
        return 10;
    }
    else if(section == 4)
    {
        if([_model.CurrentOrderStatus isEqualToString:@"已发货"]){
            return 0;
        }
        else{
            return 80/(WKScaleH);
        }
    }
    return 0;
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if(section == 0)
    {
        UIView *section0 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, WKScreenW, 60)];
        section0.backgroundColor = [UIColor colorWithHex:0xF2F5FE];
        
        UIView *headView = [[UIView alloc] initWithFrame:CGRectMake(0, 5, WKScreenW, 55)];
        headView.backgroundColor = [UIColor whiteColor];
        [section0 addSubview:headView];
        
        UILabel *name = [[UILabel alloc] init];
        name.font = [UIFont systemFontOfSize:12];
        name.text = [NSString stringWithFormat:@"%@ %@",self.model.ShipName,self.model.ShipPhone];//self.model.ShipName;
        name.textAlignment = NSTextAlignmentLeft;
        name.textColor = [UIColor colorWithHex:0x7e879d];
        self.name = name;
        [headView addSubview:name];
        [name mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(headView).offset(5);
            make.top.equalTo(headView).offset(5);
            make.size.mas_equalTo(CGSizeMake(WKScreenW-10, 20));
        }];
        
        UIImage *addressImage = [UIImage imageNamed:@"address"];
        UIImageView *addressImageView = [[UIImageView alloc] init];
        addressImageView.image = addressImage;
        [headView addSubview:addressImageView];
        [addressImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(headView).offset(5);
            make.top.equalTo(name.mas_bottom).offset(5);
            make.size.mas_equalTo(CGSizeMake(addressImage.size.width, addressImage.size.height));
        }];
        
        UILabel *address = [[UILabel alloc] init];
        address.font = [UIFont systemFontOfSize:12];
        address.text = [NSString stringWithFormat:@"%@%@%@%@",self.model.ShipProvince,self.model.ShipCity,self.model.ShipCounty,self.model.ShipAddress];
        address.textAlignment = NSTextAlignmentLeft;
        address.textColor = [UIColor colorWithHex:0x7e879d];
        self.address = address;
        [headView addSubview:address];
        [address mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(addressImageView.mas_right).offset(5);
            make.top.equalTo(name.mas_bottom).offset(2);
            make.size.mas_equalTo(CGSizeMake(WKScreenW-15-addressImage.size.width, 20));
        }];
        
        if([self.model.CurrentOrderStatus isEqualToString:@"待发货"])
        {
            UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(goEvent)];
            [headView addGestureRecognizer:gesture];
            UIImage *goImage = [UIImage imageNamed:@"go"];
            UIButton *goBtn = [[UIButton alloc] init];
            [goBtn setImage:goImage forState:UIControlStateNormal];
            [goBtn addTarget:self action:@selector(goEvent) forControlEvents:UIControlEventTouchUpInside];
            [headView addSubview:goBtn];
            [goBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.right.equalTo(headView.mas_right).offset(-10);
                make.top.equalTo(headView).offset((55-goImage.size.height)/2);
                make.size.mas_equalTo(CGSizeMake(goImage.size.width, goImage.size.height));
            }];
        }
        
        if(_type == 2)
        {
            if([self.model.CurrentOrderStatus isEqualToString:@"未支付"] || [self.model.CurrentOrderStatus isEqualToString:@"已取消"])
            {
                return nil;
            }
        }
        return section0;
    }
    else if(section == 1)
    {
        UIView *section1 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, WKScreenW, 55)];
        section1.backgroundColor = [UIColor colorWithHex:0xF2F5FE];
        
        
        UIView *headImgaeView = [[UIView alloc] initWithFrame:CGRectMake(0, 5, WKScreenW, 50)];
        headImgaeView.backgroundColor = [UIColor whiteColor];
        [section1 addSubview:headImgaeView];
        
        
        UIImage *headImage = [UIImage imageNamed:@"default_03"];
        UIImageView *headView = [[UIImageView alloc] init];
        headView.layer.cornerRadius = headImage.size.height/2;
        headView.layer.masksToBounds = YES;
        headView.layer.borderColor = [[UIColor colorWithHex:0xD97C39] CGColor];
        headView.layer.borderWidth = 1.0;
        [headView sd_setImageWithURL:[NSURL URLWithString:_model.CustomerPicUrl] placeholderImage:[UIImage imageNamed:@"default_03"]];
        [headImgaeView addSubview:headView];
        [headView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(headImgaeView).offset(10);
            make.top.equalTo(headImgaeView).offset((50-headImage.size.height)/2);
            make.size.mas_equalTo(CGSizeMake(headImage.size.width, headImage.size.height));
        }];
        
        UILabel *name = [[UILabel alloc] init];
        name.textColor = [UIColor colorWithHex:0x7e879d];
        name.font = [UIFont systemFontOfSize:12];
         CGSize nameSize = [_model.CustomerName sizeOfStringWithFont:[UIFont boldSystemFontOfSize:12] withMaxSize:CGSizeMake(MAXFLOAT, 20)];
        name.text = _model.CustomerName;
        [headImgaeView addSubview:name];
        [name mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(headView.mas_right).offset(5);
            make.top.equalTo(headImgaeView).offset(5);
            make.size.mas_equalTo(CGSizeMake(nameSize.width, 15));
        }];
        
        UILabel *ordername = [[UILabel alloc] init];
        ordername.font = [UIFont systemFontOfSize:12];
        ordername.text = [NSString stringWithFormat:@"订单编号:%@",_model.OrderCode];
        ordername.textAlignment = NSTextAlignmentLeft;
        ordername.textColor = [UIColor colorWithHex:0x7e879d];
        [headImgaeView addSubview:ordername];
        [ordername mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(headView.mas_right).offset(5);
            make.top.equalTo(name.mas_bottom).offset(5);
            make.size.mas_equalTo(CGSizeMake(200, 20));
        }];
        
        UILabel *status = [[UILabel alloc] init];
        status.font = [UIFont systemFontOfSize:12];
        status.text = _model.CurrentOrderStatus;//@"待确认";
        status.textAlignment = NSTextAlignmentRight;
        status.textColor = [UIColor colorWithHex:0xF79C70];
        [headImgaeView addSubview:status];
        [status mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(headImgaeView.mas_right).offset(-15);
            make.top.equalTo(headImgaeView).offset((50-20)/2);
            make.size.mas_equalTo(CGSizeMake(60, 20));
        }];
        return section1;
    }
    else if(section == 2)
    {
        UIView *section2 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, WKScreenW, 35)];
        section2.backgroundColor = [UIColor colorWithHex:0xF3F6FF];
        
        UILabel *name = [[UILabel alloc] init];
        name.font = [UIFont systemFontOfSize:12];
        name.text = @"物流信息:";
        name.textAlignment = NSTextAlignmentLeft;
        name.textColor = [UIColor colorWithHex:0x7e879d];
        [section2 addSubview:name];
        [name mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(section2).offset(5);
            make.top.equalTo(section2).offset(10);
            make.size.mas_equalTo(CGSizeMake(WKScreenW-10,20));
        }];
        return section2;
    }
    else if(section == 4)
    {
        CGFloat height = 0;
            if(_OrderListType == notPayOrderType)
            {
                height = 60;
            }
            else if(_OrderListType == notSendOrderType)
            {
                height = 80;
            }
            else if(_OrderListType == notConfirmOrderType)
            {
                height = 80;//100;
            }
            else if(_OrderListType == haveConfirmOrderType)
            {
                height = 100;//125;
            }
            else if([_model.CurrentOrderStatus isEqualToString:@"已取消"])
            {
                height = 60;
            }

        UIView *headImageView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, WKScreenW, height)];
        headImageView.backgroundColor = [UIColor colorWithHex:0xF3F6FF];
        
        UIView *headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, WKScreenW, height)];
        headView.backgroundColor = [UIColor whiteColor];
        [headImageView addSubview:headView];
        
        UILabel *name = [[UILabel alloc] init];
        name.font = [UIFont systemFontOfSize:12];
        name.text = @"支付方式:";
        name.textAlignment = NSTextAlignmentLeft;
        name.textColor = [UIColor colorWithHex:0x7e879d];
        [headView addSubview:name];
        [name mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(headView).offset(5);
            make.top.equalTo(headView).offset(10);
            make.size.mas_equalTo(CGSizeMake(100, 20));
        }];
        
        UILabel *way = [[UILabel alloc] init];
        way.font = [UIFont systemFontOfSize:12];
        way.text = _model.PayTypeStr;
        way.textAlignment = NSTextAlignmentRight;
        way.textColor = [UIColor colorWithHex:0x7e879d];
        [headView addSubview:way];
        [way mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(headView.mas_right).offset(-15);
            make.top.equalTo(headView).offset(10);
            make.size.mas_equalTo(CGSizeMake(100, 20));
        }];

        UIView *xianView = [[UIView alloc] init];
        xianView.backgroundColor = [UIColor colorWithHex:0xF2F3F9];
        [headView addSubview:xianView];
        [xianView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(headView).offset(0);
            make.right.equalTo(headView.mas_right).offset(0);
            make.top.equalTo(way.mas_bottom).offset(5);
            make.height.mas_equalTo(1);
        }];
        
        UILabel *createTime = [[UILabel alloc] init];
        createTime.font = [UIFont systemFontOfSize:12];
        createTime.text = [NSString stringWithFormat:@"创建时间:%@",_model.CreateTime];
        createTime.textAlignment = NSTextAlignmentLeft;
        createTime.textColor = [UIColor colorWithHex:0x7e879d];
        [headView addSubview:createTime];
        [createTime mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(headView).offset(5);
            make.top.equalTo(xianView.mas_bottom).offset(0);
            make.size.mas_equalTo(CGSizeMake(200, 20));
        }];
        
        UILabel *payTime = [[UILabel alloc] init];
        payTime.font = [UIFont systemFontOfSize:12];
        payTime.text = [NSString stringWithFormat:@"付款时间:%@",_model.PayDate];
        payTime.textAlignment = NSTextAlignmentLeft;
        payTime.textColor = [UIColor colorWithHex:0x7e879d];
        [headView addSubview:payTime];
        [payTime mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(headView).offset(5);
            make.top.equalTo(createTime.mas_bottom).offset(0);
            make.size.mas_equalTo(CGSizeMake(200, 20));
        }];
        
        UILabel *receiveTime = [[UILabel alloc] init];
        receiveTime.font = [UIFont systemFontOfSize:12];
        receiveTime.text = [NSString stringWithFormat:@"收货时间:%@",_model.ShipDate];
        receiveTime.textAlignment = NSTextAlignmentLeft;
        receiveTime.textColor = [UIColor colorWithHex:0x7e879d];
        [headView addSubview:receiveTime];
        [receiveTime mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(headView).offset(5);
            make.top.equalTo(payTime.mas_bottom).offset(0);
            make.size.mas_equalTo(CGSizeMake(200, 20));
        }];
        
        UILabel *signTime = [[UILabel alloc] init];
        signTime.font = [UIFont systemFontOfSize:12];
        signTime.text = [NSString stringWithFormat:@"签收时间:%@",_model.HasBeenDate];
        signTime.textAlignment = NSTextAlignmentLeft;
        signTime.textColor = [UIColor colorWithHex:0x7e879d];
        [headView addSubview:signTime];
        [signTime mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(headView).offset(5);
            make.top.equalTo(receiveTime.mas_bottom).offset(0);
            make.size.mas_equalTo(CGSizeMake(200, 20));
        }];
        
           //待付款
            if([_model.CurrentOrderStatus isEqualToString:@"未支付"])
            {
                payTime.hidden = YES;
                receiveTime.hidden = YES;
                signTime.hidden = YES;
            }
            else if([_model.CurrentOrderStatus isEqualToString:@"待发货"])
            {
                receiveTime.hidden = YES;
                signTime.hidden = YES;
            }
            else if([_model.CurrentOrderStatus isEqualToString:@"已发货"])
            {
                receiveTime.hidden = YES;
                signTime.hidden = YES;
            }
            else if([_model.CurrentOrderStatus isEqualToString:@"已完成"])
            {
                receiveTime.text = [NSString stringWithFormat:@"签收时间:%@",_model.HasBeenDate];
                signTime.hidden = YES;
            }
            else if([_model.CurrentOrderStatus isEqualToString:@"已取消"])
            {
                payTime.hidden = YES;
                receiveTime.hidden = YES;
                signTime.hidden = YES;
            }
        
        return headImageView;
    }
    return  nil;
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section;
{
    if(section == 0)
    {
        return nil;
    }
    else if(section == 1)
    {
        UIView *section1 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, WKScreenW, 45)];
        section1.backgroundColor = [UIColor whiteColor];
        
        UILabel *number = [[UILabel alloc] init];
        number.font = [UIFont systemFontOfSize:12];
        number.text = [NSString stringWithFormat:@"共%ld件商品",(long)_model.GoodsCount];//@"共3件商品";
        number.textAlignment = NSTextAlignmentLeft;
        number.textColor = [UIColor colorWithHex:0x7e879d];
        [section1 addSubview:number];
        [number mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(section1).offset(5);
            make.top.equalTo(section1).offset(5);
            make.size.mas_equalTo(CGSizeMake(WKScreenW-10, 20));
        }];
        number.hidden = YES;
        
        UILabel *money = [[UILabel alloc] init];
        money.font = [UIFont systemFontOfSize:12];
        money.text = [NSString stringWithFormat:@"合计￥%.2f",[_model.PayAmount floatValue]];
        money.textAlignment = NSTextAlignmentLeft;
        money.textColor = [UIColor colorWithHex:0x7e879d];
        [section1 addSubview:money];
        [money mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(section1).offset(5);
            make.top.equalTo(number.mas_bottom).offset(0);
            make.size.mas_equalTo(CGSizeMake(200, 20));
        }];
        
        if(_type == 1)
        {
            if(_OrderListType == notPayOrderType)
            {
                UIImage *editImage = [UIImage imageNamed:@"edit"];
                UIButton *fixBtn = [[UIButton alloc] init];
                fixBtn.tag = section;
                [fixBtn setTitle:@"修改" forState:UIControlStateNormal];
                [fixBtn setTitleColor:[UIColor colorWithHex:0xC8CAD3] forState:UIControlStateNormal];
                fixBtn.titleLabel.font = [UIFont systemFontOfSize:12];
                [fixBtn setImage:editImage forState:UIControlStateNormal];
                [fixBtn addTarget:self action:@selector(fixEvent:) forControlEvents:UIControlEventTouchUpInside];
                [section1 addSubview:fixBtn];
                [fixBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.right.equalTo(section1.mas_right).offset(-5);
                    make.top.equalTo(number.mas_bottom).offset(0);
                    make.size.mas_equalTo(CGSizeMake(editImage.size.width+45,editImage.size.height));
                }];
            }
        }
        UIView *xianView = [[UIView alloc] init];
        xianView.backgroundColor = [UIColor colorWithHex:0xDFDFE1];
        [section1 addSubview:xianView];
        [xianView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(section1).offset(0);
            make.right.equalTo(section1.mas_right).offset(0);
            make.top.equalTo(money.mas_bottom).offset(10);
            make.height.mas_equalTo(1);
        }];
        
        UIButton *attentionBtn = [[UIButton alloc] init];
        attentionBtn.layer.masksToBounds = YES;
        attentionBtn.layer.cornerRadius = 4.0;
        attentionBtn.layer.borderColor = [[UIColor colorWithHex:0xFFD9B1] CGColor];
        attentionBtn.layer.borderWidth = 1.0;
        [attentionBtn setTitle:@"联系买家" forState:UIControlStateNormal];
        [attentionBtn setTitleColor:[UIColor colorWithHex:0x83868B] forState:UIControlStateNormal];
        [attentionBtn addTarget:self action:@selector(attentionEvent) forControlEvents:UIControlEventTouchUpInside];
        [section1 addSubview:attentionBtn];
        [attentionBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(section1).offset(10);
            make.right.equalTo(section1.mas_right).offset(-10);
            make.top.equalTo(xianView.mas_bottom).offset(15);
            make.height.mas_equalTo(35);
        }];
        

        return section1;
    }
    else if(section == 2 || section == 3)
    {
        return nil;
    }
    else if(section == 4)
    {
        UIView *section4 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, WKScreenW, 60/(WKScaleH))];
        section4.backgroundColor = [UIColor colorWithHex:0xF3F6FF];
//        section4.backgroundColor = [UIColor purpleColor];
        
        UIButton *sendBtn = [[UIButton alloc] init];
        [sendBtn setTitle:@"线下支付" forState:UIControlStateNormal];
        [sendBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        sendBtn.backgroundColor = [UIColor colorWithHex:0xF0611E];
        [sendBtn addTarget:self action:@selector(sendEvent:) forControlEvents:UIControlEventTouchUpInside];
        [section4 addSubview:sendBtn];
        [sendBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(section4).offset(0);
            make.right.equalTo(section4.mas_right).offset(0);
            make.top.equalTo(section4).offset(5);
        }];
        
        if(_type == 1)//普通商品
        {
            //待付款
            if([_model.CurrentOrderStatus isEqualToString:@"未支付"])
            {
                [sendBtn setTitle:@"线下支付" forState:UIControlStateNormal];
            }
            else if([_model.CurrentOrderStatus isEqualToString:@"待发货"])
            {
                [sendBtn setTitle:@"发货" forState:UIControlStateNormal];
            }
            else if([_model.CurrentOrderStatus isEqualToString:@"已发货"])
            {
                section4.hidden = YES;
            }
            else if([_model.CurrentOrderStatus isEqualToString:@"已完成"])
            {
                sendBtn.hidden = YES;
                section4.backgroundColor = [UIColor whiteColor];
                UIButton *removeBtn = [[UIButton alloc] init];
                removeBtn.titleLabel.font = [UIFont systemFontOfSize:14];
                [removeBtn setTitle:@"删除订单" forState:UIControlStateNormal];
                [removeBtn setTitleColor:[UIColor colorWithHex:0xC8CAD3] forState:UIControlStateNormal];
                [removeBtn addTarget:self action:@selector(removeEvent) forControlEvents:UIControlEventTouchUpInside];
                [section4 addSubview:removeBtn];
                [removeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.equalTo(section4).offset(0);
                    make.top.equalTo(section4).offset((45-20)/2);
                    make.size.mas_equalTo(CGSizeMake(70, 20));
                }];
            }
            else if([_model.CurrentOrderStatus isEqualToString:@"已取消"])
            {
//                section4.hidden = YES;
                sendBtn.hidden = YES;
                section4.backgroundColor = [UIColor whiteColor];
                UIButton *removeBtn = [[UIButton alloc] init];
                removeBtn.titleLabel.font = [UIFont systemFontOfSize:14];
                [removeBtn setTitle:@"删除订单" forState:UIControlStateNormal];
                [removeBtn setTitleColor:[UIColor colorWithHex:0xC8CAD3] forState:UIControlStateNormal];
                [removeBtn addTarget:self action:@selector(removeEvent) forControlEvents:UIControlEventTouchUpInside];
                [section4 addSubview:removeBtn];
                [removeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.equalTo(section4).offset(0);
                    make.top.equalTo(section4).offset((45-20)/2);
                    make.size.mas_equalTo(CGSizeMake(70, 20));
                }];
            }
        }
        else
        {
//            NSString *hour = [NSString stringWithFormat:@"%ld",_model.RemainTime%3600];
            NSString *min = [NSString stringWithFormat:@"%ld",(_model.RemainTime%3600)/60];
            NSString *sec = [NSString stringWithFormat:@"%ld",_model.RemainTime%60];
            //待付款
            if([_model.CurrentOrderStatus isEqualToString:@"未支付"])
            {
                if(_model.RemainTime <= 60)
                {
                    [sendBtn setTitle:[NSString stringWithFormat:@"支付倒计时 %@s",sec] forState:UIControlStateNormal];
                }
                else
                {
                    [sendBtn setTitle:[NSString stringWithFormat:@"支付倒计时 %@min",min] forState:UIControlStateNormal];
                }
                sendBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
                sendBtn.backgroundColor = [UIColor whiteColor];
                [sendBtn setTitleColor:[UIColor colorWithHex:0x8B8F99] forState:UIControlStateNormal];
                sendBtn.titleLabel.font = [UIFont systemFontOfSize:14];
            }
            else if([_model.CurrentOrderStatus isEqualToString:@"待发货"])
            {
                 [sendBtn setTitle:@"发货" forState:UIControlStateNormal];
            }
            else if([_model.CurrentOrderStatus isEqualToString:@"已发货"])
            {
                section4.hidden = YES;
            }
            else if([_model.CurrentOrderStatus isEqualToString:@"已完成"] || [_model.CurrentOrderStatus isEqualToString:@"已取消"])
            {
                sendBtn.hidden = YES;
                section4.backgroundColor = [UIColor whiteColor];
                UIButton *removeBtn = [[UIButton alloc] init];
                removeBtn.titleLabel.font = [UIFont systemFontOfSize:14];
                [removeBtn setTitle:@"删除订单" forState:UIControlStateNormal];
                [removeBtn setTitleColor:[UIColor colorWithHex:0xC8CAD3] forState:UIControlStateNormal];
                [removeBtn addTarget:self action:@selector(removeEvent) forControlEvents:UIControlEventTouchUpInside];
                [section4 addSubview:removeBtn];
                [removeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.equalTo(section4).offset(0);
                    make.top.equalTo(section4).offset((45-20)/2);
                    make.size.mas_equalTo(CGSizeMake(70, 20));
                }];
            }
        }
        
        return section4;
    }
    return nil;
}

//联系买家
-(void)attentionEvent
{
    NSString *url = [NSString configUrl:WKFollow With:@[@"SetType",@"FollowBPOID"] values:@[@"1",self.model.CustomerBPOID]];
    
    [WKHttpRequest getFollowAndNot:HttpRequestMethodPost url:url model:nil param:nil success:^(WKBaseResponse *response) {
        WKMessageTalkViewController *messageTalkVc = [[WKMessageTalkViewController alloc] init];
        messageTalkVc.conversationType = ConversationType_PRIVATE;
        messageTalkVc.title = self.model.CustomerName;
        messageTalkVc.targetId = self.model.CustomerBPOID;
        [[self viewControllerWith:self].navigationController pushViewController:messageTalkVc animated:YES];

    } failure:^(WKBaseResponse *response) {
        [WKProgressHUD showTopMessage:response.ResultMessage];
    }];
}



-(void)fixEvent:(UIButton *)sender
{
    if(_sendCallBack)
    {
        _sendCallBack(4,sender.tag);
    }
}

-(void)goEvent
{
    if(_sendCallBack)
    {
        _sendCallBack(2,-1);
    }
}

-(void)sendEvent:(UIButton *)sender
{
    if([sender.titleLabel.text isEqualToString:@"发货"])//发货
    {
        if(_sendCallBack)
        {
            _sendCallBack(1,-1);
        }
    }
    else if([sender.titleLabel.text isEqualToString:@"线下支付"] && _OrderListType == notPayOrderType)//线下支付
    {
        if(_sendCallBack)
        {
            _sendCallBack(7,-2);
        }
    }
}

-(void)removeEvent
{
    if(_sendCallBack)
    {
        _sendCallBack(8,-3);
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
