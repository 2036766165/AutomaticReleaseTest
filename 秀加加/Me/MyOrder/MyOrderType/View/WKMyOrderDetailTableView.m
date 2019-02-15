//
//  WKMyOrderDetailTableView.m
//  秀加加
//
//  Created by lin on 2016/9/28.
//  Copyright © 2016年 walkingtec. All rights reserved.
//

#import "WKMyOrderDetailTableView.h"
#import "WKOrderDetailTableViewCell.h"
#import "NSString+Size.h"
#import "UIImage+Gif.h"
#import "WKShowInputView.h"

@interface WKMyOrderDetailTableView()

@property (nonatomic,strong) UIButton *attentionBtn;

@end

@implementation WKMyOrderDetailTableView

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
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(section == 0)
    {
        return 0;
    }
    else if(section == 1)
    {
        return 0;
    }
    else if(section == 2)
    {
        return  self.dataArray.count;
    }
    else if(section == 3)
    {
        return 0;
    }
    else if(section == 4)
    {
        return 0;
    }
    return 0;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 5;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 85;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if(section == 0)
    {
        return 90;
    }
    else if(section == 1)
    {
        if(_type == 2 && ([_model.CurrentOrderStatus isEqualToString:@"已取消"] || [_model.CurrentOrderStatus isEqualToString:@"待付款"]))
        {
            return 0.1;
        }
        else{
            return 80;
        }
    }
    else if(section == 2)
    {
        return 50;
    }
    else if(section == 3)//支付方式进行选择(不区分商品和拍卖)
    {
        if(_OrderListType == notPayOrderType)
        {
            return 40+ 30;
        }
        else if(_OrderListType == notSendOrderType)
        {
            return 40+ 30*2;
        }
        else if(_OrderListType == notConfirmOrderType)
        {
            return 40+30*2;
        }
        else if(_OrderListType == notEvaluateOrderType)
        {
            return 40+30*3;
        }
        else if([_model.CurrentOrderStatus isEqualToString:@"已取消"])
        {
            return 40+ 30;
        }
        else if([_model.CurrentOrderStatus isEqualToString:@"待发货"])
        {
            return 40+ 30*2;
        }
    }
    else if(section == 4)
    {
        return 70/(WKScaleW);
    }
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if(section == 2)
    {
        return 105;
    }
    return 0.1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 2) {
        NSString *cellIdentifier = @"cell";
        WKOrderDetailTableViewCell  *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if(!cell)
        {
            cell = [[WKOrderDetailTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        }
        [cell setItem:self.dataArray[indexPath.row] model:_model type:_model.OrderType];
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    return nil;
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *backgroundView = [[UIView alloc] init];
    backgroundView.backgroundColor = [UIColor colorWithHex:0xF3F6FF];
    
    if(section == 0)
    {
        backgroundView.frame = CGRectMake(0, 0, WKScreenW, 90);
        UIView *section0View = [[UIView alloc] init];
        section0View.backgroundColor = [UIColor whiteColor];
        [backgroundView addSubview:section0View];
        [section0View mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(backgroundView).offset(0);
            make.right.equalTo(backgroundView.mas_right).offset(0);
            make.top.equalTo(backgroundView).offset(5);
            make.bottom.equalTo(backgroundView.mas_bottom).offset(0);
        }];
        
        UILabel *name = [[UILabel alloc] init];
        name.font = [UIFont systemFontOfSize:14];
        name.text = [NSString stringWithFormat:@"订单号:%@",_model.OrderCode];
        name.textColor = [UIColor colorWithHex:0x82858E];
        name.textAlignment = NSTextAlignmentLeft;
        [section0View addSubview:name];
        [name mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(backgroundView).offset(10);
            make.top.equalTo(backgroundView).offset(10);
            make.size.mas_equalTo(CGSizeMake(250, 20));
        }];
        
        UILabel *status = [[UILabel alloc] init];
        status.font = [UIFont systemFontOfSize:14];
        status.text = _model.CurrentOrderStatus;
        status.textColor = [UIColor colorWithHex:0xFFAE75];
        status.textAlignment = NSTextAlignmentRight;
        [section0View addSubview:status];
        [status mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(backgroundView.mas_right).offset(-10);
            make.top.equalTo(backgroundView).offset(10);
            make.size.mas_greaterThanOrEqualTo(CGSizeMake(60, 20));
        }];
        
        UIView *xianView = [[UIView alloc] init];
        xianView.backgroundColor = [UIColor colorWithHex:0xDEDFE1];
        [section0View addSubview:xianView];
        [xianView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(backgroundView).offset(0);
            make.right.equalTo(backgroundView.mas_right).offset(0);
            make.top.equalTo(name.mas_bottom).offset(10);
            make.height.mas_equalTo(1);
        }];
        
        //地址详情
        UIImageView *dowmView = [[UIImageView alloc] init];
        dowmView.userInteractionEnabled = YES;
        UITapGestureRecognizer *gestureAddress = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(addressGestureEvent)];
        [dowmView addGestureRecognizer:gestureAddress];
        [section0View addSubview:dowmView];
        [dowmView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(section0View).offset(0);
            make.right.equalTo(section0View.mas_right).offset(0);
            make.top.equalTo(xianView.mas_bottom).offset(15);
            make.bottom.equalTo(section0View.mas_bottom).offset(0);
        }];
        
        UIImage *carImage = [UIImage imageNamed:@"notReceive_normal"];
        UIImage *goImage = [UIImage imageNamed:@"go"];
        UIButton *carbtn = [[UIButton alloc] init];
        [carbtn setImage:carImage forState:UIControlStateNormal];
        carbtn.userInteractionEnabled = NO;
        carbtn.showsTouchWhenHighlighted = NO;
        [dowmView addSubview:carbtn];
        [carbtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(dowmView).offset(10);
            make.top.equalTo(dowmView).offset(0);
            make.size.mas_equalTo(CGSizeMake(carImage.size.width, carImage.size.height));
        }];
        
        UILabel *title = [[UILabel alloc] init];
        title.font = [UIFont systemFontOfSize:14];
        if([_model.ExpressDetail isEqualToString:@""] || _model.ExpressDetail.length <= 0)
        {
            title.text = @"暂无物流信息";
        }
        else
        {
            title.text = _model.ExpressDetail;//@"地址是：";
            UIButton *goBtn = [[UIButton alloc] init];
            [goBtn setImage:goImage forState:UIControlStateNormal];
            [goBtn addTarget:self action:@selector(logisticsEvent) forControlEvents:UIControlEventTouchUpInside];
            [section0View addSubview:goBtn];
            [goBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.right.equalTo(dowmView.mas_right).offset(-10);
                make.top.equalTo(dowmView).offset(5);
                make.size.mas_equalTo(CGSizeMake(goImage.size.width, goImage.size.height));
            }];
        }
        title.textColor = [UIColor colorWithHex:0x81858E];
        title.textAlignment = NSTextAlignmentLeft;
        [dowmView addSubview:title];
        [title mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(carbtn.mas_right).offset(10);
            make.top.equalTo(dowmView).offset(0);
            make.size.mas_equalTo(CGSizeMake(WKScreenW-carImage.size.width-10-10-10-10-goImage.size.width, 20));
        }];

    }
    else if(section == 1)
    {
        backgroundView.frame = CGRectMake(0, 0, WKScreenW, 80);
        UIView *section1View = [[UIView alloc] init];
        section1View.backgroundColor = [UIColor whiteColor];
        [backgroundView addSubview:section1View];
        [section1View mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(backgroundView).offset(0);
            make.right.equalTo(backgroundView.mas_right).offset(0);
            make.top.equalTo(backgroundView).offset(5);
            make.bottom.equalTo(backgroundView.mas_bottom).offset(0);
        }];
        
        UILabel *name = [[UILabel alloc] init];
        name.font = [UIFont systemFontOfSize:14];
        name.text = [NSString stringWithFormat:@"%@ %@",_model.ShipName,_model.ShipPhone];
        name.textColor = [UIColor colorWithHex:0x82858E];
        name.textAlignment = NSTextAlignmentLeft;
        [section1View addSubview:name];
        [name mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(backgroundView).offset(10);
            make.top.equalTo(backgroundView).offset(20);
            make.size.mas_equalTo(CGSizeMake(WKScreenW-20, 20));
        }];
        
        UIImage *addressImage = [UIImage imageNamed:@"address"];
        UIButton *addressbtn = [[UIButton alloc] init];
        [addressbtn setImage:addressImage forState:UIControlStateNormal];
        addressbtn.userInteractionEnabled = NO;
        addressbtn.showsTouchWhenHighlighted = NO;
        [section1View addSubview:addressbtn];
        [addressbtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(backgroundView).offset(10);
            make.top.equalTo(name.mas_bottom).offset(15);
            make.size.mas_equalTo(CGSizeMake(addressImage.size.width, addressImage.size.height));
        }];
        
        UILabel *title = [[UILabel alloc] init];
        title.font = [UIFont systemFontOfSize:14];
        title.text = [NSString stringWithFormat:@"%@%@%@%@",_model.ShipProvince,_model.ShipCity,_model.ShipCounty,_model.ShipAddress];
        title.textColor = [UIColor colorWithHex:0x81858E];
        title.textAlignment = NSTextAlignmentLeft;
        [section1View addSubview:title];
        [title mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(addressbtn.mas_right).offset(10);
            make.top.equalTo(name.mas_bottom).offset(10);
            make.size.mas_equalTo(CGSizeMake(WKScreenW-20-addressImage.size.width, 20));
        }];
        if(_type == 2)
        {
            if([_model.CurrentOrderStatus isEqualToString:@"待付款"] || [_model.CurrentOrderStatus isEqualToString:@"已取消"])
            {
                return nil;
            }
        }
    }
    else if(section == 2)
    {
        backgroundView.frame = CGRectMake(0, 0, WKScreenW, 50);
        backgroundView.backgroundColor = [UIColor colorWithHex:0xF4F6FD];
        
        
        UIView *centerView = [[UIView alloc] init];
        centerView.backgroundColor = [UIColor whiteColor];
        [backgroundView addSubview:centerView];
        [centerView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(backgroundView).offset(0);
            make.right.equalTo(backgroundView.mas_right).offset(0);
            make.top.equalTo(backgroundView).offset(10);
            make.height.mas_equalTo(40);
        }];
        
        UIImage *titleImage = [UIImage imageNamed:@"default_03"];
        UIImageView *titleImageView = [[UIImageView alloc] init];
        titleImageView.layer.cornerRadius = titleImage.size.height/2;
        titleImageView.layer.masksToBounds = YES;
        titleImageView.layer.borderColor = [[UIColor colorWithHex:0xD97C39] CGColor];
        titleImageView.layer.borderWidth = 1.0;
