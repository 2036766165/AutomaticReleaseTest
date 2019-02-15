//
//  WKQrScanningViewController.m
//  wdbo
//  标题：扫描二维码功能
//  Created by Chang_Mac on 16/7/4.
//  Copyright © 2016年 Walkingtec. All rights reserved.
//

#import "WKQrScanningViewController.h"
#import <AVFoundation/AVFoundation.h>

@interface WKQrScanningViewController ()<AVCaptureMetadataOutputObjectsDelegate>

@property (nonatomic, strong) AVCaptureSession *session;
@property (nonatomic, strong) CALayer     *scanLayer;            //扫描图层
@property (nonatomic, strong) UIView      *boxView;              //扫面框
@property (nonatomic, strong) UIView    *backGroundView;

@end

@implementation WKQrScanningViewController

-(void)viewDidLoad{
    [super viewDidLoad];
    self.title = @"扫描二维码";
    [self QrCodeEvent];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(void)initUi
{
    self.backGroundView = [[UIView alloc] initWithFrame:CGRectMake(0, 20, WKScreenW, 44)];
    [self.view addSubview:self.backGroundView];
    
    
    UIImage *backImg = [UIImage imageNamed:@"mine_comeback_arrow"];
    UIButton *backBtn = [[UIButton alloc] init];
    [backBtn setImage:backImg forState:UIControlStateNormal];
    [self.backGroundView addSubview:backBtn];
    [backBtn addTarget:self action:@selector(backEvent:) forControlEvents:UIControlEventTouchUpInside];
    [backBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.backGroundView).offset(15);
        make.top.equalTo(self.backGroundView).offset((44-backImg.size.height)/2);
        make.size.mas_equalTo(CGSizeMake(backImg.size.width, backImg.size.height));
    }];
}

-(void)backEvent:(UIButton *)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)QrCodeEvent
{
    AVCaptureDevice * device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    
    //创建输入流
    AVCaptureDeviceInput * input = [AVCaptureDeviceInput deviceInputWithDevice:device error:nil];
    
    //创建输出流
    AVCaptureMetadataOutput * output = [[AVCaptureMetadataOutput alloc]init];
    
    //设置代理 在主线程里刷新
    [output setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
    
    //定义选择区域的范围
    CGFloat width = self.view.layer.bounds.size.width;
    CGFloat height = self.view.layer.bounds.size.height;
    CGFloat boxWidth = WKScreenW - 100;
    CGFloat boxX = (width - boxWidth)/2;
    CGFloat boxY = (height - boxWidth)/2;
    
    //获取扫描的范围
    CGRect cropRect = CGRectMake(boxX, boxY, boxWidth, boxWidth);
    output.rectOfInterest = CGRectMake (cropRect.origin.y/height, cropRect.origin.x/width, cropRect.size.height/height,cropRect.size.width/width);
    
    //设置选择区域的四周颜色
    [self SetView:cropRect];
    
    //初始化链接对象
    _session = [[AVCaptureSession alloc]init];
    
    //高质量采集率
    [_session setSessionPreset:AVCaptureSessionPresetHigh];
    
    if([_session canAddInput:input])
    {
        [_session addInput:input];
    }
    
    if([_session canAddOutput:output])
    {
        [_session addOutput:output];
    }
    
    //设置扫码支持的编码格式(如下设置条形码和二维码兼容)
    output.metadataObjectTypes=@[AVMetadataObjectTypeQRCode,AVMetadataObjectTypeEAN13Code, AVMetadataObjectTypeEAN8Code, AVMetadataObjectTypeCode128Code];
    
    //设置预览图层
    AVCaptureVideoPreviewLayer * layer = [AVCaptureVideoPreviewLayer layerWithSession:_session];
    layer.videoGravity = AVLayerVideoGravityResizeAspectFill;
    layer.frame = self.view.layer.bounds;
    [self.view.layer insertSublayer:layer atIndex:0];
    
    //设置扫描框的位置
    self.boxView = [[UIView alloc]initWithFrame:cropRect];
    self.boxView.layer.borderColor = [UIColor whiteColor].CGColor;
    self.boxView.layer.borderWidth = 1.0f;
    [self.view addSubview:self.boxView];
        
    //扫描线，居中闪烁
    self.scanLayer = [[CALayer alloc] init];
    self.scanLayer.frame = CGRectMake(0,boxWidth/2 ,boxWidth, 3);
    self.scanLayer.backgroundColor = [UIColor greenColor].CGColor;
    [self.boxView.layer addSublayer:self.scanLayer];
    [self.scanLayer addAnimation:[self opacityForever_Animation:0.5] forKey:nil];
    
    //提示语
    UILabel *showTitle = [[UILabel alloc] init];
    showTitle.text = @"将条形码对准框的中间,即可自动扫描";
    showTitle.textAlignment = NSTextAlignmentCenter;
    showTitle.font = [UIFont systemFontOfSize:12];
    showTitle.textColor = [UIColor whiteColor];
    [self.view addSubview:showTitle];
    [showTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(0);
        make.right.equalTo(self.view.mas_right).offset(0);
        make.top.equalTo(self.boxView.mas_bottom).offset(10);
        make.height.mas_equalTo(20);
    }];
    
    
//    NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:0.1f target:self selector:@selector(moveScanLayer:) userInfo:nil repeats:YES];
//    
//    [timer fire];

    //开始捕获
    [_session startRunning];
}

