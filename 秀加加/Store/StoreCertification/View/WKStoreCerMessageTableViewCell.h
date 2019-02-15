//
//  WKStoreCerMessageTableViewCell.h
//  秀加加
//
//  Created by lin on 16/9/5.
//  Copyright © 2016年 walkingtec. All rights reserved.
//

#import <UIKit/UIKit.h>

@class WKAuthShopModel;

@interface WKStoreCerMessageTableViewCell : UITableViewCell

@property (nonatomic,strong) UILabel *name;
@property (nonatomic,strong) UIButton *shenFen;
@property (nonatomic,strong) UILabel *titleUp;
@property (nonatomic,strong) UILabel *titleDown;
@property (nonatomic,strong) UIButton *frontShenfen;

typedef void (^ClickPhoto)(int type,UIButton *btn);

@property (nonatomic,copy) ClickPhoto clickPhoto;

//- (void)setModel:(WKAuthShopModel *)model;

@end
