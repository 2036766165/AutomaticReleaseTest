//
//  WKPersonEditTableViewCell.h
//  秀加加
//
//  Created by lin on 16/9/5.
//  Copyright © 2016年 walkingtec. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IQDropDownTextField.h"

@interface WKPersonEditTableViewCell : UITableViewCell

@property (nonatomic,strong) UILabel *name;
@property (nonatomic,strong) IQDropDownTextField *content;
@property (nonatomic,strong) UIImageView *goImageView;

@end
