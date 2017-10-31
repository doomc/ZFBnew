//
//  ZFSaleAfterTopView.m
//  ZFB
//
//  Created by  展富宝  on 2017/5/26.
//  Copyright © 2017年 com.zfb. All rights reserved.
//

#import "ZFSaleAfterTopView.h"

@interface ZFSaleAfterTopView  ()

@property (nonatomic, strong) UIButton *selectBtn;


@end
@implementation ZFSaleAfterTopView


-(instancetype)initWithFrame:(CGRect)frame titleArr:(NSArray *)arr
{
    self = [super initWithFrame:frame];
    
    if (self) {
       
        for (int i = 0 ; i < arr.count; i++) {
            
            UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
            button.frame = CGRectMake(i*(KScreenW*0.5), 0, (KScreenW*0.5), 43);
            [button setTitleColor:HEXCOLOR(0x333333) forState:UIControlStateNormal];
            [button setTitle:arr[i] forState:UIControlStateNormal];
            button.titleLabel.font = [UIFont systemFontOfSize:14];
            
            [button addTarget:self action:@selector(didclickWithAction:) forControlEvents:UIControlEventTouchUpInside];
            button.tag = i + 666;
            [self addSubview:button];
            NSLog(@"%ld \n",button.tag);
            
            UILabel * line = [[UILabel alloc]initWithFrame:CGRectMake(0, 43, KScreenW, 1)];
            line.backgroundColor = [UIColor colorWithWhite:0.840 alpha:1.000];
            [self addSubview:line];
            
            if (i == 0) {
                [self didclickWithAction:button];
            }
            self.backgroundColor= [UIColor whiteColor];
 
        }
 
    }
    return self;
}
 

-(void)didclickWithAction:(UIButton*)sender
{
    [_selectBtn setTitleColor:HEXCOLOR(0x333333) forState:UIControlStateNormal];
    _selectBtn.backgroundColor =[UIColor whiteColor];
    
    [sender setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    sender.backgroundColor =HEXCOLOR(0xf95a70);
    
    NSInteger selectTag = sender.tag;
    _selectBtn = sender;
    

    if ([_delegate respondsToSelector:@selector(sendAtagNum:)]) {
     
        [_delegate sendAtagNum:selectTag - 666];

    }
    
    NSLog(@"%ld",selectTag);
}




@end
