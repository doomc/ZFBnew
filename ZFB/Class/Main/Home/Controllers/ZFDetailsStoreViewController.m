//
//  ZFDetailsStoreViewController.m
//  ZFB
//
//  Created by 熊维东 on 2017/9/16.
//  Copyright © 2017年 com.zfb. All rights reserved.
//

#import "ZFDetailsStoreViewController.h"
#import "DetailFindGoodsViewController.h"

//model
#import "CouponModel.h"
#import "DetailStoreModel.h"
//cell
#import "DetailStoreTitleCell.h"//头
#import "SectionCouponCell.h"//优惠券
#import "StoreListTableViewCell.h"
//view
#import "CouponTableView.h"


//计算cell高度
#define   itemHeight ((KScreenW -30-20 )*0.5 - 10 ) * 140/121 +36+20+15

@interface ZFDetailsStoreViewController ()<UITableViewDelegate,UITableViewDataSource,CouponTableViewDelegate,SDCycleScrollViewDelegate,StoreListTableViewCellDelegate,DetailStoreTitleCellDelegate>
{
    NSString * _storeName;
    NSString * _address;
    NSString * _contactPhone;
    NSString * _payType;//到店付 1.支持 0.不支持
    NSArray  * _imgArray;
    BOOL _isCalling;
    CGFloat   _itemHeight;
    NSInteger _isCollect;
}
@property (nonatomic , strong) UITableView    * tableView;
@property (nonatomic , strong) NSMutableArray * storeList;
@property (nonatomic , strong) NSMutableArray * couponList;
@property (nonatomic , strong) SDCycleScrollView * cycleScrollView;
@property (nonatomic , strong) CouponTableView *  couponTableView;
@property (nonatomic , strong) UIView          *  couponBackgroundView;
@property (nonatomic , strong) UIButton        *  collectButton;


@end

@implementation ZFDetailsStoreViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"门店详情";
    [self.view addSubview:self.tableView];

    [self creatUI];
    
    [self detailListStorePostRequst];

    [self cycleScrollViewWithImgArr:_imgArray];

    _isCalling = NO;//默认没打电话
    
    [self recommentPostRequst:@"0"];

 
}

#pragma mark - 懒加载
-(UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, KScreenW, KScreenH - 64 ) style:UITableViewStylePlain
                      ];
        _tableView.delegate       = self;
        _tableView.dataSource     = self;
        _tableView.separatorStyle = UITableViewCellSelectionStyleNone;
    }
    return _tableView;
}
-(NSMutableArray *)storeList
{
    if (!_storeList) {
        _storeList = [NSMutableArray array];
    }
    return _storeList;
}
-(NSMutableArray *)couponList{
    if (!_couponList) {
        _couponList = [NSMutableArray array];
    }
    return _couponList;
}
-(CouponTableView *)couponTableView
{
    if (!_couponTableView) {
        _couponTableView = [[CouponTableView alloc]initWithFrame:CGRectMake(0, 200, KScreenW, KScreenH -200) style:UITableViewStylePlain];
        _couponTableView.couponesList = self.couponList;
        _couponTableView.popDelegate = self;
    }
    return _couponTableView;
}

-(UIView *)couponBackgroundView
{
    if (!_couponBackgroundView) {
        _couponBackgroundView = [[UIView alloc]initWithFrame:self.view.bounds];
        _couponBackgroundView.backgroundColor = RGBA(0, 0, 0, 0.2);
        [_couponBackgroundView addSubview:self.couponTableView];
    }
    return _couponBackgroundView;
}

//创建UI
-(void)creatUI{
    
    [self.tableView registerNib:[UINib nibWithNibName:@"DetailStoreTitleCell" bundle:nil] forCellReuseIdentifier:@"DetailStoreTitleCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"SectionCouponCell" bundle:nil] forCellReuseIdentifier:@"SectionCouponCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"StoreListTableViewCell" bundle:nil] forCellReuseIdentifier:@"StoreListTableViewCell"];
    
    //收藏按钮
    _collectButton  =[ UIButton buttonWithType:UIButtonTypeCustom];
    _collectButton.frame = CGRectMake(0, 0, 20, 20);
    [_collectButton setBackgroundImage:[UIImage imageNamed:@"unCollected"] forState:UIControlStateNormal];
    [_collectButton setBackgroundImage:[UIImage imageNamed:@"Collected"] forState:UIControlStateSelected];
    [_collectButton addTarget:self action:@selector(didclickLove:) forControlEvents:UIControlEventTouchUpInside];
    
    //自定义button必须执行
    UIBarButtonItem *rightItem             = [[UIBarButtonItem alloc] initWithCustomView:_collectButton];
    self.navigationItem.rightBarButtonItem = rightItem;
 
    _imgArray = [ NSArray array];
}
/**
 初始化轮播
 */
