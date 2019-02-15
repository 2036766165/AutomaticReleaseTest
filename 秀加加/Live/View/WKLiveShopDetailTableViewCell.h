//
//  WKLiveShopDetailTableViewCell.h
//  秀加加
//
//  Created by lin on 2016/10/11.
//  Copyright © 2016年 walkingtec. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WKLiveShopListModel.h"

//@protocol WKLiveShopDetailTableViewCellDelegate <NSObject>
//
//-(void)setCellHeight;
//
//@end

@interface WKLiveShopDetailTableViewCell : UITableViewCell

@property (nonatomic,strong) UIImageView *shopImageView;

@property (nonatomic,strong) WKLiveShopPicModelItem *item;

typedef void (^PicBlock) ();

@property (nonatomic,copy) PicBlock picBlock;

@end
