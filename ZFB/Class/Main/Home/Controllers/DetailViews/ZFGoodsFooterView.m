//
//  ZFGoodsFooterView.m
//  ZFB
//
//  Created by  展富宝  on 2017/5/18.
//  Copyright © 2017年 com.zfb. All rights reserved.
//

#import "ZFGoodsFooterView.h"
@interface ZFGoodsFooterView ()<UIGestureRecognizerDelegate>

@end
@implementation ZFGoodsFooterView


-(instancetype)initWithFootViewFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {

        self = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:self options:nil][0];
        //添加事件
        [self addgesViewActionWithView];
        self.frame = frame;

    }
    return self;
}
 
//添加事件
-(void)addgesViewActionWithView
{
    //点击客服
    UITapGestureRecognizer * contactTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapContactView:)];
    contactTap.delegate = self;
    [self.contactView addGestureRecognizer:contactTap];
    
    //店铺
    UITapGestureRecognizer *storeViewTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapStoreView:)];
    storeViewTap.delegate = self;
    [self.storeView addGestureRecognizer:storeViewTap];
    
    //购物车
    UITapGestureRecognizer *tapShopcar = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapShopcarView:)];
    tapShopcar.delegate = self;
    [self.shopCarView addGestureRecognizer:tapShopcar];
    
    //加入购物车
    UITapGestureRecognizer * tapAddShoppingCarView = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAddShoppingCarView:)];
    tapAddShoppingCarView.delegate = self;
    [self.addShoppingCarView addGestureRecognizer:tapAddShoppingCarView];
    
    //立即抢购
    UITapGestureRecognizer * tapBuynowView = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapBuynowView:)];
    tapBuynowView.delegate = self;
    [self.buynowView addGestureRecognizer:tapBuynowView];
}
 
//点击客服
-(void)tapContactView:(UITapGestureRecognizer *)tap
{
    if ([self.delegate respondsToSelector:@selector(didClickContactRobotView)]) {
        [self.delegate didClickContactRobotView];
    }
}

// 点击店铺
-(void)tapStoreView:(UITapGestureRecognizer *)tap
{
    if ([self.delegate respondsToSelector:@selector(didClickStoreiew)]) {
        [self.delegate didClickStoreiew];
    }
}

// 点击购物车
-(void)tapShopcarView:(UITapGestureRecognizer *)tap
{
    if ([self.delegate respondsToSelector:@selector(didClickShoppingCariew)]) {
        [self.delegate didClickShoppingCariew];
    }
}

// 点击添加购物车
-(void)tapAddShoppingCarView:(UITapGestureRecognizer *)tap
{
    if ([self.delegate respondsToSelector:@selector(didClickAddShoppingCarView)]) {
        [self.delegate didClickAddShoppingCarView];
    }
}

// 点击立即抢购
-(void)tapBuynowView:(UITapGestureRecognizer *)tap
{
    if ([self.delegate respondsToSelector:@selector(didClickBuyNowView)]) {
        [self.delegate didClickBuyNowView];
    }
    
}

@end
