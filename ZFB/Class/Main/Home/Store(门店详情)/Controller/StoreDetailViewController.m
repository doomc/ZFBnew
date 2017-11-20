//
//  StoreDetailViewController.m
//  ZFB
//
//  Created by  展富宝  on 2017/11/14.
//  Copyright © 2017年 com.zfb. All rights reserved.
//

#import "StoreDetailViewController.h"
#import "StoreHomeViewController.h"//门店首页
#import "StoreAllgoodsViewController.h"//全部商品
#import "StoreRemonedViewController.h"//新品推荐

#import "XHStarRateView.h"
#import "SGPageTitleView.h"
#import "SGPageContentView.h"

@interface StoreDetailViewController ()<SGPageTitleViewDelegate, SGPageContentViewDelegate>
{
    BOOL _isCalling;
    NSString * _isCollect;//0没收藏 1,收藏
    NSString * _starLevel;//评价星星
    NSString * _storeName;
    NSString * _saleCount;//销售数量
    NSString * _coverUrl;//背景图
    NSString * _collectNumber;//背景图

    NSString * _contactPhone;

    

}
@property (nonatomic, strong) SGPageTitleView *pageTitleView;
@property (nonatomic, strong) SGPageContentView *pageContentView;
@property (nonatomic, strong) XHStarRateView * wdStarView;
@property (nonatomic, strong) UIButton *collectButton;

@end

@implementation StoreDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    _isCalling = NO;//默认没打电话
    
    [self setupPageView];
    [self collectionButton];
    [self storePostRequest];

}
-(void)collectionButton
{
    //收藏按钮
    _collectButton  =[ UIButton buttonWithType:UIButtonTypeCustom];
    _collectButton.frame = CGRectMake(0, 0, 20, 20);
    [_collectButton setBackgroundImage:[UIImage imageNamed:@"unCollected"] forState:UIControlStateNormal];
    [_collectButton setBackgroundImage:[UIImage imageNamed:@"Collected"] forState:UIControlStateSelected];
    [_collectButton addTarget:self action:@selector(didclickLove:) forControlEvents:UIControlEventTouchUpInside];
    
    //自定义button必须执行
    UIBarButtonItem *rightItem             = [[UIBarButtonItem alloc] initWithCustomView:_collectButton];
    self.navigationItem.rightBarButtonItem = rightItem;
    
    
    _wdStarView = [[XHStarRateView alloc]initWithFrame:self.starView.frame numberOfStars:5 rateStyle:WholeStar isAnination:NO delegate:self WithtouchEnable:NO];
    [self.starView addSubview:_wdStarView];
}


- (void)setupPageView {
    
    StoreHomeViewController * storeVC1 = [[StoreHomeViewController alloc]init];
    StoreAllgoodsViewController * storeVC2 = [[StoreAllgoodsViewController alloc]init];
    StoreRemonedViewController * storeVC3 = [[StoreRemonedViewController alloc]init];
    storeVC1.storeId = _storeId;
    
    NSArray *childs = @[storeVC1, storeVC2,storeVC3];
    /// pageContentView
    CGFloat contentViewHeight = self.view.frame.size.height - 130 - 44 - 64 -49;
    self.pageContentView = [[SGPageContentView alloc] initWithFrame:CGRectMake(0, 130+44, self.view.frame.size.width, contentViewHeight) parentVC:self childVCs:childs];
    _pageContentView.delegatePageContentView = self;
    [self.view addSubview:_pageContentView];
    
    NSArray * titles = @[@"门店首页",@"全部商品",@"新品推荐"];
    /// pageTitleView
    self.pageTitleView = [SGPageTitleView pageTitleViewWithFrame:CGRectMake(0, 130, self.view.frame.size.width, 44) delegate:self titleNames:titles];
    [self.view addSubview:_pageTitleView];
    _pageTitleView.isTitleGradientEffect = NO;
    _pageTitleView.indicatorLengthStyle = SGIndicatorLengthStyleSpecial;
    _pageTitleView.indicatorScrollStyle = SGIndicatorScrollStyleHalf;
    _pageTitleView.selectedIndex = 0;
    _pageTitleView.isShowBottomSeparator = YES;
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

#pragma mark - <DetailStoreTitleCellDelegate> 拨打电话代理
//拨打电话
-(void)callingBack
{
    if (_isCalling == YES) {
        return;
    }
    _isCalling = YES;
    NSMutableString * str= [[NSMutableString alloc] initWithFormat:@"telprompt://%@",_contactPhone];
    NSDictionary * dic = @{@"":@""} ;
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str] options:dic completionHandler:^(BOOL success) {
        _isCalling = NO;
    }];
    
}
/**
 点爱心
 
 @param sender 收藏/取消收藏
 */
