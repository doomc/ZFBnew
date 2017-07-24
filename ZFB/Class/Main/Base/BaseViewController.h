//
//  BaseViewController.h
//  ZFB
//
//  Created by  展富宝  on 2017/5/11.
//  Copyright © 2017年 com.zfb. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BaseViewController : UIViewController

-(void)backAction;
-(void)popToViewControllerWithName:(NSString *)name ;

-(UIButton*)set_rightButton;
-(UIButton*)set_leftButton;

-(void)right_button_event:(UIButton*)sender;
-(void)left_button_event:(UIButton*)sender;



/**
 编辑状态

 @param edit 编辑事件
 */
-(void)didclickEdit:(UIButton *)edit;


/** 取消searchBar背景色 */
- (UIImage *)imageWithColor:(UIColor *)color size:(CGSize)size;


@end
