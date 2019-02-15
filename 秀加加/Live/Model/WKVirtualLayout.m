//
//  WKVirtualLayout.m
//  秀加加
//
//  Created by sks on 2017/2/15.
//  Copyright © 2017年 walkingtec. All rights reserved.
//

#import "WKVirtualLayout.h"
#import "WKVirtualWorldModel.h"

@implementation WKVirtualLayout

//@dynamic dataModel;

- (void)setDataModel:(WKVirtualWorldModel *)dataModel{
    CGFloat height = 0;
    
    self.profileRect = CGRectMake(0, 0, WKScreenW, 60);
    height += 60;     // person info
    
    CGSize descSize = [NSString sizeWithText:dataModel.GoodsName font:[UIFont systemFontOfSize:14.0] maxSize:CGSizeMake(WKScreenW - 20, 10000)];
    self.DescRect = CGRectMake(10, height, descSize.width, descSize.height + 5);
    height += self.DescRect.size.height;   // desc height
    
    NSInteger column = 3;
    NSInteger row = dataModel.VirtualInfoList.count%column == 0? dataModel.VirtualInfoList.count/3: dataModel.VirtualInfoList.count/column + 1;
    CGFloat spacing = 10;
    CGFloat itemWidth = (WKScreenW - (column + 1) * spacing)/3;
    
    NSMutableArray *rectArr = @[].mutableCopy;
    
    for (NSUInteger i=0; i<dataModel.VirtualInfoList.count; i++) {
        CGFloat itemX = spacing + i%column * (itemWidth + spacing);
        CGFloat itemY = height + spacing + i/column * (itemWidth + 10);
        
        NSDictionary *rectDict = @{@"x":@(itemX),
                                   @"y":@(itemY),
                                   @"size":@(itemWidth)
                                   };
        [rectArr addObject:rectDict];
    }
    self.imageVRects = rectArr;
    
    height += (spacing + itemWidth) * row;    // image height
    
    // 备注
    CGSize memoSize = [NSString sizeWithText:dataModel.Memo font:[UIFont systemFontOfSize:14.0f] maxSize:CGSizeMake(WKScreenW - 20, 14*4)];
    self.memoRect = CGRectMake(10, height, memoSize.width, memoSize.height + 10);
    height += self.memoRect.size.height + 10;
    
    self.height = height;    // memo height
    _dataModel = dataModel;
}




@end
