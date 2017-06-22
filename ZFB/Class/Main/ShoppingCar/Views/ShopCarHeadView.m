//
//  ShopCarHeadView.m
//  ZFB
//
//  Created by  展富宝  on 2017/6/20.
//  Copyright © 2017年 com.zfb. All rights reserved.
//

#import "ShopCarHeadView.h"
@interface ShopCarHeadView ()

@end
@implementation ShopCarHeadView

-(void)setSectionBlock:(SctiontitleBlock)sectionBlock
{
    _sectionBlock = sectionBlock;
}

-(id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];

    if (self) {
        NSString *statusStr = @"编辑";
        NSString *titletext = @"王大帅进口食品厂";
        UIFont * font  =[UIFont systemFontOfSize:12];
        UILabel * title = [[UILabel alloc]init];
        title.text = titletext;
        title.font = font;
        CGSize size = [title.text sizeWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:font,NSFontAttributeName,nil]];
        CGFloat titleW = size.width;
        
        title.frame = CGRectMake(15, 5, titleW, 30);
        title.textColor = HEXCOLOR(0x363636);
        
        
        UIButton * edit_btn = [[UIButton alloc]init ];
        [edit_btn setTitle:statusStr forState:UIControlStateNormal];
        edit_btn.titleLabel.font = font;
        [edit_btn setTitleColor: HEXCOLOR(0x7a7a7a) forState:UIControlStateNormal];
        CGSize statusSize = [statusStr sizeWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:font,NSFontAttributeName,nil]];
        CGFloat statusW = statusSize.width;
        
        edit_btn.frame = CGRectMake(KScreenW - statusW - 15, 5, statusW, 30);
        [edit_btn addTarget:self action:@selector(didclickEdit:) forControlEvents:UIControlEventTouchUpInside];
        
        UILabel *lineDown =[[UILabel alloc]initWithFrame:CGRectMake(0, 39, KScreenW, 0.5)];
        lineDown.backgroundColor = HEXCOLOR(0xffcccc);
        UILabel *lineUP =[[UILabel alloc]initWithFrame:CGRectMake(0,0, KScreenW, 10)];
        lineUP.backgroundColor = RGB(247, 247, 247);//#F7F7F7 16进制
        
        [self addSubview:lineDown];
        [self addSubview:edit_btn];
        [self addSubview:title];
        

    }
    return self;
}


-(void)didclickEdit:(UIButton *)edit
{
    if ([self.shopCarDelegate respondsToSelector:@selector(editAction:)]) {
        [self.shopCarDelegate editAction:edit];
    }
}

@end
