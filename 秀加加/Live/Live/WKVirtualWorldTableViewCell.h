//
//  WKVirtualWorldTableViewCell.h
//  秀加加
//
//  Created by sks on 2017/2/15.
//  Copyright © 2017年 walkingtec. All rights reserved.
//

#import <UIKit/UIKit.h>

@class WKVirtualLayout,WKVirtualWorldTableViewCell,WKVirtualWorldModel;

@interface WKProfileView : UIView
@property (nonatomic,strong) UIImageView *iconImageV;
@property (nonatomic,strong) UILabel *nameLabel;
@property (nonatomic,strong) UILabel *timeLabel;
@property (nonatomic,strong) UIButton *deleteBtn;

@property (nonatomic,weak) WKVirtualWorldTableViewCell *cell;

- (void)setVirtualModel:(WKVirtualWorldModel *)md;

@end

@interface WKStatusView : UIView

@property (nonatomic,strong) WKProfileView *profileView; // 个人信息
@property (nonatomic,strong) UILabel *descLabel;         // 描述
@property (nonatomic,strong) NSArray<UIView *> *picArr;  // 图片
@property (nonatomic,strong) UILabel *memoLabel;         // 备注
@property (nonatomic,strong) WKVirtualLayout *layout;
@property (nonatomic,weak) WKVirtualWorldTableViewCell *cell;
@end

@protocol WKVirtualDelegate;

@interface WKVirtualWorldTableViewCell : UITableViewCell
@property (nonatomic,assign) id<WKVirtualDelegate> delegate;
@property (nonatomic,strong) WKStatusView *statusView;
- (void)setLayout:(WKVirtualLayout *)layout;

@end

@protocol WKVirtualDelegate <NSObject>
- (void)deleteVirtual:(WKVirtualWorldModel *)virtualWorld;
- (void)tapImageArr:(NSArray *)arr Idx:(NSInteger)idx;
- (void)tapMemoSelet:(NSString *)momeStr;
@end
