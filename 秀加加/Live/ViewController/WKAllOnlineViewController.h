//
//  WKAllOnlineViewController.h
//  秀加加
//
//  Created by sks on 2017/2/26.
//  Copyright © 2017年 walkingtec. All rights reserved.
//

#import "ViewController.h"

@interface WKAllOnlineViewController : ViewController

- (instancetype)initWithMemberNo:(NSString *)memberNo;

@end

@interface WKOnlineListMd : NSObject

@property (nonatomic,copy) NSString *bpoid;
@property (nonatomic,copy) NSString *ml;
@property (nonatomic,copy) NSString *mn;
@property (nonatomic,copy) NSString *mno;
@property (nonatomic,copy) NSString *murl;

@property (nonatomic,copy) NSString *no;

@end
