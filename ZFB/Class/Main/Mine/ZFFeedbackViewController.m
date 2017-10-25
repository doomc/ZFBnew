//
//  ZFFeedbackViewController.m
//  ZFB
//
//  Created by  展富宝  on 2017/6/8.
//  Copyright © 2017年 com.zfb. All rights reserved.
//

#import "ZFFeedbackViewController.h"
#import "ZFCommitOpinionViewController.h"
#import "ZFMyOpinionViewController.h"
#import "SGPagingView.h"//控制自控制器

@interface ZFFeedbackViewController ()<SGPageTitleViewDelegate, SGPageContentViewDelegate>

@property (nonatomic, strong) SGPageTitleView *pageTitleView;
@property (nonatomic, strong) SGPageContentView *pageContentView;

@end

@implementation ZFFeedbackViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"意见反馈";
    self.automaticallyAdjustsScrollViewInsets = YES;

    [self setupPageView];
    
}
-(void)viewWillAppear:(BOOL)animated{

    [self settingNavBarBgName:@"nav64_gray"];

}
- (void)setupPageView {
    
    ZFCommitOpinionViewController *commitOpinionVC = [[ZFCommitOpinionViewController alloc]init];
    ZFMyOpinionViewController *myOpinionVC = [[ZFMyOpinionViewController alloc]init];

    
    NSArray *childArr = @[commitOpinionVC, myOpinionVC];
    /// pageContentView
    CGFloat contentViewHeight = self.view.frame.size.height - 108;
    self.pageContentView = [[SGPageContentView alloc] initWithFrame:CGRectMake(0, 44, self.view.frame.size.width, contentViewHeight) parentVC:self childVCs:childArr];
    _pageContentView.delegatePageContentView = self;
    [self.view addSubview:_pageContentView];
    
    NSArray *titleArr = @[@"提交意见", @"我的意见"];
    /// pageTitleView
    self.pageTitleView = [SGPageTitleView pageTitleViewWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 44) delegate:self titleNames:titleArr];
    [self.view addSubview:_pageTitleView];
    _pageTitleView.isTitleGradientEffect = NO;
    _pageTitleView.indicatorLengthStyle = SGIndicatorLengthStyleSpecial;
    _pageTitleView.indicatorScrollStyle = SGIndicatorScrollStyleHalf;
    _pageTitleView.selectedIndex = 0;
    _pageTitleView.isShowBottomSeparator = NO;
    _pageTitleView.isNeedBounces = NO;
    _pageTitleView.titleColorStateSelected = HEXCOLOR(0xf95a70);
    _pageTitleView.titleColorStateNormal = HEXCOLOR(0x7a7a7a);
    _pageTitleView.indicatorColor = HEXCOLOR(0xf95a70);
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
