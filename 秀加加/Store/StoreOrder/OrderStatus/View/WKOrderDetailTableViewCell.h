//
//  WKOrderDetailTableViewCell.h
//  秀加加
//
//  Created by lin on 16/9/12.
//  Copyright © 2016年 walkingtec. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WKOrderDetailModel.h"
#import "PlayerManager.h"
@interface WKOrderDetailTableViewCell : UITableViewCell<PlayingDelegate>

//3.编辑  1.播放语音
typedef void (^SelectType) (NSInteger type);

@property (nonatomic,copy) SelectType selectType;

@property (nonatomic,strong) UIImageView *headImgaeView;

-(void)setItem:(WKOrderProducts *)item  model:(WKOrderDetailModel *)model type:(NSInteger)type;

@end
