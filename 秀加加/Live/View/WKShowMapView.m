//
//  WKShowMapView.m
//  秀加加
//
//  Created by lin on 2016/10/18.
//  Copyright © 2016年 walkingtec. All rights reserved.
//

#import "WKShowMapView.h"
#import <MapKit/MapKit.h>
#import "WKGetLocation.h"
#import "WKGetShopAuthenticationModel.h"

@interface WKShowMapView()<MKMapViewDelegate>
{
    WKGetShopAuthenticationModel *_location;
}

@property (nonatomic,strong) MKMapView *mapView;

//@property (nonatomic,strong) WKGetLocation *location;

@property (nonatomic,strong) WKAnnotationTest *annotation;

@property (nonatomic,copy) void(^showBlock)();

@end


@implementation WKShowMapView

- (instancetype)initWithFrame:(CGRect)frame location:(WKGetShopAuthenticationModel *)location showBlock:(void (^)())block
{
    if (self = [super initWithFrame:frame])
    {
        if (block) {
            self.showBlock = block;
        }
        
        _location = location;
        [self initUi];
    }
    return self;
}

-(void)initUi
{
    _annotation = [[WKAnnotationTest alloc] init];
    
    self.backgroundColor = [UIColor whiteColor];
    
    _mapView = [[MKMapView alloc] initWithFrame:self.bounds];
//    _mapView.showsUserLocation = YES;
    _mapView.delegate = self;
    _mapView.userTrackingMode = MKUserTrackingModeFollow;
    _mapView.mapType = MKMapTypeStandard;
    [self addSubview:_mapView];
    
    WKAnnotationTest *ann = [[WKAnnotationTest alloc] init];
    CLLocationCoordinate2D point = CLLocationCoordinate2DMake(_location.ShopLat.doubleValue, _location.ShopLong.doubleValue);
    ann.coordinate = point;
    ann.title = [NSString stringWithFormat:@"%@%@%@",_location.ProvinceName,_location.CityName,_location.CountyName];
    ann.subtitle = _location.ShopAddress;
    
    [_mapView addAnnotation:ann];
    
    _annotation = ann;
    
    [_mapView selectAnnotation:ann animated:YES];
    
    [_mapView setCenterCoordinate:ann.coordinate animated:YES];

    MKCoordinateRegion region;
    region.span.latitudeDelta = 0.05;
    region.span.longitudeDelta = 0.05;
    region.center = _annotation.coordinate;
    // 设置显示位置(动画)
    [_mapView setRegion:region animated:YES];
    // 设置地图显示的类型及根据范围进行显示
    [_mapView regionThatFits:region];
    
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        dispatch_async(dispatch_get_main_queue(), ^{
//        });
//    });
    

    UIView *headView = [[UIView alloc] init];
    headView.backgroundColor = [UIColor whiteColor];
    UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(backGesture)];
    [headView addGestureRecognizer:gesture];
    [self addSubview:headView];
    [headView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(0);
        make.top.equalTo(self).offset(0);
        make.right.equalTo(self.mas_right).offset(0);
        make.height.mas_equalTo(64);
    }];
    
    UIImage *backImage = [UIImage imageNamed:@"back"];
    UIButton *backBtn = [[UIButton alloc] init];
    [backBtn setImage:backImage forState:UIControlStateNormal];
    [backBtn setTitle:@"返回" forState:UIControlStateNormal];
    backBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    backBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, -20);
    [backBtn setTitleColor:[UIColor colorWithHex:0xB4B5B9] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(backEvent:) forControlEvents:UIControlEventTouchUpInside];
    [headView addSubview:backBtn];
    [backBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(headView.mas_right).offset(-10);
        make.top.equalTo(headView).offset((64-backImage.size.height)/2);
        make.size.mas_equalTo(CGSizeMake(backImage.size.width+40,20));
    }];
}

- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation{
    mapView.showsUserLocation = NO;
}

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation
{
    if ([annotation isKindOfClass:[MKUserLocation class]])
    {
        return nil;
    }
    static NSString *ID = @"annotation";
    MKPinAnnotationView *annotationView = (MKPinAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:ID];
    if (annotationView == nil) {
        annotationView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:ID];
        //设置大头针颜色
        annotationView.pinTintColor = [UIColor colorWithRed:0.13 green:0.81 blue:0.63 alpha:1.00];
        //设置为动画掉落的效果
        annotationView.animatesDrop = YES;
        //显示详情
        annotationView.canShowCallout = YES;
    }
    annotationView.annotation = annotation;
    return annotationView;
}

-(void)backEvent:(UIButton *)sender
{
    [UIView animateWithDuration:0.5 animations:^{
        self.frame = CGRectMake(WKScreenW, 0,WKScreenW, WKScreenH);
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
        
        if (self.showBlock) {
            self.showBlock();
        }
    }];
}

-(void)backGesture
{
    [UIView animateWithDuration:0.5 animations:^{
        self.frame = CGRectMake(WKScreenW, 0,WKScreenW, WKScreenH);
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

@end
