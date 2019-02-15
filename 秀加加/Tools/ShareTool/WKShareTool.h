//
//  XCShareTool.h
//  ShareSDKTEST
//
//  Created by Chang_Mac on 16/6/20.
//  Copyright © 2016年 Chang_Mac. All rights reserved.
//

#import <Foundation/Foundation.h>
//分享枚举
typedef NS_ENUM(NSInteger,ShareType){
    SHAREFRIENDCIRRLE,
    SHARECONTACT,
} ;

@class WKShareModel;
@interface WKShareTool : NSObject

+(void)shareShow:(WKShareModel *)model;

/**
 *  分享
 *
 *  @param imageArr     要分享的图片
 *  @param shareTitle   分享标题
 *  @param shareContent 分享内容
 *  @param type         分享类型
 */
+(void)shareWithWeChat:(NSArray *)imageArr andTitle:(NSString *)shareTitle andContent:(NSString *)shareContent andType:(ShareType)type :(NSString *)urlStr :(NSString *)ownerNO;


@end

@interface WKShareModel : NSObject

@property (strong, nonatomic) NSArray * shareImageArr;
@property (strong, nonatomic) NSString * shareTitle;
@property (strong, nonatomic) NSString * shareContent;
@property (assign, nonatomic) ShareType shareType;
@property (strong, nonatomic) NSString * shareUrl;
@property (strong, nonatomic) NSString * shopOwnerNo;

@end

