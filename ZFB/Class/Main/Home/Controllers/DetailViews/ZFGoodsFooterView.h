//
//  ZFGoodsFooterView.h
//  ZFB
//
//  Created by  展富宝  on 2017/5/18.
//  Copyright © 2017年 com.zfb. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol ZFGoodsFooterViewDelegate <NSObject>
@optional
//客服
-(void)didClickContactRobotView;
//店铺
-(void)didClickStoreiew;
//购物车
-(void)didClickShoppingCariew;
//加入购物车
-(void)didClickAddShoppingCarView;
//立即购买
-(void)didClickBuyNowView;


@end
@interface ZFGoodsFooterView : UIView

-(instancetype)initWithFootViewFrame:(CGRect)frame;

@property (assign , nonatomic )id <ZFGoodsFooterViewDelegate>  delegate;

@property (weak, nonatomic) IBOutlet UIView *contactView;

@property (weak, nonatomic) IBOutlet UIView *storeView;

@property (weak, nonatomic) IBOutlet UIView *shopCarView;

@property (weak, nonatomic) IBOutlet UIView *addShoppingCarView;

@property (weak, nonatomic) IBOutlet UIView *buynowView;


@end
