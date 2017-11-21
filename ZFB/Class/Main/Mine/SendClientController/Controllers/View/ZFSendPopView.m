//
//  ZFSendPopView.m
//  ZFB
//
//  Created by  展富宝  on 2017/5/26.
//  Copyright © 2017年 com.zfb. All rights reserved.
//

#import "ZFSendPopView.h"

@interface ZFSendPopView ()

@property(nonatomic,strong)NSArray *titleArray;

@property(nonatomic,assign)SendServicType selectType;

@property(nonatomic,strong)UIButton * selectedBtn;
@end

@implementation ZFSendPopView

-(instancetype)initWithFrame:(CGRect)frame titleArray:(NSArray *)titleArray
{
    self= [super initWithFrame:frame];
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
            button.tag = i+1000;
            NSLog(@"%ld \n",button.tag);
            if (i == 0) {
                [self didclickSendPopViewAction:button];
            }
            
        }
        self.backgroundColor = [UIColor whiteColor];

    }
    return self;
}

-(void)didclickSendPopViewAction:(UIButton*)sender
{
    [_selectedBtn setTitleColor:HEXCOLOR(0x363636) forState:UIControlStateNormal];
    _selectedBtn.layer.borderColor =HEXCOLOR(0xdedede).CGColor;
    
    [sender setTitleColor:HEXCOLOR(0xf95a70) forState:UIControlStateNormal];
    sender.layer.borderColor =HEXCOLOR(0xf95a70).CGColor;
    
    _selectedBtn = sender;
    
    NSInteger selectTag = sender.tag;
    
    switch (selectTag) {
        case 1000:
            _selectType = SendServicTypeWaitSend;//待配送
            break;
        case 1001:
            _selectType = SendServicTypeSending;//配送中
            
            break;
        case 1002:
            _selectType = SendServicTypeSended;//已配送
            
            break;
    }
    
    if ([self.delegate respondsToSelector:@selector(sendTitle:SendServiceType:)]) {
        
        [_delegate sendTitle:_titleArray[selectTag - 1000] SendServiceType:_selectType];
        
    }

}
@end
