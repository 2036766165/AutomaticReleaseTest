//
//  OrderTypeCell.h
//  秀加加
//
//  Created by liuliang on 2017/2/18.
//  Copyright © 2017年 walkingtec. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OrderTypeCell : UITableViewCell

@property UILabel* typelabel;
@property UIImageView* typeimg;

-(void)setData:(NSString*)txt img:(NSString*)img;
@end
