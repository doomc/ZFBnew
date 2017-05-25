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
            [button setTitleColor:HEXCOLOR(0x363636) forState:UIControlStateNormal];
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
    [_selectBtn setTitleColor:HEXCOLOR(0x363636) forState:UIControlStateNormal];
    _selectBtn.layer.borderColor =HEXCOLOR(0xdedede).CGColor;
    
    [sender setTitleColor:HEXCOLOR(0xfe6d6a) forState:UIControlStateNormal];
    sender.layer.borderColor =HEXCOLOR(0xfe6d6a).CGColor;
    
    NSInteger selectTag = sender.tag;

    _selectBtn = sender;
    //    @property(nonatomic ,strong) UITableView * AllOrder_tableView;//全部订单
    //    @property(nonatomic ,strong) UITableView * waitPay_tableView;//待付款
    //    @property(nonatomic ,strong) UITableView * waitSend_tableView;//待配送
    //    @property(nonatomic ,strong) UITableView * sending_tableView;//配送中
    //
    //    @property(nonatomic ,strong) UITableView * sended_tableView;//配送完成
    //    @property(nonatomic ,strong) UITableView * dealSuccess_tableView;//交易完成
    //    @property(nonatomic ,strong) UITableView * cancelSuccess_tableView;
    //    @property(nonatomic ,strong) UITableView * afterSale_tableView;//申请售后
    switch (selectTag) {
        case 2000:
            _selctedType = OrderTypeAllOrder;
            break;
        case 2001:
            _selctedType = OrderTypeWaitPay;

            break;
        case 2002:
            _selctedType = OrderTypeWaitSend;

            break;
        case 2003:
            _selctedType = OrderTypeSending;

            break;
        case 2004:
            _selctedType = OrderTypeSended;

            break;
        case 2005:
            _selctedType = OrderTypeDealSuccess;

            break;
        case 2006:
            _selctedType = OrderTypeCancelSuccess;

            break;
        case 2007:
            _selctedType = OrderTypeAfterSale;

            break;
    }
    if ([_delegate respondsToSelector:@selector(sendTitle:orderType:)]) {
        
        [_delegate sendTitle:_titleArray[selectTag-2000] orderType:_selctedType];
        
    }
    
}
@end
