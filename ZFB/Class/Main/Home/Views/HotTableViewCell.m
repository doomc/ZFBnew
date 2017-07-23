//
//  HotCell.m
//  ZFB
//
//  Created by  展富宝  on 2017/5/15.
//  Copyright © 2017年 com.zfb. All rights reserved.
//

#import "HotTableViewCell.h"
#import "HotCollectionViewCell.h"
#import "HomeHotModel.h"
@interface HotTableViewCell ()
{
    NSInteger _pageSize;//每页显示条数
    NSInteger _pageIndex;//当前页码;
    
}
@end
@implementation HotTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code

    self.HotcollectionView.dataSource =self;
    self.HotcollectionView.delegate = self;
     
    [self.HotcollectionView registerNib:[UINib nibWithNibName:@"HotCollectionViewCell" bundle:nil]
             forCellWithReuseIdentifier:@"HotCollectionViewCellid"];
 
    
}
-(void)setHotArray:(NSMutableArray *)hotArray
{
    _hotArray = hotArray;
}

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return _hotArray.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    HotCollectionViewCell * cell = [self.HotcollectionView dequeueReusableCellWithReuseIdentifier:@"HotCollectionViewCellid" forIndexPath:indexPath];

    HomeHotModel * hot=  [HomeHotModel new];
    if (indexPath.row < [self.hotArray count]) {
        
    }
    hot  = [self.hotArray objectAtIndex:indexPath.row];
    
    NSURL * img_url = [NSURL URLWithString:hot.coverImgUrl];
    [cell.img_hotImgView sd_setImageWithURL:img_url placeholderImage:nil];
    cell.lb_price.text = [NSString stringWithFormat:@"%.2f",hot.storePrice];//netPurchasePrice 网购价格2选1
    return cell;
}



- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"%ld  = item" ,indexPath.item);
    
}
#pragma mark - UICollectionViewDelegateFlowLayout
//每个cell的大小，因为有indexPath，所以可以判断哪一组，或者哪一个item，可一个给特定的大小，等同于layout的itemSize属性
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    
    return CGSizeMake((KScreenW - 50)*0.3333,(KScreenW - 50)*0.3333);
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





- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
