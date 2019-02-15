//  WKCustomDetailsView.m
//  客户详情页面
//  Created by Zhaohl on 16/10/10.
//  Copyright © 2016年 walkingtec. All rights reserved.

#import "WKCustomDetailsView.h"
#import "WKCustomDetailsTableViewCell.h"

@implementation WKCustomDetailsView

-(instancetype)initWithFrame:(CGRect)frame
{
    if (self =[super initWithFrame:CGRectMake(0, 35, frame.size.width, frame.size.height)])
    {
        self.isOpenHeaderRefresh = YES;
        self.isOpenFooterRefresh = YES;
        self.tableView.showsVerticalScrollIndicator = NO;
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [self.tableView initWithFrame:frame style:UITableViewStyleGrouped];
        self.backgroundColor = [UIColor colorWithHexString:@"f3f6ff"];
    }
    return self;
}

//使用TableView的代理
#pragma mark tableView Dategate

//定义一个Section有几个Cell
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if(section == 0){
        return 0.1;
    }
    
    self.orderModel = self.CustomerOrderModel.InnerList[section-1];
    NSInteger CellCount = self.orderModel.Products.count;
    return CellCount;
}

//一个TableView有几个Section
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    NSInteger SectionCount =  self.CustomerOrderModel.InnerList.count;
    return SectionCount + 1;
}

