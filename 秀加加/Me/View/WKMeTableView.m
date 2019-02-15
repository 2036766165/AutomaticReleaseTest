//
//  WKMeTableView.m
//  秀加加
//  个人中心首页
//  Created by lin on 16/8/30.
//  Copyright © 2016年 walkingtec. All rights reserved.
//

#import "WKMeTableView.h"
#import "WKMeTableViewCell.h"
#import "WKFlowButton.h"
#import "NSObject+XCTag.h"
#import "WKShowInputView.h"
#import "NSObject+XWAdd.h"

@interface WKMeTableView()

@property (nonatomic, strong) NSArray *titles;
@property (nonatomic, strong) NSArray *headImageView;

@end

@implementation WKMeTableView

-(instancetype)initWithFrame:(CGRect)frame
{
    if (self =[super initWithFrame:frame])
    {
        self.isOpenHeaderRefresh = NO;
        self.isOpenFooterRefresh = NO;
        self.tableView.showsVerticalScrollIndicator = NO;
        [self.tableView initWithFrame:frame style:UITableViewStyleGrouped];
        self.tableView.frame = CGRectMake(0, 0, frame.size.width, frame.size.height);
    }
    [self initData];
    return self;
}

-(void)setModel:(WKMeModel *)model
{
    _model = model;
}

