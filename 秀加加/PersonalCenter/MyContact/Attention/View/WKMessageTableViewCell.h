//
//  WKMessageTableViewCell.h
//  秀加加
//
//  Created by lin on 2016/9/20.
//  Copyright © 2016年 walkingtec. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WKMessageTableViewCell : UITableViewCell

typedef void (^SelectClickTypeCell) ();

@property (nonatomic,copy) SelectClickTypeCell selectClickTypeCell;

@end