//        [titleImageView sd_setImageWithURL:[NSURL URLWithString:_model.CustomerPicUrl] placeholderImage:[UIImage imageNamed:@"default_03"]];
        [titleImageView sd_setImageWithURL:[NSURL URLWithString:_model.ShopOwnerPicUrl] placeholderImage:[UIImage imageNamed:@"default_03"]];
        titleImageView.layer.cornerRadius = titleImage.size.height/2;
        titleImageView.layer.masksToBounds = YES;
        [centerView addSubview:titleImageView];
        [titleImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(backgroundView).offset(10);
            make.top.equalTo(backgroundView).offset(10+(40-titleImage.size.height)/2);
            make.size.mas_equalTo(CGSizeMake(titleImage.size.width, titleImage.size.height));
        }];
        
        
        UILabel *name = [[UILabel alloc] init];
        name.font = [UIFont systemFontOfSize:14];
//        CGSize nameSize = [_model.CustomerName sizeOfStringWithFont:[UIFont boldSystemFontOfSize:14] withMaxSize:CGSizeMake(MAXFLOAT, 20)];
//        CGSize nameSize = [_model.ShopOwnerName sizeOfStringWithFont:[UIFont boldSystemFontOfSize:14] withMaxSize:CGSizeMake(MAXFLOAT, 20)];
        CGSize nameSize = [_model.ShopOwnerName sizeOfStringWithFont:[UIFont boldSystemFontOfSize:14] withMaxSize:CGSizeMake(MAXFLOAT, 20)];
        name.text = _model.ShopOwnerName;
        name.textColor = [UIColor colorWithHex:0x95979C];
        [centerView addSubview:name];
        [name mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(titleImageView.mas_right).offset(10);
            make.top.equalTo(backgroundView).offset(10+10);
            make.size.mas_equalTo(CGSizeMake(nameSize.width, 20));
        }];
        
        
        UIImage *liveStatusImage = [UIImage imageNamed:@"liveStatus"];
        UIImageView *livestatus = [[UIImageView alloc] init];
        livestatus.image = liveStatusImage;
        [centerView addSubview:livestatus];
        [livestatus mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(name.mas_right).offset(10);
            make.top.equalTo(backgroundView).offset(10+(40-liveStatusImage.size.height)/2);
            make.size.mas_equalTo(CGSizeMake(liveStatusImage.size.width, liveStatusImage.size.height));
        }];
        if(_model.IsShow == 1)
        {
            NSString *path = [[NSBundle mainBundle] pathForResource:@"yuyin" ofType:@"gif"];
            livestatus.image = [UIImage animatedImageWithAnimatedGIFURL:[NSURL fileURLWithPath:path]];
        }
        else
        {
            livestatus.hidden = YES;
        }
    }
    else if(section == 3)
    {
        UIView *downView = [[UIView alloc] init];
        [backgroundView addSubview:downView];
        downView.backgroundColor = [UIColor whiteColor];
        
        
        UILabel *name = [[UILabel alloc] init];
        name.text = @"支付方式";
        name.font = [UIFont systemFontOfSize:14];
        name.textColor = [UIColor colorWithHex:0x94979E];
        name.textAlignment = NSTextAlignmentLeft;
        [backgroundView addSubview:name];
        [name mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(backgroundView).offset(10);
            make.top.equalTo(backgroundView).offset(10);
            make.size.mas_equalTo(CGSizeMake(80, 20));
        }];
        
        UILabel *payMethod = [[UILabel alloc] init];
        payMethod.text = _model.PayTypeStr;
        payMethod.font = [UIFont systemFontOfSize:14];
        payMethod.textColor = [UIColor colorWithHex:0x94979E];
        payMethod.textAlignment = NSTextAlignmentRight;
        [backgroundView addSubview:payMethod];
        [payMethod mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(backgroundView.mas_right).offset(-10);
            make.top.equalTo(backgroundView).offset(10);
            make.size.mas_equalTo(CGSizeMake(80, 20));
        }];
        
        UIView *xianView = [[UIView alloc] init];
        xianView.backgroundColor = [UIColor colorWithHex:0xDEDFE1];
        [backgroundView addSubview:xianView];
        [xianView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(backgroundView).offset(0);
            make.right.equalTo(backgroundView.mas_right).offset(0);
            make.top.equalTo(name.mas_bottom).offset(10);
            make.height.mas_equalTo(1);
        }];
        
        UILabel *createTime = [[UILabel alloc] init];
        createTime.text = [NSString stringWithFormat:@"创建时间:%@",_model.CreateTime];//@"支付方式";
        createTime.font = [UIFont systemFontOfSize:14];
        createTime.textColor = [UIColor colorWithHex:0x94979E];
        createTime.textAlignment = NSTextAlignmentLeft;
        [backgroundView addSubview:createTime];
        [createTime mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(backgroundView).offset(10);
            make.top.equalTo(xianView.mas_bottom).offset(10);
            make.size.mas_equalTo(CGSizeMake(WKScreenW, 20));
        }];
        
        UILabel *payTime = [[UILabel alloc] init];
        payTime.text = [NSString stringWithFormat:@"付款时间:%@",_model.PayDate];//@"支付方式";
        payTime.font = [UIFont systemFontOfSize:14];
        payTime.textColor = [UIColor colorWithHex:0x94979E];
        payTime.textAlignment = NSTextAlignmentLeft;
        [backgroundView addSubview:payTime];
        [payTime mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(backgroundView).offset(10);
            make.top.equalTo(createTime.mas_bottom).offset(5);
            make.size.mas_equalTo(CGSizeMake(WKScreenW, 20));
        }];
        
        UILabel *receiveTime = [[UILabel alloc] init];
        receiveTime.text = [NSString stringWithFormat:@"收货时间:%@",_model.HasBeenDate];//@"支付方式";
        receiveTime.font = [UIFont systemFontOfSize:14];
        receiveTime.textColor = [UIColor colorWithHex:0x94979E];
        receiveTime.textAlignment = NSTextAlignmentLeft;
        [backgroundView addSubview:receiveTime];
        [receiveTime mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(backgroundView).offset(10);
            make.top.equalTo(payTime.mas_bottom).offset(5);
            make.size.mas_equalTo(CGSizeMake(WKScreenW, 20));
        }];
        
        UILabel *confirmTime = [[UILabel alloc] init];
        confirmTime.text = [NSString stringWithFormat:@"签收时间:%@",_model.HasBeenDate];//@"支付方式";
        confirmTime.font = [UIFont systemFontOfSize:14];
        confirmTime.textColor = [UIColor colorWithHex:0x94979E];
        confirmTime.textAlignment = NSTextAlignmentLeft;
        [backgroundView addSubview:confirmTime];
        [confirmTime mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(backgroundView).offset(10);
            make.top.equalTo(receiveTime.mas_bottom).offset(5);
            make.size.mas_equalTo(CGSizeMake(WKScreenW, 20));
        }];
        
        if(_OrderListType == notPayOrderType)
        {
            backgroundView.frame = CGRectMake(0, 0, WKScreenW, 40+30);
            [downView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(backgroundView).offset(0);
                make.right.equalTo(backgroundView.mas_right).offset(0);
                make.top.equalTo(backgroundView).offset(5);
                make.height.mas_equalTo(70);
            }];
            payTime.hidden = YES;
            receiveTime.hidden = YES;
            confirmTime.hidden = YES;
        }
        else if(_OrderListType == notSendOrderType)
        {
            backgroundView.frame = CGRectMake(0, 0, WKScreenW, 40+30*2);
            [downView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(backgroundView).offset(0);
                make.right.equalTo(backgroundView.mas_right).offset(0);
                make.top.equalTo(backgroundView).offset(5);
                make.height.mas_equalTo(70+30);
            }];
            receiveTime.hidden = YES;
            confirmTime.hidden = YES;
        }
        else if(_OrderListType == notConfirmOrderType)
        {
            backgroundView.frame = CGRectMake(0, 0, WKScreenW, 40+30*2);
            [downView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(backgroundView).offset(0);
                make.right.equalTo(backgroundView.mas_right).offset(0);
                make.top.equalTo(backgroundView).offset(5);
                make.height.mas_equalTo(70+30);
            }];
            receiveTime.hidden = YES;
            confirmTime.hidden = YES;
        }
        else if(_OrderListType == notEvaluateOrderType)
        {
            backgroundView.frame = CGRectMake(0, 0, WKScreenW, 40+30*3);
            [downView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(backgroundView).offset(0);
                make.right.equalTo(backgroundView.mas_right).offset(0);
                make.top.equalTo(backgroundView).offset(5);
                make.height.mas_equalTo(70+30*2);
            }];
            confirmTime.hidden = YES;
        }

        if([_model.CurrentOrderStatus isEqualToString:@"已取消"])
        {
            backgroundView.frame = CGRectMake(0, 0, WKScreenW, 40+30);
            [downView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(backgroundView).offset(0);
                make.right.equalTo(backgroundView.mas_right).offset(0);
                make.top.equalTo(backgroundView).offset(5);
                make.height.mas_equalTo(70);
            }];
            payTime.hidden = YES;
            receiveTime.hidden = YES;
            confirmTime.hidden = YES;
        }
        else if([_model.CurrentOrderStatus isEqualToString:@"待发货"])
        {
            backgroundView.frame = CGRectMake(0, 0, WKScreenW, 40+30*2);
            [downView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(backgroundView).offset(0);
                make.right.equalTo(backgroundView.mas_right).offset(0);
                make.top.equalTo(backgroundView).offset(5);
                make.height.mas_equalTo(70+30);
            }];
            receiveTime.hidden = YES;
            confirmTime.hidden = YES;
        }
    }
    else if(section == 4)
    {
        backgroundView.frame = CGRectMake(0, 0, WKScreenW, 60/(WKScaleH));
        
        UIView *downView = [[UIView alloc] init];
        downView.backgroundColor = [UIColor whiteColor];
        [backgroundView addSubview:downView];
        [downView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(backgroundView).offset(0);
            make.right.equalTo(backgroundView.mas_right).offset(0);
            make.top.equalTo(backgroundView).offset(10);
            make.height.mas_equalTo(45);
        }];
        

        UILabel *timelabel = [[UILabel alloc] init];
        timelabel.userInteractionEnabled = YES;
        timelabel.font = [UIFont systemFontOfSize:14];
        timelabel.textColor = [UIColor colorWithHex:0x818590];
        UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(removeEvent)];
        [timelabel addGestureRecognizer:gesture];
        [downView addSubview:timelabel];
        [timelabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(downView).offset(10);
            make.top.equalTo(downView).offset(10);
            make.size.mas_greaterThanOrEqualTo(CGSizeMake(100, 20));
        }];
        
        if(_type == 2){
            timelabel.text = @"付款剩余时间:\n23小时52分钟";
        }
        
        UIButton *payBtn = [[UIButton alloc] init];
        [payBtn setTitle:@"立即支付" forState:UIControlStateNormal];
        [payBtn setTitleColor:[UIColor colorWithHex:0xFCA669] forState:UIControlStateNormal];
        payBtn.layer.cornerRadius = 4.0;
        payBtn.layer.masksToBounds = YES;
        payBtn.layer.borderColor = [[UIColor colorWithHex:0xFCA669] CGColor];
        payBtn.layer.borderWidth = 1.0;
        [payBtn addTarget:self action:@selector(payEvent) forControlEvents:UIControlEventTouchUpInside];
        [downView addSubview:payBtn];
        [payBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(downView.mas_right).offset(-10);
            make.bottom.equalTo(downView.mas_bottom).offset(-10);
            make.size.mas_equalTo(CGSizeMake(80, 30));
        }];
        
        UIButton *cancelBtn = [[UIButton alloc] init];
        [cancelBtn setTitle:@"取消订单" forState:UIControlStateNormal];
        [cancelBtn setTitleColor:[UIColor colorWithHex:0x93939F] forState:UIControlStateNormal];
        cancelBtn.layer.cornerRadius = 4.0;
        cancelBtn.layer.masksToBounds = YES;
        cancelBtn.layer.borderColor = [[UIColor colorWithHex:0x93939F] CGColor];
        cancelBtn.layer.borderWidth = 1.0;
        [cancelBtn addTarget:self action:@selector(cancelEvent) forControlEvents:UIControlEventTouchUpInside];
        [downView addSubview:cancelBtn];
        [cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(payBtn.mas_left).offset(-10);
            make.bottom.equalTo(downView.mas_bottom).offset(-10);
            make.size.mas_equalTo(CGSizeMake(80, 30));
        }];
        
