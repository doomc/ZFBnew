//
//  ShopCarFootView.h
//  ZFB
//
//  Created by  展富宝  on 2017/6/20.
//  Copyright © 2017年 com.zfb. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ShopCarFootViewDelegate <NSObject>

//结算
-(void)didClickClearingShoppingCar:(UIButton *)sender;


@end
@interface ShopCarFootView : UIView

@property(nonatomic ,assign) id <ShopCarFootViewDelegate> delegate;


@end
