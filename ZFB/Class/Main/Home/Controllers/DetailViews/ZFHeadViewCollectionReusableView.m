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
        UIFont * font           = [UIFont systemFontOfSize:15];
        self.titleView =[[ UIView alloc]initWithFrame:CGRectMake(0, _headViewHeignt, KScreenW, 44)];
        
        _title_lb           = [[UILabel alloc]initWithFrame:CGRectMake(15, 0, KScreenW*0.5, 43)];
        _title_lb.textColor = HEXCOLOR(0x363636);
        _title_lb.font      = font;
        
        [self.titleView addSubview:_title_lb];
        
        //到店付
        //        UIButton *gotoStore_btn =[UIButton buttonWithType:UIButtonTypeCustom];
        //        gotoStore_btn.clipsToBounds = YES;
        //        gotoStore_btn.layer.cornerRadius = 4;
        //        [gotoStore_btn addTarget:self action:@selector(didClickgotoStore_btn) forControlEvents:UIControlEventTouchUpInside];
        //        gotoStore_btn.frame  = CGRectMake(KScreenW -90, 7, 70, 30);
        //        gotoStore_btn.titleLabel.font = [UIFont systemFontOfSize:14 ];
        //        [gotoStore_btn setTitle:@"到店付" forState:UIControlStateNormal];
        //        gotoStore_btn.backgroundColor = HEXCOLOR(0xfe6d6a);
        //        [self.titleView addSubview:gotoStore_btn];
        
        //下划线
        UILabel *line        = [[UILabel alloc]initWithFrame:CGRectMake(0, 43, KScreenW, 1)];
        line.backgroundColor = HEXCOLOR(0xdedede);
        [self.titleView  addSubview:line];
        
        //位置定位
        self.locationView = [[ UIView alloc]initWithFrame:CGRectMake(0, 44+_headViewHeignt, KScreenW, 44)];
        
        
        //定位logo
        UIImageView *icon_location = [[ UIImageView alloc]initWithFrame:CGRectMake(10, 7, 30, 30)];
        icon_location.image =[ UIImage imageNamed:@"location_icon2"];
        [self.locationView addSubview:icon_location];
        
        //电话logo
        UIImageView * icon_phone = [[ UIImageView alloc]initWithFrame:CGRectMake(KScreenW-15-30, 7, 30, 30)];
        icon_phone.image =[ UIImage imageNamed:@"calling_icon"];
        [self.locationView addSubview:icon_phone];
        
        _address_lb               = [[UILabel alloc]initWithFrame:CGRectMake( 40, 0, KScreenW -80, 43)];
        _address_lb.text          = @"渝北区新牌坊清风南路-龙湖-水晶郦城西门-组团";
        _address_lb.textAlignment = NSTextAlignmentLeft;
        _address_lb.font          = font;
        _address_lb.textColor     = HEXCOLOR(0x363636);
        [self.locationView addSubview:_address_lb];
        
        //全部商品section
        self.sectionView =[[ UIView alloc]initWithFrame:CGRectMake(0, 88+_headViewHeignt, KScreenW, 44)];
        _sectionView.backgroundColor = HEXCOLOR(0xffcccc);
        
        UIImageView * section_icon = [[UIImageView alloc]initWithFrame:CGRectMake(10, 7, 30, 30)];
        section_icon.image =[ UIImage imageNamed:@"more_icon"];
        [self.sectionView addSubview:section_icon];
        
        UILabel * sectionTitle= [[ UILabel alloc]initWithFrame:CGRectMake(40, 0, 100, 44)];
        sectionTitle.text =@"全部商品";
        sectionTitle.font =[UIFont systemFontOfSize:14];
        sectionTitle.textAlignment = NSTextAlignmentLeft;
        sectionTitle.textColor = HEXCOLOR(0x363636);
        [self.sectionView addSubview:sectionTitle];
        
        
        [self addSubview:_sectionView];
        [self addSubview:_locationView];
        [self addSubview:_titleView];
        
    }
    return self;
}


- (void)didClickgotoStore_btn
{
    NSLog(@"到店付");
    //    [self.gotoStore_btn respondsToSelector:@selector(didClickgotoStore_btn:)];
    
}






@end