//        NSString *hour = [NSString stringWithFormat:@"%ld",_model.RemainTime%3600];
        NSString *min = [NSString stringWithFormat:@"%d",(int)(_model.RemainTime%3600)/60];
        NSString *sec = [NSString stringWithFormat:@"%d",(int)_model.RemainTime%60];
        
        if(_type == 1)
        {
            if(_OrderListType == notPayOrderType)
            {
                
            }
            else if(_OrderListType == notSendOrderType)
            {
                backgroundView.hidden = YES;
            }
            else if(_OrderListType == notConfirmOrderType)
            {
                backgroundView.hidden = YES;
            }

            if([_model.CurrentOrderStatus isEqualToString:@"已取消"])
            {
                cancelBtn.hidden = YES;
                payBtn.hidden = YES;
                timelabel.text = @"删除订单";
            }
            else if([_model.CurrentOrderStatus isEqualToString:@"待发货"])
            {
                cancelBtn.hidden = YES;
                payBtn.hidden = YES;
                timelabel.hidden = YES;
                downView.backgroundColor = [UIColor redColor];
                [downView mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.equalTo(backgroundView).offset(0);
                    make.right.equalTo(backgroundView.mas_right).offset(0);
                    make.top.equalTo(backgroundView).offset(0);
                    make.height.mas_equalTo(0);
                }];
            }
            else if([_model.CurrentOrderStatus isEqualToString:@"已完成"] || [_model.CurrentOrderStatus isEqualToString:@"交易成功"]){
                timelabel.text = @"删除订单";
                cancelBtn.hidden = YES;
                [payBtn setTitle:@"评价晒单" forState:UIControlStateNormal];
                if(_model.CommentStatus == 1)
                {
                    payBtn.hidden = YES;
                }

            }

        }
        else
        {
            if(_OrderListType == notPayOrderType)
            {
                if(_model.RemainTime > 60)
                {
                    timelabel.text = [NSString stringWithFormat:@"支付倒计时 %@min",min];
                }
                else
                {
                    timelabel.text = [NSString stringWithFormat:@"支付倒计时 %@s",sec];
                }
                cancelBtn.hidden = YES;
            }
            else if(_OrderListType == notSendOrderType)
            {
                timelabel.hidden = YES;
                payBtn.hidden = YES;
                cancelBtn.hidden = YES;
                downView.backgroundColor = [UIColor colorWithHex:0xF3F6FF];
            }
            else if(_OrderListType == notConfirmOrderType)
            {
                timelabel.hidden = YES;
                payBtn.hidden = YES;
                cancelBtn.hidden = YES;
                downView.backgroundColor = [UIColor colorWithHex:0xF3F6FF];
            }
            
            if([_model.CurrentOrderStatus isEqualToString:@"已取消"])
            {
                cancelBtn.hidden = YES;
                payBtn.hidden = YES;
                timelabel.text = @"删除订单";
            }
            else if([_model.CurrentOrderStatus isEqualToString:@"待发货"])
            {
                cancelBtn.hidden = YES;
                payBtn.hidden = YES;
                timelabel.hidden = YES;
                downView.backgroundColor = [UIColor redColor];
                [downView mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.equalTo(backgroundView).offset(0);
                    make.right.equalTo(backgroundView.mas_right).offset(0);
                    make.top.equalTo(backgroundView).offset(0);
                    make.height.mas_equalTo(0);
                }];
            }
            else if([_model.CurrentOrderStatus isEqualToString:@"已完成"] || [_model.CurrentOrderStatus isEqualToString:@"交易成功"]){
                timelabel.text = @"删除订单";
                cancelBtn.hidden = YES;
                [payBtn setTitle:@"评价晒单" forState:UIControlStateNormal];
                if(_model.CommentStatus == 1)
                {
                    payBtn.hidden = YES;
                }
                
            }

        }
    }
    return backgroundView;
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    if(section == 2)
    {
        UIView *footView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, WKScreenW, 105)];
        footView.backgroundColor = [UIColor whiteColor];
        
        UILabel *content = [[UILabel alloc] init];
        content.font = [UIFont systemFontOfSize:14];

            if([_model.TranFeeAmount isEqualToString:@""] || (_model.TranFeeAmount.integerValue == 0))
            {
                content.text = [NSString stringWithFormat:@"合计￥%.2f",[_model.PayAmount floatValue]];
            }
            else
            {
                content.text = [NSString stringWithFormat:@"合计￥%.2f(含运费￥%.2f)",[_model.PayAmount floatValue],[_model.TranFeeAmount floatValue]];
            }

        content.textColor = [UIColor colorWithHex:0xFFAE75];
        content.textAlignment = NSTextAlignmentRight;
        [footView sizeToFit];
        [footView addSubview:content];
        [content mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(footView.mas_right).offset(-10);
            make.top.equalTo(footView).offset(10);
            //make.size.mas_equalTo(CGSizeMake(WKScreenW, 20));
        }];

        if( ((WKOrderProducts*)_model.Products[0]).IsVirtual == 1){
            UILabel *virtual =[[UILabel alloc] init];
            virtual.font = [UIFont systemFontOfSize:12];
            virtual.textColor = [UIColor colorWithHex:0x818590];
            if(_model.OrderStatus == 2 || _model.PayStatus == 0){
                virtual.text = @"付款后虚拟商品将放置在\"虚拟世界\"中";                
            }
            else{
                virtual.text = @"虚拟商品已放置在\"虚拟世界中\"";
            }
            [virtual sizeToFit];
            [footView addSubview:virtual];
            [virtual mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(footView.mas_left).offset(10);
                make.top.equalTo(footView).offset(10);
                //make.size.mas_equalTo(CGSizeMake(100, 20));
            }];
        }
        
        
        UIView *xianView = [[UIView alloc] init];
        xianView.backgroundColor = [UIColor colorWithHex:0xDFDFE1];
        [footView addSubview:xianView];
        [xianView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(footView).offset(0);
            make.right.equalTo(footView.mas_right).offset(0);
            make.top.equalTo(content.mas_bottom).offset(10);
            make.height.mas_equalTo(1);
        }];

        UIButton *attentionBtn = [[UIButton alloc] init];
        attentionBtn.layer.masksToBounds = YES;
        attentionBtn.layer.cornerRadius = 4.0;
        attentionBtn.layer.borderColor = [[UIColor colorWithHex:0xFFD9B1] CGColor];
        attentionBtn.layer.borderWidth = 1.0;
        [attentionBtn setTitle:@"联系店主" forState:UIControlStateNormal];
        [attentionBtn setTitleColor:[UIColor colorWithHex:0x83868B] forState:UIControlStateNormal];
        [attentionBtn addTarget:self action:@selector(attentionEvent) forControlEvents:UIControlEventTouchUpInside];
        self.attentionBtn = attentionBtn;
        [footView addSubview:attentionBtn];
        [attentionBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(footView).offset(10);
            make.right.equalTo(footView.mas_right).offset(-10);
            make.top.equalTo(xianView.mas_bottom).offset(15);
            make.height.mas_equalTo(35);
        }];
        
        [attentionBtn setTitle:@"联系店主" forState:UIControlStateNormal];


        return footView;
    }
    return nil;
}

