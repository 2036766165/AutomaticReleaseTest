//
//  WKPersonEditTableView.m
//  秀加加
//  个人信息修改页（头像，昵称，年龄）
//  Created by lin on 16/9/5.
//  Copyright © 2016年 walkingtec. All rights reserved.
//

#import "WKPersonEditTableView.h"
#import "WKPersonEditTableViewCell.h"

@interface WKPersonEditTableView() <IQDropDownTextFieldDelegate,WKMemberInfoProtocol>
@property (nonatomic,strong) NSArray *titles;
@end

@implementation WKPersonEditTableView

-(instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style
{
    if (self =[super initWithFrame:frame])
    {
        self.isOpenHeaderRefresh = NO;
        self.isOpenFooterRefresh = NO;
        self.tableView.showsVerticalScrollIndicator = NO;
        self.tableView.tableHeaderView = [[UIView alloc] init];

        //定义背景图
        UIImage *backImage = [UIImage imageNamed:@"gerenbianji"];
        self.headView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 64, WKScreenW, backImage.size.height)];
        self.headView.userInteractionEnabled = YES;
        self.headView.image =  backImage;
        
        //绑定用户头像
        UIImage *headImage = [UIImage imageNamed:@"bianjizanwutouxiang"];
        self.centerImageView = [[UIImageView alloc] init];
        self.centerImageView.userInteractionEnabled = YES;
        [self.centerImageView sd_setImageWithURL:[NSURL URLWithString:User.MemberPhotoMinUrl] placeholderImage:headImage];
        
        self.centerImageView.clipsToBounds = YES;
        self.centerImageView.contentMode = UIViewContentModeScaleAspectFill;
        self.centerImageView.userInteractionEnabled = YES;
        
        [self.headView addSubview:self.centerImageView];
        [self.centerImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.headView).offset((WKScreenW-headImage.size.width)/2);
            make.top.equalTo(self.headView).offset(20);
            make.size.mas_equalTo(CGSizeMake(headImage.size.width, headImage.size.height));
        }];
        
        //定义修改按钮图片
        UIImageView *editView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"editIcon"]];
        [self.centerImageView addSubview:editView];
        [editView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.centerImageView.mas_right).offset(-1);
            make.bottom.equalTo(self.centerImageView.mas_bottom).offset(-1);
            make.size.sizeOffset(CGSizeMake(editView.image.size.width, editView.image.size.height));
        }];
        
        //头像下方昵称
        self.userName = [[UILabel alloc] init];
        self.userName.font = [UIFont systemFontOfSize:16];
        self.userName.textColor = [UIColor colorWithHex:0x8E716D];
        self.userName.textAlignment = NSTextAlignmentCenter;
        self.userName.text = User.MemberName;
        [self.headView addSubview:self.userName];
        [self.userName mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.headView).offset(0);
            make.top.equalTo(self.centerImageView.mas_bottom).offset(10);
            make.right.equalTo(self.headView.mas_right).offset(0);
            make.size.mas_equalTo(CGSizeMake(WKScreenW, 17));
        }];
        
        UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(headEvent)];
        [self.centerImageView addGestureRecognizer:gesture];
        
        self.tableView.tableHeaderView = self.headView;
    }
    [self initData];
    return self;
}

-(void)initData{
    self.titles = @[@"用户昵称",@"性别",@"出生日期"];
}

-(void)headEvent
{
    if(_clickType)
    {
        _clickType();
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.titles.count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *cellIdentifier = @"cell";
    WKPersonEditTableViewCell  *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if(!cell)
    {
        cell = [[WKPersonEditTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        cell.content.delegate = self;
        cell.content.isOptionalDropDown = NO;
        if (indexPath.row == 0) {
            cell.content.dropDownMode = IQDropDownModeTextField;
            cell.content.selectedItem = User.MemberName;
        }else if(indexPath.row == 1){
            cell.content.dropDownMode = IQDropDownModeTextPicker;
            
            NSArray *arr = @[@"未知",@"男",@"女"];
            [cell.content setItemList:arr];
            [cell.content setSelectedRow:[User.Sex integerValue]];
            
        }else{
            cell.content.dropDownMode = IQDropDownModeDatePicker;
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
            [dateFormatter setDateFormat:@"yyyy-MM-dd"];
            cell.content.dateFormatter = dateFormatter;
            NSString *birthday = [User.Birthday componentsSeparatedByString:@" "][0];
            NSDate *birthdayDate = [dateFormatter dateFromString:birthday];
            NSString *minStr = @"1900-01-01";
            NSDate *minDate = [dateFormatter dateFromString:minStr];
            cell.content.minimumDate = minDate;
            cell.content.maximumDate = [NSDate date];
            [cell.content setDate:birthdayDate];
        }
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.name.text = self.titles[indexPath.row];
    }
    
    return cell;
}

// 修改昵称
- (void)textFieldDidEndEditing:(UITextField *)textField{
    UILabel *lab = [textField.superview viewWithTag:1001];
    
    NSDictionary *sexDict = @{
                              @"未知":@0,
                              @"男":@1,
                              @"女":@2
                              };
    
    NSDictionary *dict = @{@"用户昵称":@"1",@"性别":@"2",@"出生日期":@"3"};
    NSString *key = dict[lab.text];
    NSString *value = textField.text;
    
    if (key.integerValue == 2) {
        value = sexDict[value];
    }
    
    [self updateWithType:dict[lab.text] text:value];
}

- (void)updateWithType:(NSNumber *)type text:(NSString *)text{
    if ([_delegate respondsToSelector:@selector(updateMemberInfoKey:value:)]) {
        [_delegate updateMemberInfoKey:type value:text];
    }
}

- (void)refreshName{
    self.userName.text = User.MemberName;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}
@end
