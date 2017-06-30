//
//  ZFOrderListCell.m
//  ZFB
//
//  Created by  展富宝  on 2017/5/24.
//  Copyright © 2017年 com.zfb. All rights reserved.
//

#import "ZFOrderListCell.h"
#import "GoodsitemCell.h"
#import "AddressCommitOrderModel.h"
@implementation ZFOrderListCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.order_collectionCell.delegate = self;
    self.order_collectionCell.dataSource = self;
    
    [self.order_collectionCell registerNib:[UINib nibWithNibName:@"GoodsitemCell" bundle:nil] forCellWithReuseIdentifier:@"GoodsitemCellid"];
   
}
-(void)setListArray:(NSMutableArray *)listArray
{
    _listArray = [NSMutableArray array];
    _listArray = listArray;
    NSLog(@"======== %@",_listArray);

}
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return  3;
}

#pragma mark - UICollectionViewDelegateFlowLayout
//每个cell的大小，因为有indexPath，所以可以判断哪一组，或者哪一个item，可一个给特定的大小，等同于layout的itemSize属性
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    return CGSizeMake((KScreenW - self.lb_totalNum.width )*0.3333 - 35,60);
}
// 设置整个组的缩进量是多少
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    
    return UIEdgeInsetsMake(5, 10, 5, 10);
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    Cmgoodslist * list = _listArray[indexPath.row];
    
    GoodsitemCell * cell = [self.order_collectionCell
                            dequeueReusableCellWithReuseIdentifier:@"GoodsitemCellid" forIndexPath:indexPath];

    if (_listArray.count > 3) {
        
        self.img_shenglve.hidden = NO;
    }
    else{
        self.img_shenglve.hidden = YES;
    }
    
    [cell.img_listImgView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",list.coverImgUrl]] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        
    }];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"%ld  = item" ,indexPath.item);
    
}


//// 设置最小行间距，也就是前一行与后一行的中间最小间隔
//- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
//    return 10;
//}
//
//// 设置最小列间距，也就是左行与右一行的中间最小间隔
//- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
//    return 10;
//}

//// 设置section头视图的参考大小，与tableheaderview类似
//- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
//    return CGSizeMake(self.frame.size.width, 40);
//}
//
//// 设置section尾视图的参考大小，与tablefooterview类似
//- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section {
//    return CGSizeMake(self.frame.size.width, 40);
//}
//



- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