//关注店主
-(void)attentionEvent
{
    if(_attentionBack)
    {
        _attentionBack(1);
    }
}

//交易完成的订单详情(删除订单),已取消的订单也可以删除订单
-(void)removeEvent
{
    if(_attentionBack)
    {
        _attentionBack(2);
    }
}

//立即支付和提醒发货
-(void)payEvent
{
    if(_OrderListType == notPayOrderType)
    {
        if(_attentionBack)//立即支付
        {
            _attentionBack(4);
        }
    }
    else if(_OrderListType == notSendOrderType || _OrderListType == notConfirmOrderType)
    {
        if(_attentionBack)//提醒发货
        {
            _attentionBack(6);
        }
    }
    else if(_OrderListType == notEvaluateOrderType)
    {
        if(_attentionBack)//评价晒单
        {
            _attentionBack(3);
        }
    }
}

//取消订单
-(void)cancelEvent
{
    if(_attentionBack)
    {
        _attentionBack(5);
    }
}

//物流
-(void)logisticsEvent
{
    if(_attentionBack)
    {
        _attentionBack(8);
    }
}

-(void)addressGestureEvent
{
    if([_model.ExpressDetail isEqualToString:@""] || _model.ExpressDetail.length <= 0)
    {
        if(_attentionBack)
        {
            _attentionBack(9);
        }
    }
    else
    {
        if(_attentionBack)
        {
            _attentionBack(8);
        }
    }
}

@end
