//
//  WKPersonalCenterView.m
//  秀加加
//
//  Created by Chang_Mac on 17/2/7.
//  Copyright © 2017年 walkingtec. All rights reserved.
//

#import "WKPersonalCenterView.h"
#import "WKPersonalCenterCell.h"
#import "WKTagAnimationLabel.h"
#import "NSObject+XCTag.h"
#import "NSObject+XWAdd.h"

@interface WKPersonalCenterView ()<UITableViewDelegate,UITableViewDataSource>

@property (strong, nonatomic) NSArray * titleArr;

@end

@implementation WKPersonalCenterView

-(instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style{
    if (self = [super initWithFrame:frame style:style]) {
        self.backgroundColor = [UIColor colorWithHexString:@"f3f6ff"];
        self.delegate = self;
        self.dataSource = self;
        self.separatorStyle = UITableViewCellSeparatorStyleNone;
        self.bounces = NO;
        self.showsVerticalScrollIndicator = NO;
        self.titleArr = @[@"商品管理",@"发货管理",@"客户",@"实体店认证",@"我的等级",@"我的订单",@"我看过的",@"我的地址",@"虚拟世界",@"设置"];
        
    };
    return self;
}

#pragma mark tableView delegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 3;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    switch (section) {
        case 0:
        {
            UIView *topView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, WKScreenW, WKScreenW)];
            topView.backgroundColor = [UIColor colorWithHexString:@"f3f6ff"];
            
            UIImageView *backIM = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, WKScreenW, WKScreenW*0.8)];
            backIM.userInteractionEnabled = YES;
            backIM.image = [UIImage imageNamed:@"Personal_back"];
            [topView addSubview:backIM];
            UIImageView *userHeadIM = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, WKScreenW, WKScreenW*0.8)];
            userHeadIM.userInteractionEnabled = YES;
            [userHeadIM sd_setImageWithURL:[NSURL URLWithString:self.model.MemberPhotoUrl]];
            userHeadIM.alpha = 0.3;
            [backIM addSubview:userHeadIM];
            
            UIView *whiteBackView = [[UIView alloc]initWithFrame:CGRectMake(WKScreenW*0.05, WKScreenW*0.64, WKScreenW*0.9, WKScreenW*0.32)];
            whiteBackView.backgroundColor = [UIColor whiteColor];
            whiteBackView.layer.cornerRadius = WKScreenW*0.03;
            whiteBackView.layer.shadowColor = [UIColor colorWithRed:235/255.0 green:230/255.0 blue:230/255.0 alpha:1].CGColor;
            whiteBackView.layer.shadowOffset = CGSizeMake(3, 3);
            whiteBackView.layer.shadowOpacity = 1;
            [topView addSubview:whiteBackView];
            
            for (int i = 0 ; i < 3; i ++) {
                [whiteBackView addSubview:[self createBtn:i]];
            }
            
            UIButton *penBtn = [[UIButton alloc]initWithFrame:CGRectMake(WKScreenW*0.91, 20, WKScreenW*0.07, WKScreenW*0.07)];
            [penBtn setImage:[UIImage imageNamed:@"Personal_edit"] forState:UIControlStateNormal];
            penBtn.tag = 3;
            [penBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
            [backIM addSubview:penBtn];
            
            UIButton *iconBtn = [[UIButton alloc]initWithFrame:CGRectMake(WKScreenW*0.4, WKScreenW*0.2, WKScreenW*0.2, WKScreenW*0.2)];
            iconBtn.layer.cornerRadius = WKScreenW*0.2/2;
            iconBtn.layer.masksToBounds = YES;
            iconBtn.layer.borderColor = [UIColor whiteColor].CGColor;
            iconBtn.layer.borderWidth = 1;
            iconBtn.tag = 4;
            [iconBtn setBackgroundImage:[UIImage imageNamed:@"default_03"] forState:UIControlStateNormal];
            [iconBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
            [iconBtn sd_setImageWithURL:[NSURL URLWithString:self.model.MemberPhotoMinUrl] forState:UIControlStateNormal];
            [backIM addSubview:iconBtn];
            
//<<<<<<< HEAD
//            CGSize userNameSize = [self.model.MemberName sizeOfStringWithFont:[UIFont systemFontOfSize:WKScreenW*0.04] withMaxSize:CGSizeMake(MAXFLOAT, WKScreenW*0.05)];
//            UIImage *sexImage = [UIImage imageNamed:[self.model.Sex isEqualToString:@"1"]?@"personal_manFrame":@"Personal_womanFrame"];
//            
//            UIButton *userMessageBtn = [[UIButton alloc]initWithFrame:CGRectMake((WKScreenW-userNameSize.width-sexImage.size.width-WKScreenW*0.015)/2, WKScreenW*0.473, userNameSize.width, WKScreenW*0.05)];
//            [userMessageBtn setTitle:self.model.MemberName forState:UIControlStateNormal];
//            [userMessageBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//            userMessageBtn.titleLabel.font = [UIFont systemFontOfSize:WKScreenW*0.04];
//            [backIM addSubview:userMessageBtn];
//=======
            //获得年龄和框的名字
            NSString *strAge = @"Personal_NoValue";
            NSString *borderName = @"Personal_NoSex";
            if(self.model.Birthday.length > 4)
            {
                NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
                [dateFormatter setDateFormat:@"YYYY"];
                NSDate *nowDate = [NSDate date];
                NSInteger CurrentYear = [[dateFormatter stringFromDate:nowDate] intValue];
                NSInteger userAge = CurrentYear - [[User.Birthday substringWithRange:NSMakeRange(0, 4)] integerValue];
                
                if(userAge > 99)
                {
                    strAge = @"99";
                }
                else
                {
                    strAge = userAge < 10 ? [NSString stringWithFormat:@"0%lu",(long)userAge] : [NSString stringWithFormat:@"%lu",userAge];
                }
                
                if(self.model.Sex.integerValue == 1)
                {
                    borderName = @"personal_manFrame";
                }
                else if(self.model.Sex.integerValue == 2)
                {
                    borderName = @"Personal_womanFrame";
                }
            }
            else
            {
                if(self.model.Sex.integerValue == 1)
                {
                    borderName = @"Personal_manNoAge";
                }
                else if(self.model.Sex.integerValue == 2)
                {
                    borderName = @"Personal_womanNoAge";
                }
            }
//>>>>>>> c4f470033dd34f5eb4a33432ab2f14e0e8a495f3
            
            //添加边框
            UIImageView *borderView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:borderName]];
            
