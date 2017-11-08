//
//  ZFOrderListCell.m
//  ZFB
//
//  Created by  展富宝  on 2017/5/24.
//  Copyright © 2017年 com.zfb. All rights reserved.
//

#import "ZFOrderListCell.h"
#import "GoodsitemCell.h"
#import "JsonModel.h"
@interface ZFOrderListCell ()

@property (nonatomic , strong) NSMutableArray * images;
@end
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
    _listArray = listArray;
    _images = [NSMutableArray array];
    
    for (NSDictionary * imgDic in listArray) {
        
        NSString * imgUrl = imgDic[@"coverImgUrl"];
        [_images addObject:imgUrl];
    }
}
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    
    return 1;
}
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return  _images.count;
}

#pragma mark - UICollectionViewDelegateFlowLayout
//每个cell的大小，因为有indexPath，所以可以判断哪一组，或者哪一个item，可一个给特定的大小，等同于layout的itemSize属性
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
//    return CGSizeMake((KScreenW - self.lb_totalNum.width )*0.3333 - 35,65);
    return CGSizeMake(65,65);
    
}
// 设置整个组的缩进量是多少
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    
    return UIEdgeInsetsMake(5, 10, 5, 10);
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    GoodsitemCell * cell = [self.order_collectionCell
                            dequeueReusableCellWithReuseIdentifier:@"GoodsitemCellid" forIndexPath:indexPath];

    [cell.img_listImgView sd_setImageWithURL:[NSURL URLWithString:_images[indexPath.item] ] placeholderImage:nil];
    
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
