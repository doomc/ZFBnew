//
//  LoadPictureCell.m
//  ZFB
//
//  Created by  展富宝  on 2017/12/6.
//  Copyright © 2017年 com.zfb. All rights reserved.
//

#import "LoadPictureCell.h"
#import "LoadPicCollectionViewCell.h"

@interface LoadPictureCell () <UICollectionViewDelegate,UICollectionViewDataSource>

@end

@implementation LoadPictureCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.loadColllectionView.delegate = self;
    self.loadColllectionView.dataSource = self;
    
    
    [self.loadColllectionView registerNib:[UINib nibWithNibName:@"LoadPicCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"LoadPicCollectionViewCell"];
}
-(void)setImagesUrl:(NSArray *)imagesUrl
{
    _imagesUrl = imagesUrl;
    if (_imagesUrl.count >0 ) {
        if (imagesUrl.count > 3) {
            _layoutConstarintsHeight.constant = KScreenW /3 - 20 ;
        }else{
            _layoutConstarintsHeight.constant = (KScreenW /3 - 20)*2 ;
        }
    }
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
    return _imagesUrl.count;;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    LoadPicCollectionViewCell  *cell = (LoadPicCollectionViewCell *)[self.loadColllectionView dequeueReusableCellWithReuseIdentifier:@"CouponCollectionCell" forIndexPath:indexPath];
 
    if (_imagesUrl.count > 0 ) {
        [cell.imageView sd_setImageWithURL:[NSURL URLWithString:_imagesUrl[indexPath.item]] placeholderImage:nil];
    }
    return cell;
}

//设置每个item的尺寸
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    return CGSizeMake( KScreenW /3 - 20, KScreenW /3 - 20 );
}

//设置每个item的UIEdgeInsets
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(5,  5 , 5, 5);
    
}

//点击item方法
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@" item === %ld ",indexPath.item);
 
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
