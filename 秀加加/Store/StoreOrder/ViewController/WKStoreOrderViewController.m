//
//  WKStoreOrderViewController.m
//  秀加加
//
//  Created by lin on 16/9/2.
//  Copyright © 2016年 walkingtec. All rights reserved.
//

#import "WKStoreOrderViewController.h"
#import "WKShopOrderViewController.h"
#import "WKSellOrderViewController.h"
#import "OrderTypeSelectorController.h"

@interface WKStoreOrderViewController ()<WEPopoverControllerDelegate>
@property NSInteger selectedindex;

@end

@implementation WKStoreOrderViewController

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:YES];
    self.navigationController.interactivePopGestureRecognizer.enabled = YES;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:YES];
    self.navigationController.interactivePopGestureRecognizer.enabled = NO;
}

-(void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self initUi];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(triggerAction:) name:@"ordertypeselect" object:nil];
    [self xw_postNotificationWithName:@"SHOPREDDOT" userInfo:@{@"isHidden":@true,@"type":@(2)}];
}

-(void) triggerAction:(NSNotification *) notification
{
    NSDictionary *dict = notification.userInfo;
    NSIndexPath* index = (NSIndexPath*)dict[@"index"];
    _selectedindex = index.row;
    NSString* labelname = @"";
    if(index.row == 0){
        labelname = @"全部";
    }
    if(index.row == 1){
        labelname = @"普通";
    }
    if(index.row == 2){
        labelname = @"拍卖";
    }
    if(index.row == 3){
        labelname = @"幸运";
    }
    [((UIButton*)self.navigationItem.rightBarButtonItem.customView.subviews[0]) setTitle:labelname forState:UIControlStateNormal];
    if (self.popController) {//如果视图已弹出，则点击就是关闭视图
        [self.popController dismissPopoverAnimated:YES];
        self.popController = nil;
    }
    
}

-(void)initUi
{
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithImageAndTitle:[UIImage imageNamed:@"typelist"] selImage:[UIImage imageNamed:@"typelist"] title:@"全部" target:self action:@selector(filter)];
    
}

-(void)filter{
    if (self.popController) {//如果视图已弹出，则点击就是关闭视图
        [self.popController dismissPopoverAnimated:YES];
        self.popController = nil;
    }
    else{
        OrderTypeSelectorController *contentViewController = [[OrderTypeSelectorController alloc]initWithStyle:UITableViewStylePlain];
        contentViewController.selectedIndex = _selectedindex;
        self.popController = [[CustomPopover alloc] initWithContentViewController:contentViewController];
        self.popController.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.0];
        self.popController.delegate = self;
        self.popController.passthroughViews = [NSArray arrayWithObject:self.navigationController.navigationBar];
        
        [self.popController presentPopoverFromBarButtonItem:self.navigationItem.rightBarButtonItem
                                   permittedArrowDirections:(UIPopoverArrowDirectionUp)
                                                   animated:YES];
    }
}

- (void)popoverControllerDidDismissPopover:(WEPopoverController *)popoverController {
    self.popController = nil;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
