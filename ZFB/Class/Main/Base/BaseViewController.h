//
//  BaseViewController.h
//  ZFB
//
//  Created by  展富宝  on 2017/5/11.
//  Copyright © 2017年 com.zfb. All rights reserved.
//

#import <UIKit/UIKit.h>

#define kPageCount 10

/**
 刷新类型

 - RefreshTypeHeader: 下拉刷新
 - RefreshTypeFooter: 上拉刷新
 */
typedef NS_ENUM(NSInteger, RefreshType) {
    RefreshTypeHeader,
    RefreshTypeFooter
};

@interface BaseViewController : UIViewController

@property (nonatomic, assign) RefreshType refreshType;
@property (nonatomic, assign) NSInteger currentPage;
@property (nonatomic, strong) UITableView * zfb_tableView;


/**
 集成刷新
 */
-(void)setupRefresh;

/**
 下拉刷新
 */
-(void)headerRefresh;

/**
 上拉刷新
 */
-(void)footerRefresh;

/**
 结束刷新
 */
-(void)endRefresh;


-(void)backAction;

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


/** pop到指定页面 */
-(void)poptoUIViewControllerNibName:(NSString *)controllerName AndObjectIndex:(NSInteger)objectIndex;

///判断是不是空数组
/**
 判断是不是空数组
 
 @param array 传入数组
 @return 1是空 0不是
 */
- (BOOL)isEmptyArray:(NSMutableArray *)array;

//判断密码 不能太简单了
- (BOOL)checkPassWordIsNotEasy:(NSMutableString *)oldPassword;

//如果没有登录
-(void)isIfNotSignIn;

//用户提示没开放的任务
- (void)settingAlertView;

@end
