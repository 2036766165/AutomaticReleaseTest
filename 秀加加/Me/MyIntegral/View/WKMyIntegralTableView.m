//
//  WKMyIntegralTableView.m
//  秀加加
//  我的积分
//  Created by lin on 16/9/7.
//  Copyright © 2016年 walkingtec. All rights reserved.
//

#import "WKMyIntegralTableView.h"
#import "WKMyIntegralTableViewCell.h"

@implementation WKMyIntegralTableView

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


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(section == 0)
    {
        return 0.1;
    }
    return self.dataArray.count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *cellIdentifier = @"cell";
    WKMyIntegralTableViewCell  *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if(!cell)
    {
        cell = [[WKMyIntegralTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.item = self.dataArray[indexPath.row];
    cell.preservesSuperviewLayoutMargins = NO;
    cell.separatorInset = UIEdgeInsetsZero;
    cell.layoutMargins = UIEdgeInsetsZero;
    return cell;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 65;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *backView = [[UIView alloc]init];

    if(section == 0)
    {
        UIView *TopView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, WKScreenW, 114)];
        TopView.backgroundColor = [UIColor whiteColor];
        
        UIImageView *ImageLayerView = [[UIImageView alloc]init];
        ImageLayerView.backgroundColor = [UIColor colorWithHexString:@"FEF9F2"];
        ImageLayerView.layer.cornerRadius = 94/2.0f;
        ImageLayerView.layer.borderColor = [UIColor colorWithHexString:@"FEF9F2"].CGColor;
        ImageLayerView.layer.borderWidth = 1;
        ImageLayerView.layer.masksToBounds = YES;
        [TopView addSubview:ImageLayerView];
        [ImageLayerView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(TopView.mas_centerX);
            make.top.equalTo(TopView.mas_top).offset(10);
            make.size.sizeOffset(CGSizeMake(94, 94));
        }];
        
        UIImageView *headView = [[UIImageView alloc]init];
        [headView sd_setImageWithURL:[NSURL URLWithString:self.PersonModel.MemberPhotoMinUrl] placeholderImage:[UIImage imageNamed:@"guanzhu"]];
        headView.layer.cornerRadius = 80/2.0f;
        headView.layer.borderColor = [UIColor colorWithHexString:@"FCCE90"].CGColor;
        headView.layer.borderWidth = 5;
        headView.layer.masksToBounds = YES;
        [ImageLayerView addSubview:headView];
        [headView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(ImageLayerView.mas_centerX);
            make.top.equalTo(ImageLayerView.mas_top).offset(7);
            make.size.sizeOffset(CGSizeMake(80, 80));
        }];
        
        UIImageView *LevelView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"rank-bg"]];
        [TopView addSubview:LevelView];
        [LevelView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(TopView.mas_bottom).offset(-10);
            make.centerX.equalTo(TopView.mas_centerX);
            make.size.sizeOffset(CGSizeMake(LevelView.image.size.width, LevelView.image.size.height));
        }];
        
        UILabel *lblLevel = [[UILabel alloc]init];
        lblLevel.text = [NSString stringWithFormat:@"等级：lv%@",self.PersonModel.MemberLevel];
        lblLevel.textColor = [UIColor whiteColor];
        lblLevel.font = [UIFont systemFontOfSize:13];
        lblLevel.textAlignment = NSTextAlignmentCenter;
        CGSize lblSize = [lblLevel.text sizeOfStringWithFont:[UIFont systemFontOfSize:13] withMaxSize:CGSizeMake(MAXFLOAT, 14)];
        [LevelView addSubview:lblLevel];
        [lblLevel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(LevelView.mas_top).offset(5);
            make.centerX.equalTo(LevelView.mas_centerX);
            make.size.sizeOffset(CGSizeMake(lblSize.width + 1, 14));
        }];
        
        UIView *DownView = [[UIView alloc]initWithFrame:CGRectMake(0, 114, WKScreenW, 80)];
        DownView.backgroundColor = [UIColor whiteColor];
        
        UILabel *lblDesc = [[UILabel alloc]init];
        lblDesc.text = [NSString stringWithFormat:@"我的积分：%@，离升级还差：%@",self.PersonModel.TotalPoint,self.PersonModel.NeedRisePoint];
        lblDesc.textColor = [UIColor colorWithHexString:@"7e897d"];
        lblDesc.textAlignment = NSTextAlignmentCenter;
        lblDesc.font = [UIFont systemFontOfSize:13];
        [DownView addSubview:lblDesc];
        [lblDesc mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(DownView.mas_top).offset(10);
            make.size.sizeOffset(CGSizeMake(WKScreenW, 14));
        }];
        
        UILabel *lblC = [[UILabel alloc]init];
        lblC.text = [NSString stringWithFormat:@"lv %@",self.PersonModel.MemberLevel];
        lblC.textColor = [UIColor colorWithHexString:@"7e897d"];
        lblC.textAlignment = NSTextAlignmentCenter;
        lblC.font = [UIFont systemFontOfSize:13];
        CGSize lblCSize = [lblC.text sizeOfStringWithFont:[UIFont systemFontOfSize:13] withMaxSize:CGSizeMake(MAXFLOAT, 14)];
        [DownView addSubview:lblC];
        [lblC mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(lblDesc.mas_bottom).offset(20);
            make.left.equalTo(DownView.mas_left).offset(20);
            make.size.sizeOffset(CGSizeMake(lblCSize.width+1, 14));
        }];
        
        UILabel *lblN = [[UILabel alloc]init];
        NSInteger NextLevel = self.PersonModel.MemberLevel.integerValue +  1 ;
        lblN.text = [NSString stringWithFormat:@"lv %ld",NextLevel];
        lblN.textColor = [UIColor colorWithHexString:@"7e897d"];
        lblN.textAlignment = NSTextAlignmentCenter;
        lblN.font = [UIFont systemFontOfSize:13];
        CGSize lblNSize = [lblN.text sizeOfStringWithFont:[UIFont systemFontOfSize:13] withMaxSize:CGSizeMake(MAXFLOAT, 14)];
        [DownView addSubview:lblN];
        [lblN mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(lblC.mas_centerY);
            make.right.equalTo(DownView.mas_right).offset(-20);
            make.size.sizeOffset(CGSizeMake(lblNSize.width+1, 14));
        }];
        
        UIView *barBottomView = [[UIView alloc]init];
        barBottomView.layer.cornerRadius = 6/2.0f;
        barBottomView.layer.masksToBounds = YES;
        barBottomView.backgroundColor = [UIColor colorWithHexString:@"fff1d0"];
        CGFloat barBottomWidth = WKScreenW - 40 - 16 - lblCSize.width - lblNSize.width - 2 ;
        [DownView addSubview:barBottomView];
        [barBottomView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(lblC.mas_centerY);
            make.left.equalTo(lblC.mas_right).offset(8);
            make.right.equalTo(lblN.mas_left).offset(-8);
            make.size.sizeOffset(CGSizeMake(barBottomWidth, 6));
        }];
        
        UIView *barCoverView = [[UIView alloc]init];
        barCoverView.layer.cornerRadius = 6/2.0f;
        barCoverView.layer.masksToBounds = YES;
        barCoverView.backgroundColor = [UIColor colorWithHexString:@"ffd46b"];
        CGFloat barCoverWith = barBottomWidth * (self.PersonModel.RisePercent.floatValue);
        [barBottomView addSubview:barCoverView];
        [barCoverView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(barBottomView.mas_centerY);
            make.left.equalTo(barBottomView.mas_left).offset(0);
            make.size.sizeOffset(CGSizeMake(barCoverWith, 6));
        }];
        
        UIImageView *ImgPoint = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"dot"]];
        CGFloat MarginLeft = barCoverWith == 0 ? 5 : (8 + barCoverWith - ImgPoint.image.size.width);
        [DownView addSubview:ImgPoint];
        [ImgPoint mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(lblC.mas_centerY);
            make.left.equalTo(lblC.mas_right).offset(MarginLeft);
            make.size.sizeOffset(CGSizeMake(ImgPoint.image.size.width, ImgPoint.image.size.height));
        }];
        
        [backView addSubview:TopView];
        [backView addSubview: DownView];
    }
    
    return backView;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if(section == 0)
    {
        return  204;
    }
    return  0.1;
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
