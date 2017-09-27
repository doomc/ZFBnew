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
#import "ZFBaseNavigationViewController.h"

#import "HomeSearchBarViewController.h"//搜索跳转
#import "SGPagingView.h"//控制自控制器

#import <AVFoundation/AVFoundation.h>
#import "QRCodeSaoyiSaoViewController.h"//扫一扫
#import "QRPayMoneyViewController.h"//付款
#import "QRCollectMoneyViewController.h"//收款


typedef NS_ENUM(NSUInteger, TypeVC) {
    TypeVCSaoyiSao,
    TypeVCAcceptMoney,
    TypeVCPaymoney,
};
@interface ZFHomeViewController () <SGPageTitleViewDelegate, SGPageContentViewDelegate,YBPopupMenuDelegate>

@property (nonatomic, strong) SGPageTitleView *pageTitleView;
@property (nonatomic, strong) SGPageContentView *pageContentView;


@property(nonatomic,strong)UIButton * customLeft_btn;//扫一扫
@property(nonatomic,strong)UIButton * navSearch_btn;//搜索
@property(nonatomic,strong)UIButton * shakehanderRight_btn;//摇一摇

@property(nonatomic,strong)NSArray * titlesArr; //右边按钮列表
@property(nonatomic,strong)NSArray * iconArr;

@property(nonatomic,assign)TypeVC psuhTypeVC;//选择跳转到哪个控制器
@end

@implementation ZFHomeViewController
- (void)dealloc {
    NSLog(@"DefaultVCOne - - dealloc");
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _titlesArr = @[@"扫一扫",@"收款",@"付款"];
    _iconArr = @[@"saoyisao",@"saoyisao",@"saoyisao"];
  
    [self customButtonOfNav];
 
    [self setupPageView];

}

- (void)setupPageView {
    
    FindStoreViewController *findStoreVC = [[FindStoreViewController alloc]init];
    FinGoodsViewController *findGoodsVC = [[FinGoodsViewController alloc]init];
    FindCircleViewController *findCircleVC = [[FindCircleViewController alloc]init];
    
    NSArray *childArr = @[findStoreVC, findGoodsVC];
    /// pageContentView
    CGFloat contentViewHeight = self.view.frame.size.height - 108;
    self.pageContentView = [[SGPageContentView alloc] initWithFrame:CGRectMake(0, 108, self.view.frame.size.width, contentViewHeight) parentVC:self childVCs:childArr];
    _pageContentView.delegatePageContentView = self;
    [self.view addSubview:_pageContentView];
    
    NSArray *titleArr = @[@"找店", @"找商品"];
    /// pageTitleView
    self.pageTitleView = [SGPageTitleView pageTitleViewWithFrame:CGRectMake(0, 64, self.view.frame.size.width, 44) delegate:self titleNames:titleArr];
    [self.view addSubview:_pageTitleView];
    _pageTitleView.isTitleGradientEffect = NO;
    _pageTitleView.indicatorLengthStyle = SGIndicatorLengthStyleSpecial;
    _pageTitleView.indicatorScrollStyle = SGIndicatorScrollStyleHalf;
    _pageTitleView.selectedIndex = 0;
    _pageTitleView.isShowBottomSeparator = NO;
    _pageTitleView.isNeedBounces = NO;
    _pageTitleView.titleColorStateSelected = HEXCOLOR(0xfe6d6a);
    _pageTitleView.titleColorStateNormal = HEXCOLOR(0x363636);
    _pageTitleView.indicatorColor = [UIColor colorWithRed:0.996 green:0.427 blue:0.416 alpha:1.000];
    _pageTitleView.indicatorHeight = 1.0;
    _pageTitleView.titleTextScaling = 0.3;
}

- (void)pageTitleView:(SGPageTitleView *)pageTitleView selectedIndex:(NSInteger)selectedIndex
{
    [self.pageContentView setPageCententViewCurrentIndex:selectedIndex];
}

- (void)pageContentView:(SGPageContentView *)pageContentView progress:(CGFloat)progress originalIndex:(NSInteger)originalIndex targetIndex:(NSInteger)targetIndex {
    [self.pageTitleView setPageTitleViewWithProgress:progress originalIndex:originalIndex targetIndex:targetIndex];
}

-(void)customButtonOfNav
{

    self.customLeft_btn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.customLeft_btn.frame = CGRectMake(0, 0, 40, 40);
    [self.customLeft_btn setTitle:@"重庆市" forState:UIControlStateNormal];
    self.customLeft_btn.titleLabel.font = [ UIFont systemFontOfSize:12];
    [self.customLeft_btn setTitleColor:HEXCOLOR(0xfe6d6a) forState:UIControlStateNormal];
 
//    //把button的视图交给Item
    UIBarButtonItem *saoItem = [[UIBarButtonItem alloc] initWithCustomView:self.customLeft_btn];
    //添加到导航项的左按钮
    self.navigationItem.leftBarButtonItem = saoItem;

    self.shakehanderRight_btn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.shakehanderRight_btn.frame = CGRectMake(KScreenW - 50 -40, 0, 40, 40);
    [self.shakehanderRight_btn setImage :[UIImage imageNamed:@"add_red"]  forState:UIControlStateNormal];
    [self.shakehanderRight_btn addTarget:self action:@selector(clickAction:) forControlEvents:UIControlEventTouchUpInside];
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
    ZFBaseNavigationViewController * nav = [[ZFBaseNavigationViewController alloc]initWithRootViewController:sVC];
    [self.navigationController presentViewController:nav animated:NO completion:^{
        
    }];
    
}
 
