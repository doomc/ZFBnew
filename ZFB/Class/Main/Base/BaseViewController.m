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
        
        [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:HEXCOLOR(0xfe6d6a),NSFontAttributeName:[UIFont systemFontOfSize:15.0]}];
        
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

-(void)popToViewControllerWithName:(NSString *)name {
    
    for (UIViewController *vc in self.navigationController.viewControllers) {
        NSString *vcString = NSStringFromClass([vc class]);
        if ([vcString isEqualToString:name]) {
            
            [self.navigationController popToViewController:vc animated:YES];
        }
    }
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
@end

