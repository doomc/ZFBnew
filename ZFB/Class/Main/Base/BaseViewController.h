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
 配送端自定义导航

 @param Navtitle  title名
 @param didClickDownBtn 点击箭头触发的事件
 @param btnisHidden  是否隐藏这个按钮
 */
-(void)addNavWithTitle:(NSString *)Navtitle  didClickArrowsDown:(SEL)didClickDownBtn ishidden:(BOOL)btnisHidden;





/**
 设置headView

 @param headTitle 名称
 @param statusStr 状态（编辑）
 */
-(UIView *)AddwithAHeadViewOfLb_title:(NSString*)headTitle  Andstatus :(NSString *)statusStr ;



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
