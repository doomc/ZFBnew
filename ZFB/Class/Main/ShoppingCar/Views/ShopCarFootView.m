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
        
        NSString *buttonTitle = @"结算（0）";
        NSString *price = @"¥208.00";
        NSString *caseOrder =  @"合计:";
        UIFont * font  =[UIFont systemFontOfSize:12];
        
   
        
        //结算按钮
        UIButton * complete_Btn  = [UIButton buttonWithType:UIButtonTypeCustom];
        [complete_Btn setTitle:buttonTitle forState:UIControlStateNormal];
        complete_Btn.titleLabel.font =font;
        complete_Btn.backgroundColor =HEXCOLOR(0xfe6d6a);
        complete_Btn.frame =CGRectMake(KScreenW -100, 0, 100 , 49);
        [complete_Btn addTarget:self action:@selector(didClickClearingShopCar:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:complete_Btn];

        
        //价格
        UILabel * lb_price = [[UILabel alloc]init];
        lb_price.text = price;
        lb_price.textAlignment = NSTextAlignmentLeft;
        lb_price.font = font;
        lb_price.textColor = HEXCOLOR(0xfe6d6a);
        CGSize lb_priceSize = [price sizeWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:font,NSFontAttributeName, nil]];
        CGFloat lb_priceSizeW = lb_priceSize.width;
        [self addSubview: lb_price];
        
        [lb_price mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(complete_Btn.mas_left).with.offset(-20);
            make.centerY.equalTo(complete_Btn.mas_centerY);
            make.size.mas_equalTo(CGSizeMake(lb_priceSizeW+10, 20));
        }];
        
        //合计
        UILabel * lb_order = [[UILabel alloc]init];
        lb_order.text= caseOrder;
        lb_order.font = font;
        lb_order.textColor = HEXCOLOR(0x363636);
        CGSize lb_orderSiez = [caseOrder sizeWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:font,NSFontAttributeName, nil]];
        CGFloat lb_orderW = lb_orderSiez.width;
        [self addSubview:lb_order];
        
        [lb_order mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(lb_price.mas_left).with.offset(-5);
            make.centerY.equalTo(complete_Btn.mas_centerY);
            make.size.mas_equalTo(CGSizeMake(lb_orderW+10, 20));
        }];
        
        UIButton * selectAll_btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [selectAll_btn setImage:[UIImage imageNamed:@"select_normal"] forState:UIControlStateNormal];
        [selectAll_btn addTarget:self action:@selector(chooseBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:selectAll_btn];
        
        [selectAll_btn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self).with.offset(15);
            make.centerY.equalTo(complete_Btn.mas_centerY);
            make.size.mas_equalTo(CGSizeMake(24, 24));
            
        }];
        
        //全选
        UILabel * lb_chooseAll = [UILabel new];
        lb_chooseAll.text = @"全选";
        lb_chooseAll.textColor = HEXCOLOR(0x363636);
        lb_chooseAll.font = font;
        [self addSubview:lb_chooseAll];
        [lb_chooseAll mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(selectAll_btn.mas_right).with.offset(10);
            make.centerY.equalTo(complete_Btn.mas_centerY);
            make.size.mas_equalTo(CGSizeMake(30, 20));
        }];
     
    }
    return self;
}

-(void)chooseBtnAction:(UIButton * )sender
{
    sender.selected = !sender.selected ;
    
    if (sender.selected) {
        
        [sender setImage:[UIImage imageNamed:@"select_selected"] forState:UIControlStateSelected];
    }
    else{
        
        [sender setImage:[UIImage imageNamed:@"select_normal"] forState:UIControlStateNormal];
    }
    
}
-(void)didClickClearingShopCar:(UIButton * )sender
{
    if ([self.delegate respondsToSelector:@selector(didClickClearingShoppingCar:)]) {
       
        [self.delegate didClickClearingShoppingCar:sender];
    }
}
@end
