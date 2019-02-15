//
//  XCShareTool.m
//  ShareSDKTEST
//
//  Created by Chang_Mac on 16/6/20.
//  Copyright © 2016年 Chang_Mac. All rights reserved.
//

#import "WKShareTool.h"
#import <ShareSDK/ShareSDK.h>

@implementation WKShareTool

+(void)shareShow:(WKShareModel *)model{
    [WKShareTool shareWithWeChat:model.shareImageArr andTitle:model.shareTitle andContent:model.shareContent andType:model.shareType :model.shareUrl :model.shopOwnerNo];
}

+(void)shareWithWeChat:(NSArray *)imageArr andTitle:(NSString *)shareTitle andContent:(NSString *)shareContent andType:(ShareType)type :(NSString *)urlStr :(NSString *)ownerNO{
    NSString *title;
    SSDKPlatformType platformType;
    if (type == SHAREFRIENDCIRRLE) {
        platformType = SSDKPlatformSubTypeWechatTimeline;
        title = shareContent;
    }else{
        platformType = SSDKPlatformSubTypeWechatSession;
        title = shareTitle;
    }
    NSMutableArray *imageArrCopy = @[].mutableCopy;
    for (id item in imageArr) {
        if (item == nil) {
            return;
        }else{
            UIImage *image;
            if ([item isKindOfClass:[UIImage class]]) {
                image = item;
            }else{
                image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:item]]];
            }
            UIGraphicsBeginImageContext(CGSizeMake(50, 50));
            [image drawInRect:CGRectMake(0, 0, 50, 50)];
            UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
            UIGraphicsEndImageContext();
            [imageArrCopy addObject:newImage];
            
        }
    }

    if (shareContent.length<1 || imageArr.count<1 || title.length<1) {
        [WKPromptView showPromptView:@"分享失败,请重试!"];
        return;
    }
    if ([urlStr isEqual:[NSNull null]]) {
        urlStr = @"www.baidu.com";
    }
    NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
    [shareParams SSDKSetupShareParamsByText:shareContent
                                     images:imageArrCopy //传入要分享的图片
                                        url:[NSURL URLWithString:urlStr]
                                      title:title
                                       type:SSDKContentTypeAuto];
    //进行分享
    [ShareSDK share:platformType //传入分享的平台类型
         parameters:shareParams
     onStateChanged:^(SSDKResponseState state, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error) { // 回调处理....}];
         if (error) {
             NSLog(@"请安装微信客户端");
//             [ELProgressView showWithRemider:@"请安装微信客户端"];
         }else if(state == SSDKResponseStateSuccess && ownerNO){
             NSString *urlStr = [NSString configUrl:WKShareAfter With:@[@"ShopOwnerNo"] values:@[ownerNO]];
             [WKHttpRequest shareWeChatAfter:HttpRequestMethodPost url:urlStr param:nil success:^(WKBaseResponse *response) {
                 
             } failure:^(WKBaseResponse *response) {
                 NSLog(@"%@",response);
             }];
         }
     }];
}
+ (UIImage *)compressImage:(UIImage *)imgSrc
{
    if([imgSrc isEqual:@""])
    {
        return imgSrc;
    }
    CGSize size = {100, 100};
    UIGraphicsBeginImageContext(size);
    CGRect rect = {{0,0}, size};
    [imgSrc drawInRect:rect];
    UIImage *compressedImg = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return compressedImg;
}
@end

@implementation WKShareModel


@end


