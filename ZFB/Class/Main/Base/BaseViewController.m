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
//        self.navigationController.navigationBar.translucent = NO;
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
        negativeSpacer.width = -15;
        
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
    titleLabel.font = [UIFont systemFontOfSize:18];
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



-(void)addNavWithTitle:(NSString *)Navtitle didClickArrowsDown:(SEL)didClickDownBtn ishidden:(BOOL)btnisHidden;
{
    self.navigationController.navigationBar.hidden = YES;
    
    UIView * bgView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, KScreenW, 64)];
    [self.view addSubview:bgView];
    bgView.backgroundColor = HEXCOLOR(0xffcccc);
    
    UIButton * left_btn = [UIButton buttonWithType:UIButtonTypeCustom];
    left_btn.frame =CGRectMake(10, bgView.centerY, 24, 24);
    [left_btn setImage:[UIImage imageNamed:@"nav_back"] forState:UIControlStateNormal];
    [bgView addSubview:left_btn];
    
    
    UILabel * lb_title = [[UILabel alloc]initWithFrame:CGRectMake(bgView.centerX-20,bgView.centerY, 60, 24)];
    lb_title.text = Navtitle;
    lb_title.adjustsFontSizeToFitWidth = YES;
    lb_title.textAlignment = NSTextAlignmentCenter;
    lb_title.font = [UIFont systemFontOfSize:15];
    lb_title.textColor = HEXCOLOR(0xfe6d6a);
    [bgView addSubview:lb_title];
  //  CGSize titleSize = [lb_title.text sizeWithFont:lb_title.font constrainedToSize:CGSizeMake(MAXFLOAT, 30)];
    


    UIButton * btn_Action = [UIButton buttonWithType:UIButtonTypeCustom];
    btn_Action.frame =CGRectMake(bgView.centerX+40 , bgView.centerY, 24, 24);
    [btn_Action setImage:[UIImage imageNamed:@"Order_down"] forState:UIControlStateNormal];
    [btn_Action addTarget:self action:didClickDownBtn forControlEvents:UIControlEventTouchUpInside];
    btn_Action.hidden =btnisHidden;
    [bgView addSubview:btn_Action];
    

}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
