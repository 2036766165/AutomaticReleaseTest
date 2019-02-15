//
//  WKTagTableView.m
//  秀加加
//
//  Created by Chang_Mac on 16/9/20.
//  Copyright © 2016年 walkingtec. All rights reserved.
//

#import "WKTagTableView.h"
#import "WKTagCell.h"
#import "WKTagModel.h"
#import "NSObject+XCTag.h"
@implementation WKTagTableView

-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self.tableView initWithFrame:frame style:UITableViewStyleGrouped];
        self.tableView.frame = CGRectMake(0, 0, frame.size.width, frame.size.height);
        self.isOpenFooterRefresh = NO;
        self.isOpenHeaderRefresh = NO;
        self.time = 0;
        self.callBackArr = [NSMutableArray new];
        self.tableView.showsVerticalScrollIndicator = NO;
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [self createPromptView];
    }
    return self;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    WKTagModel *tagModel = self.dataArr[indexPath.section];
    NSInteger cellLine = 0;
    if (tagModel.TagList.count%3>0) {
        cellLine = tagModel.TagList.count/3+1;
    }else{
        cellLine = tagModel.TagList.count/3;
    }
    return 50*cellLine+10;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    WKTagCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CELL"];
    if (!cell) {
        cell = [[WKTagCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"CELL"];
    }
    WKTagModel *tagModel = self.dataArr[indexPath.section];
    cell.model = tagModel;
    cell.selectionStyle = UITableViewCellStyleDefault;
    WeakSelf(WKTagTableView);
    cell.tagBlock = ^(BOOL result,WkTagTitle *titleModel,UIButton *tagBtn){
        NSDictionary *dic = @{@"Sort":titleModel.Sort,@"TagColor":titleModel.TagColor,@"TagName":titleModel.TagName};
        if (result) {
            [weakSelf.callBackArr addObject:dic];
        }else{
            [weakSelf.callBackArr removeObject:dic];
        }
        if (weakSelf.callBackArr.count>5) {
            [weakSelf.callBackArr removeObject:dic];
            [weakSelf promptViewShow:@"个性标签最多只能选五个,快去进行下一步吧!"];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"tagNum" object:nil userInfo:@{@"btn":tagBtn}];
        }
        if (weakSelf.tagTableCallBack) {
            weakSelf.tagTableCallBack(weakSelf.callBackArr);
        }
    };
    return cell;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.dataArr.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 50;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return [self headView:section];
}
-(UIView *)headView:(NSInteger)section{
    WKTagModel *model = self.dataArr[section];
    UIView *backView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, WKScreenW, 50)];
    backView.backgroundColor = [UIColor colorWithHexString:@"f3f6ff"];
    UIView *headView = [[UIView alloc]initWithFrame:CGRectMake(0, 10, WKScreenW, 40)];
    headView.backgroundColor = [UIColor whiteColor];
    
    UILabel *tagTitle = [[UILabel alloc]init];
    tagTitle.font = [UIFont systemFontOfSize:16];
    tagTitle.text = model.RootTagName;
    tagTitle.textAlignment = NSTextAlignmentCenter;
    tagTitle.textColor = [UIColor colorWithHexString:@"7e879d"];
    [headView addSubview:tagTitle];
    [tagTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_offset(0);
        make.top.mas_offset(0);
        make.bottom.mas_offset(0);
        make.width.mas_greaterThanOrEqualTo(30);
    }];
    
    UIImageView *leftIM = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"left"]];
    [headView addSubview:leftIM];
    [leftIM mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_offset(20);
        make.right.equalTo(tagTitle.mas_left).offset(-15);
        make.centerY.equalTo(headView.mas_centerY);
        make.height.mas_equalTo(2);
    }];
    
    UIImageView *rightIM = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"right"]];
    [headView addSubview:rightIM];
    [rightIM mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(tagTitle.mas_right).offset(15);
        make.right.mas_equalTo(-20);
        make.centerY.equalTo(headView.mas_centerY);
        make.height.mas_equalTo(2);
    }];
    
    [backView addSubview:headView];
    
    return backView;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.1;
}

-(void)createPromptView{
    NSDictionary *tagDic = [NSDictionary dicWithJsonStr:User.ShopTag];
    NSArray *titleArr = [tagDic objectForKey:@"titleArr"];
    NSArray *sortArr = [tagDic objectForKey:@"sortArr"];
    NSArray *colorArr = [tagDic objectForKey:@"colorArr"];
    for (int i = 0 ; i < titleArr.count ; i ++ ) {
        NSDictionary *dic = @{@"Sort":sortArr[i],@"TagColor":colorArr[i],@"TagName":titleArr[i]};
        [self.callBackArr addObject:dic];
    }
}

-(void)promptViewShow:(NSString *)message{
    [WKPromptView showPromptView:message];
}

@end
