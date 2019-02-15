//
//  WKImageCollectionViewCell.m
//  秀加加
//
//  Created by sks on 2017/2/9.
//  Copyright © 2017年 walkingtec. All rights reserved.
//

#import "WKImageCollectionViewCell.h"
#import "WKImageModel.h"
#import "WKCellOperationProtocol.h"

@interface WKImageCollectionViewCell () <WKCellOperationProtocol>
@property (weak, nonatomic) IBOutlet UIImageView *goodsImageV;
@property (weak, nonatomic) IBOutlet UIButton *delBtn;

@end

@implementation WKImageCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setImageMd:(WKImageModel *)md{
    self.delBtn.hidden = md.isNormal;
    
    if (md.image || md.isNormal) {
        self.goodsImageV.image = md.image;
    }else{
        NSString *imageUrl;
        if (md.FileUrl) {
            imageUrl = md.FileUrl;
        }else{
            imageUrl = md.PicUrl;
        }
        [self.goodsImageV sd_setImageWithURL:[NSURL URLWithString:imageUrl] placeholderImage:[UIImage imageNamed:@"default_02"]];
    }
}

- (IBAction)delClick:(id)sender {
    if ([_delegate respondsToSelector:@selector(opeartionCell:type:)]) {
        [_delegate opeartionCell:self type:WKOpeartionTypeDel];
    }
}

@end
