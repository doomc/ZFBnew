//
//  ZFHeadViewCollectionReusableView.h
//  ZFB
//
//  Created by 熊维东 on 2017/5/18.
//  Copyright © 2017年 com.zfb. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZFHeadViewCollectionReusableView : UICollectionReusableView
//设置titleView
@property (strong,nonatomic) UIView * titleView;
@property (strong,nonatomic) UILabel * title_lb ;
@property (strong,nonatomic) UIButton * gotoStore_btn;//到店付按钮 暂时不要？
@property (strong,nonatomic) UILabel* line;//下划线

//位置定位View
@property (strong,nonatomic) UIView * locationView;
@property (strong,nonatomic) UIImageView * icon_location;//定位logo
@property (strong,nonatomic) UILabel * locatext;//定位位置名字
@property (strong,nonatomic) UIImageView * icon_phone;//电话logo


//全部商品section
@property (strong,nonatomic) UIView *sectionView;
@property (strong,nonatomic) UIImageView * section_icon ;
@property (strong,nonatomic) UILabel * sectionTitle;



@end
