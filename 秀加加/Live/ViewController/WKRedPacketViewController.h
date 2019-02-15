//
//  WKRedPacketViewController.h
//  秀加加
//
//  Created by Chang_Mac on 17/3/14.
//  Copyright © 2017年 walkingtec. All rights reserved.
//

#import "ViewController.h"

@interface WKRedPacketViewController : ViewController

@property (assign, nonatomic) NSInteger type;//1.个人红包  2.群红包
@property (copy, nonatomic) NSString * receiveBPOID;//1v1红包接收人 bpoid
@property (strong, nonatomic) NSString * memberNo;//房间号
@property (strong, nonatomic) NSString * memberName;

@end

