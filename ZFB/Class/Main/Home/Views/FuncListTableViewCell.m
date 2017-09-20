//
//  FuncListTableViewCell.m
//  ZFB
//
//  Created by  展富宝  on 2017/6/16.
//  Copyright © 2017年 com.zfb. All rights reserved.
//

#import "FuncListTableViewCell.h"
#import "FuncListCollectionViewCell.h"
#import "HomeFuncModel.h"
#import "ZFClassifyCollectionViewController.h"

@interface FuncListTableViewCell ()<UICollectionViewDelegate,UICollectionViewDataSource>


@end
@implementation FuncListTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.funcCollectionView.dataSource =self;
    self.funcCollectionView.delegate = self;
    self.funcCollectionView.scrollEnabled = NO;

    [self.funcCollectionView registerNib:[UINib nibWithNibName:@"FuncListCollectionViewCell" bundle:nil]
              forCellWithReuseIdentifier:@"FuncListCollectionViewCellid"];

}
-(void)setDataArray:(NSMutableArray *)dataArray
{
    _dataArray = dataArray;
}
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 8;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    FuncListCollectionViewCell * cell = [self.funcCollectionView dequeueReusableCellWithReuseIdentifier:@"FuncListCollectionViewCellid" forIndexPath:indexPath];

    CMgoodstypelist * type=  self.dataArray[indexPath.item];

    cell.lb_listName.text = type.name;
 
    NSURL * img_url = [NSURL URLWithString:type.iconUrl];
    
    [cell.img_listView sd_setImageWithURL:img_url placeholderImage:nil];
    
    if (indexPath.item == 7) {
        cell.lb_listName.text = @"全部分类";
        cell.img_listView.image = [UIImage imageNamed:@"classes"];
    }
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"%ld  = item" ,indexPath.item);
    CMgoodstypelist * type = _dataArray[indexPath.item];
     if ([self.funcDelegate respondsToSelector:@selector(seleteItemGoodsTypeId:withIndexrow:)]) {
         [self.funcDelegate seleteItemGoodsTypeId:[NSString stringWithFormat:@"%ld",type.goodId] withIndexrow:indexPath.item ];
    }
    
    
}
#pragma mark - UICollectionViewDelegateFlowLayout
//每个cell的大小，因为有indexPath，所以可以判断哪一组，或者哪一个item，可一个给特定的大小，等同于layout的itemSize属性
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    return CGSizeMake(KScreenW/4-10,85);
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


-(void)reloadColltionView
{
    [self.funcCollectionView reloadData];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
