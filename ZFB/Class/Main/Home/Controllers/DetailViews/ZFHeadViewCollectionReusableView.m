//
//  ZFHeadViewCollectionReusableView.m
//  ZFB
//
//  Created by 熊维东 on 2017/5/18.
//  Copyright © 2017年 com.zfb. All rights reserved.
//

#import "ZFHeadViewCollectionReusableView.h"
@interface ZFHeadViewCollectionReusableView ()

//设置titleView
@property (strong,nonatomic) UIView * titleView;

//位置定位View
@property (strong,nonatomic) UIView * locationView;

//全部商品section
@property (strong,nonatomic) UIView *sectionView;

@end

@implementation ZFHeadViewCollectionReusableView

-(instancetype)initWithFrame:(CGRect)frame
 {
    self =[super initWithFrame:frame];
    
    if (self) {
      
        CGFloat _headViewHeignt = 155.f;
        self.titleView =[[ UIView alloc]initWithFrame:CGRectMake(0, _headViewHeignt, KScreenW, 40)];
     
        
        UILabel *title_lb= [[UILabel alloc]initWithFrame:CGRectMake(15, 0, KScreenW*0.5, 39)];
        title_lb.text = @"KOTTE化妆品专卖店";
        title_lb.textColor = HEXCOLOR(0xfe6d6a);
        title_lb.font =[UIFont systemFontOfSize:12];
//        title_lb.backgroundColor = [UIColor yellowColor];
        [self.titleView addSubview:title_lb];
        
        //到店付
        UIButton *gotoStore_btn =[UIButton buttonWithType:UIButtonTypeCustom];
        [gotoStore_btn addTarget:self action:@selector(didClickgotoStore_btn) forControlEvents:UIControlEventTouchUpInside];
        gotoStore_btn.frame  = CGRectMake(KScreenW -100, 5, 80, 30);
        gotoStore_btn.titleLabel.font = [UIFont systemFontOfSize:12 ];
        [gotoStore_btn setTitle:@"到店付" forState:UIControlStateNormal];
        gotoStore_btn.backgroundColor = HEXCOLOR(0xfe6d6a);
        [self.titleView addSubview:gotoStore_btn];
        
        //下划线
        UILabel *line = [[UILabel alloc]initWithFrame:CGRectMake(0, 39, KScreenW, 1)];
        line.backgroundColor = HEXCOLOR(0xdedede);
        [self.titleView  addSubview:line];
        
        //位置定位
        self.locationView= [[ UIView alloc]initWithFrame:CGRectMake(0, 40+_headViewHeignt, KScreenW, 40)];


        //定位logo
        UIImageView *icon_location = [[ UIImageView alloc]initWithFrame:CGRectMake(10, 5, 30, 30)];
        icon_location.image =[ UIImage imageNamed:@"location_icon2"];
        [self.locationView addSubview:icon_location];
        
        //电话logo
        UIImageView * icon_phone = [[ UIImageView alloc]initWithFrame:CGRectMake(KScreenW-15-20, 5, 30, 30)];
        icon_phone.image =[ UIImage imageNamed:@"calling_icon"];
        [self.locationView addSubview:icon_phone];
        
        UILabel* locatext = [[UILabel alloc]initWithFrame:CGRectMake( 40, 0, KScreenW -80, 39)];
        locatext.text = @"渝北区新牌坊清风南路-龙湖-水晶郦城西门-组团";
        locatext.textAlignment = NSTextAlignmentLeft;
        locatext.font =[ UIFont systemFontOfSize:12.0];
        locatext.textColor = HEXCOLOR(0x363636);
        [self.locationView addSubview:locatext];
        
        //全部商品section
        self.sectionView =[[ UIView alloc]initWithFrame:CGRectMake(0, 80+_headViewHeignt, KScreenW, 40)];
        _sectionView.backgroundColor = HEXCOLOR(0xffcccc);
 
        UIImageView * section_icon = [[UIImageView alloc]initWithFrame:CGRectMake(10, 5, 30, 30)];
         section_icon.image =[ UIImage imageNamed:@"more_icon"];
        [self.sectionView addSubview:section_icon];
        
        UILabel * sectionTitle= [[ UILabel alloc]initWithFrame:CGRectMake(40, 0, 100, 40)];
        sectionTitle.text =@"全部商品";
        sectionTitle.font =[UIFont systemFontOfSize:13];
        sectionTitle.textAlignment = NSTextAlignmentLeft;
        sectionTitle.textColor = HEXCOLOR(0x363636);
        [self.sectionView addSubview:sectionTitle];
 
        
        [self addSubview:_sectionView];
        [self addSubview:_locationView];
        [self addSubview:_titleView];
        
//        self.backgroundColor = randomColor;
    }
    
    return self;
}


- (void)didClickgotoStore_btn
{
    NSLog(@"到店付");
//    [self.gotoStore_btn respondsToSelector:@selector(didClickgotoStore_btn:)];
   
}






@end
