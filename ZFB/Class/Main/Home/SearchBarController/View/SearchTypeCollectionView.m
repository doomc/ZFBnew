//
//  SearchTypeCollectionView.m
//  ZFB
//
//  Created by  展富宝  on 2017/7/24.
//  Copyright © 2017年 com.zfb. All rights reserved.
//

#import "SearchTypeCollectionView.h"
#import "SearchTypeCollectionCell.h"
#import "SearchTypeFootReusableView.h"

@interface SearchTypeCollectionView ()<UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,UICollectionViewDelegate>

@end

@implementation SearchTypeCollectionView

static NSString * identifier = @"SearchTypeCollectionCell";
static NSString * footIdentifier = @"SearchTypeFootReusableView";

-(instancetype)initWithFrame:(CGRect)frame collectionViewLayout:(UICollectionViewLayout *)layout
{
    if (self = [super initWithFrame:frame collectionViewLayout:layout]) {
        
        self.backgroundColor = [UIColor whiteColor];
        self.delegate = self;
        self.dataSource = self;
    
        [self registerNib:[UINib nibWithNibName:@"SearchTypeCollectionCell" bundle:nil] forCellWithReuseIdentifier:identifier];
        //如果collectionView有头的话，那么写上它，注册collectionview的尾部视图，
        
        [self registerNib:[UINib nibWithNibName:@"SearchTypeFootReusableView" bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:footIdentifier];
 

    }
    return self;
}

//返回collection view里区(section)的个数，如果没有实现该方法，将默认返回1：
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

//返回指定区(section)包含的数据源条目数(number of items)，该方法必须实现：
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return  7;
}

//返回某个indexPath对应的cell，该方法必须实现：
- (UICollectionViewCell*)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    SearchTypeCollectionCell *cell =  [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    
    return cell;
    
}

//设定collectionView(指定区)的边距
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(20, 40, 20,40);
    
}
//点击每个item实现的方法：
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"selcted item  ==== %ld",indexPath.item);
}

//设置footer和header
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath

{
    UICollectionReusableView * view = nil ;
    if([kind isEqualToString:UICollectionElementKindSectionFooter]){//尾部视图
        
        UICollectionReusableView *footer = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:footIdentifier forIndexPath:indexPath];

        return  footer;
        
    }else{
        
        return view;
        
    }
    
}


//设置footer尺寸
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section
{
    return  CGSizeMake(KScreenW, 40);
}




@end
