//
//  StoreListTableViewCell.m
//  ZFB
//
//  Created by 熊维东 on 2017/9/16.
//  Copyright © 2017年 com.zfb. All rights reserved.
//

#import "StoreListTableViewCell.h"
#import "ZFDetailStoreCell.h"

@interface StoreListTableViewCell ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>

@end
@implementation StoreListTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    self.storeListCollectionView.delegate = self;
    self.storeListCollectionView .dataSource = self;
    self.storeListCollectionView.scrollEnabled = NO;
    
    [self.storeListCollectionView registerNib:[UINib nibWithNibName:@"ZFDetailStoreCell" bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:@"ZFDetailStoreCellid"];
    
}

-(void)setStoreListArray:(NSMutableArray *)storeListArray{
    
    _storeListArray = [NSMutableArray array];
    _storeListArray = storeListArray;
    
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
    return _storeListArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    ZFDetailStoreCell  *cell = (ZFDetailStoreCell *)[self.storeListCollectionView dequeueReusableCellWithReuseIdentifier:@"ZFDetailStoreCellid" forIndexPath:indexPath];
    
    DetailCmgoodslist * detailGoodlist = _storeListArray[indexPath.item];
    cell.detailGoodlist = detailGoodlist;
    
    return cell;
}

//设置每个item的尺寸
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat itemHeight =  ((KScreenW -30-20 )*0.5 - 10 ) * 140/121 +36+20+15;
    return CGSizeMake( (KScreenW -30-20 )*0.5 , itemHeight);
}

//设置每个item的UIEdgeInsets
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(15,  20 , 10, 20);
    
}

//点击item方法
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@" item === %ld xxxxxxx section = %ld",indexPath.item,indexPath.section);
    
    DetailCmgoodslist * goodlist                 = _storeListArray[indexPath.item];
    
    if ([self.collectionDelegate respondsToSelector:@selector(didClickCollectionCellGoodId:withIndexItem:)]) {
        [self.collectionDelegate didClickCollectionCellGoodId:[NSString stringWithFormat:@"%ld",goodlist.goodsId] withIndexItem:_indexItem];
    }
    
}

-(void)reloadCollectionView
{
    [self.storeListCollectionView reloadData];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end