-(void)cycleScrollViewWithImgArr:(NSArray*)imgArr;
{
    _cycleScrollView                      = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, KScreenW, 310*0.5) delegate:self placeholderImage:[UIImage imageNamed:@"placeholder"]];
    _cycleScrollView.pageControlAliment   = SDCycleScrollViewPageContolAlimentCenter;
    _cycleScrollView.imageURLStringsGroup = imgArr;
    
    //自定义dot 大小和图案
    _cycleScrollView.currentPageDotImage = [UIImage imageNamed:@"dot_normal"];
    _cycleScrollView.pageDotImage        = [UIImage imageNamed:@"dot_selected"];
    _cycleScrollView.currentPageDotColor = [UIColor whiteColor];// 自定义分页控件小圆标颜色
    _cycleScrollView.placeholderImage    = [UIImage imageNamed:@"placeholder"];
    self.tableView.tableHeaderView = _cycleScrollView;
    
}

#pragma mark - SDCycleScrollViewDelegate 轮播图代理
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index
{
    NSLog(@"---点击了第%ld张图片", (long)index);
    //  [self.navigationController pushViewController:[NSClassFromString(@"DemoVCWithXib") new] animated:YES];
}

#pragma mark - UITableViewDataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger numSection = 1;
 
    return numSection ;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0 ) {
        
        return 80;

    }
    else if (indexPath.section == 1)
    {
        if (![self isEmptyArray:self.couponList]) {
            return 44;
        }
        else{
            return 0;
        }
    }
    else{
        
        NSInteger cout =  self.storeList.count;
        if (cout % 2 == 0 ) {
            
            return (itemHeight +10) * cout/2 +10  ;
        }else{
            
            return (itemHeight +10) * (cout/2 +1) +10;
        }
     }
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 2) {
        return 44;
    }
    return 0;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView * headerView = nil;
    if (headerView == nil) {
        if (section == 2) {
            //全部商品section
            headerView =[[ UIView alloc]initWithFrame:CGRectMake(0, 0, KScreenW, 44)];
            headerView.backgroundColor = HEXCOLOR(0xffcccc);
            
            UIImageView * section_icon = [[UIImageView alloc]initWithFrame:CGRectMake(10, 7, 30, 30)];
            section_icon.image =[ UIImage imageNamed:@"more_icon"];
            [headerView addSubview:section_icon];
            
            UILabel * sectionTitle= [[ UILabel alloc]initWithFrame:CGRectMake(40, 0, 100, 44)];
            sectionTitle.text =@"全部商品";
            sectionTitle.font =[UIFont systemFontOfSize:14];
            sectionTitle.textAlignment = NSTextAlignmentLeft;
            sectionTitle.textColor = HEXCOLOR(0x363636);
            [headerView addSubview:sectionTitle];
        }
    }
    return headerView;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0 ) {
        
        DetailStoreTitleCell * titleCell = [self.tableView dequeueReusableCellWithIdentifier:@"DetailStoreTitleCell" forIndexPath:indexPath];
        titleCell.lb_storeName.text = _storeName;
        titleCell.lb_address.text = _address;
        titleCell.delegate = self;
        return titleCell;
        
    }else if (indexPath.section == 1)
    {
 
        NSInteger count = self.couponList.count;
        SectionCouponCell * couponCell = [self.tableView dequeueReusableCellWithIdentifier:@"SectionCouponCell" forIndexPath:indexPath];
        

        
        if (![self isEmptyArray:self.couponList]) {
            //关键字
            couponCell.lb_title.text = [NSString stringWithFormat:@"您有 %ld 张待领取的优惠券",count];
            couponCell.lb_title.keywords      = [NSString stringWithFormat:@"%ld",count];
            couponCell.lb_title.keywordsColor = HEXCOLOR(0xfe6d6a);
            couponCell.lb_title.keywordsFont  = [UIFont systemFontOfSize:18];
            ///必须设置计算宽高
            CGRect dealNumh              = [couponCell.lb_title getLableHeightWithMaxWidth:300];
            couponCell.lb_title.frame = CGRectMake(15, 10, dealNumh.size.width, dealNumh.size.height);
            return couponCell;

        } else{
            couponCell.hidden = YES;
            return couponCell;
        }
    }
    else{
        StoreListTableViewCell * listCell = [self.tableView dequeueReusableCellWithIdentifier:@"StoreListTableViewCell" forIndexPath:indexPath];
        listCell.storeListArray = self.storeList;
        listCell.collectionDelegate = self;
        [listCell reloadCollectionView];

        return listCell;
        
    }
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"section == %ld   ,row == %ld",indexPath.section,indexPath.row);
    if (indexPath.section == 1){//点击优惠券
        
        //列表请求到了才能添加视图
        if (![self isEmptyArray:self.couponList]) {
            
            [self.tableView bringSubviewToFront:self.couponBackgroundView];
            [self.view addSubview:self.couponBackgroundView];
        }
    }
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
    ///是否收藏	1.收藏成功 0.取消收藏
    if (_isCollect == 1) {
        
        [self cancelCollectedPostRequest];//取消收藏
        
    }else{
        
        [self addCollectedPostRequest]; //添加收藏
    }
    
}
#pragma mark - 判断是否收藏了
-(void)iscollect
{
    if (_isCollect == 1) {///是否收藏	1.收藏 0.不
        
        [_collectButton setBackgroundImage:[UIImage imageNamed:@"Collected"] forState:UIControlStateNormal];
        
    }else
    {
        [_collectButton setBackgroundImage:[UIImage imageNamed:@"unCollected"] forState:UIControlStateNormal];
    }
}

