
//
//  ApplySalesUploadCell.m
//  ZFB
//
//  Created by  展富宝  on 2017/5/27.
//  Copyright © 2017年 com.zfb. All rights reserved.
//

#import "ApplySalesUploadCell.h"
#import "CollectionViewCell.h"


@interface ApplySalesUploadCell ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>

@property (weak, nonatomic) IBOutlet UICollectionView *uploadImageColletView;



@end
@implementation ApplySalesUploadCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.uploadImageColletView.dataSource =self;
    self.uploadImageColletView.delegate = self;
    
    [self.uploadImageColletView registerClass:[CollectionViewCell class] forCellWithReuseIdentifier:@"CollectionViewCellid"];
// 

    [self.enter_btn addTarget:self action:@selector(sureReturanWays:) forControlEvents:UIControlEventTouchUpInside];
}
#pragma  mark - UICollectionViewDelegate
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 4;
//    return _photosArray.count+1;
 
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    CollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"CollectionViewCellid" forIndexPath:indexPath];
        return cell;
    
}

- (void)deletePhotos:(UIButton *)sender{
  
}



#pragma mark - UICollectionViewDelegateFlowLayout
//每个cell的大小，因为有indexPath，所以可以判断哪一组，或者哪一个item，可一个给特定的大小，等同于layout的itemSize属性
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    return  CGSizeMake((KScreenW - 40)/ 4, (KScreenW - 40)/ 4);

}
// 设置整个组的缩进量是多少
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(5, 5, 5, 5);
}

// 设置最小行间距，也就是前一行与后一行的中间最小间隔
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 10;
}

// 设置最小列间距，也就是左行与右一行的中间最小间隔
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 10;
}



- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
 
}

-(void)sureReturanWays:(UIButton *)sender
{
    [self respondsToSelector:@selector(enterNextPage)];
    [self enterNextPage];
    
}
-(void)enterNextPage
{
    
}
 

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