//<<<<<<< HEAD
//            NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
//            formatter.dateFormat = @"yyyy-MM-dd";
//            NSInteger age = [self ageWithDateOfBirth:[formatter dateFromString:self.model.Birthday]];
//            UILabel *ageLabel = [[UILabel alloc]initWithFrame:CGRectMake(WKScreenW*0.026, WKScreenW*0.005, borderView.frame.size.height*0.9, borderView.frame.size.height*0.9)];
//            ageLabel.text = [NSString stringWithFormat:@"%ld",(long)(age>100?0:age)];
//            ageLabel.textColor = [UIColor whiteColor];
//            ageLabel.font = [UIFont systemFontOfSize:WKScreenW*0.028];
//            ageLabel.adjustsFontSizeToFitWidth = YES;
//            [borderView addSubview:ageLabel];
//=======
            if(self.model.Birthday.length > 4)
            {
                UILabel *lblAge = [[UILabel alloc]init];
                lblAge.text = strAge;
                lblAge.textColor = [UIColor whiteColor];
                lblAge.textAlignment = NSTextAlignmentCenter;
                lblAge.font = [UIFont systemFontOfSize:WKScreenW * 0.025];
                CGSize ageSize = [lblAge.text sizeOfStringWithFont:[UIFont systemFontOfSize:WKScreenW * 0.025] withMaxSize:CGSizeMake(MAXFLOAT, WKScreenW * 0.025 + 1)];
                [borderView addSubview:lblAge];
                [lblAge mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.centerY.equalTo(borderView.mas_centerY).offset(1.5);
                    make.right.equalTo(borderView.mas_right).offset(-1);
                    make.size.sizeOffset(CGSizeMake(ageSize.width + 1, WKScreenW * 0.025 + 1));
                }];
            }
            else
            {
                // 没有性别，且没有年龄的时候显示
                if(self.model.Sex.integerValue == 0)
                {
                    UIImageView *ageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:strAge]];
                    [borderView addSubview:ageView];
                    [ageView mas_makeConstraints:^(MASConstraintMaker *make) {
                        make.centerY.equalTo(borderView.mas_centerY);
                        make.right.equalTo(borderView.mas_right).offset(-3);
                        make.size.sizeOffset(CGSizeMake(ageView.image.size.width,ageView.image.size.height));
                    }];
                }
            }
        
            //排版名字和性别年龄框
            UILabel *lblName = [[UILabel alloc]init];
            lblName.text = self.model.MemberName;
            lblName.textColor = [UIColor whiteColor];
            lblName.textAlignment = NSTextAlignmentCenter;
            lblName.font =[UIFont systemFontOfSize:WKScreenW * 0.04];
            CGSize NameSize = [lblName.text sizeOfStringWithFont:[UIFont systemFontOfSize:WKScreenW * 0.04] withMaxSize:CGSizeMake(MAXFLOAT, WKScreenW * 0.04 + 1)];