#pragma mark - <CouponTableViewDelegate> 优惠券代理
/**
 *  关闭弹框
 */
-(void)didClickCloseCouponView
{
    [self.couponBackgroundView removeFromSuperview];
}

/**
 获取到当前的优惠券信息
 
 @param indexRow 下标
 @param couponId id
 @param result 返回值
 */
-(void)selectCouponWithIndex:(NSInteger)indexRow AndCouponId :(NSString *)couponId withResult:(NSString *)result
{
    //领取优惠券  接口
    [self getCouponesPostRequst:couponId];
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
    [self.couponBackgroundView removeFromSuperview];
    
}


#pragma mark - StoreListTableViewCellDelegate 集合视图的代理
-(void)didClickCollectionCellGoodId:(NSString *)goodId withIndexItem:(NSInteger )indexItem
{
    DetailCmgoodslist * goodlist = self.storeList[indexItem];
    DetailFindGoodsViewController * goodVC = [DetailFindGoodsViewController new];
    goodVC.goodsId = [NSString stringWithFormat:@"%ld",goodlist.goodsId];
    [self.navigationController pushViewController:goodVC animated:NO];
}

#pragma mark - 门店详情网络商品列表 getGoodsDetailsInfo用于门店详情的接口
-(void)detailListStorePostRequst
{
    if (BBUserDefault.cmUserId == nil || BBUserDefault.cmUserId == NULL ||[BBUserDefault.cmUserId  isKindOfClass:[NSNull class]]) {
        BBUserDefault.cmUserId = @"";
    }
    NSDictionary * parma = @{
                             
                             @"storeId":_storeId,//门店id
                             @"userId":BBUserDefault.cmUserId,//门店id
                             };
    [SVProgressHUD show];
    [MENetWorkManager post:[NSString stringWithFormat:@"%@/getCmStoreDetailsInfo",zfb_baseUrl] params:parma success:^(id response) {
        
        if ( [response[@"resultCode"] intValue] == 0) {
            
            if (self.storeList.count > 0) {
                
                [self.storeList removeAllObjects];
                
            }
            DetailStoreModel * detailModel = [DetailStoreModel  mj_objectWithKeyValues:response];
            for (DetailCmgoodslist * goodlist in detailModel.cmGoodsList) {
                [self.storeList addObject:goodlist];
            }
//            NSLog(@"门店详情         = storeListArray = %@",  self.storeList);
            //是否收藏
            _isCollect    = detailModel.cmStoreDetailsList.isCollect;
            _storeName    = detailModel.cmStoreDetailsList.storeName;
            _address      = detailModel.cmStoreDetailsList.address;
            _contactPhone = detailModel.cmStoreDetailsList.contactPhone;
            _payType      = [NSString stringWithFormat:@"%ld", detailModel.cmStoreDetailsList.payType];
            _imgArray             = [detailModel.cmStoreDetailsList.attachUrl componentsSeparatedByString:@","];
         
            [self iscollect];
            
            [self cycleScrollViewWithImgArr:_imgArray];
            NSLog(@"图片地址        = %@",_imgArray);
            [SVProgressHUD dismiss];
        }
        [self.tableView reloadData];
        
        
    } progress:^(NSProgress *progeress) {
        
    } failure:^(NSError *error) {
        [self.view makeToast:@"网络错误" duration:2 position:@"center"];
        NSLog(@"error=====%@",error);
        [SVProgressHUD dismiss];
        
    }];
    
}

