//
//  BaseViewController.h
//  ZFB
//
//  Created by  展富宝  on 2017/5/11.
//  Copyright © 2017年 com.zfb. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BaseViewController : UIViewController

- (void)backAction;

-(void)setCustomerTitle:(NSString *)title;

-(void)popToViewControllerWithName:(NSString *)name ;



/**
 自定义导航

 @param Navtitle  title名
 @param didClickDownBtn 点击箭头触发的事件
 @param btnisHidden  是否隐藏这个按钮
 */
-(void)addNavWithTitle:(NSString *)Navtitle didClickArrowsDown:(SEL)didClickDownBtn ishidden:(BOOL)btnisHidden;

@end