-(void)initData
{
    self.headImageView = @[@"myAccount",@"my1",@"my2",@"my3",@"my4",@"my5",@"my6",@"开播通知",@"my7",@"my8",@"my9",@"my10",@"my11"];
    self.titles = @[@"我的账户",@"我的订单",@"消息中心",@"我的关注",@"地址管理",@"我的积分",@"浏览记录",@"开播通知",@"个人标签",@"评价晒单",@"关于我们",@"意见与反馈",@"处罚申诉"];
//    self.headImageView = @[@"my1",@"my2",@"my3",@"my4",@"my5",@"my6",@"开播通知",@"my7",@"my8",@"my9",@"my10",@"my11"];
//    self.titles = @[@"我的订单",@"消息中心",@"我的关注",@"地址管理",@"我的积分",@"浏览记录",@"开播通知",@"个人标签",@"评价晒单",@"关于我们",@"意见与反馈",@"处罚申诉"];
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
    cell.preservesSuperviewLayoutMargins = NO;
    cell.separatorInset = UIEdgeInsetsZero;
    cell.layoutMargins = UIEdgeInsetsZero;
    cell.headImageView.image = [UIImage imageNamed:self.headImageView[indexPath.row]];
    cell.title.text = self.titles[indexPath.row];
    cell.goImageView.image = [UIImage imageNamed:@"go"];
    if (indexPath.row == SELECTROW+2) {
        cell.circleView.hidden = !self.isRed;
    }else{
        cell.circleView.hidden = YES;
    }
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
    return 177 * WKScaleW;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 95;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 48;
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    //定义头部的大背景
    UIView *headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, WKScreenW, 177 * WKScaleW)];
    headView.backgroundColor = [UIColor colorWithHexString:@"f3f6ff"];
    
    //定义第二层显示数据的背景
    UIView *backgroundView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, WKScreenW, 165 * WKScaleW)];
    backgroundView.backgroundColor = [UIColor whiteColor];

    [headView addSubview:backgroundView];
    
    //头像边框
    UIImage *headImage = [UIImage imageNamed:@"biankuang"];
    UIImageView *headImageView = [[UIImageView alloc] init];
    headImageView.userInteractionEnabled = YES;
    headImageView.image = headImage;
    [backgroundView addSubview:headImageView];
    [headImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(backgroundView).offset(10);
        make.top.equalTo(backgroundView).offset(10);
        make.bottom.equalTo(backgroundView).offset(-10);
        make.size.sizeOffset(CGSizeMake(headImage.size.width*WKScaleW, headImage.size.height*WKScaleW));
    }];
    
    //用户头像
    UIImageView *titleImageView = [[UIImageView alloc] init];
    titleImageView.userInteractionEnabled = YES;
    [titleImageView sd_setImageWithURL:[NSURL URLWithString:User.MemberPhotoMinUrl] placeholderImage:[UIImage imageNamed:@"default_04"]];
    UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(headEvent:)];
    [titleImageView addGestureRecognizer:gesture];
    [headImageView addSubview:titleImageView];
    [titleImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(headImageView).offset(10);
        make.right.equalTo(headImageView.mas_right).offset(-10);
        make.top.equalTo(headImageView).offset(17);
        make.bottom.equalTo(headImageView.mas_bottom).offset(-17);
    }];
    
    //level(图标)
    NSString *strLevel = [NSString stringWithFormat: @"dengji_%d",[User.MemberLevel intValue]];
    UIImageView *levelImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:strLevel]];
    [backgroundView addSubview:levelImageView];
    [levelImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(backgroundView.mas_right).offset(-10);
        make.top.equalTo(backgroundView).offset(13 * WKScaleW);
        make.size.mas_equalTo(CGSizeMake(levelImageView.image.size.width, levelImageView.image.size.height));
    }];

    //门牌号(图标)
    UIImageView *doorImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"men"]];
    [backgroundView addSubview:doorImageView];
    [doorImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(headImageView.mas_right).offset(10);
        make.centerY.equalTo(levelImageView.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(doorImageView.image.size.width, doorImageView.image.size.height));
    }];
    
    //门牌号(内容)
    UILabel *doorCon = [[UILabel alloc] init];
    doorCon.text = [NSString stringWithFormat:@"门牌号 %@",User.MemberNo];
    doorCon.font = [UIFont systemFontOfSize:13];
    doorCon.textColor = [UIColor colorWithHexString:@"7e897d"];
    [backgroundView addSubview:doorCon];
    CGFloat doorWith = WKScreenW - levelImageView.image.size.width - doorImageView.image.size.width - headImageView.image.size.width - 45 ;
    [doorCon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(doorImageView.mas_right).offset(10);
        make.centerY.equalTo(levelImageView.mas_centerY);
        make.size.sizeOffset(CGSizeMake(doorWith, 14));
    }];

    //设置性别，年龄显示
    NSString *strGender = @"three";
    if(User.Sex.integerValue == 1){
        strGender = @"man";
    }else if(User.Sex.integerValue == 2){
        strGender = @"wuman";
    }
    
    NSString *strAge = @"three";
    if(User.Birthday.length > 4)
    {
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"YYYY"];
        NSDate *nowDate = [NSDate date];
        NSInteger CurrentYear = [[dateFormatter stringFromDate:nowDate] intValue];
        NSInteger userAge = CurrentYear - [[User.Birthday substringWithRange:NSMakeRange(0, 4)] integerValue];
        strAge = userAge < 10 ? [NSString stringWithFormat:@"0%lu",(long)userAge] : [NSString stringWithFormat:@"%lu",userAge];
    }
    
    UIImageView *borderImage = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"biankuanghui"]];
    UIImageView *genderImage = [[UIImageView alloc]initWithImage:[UIImage imageNamed:strGender]];

    UILabel *lblAge = [[UILabel alloc]init];
    UIImageView *ageImage = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"three"]];
    CGFloat btnWidth = 0 ;
    CGFloat btnHight = 0 ;
    if(User.Birthday.length > 4)
    {
        lblAge.text = strAge;
        lblAge.font = [UIFont systemFontOfSize:10];
        lblAge.textColor = [UIColor colorWithHexString:@"7e897d"];
        lblAge.textAlignment = NSTextAlignmentCenter;
        CGSize btnSize = [lblAge.text sizeOfStringWithFont:[UIFont systemFontOfSize:10] withMaxSize:CGSizeMake(MAXFLOAT, 11)];
        btnWidth = btnSize.width + 1;
        btnHight = 11;
    }
    else{
        btnWidth = ageImage.image.size.width;
        btnHight = ageImage.image.size.height;
    }
    
    //开始排版
    CGFloat borderWidth = genderImage.image.size.width + btnWidth + 3.5;
    //如果没有年龄值，需要加宽边框
    if(User.Birthday.length == 0)
    {
        borderWidth = borderWidth + 3;
    }
    
    [backgroundView addSubview:borderImage];
    [borderImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(backgroundView.mas_right).offset(-10);
        make.top.equalTo(levelImageView.mas_bottom).offset(15 * WKScaleW);
        make.size.sizeOffset(CGSizeMake(borderWidth, borderImage.image.size.height));
    }];
    
    [borderImage addSubview:genderImage];
    [genderImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(borderImage.mas_left).offset(2);
        make.centerY.equalTo(borderImage.mas_centerY).offset(0.5);
        make.size.sizeOffset(CGSizeMake(genderImage.image.size.width, genderImage.image.size.height));
    }];
    
    if(User.Birthday.length > 4)
    {
        [borderImage addSubview:lblAge];
        [lblAge mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(borderImage.mas_centerY).offset(0.5);
            make.right.equalTo(borderImage.mas_right).offset(-1);
            make.size.mas_equalTo(CGSizeMake(btnWidth,btnHight));
        }];
    }
    else
    {
        [borderImage addSubview:ageImage];
        [ageImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(borderImage.mas_centerY).offset(0.5);
            make.right.equalTo(borderImage.mas_right).offset(-2);
            make.size.mas_equalTo(CGSizeMake(btnWidth,btnHight));
        }];
    }
    
    //昵称(图标)
    UIImageView *personImage = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"person"]];
    [backgroundView addSubview:personImage];
    [personImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(headImageView.mas_right).offset(10);
        make.centerY.equalTo(borderImage.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(personImage.image.size.width, personImage.image.size.height));
    }];

    //昵称(内容)
    UILabel *lblPerson = [[UILabel alloc] init];
    lblPerson.text = User.MemberName;
    lblPerson.textColor = [UIColor colorWithHexString:@"7e897d"];
    lblPerson.font = [UIFont systemFontOfSize:13];
    [backgroundView addSubview:lblPerson];
    CGFloat personWith = WKScreenW - borderImage.image.size.width - personImage.image.size.width - headImageView.image.size.width - 45 ;
    [lblPerson mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(personImage.mas_right).offset(10);
        make.centerY.equalTo(borderImage.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(personWith, 14));
    }];
    
    //粉丝数量
    UILabel *funsCount = [[UILabel alloc] init];
    funsCount.text = [NSString stringWithFormat:@"粉丝 %ld",(long)self.funsCount];
    funsCount.font = [UIFont systemFontOfSize:13];
    funsCount.textAlignment = NSTextAlignmentRight;
    funsCount.textColor = [UIColor colorWithHexString:@"7e897d"];
    [backgroundView addSubview:funsCount];
    [funsCount mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(backgroundView.mas_right).offset(-10);
        make.top.equalTo(borderImage.mas_bottom).offset(15 * WKScaleW);
        make.size.mas_greaterThanOrEqualTo(CGSizeMake(200, 14));
    }];

    //认证(图标)
    NSString *certName = User.ShopAuthenticationStatus == 1 ? @"renzhengSuccess" : @"level" ;
    UIImageView *certiImage = [[UIImageView alloc]initWithImage:[UIImage imageNamed:certName]];
    [backgroundView addSubview:certiImage];
    [certiImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(headImageView.mas_right).offset(10);
        make.centerY.equalTo(funsCount.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(certiImage.image.size.width, certiImage.image.size.height));
    }];
    
    //认证文字
    UILabel *certiCon = [[UILabel alloc] init];
    certiCon.font = [UIFont systemFontOfSize:13];
    certiCon.textColor = [UIColor colorWithHexString:@"7e897d"];
    certiCon.text = User.ShopAuthenticationStatus == 1 ? @"实体店认证" : @"非实体店" ;
    [backgroundView addSubview:certiCon];
    [certiCon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(certiImage.mas_right).offset(10);
        make.centerY.equalTo(funsCount.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(100, 14));
    }];
    
    //加载店铺标签
    NSDictionary *dic = [NSDictionary dicWithJsonStr:User.ShopTag];
    NSArray *colorArray = dic[@"colorArr"];
    NSArray *tagArr = dic[@"titleArr"];
    
    //定义新集合
    NSMutableArray *titleArray = [NSMutableArray new];
    
    //是否去除井号
    NSInteger NeedFilter = 0 ;
    
    //定义标签中间距离为7
    CGFloat middleWH = 7 ;
    
    //标签可用宽度 页面总宽度 - 头像距离左侧距离 - 头像宽度 - 标签整体左侧距离头像距离 - 标签整体右侧距离边框的距离
    CGFloat tagWidth = WKScreenW - 10 - headImageView.image.size.width - 10 - 5;
    
    //如果是5个标签，需要判断是否能显示完整
    if(tagArr.count == 5)
    {
        //获得5个标签的宽度
        CGFloat t1 = 0 ;
        CGFloat t2 = 0 ;
        CGFloat t3 = 0 ;
        CGFloat t4 = 0 ;
        CGFloat t5 = 0 ;
        for (int i = 0; i < tagArr.count; i++)
        {
            NSString *tag = tagArr[i];
            UILabel *lblTag = [[UILabel alloc]init];
            lblTag.text = tag;
            lblTag.font = [UIFont systemFontOfSize:13 * WKScaleW];
            CGSize lblSize = [lblTag.text sizeOfStringWithFont:[UIFont systemFontOfSize:13 * WKScaleW] withMaxSize:CGSizeMake(MAXFLOAT, 13 * WKScaleW)];
            switch (i)
            {
                case 0:
                    t1 = lblSize.width; break;
                case 1:
                    t2 = lblSize.width; break;
                case 2:
                    t3 = lblSize.width; break;
                case 3:
                    t4 = lblSize.width; break;
                case 4:
                    t5 = lblSize.width; break;
                default: break;
            }
        }
        
        //如果加上第三个标签超过总宽度，折行
        if(t1 + t2 + middleWH * 2 + t3 > tagWidth)
        {
            //如果标签不能显示2行，去除#号
            if(t3 + t4 + t5 + middleWH * 2 > tagWidth)
            {
                NeedFilter = 1;
            }
        }
    }
    
    if(NeedFilter == 1)
    {
        for (NSString *item in tagArr)
        {
            [titleArray addObject:[item stringByReplacingOccurrencesOfString:@"#" withString:@""]];
        }
    }
    else
    {
        [titleArray addObjectsFromArray:tagArr];
    }
    
    //进行实际的绑定
    CGFloat marginLeft = 10;
    CGFloat marginTop = 20 * WKScaleW ;
    for (int i = 0; i < titleArray.count; i++)
    {
        NSString *tag = titleArray[i];
        NSString *tagColor = colorArray[i];
        UILabel *lblTag = [[UILabel alloc]init];
        lblTag.text = tag;
        lblTag.font = [UIFont systemFontOfSize:13 * WKScaleW];
        lblTag.textColor = [UIColor colorWithHexString:tagColor];
        [backgroundView addSubview:lblTag];
        
        CGSize lblSize = [lblTag.text sizeOfStringWithFont:[UIFont systemFontOfSize:13 * WKScaleW] withMaxSize:CGSizeMake(MAXFLOAT, 13 * WKScaleW)];
        
        //判断如果剩余宽度不够，折行
        if(lblSize.width + marginLeft - 10 > tagWidth)
        {
            marginLeft = 10;
            marginTop = lblSize.height + 32 * WKScaleW ;
        }

        //进行设置
        [lblTag mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(headImageView.mas_right).offset(marginLeft);
            make.top.equalTo(funsCount.mas_bottom).offset(marginTop);
            make.size.sizeOffset(CGSizeMake(lblSize.width + 1, 14 * WKScaleW));
        }];
        
        marginLeft = lblSize.width + marginLeft + middleWH;
    }

    UIButton *tagBtn = [[UIButton alloc]init];
    [tagBtn addTarget:self action:@selector(tagBtnAction) forControlEvents:UIControlEventTouchUpInside];
    tagBtn.backgroundColor = [UIColor clearColor];
    [backgroundView addSubview:tagBtn];
    [tagBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(headImageView.mas_right).offset(0);
        make.height.mas_offset(50*WKScaleW);
        make.right.mas_offset(0);
        make.bottom.mas_offset(0);
    }];
    return  headView;
}
-(void)tagBtnAction{
    if (self.selectViewConotroller) {
        self.selectViewConotroller([NSIndexPath indexPathForRow:SELECTROW+8 inSection:0]);
    }
}
- (nullable UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *footView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, WKScreenW, 95)];
    footView.backgroundColor = [UIColor colorWithHexString:@"f3f6ff"];
    UIButton *quitBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 20, WKScreenW, 55)];
    [quitBtn addTarget:self action:@selector(quitEvent:) forControlEvents:UIControlEventTouchUpInside];
    quitBtn.backgroundColor = [UIColor whiteColor];
    [quitBtn setTitle:@"退出当前账号" forState:UIControlStateNormal];
    [quitBtn setTitleColor:[UIColor colorWithHexString:@"7e897d"] forState:UIControlStateNormal];
    quitBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [footView addSubview:quitBtn];
    
    return  footView;
}

-(void)quitEvent:(UIButton *)sender
{
    NSString *Msg = @"确定退出应用吗？";
    [WKShowInputView showInputWithPlaceString:Msg type:LABELTYPE andBlock:^(NSString * Count) {
      
        if(_quitCallBack)
        {
            _quitCallBack(1);
        }
    }];
}

-(void)headEvent:(UITapGestureRecognizer *)gesture
{
    if(_quitCallBack)
    {
        _quitCallBack(2);
    }
}

-(void)promptViewShow:(NSString *)message{
    [WKPromptView showPromptView:message];
}

@end