#pragma mark - 点击领取优惠券    recomment/receiveCoupon
-(void)getCouponesPostRequst:(NSString *)couponId
{
    NSDictionary * parma = @{
                             
                             @"couponId":couponId,
                             @"userId":BBUserDefault.cmUserId,
                             };
    [SVProgressHUD show];
    [MENetWorkManager post:[zfb_baseUrl stringByAppendingString:@"/recomment/receiveCoupon"] params:parma success:^(id response) {
        if ([response[@"resultCode"] isEqualToString:@"0"] ) {
            
            [self.view makeToast:@"领取优惠券成功" duration:2 position:@"center"];
            //领取成功后移除
            [self.couponBackgroundView removeFromSuperview];

            [SVProgressHUD dismiss];
        }
        
    } progress:^(NSProgress *progeress) {
        
    } failure:^(NSError *error) {
        
        [SVProgressHUD dismiss];
        NSLog(@"error=====%@",error);
        [self.view makeToast:@"网络错误" duration:2 position:@"center"];
    }];
    
}

#pragma mark - 获取用户优惠券列表   recomment/getUserCouponList
-(void)recommentPostRequst:(NSString *)status
{
    //idType	number	0 平台 1 商家 2 商品 3 所有	否
    //resultId	number	平台编号/商店编号/商品编号	是
    // userId	number	领优惠券用户编号	否
    // status	number	0 未领取 1 未使用 2 已使用 3 已失效	否
    
    NSDictionary * parma = @{
                             @"idType":@"3",
                             @"resultId":@"",
                             @"userId":BBUserDefault.cmUserId,
                             @"status":status,
                             @"pageIndex":[NSNumber numberWithInteger:self.currentPage],
                             @"pageSize":@"1000",
                             };
    [SVProgressHUD show];
    [MENetWorkManager post:[zfb_baseUrl stringByAppendingString:@"/recomment/getUserCouponList"] params:parma success:^(id response) {
        if ([response[@"resultCode"] isEqualToString:@"0"] ) {
            
            if (self.couponList.count > 0) {
                [self.couponList removeAllObjects];
            }
            CouponModel * coupon = [CouponModel mj_objectWithKeyValues:response];
            for (Couponlist * list in coupon.couponList) {
                [self.couponList addObject:list];
            }
            
            [self.couponTableView reloadData];
            [self.tableView reloadData];
            [SVProgressHUD dismiss];
        }
        
    } progress:^(NSProgress *progeress) {
    } failure:^(NSError *error) {
        [SVProgressHUD dismiss];
        NSLog(@"error=====%@",error);
        [self.view makeToast:@"网络错误" duration:2 position:@"center"];
    }];
    
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
            
            _isCollect = 1;
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
    NSDictionary * parma = @{
                             
                             @"cmUserId":BBUserDefault.cmUserId,
                             @"goodId":_storeId,
                             @"collectType":@"2",//1收藏商品 2收藏门店
                             };
    
    [MENetWorkManager post:[NSString stringWithFormat:@"%@/cancalGoodsCollect",zfb_baseUrl] params:parma success:^(id response) {
        
        if ([response[@"resultCode"] isEqualToString:@"0"]) {
        
            _isCollect = 0;
            [self iscollect];
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
