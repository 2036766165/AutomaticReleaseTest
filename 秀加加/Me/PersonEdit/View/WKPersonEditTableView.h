//
//  WKPersonEditTableView.h
//  秀加加
//
//  Created by lin on 16/9/5.
//  Copyright © 2016年 walkingtec. All rights reserved.
//

#import "WKBaseTableView.h"

@protocol WKMemberInfoProtocol <NSObject>
- (void)updateMemberInfoKey:(NSNumber *)key value:(NSString *)value;
@end

@interface WKPersonEditTableView : WKBaseTableView

@property (nonatomic,weak) id <WKMemberInfoProtocol> delegate;

- (void)refreshName;

typedef void (^ClickType) ();

@property (nonatomic,copy) ClickType clickType;

@property (nonatomic,strong) UIImageView *headView;

@property (nonatomic,strong) UIImageView *centerImageView;

@property (nonatomic,strong) UILabel *userName;

@end