-(void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection{
    if (metadataObjects.count>0) {
        AVMetadataMachineReadableCodeObject * metadataObject = [metadataObjects objectAtIndex : 0 ];
        self.scnningBlock(metadataObject.stringValue);
        [_session stopRunning];
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)moveScanLayer:(NSTimer *)timer
{
//    CGRect frame = self.scanLayer.frame;
//    if (_boxView.frame.size.height <= _scanLayer.frame.origin.y + 10) {
//        frame.origin.y = -20;
//        _scanLayer.frame = frame;
//    }else{
//        
//        frame.origin.y += 10;
//        
//        [UIView animateWithDuration:0.1 animations:^{
//            _scanLayer.frame = frame;
//        }];
//    }
}

//设置永久闪烁
-(CABasicAnimation *)opacityForever_Animation:(float)time
{
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"opacity"];
    animation.fromValue = [NSNumber numberWithFloat:1.0f];
    animation.toValue = [NSNumber numberWithFloat:0.0f];
    animation.autoreverses = YES;
    animation.duration = time;
    animation.repeatCount = MAXFLOAT;
    animation.removedOnCompletion = NO;
    animation.fillMode = kCAFillModeForwards;
    animation.timingFunction=[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
    return animation;
}

//设置周围的层半透明
-(void)SetView:(CGRect)rect
{
    CGFloat width = self.view.bounds.size.width;
    
    UIView *topView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, width,rect.origin.y)];
    topView.backgroundColor = [UIColor blackColor];
    topView.layer.opacity = 0.6;
    
    UIView *leftView = [[UIView alloc]initWithFrame:CGRectMake(0, rect.origin.y, rect.origin.x, rect.size.height)];
    leftView.backgroundColor = [UIColor blackColor];
    leftView.layer.opacity = 0.6;
    
    UIView *rightView = [[UIView alloc]initWithFrame:CGRectMake(rect.origin.x + rect.size.width, rect.origin.y, rect.origin.x,rect.size.height)];
    rightView.backgroundColor = [UIColor blackColor];
    rightView.layer.opacity = 0.6;
    
    UIView *bottomView = [[UIView alloc]initWithFrame:CGRectMake(0, rect.origin.y + rect.size.height, width,rect.origin.y)];
    bottomView.backgroundColor = [UIColor blackColor];
    bottomView.layer.opacity = 0.6;
    
    [self.view addSubview:topView];
    [self.view addSubview:leftView];
    [self.view addSubview:rightView];
    [self.view addSubview:bottomView];
}

@end
