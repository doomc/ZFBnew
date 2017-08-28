//
//  ZFPersonalHeaderView.h
//  ZFB
//
//  Created by  展富宝  on 2017/5/31.
//  Copyright © 2017年 com.zfb. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol PersonalHeaderViewDelegate  <NSObject>
//登录
-(void)didClickLoginAction:(UIButton*)sender;
//注册
-(void)didClickRegisterAction:(UIButton*)sender;

//更换头像
-(void)didClickHeadImageViewAction:(UITapGestureRecognizer *)sender;
//商品收藏的点击事件
-(void)didClickCollectAction:(UIButton *)sender;

//浏览足记的点击事件
-(void)didClickHistorytAction:(UIButton *)sender;

@end
@interface ZFPersonalHeaderView : UIView

@property (nonatomic,assign)id <PersonalHeaderViewDelegate> delegate;


//背景图
@property (weak, nonatomic) IBOutlet UIImageView *img_bgView;

//头像
@property (weak, nonatomic) IBOutlet UIImageView *img_headview;
//用户名
@property (weak, nonatomic) IBOutlet UILabel *lb_userNickname;

//商品收藏手势view
@property (weak, nonatomic) IBOutlet UIView *collectTagView;
//浏览足记view
@property (weak, nonatomic) IBOutlet UIView *historyTagView;

//收藏数量
@property (weak, nonatomic) IBOutlet UILabel *lb_collectCount;
//足记数量
@property (weak, nonatomic) IBOutlet UILabel *lb_historyCount;

//未登录的视图
@property (weak, nonatomic) IBOutlet UIView *unloginView;
//登录过后的图
@property (weak, nonatomic) IBOutlet UIView *loginView;


@property (weak, nonatomic) IBOutlet UIButton *btn_login;

@property (weak, nonatomic) IBOutlet UIButton *btn_regist;



@end
