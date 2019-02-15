//
//  WKGetLocation.h
//  原生地图
//
//  Created by sks on 16/8/30.
//  Copyright © 2016年 sks. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>

typedef void(^CompletionBlock)(id);

@interface WKAnnotationTest : NSObject <MKAnnotation>

@property (nonatomic,copy) NSString *title;
@property (nonatomic,copy) NSString *subtitle;

@property (nonatomic,copy) NSString *province;
@property (nonatomic,copy) NSString *city;
@property (nonatomic,copy) NSString *country;

@property (nonatomic,copy) NSString *street;

@property (nonatomic,assign) CLLocationCoordinate2D coordinate;

@end

@interface WKGetLocation : NSObject

- (void)getLocationCompletion:(CompletionBlock)completion;

- (void)getAnnotationWith:(CLLocationCoordinate2D)coordinate completion:(CompletionBlock)block;

@end
