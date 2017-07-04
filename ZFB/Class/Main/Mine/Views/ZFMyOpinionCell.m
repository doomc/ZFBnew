//
//  ZFMyOpinionCell.m
//  ZFB
//
//  Created by  展富宝  on 2017/6/8.
//  Copyright © 2017年 com.zfb. All rights reserved.
//

#import "ZFMyOpinionCell.h"
#import "FeedCollectionViewCell.h"
@interface ZFMyOpinionCell ()<UICollectionViewDelegate,UICollectionViewDataSource>

@property (weak, nonatomic) IBOutlet UICollectionViewFlowLayout *colletionviewLayoutFlow;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *feedcollectViewLayoutheight;

@end

@implementation ZFMyOpinionCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    //多行必须写
    [self.lb_title setPreferredMaxLayoutWidth:(KScreenW - 30)];
    
    [self.feedCollectionView registerNib:[UINib nibWithNibName:@"FeedCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"FeedCollectionViewCellid"];
    self.feedCollectionView.delegate = self;
    self.feedCollectionView.dataSource =self;

    [self reloadCell];
}
-(void)reloadCell
{
    [self.feedCollectionView reloadData];
    self.feedcollectViewLayoutheight.constant = self.colletionviewLayoutFlow.collectionViewContentSize.height;
    [self updateConstraintsIfNeeded];
    
}

-(void)setImagerray:(NSMutableArray *)imagerray
{
    _imagerray = [NSMutableArray array];
    _imagerray = imagerray;
}
#pragma  mark - UICollectionViewDelegate
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    
    return _imagerray.count;
    
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    if (_imagerray.count == 0) {
        
        _feedcollectViewLayoutheight = 0;
    }
        
    
    FeedCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"FeedCollectionViewCellid" forIndexPath:indexPath];
    
    return cell;
    
}
 

#pragma mark - UICollectionViewDelegateFlowLayout
//每个cell的大小，因为有indexPath，所以可以判断哪一组，或者哪一个item，可一个给特定的大小，等同于layout的itemSize属性
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    return  CGSizeMake( 50, 50);
    
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
 
    NSLog(@"%ld ==== section =%ld ==== item",indexPath.section,indexPath.item);
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
