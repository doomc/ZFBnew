//
//  ShopCarHeadView.h
//  ZFB
//
//  Created by  展富宝  on 2017/6/20.
//  Copyright © 2017年 com.zfb. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ShopCarHeadViewDelegate <NSObject>

-(void)editAction:(id)sender;
-(void)sctionTitle:(NSString *)title;


@end

typedef void(^SctiontitleBlock)(NSString * title);

@interface ShopCarHeadView : UIView

@property (nonatomic ,strong) SctiontitleBlock sectionBlock;

@property (nonatomic ,assign) id <ShopCarHeadViewDelegate>shopCarDelegate;


@end
