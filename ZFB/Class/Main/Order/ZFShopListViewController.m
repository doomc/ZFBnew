//
//  ZFShopListViewController.m
//  ZFB
//
//  Created by 熊维东 on 2017/5/24.
//  Copyright © 2017年 com.zfb. All rights reserved.
//

#import "ZFShopListViewController.h"
#import "ZFShopListCell.h"
#import "ShopOrderStoreNameCell.h"

@interface ZFShopListViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong) UITableView  * mytableView;
@property (nonatomic,strong) NSMutableArray  * goodsArray;
@property (nonatomic,strong) NSMutableArray  * storeArray;



@end

@implementation ZFShopListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title =@"商家清单";
    
 

 //    [self goodslistDetailPostRequst];
    
     [self tableViewInterFaceView];

}
-(void)setStoreListArray:(NSMutableArray *)storeListArray{
    
    _storeListArray = storeListArray;
    
}
-(void)tableViewInterFaceView
{
    
    self.mytableView            = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, KScreenW, KScreenH-64) style:UITableViewStylePlain];
    self.mytableView.delegate   = self;
    self.mytableView.dataSource = self;
    [self.view addSubview:self.mytableView];
    self.mytableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [self.mytableView registerNib:[UINib nibWithNibName:@"ZFShopListCell" bundle:nil]
           forCellReuseIdentifier:@"ZFShopListCellid"];
    [self.mytableView registerNib:[UINib nibWithNibName:@"ShopOrderStoreNameCell" bundle:nil]
           forCellReuseIdentifier:@"ShopOrderStoreNameCellid"];
    
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
 
    return self.storeArray.count;
    
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.goodsArray.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 135;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 40;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    ShopOrderStoreNameCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ShopOrderStoreNameCellid"];
    for (NSDictionary * storedic in self.storeArray) {
        
        cell.lb_storeName.text =  [storedic objectForKey:@"storeName"];

    }
    return cell;
    
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
 
    ZFShopListCell * listCell = [self.mytableView dequeueReusableCellWithIdentifier:@"ZFShopListCellid" forIndexPath:indexPath];
 
    for (NSDictionary * goodsDic in self.goodsArray) {
        
      [listCell.img_shopView sd_setImageWithURL:[NSURL URLWithString:[goodsDic objectForKey:@"coverImgUrl"]] placeholderImage:[UIImage imageNamed:@""]];
        listCell.lb_count.text = [NSString stringWithFormat:@"x%@",[goodsDic objectForKey:@"goodsCount"]];
        listCell.lb_title.text = [NSString stringWithFormat:@"%@",[goodsDic objectForKey:@"goodsName"]];
        listCell.lb_detailTitle.text = [NSString stringWithFormat:@"%@",[goodsDic objectForKey:@"goodsProp"]];
        listCell.lb_price.text = [NSString stringWithFormat:@"¥%@",[goodsDic objectForKey:@"purchasePrice"]];
        listCell.section = indexPath.section;
    }
  
    return listCell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"section = %ld ----  row =%ld",indexPath.section,indexPath.row);
}

#pragma mark -   获取用户商品列表接口 getProductList
-(void)goodslistDetailPostRequst
{
    NSDictionary * parma = @{

                             @"cmUserId":BBUserDefault.cmUserId,
                             @"storeId":@"1",//可能添加参数 _storeId
                             @"goodsList":@"",
                             @"goodsId":@"",
                             @"goodsProp":@"",
                             @"goodsCount":@"",
 
                             };
    
 
    
    [MENetWorkManager post:[NSString stringWithFormat:@"%@/getGoodsInfoList",zfb_baseUrl] params:parma success:^(id response) {
        
    [self.view makeToast:response[@"resultMsg"] duration:2 position:@"center"];
        
    } progress:^(NSProgress *progeress) {
        
    } failure:^(NSError *error) {
        
        NSLog(@"error=====%@",error);
        [self.view makeToast:@"网络错误" duration:2 position:@"center"];
    }];

}

-(void)viewWillAppear:(BOOL)animated
{
    for (NSDictionary * storeDic in  self.storeListArray) {
        
        [self.storeArray addObject: storeDic];
        
        for (NSDictionary * goodsDic  in storeDic[@"goodsList"]) {
            
            [self.goodsArray addObject:goodsDic];
        }
    }
    
    [self.mytableView reloadData];
}
-(NSMutableArray *)goodsArray
{
    if (!_goodsArray) {
        _goodsArray =[NSMutableArray array];
    }
    return _goodsArray;
}
-(NSMutableArray *)storeArray
{
    if (!_storeArray) {
        _storeArray =[NSMutableArray array];
    }
    return _storeArray;
}
@end
