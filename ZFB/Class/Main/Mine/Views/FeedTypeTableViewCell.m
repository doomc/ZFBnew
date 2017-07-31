//
//  FeedTypeTableViewCell.m
//  ZFB
//
//  Created by  展富宝  on 2017/7/4.
//  Copyright © 2017年 com.zfb. All rights reserved.
//

#import "FeedTypeTableViewCell.h"
#import "FeedCommitCollectionViewCell.h"
@interface FeedTypeTableViewCell ()<UICollectionViewDelegate,UICollectionViewDataSource>


@end
@implementation FeedTypeTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.typeCollectionView.delegate = self;
    self.typeCollectionView.dataSource =self;

    [self.typeCollectionView registerNib:[UINib nibWithNibName:@"FeedCommitCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"FeedCommitCollectionViewCellid"];
    
 
}

-(void)setNameArray:(NSArray *)nameArray
{
    _nameArray = [NSArray array];
    _nameArray = nameArray;
    
    [self reloadCell];
}
- (void)reloadCell{
    
    self.collectionViewLayoutHeight.constant = self.collectionViewFlowLayout.collectionViewContentSize.height;
    [self updateConstraintsIfNeeded];
 
}


#pragma  mark - UICollectionViewDelegate
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
 
    return _nameArray.count;
    NSLog(@" - name array =  %@",_nameArray);
    
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
   
    FeedCommitCollectionViewCell *cell = [self.typeCollectionView dequeueReusableCellWithReuseIdentifier:@"FeedCommitCollectionViewCellid" forIndexPath:indexPath];
    
    if (_nameArray.count > 0) {
        //数据操作
        cell.lb_type.text = _nameArray[indexPath.item];
     }

    return cell;
    
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    NSLog(@"%ld ==== section =%ld ==== item",indexPath.section,indexPath.item);
    if (_nameArray.count > 0 ) {
        NSString * name = _nameArray[indexPath.item];
        if ([self.delegate respondsToSelector:@selector(didClickTypeName:Index:)]) {
            [self.delegate didClickTypeName:name Index:indexPath.item];
        }
        
    }
    
}

#pragma mark - UICollectionViewDelegateFlowLayout
//每个cell的大小，因为有indexPath，所以可以判断哪一组，或者哪一个item，可一个给特定的大小，等同于layout的itemSize属性
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    return  CGSizeMake( KScreenW /4 - 30 , 20);
    
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
