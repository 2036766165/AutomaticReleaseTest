//
//  WKAddressItem.h
//  秀加加
//
//  Created by sks on 2016/9/22.
//  Copyright © 2016年 walkingtec. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface WKAddressItem : NSObject

@property (nonatomic,copy) NSString *name;
@property (nonatomic,copy) NSArray *sub;
@property (nonatomic,copy) NSNumber *type;
@property (nonatomic,assign) BOOL isSelected;

@end
