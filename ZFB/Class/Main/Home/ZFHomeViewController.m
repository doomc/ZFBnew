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

#import "BaseNavigationController.h"
#import "HomeSearchBarViewController.h"


@interface ZFHomeViewController ()<UISearchBarDelegate>
{
    NSInteger _pageSize;//每页显示条数
    NSInteger _pageIndex;//当前页码;
    
}

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
    
 //   [self settingCustomSearchBar];

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
 
}

/**
 跳转搜索

 @param sender sender点击放大镜
 */
-(void)DidClickSearchBarAction:(UIButton*)sender
{
    HomeSearchBarViewController  * sVC = [HomeSearchBarViewController new];
    BaseNavigationController * nav = [[BaseNavigationController alloc]initWithRootViewController:sVC];
    [self.navigationController presentViewController:nav animated:NO completion:^{
        
    }];
    


}
//-(void)DidClickSearchBarAction:(UIButton*)sender
//{
//
//    
// 
//    ZFSearchBarViewController  * sVC = [ZFSearchBarViewController new];
//        
//    
//    BaseNavigationController * nav = [[BaseNavigationController alloc]initWithRootViewController:sVC];
//    
//    [self.navigationController presentViewController:nav animated:NO completion:^{
//            
//        }];
// 
// 
//    NSLog(@"clickAction2");
//
//}
/**
 扫一扫事件 、  摇一摇  、
 */
-(void)clickAction
{
    NSLog(@"clickAction");
 
    JXTAlertController * jxt = [JXTAlertController alertControllerWithTitle:@"提示信息" message:@"功能暂未开放，敬请期待！" preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction * right = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
 
        //添加一些扫码或相册结果处理
 

    }];

    [jxt addAction:right];
    [self presentViewController:jxt animated:YES completion:^{  }];
 
}



@end
