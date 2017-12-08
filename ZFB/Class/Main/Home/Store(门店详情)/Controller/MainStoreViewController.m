//
//  MainStoreViewController.m
//  ZFB
//
//  Created by  展富宝  on 2017/11/21.
//  Copyright © 2017年 com.zfb. All rights reserved.
//
#define headerH 135

#import "MainStoreViewController.h"
#import "StoreHomeViewController.h"//门店首页
#import "StoreAllgoodsViewController.h"//全部商品
#import "StoreRemonedViewController.h"//新品推荐
#import "StoreInfoViewController.h"//门店信息
#import "StoreSearchViewController.h"//搜索页面
#import "ZFBaseNavigationViewController.h"

//view
#import "MainStoreHeadView.h"
#import "MainStoreFooterView.h"
#import "JohnTopTitleView.h"
#import "XHStarRateView.h"


//tool
#import "TJMapNavigationService.h"//导航

//网易云信
#import "NTESSessionViewController.h"

@interface MainStoreViewController ()<JohnTopTitleViewDelegate,MainStoreFooterViewDelegate,NIMSystemNotificationManagerDelegate,NIMUserManagerDelegate,UISearchBarDelegate,UITextFieldDelegate>
{
    NSString * _isCollect;//0没收藏 1,收藏
    NSString * _starLevel;//评价星星
    NSString * _storeName;
    NSString * _goodsCount;
    NSString * _saleCount;//销售数量
    NSString * _coverUrl;//背景图
    NSString * _collectNumber;
    NSString * _userAccId;//网易云信
    NSString * _creatTime;

    NSString * _longitude;
    NSString * _latitude;
    NSString * _address;
}
@property (nonatomic,strong) StoreHomeViewController * vc1;
@property (nonatomic,strong) StoreAllgoodsViewController * vc2;
@property (nonatomic,strong) StoreRemonedViewController * vc3;
@property (nonatomic,strong) JohnTopTitleView *topTitleView;
@property (nonatomic,strong) MainStoreHeadView * headerView;
@property (nonatomic,strong) MainStoreFooterView * footerView;
@property (nonatomic, strong) XHStarRateView * wdStarView;
@property (nonatomic, strong) UIButton *collectButton;
@property (nonatomic, strong) UIView *titleView;

@end

@implementation MainStoreViewController
-(UIView *)titleView
{
    _titleView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, KScreenW -120, 36)];
    _titleView.backgroundColor = RGB(238, 238, 238);
    _titleView.layer.cornerRadius = 6;
    _titleView.layer.masksToBounds = YES;

    UIImageView * imageView =[ UIImageView new];
    imageView.image = [UIImage imageNamed:@"search2"];
    imageView.frame = CGRectMake(10, 9, 18, 18);
    [_titleView addSubview:imageView];
    
    UITextField * searchtext = [[UITextField alloc]initWithFrame:CGRectMake(40, 0, _titleView.size.width -50 -50, 36)];
    searchtext.font = SYSTEMFONT(14);
    searchtext.backgroundColor = RGB(238, 238, 238);
    searchtext.placeholder = @"搜索店铺内商品";
    searchtext.delegate = self;
    [_titleView addSubview:searchtext];
    return _titleView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.view.backgroundColor =   HEXCOLOR(0xf7f7f7);
    self.navigationItem.titleView = self.titleView;

 
    self.headerView = [[MainStoreHeadView alloc]initWithHeaderViewFrame:CGRectMake(0, 0, KScreenW, headerH)] ;
    
    if (kDevice_Is_iPhoneX) {
        self.footerView = [[ MainStoreFooterView alloc]initWithFooterViewFrame:CGRectMake(0, KScreenH -headerH, KScreenW,  49)];
    }else{
        self.footerView = [[ MainStoreFooterView alloc]initWithFooterViewFrame:CGRectMake(0, KScreenH -headerH +20, KScreenW,  49)];
    }
    self.footerView.delegate = self;
    [self.view addSubview:self.headerView];
    [self.topTitleView addSubview:self.footerView];
    [self.view addSubview:self.topTitleView];

    _wdStarView = [[XHStarRateView alloc]initWithFrame:CGRectMake(0, 0, 100, 18) numberOfStars:5 rateStyle:WholeStar isAnination:NO delegate:self WithtouchEnable:NO littleStar:@"1"];//小星星
    [ self.headerView.starView addSubview:_wdStarView];
    
    [self storePostRequest];
    [self collectionButton];
    
    [[NIMSDK sharedSDK].userManager addDelegate:self];
    [[NIMSDK sharedSDK].systemNotificationManager addDelegate:self];
    
}

- (void)dealloc
{
    [[[NIMSDK sharedSDK] systemNotificationManager] removeDelegate:self];
    [[NIMSDK sharedSDK].userManager removeDelegate:self];
}
-(void)collectionButton
{
    //收藏按钮
    _collectButton  =[ UIButton buttonWithType:UIButtonTypeCustom];
    _collectButton.frame = CGRectMake(0, 0, 20, 20);
    [_collectButton setBackgroundImage:[UIImage imageNamed:@"like"] forState:UIControlStateNormal];
    [_collectButton setBackgroundImage:[UIImage imageNamed:@"like2"] forState:UIControlStateSelected];
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
    self.topTitleView.frame = CGRectMake(0, CGRectGetMaxY(self.headerView.frame), KScreenW, KScreenH  - 49);
}


