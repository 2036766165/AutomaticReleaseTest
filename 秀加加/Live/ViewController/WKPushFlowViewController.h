//
//  WKPushFlowViewController.h
//  秀加加
//
//  Created by lin on 2016/9/26.
//  Copyright © 2016年 walkingtec. All rights reserved.
//

#import "ViewController.h"

#import <AVFoundation/AVFoundation.h>
#import <libksygpulive/libksygpulive.h>
#import "WKGoodsHorCollectionViewCell.h"

@class KSYGPUStreamerKit,WKKSYConfigModel,KSYBeautifyFaceFilter,KSYBuildInSpecialEffects,GPUImageFilterGroup;
//@class WKKSYConfigModel;

@interface WKPushFlowViewController : ViewController

- (instancetype)initStreamCfg:(WKKSYConfigModel *)config;

@end

// 金山云推流配置
@interface WKKSYConfigModel : NSObject

// 采集分辨率
@property (nonatomic,copy) NSString *capResolution;

// 推流分辨率
@property (nonatomic,assign) CGSize streamResolution;

// 摄像头朝向
@property (nonatomic,assign) AVCaptureDevicePosition capPosition;

// 像素格式
@property (nonatomic,assign) OSType osType;

// 视频编码器
@property (nonatomic,assign) KSYVideoCodec videoCodec;
// 音频编码器
@property (nonatomic,assign) KSYAudioCodec audioCodec;
    
// 视频帧率
@property (nonatomic,assign) int videoFPS;
    
// 起始码率
@property (nonatomic,assign) int videoInitBitrate;

// 最大码率
@property (nonatomic,assign) int videoMaxBitrate;
    
// 最小码率
@property (nonatomic,assign) int videoMinBitrate;
    
// 音频码率
@property (nonatomic,assign) int audiokBPS;

// 宽带估计模式
@property (nonatomic,assign) KSYBWEstimateMode bwEstMode;

// 屏幕模式
@property (nonatomic,assign) WKGoodsLayoutType screenType;

/*前摄像头镜像*/
@property (nonatomic,assign) BOOL frontMirror;

/*后摄像头镜像*/
@property (nonatomic,assign) BOOL backMirror;

@end

/*金山云推流配置*/
@interface WKCurFilter : NSObject

/*美颜滤镜*/
@property (nonatomic,strong) KSYBeautifyFaceFilter *beautyFilter;

/*特效滤镜*/
@property (nonatomic,strong) KSYBuildInSpecialEffects *specialEffectFilter;

// 用滤镜组 将 滤镜 串联成整体
@property (nonatomic,strong) GPUImageFilterGroup *groupFilter;



@end

