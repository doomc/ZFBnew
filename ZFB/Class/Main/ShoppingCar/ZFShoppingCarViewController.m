//
//  ZFShoppingCarViewController.m
//  ZFB
//
//  Created by  展富宝  on 2017/5/11.
//  Copyright © 2017年 com.zfb. All rights reserved.
//  ****购物车


#import "ZFShoppingCarViewController.h"
#import "LoginViewController.h"
#import "ZFShopCarCell.h"
#import "ZFMainPayforViewController.h"
#import "DetailFindGoodsViewController.h"

#import "ShopCarHeadView.h"
#import "ShopCarFootView.h"
#import "AddGoodsToShopCar.h"
@interface ZFShoppingCarViewController ()<UITableViewDelegate,UITableViewDataSource,ShopCarFootViewDelegate>

@property (nonatomic,strong) UITableView * shopCar_tableview;

@property (nonatomic,strong) ShopCarFootView * footView;
@property (nonatomic,strong) ShopCarHeadView * sectionHeadView;
@property (nonatomic,strong) NSMutableArray * carListArray;



@end

@implementation ZFShoppingCarViewController

-(NSMutableArray *)carListArray
{
    if (!_carListArray) {
        _carListArray = [NSMutableArray array];
        
    }
    return _carListArray;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self.shopCar_tableview registerNib:[UINib nibWithNibName:@"ZFShopCarCell" bundle:nil] forCellReuseIdentifier:@"ShopCarCellid"];
 
    [self.view addSubview:self.footView];
    
    [self shoppingCarPostRequst];
}

-(UITableView *)shopCar_tableview
{
    if (!_shopCar_tableview) {
        self.title = @"购物车";
        _shopCar_tableview =[[UITableView alloc]initWithFrame:CGRectMake(0, 64, KScreenW, KScreenH-64-49*2) style:UITableViewStyleGrouped];
        _shopCar_tableview.delegate = self;
        _shopCar_tableview.dataSource = self;
        _shopCar_tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
        //        _shopCar_tableview.backgroundColor = [UIColor whiteColor];
        [self.view addSubview:_shopCar_tableview];
    }
    return _shopCar_tableview;
}

-(ShopCarHeadView *)sectionHeadView
{
    _sectionHeadView  = [[ShopCarHeadView alloc]initWithFrame:CGRectMake(0 , 0, KScreenW, 40)];
    _sectionHeadView.backgroundColor = [UIColor whiteColor];
    return _sectionHeadView;
}

-(ShopCarFootView *)footView
{
    if (!_footView) {
        _footView= [[ShopCarFootView alloc]initWithFrame:CGRectMake(0, KScreenH -49-49, KScreenW,  KScreenH -49-49-64)];
        _footView.backgroundColor = randomColor;
        _footView.delegate = self;
    }
    return _footView;
}

#pragma mark - didClickClearingShoppingCar 购物车结算
-(void)didClickClearingShoppingCar:(UIButton *)sender
{
    ZFMainPayforViewController * payVC = [[ZFMainPayforViewController alloc]init];
    
    [self.navigationController pushViewController:payVC animated:YES];
}

-(void)didclickEdit:(UIButton *)edit
{
    NSLog(@"edit");
}
#pragma mark - tableView delegare
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 4;
    
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 92;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    
    return [self sectionHeadView] ;
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    //    if (section == 0) {
    //        return 0.001;
    //    }
    return 40.001 ;
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 10;
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ZFShopCarCell * shopCell = [self.shopCar_tableview dequeueReusableCellWithIdentifier:@"ShopCarCellid" forIndexPath:indexPath];
    shopCell.selectionStyle  = UITableViewCellSelectionStyleNone;
    Shoppcartlist * shopList = self.carListArray[indexPath.row];
    
    shopCell.lb_title.text = shopList.goodsName;
    shopCell.lb_price.text = shopList.storePrice;
//    shopCell.lb_result.text = shopList.goodsCount;
    
    [shopCell.img_shopCar sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",shopList.coverImgUrl]] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        
    }];
    
    
    return shopCell;
    
}
-(void)selectResult:(NSInteger)result
{
    
}

#pragma mark - tableView datasource
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@" section = %ld ， row = %ld",indexPath.section,indexPath.row);
    DetailFindGoodsViewController *deatilGoods =[[DetailFindGoodsViewController alloc]init];
    [self.navigationController pushViewController:deatilGoods animated:YES];
    
}



#pragma mark - 首页网络请求
-(void)shoppingCarPostRequst
{
 
 
    NSDictionary * parma = @{
                             
                             @"svcName":@"getShoppingCartList",
                             @"cmUserId":BBUserDefault.cmUserId,
                             
                             };
    
    NSDictionary *parmaDic=[NSDictionary dictionaryWithDictionary:parma];
    
    [PPNetworkHelper POST:ZFB_11SendMessageUrl parameters:parmaDic responseCache:^(id responseCache) {
        
    } success:^(id responseObject) {
        
        NSLog(@"  %@  = responseObject  " ,responseObject);
        
        if ([responseObject[@"resultCode"] isEqualToString:@"0"]) {
            
            if (self.carListArray.count >0) {
                
                [self.carListArray  removeAllObjects];
                
            }else{
                
                NSString  * dataStr= [responseObject[@"data"] base64DecodedString];
                NSDictionary * jsondic = [NSString dictionaryWithJsonString:dataStr];
                NSArray * dictArray = jsondic [@"shoppCartList"];
                
                //mjextention 数组转模型
                NSArray *storArray = [Shoppcartlist mj_objectArrayWithKeyValuesArray:dictArray];
                
                for (Shoppcartlist *list in storArray) {
                    
                    [self.carListArray addObject:list];
                }
                NSLog(@"carListArray = %@",   self.carListArray);
                
                [self.shopCar_tableview reloadData];
            }
            
        }
        
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
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
