//
//  StoreHomeViewController.m
//  ZFB
//
//  Created by  展富宝  on 2017/11/20.
//  Copyright © 2017年 com.zfb. All rights reserved.
//  门店首页

#define  cellHeight  66 + KScreenW -20
#import "StoreHomeViewController.h"
#import "GoodsDeltailViewController.h"

//cell
#import "StoreHomeCell.h"
#import "StoreHomeHeaderCell.h"
#import "StoreCouponTableCell.h"
//view
#import "CQPlaceholderView.h"
//model
#import "CouponModel.h"
#import "StoreDetailHomeModel.h"

@interface StoreHomeViewController () <UITableViewDelegate,UITableViewDataSource,StoreCouponTableCellDelegate,StoreHomeCellDelegate>

@property (nonatomic , strong) NSMutableArray * dataArray;
@property (nonatomic , strong) NSMutableArray * couponList;
@property (nonatomic , strong) CQPlaceholderView * placeholderView;


@end

@implementation StoreHomeViewController


-(NSMutableArray *)couponList{
    if (!_couponList) {
        _couponList = [NSMutableArray array];
    }
    return _couponList;
}


-(NSMutableArray *)dataArray{
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}
#pragma mark - tableView
-(UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, KScreenW, KScreenH -64 -40 -49 )];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = HEXCOLOR(0xf7f7f7);
        _tableView.estimatedRowHeight = 0;
        _tableView.estimatedSectionFooterHeight = 0;
        _tableView.estimatedSectionHeaderHeight = 0;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        
    }
    return _tableView;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.view addSubview:self.tableView];
    self.zfb_tableView  = self.tableView;

    [self.tableView registerNib:[UINib nibWithNibName:@"StoreHomeCell" bundle:nil] forCellReuseIdentifier:@"StoreHomeCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"StoreCouponTableCell" bundle:nil] forCellReuseIdentifier:@"StoreCouponTableCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"StoreHomeHeaderCell" bundle:nil] forCellReuseIdentifier:@"StoreHomeHeaderCell"];
    
    [self storeListPostRequest];
    [self setupRefresh];

}
-(void)headerRefresh
{
    [super headerRefresh];
    [self storeListPostRequest];
    [self recommentPostRequst:@"0"];

}
-(void)footerRefresh
{
    [super footerRefresh];
    [self storeListPostRequest];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 1;
    }
    else{
        return self.dataArray.count;
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        if (![self isEmptyArray:self.couponList]) {
            return 91;
        }
        else{
            return 0;
        }
    }else
    {
        return cellHeight;
    }
  
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return 0.001;
    }else{
        return 98;
    }
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView * headView  = nil;
    if (nil == headView) {
        if (section == 1) {
            StoreHomeHeaderCell * headCell = [self.tableView dequeueReusableCellWithIdentifier:@"StoreHomeHeaderCell"];
            headView = headCell;
        }
    }
    return headView;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0){
        StoreCouponTableCell * couponCell = [self.tableView dequeueReusableCellWithIdentifier:@"StoreCouponTableCell" forIndexPath:indexPath];
        if (![self isEmptyArray:self.couponList]) {
            //优惠券不为空
            couponCell.couponArray = self.couponList;
            couponCell.delegate = self;
            [couponCell reload_CollectionView];
        }else {
            couponCell.hidden = YES;
        }
        return couponCell;
    }else{
        StoreHomeCell * storeCell = [self.tableView dequeueReusableCellWithIdentifier:@"StoreHomeCell" forIndexPath:indexPath];
        GoodsExtendList * goodslist = self.dataArray[indexPath.row];
        storeCell.goodslist = goodslist;
        storeCell.delegate = self;
        storeCell.indexPath = indexPath;
        return storeCell;
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    GoodsDeltailViewController * goodVC = [ GoodsDeltailViewController new];
    if ( self.dataArray.count > 0) {
        GoodsExtendList * goodslist = self.dataArray[indexPath.row];
        goodVC.goodsId = [NSString stringWithFormat:@"%ld",goodslist.goodsId];
        goodVC.headerImage = goodslist.coverImgUrl;
    }
    [self.navigationController pushViewController:goodVC animated: NO];
    
}
#pragma mark - StoreHomeCellDelegate 立即购买
-(void)didClickwitchOneBuyIndexPath:(NSIndexPath*)indexPath AndGoodId:(NSString * )goodId{
  
    NSLog(@"%@ == goodId",goodId);
    GoodsDeltailViewController * goodVC = [ GoodsDeltailViewController new];
    if ( self.dataArray.count > 0) {
        GoodsExtendList * goodslist = self.dataArray[indexPath.row];
        goodVC.goodsId = goodId;
        goodVC.headerImage = goodslist.coverImgUrl;
    }
    [self.navigationController pushViewController:goodVC animated: NO];
    
    
}
#pragma mark - StoreCouponTableCellDelegate 获取优惠券
/**
 获取到当前的优惠券
 
 @param index 下标
 @param couponId id
 */
