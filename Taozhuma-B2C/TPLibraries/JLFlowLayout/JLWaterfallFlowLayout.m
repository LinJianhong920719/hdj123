//
//  JLWaterfallFlowLayout.m
//  JLWaterfallFlow
//
//  Created by Jasy on 16/1/26.
//  Copyright © 2016年 Jasy. All rights reserved.
//

#import "JLWaterfallFlowLayout.h"

@interface JLWaterfallFlowLayout ()
@property (nonatomic, strong) NSMutableArray *colunMaxYArr;
@end

@implementation JLWaterfallFlowLayout

/*
 *  初始化layout后自动调动，可以在该方法中初始化一些自定义的变量参数
 */
-(void)prepareLayout
{
    [super prepareLayout];
    
    self.colunMaxYArr = [[NSMutableArray alloc]init];
    
    for (NSInteger i = 0; i < self.colCount; i++) {
        [self.colunMaxYArr addObject:@0];
    }
    
}

-(BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds
{
    return YES;
}

/*
 *  设置UICollectionView的内容大小，道理与UIScrollView的contentSize类似
 *  @return 返回设置的UICollectionView的内容大小
 */
-(CGSize)collectionViewContentSize
{
    NSInteger maxCol = 0;
    for (NSInteger i = 0; i < self.colCount; i ++) {
        if ([self.colunMaxYArr[i] floatValue] > [self.colunMaxYArr[maxCol] floatValue]) {
            maxCol = i;
        }
    }
    
    return CGSizeMake(0, [self.colunMaxYArr[maxCol] floatValue]);
}

/*
 *  初始Layout外观
 *  @param rect 所有元素的布局属性
 *  @return 所有元素的布局
 */
-(NSArray<UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect
{
    [self.colunMaxYArr removeAllObjects];
    for (NSInteger i = 0; i < self.colCount; i++) {
        [self.colunMaxYArr addObject:@0];
    }
    
    NSMutableArray *attrsArray = [NSMutableArray array];
    
    for (NSInteger i = 0; i < [self.collectionView numberOfSections]; i++) {
        //header
        UICollectionViewLayoutAttributes *headerAtts = [self layoutAttributesForSupplementaryViewOfKind:UICollectionElementKindSectionHeader atIndexPath:[NSIndexPath indexPathForItem:0 inSection:i]];
        [attrsArray addObject:headerAtts];
        
        //item
        NSInteger count = [self.collectionView numberOfItemsInSection:i];
        for (NSInteger j = 0; j < count; j++) {
            UICollectionViewLayoutAttributes *atts = [self layoutAttributesForItemAtIndexPath:[NSIndexPath indexPathForItem:j inSection:i]];
            [attrsArray addObject:atts];
        }
        
        //footer
        UICollectionViewLayoutAttributes *footerAtts = [self layoutAttributesForSupplementaryViewOfKind:UICollectionElementKindSectionFooter atIndexPath:[NSIndexPath indexPathForItem:0 inSection:i]];
        [attrsArray addObject:footerAtts];
    }
    return attrsArray;
}

/*
 *  根据不同的indexPath,给出布局
 *  @param indexPath
 *  @return 布局
 */
-(UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger minCol = 0;
    for (NSInteger i = 0; i < self.colCount; i ++) {
        if ([self.colunMaxYArr[i] floatValue] < [self.colunMaxYArr[minCol] floatValue]) {
            minCol = i;
        }
    }
    
    //宽度
    CGFloat width = (self.collectionView.frame.size.width - self.sectionInset.left - self.sectionInset.right - (self.colCount - 1) * self.colMargin)/self.colCount;
    //高度
    CGFloat height = 0;
    if ([self.delegate respondsToSelector:@selector(collectionView:layout:heightForWidth:atIndexPath:)]) {
        height = [self.delegate collectionView:self.collectionView layout:self heightForWidth:20 atIndexPath:indexPath];
    }
    
    CGFloat x = self.sectionInset.left + (width + self.colMargin) * minCol;
    
    CGFloat space = 0;
    if (indexPath.item < self.colCount) {
        space = self.sectionInset.top;
    }
    else
    {
        space = self.rowMargin;
    }
    CGFloat y = [self.colunMaxYArr[minCol] floatValue] + space;
    
    //更新对应列的高度
    [self.colunMaxYArr setObject:@(y + height) atIndexedSubscript:minCol];
    
    //计算位置
    UICollectionViewLayoutAttributes *attrItem = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
    attrItem.frame = CGRectMake(x, y, width, height);
    
    return attrItem;
}

-(UICollectionViewLayoutAttributes *)layoutAttributesForSupplementaryViewOfKind:(NSString *)elementKind atIndexPath:(NSIndexPath *)indexPath
{
    NSInteger maxCol = 0;
    for (NSInteger i = 0; i < self.colCount; i ++) {
        if ([self.colunMaxYArr[i] floatValue] > [self.colunMaxYArr[maxCol] floatValue]) {
            maxCol = i;
        }
    }
    
    //header
    if ([UICollectionElementKindSectionHeader isEqualToString:elementKind]) {
        UICollectionViewLayoutAttributes *attri = [UICollectionViewLayoutAttributes layoutAttributesForSupplementaryViewOfKind:UICollectionElementKindSectionHeader withIndexPath:indexPath];
        //size
        CGSize size = CGSizeZero;
        if ([self.delegate respondsToSelector:@selector(collectionView:layout:referenceSizeForHeaderInSection:)]) {
            size = [self.delegate collectionView:self.collectionView layout:self referenceSizeForHeaderInSection:indexPath.section];
        }
        CGFloat x = 0;
        CGFloat y = [self.colunMaxYArr[maxCol] floatValue];

        //更新所有对应列的高度
        for (NSInteger i = 0; i < self.colCount; i ++) {
            [self.colunMaxYArr setObject:@(y + size.height) atIndexedSubscript:i];
        }
        attri.frame = CGRectMake(x, y, size.width, size.height);
        return attri;
    }
    
    //footer
    else {
        UICollectionViewLayoutAttributes *attri = [UICollectionViewLayoutAttributes layoutAttributesForSupplementaryViewOfKind:UICollectionElementKindSectionFooter withIndexPath:indexPath];
        //size
        CGSize size = CGSizeZero;
        if ([self.delegate respondsToSelector:@selector(collectionView:layout:referenceSizeForFooterInSection:)]) {
            size = [self.delegate collectionView:self.collectionView layout:self referenceSizeForFooterInSection:indexPath.section];
        }
        CGFloat x = self.sectionInset.left;
        CGFloat y = [self.colunMaxYArr[maxCol] floatValue];
        
        //更新所有对应的高度
        for (NSInteger i = 0; i < self.colCount; i ++) {
            [self.colunMaxYArr setObject:@(y + size.height + self.sectionInset.bottom) atIndexedSubscript:i];
        }
        attri.frame = CGRectMake(x, y, size.width, size.height);
        return attri;
    }
}

@end
