//
//  CollectionViewCell.m
//  FJTagCollectionView
//
//  Created by fujin on 16/1/12.
//  Copyright © 2016年 fujin. All rights reserved.
//

#import "CollectionViewCell.h"

@interface CollectionViewCell()

@end

@implementation CollectionViewCell

- (void)awakeFromNib
{
    [super awakeFromNib];
    self.backGroupView.layer.masksToBounds = YES;
    self.backGroupView.layer.cornerRadius = 5.0;
    self.backGroupView.layer.borderWidth = 0.5;
    self.backGroupView.layer.borderColor = [UIColor colorWithHex:0x8A8D9D].CGColor;
    
    self.contentLabel.textColor = [UIColor colorWithHex:0x8A8D9D];
    UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(gestureEvent)];
    [self.backGroupView addGestureRecognizer:gesture];
}

-(void)gestureEvent
{
    if(_clickTypeCell)
    {
        _clickTypeCell();
    }
}

@end