//>>>>>>> c4f470033dd34f5eb4a33432ab2f14e0e8a495f3

            [backIM addSubview:lblName];
            [lblName mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(backIM.mas_top).offset(WKScreenW * 0.47);
                make.left.equalTo(backIM.mas_left).offset((WKScreenW - NameSize.width - borderView.image.size.width - 6)/2);
                make.size.sizeOffset(CGSizeMake(NameSize.width + 1, WKScreenW * 0.04 + 1));
            }];
            [backIM addSubview:borderView];
            [borderView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.equalTo(lblName.mas_centerY);
                make.left.equalTo(lblName.mas_right).offset(5);
                make.size.sizeOffset(CGSizeMake(borderView.image.size.width, borderView.image.size.height));
            }];
            
            UILabel *houseNumLable = [[UILabel alloc]initWithFrame:CGRectMake(0, WKScreenW*0.55, WKScreenW*0.55, WKScreenW*0.035)];
            houseNumLable.textAlignment = NSTextAlignmentRight;
            houseNumLable.font = [UIFont systemFontOfSize:WKScreenW*0.035];
            houseNumLable.text = [NSString stringWithFormat:@" 门牌号 %@ l",[self.model.MemberNo containsString:@"(null)"]?@"000000":self.model.MemberNo];
            houseNumLable.textColor = [UIColor whiteColor];
            [backIM addSubview:houseNumLable];
            
            UIImageView *addressIM = [[UIImageView alloc]initWithFrame:CGRectMake(WKScreenW*0.57, WKScreenW*0.55,  WKScreenW*0.023, WKScreenW*0.03)];
            addressIM.image =[UIImage imageNamed:@"address_white"];
            [backIM addSubview:addressIM];
            
            UILabel *addressLabel = [[UILabel alloc]initWithFrame:CGRectMake(WKScreenW*0.61, WKScreenW*0.55,  WKScreenW*0.3, WKScreenW*0.035)];
            addressLabel.textColor = [UIColor whiteColor];
            addressLabel.text = self.model.Location;
            addressLabel.font = [UIFont systemFontOfSize:WKScreenW*0.035];
            addressLabel.textAlignment = NSTextAlignmentLeft;
            [backIM addSubview:addressLabel];
            
            NSDictionary *dic = [NSDictionary dicWithJsonStr:self.model.ShopTag];
            NSArray *titleArr = [dic objectForKey:@"titleArr"];
            NSArray *colorArr = [dic objectForKey:@"colorArr"];
            NSMutableArray *tagLabelArr = [NSMutableArray new];
            for (int i = 0 ; i < titleArr.count ; i ++ ) {
                WKTagAnimationLabel *tagLabel = [[WKTagAnimationLabel alloc]initWithString:titleArr[i] andTextColor:colorArr[i]];
                [tagLabel addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
                tagLabel.tag = 6;
                [backIM addSubview:tagLabel];
                [tagLabelArr addObject:tagLabel];
            }
            
            NSArray *pointArr = @[
                                  @[[NSValue valueWithCGPoint:CGPointMake(WKScreenW*0.60, WKScreenW*0.15)],
                                    [NSValue valueWithCGPoint:CGPointMake(WKScreenW*0.603, WKScreenW*0.147)],
                                    [NSValue valueWithCGPoint:CGPointMake(WKScreenW*0.604, WKScreenW*0.145)],
                                    ],
                                  @[[NSValue valueWithCGPoint:CGPointMake(WKScreenW*0.06, WKScreenW*0.2)],
                                    [NSValue valueWithCGPoint:CGPointMake(WKScreenW*0.055, WKScreenW*0.197)],
                                    [NSValue valueWithCGPoint:CGPointMake(WKScreenW*0.054, WKScreenW*0.194)],
                                    ],
                                  @[[NSValue valueWithCGPoint:CGPointMake(WKScreenW*0.67, WKScreenW*0.265)],
                                    [NSValue valueWithCGPoint:CGPointMake(WKScreenW*0.674, WKScreenW*0.266)],
                                    [NSValue valueWithCGPoint:CGPointMake(WKScreenW*0.672, WKScreenW*0.264)],
                                    ],
                                  @[[NSValue valueWithCGPoint:CGPointMake(WKScreenW*0.10, WKScreenW*0.35)],
                                    [NSValue valueWithCGPoint:CGPointMake(WKScreenW*0.095, WKScreenW*0.353)],
                                    [NSValue valueWithCGPoint:CGPointMake(WKScreenW*0.097, WKScreenW*0.355)],
                                    ],
                                  @[[NSValue valueWithCGPoint:CGPointMake(WKScreenW*0.62, WKScreenW*0.375)],
                                    [NSValue valueWithCGPoint:CGPointMake(WKScreenW*0.623, WKScreenW*0.376)],
                                    [NSValue valueWithCGPoint:CGPointMake(WKScreenW*0.625, WKScreenW*0.378)],
                                    ]];
            for (int i = 0; i < tagLabelArr.count; i++ ) {
                WKTagAnimationLabel *tagLabel = tagLabelArr[i];
                [tagLabel startAnimation:[pointArr[i][0] CGPointValue]centerPoint:[pointArr[i][1] CGPointValue] endPoint:[pointArr[i][2] CGPointValue]];
            }
            return topView;
        }
            break;
        case 1:
            return [[UIView alloc]initWithFrame:CGRectMake(0, 0, WKScreenW, WKScreenW*0.1)];;
            break;
        default:
            return [[UIView alloc]initWithFrame:CGRectMake(0, 0, WKScreenW, WKScreenW*0.1)];;
            break;
    }
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    switch (section) {
        case 0:
            return 4;
            break;
        case 1:
            if (User.isReviewID) {
                return 4;
            }
            return 5;
            break;
        default:
            return 1;
            break;
    }
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    WKPersonalCenterCell *cell = [[WKPersonalCenterCell alloc]init];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;

    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    if (indexPath.section == 0 || indexPath.section == 1) {
        if (indexPath.row == 0) {//判断上圆角
            UIBezierPath *bezier = [UIBezierPath bezierPathWithRoundedRect:cell.whiteBackView.bounds byRoundingCorners:UIRectCornerTopLeft|UIRectCornerTopRight cornerRadii:CGSizeMake(WKScreenW*0.03, WKScreenW*0.03)];
            shapeLayer.path = bezier.CGPath;
            shapeLayer.frame = cell.whiteBackView.bounds;
            cell.whiteBackView.layer.mask = shapeLayer;
        }else if(indexPath.row == (User.isReviewID?3:4) || (indexPath.section == 0 && indexPath.row == 3)){//判断下圆角
            UIBezierPath *bezier = [UIBezierPath bezierPathWithRoundedRect:cell.whiteBackView.bounds byRoundingCorners:UIRectCornerBottomLeft|UIRectCornerBottomRight cornerRadii:CGSizeMake(WKScreenW*0.03, WKScreenW*0.03)];
            CAShapeLayer *shapeLayer = [CAShapeLayer layer];
            shapeLayer.frame = cell.whiteBackView.bounds;
            shapeLayer.path = bezier.CGPath;
            cell.whiteBackView.layer.mask = shapeLayer;
            cell.dottedView.hidden = YES;
        }
    }
    NSArray *cellHeadPicArr = @[@"Personal_goodsManage",@"Personal_deliverGoods",@"Personal_custom",@"Personal_cerfitication",@"Personal_level",@"Personal_order",@"Personal_hadSeen",@"Personal_address",@"Personal_virtual",@"Personal_setting"];
    if (indexPath.section == 2) {
        cell.whiteBackView.layer.cornerRadius = WKScreenW*0.03;
        cell.whiteBackView.layer.masksToBounds = YES;
        cell.dottedView.hidden = YES;
        cell.headIM.image = [UIImage imageNamed:cellHeadPicArr[9]];
    }
    if (indexPath.section < 2) {
        cell.headIM.image = [UIImage imageNamed:cellHeadPicArr[indexPath.section*4+indexPath.row]];
    }
    if (indexPath.section == 0 && indexPath.row == 0) {//商品
        [cell.rightContentBtn setTitle:self.model.ProductCount forState:UIControlStateNormal];
    }
    if (indexPath.section == 0 && indexPath.row == 2) {//客户
        [cell.rightContentBtn setTitle:self.model.CustomerCount forState:UIControlStateNormal];
    }
    if (indexPath.section == 0 && indexPath.row == 3) {//是否认证
        [cell.rightContentBtn setImage:[UIImage imageNamed:[self.model.ShopAuthenticationStatus integerValue]== 0?@"Personal_weirenzheng":@"Personal_renzheng"] forState:UIControlStateNormal];
        [cell.rightContentBtn setTitleColor:[UIColor colorWithHexString:@"7e879d"] forState:UIControlStateNormal];
        [cell.rightContentBtn setTitle:[self.model.ShopAuthenticationStatus integerValue] == 0?@" 未认证":@" 已认证" forState:UIControlStateNormal];
    }
    if (indexPath.section == 1 && indexPath.row == 0) {//创建等级标签
        [cell.rightContentBtn addSubview: [self createLevelViewWithLevel:self.model.MemberLevel]];
    }
    if (indexPath.section == 1 && indexPath.row == 1) {//订单红点
        BOOL hidden = [[[NSUserDefaults standardUserDefaults]objectForKey:@"orderRedDot"]boolValue];
        cell.redView.hidden = hidden;
    }else if (indexPath.section == 0 && indexPath.row == 1){//发货
        BOOL hidden = [[[NSUserDefaults standardUserDefaults]objectForKey:@"sendGoodsRedDot"]boolValue];
        cell.redView.hidden = hidden;
    }
    cell.titleLabel.text = self.titleArr[indexPath.section*4+indexPath.row+(indexPath.section>1?1:0)];
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return WKScreenW*0.15;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.01;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    switch (section) {
        case 0:
            return WKScreenW;
            break;
        case 1:
            return WKScreenW*0.04;
            break;
        default:
            return WKScreenW*0.04;
            break;
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (!self.selectBlock) {
        return;
    }
    switch (indexPath.section) {
        case 0:
            switch (indexPath.row) {
                case 0:
                    self.selectBlock(goodsType);
                    break;
                case 1:
                    self.selectBlock(deliverGoodsType);
                    break;
                case 2:
                    self.selectBlock(customType);
                    break;
                case 3:
                    self.selectBlock(shopCertificateType);
                    break;
            }
            break;
        case 1:
            switch (indexPath.row) {
                case 0:
                    self.selectBlock(levelType);
                    break;
                case 1:
                    self.selectBlock(orderType);
                    break;
                case 2:
                    self.selectBlock(hadSeenType);
                    break;
                case 3:
                    self.selectBlock(addressType);
                    break;
                case 4:
                    self.selectBlock(virtualWordType);
                    break;
            }
            break;
        case 2:
            self.selectBlock(settingType);
            break;
    }
}

