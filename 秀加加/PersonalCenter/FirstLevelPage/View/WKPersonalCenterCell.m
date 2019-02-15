//
//  WKPersonalCenterCell.m
//  秀加加
//
//  Created by Chang_Mac on 17/2/7.
//  Copyright © 2017年 walkingtec. All rights reserved.
//

#import "WKPersonalCenterCell.h"
#import "WKDottedView.h"
@interface WKPersonalCenterCell ()


@end

@implementation WKPersonalCenterCell

-(instancetype)init{
    if (self = [super init]) {
        [self createUI];
    }
    return self;
}

-(void)createUI{
    self.backgroundColor = [UIColor colorWithHexString:@"f3f6ff"];
    self.whiteBackView = [[UIView alloc]initWithFrame:CGRectMake(WKScreenW*0.05,0, WKScreenW*0.9, WKScreenW*0.15)];
    self.whiteBackView.backgroundColor = [UIColor whiteColor];
    
    [self.contentView addSubview:self.whiteBackView];
    
    self.headIM = [[UIImageView alloc]initWithFrame:CGRectMake(WKScreenW*0.05, WKScreenW*0.05, WKScreenW*0.053, WKScreenW*0.05)];
    [self.whiteBackView addSubview:self.headIM];
    
    self.titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(WKScreenW*0.13, WKScreenW*0.055, WKScreenW*0.3, WKScreenW*0.04)];
    self.titleLabel.font = [UIFont systemFontOfSize:WKScreenW*0.04];
    self.titleLabel.textColor = [UIColor colorWithHexString:@"7e879d"];
    [self.whiteBackView addSubview:self.titleLabel];
    
    self.dottedView = [WKDottedView createDottedViewWithFrame:CGRectMake(WKScreenW*0.05, WKScreenW*0.135, WKScreenW*0.9, WKScreenW*0.03)];
    [self.contentView addSubview:self.dottedView];
    
    self.rightContentBtn = [[UIButton alloc]initWithFrame:CGRectMake(WKScreenW*0.53, WKScreenW*0.05, WKScreenW*0.3, WKScreenW*0.05)];
    [self.rightContentBtn setTitleColor:[UIColor colorWithHexString:@"ff6600"] forState:UIControlStateNormal];
    self.rightContentBtn.titleLabel.font = [UIFont systemFontOfSize:WKScreenW*0.04];
    self.rightContentBtn.userInteractionEnabled = NO;
    self.rightContentBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    [self.whiteBackView addSubview:self.rightContentBtn];
    
    UIImageView *goIM = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"Personal_right_arrow"]];
    goIM.frame = CGRectMake(WKScreenW*0.84, WKScreenW*0.06, WKScreenW*0.02, WKScreenW*0.03);
    [self.whiteBackView addSubview:goIM];
    
    self.redView = [[UIView alloc]initWithFrame:CGRectMake(WKScreenW*0.053, -2.5, 5, 5)];
    [self.redView layoutIfNeeded];
    self.redView.layer.cornerRadius = 2.5;
    self.redView.hidden = YES;
    self.redView.backgroundColor = [UIColor colorWithWholeRed:253 green:100 blue:30];
    [self.headIM addSubview:self.redView];
    
}

@end
