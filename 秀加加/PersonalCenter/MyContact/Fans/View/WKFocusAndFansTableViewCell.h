//
//  WKFocusAndFansTableViewCell.h
//  秀加加
//
//  Created by lin on 16/9/6.
//  Copyright © 2016年 walkingtec. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WKAttentionModel.h"

typedef enum{
    ClickHead = 1,          //点击头像
    ClickMessage,           //点击信息
    ClickFocus,             //点击关注
    ClickFocusNot,          //取消关注
    ClickShare,             //点击分享
    ClickLive               //点击进入直播
}ClickType;

@interface WKFocusAndFansTableViewCell : UITableViewCell

//@property (nonatomic,strong) UIButton *shareAnFocus;

typedef void (^ClickCallBack) (ClickType type);

@property (nonatomic,copy) ClickCallBack clickCallBack;

-(void)getItem:(WKAttentionItemModel *)item type:(NSInteger)type;

@end
