//
//  WKLivePreView.h
//  wdbo
//
//  Created by sks on 16/6/29.
//  Copyright © 2016年 Walkingtec. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WKGoodsHorCollectionViewCell.h"

typedef enum : NSUInteger {
    WKLiveOpeartionLeave,
    WKLiveOpeartionContributor,
    WKLiveOpeartionVirtual,
    WKLiveOpeartionOnlineList,
    WKLiveOpeartionFoolActivity,
    WKLiveOpeartionRedEvenlope
} WKLiveOpeartion;

@class WKOnLineMd;

//typedef void (^BeautifulLevel) (NSInteger level);
typedef void (^btnAction)(NSInteger);//聊天1、红包2 回调

@protocol WKLivePreDelegate <NSObject>
/*
 0 美颜特效
 
 */
- (void)switchFilterType:(NSInteger)type;

/*
 0 反转摄像头
 1 开镜像
 */
- (void)controlCamearSingal:(NSInteger)singal;  // 切换摄像头

/*
 * 0 关闭
 * 1 录音棚
 * 2 KTV
 * 3 小舞台
 * 4 演唱会
 */
- (void)controlAudioSingal:(NSInteger)singal;   // 控制录音设备

//- (void)leaveLive;     // 离开直播

- (void)livePreOperation:(WKLiveOpeartion)operation;

@optional
- (void)rotationScreen;// 旋转屏幕
//- (void)selectedMessage
- (void)selectedIndexPerson:(WKOnLineMd *)md;
- (void)selectedIndexSelf;
- (void)operateType:(WKLiveOpeartion)type md:(id)md;

@end

@interface WKLivePreView : UIView

@property (nonatomic,copy) NSString *titleContent;
@property (nonatomic,weak) id <WKLivePreDelegate> delegate;
//@property (nonatomic,copy) BeautifulLevel beautifulLevel;
@property (copy, nonatomic) btnAction btnBlock;

@property (nonatomic,assign) NSInteger totalPerson;      // 总计观看人数
@property (nonatomic,assign) NSInteger currentPerson;    // 当前观看人数

- (instancetype)initWithFrame:(CGRect)frame type:(WKGoodsLayoutType)type;

- (void)setSingalStateWithIndex:(NSInteger)index;

- (void)setMuteWithBOPID:(NSString *)bpoid type:(NSInteger)type;

@end
