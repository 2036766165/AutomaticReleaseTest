//
//  WKGetLocation.m
//  原生地图
//
//  Created by sks on 16/8/30.
//  Copyright © 2016年 sks. All rights reserved.
//

#import "WKGetLocation.h"
#import <UIKit/UIKit.h>

@implementation WKAnnotationTest


@end

@interface WKGetLocation () <CLLocationManagerDelegate> {
//    CLLocationManager *_locationManager;// 位置管理
    CLGeocoder *_clgeoCoder;            // 地理编码
    CompletionBlock _block;             // 获取地址
    CompletionBlock _block1;            // 反地理编码
}

@property (nonatomic,strong) CLLocationManager *locationManager;

@end

@implementation WKGetLocation

- (instancetype)init{
    if (self = [super init]) {
        self.locationManager = [[CLLocationManager alloc] init];
        _clgeoCoder = [[CLGeocoder alloc] init];
    }
    return self;
}

- (void)getLocationCompletion:(CompletionBlock)completion{

    if (![CLLocationManager locationServicesEnabled]) {
        NSLog(@"定位服务尚未打开,请设置打开");
    }
    // 位置管理
    self.locationManager.delegate = self;
    
    if ([[[UIDevice currentDevice] systemVersion] doubleValue] > 8.0)
    {
        //设置定位权限 仅ios8有意义
        [self.locationManager requestWhenInUseAuthorization];// 前台定位
    }
    
    _locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters;
    CLLocationDistance distance = 100.0;
    _locationManager.distanceFilter = distance;
    [self.locationManager startUpdatingLocation];

    // 区域监听的方法
    //self.locationManager requestStateForRegion:<#(nonnull CLRegion *)#>
    
    _block = [completion copy];
}

- (void)getAnnotationWith:(CLLocationCoordinate2D)coordinate completion:(CompletionBlock)block{
    
    CLLocation *location = [[CLLocation alloc] initWithLatitude:coordinate.latitude longitude:coordinate.longitude];
    
    [_clgeoCoder reverseGeocodeLocation:location completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
        
        CLPlacemark *placeMark = [placemarks firstObject];
            
        if (block) {
            NSDictionary *addressDict = placeMark.addressDictionary;
            WKAnnotationTest *annotation = [[WKAnnotationTest alloc] init];
            annotation.title = @"您的位置是";
            annotation.subtitle = [NSString stringWithFormat:@"%@",placeMark.name];
            annotation.coordinate = placeMark.location.coordinate;
            annotation.city = addressDict[@"City"];
            annotation.country = addressDict[@"SubLocality"];
            annotation.province = addressDict[@"State"];
            annotation.street = addressDict[@"Street"];
            block(annotation);
        }
    }];
}

#pragma mark - location delegate
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations{

    CLLocation *location = [locations lastObject];
    NSLog(@"定位到了地址");
    
    [_clgeoCoder reverseGeocodeLocation:location completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
        
        CLPlacemark *placeMark = [placemarks firstObject];
        
        if (_block) {
            NSLog(@"placeMark : %@",placeMark.addressDictionary);
            
            NSDictionary *addressDict = placeMark.addressDictionary;
            
            WKAnnotationTest *annotation = [[WKAnnotationTest alloc] init];
            annotation.title = @"您的位置是";
            annotation.subtitle = [NSString stringWithFormat:@"%@",placeMark.name];
            annotation.coordinate = placeMark.location.coordinate;
            annotation.city = addressDict[@"City"];
            annotation.country = addressDict[@"SubLocality"];
            annotation.province = addressDict[@"State"];
            
            annotation.street = addressDict[@"Street"];
            
            _block(annotation);
        }
    }];
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error{
    if (_block) {
        WKAnnotationTest *annotation = [[WKAnnotationTest alloc] init];
        annotation.city = @"";
        _block(annotation);
    }
}

- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status{
    if (status == kCLAuthorizationStatusDenied) {
        if (_block) {
            WKAnnotationTest *annotation = [[WKAnnotationTest alloc] init];
            annotation.city = @"火星";
            _block(annotation);
        }
    }
}

-(void)dealloc{
    _locationManager = nil;
}

@end
