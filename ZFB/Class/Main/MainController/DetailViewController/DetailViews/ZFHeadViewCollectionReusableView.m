//
//  ZFHeadViewCollectionReusableView.m
//  ZFB
//
//  Created by 熊维东 on 2017/5/18.
//  Copyright © 2017年 com.zfb. All rights reserved.
//

#import "ZFHeadViewCollectionReusableView.h"

@implementation ZFHeadViewCollectionReusableView

- (id) initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    return self;
}

-(instancetype)initWithFrame:(CGRect)frame
{
    self =[super initWithFrame:frame];
    
    if (self) {
      
        CGFloat _headViewHeignt = 155.f;
        _titleView =[[ UIView alloc]initWithFrame:CGRectMake(0, _headViewHeignt, KScreenW, 40)];
        [self addSubview:_titleView];
        
        self.title_lb= [[UILabel alloc]initWithFrame:CGRectMake(15, 0, KScreenW*0.5, 39)];
        _title_lb.text = @"KOTTE化妆品专卖店";
        _title_lb.textColor = HEXCOLOR(0xfe6d6a);
        _title_lb.font =[UIFont systemFontOfSize:12];
        _titleView.backgroundColor = [UIColor yellowColor];
        [self.titleView addSubview:_title_lb];
        
        //到店付
        self.gotoStore_btn =[UIButton buttonWithType:UIButtonTypeCustom];
        [_gotoStore_btn addTarget:self action:@selector(didClickgotoStore_btn) forControlEvents:UIControlEventTouchUpInside];
        _gotoStore_btn.frame  = CGRectMake(KScreenW -100-15, 16, 100, 20);
        [_gotoStore_btn setTitle:@"到店付" forState:UIControlStateNormal];
        _gotoStore_btn.backgroundColor = HEXCOLOR(0xffffff);
        [self.titleView addSubview:_gotoStore_btn];
        
        //下划线
        self.line = [[UILabel alloc]initWithFrame:CGRectMake(0, 39, KScreenW, 1)];
        _line.backgroundColor = HEXCOLOR(0xdedede);
        [_titleView addSubview:_line];
        
        
        //位置定位
        self.locationView= [[ UIView alloc]initWithFrame:CGRectMake(0, 40+_headViewHeignt, KScreenW, 40)];
        [self addSubview:_locationView];
        
        //定位logo
        _icon_location = [[ UIImageView alloc]initWithFrame:CGRectMake(10, 5, 30, 30)];
        _icon_location.image =[ UIImage imageNamed:@"location_icon2"];
        [self.locationView addSubview:_icon_location];
        
        //电话logo
        _icon_phone = [[ UIImageView alloc]initWithFrame:CGRectMake(KScreenW-15-20, 5, 30, 30)];
        _icon_phone.image =[ UIImage imageNamed:@"calling_icon"];
        [self.locationView addSubview:_icon_phone];
        
        _locatext = [[UILabel alloc]initWithFrame:CGRectMake( 40, 0, KScreenW -80, 39)];
        _locatext.text = @"渝北区新牌坊清风南路-龙湖-水晶郦城西门-组团";
        _locatext.textAlignment = NSTextAlignmentLeft;
        _locatext.font =[ UIFont systemFontOfSize:12.0];
        _locatext.textColor = HEXCOLOR(0x363636);
        
        
        [self.locationView addSubview:_locatext];
        
        //全部商品section
        self.sectionView =[[ UIView alloc]initWithFrame:CGRectMake(0, 80+_headViewHeignt, KScreenW, 40)];
        _sectionView.backgroundColor = HEXCOLOR(0xffcccc);
        [self addSubview:_sectionView];
        
         self.section_icon = [[UIImageView alloc]initWithFrame:CGRectMake(10, 5, 30, 30)];
         _section_icon.image =[ UIImage imageNamed:@"more_icon"];
        [self.sectionView addSubview:_section_icon];
        
        _sectionTitle= [[ UILabel alloc]initWithFrame:CGRectMake(40, 0, 100, 40)];
        _sectionTitle.text =@"全部商品";
        _sectionTitle.font =[UIFont systemFontOfSize:13];
        _sectionTitle.textAlignment = NSTextAlignmentLeft;
        _sectionTitle.textColor = HEXCOLOR(0x363636);
        [self.sectionView addSubview:_sectionTitle];
        

    }
    
    return self;
}


- (void)didClickgotoStore_btn
{
    NSLog(@"到店付");
//    [self.gotoStore_btn respondsToSelector:@selector(didClickgotoStore_btn:)];
   
}






@end
