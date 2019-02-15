//
//  WKHorizontalList.m
//  秀加加
//
//  Created by sks on 2016/10/10.
//  Copyright © 2016年 walkingtec. All rights reserved.
//

#import "WKHorizontalList.h"

@interface WKHorizontalList ()

//@property (nonatomic) CGFloat minimumLineSpacing; //行间距
//
//@property (nonatomic) CGFloat minimumInteritemSpacing; //item间距
//
//@property (nonatomic) CGSize itemSize; //item大小
//
//@property (nonatomic) UIEdgeInsets sectionInset;
@end

//static long  pageNumber = 1;
//static int line = 2;

@implementation WKHorizontalList

- (void)prepareLayout{
    [super prepareLayout];
//    self.itemSize = CGSizeMake(WKScreenW/2 - 20, 1.618 * WKScreenW/2 - 10);
//    self.minimumLineSpacing = 10;
//    self.minimumInteritemSpacing = 10;
//    self.sectionInset = UIEdgeInsetsMake(5, 10, 5, 10);
    
    self.scrollDirection = UICollectionViewScrollDirectionHorizontal | UICollectionViewScrollDirectionVertical;
    
//    NSInteger itemNumber = [self.collectionView numberOfItemsInSection:0];
//    pageNumber = itemNumber%2 == 0?itemNumber/2:itemNumber/2 + 1;
}

//- (CGSize)collectionViewContentSize{
//    return CGSizeMake(self.collectionView.bounds.size.width * pageNumber, self.collectionView.frame.size.height);
//}

//- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds{
//    return YES;
//}

/*
 * set collectionView stopped location
 @param proposedContentOffset : stopped location
 @param velocity : the scrolling speed
 */
//- (CGPoint)targetContentOffsetForProposedContentOffset:(CGPoint)proposedContentOffset withScrollingVelocity:(CGPoint)velocity{
//    // 计算最后停止滑动的rect
//    CGRect lastRect;
//    lastRect.origin = proposedContentOffset;
//    lastRect.size = self.collectionView.frame.size;
//    
//    //
////    CGFloat centerX = proposedContentOffset.x + self.collectionView.frame.size.width/2;
//    
//    // 计算这个范围内的item
//    NSArray *items = [self layoutAttributesForElementsInRect:lastRect];
//    CGFloat adjustCenterX = MAXFLOAT;
//    UICollectionViewLayoutAttributes *lastAttri;
//    
//    
//    for (int i=0; i<items.count; i++) {
//        UICollectionViewLayoutAttributes *attri = items[i];
//        if (ABS(attri.frame.origin.x - proposedContentOffset.x) < adjustCenterX) {
//            adjustCenterX = attri.frame.origin.x - proposedContentOffset.x;
//            lastAttri = attri;
//        }
//    }
//    
//    CGFloat offsetX = proposedContentOffset.x - lastAttri.size.width;
//    if (offsetX <= lastAttri.size.width/2) {
//        return proposedContentOffset;
//    }
//    
////    for (UICollectionViewLayoutAttributes *attri in items) {
////        
////        if (ABS(attri.frame.origin.x - proposedContentOffset.x) < adjustCenterX) {
////            adjustCenterX = attri.frame.origin.x - proposedContentOffset.x;
////            lastAttri = attri;
////        }
////    }
//    
//    
//    return CGPointMake(lastAttri.frame.origin.x - 10, proposedContentOffset.y);
//
////    if (lastAttri.frame.origin.x + lastAttri.frame.size.width >= self.collectionView.contentSize.width) {
////        return CGPointMake(self.collectionView.contentSize.width - lastAttri.frame.size.width, proposedContentOffset.y);
////    }else{
////    }
//    
//}

//- (instancetype)init {
//    self = [super init];
//    if (self) {
//        self.scrollDirection = UICollectionViewScrollDirectionHorizontal;
////        self.minimumInteritemSpacing = LAYOUT_ITEM_OFFSET * 2;
//    }
//    return self;
//}

//- (CGPoint)targetContentOffsetForProposedContentOffset: (CGPoint)proposedContentOffset withScrollingVelocity:(CGPoint)velocity //自动对齐到网格
//{
//    //proposedContentOffset是没有对齐到网格时本来应该停下的位置
//    CGFloat offsetY = MAXFLOAT;
//    CGFloat offsetX = MAXFLOAT;
//    CGFloat horizontalCenter = proposedContentOffset.x + self.itemSize.width/2;
//    CGFloat verticalCenter = proposedContentOffset.y + self.itemSize.height/2;
//    CGRect targetRect = CGRectMake(0, 0.0, self.collectionView.bounds.size.width, self.collectionView.bounds.size.height);
//    NSArray* array = [super layoutAttributesForElementsInRect:targetRect];
//    
//    //对当前屏幕中的UICollectionViewLayoutAttributes逐个与屏幕中心进行比较，找出最接近中心的一个
//    CGPoint offPoint = proposedContentOffset;
//    for (UICollectionViewLayoutAttributes* layoutAttributes in array) {
//        CGFloat itemHorizontalCenter = layoutAttributes.center.x;
//        CGFloat itemVerticalCenter = layoutAttributes.center.y;
//        if (ABS(itemHorizontalCenter - horizontalCenter) && (ABS(offsetX)>ABS(itemHorizontalCenter - horizontalCenter))) {
//            offsetX = itemHorizontalCenter - horizontalCenter;
//            offPoint = CGPointMake(itemHorizontalCenter, itemVerticalCenter);
//        }
//        if (ABS(itemVerticalCenter - verticalCenter) && (ABS(offsetY)>ABS(itemVerticalCenter - verticalCenter))) {
//            offsetY = itemHorizontalCenter - horizontalCenter;
//            offPoint = CGPointMake(itemHorizontalCenter, itemVerticalCenter);
//        }
//    }
//    return offPoint;
//}

//- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect
//{
//    NSArray *array = [super layoutAttributesForElementsInRect:rect];
//    
//    CGRect visibleRect = (CGRect){self.collectionView.contentOffset, self.collectionView.bounds.size};
//    
//    for (UICollectionViewLayoutAttributes *attributes in array) {
//        
//        if (CGRectIntersectsRect(attributes.frame, rect)) {
//            
//            attributes.alpha = 0.5;
//            
//            CGFloat distance = CGRectGetMidX(visibleRect) - attributes.center.x;//distance to screen center
////            CGFloat normalizedDistance = distance / 20;
//            
////            if (ABS(distance) < ActiveDistance) {
////                CGFloat zoom = 1 + ScaleFactor * (1 - ABS(normalizedDistance)); //zoom in
////                attributes.transform3D = CATransform3DMakeScale(zoom, zoom, 1.0);
////                attributes.zIndex = 1;
////                attributes.alpha = 1.0;
////            }
//            
//        }
//    }
//    
//    return array;
//}

//- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath{
//    UICollectionViewLayoutAttributes *attributes = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
//    CGRect frame;
//    frame.size = self.itemSize;
//    frame.origin = CGPointMake(indexPath.item * (self.itemSize.width + self.minimumInteritemSpacing + self.sectionInset.right + self.sectionInset.left), self.minimumLineSpacing + self.sectionInset.top);
//    attributes.frame = frame;
//    return attributes;
//}

@end
