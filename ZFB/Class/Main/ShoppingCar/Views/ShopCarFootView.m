//
//  ShopCarFootView.m
//  ZFB
//
//  Created by  展富宝  on 2017/6/20.
//  Copyright © 2017年 com.zfb. All rights reserved.
//

#import "ShopCarFootView.h"

@implementation ShopCarFootView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

-(id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self) {
        
        NSString *buttonTitle = @"结算";
        NSString *price = @"¥208.00";
        NSString *caseOrder =  @"订单金额";
        UIFont * font  =[UIFont systemFontOfSize:12];
        
        
        //结算按钮
        UIButton * complete_Btn  = [UIButton buttonWithType:UIButtonTypeCustom];
        [complete_Btn setTitle:buttonTitle forState:UIControlStateNormal];
        complete_Btn.titleLabel.font =font;
        complete_Btn.layer.cornerRadius = 2;
        complete_Btn.backgroundColor =HEXCOLOR(0xfe6d6a);
        CGSize complete_BtnSize = [buttonTitle sizeWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:font,NSFontAttributeName,nil]];
        CGFloat complete_BtnW = complete_BtnSize.width;
        complete_Btn.frame =CGRectMake(KScreenW - complete_BtnW - 25, 5, complete_BtnW +10, 25);
        [complete_Btn addTarget:self action:@selector(didClickClearingShopCar:) forControlEvents:UIControlEventTouchUpInside];
        
        
        //价格
        UILabel * lb_price = [[UILabel alloc]init];
        lb_price.text = price;
        lb_price.textAlignment = NSTextAlignmentLeft;
        lb_price.font = font;
        lb_price.textColor = HEXCOLOR(0xfe6d6a);
        CGSize lb_priceSize = [price sizeWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:font,NSFontAttributeName, nil]];
        CGFloat lb_priceW = lb_priceSize.width;
        lb_price.frame = CGRectMake(KScreenW - lb_priceW -35-complete_BtnW, 5, lb_priceW, 30);
        
        //固定金额位置
        UILabel * lb_order = [[UILabel alloc]init];
        lb_order.text= caseOrder;
        lb_order.font = font;
        lb_order.textColor = HEXCOLOR(0x363636);
        CGSize lb_orderSiez = [caseOrder sizeWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:font,NSFontAttributeName, nil]];
        CGFloat lb_orderW = lb_orderSiez.width;
        lb_order.frame =  CGRectMake(KScreenW - lb_priceW -35-complete_BtnW-15-lb_orderW, 5, lb_orderW, 30);
        
        [self addSubview: lb_price];
        [self addSubview:lb_order];
        [self addSubview:complete_Btn];
    }
    return self;
}

-(void)didClickClearingShopCar:(UIButton * )sender
{
    if ([self.delegate respondsToSelector:@selector(didClickClearingShoppingCar:)]) {
       
        [self.delegate didClickClearingShoppingCar:sender];
    }
}
@end
