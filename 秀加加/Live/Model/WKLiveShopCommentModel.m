//
//  WKLiveShopCommentModel.m
//  秀加加
//
//  Created by lin on 2016/10/12.
//  Copyright © 2016年 walkingtec. All rights reserved.
//

#import "WKLiveShopCommentModel.h"

@implementation WKLiveShopCommentModel

+ (NSDictionary *)modelContainerPropertyGenericClass
{
    return @{@"InnerList":[WKLiveShopCommentModelItem class]};
}
@end


@implementation WKLiveShopCommentModelItem

+ (NSDictionary *)modelContainerPropertyGenericClass
{
    return @{@"PicUrls":[NSString class]};
}

@end

//@implementation WKLiveShopCommentPicUrlItem
//
//
//@end
