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
    self.selectionStyle = UITableViewCellSelectionStyleNone;

    self.typeCollectionView.delegate = self;
    self.typeCollectionView.dataSource =self;

    [self.typeCollectionView registerNib:[UINib nibWithNibName:@"FeedCommitCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"FeedCommitCollectionViewCellid"];
    
    _nameArray = [NSArray array];

}

-(void)setNameArray:(NSArray *)nameArray
{
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
//点击选定
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    FeedCommitCollectionViewCell *cell = (FeedCommitCollectionViewCell *)[self.typeCollectionView cellForItemAtIndexPath:indexPath];

    if (_nameArray.count > 0 ) {
        cell.lb_type.backgroundColor = HEXCOLOR(0xfe6d6a);
        cell.lb_type.textColor =  HEXCOLOR(0xffffff);

 
        NSString * name = _nameArray[indexPath.item];
        if ([self.delegate respondsToSelector:@selector(didClickTypeName:Index:isSelected:)]) {
            [self.delegate didClickTypeName:name Index:indexPath.item isSelected:_isSelectedBackGround];
            
        }
        
    }
}
//取消选定
-(void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath
{
    FeedCommitCollectionViewCell *cell = (FeedCommitCollectionViewCell *)[self.typeCollectionView cellForItemAtIndexPath:indexPath];
    cell.lb_type.backgroundColor = HEXCOLOR(0xffffff);
    cell.lb_type.textColor =  HEXCOLOR(0x363636);
}

#pragma mark - UICollectionViewDelegateFlowLayout
//每个cell的大小，因为有indexPath，所以可以判断哪一组，或者哪一个item，可一个给特定的大小，等同于layout的itemSize属性
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    return  CGSizeMake( KScreenW *0.25 - 30 , 20);
    
}
// 设置整个组的缩进量是多少
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(5, 5, 5, 5);
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
