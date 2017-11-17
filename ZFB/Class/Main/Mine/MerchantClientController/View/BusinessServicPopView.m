//
//  BusinessServicPopView.m
//  ZFB
//
//  Created by 熊维东 on 2017/7/29.
//  Copyright © 2017年 com.zfb. All rights reserved.
//

#import "BusinessServicPopView.h"
@interface BusinessServicPopView ()

@property (nonatomic, assign) BusinessServicType selctedType;
@property (nonatomic, strong) UIButton *selectBtn;

@end
@implementation BusinessServicPopView
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
            button.tag = i+3000;
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
    
    [sender setTitleColor:HEXCOLOR(0xf95a70) forState:UIControlStateNormal];
    sender.layer.borderColor =HEXCOLOR(0xf95a70).CGColor;
    NSInteger selectTag = sender.tag;
    
    _selectBtn = sender;
    
    switch (selectTag) {

        case 3000:
            _selctedType =   BusinessServicTypeWaitSendlist;//待派单
            break;
        case 3001:
            _selctedType = BusinessServicTypeSending;//配送中
            
            break;
        case 3002:
            _selctedType = BusinessServicTypeWaitPay;//待付款
            
            break;
        case 3003:
            _selctedType = BusinessServicTypeDealComplete;//交易完成
            
            break;
        case 3004:
            _selctedType = BusinessServicTypeSureReturn;//待确认退回
            
            break;
        case 3005:
            _selctedType = BusinessServicTypeSended;//已配送
            
            break;
        case 3006:
            _selctedType = BusinessServicTypeCancelOrder;//取消交易
            
            break;
        case 3007:
            _selctedType = BusinessServicTypeWiatOrder;//待结单
            
            break;
        case 3008:
            _selctedType = BusinessServicTypeWaitSending;
            
            break;
        case 3009:
            _selctedType = BusinessServicTypeWaitReceived;
            
            break;
    }
    if ([_delegate respondsToSelector:@selector(sendTitle:businessServicType:)]) {
        
        [_delegate sendTitle:_titleArray[selectTag-3000] businessServicType:_selctedType];
        
    }
    
}


@end