//设置Cell的样式
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    WKCustomDetailsTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"CELL"];
    if (!cell) {
        cell = [[WKCustomDetailsTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"CELL"];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    WKCustomerListOrder *listOrder = self.CustomerOrderModel.InnerList[indexPath.section-1];
    cell.model= listOrder.Products[indexPath.row];
    return cell;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    //创建一个背景View
    UIView *backView = [[UIView alloc]init];
    backView.backgroundColor = [UIColor whiteColor];
    
    //头部的Section，第一个
    if(section == 0)
    {
        //在背景上添加头像
        UIImageView *imageView = [[UIImageView alloc]init];
        [imageView sd_setImageWithURL:[NSURL URLWithString:self.customModel.MemberMinPhoto] placeholderImage:[UIImage imageNamed:@"guanzhu"]];
        imageView.layer.cornerRadius = 55/2.0f;
        imageView.layer.borderColor = [UIColor whiteColor].CGColor;
        imageView.layer.borderWidth = 1;
        imageView.layer.masksToBounds = YES;
        [backView addSubview:imageView];
        [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(backView.mas_centerX);
            make.top.equalTo(backView).offset(10);
            make.size.sizeOffset(CGSizeMake(55, 55));
        }];

        NSString *levelName = [NSString stringWithFormat:@"dengji_%@",self.customModel.MemberLevel];
        UIImageView *levelView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:levelName]];
        [backView addSubview:levelView];
        [levelView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(backView).offset(65 - levelView.image.size.width - 1);
            make.left.equalTo(backView.mas_left).offset(WKScreenW * 0.5 + 55 * 0.5 - levelView.image.size.width - 1);
            //make.size.sizeOffset(CGSizeMake(15, 15));
        }];
        
        //添加昵称和性别
        UILabel *lblName = [[UILabel alloc]init];
        lblName.text = self.customModel.MemberName;
        lblName.textAlignment = NSTextAlignmentCenter;
        lblName.font = [UIFont systemFontOfSize:13];
        lblName.textColor = [UIColor colorWithHexString:@"7e879d"];
        CGSize nameSize = [lblName.text sizeOfStringWithFont:[UIFont systemFontOfSize:13] withMaxSize:CGSizeMake(MAXFLOAT, 13)];
        [backView addSubview:lblName];
        
        CGFloat genderWith =  self.customModel.Sex.integerValue == 0 ? 0 : 15;
        [lblName mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(imageView.mas_bottom).offset(10);
            make.left.equalTo(backView.mas_left).offset((WKScreenW -( nameSize.width + genderWith))/2); //昵称和性别图标的动态计算居中
            make.size.sizeOffset(CGSizeMake(nameSize.width+2, 14));
        }];

        NSString *gender = @"";
        if(self.customModel.Sex.integerValue == 1){
            gender = @"sex_male";
        }else if(self.customModel.Sex.integerValue == 2){
            gender = @"sex_female";
        }
        UIImageView *genderView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:gender]];
        [backView addSubview:genderView];
        [genderView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(lblName.mas_centerY);
            make.left.equalTo(lblName.mas_right).offset(10);
        }];
        
        //认证文字
        UILabel *lblShop = [[UILabel alloc]init];
        lblShop.text = self.customModel.ShopAuthenticationStatus.integerValue==1? @"实体店认证":@"非实体店";
        lblShop.textAlignment = NSTextAlignmentCenter;
        lblShop.textColor = [UIColor colorWithHexString:@"7e897d"];
        lblShop.font = [UIFont systemFontOfSize:11];
        CGSize shopSize = [lblShop.text sizeOfStringWithFont:[UIFont systemFontOfSize:11] withMaxSize:CGSizeMake(MAXFLOAT, 12)];
        [backView addSubview:lblShop];
        
        //认证图标
        UIImageView *shopView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:self.customModel.ShopAuthenticationStatus.integerValue == 1? @"renzheng":@"renzheng_def"]];
        [backView addSubview:shopView];
        [shopView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(lblName.mas_bottom).offset(10);
            make.right.equalTo(lblShop.mas_left).offset(-2);
            make.size.sizeOffset(CGSizeMake(12, 14));
        }];

        //添加地理位置，实体店认证
        UILabel *lblLocation = [[UILabel alloc]init];
        lblLocation.text = self.customModel.Location.length == 0 ? @"火星" : self.customModel.Location;
        lblLocation.textAlignment = NSTextAlignmentCenter;
        lblLocation.font = [UIFont systemFontOfSize:13];
        lblLocation.textColor = [UIColor colorWithHexString:@"7e897d"];
        CGSize locationSize = [lblLocation.text sizeOfStringWithFont:[UIFont systemFontOfSize:13] withMaxSize:CGSizeMake(MAXFLOAT, 14)];
        [backView addSubview:lblLocation];
        [lblLocation mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(lblName.mas_bottom).offset(10);
            make.right.equalTo(shopView.mas_left).offset(-10);
            make.size.sizeOffset(CGSizeMake(locationSize.width + 2, 14));
        }];
        
        [lblShop mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(lblName.mas_bottom).offset(10);
            make.right.equalTo(backView.mas_right).offset(-(WKScreenW - (locationSize.width + shopSize.width + 13))/2);
            make.size.sizeOffset(CGSizeMake(shopSize.width, 12));
        }];

        //添加横线
        UIView *line = [[UIView alloc]init];
        line.backgroundColor = [UIColor colorWithHexString:@"dae0ed"];
        [backView addSubview:line];
        [line mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(lblLocation.mas_bottom).offset(10);
            make.size.sizeOffset(CGSizeMake(WKScreenW, 1));
        }];

        //添加购买，打赏，积分记录
        for (int i = 0; i< 3; i++) {
            UILabel *labelButton = [[UILabel alloc]init];
            if(i == 0){
                labelButton.text = self.customModel.OrderCount;
            }else if(i == 1){
                labelButton.text = self.customModel.RewardCount;
            }else{
                labelButton.text = self.customModel.TotalPoint;
            }
            labelButton.textAlignment = NSTextAlignmentCenter;
            labelButton.textColor = [UIColor colorWithHexString:@"7e897d"];
            labelButton.font = [UIFont systemFontOfSize:13];
            [backView addSubview:labelButton];
            [labelButton mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(line.mas_bottom).offset(10);
                make.left.equalTo(backView.mas_left).offset(WKScreenW*0.33*i);
                make.size.sizeOffset(CGSizeMake(WKScreenW * 0.33, 14));
            }];
            
            UILabel *labelText = [[UILabel alloc]init];
            if(i == 0){
                labelText.text = @"购买";
            }else if(i == 1){
                labelText.text = @"红包";
            }else{
                labelText.text = @"积分";
            }
            labelText.textAlignment = NSTextAlignmentCenter;
            labelText.textColor = [UIColor colorWithHexString:@"7e897d"];
            labelText.font = [UIFont systemFontOfSize:13];
            [backView addSubview:labelText];
            [labelText mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(labelButton.mas_bottom).offset(5);
                make.left.equalTo(backView.mas_left).offset(WKScreenW*0.33*i);
                make.size.sizeOffset(CGSizeMake(WKScreenW * 0.33, 14));
            }];
        }

        //显示分割区
        UIView *OrderView = [[UIView alloc]init];
        OrderView.backgroundColor = [UIColor colorWithHexString:@"f3f6ff"];
        [backView addSubview:OrderView];
        [OrderView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(line.mas_bottom).offset(50);
            make.size.sizeOffset(CGSizeMake(WKScreenW, 40));
        }];

        UILabel *lblOrder = [[UILabel alloc]init];
        lblOrder.text = @"订单信息";
        lblOrder.textColor = [UIColor colorWithHexString:@"7e897d"];
        lblOrder.font = [UIFont systemFontOfSize:13];
        [OrderView addSubview:lblOrder];
        [lblOrder mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(OrderView.mas_centerY);
            make.left.equalTo(OrderView.mas_left).offset(10);
            make.size.sizeOffset(CGSizeMake(WKScreenW, 14));
        }];
    }
    else{
        WKCustomerListOrder *listOrder = self.CustomerOrderModel.InnerList[section - 1];
        
        UILabel *lblOrderCode = [[UILabel alloc]init];
        lblOrderCode.text = [NSString stringWithFormat:@"订单编号：%@",listOrder.OrderCode];
        lblOrderCode.textColor = [UIColor colorWithHexString:@"7e897d"];
        lblOrderCode.font = [UIFont systemFontOfSize:13];
        [backView addSubview:lblOrderCode];
        [lblOrderCode mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(backView.mas_centerY);
            make.left.equalTo(backView.mas_left).offset(10);
            make.size.sizeOffset(CGSizeMake(WKScreenW*0.6, 14));
        }];
        
        UILabel *lblOrderStatus = [[UILabel alloc]init];
        lblOrderStatus.text = listOrder.CurrentOrderStatus;
        lblOrderStatus.textAlignment = NSTextAlignmentRight;
        lblOrderStatus.textColor = [UIColor orangeColor];
        lblOrderStatus.font = [UIFont systemFontOfSize:13];
        [backView addSubview:lblOrderStatus];
        [lblOrderStatus mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(backView.mas_centerY);
            make.right.equalTo(backView.mas_right).offset(-15);
            make.size.sizeOffset(CGSizeMake(WKScreenW*0.3, 14));
        }];
    }
    
    return backView;
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView *footView = [[UIView alloc]init];
    footView.backgroundColor = [UIColor whiteColor];
    
    if(section >0)
    {
        self.orderModel = self.CustomerOrderModel.InnerList[section - 1];
        
        UILabel *lblDes = [[UILabel alloc]init];
        lblDes.font = [UIFont systemFontOfSize:13];
        lblDes.textAlignment = NSTextAlignmentRight;
        lblDes.textColor = [UIColor colorWithHexString:@"7e897d"];
        
        //如果是拍卖订单
        NSString *payAmount = @"";
        if(self.orderModel.OrderType.integerValue == 2)
        {
            payAmount = [NSString stringWithFormat:@"%0.2f",self.orderModel.GoodsAmount.floatValue];
        }
        else
        {
            payAmount = [NSString stringWithFormat:@"%0.2f",self.orderModel.PayAmount.floatValue];
        }
        
        NSString *orderStr = @"";
        if(self.orderModel.TranFeeAmount.floatValue == 0 )
        {
            orderStr = [NSString stringWithFormat:@"合计￥%@",payAmount];
        }
        else
        {
            orderStr = [NSString stringWithFormat:@"合计￥%@（含运费￥%0.2f）",payAmount,self.orderModel.TranFeeAmount.floatValue];
        }
        NSMutableAttributedString *attributedStr01 = [[NSMutableAttributedString alloc] initWithString: orderStr];
        [attributedStr01 addAttribute: NSFontAttributeName value: [UIFont systemFontOfSize: 16] range: NSMakeRange(3, payAmount.length)];
        lblDes.attributedText = attributedStr01;
        [footView addSubview:lblDes];
        [lblDes mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(footView.mas_top).offset(15);
            make.right.equalTo(footView.mas_right).offset(-10);
            make.size.sizeOffset(CGSizeMake(WKScreenW, 14));
        }];
        
        UIView *line = [[UIView alloc]init];
        line.backgroundColor = [UIColor colorWithHexString:@"dae0ed"];
        [footView addSubview:line];
        [line mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(lblDes.mas_bottom).offset(15);
            make.size.sizeOffset(CGSizeMake(WKScreenW, 1));
        }];
        
        UILabel *lblTel = [[UILabel alloc]init];
        lblTel.text = @"联系电话";
        lblTel.textColor = [UIColor colorWithHexString:@"7e897d"];
        lblTel.font = [UIFont systemFontOfSize: 13];
        [footView addSubview: lblTel];
        [lblTel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(line.mas_bottom).offset(15);
            make.left.equalTo(footView.mas_left).offset(10);
            make.size.sizeOffset(CGSizeMake(70, 14));
        }];
        
        UILabel *telValue = [[UILabel alloc]init];
        telValue.text = self.orderModel.ShipPhone;
        telValue.textColor = [UIColor colorWithHexString:@"7e897d"];
        telValue.font = [UIFont systemFontOfSize: 13];
        [footView addSubview: telValue];
        [telValue mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(line.mas_bottom).offset(15);
            make.left.equalTo(lblTel.mas_right).offset(10);
            make.size.sizeOffset(CGSizeMake(WKScreenW*0.4, 14));
        }];
        
        UILabel *lblAddress = [[UILabel alloc]init];
        lblAddress.text = @"收货地址";
        lblAddress.textColor = [UIColor colorWithHexString:@"7e897d"];
        lblAddress.font = [UIFont systemFontOfSize: 13];
        [footView addSubview: lblAddress];
        [lblAddress mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(lblTel.mas_bottom).offset(15);
            make.left.equalTo(footView.mas_left).offset(10);
            make.size.sizeOffset(CGSizeMake(70, 14));
        }];
        
        UILabel *addressValue = [[UILabel alloc]init];
        addressValue.text = self.orderModel.ShipAddress;
        addressValue.textColor = [UIColor colorWithHexString:@"7e897d"];
        addressValue.font = [UIFont systemFontOfSize: 13];
        [footView addSubview: addressValue];
        [addressValue mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(lblTel.mas_bottom).offset(15);
            make.left.equalTo(lblAddress.mas_right).offset(10);
            make.size.sizeOffset(CGSizeMake(WKScreenW - 70, 14));
        }];
        
        UIView *timeView = [[UIView alloc]init];
        timeView.backgroundColor = [UIColor colorWithHexString:@"f3f6ff"];
        [footView addSubview:timeView];
        [timeView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(lblAddress.mas_bottom).offset(15);
            make.size.sizeOffset(CGSizeMake(WKScreenW, 35));
        }];
        
        NSString *strTime = @"";
        if([self.orderModel.CurrentOrderStatus isEqualToString:@"未支付"]){
            strTime = self.orderModel.CreateTime;
        }else if([self.orderModel.CurrentOrderStatus isEqualToString:@"待发货"]){
            strTime = self.orderModel.PayDate;
        }else if([self.orderModel.CurrentOrderStatus isEqualToString:@"已完成"]){
            strTime = self.orderModel.HasBeenDate;
        }
        
        UILabel *lbltime = [[UILabel alloc]init];
        lbltime.text = strTime;
        lbltime.textColor = [UIColor colorWithHexString:@"7e897d"];
        lbltime.textAlignment = NSTextAlignmentRight;
        lbltime.font = [UIFont systemFontOfSize:11];
        [timeView addSubview:lbltime];
        [lbltime mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(timeView.mas_centerY);
            make.right.equalTo(timeView.mas_right).offset(-10);
            make.size.sizeOffset(CGSizeMake(WKScreenW, 12));
        }];

        
    }
    
    return  footView;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 90;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if(section ==0){
        return 0.1;
    }
    return 153;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if(section == 0){
        return 213;
    }else{
        return 45;
    }
}

-(void)headerRequestWithData{
    if (self.headBlock) {
        self.headBlock();
    }
}
-(void)footerRequestWithData{
    if (self.footBlock) {
        self.footBlock();
    }
}

@end
