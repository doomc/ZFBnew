//
//  ZFAppraiseCell.m
//  ZFB
//
//  Created by  展富宝  on 2017/5/19.
//  Copyright © 2017年 com.zfb. All rights reserved.
//  评论

#import "ZFAppraiseCell.h"
#import "ApprariseCollectionViewCell.h"
@interface ZFAppraiseCell ()<UICollectionViewDataSource,UICollectionViewDelegate>


@end
@implementation ZFAppraiseCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.img_appraiseView.clipsToBounds = YES;
    self.img_appraiseView.layer.borderWidth = 0.5;
    self.img_appraiseView.layer.borderColor = HEXCOLOR(0xffcccc).CGColor;
    
    
    [self.appriseCollectionView registerNib:[UINib nibWithNibName:@"ApprariseCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"ApprariseCollectionViewCellid"];
    self.appriseCollectionView.delegate = self;
    self.appriseCollectionView.dataSource = self;
    
}
#pragma mark  - 计算高度
-(void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath{
    
    if (collectionView == _appriseCollectionView) {
        CGFloat height  = self.appriseCollectionView.collectionViewLayout.collectionViewContentSize.height;
        
        _appriseCollectionView.height = height;
//        _appriseCollectionView.contentSize = CGSizeMake(self.appriseCollectionView.width, height);
        NSLog(@"%f",height);
    }
//    self.appriseCollectionView.collectionViewLayout.collectionViewContentSize.heigh ;

}
#pragma  mark - UICollectionViewDelegate
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 3;
    
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
   
    ApprariseCollectionViewCell *cell = [self.appriseCollectionView dequeueReusableCellWithReuseIdentifier:@"ApprariseCollectionViewCellid" forIndexPath:indexPath];
  
    return cell;
    
}

 
#pragma mark - UICollectionViewDelegateFlowLayout
//每个cell的大小，因为有indexPath，所以可以判断哪一组，或者哪一个item，可一个给特定的大小，等同于layout的itemSize属性
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    return  CGSizeMake((KScreenW -100-15)/ 3, (KScreenW -100-15)/3);
    
}
// 设置整个组的缩进量是多少
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(5, 5, 5, 5);
}

// 设置最小行间距，也就是前一行与后一行的中间最小间隔
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 5;
}

// 设置最小列间距，也就是左行与右一行的中间最小间隔
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 5;
}



- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
   
    NSLog(@"------%ld-------",indexPath.item);
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
