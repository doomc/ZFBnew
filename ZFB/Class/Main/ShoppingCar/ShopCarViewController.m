
//
//  ShopCarViewController.m
//  ZFB
//
//  Created by  展富宝  on 2017/8/7.
//  Copyright © 2017年 com.zfb. All rights reserved.
//

#import "ShopCarViewController.h"

//cell
#import "ShopCarCell.h"
//view
#import "ShopCarSectionHeadViewCell.h"
#import "DDChangeBtn.h"
#import "UIView+Extension.h"

//model
#import "ShoppingCarModel.h"
//vc
#import "BaseNavigationController.h"
#import "LoginViewController.h"
#import "ZFSureOrderViewController.h"
#import "DetailFindGoodsViewController.h"



@interface ShopCarViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    int _keyboardHeight;
    //记录所改规格的数量
    NSString *_goodNumber;
    //记录所改规格的购物车id
    NSString *_shopCarId;
    //记录所改规格的商品id
    NSString *_goodId;
    //记录所改规格的商品的indexPath
    NSIndexPath *_speIndexPath;
}
//////////////////////--数组--//////////////////////
//全部门店
@property (nonatomic, strong) NSMutableArray *shopStoreArray;

//存储要删除商品的购物车id
@property (nonatomic, strong) NSMutableArray *shopCarDeleteIdArray;

//////////////////////--underFootView--//////////////////////
@property (nonatomic, strong) UITableView *tableView;


@end

@implementation ShopCarViewController
#pragma mark -- 懒加载
-(NSMutableArray *)shopStoreArray{
    if (!_shopStoreArray) {
        _shopStoreArray = [NSMutableArray array];
    }
    return _shopStoreArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationController.title = @"我的购物车";

    self.automaticallyAdjustsScrollViewInsets = NO;
    
    [self.tableView registerNib:[UINib nibWithNibName:@"ShopCarCell" bundle:nil]
         forCellReuseIdentifier:@"ShopCarCell"];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"ShopCarSectionHeadViewCell" bundle:nil]
         forCellReuseIdentifier:@"ShopCarSectionHeadViewCell"];
    
    [self.view addSubview:self.tableView];

    [self setUpBottomView];
    
}
-(UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, KScreenW, KScreenH - 50-49 -64) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;

    }
    return _tableView;
}

- (void)setUpBottomView{
 

}

#pragma mark -- 底部全选按钮
#pragma mark -- 计算总价
#pragma mark -- 结算
#pragma mark - ShopCarCellDelegate
#pragma mark-  选择当前section
#pragma mark-  全选
#pragma mark -- UITableViewDelegate,UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
   
    return self.shopStoreArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
   
    Shoppcartlist * storelist = self.shopStoreArray[section];
    return storelist.goodsList.count;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
   
    Shoppcartlist * storelist = self.shopStoreArray[section];
    ShopCarSectionHeadViewCell *headerView = [tableView dequeueReusableCellWithIdentifier:@"ShopCarSectionHeadViewCell"];

    headerView.storelist = storelist;
    
    return headerView;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat actualHeight = [tableView fd_heightForCellWithIdentifier:@"ShopCarCell" cacheByIndexPath:indexPath configuration:^(ShopCarCell *cell) {
        
        [self configCell:cell indexPath:indexPath];
        
    }];
    return actualHeight >= 100 ? actualHeight : 92;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 40.001 ;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
   
    ShopCarCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"ShopCarCell" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [self configCell:cell indexPath:indexPath];

    return cell;
}
- (void)configCell:(ShopCarCell *)cell indexPath:(NSIndexPath *)indexPath
{
    Shoppcartlist *storelist = self.shopStoreArray[indexPath.section];
    ShopGoodslist *goodslist = storelist.goodsList[indexPath.row];
    
    cell.goodslist = goodslist;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
 
    NSLog(@"%ld ------ %ld",indexPath.section,indexPath.row);
}


#pragma mark - 购物车列表网络请求 getShoppCartList
-(void)shoppingCarPostRequst
{
    NSDictionary * parma = @{
                             @"cmUserId":BBUserDefault.cmUserId,
                             };
    
    [SVProgressHUD show];
    [MENetWorkManager post:[zfb_baseUrl stringByAppendingString:@"/getShoppCartList"] params:parma success:^(id response) {
        
        if ([response[@"resultCode"] intValue] == 0 ) {
            
            if (self.shopStoreArray.count > 0) {
                
                [self.shopStoreArray  removeAllObjects];
            }
            ShoppingCarModel * shopModel = [ShoppingCarModel mj_objectWithKeyValues:response];
            
            for (Shoppcartlist * list in shopModel.shoppCartList) {
               
                [self.shopStoreArray addObject:list];
                
            }
            NSLog(@"shopStoreArray---%@",self.shopStoreArray);
            [SVProgressHUD dismiss];
            [self.tableView reloadData];
        }
        
    } progress:^(NSProgress *progeress) {
        
    } failure:^(NSError *error) {
        [SVProgressHUD dismiss];
        NSLog(@"error=====%@",error);
        [self.view makeToast:@"网络错误" duration:2 position:@"center"];
    }];
    
}
#pragma mark - 删除网络请求后一些列更新操作delShoppingCart
-(void)deleteShoppingCarPostRequst
{
    NSDictionary * parma = @{
                             
                             @"cmUserId":BBUserDefault.cmUserId,
                             @"cartItemId":_shopCarId,
                             
                             };
    [MENetWorkManager post:[zfb_baseUrl stringByAppendingString:@"/delShoppingCart"] params:parma success:^(id response) {
        
        [self.view makeToast:response[@"resultMsg"] duration:2 position:@"center"];
        [self.tableView reloadData];
        
    } progress:^(NSProgress *progeress) {
    } failure:^(NSError *error) {
        
        NSLog(@"error=====%@",error);
        [self.view makeToast:@"网络错误" duration:2 position:@"center"];
    }];
}


-(void)viewWillAppear:(BOOL)animated
{
    [self shoppingCarPostRequst];//获取购物车列表
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
