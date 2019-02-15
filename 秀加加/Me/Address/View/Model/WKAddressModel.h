//
//  WKAddressModel.h
//  秀加加
//
//  Created by sks on 2016/9/22.
//  Copyright © 2016年 walkingtec. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WKAddressModel : NSObject

@property (nonatomic,copy) NSString *Address;
@property (nonatomic,copy) NSString *BPOID;
@property (nonatomic,copy) NSString *CityID;
@property (nonatomic,copy) NSString *CityName;
@property (nonatomic,copy) NSString *Contact;
@property (nonatomic,copy) NSString *CountyID;
@property (nonatomic,copy) NSString *CountyName;
@property (nonatomic,copy) NSString *CreateTime;
@property (nonatomic,copy) NSString *ID;
@property (nonatomic,assign) BOOL IsDefault;
@property (nonatomic,copy) NSString *Memo;

@property (nonatomic,copy) NSString *Phone;
@property (nonatomic,copy) NSString *PostCode;
@property (nonatomic,copy) NSString *ProvinceID;
@property (nonatomic,copy) NSString *ProvinceName;

@end

@interface WKAddressListModel : NSObject

@property (nonatomic,copy) NSNumber *AddressCount;
@property (nonatomic,strong) NSArray *InnerList;

@end

@interface WKAddressListItem : NSObject

@property (nonatomic,copy) NSString *Address;
@property (nonatomic,copy) NSString *BPOID;
@property (nonatomic,copy) NSString *CityID;
@property (nonatomic,copy) NSString *CityName;
@property (nonatomic,copy) NSString *Contact;
@property (nonatomic,copy) NSString *CountyID;
@property (nonatomic,copy) NSString *CountyName;
@property (nonatomic,copy) NSString *CreateTime;
@property (nonatomic,copy) NSString *ID;
@property (nonatomic,assign) BOOL IsDefault;
@property (nonatomic,copy) NSString *Memo;

@property (nonatomic,copy) NSString *Phone;
@property (nonatomic,copy) NSString *PostCode;
@property (nonatomic,copy) NSString *ProvinceID;
@property (nonatomic,copy) NSString *ProvinceName;

@property (nonatomic,assign) BOOL isSelected;

@end
