//
//  StoreHomeViewController.m
//  ZFB
//
//  Created by  展富宝  on 2017/11/20.
//  Copyright © 2017年 com.zfb. All rights reserved.
//  门店首页
#define  cellHeight  270
#import "StoreHomeViewController.h"
//cell
#import "StoreHomeCell.h"
#import "StoreHomeHeaderCell.h"
#import "StoreCouponTableCell.h"
//view
#import "CouponTableView.h"
//model
#import "CouponModel.h"

@interface StoreHomeViewController () <UITableViewDelegate,UITableViewDataSource,CouponTableViewDelegate>

@property (nonatomic , strong) UITableView * tableView;
@property (nonatomic , strong) NSMutableArray * dataArray;
@property (nonatomic , strong) NSMutableArray * couponList;
@property (nonatomic , strong) CouponTableView *  couponTableView;
@property (nonatomic , strong) UIView *  couponBackgroundView;

@end

@implementation StoreHomeViewController


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
-(NSMutableArray *)dataArray{
    if (_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}
#pragma mark - tableView
-(UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, KScreenW, KScreenH -50)];
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
    
    [self.tableView registerNib:[UINib nibWithNibName:@"StoreHomeCell" bundle:nil] forCellReuseIdentifier:@"StoreHomeCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"StoreCouponTableCell" bundle:nil] forCellReuseIdentifier:@"StoreCouponTableCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"StoreHomeHeaderCell" bundle:nil] forCellReuseIdentifier:@"StoreHomeHeaderCell"];

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
    return 3;
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
    }
    return cellHeight;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return 0.001;
    }
    return 98;
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
            
        }else {
            couponCell.hidden = YES;
        }
        return couponCell;
    }else
    {
        StoreHomeCell * storeCell = [self.tableView dequeueReusableCellWithIdentifier:@"StoreHomeCell" forIndexPath:indexPath];
        return storeCell;
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
        if ([response[@"resultCode"] isEqualToString:@"0"] ) {
            
            [self.view makeToast:@"领取优惠券成功" duration:2 position:@"center"];
            //领取成功后移除
            [self.couponBackgroundView removeFromSuperview];
            [self.couponTableView reloadData];
            [SVProgressHUD dismiss];
            
        }else{
            
            //领取失败后移除
            [self.couponBackgroundView removeFromSuperview];
            [self.couponTableView reloadData];
            [SVProgressHUD dismiss];
            [self.view makeToast:@"领取失败" duration:2 position:@"center"];
            
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
                             @"idType":@"3",
                             @"resultId":@"",
                             @"userId":BBUserDefault.cmUserId,
                             @"status":status,
                             @"pageIndex":[NSNumber numberWithInteger:self.currentPage],
                             @"pageSize":@"100",
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
            
            [self.couponTableView reloadData];
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
    if (BBUserDefault.cmUserId == nil) {
        BBUserDefault.cmUserId = @"";
    }
    NSDictionary * parma = @{
                             @"userId":BBUserDefault.cmUserId,
                             @"storeId":_storeId,
                             @"isNewRecomment":@"",
                             @"orderSort":@"",
                             @"page":[NSNumber numberWithInteger:self.currentPage],
                             @"size":[NSNumber numberWithInteger:kPageCount],
                             };
    [MENetWorkManager post:[NSString stringWithFormat:@"%@/getGoodsExtendListApp",zfb_baseUrl] params:parma success:^(id response) {
        if ([response[@"resultCode"] isEqualToString:@"0"]) {
            
 
            
        }
    } progress:^(NSProgress *progeress) {
    } failure:^(NSError *error) {
        NSLog(@"error=====%@",error);
        [self.view makeToast:@"网络错误" duration:2 position:@"center"];
    }];
    
}

-(void)viewWillAppear:(BOOL)animated
{
    if (BBUserDefault.isLogin == 1) {
        //登录后才有优惠券
        [self recommentPostRequst:@"0"];
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
