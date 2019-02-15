//
//  WKIncomeDetailsView.m
//  秀加加
//
//  Created by Chang_Mac on 16/9/29.
//  Copyright © 2016年 walkingtec. All rights reserved.
//

#import "WKIncomeDetailsView.h"
#import "WKIncomeSmallTableViewCell.h"
#import "WKIncomeDetailsModel.h"

@interface WKIncomeDetailsView ()

@property (strong, nonatomic) UILabel * label;

@end

@implementation WKIncomeDetailsView

-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.isOpenHeaderRefresh = NO;
        self.isOpenFooterRefresh = NO;
        self.tableView.scrollEnabled = NO;
        self.tableView.showsVerticalScrollIndicator = NO;
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        self.tableView.frame = CGRectMake(0, 0, frame.size.width, frame.size.height);
        self.backgroundColor = [UIColor colorWithHexString:@"f3f6ff"];
    }
    return self;
}

#pragma mark tableView Dategate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if(self.type==1){
        return 5;
    }else{
        return 7;
    }
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    WKIncomeSmallTableViewCell *cell = [[WKIncomeSmallTableViewCell alloc]init];
    NSArray *titleArr;
    if (self.type == 1) {
        titleArr = @[@"手续费",@"交    易",@"当前状态",@"提现提交时间",@"预计到账时间"];
    }else{
        titleArr = @[@"商       品",@"起拍价格",@"成交价格",@"得拍客户",@"保  证  金",@"服  务  费",@""];
    }
    cell.titleLabel.text = titleArr[indexPath.row];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (self.type == 1) {
        switch (indexPath.row) {
            case 0:
                cell.valueLabel.text = [NSString stringWithFormat:@"¥%0.2f",self.model.ServiceAmount.floatValue];
                break;
            case 1:
                if ([self.model.Status integerValue] == 1) {
                    cell.valueLabel.text = @"提现";
                }else{
                    cell.valueLabel.text = @"收入";
                }
                break;
            case 2:
                cell.valueLabel.text = self.model.StatusName;
                break;
            case 3:
                cell.valueLabel.text = self.model.ApplyTime;
                break;
            case 4:
                cell.valueLabel.text = self.model.ReceiveTime;
                break;
        }
    }else{
        ActionOrderProducts *orderProduct =self.auctionModel.Products[0];
        if(indexPath.row == 0){
            cell.valueLabel.text = orderProduct.GoodsName;
        }
        else if(indexPath.row == 1){
            cell.valueLabel.text = [NSString stringWithFormat:@"¥%0.2f",self.auctionModel.GoodsStartPrice.floatValue];
        }
        else if(indexPath.row == 2){
            cell.valueLabel.text = [NSString stringWithFormat:@"¥%0.2f",self.auctionModel.GoodsAmount.floatValue];
        }
        else if(indexPath.row == 3){
            cell.valueLabel.text = self.auctionModel.CustomerName;
        }
        else if(indexPath.row==4){
            cell.valueLabel.text =[NSString stringWithFormat:@"¥%0.2f",self.auctionModel.GoodsStartPrice.floatValue];
        }
        else if(indexPath.row==5){
            cell.valueLabel.text =[NSString stringWithFormat:@"¥%0.2f",self.auctionModel.ServiceAmount.floatValue];
        }
        else if(indexPath.row==6)
        {
            UIView *line = [[UIView alloc]init];
            line.backgroundColor = [UIColor colorWithHexString:@"dae0ed"];
            [cell addSubview:line];
            cell.valueLabel.font = [UIFont systemFontOfSize:12];
            cell.valueLabel.text = self.createTime;
            [line mas_makeConstraints:^(MASConstraintMaker *make) {
                make.bottom.equalTo(cell.titleLabel.mas_top).offset(-4);
                make.left.mas_equalTo(0);
                make.width.mas_equalTo(WKScreenW);
                make.height.mas_equalTo(1);
            }];
        }
        
    }
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 4) {
        return 40;
    }
    return 30;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *backView = [[UIView alloc]init];
    backView.backgroundColor = [UIColor colorWithHexString:@"f3f6ff"];
    
    UIView *topView = [[UIView alloc]init];
    topView.backgroundColor = [UIColor whiteColor];
    [backView addSubview: topView];
    [topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_offset(0);
        make.top.mas_offset(7);
        make.size.sizeOffset(CGSizeMake(WKScreenW, 50));
    }];
    NSString *imageName;
    NSString *bigTitle;
    if (self.type == 1) {
        imageName =@"income_changecard";
        bigTitle = @"提现到微信";
    }else{
        imageName = @"chuizi@2x_03";
        bigTitle = [NSString stringWithFormat:@"订单编号：%@",self.auctionModel.OrderCode];
    }
    UIImageView *imageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:imageName]];
    [backView addSubview:imageView];
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_offset(15);
        make.top.equalTo(topView.mas_top).offset(10);
        make.size.sizeOffset(CGSizeMake(30, 30));
    }];
    
    self.label = [[UILabel alloc]init];
    self.label.text = bigTitle;
    self.label.font = [UIFont systemFontOfSize:16];
    self.label.textColor = [UIColor colorWithHexString:@"7e879d"];
    [topView addSubview:self.label];
    [self.label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(imageView.mas_right).offset(15);
        make.centerY.equalTo(imageView.mas_centerY);
        make.size.sizeOffset(CGSizeMake(WKScreenW*0.8, 30));
    }];
    
    UIView *bottomView = [[UIView alloc]init];
    bottomView.backgroundColor = [UIColor whiteColor];
    [backView addSubview:bottomView];
    [bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_offset(0);
        make.bottom.mas_offset(0);
        make.size.sizeOffset(CGSizeMake(WKScreenW, 80));
    }];
    
    UILabel *money = [[UILabel alloc]init];
    money.text = @"收入金额";
    money.font = [UIFont systemFontOfSize:16];
    money.textColor = [UIColor grayColor];
    [bottomView addSubview:money];
    [money mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(bottomView.mas_left).offset(15);
        make.centerY.equalTo(bottomView.mas_centerY);
        make.size.sizeOffset(CGSizeMake(WKScreenW*0.5-15, 20));
    }];
    
    UILabel *moneyNum = [[UILabel alloc]init];
    moneyNum.font = [UIFont systemFontOfSize:20];
    //提现
    if(self.type==1){
         moneyNum.text = [NSString stringWithFormat:@"¥ %0.2f",self.model.Amount.floatValue];
    }
    else{
        //拍卖
        if(self.auctionModel.PayStatus.integerValue == 1){
            //正常拍卖收入
            float income=self.auctionModel.GoodsAmount.floatValue-self.auctionModel.ServiceAmount.floatValue;
            moneyNum.text = [NSString stringWithFormat:@"¥ %0.2f",income];
        }
        else{
            //保证金收入
            moneyNum.text = [NSString stringWithFormat:@"¥ %0.2f",self.auctionModel.GoodsStartPrice.floatValue];
        }
    }
    
    moneyNum.textAlignment = NSTextAlignmentRight;
    [bottomView addSubview:moneyNum];
    [moneyNum mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(bottomView.mas_right).offset(-15);
        make.centerY.equalTo(bottomView.mas_centerY);
        make.size.sizeOffset(CGSizeMake(WKScreenW*0.5-15, 25));
    }];
    
    UIView *line = [[UIView alloc]initWithFrame:CGRectMake(0, 140, WKScreenW, 1)];
    line.backgroundColor = [UIColor colorWithHexString:@"eeeeee"];
    [backView addSubview:line];
    
    return backView;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 144;
}
@end