-(void)didClickCouponlistIndex:(NSInteger)index andCouponId:(NSString *)couponId
{
    if (BBUserDefault.isLogin == 1) {
        //领取优惠券  接口
        [self getCouponesPostRequst:couponId];
    }else{
        [self isNotLoginWithTabbar:YES];
    }
}

#pragma mark - 点击领取优惠券    recomment/receiveCoupon
-(void)getCouponesPostRequst:(NSString *)couponId
{
    NSDictionary * parma = @{
                             @"userName":BBUserDefault.nickName,
                             @"userPhone":BBUserDefault.userPhoneNumber,
                             @"couponId":couponId,
                             @"userId":BBUserDefault.cmUserId,
                             };
    [SVProgressHUD show];
    [MENetWorkManager post:[zfb_baseUrl stringByAppendingString:@"/recomment/receiveCoupon"] params:parma success:^(id response) {
      
        NSString * code = [NSString stringWithFormat:@"%@",response[@"resultCode"]];
        if ([code isEqualToString:@"0"] ) {
            
            [self.view makeToast:@"领取优惠券成功" duration:2 position:@"center"];
            //领取成功后移除
            [SVProgressHUD dismiss];
        }else{
            //领取失败后移除
            [SVProgressHUD dismiss];
            [self.view makeToast:response[@"resultMsg"] duration:2 position:@"center"];
            
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
    //idType    number    0 平台 1 商家 2 商品 3 所有    否
    //resultId    number    平台编号/商店编号/商品编号    是
    // userId    number    领优惠券用户编号    否
    // status    number    0 未领取 1 未使用 2 已使用 3 已失效    否
    
    NSDictionary * parma = @{
                             @"idType":@"2",
                             @"resultId":@"",
                             @"userId":BBUserDefault.cmUserId,
                             @"status":status,
                             @"pageIndex":[NSNumber numberWithInteger:self.currentPage],
                             @"pageSize":@"10",
                             @"storeId":_storeId,
                             @"goodsId":@"",
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
          
            [self.tableView reloadData];
            [SVProgressHUD dismiss];
        }else{
            
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

#pragma mark - 门店详情
-(void)storeListPostRequest
{

    NSDictionary * parma = @{
                             @"storeId":_storeId,
                             @"orderSort":@"",
                             @"page":[NSNumber numberWithInteger:self.currentPage],
                             @"size":[NSNumber numberWithInteger:kPageCount],
                             };
    [MENetWorkManager post:[NSString stringWithFormat:@"%@/getGoodsExtendListApp",zfb_baseUrl] params:parma success:^(id response) {
        StoreDetailHomeModel * store = [StoreDetailHomeModel mj_objectWithKeyValues:response];
        if ([store.resultCode isEqualToString:@"0"]) {
            if (self.refreshType == RefreshTypeHeader) {
                if (self.dataArray.count > 0) {
                    [self.dataArray removeAllObjects];
                }
            }
            for (GoodsExtendList * storelist in store.data.goodsExtendList) {
                [self.dataArray addObject:storelist];
            }
            [_placeholderView removeFromSuperview];
            if ([self isEmptyArray:self.dataArray]) {
                _placeholderView = [[CQPlaceholderView alloc]initWithFrame:self.tableView.bounds type:CQPlaceholderViewTypeNoGoods delegate:self];
                [self.tableView addSubview:_placeholderView];
            }
            [self.tableView reloadData];
        }
        [self endRefresh];
    } progress:^(NSProgress *progeress) {
    } failure:^(NSError *error) {
        NSLog(@"error=====%@",error);
        [self endRefresh];
        [self.view makeToast:@"网络错误" duration:2 position:@"center"];
    }];
    
}

-(void)viewWillAppear:(BOOL)animated
{
    //有优惠券列表
    [self recommentPostRequst:@"0"];
}
//既可以让headerView不悬浮在顶部，也可以让footerView不停留在底部。
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (self.DidScrollBlock) {
        self.DidScrollBlock(scrollView.contentOffset.y);
    }
    CGFloat sectionHeaderHeight = 98 ;
    CGFloat sectionFooterHeight = 0;
    CGFloat offsetY = scrollView.contentOffset.y;
    if (offsetY >= 0 && offsetY <= sectionHeaderHeight)
    {
        scrollView.contentInset = UIEdgeInsetsMake(-offsetY, 0, -sectionFooterHeight, 0);
    }else if (offsetY >= sectionHeaderHeight && offsetY <= scrollView.contentSize.height - scrollView.frame.size.height - sectionFooterHeight)
    {
        scrollView.contentInset = UIEdgeInsetsMake(-sectionHeaderHeight, 0, -sectionFooterHeight, 0);
    }else if (offsetY >= scrollView.contentSize.height - scrollView.frame.size.height - sectionFooterHeight && offsetY <= scrollView.contentSize.height - scrollView.frame.size.height)
    {
        scrollView.contentInset = UIEdgeInsetsMake(-offsetY, 0, -(scrollView.contentSize.height - scrollView.frame.size.height - sectionFooterHeight), 0);
    }
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
