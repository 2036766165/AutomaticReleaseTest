//
//  WKRedViewDetails.h
//  秀加加
//
//  Created by Chang_Mac on 17/3/20.
//  Copyright © 2017年 walkingtec. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WKRedBagDetailsModel.h"
@interface WKRedViewDetails : UIView

@property (strong, nonatomic) WKRedBagDetailsModel * model;
@property (strong, nonatomic) UITableView *tablview;
-(UIView *)createHeadView;

@end

@interface WKRedViewCell : UITableViewCell

@property (strong, nonatomic) InnerList * model;
@property (strong, nonatomic) UIButton * luckBtn;

@end
