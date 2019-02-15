//
//  WKStoreTableView.m
//  秀加加
//
//  Created by lin on 16/9/2.
//  Copyright © 2016年 walkingtec. All rights reserved.
//

#import "WKStoreTableView.h"
#import "WKMeTableViewCell.h"

@interface WKStoreTableView()

@property (nonatomic, strong) NSArray *titles;
@property (nonatomic, strong) NSArray *headImageView;
@property (nonatomic, strong) NSArray *content;

@end

@implementation WKStoreTableView

-(instancetype)initWithFrame:(CGRect)frame
{
    if (self =[super initWithFrame:frame])
    {
        self.isOpenHeaderRefresh = NO;
        self.isOpenFooterRefresh = NO;
        self.tableView.showsVerticalScrollIndicator = NO;
        self.tableView.scrollEnabled = NO;
        [self.tableView initWithFrame:frame style:UITableViewStyleGrouped];
    }
    [self initData];
    return self;
}

-(void)initData
{
    self.headImageView = @[@"my1",@"my2",@"my3",@"my4",@"my5",@"my6",@"my7",@"my8"];
    
    self.titles = @[@"店铺标签",@"店铺认证",@"商品管理",@"店铺订单",@"店铺客户",@"店铺收入",@"运费设置",@"开店帮助"];
    
    self.content = @[@"为您的店铺选择一个合适的标签",@"认证店铺更值得信赖",@"让您的商品更加夺目",@"发货，查看订单",@"您的新老客户一目了然",@"您自己的小金库",@"发货更方便",@"管理店铺更方便"];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.headImageView.count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *cellIdentifier = @"cell";
    WKMeTableViewCell  *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if(!cell)
    {
        cell = [[WKMeTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.headImageView.image = [UIImage imageNamed:self.headImageView[indexPath.row]];
    cell.title.text = self.titles[indexPath.row];
    cell.content.text = self.content[indexPath.row];
    cell.goImageView.image = [UIImage imageNamed:@"go"];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(_selectViewConotroller)
    {
        _selectViewConotroller(indexPath);
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return WKScreenH-64-49;//WKScreenW+40;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 48;
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, WKScreenW, WKScreenH-64-49)];
    headView.backgroundColor = [UIColor whiteColor];
    
    UIImage *centerImage = [UIImage imageNamed:@"default_01"];
    UIImageView *backgroundView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 40, WKScreenW, WKScreenH-40-64-49)];
    backgroundView.image = centerImage;
    [headView addSubview:backgroundView];

    UIView *downView = [[UIView alloc] init];
    downView.alpha = 0.48;
    downView.backgroundColor = [UIColor blackColor];
    [backgroundView addSubview:downView];
    [downView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(backgroundView).offset(0);
        make.right.equalTo(backgroundView.mas_right).offset(0);
        make.bottom.equalTo(backgroundView.mas_bottom).offset(0);
        make.height.mas_equalTo(65);
    }];
    
    UIImage *shopImage = [UIImage imageNamed:@"default_02"];
    UIImageView *rightImgView = [[UIImageView alloc] init];
    rightImgView.image = shopImage;
    [downView addSubview:rightImgView];
    [rightImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(downView.mas_right).offset(-2);
        make.top.equalTo(downView).offset(2);
        make.bottom.equalTo(downView.mas_bottom).offset(-2);
        make.width.mas_equalTo(61);
    }];
    
    //合并到一个控件中使用
    UIImage *renzhengImg = [UIImage imageNamed:@"renzheng"];
    UIView *rightTopView = [[UIView alloc] init];
    [backgroundView addSubview:rightTopView];
    [rightTopView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(backgroundView.mas_right).offset(0);
        make.top.equalTo(backgroundView).offset(10);
        make.size.mas_equalTo(CGSizeMake(60+2+renzhengImg.size.width, 20));
    }];
    
    //实体店认证
    UILabel *renzhengLab = [[UILabel alloc] init];
    renzhengLab.textColor = [UIColor colorWithHex:0xB4B7B9];
    renzhengLab.font = [UIFont systemFontOfSize:12];
    renzhengLab.text = @"实体店认证";
    [rightTopView addSubview:renzhengLab];
    [renzhengLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(rightTopView.mas_right).offset(-5);
        make.top.equalTo(rightTopView).offset(0);
        make.size.mas_equalTo(CGSizeMake(60, 20));
    }];
    
    
    UIImageView *renzhengImgView = [[UIImageView alloc] init];
    renzhengImgView.image = renzhengImg;
    [rightTopView addSubview:renzhengImgView];
    [renzhengImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(renzhengLab.mas_left).offset(-2);
        make.top.equalTo(rightTopView).offset(2);
        make.size.mas_equalTo(CGSizeMake(renzhengImg.size.width, renzhengImg.size.height));
    }];

    
    UIView *upView = [[UIView alloc] init];
    [headView addSubview:upView];
    [upView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(headView).offset(0);
        make.right.equalTo(headView.mas_right).offset(0);
        make.top.equalTo(headView).offset(0);
        make.height.mas_equalTo(40);
    }];
    
    UIImage *leftHeadImg = [UIImage circleImageWithName:@"default_03" borderWidth:1 borderColor:[UIColor colorWithHex:0xF4C1A6]];
    UIImageView *leftImgView = [[UIImageView alloc] init];
    leftImgView.image = leftHeadImg;
    [upView addSubview:leftImgView];
    [leftImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(upView).offset(10);
        make.top.equalTo(upView).offset((40-leftHeadImg.size.height*0.8)/2);
        make.size.mas_equalTo(CGSizeMake(leftHeadImg.size.width*0.8, leftHeadImg.size.height*0.8));
    }];
    
    UIImage *dengjiImage = [UIImage imageNamed:@"dengji"];
    UIImageView *dengjiImageView = [[UIImageView alloc] init];
    dengjiImageView.image = dengjiImage;
    [upView addSubview:dengjiImageView];
    [dengjiImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(leftImgView.mas_right).offset(-8);
        make.bottom.equalTo(leftImgView.mas_bottom).offset(-2);
        make.size.mas_equalTo(CGSizeMake(dengjiImage.size.width, dengjiImage.size.height));
    }];
    
    
    UILabel *name = [[UILabel alloc] init];
    name.font = [UIFont systemFontOfSize:10];
    name.textColor = [UIColor colorWithHex:0xBABDC9];
    name.text = @"adaddadadadada  北京";
    [upView addSubview:name];
    [name mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(leftImgView.mas_right).offset(10);
        make.top.equalTo(upView).offset(5);
        make.size.mas_equalTo(CGSizeMake(200, 15));
    }];
    
    UILabel *fan = [[UILabel alloc] init];
    fan.text = @"粉丝  886";
    fan.font = [UIFont systemFontOfSize:10];
    fan.textColor = [UIColor colorWithHex:0xBABDC9];
    [upView addSubview:fan];
    [fan mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(leftImgView.mas_right).offset(10);
        make.top.equalTo(name.mas_bottom).offset(0);
        make.size.mas_equalTo(CGSizeMake(200, 15));
    }];
    
    UILabel *liveNum = [[UILabel alloc] init];
    liveNum.textColor = [UIColor colorWithHex:0xFDA66D];
    liveNum.text = @"8989在看";
    liveNum.font = [UIFont systemFontOfSize:10];
    liveNum.textAlignment = NSTextAlignmentRight;
    [upView addSubview:liveNum];
    [liveNum mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(upView.mas_right).offset(-5);
        make.bottom.equalTo(upView.mas_bottom).offset(-5);
        make.size.mas_equalTo(CGSizeMake(150, 15));
    }];
    return  headView;
}
@end
