//
//  WKAddAddressTableViewCell.h
//  秀加加
//
//  Created by sks on 2016/9/22.
//  Copyright © 2016年 walkingtec. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WKAddAddressTableViewCell : UITableViewCell

//- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier;

@property (nonatomic,strong) UILabel *titleLabel;

@property (nonatomic,strong) UITextView *contentTextView;
@property (nonatomic,strong) UITextField *contentTextField;

@end