-(void )didclickLove:(UIButton *)sender
{
    sender.selected = !sender.selected ;
    ///是否收藏    1.收藏成功 0.取消收藏
    if ([_isCollect isEqualToString:@"1"]) {
        
        [self cancelCollectedPostRequest];//取消收藏
        
    }else{
        [self addCollectedPostRequest]; //添加收藏
    }
}
#pragma mark - 判断是否收藏了
-(void)iscollect
{
    if ([_isCollect isEqualToString:@"1"] ) {///是否收藏    1.收藏 0.不
        [_collectButton setBackgroundImage:[UIImage imageNamed:@"Collected"] forState:UIControlStateNormal];
    }else
    {
        [_collectButton setBackgroundImage:[UIImage imageNamed:@"unCollected"] forState:UIControlStateNormal];
    }
}
#pragma mark - 添加收藏 getKeepGoodInfo
-(void)addCollectedPostRequest
{
    NSDictionary * parma = @{
                             @"cmUserId":BBUserDefault.cmUserId,
                             @"goodId":_storeId,//1收藏商品 2收藏门店
                             @"goodName":_storeName,//门店名称
                             @"collectType":@"2",//1收藏商品 2收藏门店
                             
                             };
    [MENetWorkManager post:[NSString stringWithFormat:@"%@/getKeepGoodInfo",zfb_baseUrl] params:parma success:^(id response) {
        if ([response[@"resultCode"] isEqualToString:@"0"]) {
            
            _isCollect = @"1";
            [self iscollect];
        }
    } progress:^(NSProgress *progeress) {
    } failure:^(NSError *error) {
        NSLog(@"error=====%@",error);
        [self.view makeToast:@"网络错误" duration:2 position:@"center"];
    }];
    
}
#pragma mark - 取消收藏 cancalGoodsCollect
-(void)cancelCollectedPostRequest
{
    if (BBUserDefault.cmUserId == nil) {
        BBUserDefault.cmUserId = @"";
    }
    NSDictionary * parma = @{
                             @"cmUserId":BBUserDefault.cmUserId,
                             @"goodId":_storeId,
                             @"collectType":@"2",//1收藏商品 2收藏门店
                             };
    
    [MENetWorkManager post:[NSString stringWithFormat:@"%@/cancalGoodsCollect",zfb_baseUrl] params:parma success:^(id response) {
        
        if ([response[@"resultCode"] isEqualToString:@"0"]) {
            
            _isCollect = @"0";
            [self iscollect];
        }
    } progress:^(NSProgress *progeress) {
        
    } failure:^(NSError *error) {
        
        NSLog(@"error=====%@",error);
        [self.view makeToast:@"网络错误" duration:2 position:@"center"];
    }];
    
}
#pragma mark - 门店详情
-(void)storePostRequest
{
    if (BBUserDefault.cmUserId == nil) {
        BBUserDefault.cmUserId = @"";
    }
    NSDictionary * parma = @{
                             @"userId":BBUserDefault.cmUserId,
                             @"storeId":_storeId,
                             };
    [MENetWorkManager post:[NSString stringWithFormat:@"%@/getStoreInfoApp",zfb_baseUrl] params:parma success:^(id response) {
        if ([response[@"resultCode"] isEqualToString:@"0"]) {
            
            _storeName = response[@"data"][@"storeName"];
            _coverUrl  = response[@"data"][@"coverUrl"];
            _collectNumber  = response[@"data"][@"collectNumber"];
            _saleCount  = response[@"data"][@"saleCount"];
            _isCollect = [NSString stringWithFormat:@"%@",response[@"data"][@"isCollect"]];
            _starLevel = [NSString stringWithFormat:@"%@",response[@"data"][@"starLevel"]];
            
            self.lb_sale.text = _saleCount;
            self.lb_collect.text = _collectNumber;
            self.lb_storeName.text = _storeName;
            _wdStarView.currentScore = [_starLevel integerValue];
            [self.storeBackground sd_setImageWithURL:[NSURL URLWithString:_isCollect] placeholderImage:nil];

        }
    } progress:^(NSProgress *progeress) {
    } failure:^(NSError *error) {
        NSLog(@"error=====%@",error);
        [self.view makeToast:@"网络错误" duration:2 position:@"center"];
    }];
    
}

-(void)viewWillAppear:(BOOL)animated{
    [self settingNavBarBgName:@"nav64_gray"];
    
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
