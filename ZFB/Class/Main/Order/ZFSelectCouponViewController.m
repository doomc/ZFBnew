//
//  ZFSelectCouponViewController.m
//  ZFB
//
//  Created by  展富宝  on 2017/9/14.
//  Copyright © 2017年 com.zfb. All rights reserved.
//  使用优惠券列表

#import "ZFSelectCouponViewController.h"
#import "CouponCell.h"

@interface ZFSelectCouponViewController ()<UITableViewDataSource,UITableViewDelegate,CYLTableViewPlaceHolderDelegate,WeChatStylePlaceHolderDelegate>

@property (nonatomic ,strong) UITableView * tableView;
@property (nonatomic ,strong) NSMutableArray * couponList;//优惠券数组


@end

@implementation ZFSelectCouponViewController
#pragma mark - 懒加载
-(UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, KScreenW, KScreenH - 64) style:UITableViewStylePlain
                      ];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle =  UITableViewCellSelectionStyleNone;
    }
    return _tableView;
}

-(NSMutableArray *)couponList
{
    if (!_couponList) {
        _couponList = [NSMutableArray array];
    }
    return _couponList;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    self.title = @"使用优惠券";
    self.view.backgroundColor = RGBA(244, 244, 244, 1);
    [self.view addSubview:self.tableView];
    self.zfb_tableView = self.tableView;
    [self.tableView registerNib:[UINib nibWithNibName:@"CouponCell" bundle:nil] forCellReuseIdentifier:@"CouponCell"];
    
    [self setupRefresh];
}

-(void)footerRefresh
{
    [super footerRefresh];
    [self getUserNotUseCouponListPostRequset];

}
-(void)headerRefresh
{
    [super headerRefresh];
    [self getUserNotUseCouponListPostRequset];

}
-(void)viewWillAppear:(BOOL)animated{

    [self getUserNotUseCouponListPostRequset];

}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.couponList.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 100;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CouponCell * couponCell = [self.tableView dequeueReusableCellWithIdentifier:@"CouponCell" forIndexPath:indexPath];
    Couponlist  * list  = self.couponList [indexPath.row];
    couponCell.couponlist = list;
    couponCell.indexRow = indexPath.row;
    return couponCell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    Couponlist  * list  = self.couponList [indexPath.row];
    self.couponBlock([NSString stringWithFormat:@"%ld",list.couponId], [NSString stringWithFormat:@"%ld",list.useRange], [NSString stringWithFormat:@"%.2f",list.eachOneAmount],list.storeId ,list.goodsIds);
    [self backAction];
}


#pragma mark - 获取用户未使用优惠券列表   recomment/getUserNotUseCouponList
-(void)getUserNotUseCouponListPostRequset{
    NSDictionary * parma = @{
                             @"status":@"1",
                             @"idType":@"3",
                             @"resultId":@"",
                             @"goodsAmount":_goodsAmount,//商品金额
                             @"goodsId":_goodsIdJson,
                             @"storeId":_storeIdjosn,
                             @"userId":BBUserDefault.cmUserId,
                             @"pageIndex":[NSNumber numberWithInteger:self.currentPage],
                             @"pageSize":[NSNumber numberWithInteger:kPageCount],
                             };
    [SVProgressHUD show];
    [MENetWorkManager post:[zfb_baseUrl stringByAppendingString:@"/recomment/getUserNotUseCouponList"] params:parma success:^(id response) {
        if ([response[@"resultCode"] isEqualToString:@"0"] ) {
            
            if (self.refreshType == RefreshTypeHeader) {
                if (self.couponList.count > 0) {
                    
                    [self.couponList removeAllObjects];
                }
            }
            CouponModel * coupon = [CouponModel mj_objectWithKeyValues:response];
            for (Couponlist * list in coupon.couponList) {
                if ([list.validPeriod isEqualToString:@"1"]) {//有效期内
                    [self.couponList addObject:list];
                }
            }

            [self.tableView reloadData];
            [SVProgressHUD dismiss];
            [self endRefresh];
           
            if ([self isEmptyArray:self.couponList]) {
                [self.tableView cyl_reloadData];
            }
        }
        
    } progress:^(NSProgress *progeress) {
        
    } failure:^(NSError *error) {
        [self endRefresh];
        [SVProgressHUD dismiss];
        NSLog(@"error=====%@",error);
        [self.view makeToast:@"网络错误" duration:2 position:@"center"];
    }];
    
}

-(void)viewWillDisappear:(BOOL)animated
{
    [SVProgressHUD dismiss];

}

#pragma mark - CYLTableViewPlaceHolderDelegate Method
- (UIView *)makePlaceHolderView {
    
    UIView *weChatStyle = [self weChatStylePlaceHolder];
    return weChatStyle;
}

//暂无数据
- (UIView *)weChatStylePlaceHolder {
    WeChatStylePlaceHolder *weChatStylePlaceHolder = [[WeChatStylePlaceHolder alloc] initWithFrame:self.tableView.frame];
    weChatStylePlaceHolder.delegate = self;
    return weChatStylePlaceHolder;
}
#pragma mark - WeChatStylePlaceHolderDelegate Method
- (void)emptyOverlayClicked:(id)sender {
    
    [self getUserNotUseCouponListPostRequset];
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
