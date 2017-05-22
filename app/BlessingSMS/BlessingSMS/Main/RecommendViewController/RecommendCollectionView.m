//
//  RecommendCollectionView.m
//  BlessingSMS
//
//  Created by hp on 2017/5/22.
//  Copyright © 2017年 hxp. All rights reserved.
//

#import "RecommendCollectionView.h"

@implementation RecommendCollectionView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end


#define ITEM_SPACING  (10)

@implementation RecommendCollectionViewFlowLayout
{
    CGFloat _totallHeight;
    NSMutableDictionary *_sectionHeightDic;
}


- (instancetype)init
{
    self = [super init];
    if (self) {
        
        self.scrollDirection = UICollectionViewScrollDirectionVertical;
        self.minimumInteritemSpacing = ITEM_SPACING;
        self.minimumLineSpacing = ITEM_SPACING;
        self.sectionInset = UIEdgeInsetsMake(ITEM_SPACING,ITEM_SPACING,0,ITEM_SPACING);

        CGFloat width = (SCREEN_WIDTH - 30) / 2;
        self.itemSize = CGSizeMake(width, width + 93);
        
    }
    return self;
}


- (CGSize)collectionViewContentSize
{
    NSInteger itemCount = [self.collectionView numberOfItemsInSection:0];
    CGFloat height = self.itemSize.height;
    CGSize contentSize = CGSizeMake(SCREEN_WIDTH, ceil(itemCount/2.0) * (height + ITEM_SPACING));
    return contentSize;
}

-(BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds {
    return YES;
}


@end
