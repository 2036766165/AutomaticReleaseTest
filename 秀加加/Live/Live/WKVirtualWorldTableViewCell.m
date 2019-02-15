//
//  WKVirtualWorldTableViewCell.m
//  秀加加
//
//  Created by sks on 2017/2/15.
//  Copyright © 2017年 walkingtec. All rights reserved.
//

#import "WKVirtualWorldTableViewCell.h"
#import "WKVirtualLayout.h"
#import "WKVirtualWorldModel.h"
#import "WKImageModel.h"
//#import "WKCustomAlert.h"
#import "WKShowInputView.h"

@interface WKProfileView (){
    WKVirtualWorldModel *_virtualMd;
}
@end

@implementation WKProfileView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        // 用户头像
        UIImageView *iconImageV = [[UIImageView alloc] initWithFrame:CGRectMake(8, 8, 45, 45)];
        iconImageV.layer.cornerRadius = 5.0;
        iconImageV.clipsToBounds = YES;
        [self addSubview:iconImageV];
        
        self.iconImageV = iconImageV;
        
        // 名字
        UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(iconImageV.frame.origin.x + iconImageV.frame.size.width + 20, iconImageV.frame.origin.y, WKScreenW - iconImageV.frame.origin.x + iconImageV.frame.size.width + 25, 25)];
        nameLabel.textColor = [UIColor darkGrayColor];
        nameLabel.textAlignment = NSTextAlignmentLeft;
        nameLabel.font = [UIFont systemFontOfSize:14.0f];
        [self addSubview:nameLabel];
        self.nameLabel = nameLabel;
        
        // 日期
        UILabel *dateLabel=  [[UILabel alloc] initWithFrame:CGRectMake(iconImageV.frame.origin.x + iconImageV.frame.size.width + 20, nameLabel.frame.size.height + nameLabel.frame.origin.y + 5, 150, 15)];
        dateLabel.textAlignment = NSTextAlignmentLeft;
        dateLabel.font = [UIFont systemFontOfSize:12.0f];
        dateLabel.textColor = [UIColor lightGrayColor];
        [self addSubview:dateLabel];
        self.timeLabel = dateLabel;
        
        // 删除按钮
        UIButton *deleteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        deleteBtn.frame = CGRectMake(WKScreenW - 35, 30, 25, 25);
        [deleteBtn setImage:[UIImage imageNamed:@"delete_virtual"] forState:UIControlStateNormal];
        [deleteBtn addTarget:self action:@selector(deleteClick) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:deleteBtn];
        self.deleteBtn = deleteBtn;
    }
    return self;
}

- (void)setVirtualModel:(WKVirtualWorldModel *)md{
    _virtualMd = md;
    self.nameLabel.text = md.ShopOwnerName;
    self.timeLabel.text = md.CreateTime;
    [self.iconImageV sd_setImageWithURL:[NSURL URLWithString:md.ShopOwnerPicUrl] placeholderImage:[UIImage imageNamed:@"default_02"]];
}

- (void)deleteClick{
    [WKShowInputView showInputWithPlaceString:@"确定删除该商品?" type:LABELTYPE andBlock:^(NSString * Count) {
        if ([self.cell.delegate respondsToSelector:@selector(deleteVirtual:)]) {
            [self.cell.delegate deleteVirtual:_virtualMd];
        }
    }];
}

@end


@implementation WKStatusView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        // 个人信息
        WKProfileView *profileView = [[WKProfileView alloc] initWithFrame:CGRectZero];
        [self addSubview:profileView];
        self.profileView = profileView;
        
        //图片
//        UIView *imageBgView = [[UIView alloc] init];
//        [self addSubview:imageBgView];
        
        // 描述
        UILabel *descLabel = [[UILabel alloc] init];
        descLabel.textAlignment = NSTextAlignmentCenter;
        descLabel.font = [UIFont systemFontOfSize:14.0f];
        descLabel.textColor = [UIColor darkGrayColor];
        [self addSubview:descLabel];
        self.descLabel = descLabel;
        
        // 备注
        UILabel *memoLabel = [[UILabel alloc] init];
        memoLabel.textAlignment = NSTextAlignmentCenter;
        memoLabel.font = [UIFont systemFontOfSize:14.0f];
        memoLabel.textColor = [UIColor darkGrayColor];
        memoLabel.numberOfLines = 3;
        memoLabel.userInteractionEnabled = YES;
        [self addSubview:memoLabel];
        self.memoLabel = memoLabel;
        
        UITapGestureRecognizer *tapGes = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapAction)];
        [self.memoLabel addGestureRecognizer:tapGes];
    }
    return self;
}

-(void)tapAction{
    if ([self.cell.delegate respondsToSelector:@selector(tapMemoSelet:)]) {
        [self.cell.delegate tapMemoSelet:self.layout.dataModel.Memo];
    }
}

- (void)setLayout:(WKVirtualLayout *)layout{
    self.descLabel.text = layout.dataModel.GoodsName;
    self.memoLabel.text = layout.dataModel.Memo;
    [self.profileView setVirtualModel:layout.dataModel];
    self.profileView.cell = self.cell;
    self.profileView.frame = layout.profileRect;
    self.descLabel.frame = layout.DescRect;
    
    for (UIView *v in self.picArr) {
        [v removeFromSuperview];
    }
    
    NSMutableArray *arr = @[].mutableCopy;
    
    for (NSUInteger i=0; i<layout.dataModel.VirtualInfoList.count; i++) {
        WKImageModel *md = layout.dataModel.VirtualInfoList[i];
        
        UIImageView *imageView = [[UIImageView alloc] init];
        imageView.userInteractionEnabled = YES;
        imageView.tag = 100 + i;
        [imageView sd_setImageWithURL:[NSURL URLWithString:md.FileUrl] placeholderImage:[UIImage imageNamed:@"default_02"]];
        
        [arr addObject:imageView];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageTap:)];
        [imageView addGestureRecognizer:tap];
    }
    self.picArr = arr;
    
//    if (!self.picArr) {
//        
//    }
    
    for (NSUInteger j=0; j<self.picArr.count; j++) {
        NSDictionary *dict = layout.imageVRects[j];
        UIImageView *imageV = (UIImageView *)self.picArr[j];
        imageV.frame = CGRectMake([dict[@"x"] floatValue], [dict[@"y"] floatValue], [dict[@"size"] floatValue], [dict[@"size"] floatValue]);
        [self addSubview:imageV];
    }
    
    self.memoLabel.frame = layout.memoRect;
    
    _layout = layout;
}

- (void)imageTap:(UITapGestureRecognizer *)tap{
    if ([self.cell.delegate respondsToSelector:@selector(tapImageArr:Idx:)]) {
        [self.cell.delegate tapImageArr:self.layout.dataModel.VirtualInfoList Idx:tap.view.tag-100];
    }
}

@end


@implementation WKVirtualWorldTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.statusView = [[WKStatusView alloc] initWithFrame:CGRectZero];
        [self.contentView addSubview:self.statusView];
    }
    return self;
}

- (void)setLayout:(WKVirtualLayout *)layout{
    self.statusView.frame = CGRectMake(0, 0, WKScreenW, layout.height);
    self.statusView.cell = self;
    self.statusView.layout = layout;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
