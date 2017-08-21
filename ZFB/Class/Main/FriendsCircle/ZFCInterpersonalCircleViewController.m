//
//  ZFCInterpersonalCircleViewController.m
//  ZFB
//
//  Created by  展富宝  on 2017/5/11.
//  Copyright © 2017年 com.zfb. All rights reserved.
//  ****人际圈

#import "ZFCInterpersonalCircleViewController.h"
#import "SGPagingView.h"//控制自控制器
#import "IMContactListViewController.h"//联系人通讯录
#import "IMFriendsCircleViewController.h"//朋友圈
#import "IMCurrentMessageListViewController.h"//当前会话列表
@interface ZFCInterpersonalCircleViewController () <SGPageTitleViewDelegate, SGPageContentViewDelegate>
@property (nonatomic, strong) SGPageTitleView   *pageTitleView;
@property (nonatomic, strong) SGPageContentView *pageContentView;

@end

@implementation ZFCInterpersonalCircleViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"人际圈";
    
    [self setupPageView];
    
    
}

- (void)setupPageView {
    
    IMCurrentMessageListViewController *messageVC = [[IMCurrentMessageListViewController alloc]init];
    IMContactListViewController *contactVC        = [[IMContactListViewController alloc]init];
    IMFriendsCircleViewController *friendVC       = [[IMFriendsCircleViewController alloc]init];

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


@end
