//
//  ZFpopView.m
//  ZFB
//
//  Created by 熊维东 on 2017/5/25.
//  Copyright © 2017年 com.zfb. All rights reserved.
//

#import "ZFpopView.h"

@interface ZFpopView ()

@property (nonatomic, assign) OrderType selctedType;
@property (nonatomic, strong) UIButton *selectBtn;
@end
@implementation ZFpopView


-(instancetype)initWithFrame:(CGRect)frame titleArray:(NSArray *)titleArray
{
    self = [super initWithFrame:frame];
    if (self) {
        _titleArray = titleArray;
        for (int i = 0; i < titleArray.count; i++) {
            
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            button = [[UIButton alloc] initWithFrame:CGRectMake(i%3 * (KScreenW*0.3333)+20,20+i/3*(25+20), KScreenW*0.3333 - 40, 25)];
            button.layer.cornerRadius = 2;
            button.layer.borderWidth = 1;
            button.layer.borderColor = HEXCOLOR(0xdedede).CGColor;
            [button setTitleColor:HEXCOLOR(0x333333) forState:UIControlStateNormal];
            [button setTitle:titleArray[i] forState:UIControlStateNormal];
            button.titleLabel.font = [UIFont systemFontOfSize:12];
            [button addTarget:self action:@selector(didclickSendPopViewAction:) forControlEvents:UIControlEventTouchUpInside];
            [self addSubview:button];
            button.tag = i+2000;
            NSLog(@"%ld \n",button.tag);
            if (i == 0) {
                [self didclickSendPopViewAction:button];
            }
            
        }
        self.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

-(void)didclickSendPopViewAction:(UIButton *)sender {
    
    [_selectBtn setTitleColor:HEXCOLOR(0x333333) forState:UIControlStateNormal];
    _selectBtn.layer.borderColor =HEXCOLOR(0xdedede).CGColor;
    
    [sender setTitleColor:HEXCOLOR(0xf95a70) forState:UIControlStateNormal];
    sender.layer.borderColor =HEXCOLOR(0xf95a70).CGColor;
    
    NSInteger selectTag = sender.tag;

    _selectBtn = sender;
 
    switch (selectTag) {
            
        case 2000:
            _selctedType = OrderTypeAllOrder;//全部订单
            break;
        case 2001:
            _selctedType = OrderTypeWaitPay;//待付款

            break;
        case 2002:
            _selctedType = OrderTypeWaitSend;//待配送

            break;
        case 2003:
            _selctedType = OrderTypeSending;//配送中

            break;
        case 2004:
            _selctedType = OrderTypeSended;//配送完成

            break;
        case 2005:
            _selctedType = OrderTypeDealSuccess;//交易完成

            break;
        case 2006:
            _selctedType = OrderTypeCancelSuccess;//交易取消

            break;
        case 2007:
            _selctedType = OrderTypeAfterSale;//申请售后

            break;
        case 2008:
            _selctedType = OrderTypeWaitSending; //待发货
           

            break;
        case 2009:
            _selctedType =  OrderTypeWaitRecive;//待收货
            
            break;
    }
    if ([_delegate respondsToSelector:@selector(sendTitle:orderType:)]) {
        
        [_delegate sendTitle:_titleArray[selectTag-2000] orderType:_selctedType];
        
    }
    
}


@end
