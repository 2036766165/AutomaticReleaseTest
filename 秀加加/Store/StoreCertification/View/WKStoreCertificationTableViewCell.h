//
//  WKStoreCertificationTableViewCell.h
//  秀加加
//
//  Created by lin on 16/9/5.
//  Copyright © 2016年 walkingtec. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WKStoreCertificationTableViewCell : UITableViewCell

@property (nonatomic,strong) UILabel *name;
@property (nonatomic,strong) UITextField *content;
@property (nonatomic,strong) UIImageView *goImageView;

typedef void (^SelectOrigin)();

@property (nonatomic,copy) SelectOrigin selectOrigin;

@end
