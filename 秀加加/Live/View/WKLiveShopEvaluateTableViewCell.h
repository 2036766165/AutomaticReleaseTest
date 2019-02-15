//
//  WKLiveShopEvaluateTableViewCell.h
//  秀加加
//
//  Created by lin on 2016/10/11.
//  Copyright © 2016年 walkingtec. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WKLiveShopCommentModel.h"

@interface WKLiveShopEvaluateTableViewCell : UITableViewCell

typedef enum{
    ClickLiveShopXinType = 1001, //点击星星
    ClickLiveShopPicType,          //点击图片
    ClickLiveShopAudioType,     //点击查看的语音
    ClickLiveShopReplyAudioType,//点击回复的语音
}LiveShopAudioType;

//1.评价等级    2.播放语音
typedef void (^ClickLiveShopType) (LiveShopAudioType type);

@property (nonatomic,copy) ClickLiveShopType clickLiveShopType;

@property (nonatomic,strong) UIButton *replyHornBtn;//喇叭

-(id)initWithStyle:(UITableViewCellStyle)style
   reuseIdentifier:(NSString *)reuseIdentifier;

-(void)setModelItem:(WKLiveShopCommentModelItem *)modelItem setRowIndex:(NSInteger) rowIndex;

//定义获得上次点击收听的按钮block函数
typedef void (^listenCommetBlock)(UIButton *sender);
@property (nonatomic,copy) listenCommetBlock listenBlock;
@end
