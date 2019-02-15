//
//  WKContactViewController.m
//  秀加加
//
//  Created by lin on 16/9/7.
//  Copyright © 2016年 walkingtec. All rights reserved.
//

#import "WKContactViewController.h"
#import "WKContactTableView.h"

@interface WKContactViewController ()

@property (nonatomic,strong) WKContactTableView *contactTableView;
@property (nonatomic,strong) NSArray *content;

@end

@implementation WKContactViewController

- (WKContactTableView *)contactTableView
{
    if (!_contactTableView) {
        _contactTableView = [[WKContactTableView alloc] initWithFrame:CGRectMake(0, 32, WKScreenW, WKScreenH-64)];
        _contactTableView.backgroundColor = [UIColor whiteColor];
    }
    return _contactTableView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
   
    self.view.backgroundColor = [UIColor colorWithHex:0xF3F6FF];
    [self.view addSubview:self.contactTableView];
    
    [self initUi];
    
    [self event];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(void)initUi
{
    self.title = @"联系我们";
    self.content = @[WK_ServiceEmail,WK_BusCoopEmail];
}

-(void)event
{
    WeakSelf(WKContactViewController);
    self.contactTableView.selectClickType = ^(NSIndexPath *index){
//        [ELProgressView showWithRemider:@"复制成功"];
        UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
        pasteboard.string = weakSelf.content[index.row];
    };
}

@end