/**
 扫一扫事件 、  摇一摇  、
 */
-(void)clickAction:(UIButton *)sender
{
    NSLog(@"clickAction");
    
    if ( KScreenW == Iphone6PlusWidth ) {
        [YBPopupMenu showRelyOnView:sender titles:_titlesArr icons:_iconArr menuWidth:140 otherSettings:^(YBPopupMenu *popupMenu) {
            popupMenu.isShowShadow = YES;
            popupMenu.delegate = self;
            popupMenu.offset = 10;
            popupMenu.type = YBPopupMenuTypeDark;
            
        }];
   
    }
    else{
        [YBPopupMenu showRelyOnView:sender titles:_titlesArr icons:_iconArr menuWidth:120 otherSettings:^(YBPopupMenu *popupMenu) {
            popupMenu.isShowShadow = YES;
            popupMenu.delegate = self;
            popupMenu.offset = 10;
            popupMenu.type = YBPopupMenuTypeDark;
            
        }];
    }
}
#pragma mark - YBPopupMenu Delegate
- (void)ybPopupMenuDidSelectedAtIndex:(NSInteger)index ybPopupMenu:(YBPopupMenu *)ybPopupMenu
{
    NSLog(@" %ld ",index);
    _psuhTypeVC = index;
    switch (_psuhTypeVC) {
       
        case TypeVCSaoyiSao:
            NSLog(@"第一个扫一扫VC");
            [self scanningQRCode];
   
            break;

        case TypeVCAcceptMoney://收款
            NSLog(@"第2个VC");
            [self collectMoneyQRCode];

            break;
        case TypeVCPaymoney://付款
            NSLog(@"第3 ge VC");
            [self PayMoneyQRCode];

            break;

    }
}

/** 生成二维码方法 *///付款码
- (void)PayMoneyQRCode {

    QRPayMoneyViewController *VC = [[QRPayMoneyViewController alloc] init];
    [self.navigationController pushViewController:VC animated:NO];
    
}
///收款码
- (void)collectMoneyQRCode {
    
    QRCollectMoneyViewController * collctVC = [[QRCollectMoneyViewController alloc]init];
    [self.navigationController pushViewController:collctVC animated:NO];

    
}

/** 扫描二维码方法 */
- (void)scanningQRCode {
    // 1、 获取摄像设备
    AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    if (device) {
        AVAuthorizationStatus status = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
        if (status == AVAuthorizationStatusNotDetermined) {
            [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
                if (granted) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        QRCodeSaoyiSaoViewController *vc = [[QRCodeSaoyiSaoViewController alloc] init];
                        [self.navigationController pushViewController:vc animated:YES];
                    });
                    
                    NSLog(@"当前线程 - - %@", [NSThread currentThread]);
                    // 用户第一次同意了访问相机权限
                    NSLog(@"用户第一次同意了访问相机权限");
                    
                } else {
                    
                    // 用户第一次拒绝了访问相机权限
                    NSLog(@"用户第一次拒绝了访问相机权限");
                }
            }];
        } else if (status == AVAuthorizationStatusAuthorized) { // 用户允许当前应用访问相机
            QRCodeSaoyiSaoViewController *vc = [[QRCodeSaoyiSaoViewController alloc] init];
            [self.navigationController pushViewController:vc animated:YES];
        } else if (status == AVAuthorizationStatusDenied) { // 用户拒绝当前应用访问相机
            UIAlertController *alertC = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"请去-> [设置 - 隐私 - 相机 - SGQRCodeExample] 打开访问开关" preferredStyle:(UIAlertControllerStyleAlert)];
            UIAlertAction *alertA = [UIAlertAction actionWithTitle:@"确定" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
                
            }];
            
            [alertC addAction:alertA];
            [self presentViewController:alertC animated:YES completion:nil];
            
        } else if (status == AVAuthorizationStatusRestricted) {
            NSLog(@"因为系统原因, 无法访问相册");
        }
    } else {
        UIAlertController *alertC = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"未检测到您的摄像头" preferredStyle:(UIAlertControllerStyleAlert)];
        UIAlertAction *alertA = [UIAlertAction actionWithTitle:@"确定" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        
        [alertC addAction:alertA];
        [self presentViewController:alertC animated:YES completion:nil];
    } 
    
}

@end
