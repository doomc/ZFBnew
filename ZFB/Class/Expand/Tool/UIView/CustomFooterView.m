
//
//  CustomFooterView.m
//  ZFB
//
//  Created by  展富宝  on 2017/5/24.
//  Copyright © 2017年 com.zfb. All rights reserved.
//

#import "CustomFooterView.h"

@implementation CustomFooterView
-(instancetype)initWithFrame:(CGRect)frame

{
    self= [super initWithFrame:frame];
    if (self) {
        NSString *buttonTitle = @"配送完成";
        NSString *price = @"¥208.00";
        NSString *caseOrder =  @"订单金额";
        
        UIFont * font  =[UIFont systemFontOfSize:12];
        UIView* footerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, KScreenW, 50)];
        footerView.backgroundColor =[UIColor whiteColor];
        
        //结算按钮
        UIButton * complete_Btn  = [UIButton buttonWithType:UIButtonTypeCustom];
        [complete_Btn setTitle:buttonTitle forState:UIControlStateNormal];
        complete_Btn.titleLabel.font =font;
        complete_Btn.layer.cornerRadius = 2;
        complete_Btn.backgroundColor =HEXCOLOR(0xf95a70);
        CGSize complete_BtnSize = [buttonTitle sizeWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:font,NSFontAttributeName,nil]];
        CGFloat complete_BtnW = complete_BtnSize.width;
        complete_Btn.frame =CGRectMake(KScreenW - complete_BtnW - 25, 5, complete_BtnW +20, 30);
        [complete_Btn addTarget:self action:@selector(didCleckSending:) forControlEvents:UIControlEventTouchUpInside];
        

        //固定金额位置
        UILabel * lb_order = [[UILabel alloc]init];
        lb_order.text= caseOrder;
        lb_order.font = font;
        lb_order.textColor = HEXCOLOR(0x363636);
        CGSize lb_orderSiez = [caseOrder sizeWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:font,NSFontAttributeName, nil]];
        CGFloat lb_orderW = lb_orderSiez.width;
        lb_order.frame =  CGRectMake(15, 5, lb_orderW, 30);
        
        //价格
        UILabel * lb_price = [[UILabel alloc]init];
        lb_price.text = price;
        lb_price.textAlignment = NSTextAlignmentLeft;
        lb_price.font = font;
        lb_price.textColor = HEXCOLOR(0xf95a70);
        CGSize lb_priceSize = [price sizeWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:font,NSFontAttributeName, nil]];
        CGFloat lb_priceW = lb_priceSize.width;
        lb_price.frame = CGRectMake(15+lb_orderW+10, 5, lb_priceW, 30);
        
        
        [footerView addSubview: lb_price];
        [footerView addSubview:lb_order];
        [footerView addSubview:complete_Btn];
        

    }
    return self;
}
-(void)creatFooterViewWithleftTitle :(NSString *)leftTitle AndRightTitle :(NSString *)rigntTitle
{
    
}

-(void)didCleckSending:(UIButton*)button
{
    
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
