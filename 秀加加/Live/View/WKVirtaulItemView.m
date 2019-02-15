//
//  WKVirtaulItemView.m
//  秀加加
//
//  Created by sks on 2016/10/14.
//  Copyright © 2016年 walkingtec. All rights reserved.
//

#import "WKVirtaulItemView.h"
#import "WKVirtualGiftModel.h"
#import "UIImage+Gif.h"

@interface WKVirtaulItemView ()

@property (nonatomic,strong) UIImageView *virImage;
@property (nonatomic,strong) UILabel *nameLabel;
@property (nonatomic,strong) UILabel *priceLabel;
@property (nonatomic,strong) UILabel *numberLabel;

@end

@implementation WKVirtaulItemView

- (instancetype)initWithFrame:(CGRect)frame virModel:(WKVirtualGiftModel *)virModel{
    if (self = [super initWithFrame:frame]) {
        self.virtualModel = virModel;
        self.virtualModel.gifCount = 0;
        [self setupViews];
    }
    return self;
}

- (void)setupViews{
    
    // 图片
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:_virtualModel.virtualImage]];
    self.virImage = imageView;
    [self addSubview:imageView];

    // 价格
    UILabel *lab = [UILabel new];
    lab.text = self.virtualModel.virtualPrice;
    lab.textColor = [UIColor whiteColor];
    lab.font = [UIFont systemFontOfSize:14.0f];
    lab.textAlignment = NSTextAlignmentCenter;
    self.priceLabel = lab;
    [self addSubview:lab];
    
    // 名字
    UILabel *lab0 = [UILabel new];
    lab0.text = self.virtualModel.virtualName;
    lab0.textColor = [UIColor colorWithHexString:@"#FC6620"];
    lab0.font = [UIFont systemFontOfSize:14.0f];
    lab0.textAlignment = NSTextAlignmentCenter;
    self.nameLabel = lab0;
    [self addSubview:lab0];
    
    // 打赏个数
    UILabel *lab1 = [UILabel new];
    lab1.text = self.virtualModel.virtualName;
    lab1.backgroundColor = [UIColor colorWithHexString:@"#FC6620"];
    lab1.textColor = [UIColor whiteColor];
    lab1.font = [UIFont systemFontOfSize:12.0f];
    lab1.textAlignment = NSTextAlignmentCenter;
    self.numberLabel = lab1;
    self.numberLabel.hidden = YES;
    [self addSubview:lab1];
    
    // 布局
    [self layoutUI];
    
    [self.virtualModel addObserver:self forKeyPath:@"showGif" options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld context:NULL];
    
    [self.virtualModel addObserver:self forKeyPath:@"gifCount" options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld context:NULL];
}

- (void)layoutUI{
    
    [self.virImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.mas_top).offset(3);
        make.centerX.mas_equalTo(self);
        make.size.mas_equalTo(CGSizeMake(self.virImage.image.size.width * 0.7, self.virImage.image.size.height * 0.7));
    }];
    
    [self.priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.virImage.mas_bottom).offset(0);
        make.right.and.left.mas_equalTo(self);
        make.height.mas_equalTo(@20);
    }];
    
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.priceLabel.mas_bottom).offset(0);
        make.right.and.left.mas_equalTo(self);
        make.height.mas_equalTo(@20);
    }];
    
    [self.numberLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_offset(5);
        make.right.mas_equalTo(self.mas_right).offset(-5);
        make.size.mas_offset(CGSizeMake(18, 18));
    }];
    
    self.numberLabel.layer.cornerRadius = 18/2;
    self.numberLabel.clipsToBounds = YES;
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context{
    if ([keyPath isEqualToString:@"showGif"]) {
        NSInteger isShowGif = [change[NSKeyValueChangeNewKey] integerValue];
        
        if (!isShowGif) {
            self.virImage.image = [UIImage imageNamed:self.virtualModel.virtualImage];
        }else{
            NSString *gifPath = [[NSBundle mainBundle] pathForResource:self.virtualModel.virtualImage ofType:@"gif"];
            self.virImage.image = [UIImage animatedImageWithAnimatedGIFURL:[NSURL fileURLWithPath:gifPath]];
        }
    }else{
        
        NSInteger count = [change[NSKeyValueChangeNewKey] integerValue];
        
        if (count == 0) {
            self.numberLabel.hidden = YES;
        }else{
            self.numberLabel.hidden = NO;
            self.numberLabel.text = [NSString stringWithFormat:@"%zd",self.virtualModel.gifCount];
        }
    }
}

- (void)dealloc{
    [self.virtualModel removeObserver:self forKeyPath:@"showGif"];
    [self.virtualModel removeObserver:self forKeyPath:@"gifCount"];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