-(void)btnClick:(UIButton *)btn{
    if (!self.selectBlock) {
        return;
    }
    switch (btn.tag) {
        case 0:
            self.selectBlock(attentionType);
            break;
        case 1:
            self.selectBlock(walletType);
            break;
        case 2:
            self.selectBlock(fansType);
            break;
        case 3: case 4:
            self.selectBlock(userMessageType);
            break;
        case 6:
            self.selectBlock(tagType);
            break;
    }
}

-(UIView *)createLevelViewWithLevel:(NSString *)levelStr{
    NSInteger level = levelStr.integerValue;
    NSString *imageName = @"";
    if (level>9) {
        imageName = @"level10";
    }else{
        imageName = [NSString stringWithFormat:@"level%ld",(long)level];
    }
    NSArray *colorArr = @[@"d9790b",@"e2e2e0",@"eecb00",@"a200d0"];
    NSArray *edgeColorArr = @[@"ff9c20",@"bbbbb9",@"ffe80e",@"8b02b4"];
    UIView *levelView = [[UIView alloc]initWithFrame:CGRectMake(WKScreenW*0.2, 0.0075*WKScreenW, WKScreenW*0.1, WKScreenW*0.035)];
    
    UILabel *levelLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, WKScreenW*0.1, WKScreenW*0.035)];
    switch (level) {
        case 1:case 4:case 7:
            levelLabel.backgroundColor = [UIColor colorWithHexString:colorArr[0]];
            levelLabel.layer.borderColor = [UIColor colorWithHexString:edgeColorArr[0]].CGColor;
            levelLabel.textColor = [UIColor colorWithHexString:@"f6ebab"];
            break;
        case 2:case 5:case 8:
            levelLabel.backgroundColor = [UIColor colorWithHexString:colorArr[1]];
            levelLabel.layer.borderColor = [UIColor colorWithHexString:edgeColorArr[1]].CGColor;
            levelLabel.textColor = [UIColor colorWithHexString:@"b2b2b2"];
            break;
        case 3:case 6:case 9:
            levelLabel.backgroundColor = [UIColor colorWithHexString:colorArr[2]];
            levelLabel.layer.borderColor = [UIColor colorWithHexString:edgeColorArr[2]].CGColor;
            levelLabel.textColor = [UIColor colorWithHexString:@"ffeeb3"];
            break;
        default:
            levelLabel.backgroundColor = [UIColor colorWithHexString:colorArr[3]];
            levelLabel.layer.borderColor = [UIColor colorWithHexString:edgeColorArr[3]].CGColor;
            levelLabel.textColor = [UIColor colorWithHexString:@"f1cb66"];
            break;
    }
    
    levelLabel.layer.borderWidth = 1;
    levelLabel.layer.masksToBounds = YES;
    levelLabel.font = [UIFont systemFontOfSize:WKScreenW*0.025];
    levelLabel.textAlignment = NSTextAlignmentCenter;
    levelLabel.text = [NSString stringWithFormat:@"    V%lu",(long)level];
    levelLabel.layer.cornerRadius = WKScreenW*0.035/2;
    levelLabel.adjustsFontSizeToFitWidth = YES;
    [levelView addSubview:levelLabel];
    
    UIImageView *levelIM = [[UIImageView alloc]initWithFrame:CGRectMake(0, -WKScreenW*0.005, WKScreenW*0.043, WKScreenW*0.043)];
    levelIM.image = [UIImage imageNamed:imageName];
    [levelView addSubview:levelIM];
    
    return levelView;
}

