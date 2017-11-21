//
//  MainStoreViewController.m
//  ZFB
//
//  Created by  展富宝  on 2017/11/21.
//  Copyright © 2017年 com.zfb. All rights reserved.
//
#define  headerH 130

#import "MainStoreViewController.h"
#import "StoreHomeViewController.h"//门店首页
#import "StoreAllgoodsViewController.h"//全部商品
#import "StoreRemonedViewController.h"//新品推荐

#import "MainStoreHeadView.h"
#import "MainStoreFooterView.h"

#import "JohnTopTitleView.h"
#import "XHStarRateView.h"

@interface MainStoreViewController ()<JohnTopTitleViewDelegate>
{
    NSString * _isCollect;//0没收藏 1,收藏
    NSString * _starLevel;//评价星星
    NSString * _storeName;
    NSString * _saleCount;//销售数量
    NSString * _coverUrl;//背景图
    NSString * _collectNumber;//背景图
}
@property (nonatomic,strong) StoreHomeViewController * vc1;
@property (nonatomic,strong) StoreAllgoodsViewController * vc2;
@property (nonatomic,strong) StoreRemonedViewController * vc3;
@property (nonatomic,strong) JohnTopTitleView *topTitleView;
@property (nonatomic,strong) MainStoreHeadView * headerView;
@property (nonatomic,strong) MainStoreFooterView * footerView;
@property (nonatomic, strong) XHStarRateView * wdStarView;
@property (nonatomic, strong) UIButton *collectButton;

@end

@implementation MainStoreViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.view.backgroundColor =  HEXCOLOR(0xf7f7f7);
    
    self.headerView = [[NSBundle mainBundle]loadNibNamed:@"MainStoreHeadView" owner:nil options:nil].lastObject;
    self.footerView = [[NSBundle mainBundle]loadNibNamed:@"MainStoreFooterView" owner:nil options:nil].lastObject;

    [self.view addSubview:self.headerView];
    [self.view addSubview:self.footerView];
    [self.view addSubview:self.topTitleView];
    
    _wdStarView = [[XHStarRateView alloc]initWithFrame:CGRectMake(0, 0, 120, 24) numberOfStars:5 rateStyle:WholeStar isAnination:NO delegate:self WithtouchEnable:NO];
    [ self.headerView.starView addSubview:_wdStarView];
    
    [self storePostRequest];
    [self collectionButton];
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
}


#pragma mark - CustomDelegate
- (void)johnScrollViewDidScroll:(CGFloat)scrollY{
    CGFloat headerViewY;
    if (scrollY > 0) {
        headerViewY = -scrollY ;
        if (scrollY > headerH) {
            headerViewY = -headerH ;
        }
    }else{
        headerViewY = 0;
    }
    self.headerView.frame = CGRectMake(0,headerViewY, KScreenW, headerH);
    self.topTitleView.frame = CGRectMake(0, CGRectGetMaxY(self.headerView.frame), KScreenW, KScreenH - CGRectGetMaxY(self.headerView.frame));
}


#pragma mark - JohnTopTitleViewDelegate
- (void)didSelectedPage:(NSInteger)page{
    self.headerView.frame = CGRectMake(0, 0, KScreenW, headerH);
    self.topTitleView.frame = CGRectMake(0, CGRectGetMaxY(self.headerView.frame), KScreenW, KScreenH - CGRectGetMaxY(self.headerView.frame));
    switch (page) {
        case 0:
        {
            [self.vc2.AcollectionView setContentOffset:CGPointMake(0, 0) animated:NO];
            [self.vc3.ScollectionView setContentOffset:CGPointMake(0, 0) animated:NO];
        }
            break;
        case 1:
        {
            [self.vc1.tableView setContentOffset:CGPointMake(0, 0) animated:NO];
            [self.vc3.ScollectionView setContentOffset:CGPointMake(0, 0) animated:NO];
            
        }
            break;
        default:
        {
            [self.vc1.tableView setContentOffset:CGPointMake(0, 0) animated:NO];
            [self.vc2.AcollectionView setContentOffset:CGPointMake(0, 0) animated:NO];
            
        }
            break;
    }
}

#pragma mark - Getter
- (JohnTopTitleView *)topTitleView{
    if (!_topTitleView) {
        _topTitleView = [[JohnTopTitleView alloc]initWithFrame:CGRectMake(0,CGRectGetMaxY(self.headerView.frame), KScreenW, KScreenH)];
        _topTitleView.titles = @[@"门店首页",@"全部商品",@"新品推荐"];
        [_topTitleView setupViewControllerWithFatherVC:self childVC:@[self.vc1,self.vc2,self.vc3]];
        _topTitleView.delegete = self;
    }
    return _topTitleView;
}

- (StoreHomeViewController *)vc1{
    if (!_vc1) {
        _vc1 = [[StoreHomeViewController alloc]init];
        __weak typeof(self) weakSelf = self;
        _vc1.storeId = _storeId;
        _vc1.DidScrollBlock = ^(CGFloat scrollY) {
            [weakSelf johnScrollViewDidScroll:scrollY];
        };
    }
    return _vc1;
}

- (StoreAllgoodsViewController *)vc2{
    if (!_vc2) {
        _vc2 = [[StoreAllgoodsViewController alloc]init];
        __weak typeof(self) weakSelf = self;
        _vc2.DidScrollBlock = ^(CGFloat scrollY) {
            [weakSelf johnScrollViewDidScroll:scrollY];
        };
    }
    return _vc2;
}

- (StoreRemonedViewController *)vc3{
    if (!_vc3) {
        _vc3 = [[StoreRemonedViewController alloc]init];
        __weak typeof(self) weakSelf = self;
        _vc3.DidScrollBlock = ^(CGFloat scrollY) {
            [weakSelf johnScrollViewDidScroll:scrollY];
        };
    }
    return _vc3;
}


-(void)viewWillAppear:(BOOL)animated
{
    [self settingNavBarBgName:@"nav64_gray"];

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
            
            self.headerView.lb_sale.text = _saleCount;
            self.headerView.lb_collect.text = _collectNumber;
            self.headerView.lb_storeName.text = _storeName;
            _wdStarView.currentScore = [_starLevel integerValue];
            [self.headerView.storeBackground sd_setImageWithURL:[NSURL URLWithString:_coverUrl] placeholderImage:nil];
            
        }
    } progress:^(NSProgress *progeress) {
    } failure:^(NSError *error) {
        NSLog(@"error=====%@",error);
        [self.view makeToast:@"网络错误" duration:2 position:@"center"];
    }];
    
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
