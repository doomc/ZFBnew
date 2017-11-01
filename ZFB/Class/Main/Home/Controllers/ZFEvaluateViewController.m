//
//  ZFEvaluateViewController.m
//  ZFB
//
//  Created by  展富宝  on 2017/5/19.
//  Copyright © 2017年 com.zfb. All rights reserved.
//   评论


#import "ZFEvaluateViewController.h"

#import "AppraiseModel.h"

#import "SGPagingView.h"//控制自控制器
#import "AllEvaluteViewController.h"
#import "GoodEvaluteViewController.h"
#import "HasPictureEvaViewController.h"
#import "BadEvaluteViewController.h"


@interface ZFEvaluateViewController ()<SGPageTitleViewDelegate, SGPageContentViewDelegate>
{
    
    NSString * _commentNum;
    NSString * _goodCommentNum;
    NSString * _lackCommentNum;
    NSString * _imgCommentNum;
    
}

@property (nonatomic, strong) SGPageTitleView *pageTitleView;
@property (nonatomic, strong) SGPageContentView *pageContentView;

@end

@implementation ZFEvaluateViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"评论";
    
    [self appriaseToPostRequestWithgoodsComment:@"" AndimgComment:@""];
  

    
}

- (void)setupPageView {
    
    AllEvaluteViewController *allVC = [[AllEvaluteViewController alloc]init];
    GoodEvaluteViewController *goodVC = [[GoodEvaluteViewController alloc]init];
    BadEvaluteViewController * badVC = [[BadEvaluteViewController alloc]init];
    HasPictureEvaViewController *picVC = [[HasPictureEvaViewController alloc]init];
    
    allVC.goodsId = goodVC.goodsId = badVC.goodsId = picVC.goodsId = _goodsId;
    
    NSArray *childArr = @[allVC, goodVC, badVC, picVC];
    
    /// pageContentView
    CGFloat contentViewHeight = self.view.frame.size.height - 44-64;
    self.pageContentView = [[SGPageContentView alloc] initWithFrame:CGRectMake(0, 44, KScreenW, contentViewHeight) parentVC:self childVCs:childArr];
    _pageContentView.delegatePageContentView = self;
    [self.view addSubview:_pageContentView];
    
    NSArray *titleArr   = @[_commentNum,_goodCommentNum,_lackCommentNum,_imgCommentNum];
    
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


#pragma mark - 评论的网络请求 getGoodsCommentInfo
-(void)appriaseToPostRequestWithgoodsComment:(NSString * )goodsComment AndimgComment:(NSString *)imgComment
{
    NSDictionary * parma = @{
                             @"goodsId":_goodsId,
                             @"goodsComment":goodsComment,
                             @"imgComment":imgComment,
                             @"pageSize":[NSNumber numberWithInteger:kPageCount],
                             @"pageIndex":[NSNumber numberWithInteger:self.currentPage],
                             
                             };
    
    [MENetWorkManager post:[NSString stringWithFormat:@"%@/getGoodsCommentInfo",zfb_baseUrl] params:parma success:^(id response) {
        
        if ([response[@"resultCode"] isEqualToString:@"0"]) {
            
            
            AppraiseModel * appraise = [AppraiseModel mj_objectWithKeyValues:response];
            
            _commentNum = [NSString stringWithFormat:@"全部(%ld)",appraise.data.goodsCommentList.commentNum];   //全部评论数
            _goodCommentNum = [NSString stringWithFormat:@"好评(%ld)",appraise.data.goodsCommentList.goodCommentNum ];  //好评数
            _lackCommentNum = [NSString stringWithFormat:@"差评(%ld)",appraise.data.goodsCommentList.lackCommentNum ];  //差评数
            _imgCommentNum = [NSString stringWithFormat:@"有图(%ld)",appraise.data.goodsCommentList.imgCommentNum ];    //有图数
          
            //设置title
            [self setupPageView];
        }
        [self setupPageView];

    } progress:^(NSProgress *progeress) {
    } failure:^(NSError *error) {
        
        [SVProgressHUD dismiss];
        NSLog(@"error=====%@",error);
        [self.view makeToast:@"网络错误" duration:2 position:@"center"];
    }];
    
}

@end
