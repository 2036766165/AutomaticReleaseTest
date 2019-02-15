//
//  WKTagModel.h
//  aa
//
//  Created by Chang_Mac on 16/9/21.
//  Copyright © 2016年 Chang_Mac. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WKTagModel : NSObject

@property (strong, nonatomic) NSString * RootSort;
@property (strong, nonatomic) NSString * RootTagName;
@property (strong, nonatomic) NSArray * TagList;

@end

@interface WkTagTitle : NSObject

@property (strong, nonatomic) NSString * Sort;
@property (strong, nonatomic) NSString * TagColor;
@property (strong, nonatomic) NSString * TagName;
@property (strong, nonatomic) NSIndexPath * indexPath;

@end





