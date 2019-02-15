//
//  WKPersonEditHeadView.m
//  秀加加
//
//  Created by lin on 16/9/13.
//  Copyright © 2016年 walkingtec. All rights reserved.
//

#import "WKPersonEditHeadView.h"
#import "NSObject+WKImagePicker.h"

@interface WKPersonEditHeadView()

@property (nonatomic,strong) UIVisualEffectView *effectview;

@end

@implementation WKPersonEditHeadView

- (id) initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.imageview = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
        self.imageview.userInteractionEnabled = YES;
        [self addSubview:self.imageview];
        
        self.imageview.contentMode = UIViewContentModeScaleAspectFill;
        UIBlurEffect *blur = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
        self.effectview = [[UIVisualEffectView alloc] initWithEffect:blur];
        self.effectview.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
        self.effectview.alpha = 0;
        self.effectview.userInteractionEnabled = YES;
        [self.imageview addSubview:self.effectview];
        
        UIImage *centerImage = [UIImage imageNamed:@"bianjizanwutouxiang"];
        self.centerImageView = [[UIImageView alloc] init];
        self.centerImageView.layer.borderColor = [UIColor lightGrayColor].CGColor;
        self.centerImageView.layer.borderWidth = 3.0;
        
        [self.centerImageView sd_setImageWithURL:[NSURL URLWithString:User.MemberPhotoMinUrl] placeholderImage:centerImage];
        self.centerImageView.userInteractionEnabled = YES;

        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(selectImage)];
        [self.centerImageView addGestureRecognizer:tap];
        [self.imageview addSubview:self.centerImageView];
        [self.centerImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.imageview).offset((WKScreenW-centerImage.size.width)/2);
            make.top.equalTo(self.imageview).offset(50);
            make.size.mas_equalTo(CGSizeMake(centerImage.size.width, centerImage.size.height));
        }];
        
        UIImageView *editView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"edit"]];
        [self.centerImageView addSubview:editView];
        [editView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.centerImageView.mas_right).offset(0);
            make.bottom.equalTo(self.centerImageView.mas_bottom).offset(0);
            make.size.sizeOffset(CGSizeMake(editView.image.size.width, editView.image.size.height));
        }];
    
        self.name = [[UILabel alloc] init];
        self.name.font = [UIFont systemFontOfSize:16];
        self.name.textColor = [UIColor colorWithHex:0x8E716D];
        self.name.textAlignment = NSTextAlignmentCenter;
        self.name.text = User.MemberName;
        [self.imageview addSubview:self.name];
        [self.name mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.imageview).offset(0);
            make.top.equalTo(self.centerImageView.mas_bottom).offset(20);
            make.right.equalTo(self.imageview.mas_right).offset(0);
            make.size.mas_equalTo(CGSizeMake(WKScreenW, 17));
        }];
    }

    return self;
}

-(void)setImageName:(UIImage *)imageName{
    self.imageview.image = imageName;//[UIImage imageNamed:imageName];
}

- (void)selectImage{
    // 上传头像
    [self captureImageWith:^(UIImage *image) {
       
        [WKHttpRequest uploadImages:HttpRequestMethodPost url:WKUploadImage fileArr:@[image] success:^(WKBaseResponse *response) {
            
            NSArray *arr = response.Data;
            [self updateMemberInfoKey:@4 value:[arr firstObject]];
            self.centerImageView.image = image;
            User.MemberPhotoMinUrl = [arr firstObject];
            
        } failure:^(WKBaseResponse *response) {
            
        }];
        
    }];
}

- (void)updateMemberInfoKey:(NSNumber *)key value:(NSString *)value{
    
    NSString *url = [NSString configUrl:WKMemberUpdateInfo With:@[@"Key",@"Value"] values:@[[NSString stringWithFormat:@"%@",key],value]];
    
    [WKHttpRequest updateMemberInfo:HttpRequestMethodPost url:url param:@{} success:^(WKBaseResponse *response) {
        _LOGD(@"response : %@",response);
    } failure:^(WKBaseResponse *response) {
        
    }];
}

-(void)setHeight:(CGFloat)height
{
    self.frame = CGRectMake(0, -height, self.frame.size.width, height);
    self.imageview.frame = CGRectMake(0, 0, self.frame.size.width, height);
    self.effectview.frame = CGRectMake(0, 0, self.frame.size.width, height);
    self.effectview.alpha = (height-290)/(WKScreenH-290-90);
}
@end