-(UIButton *)createBtn:(int)index{
    NSArray *imageArr = @[@"Personal_attention",@"Personal_wallet",@"Personal_fans"];
    NSArray *titleArr = @[@"关注",@"钱包",@"粉丝"];
    NSMutableArray *numberArr = @[[NSString stringWithFormat:@"%@",self.model.FollowCount],[NSString stringWithFormat:@"¥ %.2f",self.model.MemberMoney.floatValue],[NSString stringWithFormat:@"%@",self.model.FunsCount]].mutableCopy;
    
    UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(index*WKScreenW*0.3, 0, WKScreenW*0.3, WKScreenW*0.32)];
    UIImageView *topIM = [[UIImageView alloc]initWithImage:[UIImage imageNamed:imageArr[index]]];
    topIM.frame = CGRectMake(WKScreenW*0.11, WKScreenW*0.055, WKScreenW*0.07, WKScreenW*0.07);
    [btn addSubview:topIM];
    
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, WKScreenW*0.155, WKScreenW*0.3, WKScreenW*0.05)];
    titleLabel.font = [UIFont systemFontOfSize:WKScreenW*0.04];
    titleLabel.text = titleArr[index];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.textColor = [UIColor colorWithHexString:@"7e879d"];
    [btn addSubview:titleLabel];
    
    NSString *contentStr = numberArr[index];
    UILabel *contentLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, WKScreenW*0.225, WKScreenW*0.3, WKScreenW*0.05)];
    contentLabel.font = [UIFont systemFontOfSize:WKScreenW*0.04];
    contentLabel.text = [contentStr containsString:@"(null)"]?@"0.00":contentStr;
    contentLabel.textAlignment = NSTextAlignmentCenter;
    contentLabel.textColor = [UIColor colorWithHexString:@"7e879d"];
    [btn addSubview:contentLabel];
    
    btn.tag = index;
    [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];

    return btn;
}

- (NSInteger)ageWithDateOfBirth:(NSDate *)date;
{
    // 出生日期转换 年月日
    NSDateComponents *components1 = [[NSCalendar currentCalendar] components:NSDayCalendarUnit | NSMonthCalendarUnit | NSYearCalendarUnit fromDate:date];
    NSInteger brithDateYear  = [components1 year];
    NSInteger brithDateDay   = [components1 day];
    NSInteger brithDateMonth = [components1 month];
    
    // 获取系统当前 年月日
    NSDateComponents *components2 = [[NSCalendar currentCalendar] components:NSDayCalendarUnit | NSMonthCalendarUnit | NSYearCalendarUnit fromDate:[NSDate date]];
    NSInteger currentDateYear  = [components2 year];
    NSInteger currentDateDay   = [components2 day];
    NSInteger currentDateMonth = [components2 month];
    
    // 计算年龄
    NSInteger iAge = currentDateYear - brithDateYear - 1;
    if ((currentDateMonth > brithDateMonth) || (currentDateMonth == brithDateMonth && currentDateDay >= brithDateDay)) {
        iAge++;
    }
    
    return iAge;
}
@end










