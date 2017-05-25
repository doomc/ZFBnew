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



-(UIView *)addNavWithTitle:(NSString *)Navtitle didClickArrowsDown:(SEL)didClickDownBtn ishidden:(BOOL)btnisHidden;
{
    self.navigationController.navigationBar.hidden = YES;
    
    UIView * bgView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, KScreenW, 64)];
    [self.view addSubview:bgView];
    bgView.backgroundColor = HEXCOLOR(0xffcccc);
    
    UIButton * left_btn = [UIButton buttonWithType:UIButtonTypeCustom];
    left_btn.frame =CGRectMake(10, bgView.centerY, 24, 24);
    [left_btn setImage:[UIImage imageNamed:@"nav_back"] forState:UIControlStateNormal];
    //    [left_btn addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
    [bgView addSubview:left_btn];
    
    
    UILabel * lb_title = [[UILabel alloc]initWithFrame:CGRectMake(bgView.centerX-20,bgView.centerY, 60, 24)];
    lb_title.text = Navtitle;
    lb_title.adjustsFontSizeToFitWidth = YES;
    lb_title.textAlignment = NSTextAlignmentCenter;
    lb_title.font = [UIFont systemFontOfSize:15];
    lb_title.textColor = HEXCOLOR(0xfe6d6a);
    [bgView addSubview:lb_title];
    
    
    
    UIButton * btn_Action = [UIButton buttonWithType:UIButtonTypeCustom];
    btn_Action.frame =CGRectMake(bgView.centerX+40 , bgView.centerY, 24, 24);
    [btn_Action setImage:[UIImage imageNamed:@"Order_down"] forState:UIControlStateNormal];
    [btn_Action addTarget:self action:didClickDownBtn forControlEvents:UIControlEventTouchUpInside];
    btn_Action.hidden =btnisHidden;
    [bgView addSubview:btn_Action];
    
    return bgView;
}




-(void)creatHeadViewWithleftTitle :(NSString *)leftTitle AndRightTitle :(NSString *)rigntTitle
{
    
    UIFont * font  =[UIFont systemFontOfSize:12];
    
    UIView *  headerView = [[UIView alloc]initWithFrame:CGRectMake(0 , 0, KScreenW, 40)];
    headerView.backgroundColor =[ UIColor whiteColor];
    
    UILabel * title = [[UILabel alloc]init];
    title.text = leftTitle;
    title.font = font;
    CGSize size = [title.text sizeWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:font,NSFontAttributeName,nil]];
    CGFloat titleW = size.width;
    title.frame = CGRectMake(15, 5, titleW, 30);
    title.textColor = HEXCOLOR(0x363636);
    
    
    UIButton * status = [[UIButton alloc]init ];
    [status setTitle:rigntTitle forState:UIControlStateNormal];
    status.titleLabel.font = font;
    [status setTitleColor: HEXCOLOR(0x363636) forState:UIControlStateNormal];
    CGSize statusSize = [rigntTitle sizeWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:font,NSFontAttributeName,nil]];
    CGFloat statusW = statusSize.width;
    
    status.frame = CGRectMake(KScreenW - statusW - 15, 5, statusW, 30);
    [status addTarget:self action:@selector(didclickEdit:) forControlEvents:UIControlEventTouchUpInside];
    
    UILabel *lineDown =[[UILabel alloc]initWithFrame:CGRectMake(0, 39, KScreenW, 1)];
    lineDown.backgroundColor = HEXCOLOR(0xffcccc);
    UILabel *lineUP =[[UILabel alloc]initWithFrame:CGRectMake(0,0, KScreenW, 10)];
    lineUP.backgroundColor = HEXCOLOR(0xdedede);
    
    //        [headerView addSubview:lineDown];
    //        [headerView addSubview:lineUP];
    [headerView addSubview:status];
    [headerView addSubview:title];
    
    
}

/**
 didclickEdit

 @param edit headview上的事件
 */
-(void)didclickEdit:(UIButton*)edit
{
    
}


-(UIView *)creatWithAFooterViewOfCaseOrder :(NSString *)caseOrder AndPrice:(NSString *)price AndSetButtonTitle :(NSString*)buttonTitle
{
    UIFont * font  =[UIFont systemFontOfSize:12];
    UIView* _footerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, KScreenW, 50)];
    _footerView.backgroundColor =[UIColor whiteColor];

    //结算按钮
    UIButton * complete_Btn  = [UIButton buttonWithType:UIButtonTypeCustom];
    [complete_Btn setTitle:buttonTitle forState:UIControlStateNormal];
    complete_Btn.titleLabel.font =font;
    CGSize complete_BtnSize = [buttonTitle sizeWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:font,NSFontAttributeName,nil]];
    CGFloat complete_BtnW = complete_BtnSize.width;
    complete_Btn.frame =CGRectMake(KScreenW - complete_BtnW - 15, 5, complete_BtnW, 25);
    [complete_Btn setBackgroundColor: HEXCOLOR(0xfe6d6a)];


    //价格
    UILabel * lb_price = [[UILabel alloc]init];
    lb_price.text = price;
    CGSize lb_priceSize = [price sizeWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:font,NSFontAttributeName, nil]];
    CGFloat lb_priceW = lb_priceSize.width;
    lb_price.frame = CGRectMake(KScreenW - lb_priceW -25-complete_BtnW, 5, lb_priceW, 30);
    lb_price.textAlignment = NSTextAlignmentLeft;
    lb_price.font = font;
    lb_price.textColor = HEXCOLOR(0xfe6d6a);
    
    //固定金额位置
    UILabel * lb_order = [[UILabel alloc]init];
    lb_order.text= caseOrder;
    lb_order.font = font;
    lb_order.textColor = HEXCOLOR(0x363636);
    CGSize lb_orderSiez = [caseOrder sizeWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:font,NSFontAttributeName, nil]];
    CGFloat lb_orderW = lb_orderSiez.width;
    lb_order.frame =  CGRectMake(KScreenW - lb_priceW -25-complete_BtnW-15-lb_orderW, 5, lb_orderW, 30);

    UILabel *line = [[UILabel alloc]initWithFrame:CGRectMake(0, 40, KScreenW, 10)];
    line.backgroundColor =HEXCOLOR(0xdedede);
    
 
    [_footerView addSubview:line];
    [_footerView addSubview: lb_price];
    [_footerView addSubview:lb_order];
    [_footerView addSubview:complete_Btn];
    
    return _footerView;
}






@end
