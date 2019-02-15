//
//  WKBatchListView.h
//  秀加加
//
//  Created by sks on 2016/9/20.
//  Copyright © 2016年 walkingtec. All rights reserved.
//

#import "WKBaseTableView.h"
#import "WKGoodsBottomView.h"

@interface WKBatchListView : WKBaseTableView

- (instancetype)initWithFrame:(CGRect)frame with:(WKGoodsType)type;

- (NSArray *)getSelectedArr;

- (void)resetSelectedArr;

@property (strong, nonatomic) WKPromptView* promptView;

-(void)promptViewShow:(NSString *)message;
@end
