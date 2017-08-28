//
//  ZFCInterpersonalCircleViewController.m
//  ZFB
//
//  Created by  展富宝  on 2017/5/11.
//  Copyright © 2017年 com.zfb. All rights reserved.
//  ****人际圈

#import "ZFCInterpersonalCircleViewController.h"
#import "SGPagingView.h"//控制自控制器
//#import "IMContactListViewController.h"//联系人通讯录
//#import "IMFriendsCircleViewController.h"//朋友圈
#import "IMChatSessionViewController.h"//会话列表
#import "NTESCustomNotificationDB.h"

#import "NTESSessionListViewController.h"//当前会话列表
#import "NTESContactViewController.h"//联系人通讯录

#import "LoginViewController.h"
#import "ZFBaseNavigationViewController.h"
#import "IMSearchFriendViewController.h"//添加好友

#import "ZFBaseNavigationViewController.h"
@interface ZFCInterpersonalCircleViewController () <SGPageTitleViewDelegate, SGPageContentViewDelegate,NIMSystemNotificationManagerDelegate,NIMConversationManagerDelegate>

@property (nonatomic, strong) SGPageTitleView   *pageTitleView;
@property (nonatomic, strong) SGPageContentView *pageContentView;


@end

@implementation ZFCInterpersonalCircleViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"人际圈";
    
    [self setupPageView];
    
    [[NIMSDK sharedSDK].systemNotificationManager addDelegate:self];
    [[NIMSDK sharedSDK].conversationManager addDelegate:self];
  
    
}
- (void)dealloc{
    [[NIMSDK sharedSDK].systemNotificationManager removeDelegate:self];
    [[NIMSDK sharedSDK].conversationManager removeDelegate:self];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


////设置右边按键（如果没有右边 可以不重写）
//-(UIButton*)set_rightButton
//{
//    NSString * saveStr = @"+";
//    UIButton *right_button = [[UIButton alloc]init];
//    [right_button setTitle:saveStr forState:UIControlStateNormal];
//    right_button.titleLabel.font=SYSTEMFONT(14);
//    [right_button setTitleColor:HEXCOLOR(0xfe6d6a)  forState:UIControlStateNormal];
//    right_button.titleLabel.textAlignment = NSTextAlignmentRight;
//    CGSize size = [saveStr sizeWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:SYSTEMFONT(14),NSFontAttributeName, nil]];
//    CGFloat width = size.width ;
//    right_button.frame =CGRectMake(0, 0, width+10, 22);
//    
//    return right_button;
//}
//
////设置右边事件
//-(void)right_button_event:(UIButton*)sender{
//    IMSearchFriendViewController * searchvc = [[ IMSearchFriendViewController alloc]init];
//    [self.navigationController pushViewController:searchvc animated:NO];
//    
//    
//}

- (void)setupPageView {
    
    NTESSessionListViewController  *messageVC       = [[NTESSessionListViewController alloc]init];
    NTESContactViewController *contactVC        = [[NTESContactViewController alloc]init];
    IMChatSessionViewController *friendVC       = [[IMChatSessionViewController alloc]init];

    NSArray *childArr = @[messageVC, contactVC, friendVC];
   
    /// pageContentView
    CGFloat contentViewHeight                = self.view.frame.size.height - 108;
    self.pageContentView                     = [[SGPageContentView alloc] initWithFrame:CGRectMake(0, 108, self.view.frame.size.width, contentViewHeight) parentVC:self childVCs:childArr];
    _pageContentView.delegatePageContentView = self;
    [self.view addSubview:_pageContentView];
    
    NSArray *titleArr = @[@"消息", @"通讯录", @"朋友圈"];
    /// pageTitleView
    self.pageTitleView = [SGPageTitleView pageTitleViewWithFrame:CGRectMake(0, 64, self.view.frame.size.width, 44) delegate:self titleNames:titleArr];
    [self.view addSubview:_pageTitleView];
    _pageTitleView.isTitleGradientEffect   = NO;
    _pageTitleView.indicatorLengthStyle    = SGIndicatorLengthStyleSpecial;
    _pageTitleView.indicatorScrollStyle    = SGIndicatorScrollStyleHalf;
    _pageTitleView.selectedIndex           = 0;
    _pageTitleView.isShowBottomSeparator   = NO;
    _pageTitleView.isNeedBounces           = NO;
    _pageTitleView.titleColorStateSelected = HEXCOLOR(0xfe6d6a);
    _pageTitleView.titleColorStateNormal   = HEXCOLOR(0x363636);
    _pageTitleView.indicatorColor          = [UIColor colorWithRed:0.996 green:0.427 blue:0.416 alpha:1.000];
    _pageTitleView.indicatorHeight         = 1.0;
    _pageTitleView.titleTextScaling        = 0.3;
}

- (void)pageTitleView:(SGPageTitleView *)pageTitleView selectedIndex:(NSInteger)selectedIndex
{
    [self.pageContentView setPageCententViewCurrentIndex:selectedIndex];
}

- (void)pageContentView:(SGPageContentView *)pageContentView progress:(CGFloat)progress originalIndex:(NSInteger)originalIndex targetIndex:(NSInteger)targetIndex {
    [self.pageTitleView setPageTitleViewWithProgress:progress originalIndex:originalIndex targetIndex:targetIndex];
}


-(void)viewWillAppear:(BOOL)animated
{
 
    if (BBUserDefault.isLogin == 1) {
        [self loginNIM];
        
    }else{
        
        NSLog(@"登录了");
        LoginViewController * logvc    = [ LoginViewController new];
        ZFBaseNavigationViewController * nav = [[ZFBaseNavigationViewController alloc]initWithRootViewController:logvc];
        
        [self presentViewController:nav animated:NO completion:^{
            
            [nav.navigationBar setBarTintColor:HEXCOLOR(0xfe6d6a)];
            [nav.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:HEXCOLOR(0xffffff),NSFontAttributeName:[UIFont systemFontOfSize:15.0]}];
        }];
    }
}


#pragma mark - 登陆网易云信
-(void)loginNIM
{
    
    //手动登录，error为登录错误信息，成功则为nil。
    //不要在登录完成的回调中直接获取 SDK 缓存数据，而应该在 同步完成的回调里获取数据 或者 监听相应的数据变动回调后获取
    [[[NIMSDK sharedSDK] loginManager] login:BBUserDefault.userPhoneNumber
                                       token:BBUserDefault.token
                                  completion:^(NSError *error) {
                                      if (error == nil)
                                      {
                                          NSLog(@" 已经 login success");
                              
                                      }
                                      else
                                      {
                                          NSLog(@"登录失败 --- %@",error);
                                      }
                                  }];
}

 



@end
