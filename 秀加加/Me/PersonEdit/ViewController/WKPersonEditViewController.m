//
//  WKPersonEditViewController.m
//  秀加加
//
//  Created by lin on 16/9/5.
//  Copyright © 2016年 walkingtec. All rights reserved.
//

#import "WKPersonEditViewController.h"
#import "WKPersonEditTableView.h"
#import "WKPersonEditTableViewCell.h"
#import "NSObject+XWAdd.h"
#import "NSObject+WKImagePicker.h"

@interface WKPersonEditViewController () <WKMemberInfoProtocol>

@property (nonatomic,strong) WKPersonEditTableView *personEditTableView;

@end

@implementation WKPersonEditViewController

- (WKPersonEditTableView *)personEditTableView
{
    if (!_personEditTableView) {
        _personEditTableView = [[WKPersonEditTableView alloc] initWithFrame:CGRectMake(0, 32, WKScreenW, WKScreenH) style:UITableViewStyleGrouped];
        _personEditTableView.delegate = self;
    }
    
    return _personEditTableView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"编辑";
    self.view.backgroundColor = [UIColor whiteColor];
    [self event];
    [self.view addSubview:self.personEditTableView];
}

-(void)event
{
    WeakSelf(WKPersonEditViewController);
    self.personEditTableView.clickType = ^(){
        [weakSelf selectImage];
    };
}

//修改头像
- (void)selectImage{
    WeakSelf(WKPersonEditViewController);
    [weakSelf captureImageWith:^(UIImage *image) {
        [WKHttpRequest uploadImages:HttpRequestMethodPost url:WKUploadImage fileArr:@[image] success:^(WKBaseResponse *response) {
            NSArray *arr = response.Data;
            [self updateMemberInfoKey:@4 value:[arr firstObject]];
            self.personEditTableView.centerImageView.image = image;
            User.MemberPhotoMinUrl = [arr firstObject];
        } failure:^(WKBaseResponse *response) {
            [WKProgressHUD showTopMessage:response.ResultMessage];
        }];
        
    }];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self xw_postNotificationWithName:@"person" userInfo:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(void)updateMemberInfoKey:(NSNumber *)key value:(NSString *)value{
    
    if(key.integerValue == 1)
    {
        if(value.length == 0)
        {
            [WKProgressHUD showTopMessage:@"请输入昵称！"];
            return;
        }
        else if(value.length > 16)
        {
            [WKProgressHUD showTopMessage:@"昵称限制16个字符！"];
            return;
        }
    }
    
    NSString *url = [NSString configUrl:WKMemberUpdateInfo With:@[@"Key",@"Value"] values:@[[NSString stringWithFormat:@"%@",key],[NSString stringWithFormat:@"%@",value]]];
    
    [WKHttpRequest updateMemberInfo:HttpRequestMethodPost url:url param:@{} success:^(WKBaseResponse *response) {
        if (key.integerValue == 1)
        {
            User.MemberName = value;
            [self.personEditTableView refreshName];
        }
        else if (key.integerValue == 2)
        {
            User.Sex = [NSNumber numberWithInt:value.intValue];
        }
        else if(key.integerValue == 3)
        {
            User.Birthday = value;
        }
        else
        {
            User.MemberPhotoUrl = value;
            User.MemberPhotoMinUrl = value;
        }
    } failure:^(WKBaseResponse *response) {
        [WKProgressHUD showTopMessage:response.ResultMessage];
    }];
}

@end
