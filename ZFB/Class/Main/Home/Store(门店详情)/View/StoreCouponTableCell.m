//
//  StoreCouponTableCell.m
//  ZFB
//
//  Created by  展富宝  on 2017/11/20.
//  Copyright © 2017年 com.zfb. All rights reserved.
//

#import "StoreCouponTableCell.h"
#import "CouponCollectionCell.h"
@interface StoreCouponTableCell ()<UICollectionViewDataSource,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>


@end
@implementation StoreCouponTableCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.selectionStyle = UITableViewCellSelectionStyleNone;

    self.couponCollectionView.delegate = self;
    self.couponCollectionView.dataSource = self;
 
    self.couponCollectionView.backgroundColor = HEXCOLOR(0xffffff);
    [self.couponCollectionView registerNib:[UINib nibWithNibName:@"CouponCollectionCell" bundle:nil] forCellWithReuseIdentifier:@"CouponCollectionCell"];
    
}
#pragma mark -  UIcollectionView 代理方法
//返回section个数
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}
//每个section的item个数
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return _couponArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CouponCollectionCell  *cell = (CouponCollectionCell *)[self.couponCollectionView dequeueReusableCellWithReuseIdentifier:@"CouponCollectionCell" forIndexPath:indexPath];
    
    return cell;
}

//设置每个item的尺寸
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
 
    return CGSizeMake( KScreenW *0.5-30, 55);
}

//设置每个item的UIEdgeInsets
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(10,  10 , 10, 10);
    
}

//点击item方法
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@" item === %ld ",indexPath.item);

    if ( [self.delegate respondsToSelector:@selector(didClickCouponlistIndex:andCouponId:)]) {
        [self.delegate  didClickCouponlistIndex:indexPath.row andCouponId:@""];
    }
    
}

-(void)reload_CollectionView
{
    [self.couponCollectionView reloadData];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
