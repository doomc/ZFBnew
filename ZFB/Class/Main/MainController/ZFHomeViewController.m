//
//  ZFHomeViewController.m
//  ZFB
//
//  Created by  展富宝  on 2017/5/11.
//  Copyright © 2017年 com.zfb. All rights reserved.
//  ****新零售

#import "ZFHomeViewController.h"
#import "FinGoodsViewController.h"
#import "FindStoreViewController.h"
#import "FindCircleViewController.h"
#import "DCNavTabBarController.h"

@interface ZFHomeViewController ()

@property(nonatomic,strong)UIButton * customLeft_btn;//扫一扫
@property(nonatomic,strong)UIButton * navSearch_btn;//搜索
@property(nonatomic,strong)UIButton * shakehanderRight_btn;//摇一摇

@end

@implementation ZFHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
 
    [self initMainController];
    
    [self customButtonOfNav];
}


-(void)initMainController
{
    FindStoreViewController *findStoreVC = [[FindStoreViewController alloc]init];
    findStoreVC.title = @"找 店";
    FinGoodsViewController *findGoodsVC = [[FinGoodsViewController alloc]init];
    findGoodsVC.title = @"找商品";
    FindCircleViewController *findCircleVC = [[FindCircleViewController alloc]init];
    findCircleVC.title = @"找圈子";
    
    NSArray *subViewControllers = @[findStoreVC,findGoodsVC,findCircleVC];
    
    DCNavTabBarController *tabBarVC = [[DCNavTabBarController alloc]initWithSubViewControllers:subViewControllers];
    tabBarVC.view.frame = CGRectMake(0,64, KScreenW, KScreenH - 64);
    [self.view addSubview:tabBarVC.view];
    [self addChildViewController:tabBarVC];
    

}
-(void)customButtonOfNav
{
    //    self.automaticallyAdjustsScrollViewInsets = NO;//(0,0)
    //    self.navigationController.navigationBar.translucent = NO;
    
    
    self.customLeft_btn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.customLeft_btn.frame = CGRectMake(20, 0, 40, 40);
    [self.customLeft_btn setImage :[UIImage imageNamed:@"saoyisao"]  forState:UIControlStateNormal];
    [self.customLeft_btn setTitle:@"扫一扫" forState:UIControlStateNormal];
    self.customLeft_btn.titleLabel.font = [UIFont systemFontOfSize:12];//title字体大小
    [self.customLeft_btn setTitleColor:HEXCOLOR(0xfe6d6a) forState:UIControlStateNormal];
    
    //设置文字图片的位置
    self.customLeft_btn.titleEdgeInsets = UIEdgeInsetsMake(0, -self.customLeft_btn.imageView.frame.size.width, -self.customLeft_btn.imageView.frame.size.height, 0);
    self.customLeft_btn.imageEdgeInsets = UIEdgeInsetsMake(-self.customLeft_btn.titleLabel.intrinsicContentSize.height, 0, 0, -self.customLeft_btn.titleLabel.intrinsicContentSize.width);
    [self.customLeft_btn addTarget:self action:@selector(clickAction) forControlEvents:UIControlEventTouchUpInside];
    //把button的视图交给Item
    UIBarButtonItem *saoItem = [[UIBarButtonItem alloc] initWithCustomView:self.customLeft_btn];
    //添加到导航项的左按钮
    self.navigationItem.leftBarButtonItem = saoItem;
    
    
    self.shakehanderRight_btn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.shakehanderRight_btn.frame = CGRectMake(KScreenW - 50 -40, 0, 40, 40);
    [self.shakehanderRight_btn setImage :[UIImage imageNamed:@"shakehand"]  forState:UIControlStateNormal];
    [self.shakehanderRight_btn setTitle:@"摇一摇" forState:UIControlStateNormal];
    self.shakehanderRight_btn.titleLabel.font = [UIFont systemFontOfSize:12];//title字体大小
    [self.shakehanderRight_btn setTitleColor:HEXCOLOR(0xfe6d6a) forState:UIControlStateNormal];
    
    //设置文字图片的位置
    self.shakehanderRight_btn.titleEdgeInsets = UIEdgeInsetsMake(0, -self.shakehanderRight_btn.imageView.frame.size.width, -self.shakehanderRight_btn.imageView.frame.size.height, 0);
    self.shakehanderRight_btn.imageEdgeInsets = UIEdgeInsetsMake(-self.shakehanderRight_btn.titleLabel.intrinsicContentSize.height, 0, 0, -self.shakehanderRight_btn.titleLabel.intrinsicContentSize.width);
    [self.shakehanderRight_btn addTarget:self action:@selector(clickAction) forControlEvents:UIControlEventTouchUpInside];
    
    //把button的视图交给Item
    UIBarButtonItem * shakeItem = [[UIBarButtonItem alloc] initWithCustomView:self.shakehanderRight_btn];
    //添加到导航项的左按钮
    self.navigationItem.rightBarButtonItem = shakeItem;
    
    
    
    self.navSearch_btn  =[UIButton buttonWithType:UIButtonTypeCustom];
    [self.navSearch_btn setBackgroundImage:[UIImage imageNamed:@"searchBar"] forState:UIControlStateNormal];
    [self.navSearch_btn addTarget:self action:@selector(DidClickSearchBarAction:) forControlEvents:UIControlEventTouchUpInside];
    self.navSearch_btn.frame = CGRectMake(0, 0, KScreenW - 60, 30);
    self.navigationItem.titleView = self.navSearch_btn;
    //navBar 的背景颜色
    self.navigationController.navigationBar.barTintColor = HEXCOLOR(0xffcccc);

    
    
/**
  跳转搜索

 @return 搜索
 */
}
-(void)DidClickSearchBarAction:(UIButton*)sender
{
    
}
/**
 扫一扫事件 、  摇一摇  、
 */
-(void)clickAction
{
    NSLog(@"clickAction");
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
