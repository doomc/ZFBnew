//
//  ZFSaleAfterTopView.m
//  ZFB
//
//  Created by  展富宝  on 2017/5/26.
//  Copyright © 2017年 com.zfb. All rights reserved.
//

#import "ZFSaleAfterTopView.h"

@interface ZFSaleAfterTopView  ()



@end
@implementation ZFSaleAfterTopView


-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self) {
       
        [self creatTopView];
        
    }
    return self;
}
-(void)creatTopView
{
    UIFont *font = [UIFont systemFontOfSize:15];
    
    UIButton * applyFor_btn = [UIButton buttonWithType:UIButtonTypeCustom];
    applyFor_btn.frame = CGRectMake(0 , 0, KScreenW*0.5, 39);
    [applyFor_btn  setTitle:@"售后申请" forState:UIControlStateNormal];
    [applyFor_btn setTitleColor:HEXCOLOR(0xffffff) forState:UIControlStateNormal];
    applyFor_btn.titleLabel.font = font;
    [applyFor_btn setBackgroundColor:HEXCOLOR(0xfe6d6a)];
    [applyFor_btn addTarget:self action:@selector(applyFor_btndidClick) forControlEvents:UIControlEventTouchUpInside];
    
    [self addSubview:applyFor_btn];
  
    UIButton * progress_btn = [UIButton buttonWithType:UIButtonTypeCustom];
    progress_btn.frame = CGRectMake(KScreenW*0.5, 0, KScreenW*0.5, 39);
    [progress_btn  setTitle:@"进度查询" forState:UIControlStateNormal];
    [progress_btn setTitleColor:HEXCOLOR(0x363636) forState:UIControlStateNormal];
    progress_btn.titleLabel.font = font;
//    [progress_btn setBackgroundColor:[UIColor whiteColor]];
    [progress_btn addTarget:self action:@selector(progress_btndidClick) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:progress_btn];

    UILabel * line =[[ UILabel alloc]initWithFrame:CGRectMake(0, 39, KScreenW, 1)];
    line.backgroundColor = HEXCOLOR( 0xdedede);
   
    
//    [self addSubview:line];
    self.backgroundColor = [UIColor whiteColor];
    
}
-(void)applyFor_btndidClick
{
    NSLog(@"售后申请");
    
    
    
}
-(void)progress_btndidClick
{
    NSLog(@"进度查询");

}


@end
