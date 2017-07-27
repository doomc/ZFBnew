//
//  SearchTypeCollectionView.h
//  ZFB
//
//  Created by  展富宝  on 2017/7/24.
//  Copyright © 2017年 com.zfb. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol SearchTypeCollectionViewDelegate <NSObject>


/**
  获取到 对应的-品牌id 品牌名

 @param index 当前错标
 @param brandId 品牌id
 @param brandName 品牌name
 */
-(void)didSelectedIndex:(NSInteger )index brandId :(NSString *)brandId brandName :(NSString *)brandName;

@end
@interface SearchTypeCollectionView : UICollectionView

//品牌列表 数据源
@property (nonatomic, strong) NSMutableArray * brandListArray;

@property (nonatomic, assign) id <SearchTypeCollectionViewDelegate> typeDelegate;

-(instancetype)initWithFrame:(CGRect)frame collectionViewLayout:(UICollectionViewLayout *)layout;

@end
