//
//  FJTagCollectionLayout.h
//  CollectionView
//
//  Created by fujin on 16/1/12.
//  Copyright © 2016年 fujin. All rights reserved.
//

#import <UIKit/UIKit.h>
UIKIT_EXTERN NSString *const UICollectionElementKindSectionHeader;
UIKIT_EXTERN NSString *const UICollectionElementKindSectionFooter;

@class FJTagCollectionLayout;
@protocol FJTagCollectionLayoutDelegate <NSObject>
@required
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(FJTagCollectionLayout*)collectionViewLayout widthAtIndexPath:(NSIndexPath *)indexPath;

@optional
//section header
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(FJTagCollectionLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section;
//section footer
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(FJTagCollectionLayout*)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section;
@end

@interface FJTagCollectionLayout : UICollectionViewLayout
@property (nonatomic, weak) id<FJTagCollectionLayoutDelegate> delegate;

@property(nonatomic, assign) UIEdgeInsets sectionInset; //sectionInset
@property(nonatomic, assign) CGFloat lineSpacing;  //line space
@property(nonatomic, assign) CGFloat itemSpacing; //item space
@property(nonatomic, assign) CGFloat itemHeigh;  //item heigh

@end
