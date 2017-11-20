//
//  AllGoodsCollectionReusableView.h
//  ZFB
//
//  Created by  展富宝  on 2017/11/20.
//  Copyright © 2017年 com.zfb. All rights reserved.
//

#import <UIKit/UIKit.h>

 @protocol AllGoodsCollectionReusableViewDelagte <NSObject>

-(void)selectStoreType:(StoreScreenType)type;

@end

@interface AllGoodsCollectionReusableView : UICollectionReusableView

@property (nonatomic, assign) id<AllGoodsCollectionReusableViewDelagte> delegate;

-(instancetype)initWithFrame:(CGRect)frame titles:(NSArray *)titles;

@property (nonatomic, strong) NSArray * titles;


@end