#pragma mark - JohnTopTitleViewDelegate
- (void)didSelectedPage:(NSInteger)page{
    self.headerView.frame = CGRectMake(0, 0, KScreenW, headerH);
    self.topTitleView.frame = CGRectMake(0, CGRectGetMaxY(self.headerView.frame), KScreenW, KScreenH  - 49);
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
        _topTitleView = [[JohnTopTitleView alloc]initWithFrame:CGRectMake(0,CGRectGetMaxY(self.headerView.frame), KScreenW, KScreenH  - 49)];
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
        _vc2.storeId = _storeId;
        _vc2.DidScrollBlock = ^(CGFloat scrollY) {
            [weakSelf johnScrollViewDidScroll:scrollY];
        };
    }
    return _vc2;
}

- (StoreRemonedViewController *)vc3{
    if (!_vc3) {
        _vc3 = [[StoreRemonedViewController alloc]init];
        _vc3.storeId = _storeId;
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
        [_collectButton setBackgroundImage:[UIImage imageNamed:@"like2"] forState:UIControlStateNormal];
    }else
    {
        [_collectButton setBackgroundImage:[UIImage imageNamed:@"like"] forState:UIControlStateNormal];
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
            _creatTime = response[@"data"][@"createTime"];
            _goodsCount = response[@"data"][@"goodsCount"];
            NSString *userImgAttachUrl = response[@"data"][@"userImgAttachUrl"];
            
            CGFloat longf  = [[NSString stringWithFormat:@"%@",response[@"data"][@"longitude"]] doubleValue];
            CGFloat latf  = [[NSString stringWithFormat:@"%@",response[@"data"][@"latitude"]] doubleValue];
            
            _latitude = [NSString stringWithFormat:@"%.6f",latf];
            _longitude = [NSString stringWithFormat:@"%.6f",longf];
            _address = response[@"data"][@"address"];
            
            self.headerView.lb_sale.text = _saleCount;
            self.headerView.lb_collect.text = _collectNumber;
            self.headerView.lb_storeName.text = _storeName;
            
            _wdStarView.currentScore = [_starLevel integerValue];
            [self.headerView.storeBackground sd_setImageWithURL:[NSURL URLWithString:_coverUrl] placeholderImage:nil];
            [self.headerView.storeLogo sd_setImageWithURL:[NSURL URLWithString:userImgAttachUrl] placeholderImage:[UIImage imageNamed:@"head"]];

        }
    } progress:^(NSProgress *progeress) {
    } failure:^(NSError *error) {
        NSLog(@"error=====%@",error);
        [self.view makeToast:@"网络错误" duration:2 position:@"center"];
    }];
    
}

#pragma mark -MainStoreFooterViewDelegate footer代理
//联系卖家
-(void)didClickContactStore
{
    NSLog(@"联系卖家");
    NIMSession *session = [NIMSession session:_userAccId type:NIMSessionTypeP2P];
    NTESSessionViewController *vc = [[NTESSessionViewController alloc] initWithSession:session];
    vc.isVipStore = YES;
    vc.storeId = _storeId;
    vc.storeName = _storeName;
    [self.navigationController pushViewController:vc animated:NO];
}
//店铺信息
-(void)didClickStoreInfo
{
    StoreInfoViewController * infoVC = [StoreInfoViewController  new];
    infoVC.starNum = [_starLevel integerValue];
    infoVC.collectNum = _collectNumber;
    infoVC.info = [NSString stringWithFormat:@"创建时间:%@ | %@ |",_creatTime,_address];
    infoVC.storeName = _storeName;
    infoVC.imageUrl = _coverUrl;
    infoVC.salesNum = _saleCount;
    infoVC.goodsNum = _goodsCount;
    [self.navigationController pushViewController:infoVC animated:NO];

}
#pragma mark - 到这去 唤醒地图
//到店铺导航
-(void)didClickMapNavgation
{    //当前位置导航到指定地
    CGFloat endLat       = [_latitude doubleValue];
    CGFloat endLot       = [_longitude doubleValue] ;
    NSString *endAddress = _address;
    
    CGFloat startLat = [BBUserDefault.latitude doubleValue];
    CGFloat startLot = [BBUserDefault.longitude doubleValue] ;
    
    TJMapNavigationService *mapNavigationService = [[TJMapNavigationService alloc] initWithStartLatitude:startLat startLongitude:startLot endLatitude:endLat endLongitude:endLot endAddress:endAddress locationType:LocationType_Mars];
    [mapNavigationService showAlert];
    
}

#pragma mark - 搜索跳转
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    StoreSearchViewController  * searchVC = [StoreSearchViewController new];
    searchVC.storeId = _storeId;
    [self.navigationController pushViewController:searchVC animated:NO];
//    ZFBaseNavigationViewController * nav = [[ZFBaseNavigationViewController alloc]initWithRootViewController:searchVC];
//    [self.navigationController presentViewController:nav animated:NO completion:^{
//
//    }];
    
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
