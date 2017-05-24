//
//  CustomHeaderView.m
//  ZFB
//
//  Created by  展富宝  on 2017/5/24.
//  Copyright © 2017年 com.zfb. All rights reserved.
//

#import "CustomHeaderView.h"

@implementation CustomHeaderView

-(instancetype)initWithFrame:(CGRect)frame

{
    self = [super initWithFrame:frame];
    if (self) {
        
        NSString *leftTitle = @"2017-08-23";
        NSString *rigntTitle = @"配送中";
        
        
        UIView *  headerView = [[UIView alloc]initWithFrame:CGRectMake(0 , 0, KScreenW, 40)];
        headerView.backgroundColor =[ UIColor whiteColor];
        UIFont * font  =[UIFont systemFontOfSize:12];

        UILabel * title = [[UILabel alloc]init];
        title.text = leftTitle;
        title.font = font;
        CGSize size = [title.text sizeWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:font,NSFontAttributeName,nil]];
        CGFloat titleW = size.width;
        title.frame = CGRectMake(15, 5, titleW, 30);
        title.textColor = HEXCOLOR(0x363636);
        
        
        UIButton * status = [[UIButton alloc]init ];
        [status setTitle:rigntTitle forState:UIControlStateNormal];
        status.titleLabel.font = font;
        [status setTitleColor: HEXCOLOR(0x363636) forState:UIControlStateNormal];
        CGSize statusSize = [rigntTitle sizeWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:font,NSFontAttributeName,nil]];
        CGFloat statusW = statusSize.width;
        
        status.frame = CGRectMake(KScreenW - statusW - 15, 5, statusW, 30);
        [status addTarget:self action:@selector(didclickEdit:) forControlEvents:UIControlEventTouchUpInside];
        
        UILabel *lineDown =[[UILabel alloc]initWithFrame:CGRectMake(0, 39, KScreenW, 1)];
        lineDown.backgroundColor = HEXCOLOR(0xdedede);
        UILabel *lineUP =[[UILabel alloc]initWithFrame:CGRectMake(0,0, KScreenW, 10)];
        lineUP.backgroundColor = HEXCOLOR(0xdedede);
        
        [headerView addSubview:lineDown];
        //        [headerView addSubview:lineUP];
        [headerView addSubview:status];
        [headerView addSubview:title];
        
        [self addSubview:headerView];

    }
    return self;
}

-(void)didclickEdit:(UIButton*)edit
{
    
}


// 步骤4 在`layoutSubviews`方法中设置子控件的`frame`（在该方法中一定要调用`[super layoutSubviews]`方法）
- (void)layoutSubviews
{
    [super layoutSubviews];
}

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */

@end
