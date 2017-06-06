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

-(void)right_button_event:(UIButton*)sender;
 
/**
 配送端自定义导航

 @param Navtitle  title名
 @param didClickDownBtn 点击箭头触发的事件
 @param btnisHidden  是否隐藏这个按钮
 */
-(UIView*)addNavWithTitle:(NSString *)Navtitle  didClickArrowsDown:(SEL)didClickDownBtn ishidden:(BOOL)btnisHidden;



/**
 编辑状态

 @param edit 编辑事件
 */
-(void)didclickEdit:(UIButton *)edit;

/**
 设置footerView上的控件

 
 @param caseOrder 总计
 @param price 价格
 @param buttonTitle 结算
 */
-(UIView *)creatWithAFooterViewOfCaseOrder :(NSString *)caseOrder AndPrice:(NSString *)price AndSetButtonTitle :(NSString*)buttonTitle;






@end
