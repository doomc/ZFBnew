//
//  BaseViewController.m
//  ZFB
//
//  Created by  展富宝  on 2017/5/11.
//  Copyright © 2017年 com.zfb. All rights reserved.
//

#import "BaseViewController.h"

@interface BaseViewController ()

@property (nonatomic, strong) UIView* overlayView;
@property (nonatomic, strong) UIView* bgview;
@property (nonatomic, strong) UIActivityIndicatorView *loadingIndicator;
@property (nonatomic, strong) UIImageView *loadingImageView;

@end

@implementation BaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    if (isIOS7) {
        
        self.automaticallyAdjustsScrollViewInsets = NO;
        //self.navigationController.navigationBar.translucent = NO;
        self.navigationController.navigationBar.barTintColor = HEXCOLOR(0xffcccc);
        
        [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:HEXCOLOR(0xfe6d6a),NSFontAttributeName:[UIFont systemFontOfSize:16.0]}];
        
    }
    self.view.backgroundColor = [UIColor  whiteColor];
    // 导航栏返回 按钮 打开注释掉的代码正常使用
    
    NSArray *viewControllers = self.navigationController.viewControllers;
    
    if (viewControllers.count > 1){
        
        [self.navigationItem setHidesBackButton:NO animated:NO];
        UIBarButtonItem *leftBarButtonItem = [ControlFactory createBackBarButtonItemWithTarget:self action:@selector(backAction)];
        if (isIOS7) {
            
            UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
           // negativeSpacer.width = -15;
            negativeSpacer.width = -10;

            self.navigationItem.leftBarButtonItems = @[negativeSpacer, leftBarButtonItem];
            
            
        }else{
            
            self.navigationItem.leftBarButtonItem = leftBarButtonItem;
        }
        
        UISwipeGestureRecognizer *gesture = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(backSweepGesture:)];
        gesture.direction = UISwipeGestureRecognizerDirectionRight;
        [self.view addGestureRecognizer:gesture];
        
    }else{
        
        [self.navigationItem setHidesBackButton:YES animated:NO];
        
    }
    [self rightButton];
    [self leftButton];
    
    self.currentPage = 1;

}
#pragma mark - 集成刷新
-(void)setupRefresh {
  
    self.zfb_tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(headerRefresh)];
    self.zfb_tableView.mj_footer = [MJRefreshBackStateFooter footerWithRefreshingTarget:self refreshingAction:@selector(footerRefresh)];
}
-(void)headerRefresh {

    self.refreshType = RefreshTypeHeader;
    self.currentPage = 1;
}
-(void)footerRefresh {
    
    self.refreshType = RefreshTypeFooter;
    self.currentPage ++;
}

-(void)endRefresh {

    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if (self.refreshType == RefreshTypeHeader) {
            
            [self.zfb_tableView.mj_header endRefreshing];
            
        }else {
            
            [self.zfb_tableView.mj_footer endRefreshingWithNoMoreData];
            
        }

    });
}

- (void)backSweepGesture:(UISwipeGestureRecognizer*)gesture{
    
    // [self dismissViewControllerAnimated:YES completion:nil];
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark Action
- (void)backAction{
    
    // [self dismissViewControllerAnimated:YES completion:nil];
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)setCustomerTitle:(NSString *)title{
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 0, 44)];
    titleLabel.text = title;
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.font = [UIFont systemFontOfSize:15];
    self.navigationItem.titleView = titleLabel;
    
}



/**
 didclickEdit

 @param edit headview上的事件
 */
-(void)didclickEdit:(UIButton*)edit
{
    
}



#pragma mark -- rightButton
-(BOOL)rightButton
{
    BOOL isright = [self respondsToSelector:@selector(set_rightButton)];
    if (isright) {
        UIButton *right_button = [self set_rightButton];
        [right_button addTarget:self action:@selector(right_click:) forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:right_button];
        self.navigationItem.rightBarButtonItem = item;
    }
    return isright;
}

-(void)right_click:(id)sender
{
    if ([self respondsToSelector:@selector(right_button_event:)]) {
        [self right_button_event:sender];
    }
}
 

#pragma mark --  leftButton
-(BOOL)leftButton
{
    BOOL isright = [self respondsToSelector:@selector(set_leftButton)];
    if (isright) {
        UIButton *left_Button = [self set_leftButton];
        [left_Button addTarget:self action:@selector(left_click:) forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:left_Button];
        self.navigationItem.leftBarButtonItem = item;
    }
    return isright;
}

-(void)left_click:(id)sender
{
    if ([self respondsToSelector:@selector(left_button_event:)]) {
        [self left_button_event:sender];
    }
}

#pragma mark - 去除searchbar 背景色
- (UIImage *)imageWithColor:(UIColor *)color size:(CGSize)size
{
    CGRect rect = CGRectMake(0, 0, size.width, size.height);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

//重写返回方法
-(void)poptoUIViewControllerNibName:(NSString *)controllerName AndObjectIndex:(NSInteger)objectIndex{
    
    [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:objectIndex] animated:YES];
    for(UIViewController * controller in self.navigationController.viewControllers) {
        
        if([controller isKindOfClass:[controllerName class]]) {
            
            [self.navigationController popToViewController:controller animated:YES];
        }
    }
}
#pragma mark - 判断是不是空数组
- (BOOL)isEmptyArray:(NSMutableArray *)array
{
    return (array.count == 0 || array == nil || [array isKindOfClass:[NSNull class]]);
}

@end

