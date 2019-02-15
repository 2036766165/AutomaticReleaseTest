//
//  CollectionViewCell.h
//  FJTagCollectionView
//
//  Created by fujin on 16/1/12.
//  Copyright © 2016年 fujin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CollectionViewCell : UICollectionViewCell

typedef void (^ClickTypeCell) ();

@property (nonatomic,copy) ClickTypeCell clickTypeCell;
@property (strong, nonatomic) IBOutlet UILabel *contentLabel;
@property (strong, nonatomic) IBOutlet UIView *backGroupView;
@property (strong, nonatomic) NSIndexPath *indexPath;

@end
