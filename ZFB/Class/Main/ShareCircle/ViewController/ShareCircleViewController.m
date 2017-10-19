//
//  ShareCircleViewController.m
//  ZFB
//
//  Created by  展富宝  on 2017/8/29.
//  Copyright © 2017年 com.zfb. All rights reserved.
//  分享圈

#import "ShareCircleViewController.h"
#import "ShareNewgoodsViewController.h"
#import "ShareGoodsViewController.h"
#import "ShareFriendStautusViewController.h"
#import "SGPagingView.h"//控制自控制器
#import "PPBadgeView.h"
@interface ShareCircleViewController () <SGPageTitleViewDelegate, SGPageContentViewDelegate>

@property (nonatomic, strong) SGPageTitleView   *pageTitleView;
@property (nonatomic, strong) SGPageContentView *pageContentView;

@end

@implementation ShareCircleViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"分享圈";
    [self setupPageView];
 
    
    [self.tabBarItem pp_addDotWithColor:[UIColor redColor]];
 
}

- (void)setupPageView {
    
    ShareNewgoodsViewController *newGoodsVC     = [[ShareNewgoodsViewController alloc]init];
    ShareGoodsViewController * goodsVC          = [[ShareGoodsViewController alloc]init];
//    ShareFriendStautusViewController * friendVC = [[ShareFriendStautusViewController alloc]init];
    NSArray *childArr = @[newGoodsVC, goodsVC];
    
    /// pageContentView
    CGFloat contentViewHeight                = self.view.frame.size.height - 108;
    self.pageContentView                     = [[SGPageContentView alloc] initWithFrame:CGRectMake(0, 108, self.view.frame.size.width, contentViewHeight) parentVC:self childVCs:childArr];
    _pageContentView.delegatePageContentView = self;
    [self.view addSubview:_pageContentView];
    
    NSArray *titleArr = @[@"新品推荐", @"好货共享"];
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
