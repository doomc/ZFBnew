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
#import "ClearingStoreList.h"

@interface ZFShopListViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong) UITableView    * mytableView;
@property (nonatomic,strong) NSMutableArray * goodsListArray;///商品列表
@property (nonatomic,strong) NSMutableArray * goodsPropArray;///商品规格
@property (nonatomic,strong) NSMutableArray * productlistArray;///门店商品


@end

@implementation ZFShopListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title =@"商家清单";
    
    
    self.mytableView            = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, KScreenW, KScreenH-64) style:UITableViewStyleGrouped];
    self.mytableView.delegate   = self;
    self.mytableView.dataSource = self;
    [self.view addSubview:self.mytableView];
    self.mytableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [self.mytableView registerNib:[UINib nibWithNibName:@"ZFShopListCell" bundle:nil]
           forCellReuseIdentifier:@"ZFShopListCellid"];
    [self.mytableView registerNib:[UINib nibWithNibName:@"ShopOrderStoreNameCell" bundle:nil]
           forCellReuseIdentifier:@"ShopOrderStoreNameCellid"];
    
    _goodsListArray =[NSMutableArray array];

//    [self goodslistDetailPostRequst];
    
}


-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.productlistArray.count;
    
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    Productlist * product = self.productlistArray[section];
 
    NSLog(@"product.cmGoodsList == ==== %@",  product.cmGoodsList);
   return  product.cmGoodsList.count;
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return 118;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 40;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{

    ShopOrderStoreNameCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ShopOrderStoreNameCellid"];
    
    if (self.productlistArray.count > 0) {
        
        Productlist * list = self.productlistArray[section];
        cell.lb_storeName.text = list.storeName;
    }

    return cell;
    
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    ZFShopListCell * listCell = [self.mytableView dequeueReusableCellWithIdentifier:@"ZFShopListCellid" forIndexPath:indexPath];
    
    if (self.productlistArray.count > 0) {
        Productlist * product = _productlistArray[indexPath.section];
        Cmmgoodslist * goods  = product.cmGoodsList[indexPath.row];

        listCell.lb_title.text = goods.goodsName;
        listCell.lb_count.text = goods.goodsCount;
        listCell.lb_price.text = [NSString stringWithFormat:@"¥%@",goods.storePrice];
        [listCell.img_shopView sd_setImageWithURL:[NSURL URLWithString:goods.coverImgUrl] placeholderImage:nil];
        
        NSString *str = @"";
        
        for (Goodsprop * sku in goods.goodsProp) {
            
            [self.goodsPropArray addObject:sku];
            NSLog(@"%@ --:--%@",sku.name ,sku.value);
            NSString * goodstr = [NSString stringWithFormat:@"%@:%@ ",sku.name,sku.value];
            str = [str stringByAppendingString:goodstr];
        }
        
        listCell.lb_detailTitle.text = str;

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
//    [PPNetworkHelper POST:zfb_baseUrl parameters:parma responseCache:^(id responseCache) {
//        
//    } success:^(id responseObject) {
//    
//         if ([responseObject[@"resultCode"] isEqualToString:@"0"]) {
//            if (self.productlistArray.count >0) {
//                
//                [self.productlistArray removeAllObjects];
//
//            }
//        
//            NSString  * dataStr    = [responseObject[@"data"] base64DecodedString];
//            NSDictionary * jsondic = [NSString dictionaryWithJsonString:dataStr];
//            
// 
//             ClearingStoreList * storeList = [ClearingStoreList mj_objectWithKeyValues:jsondic];
//            
//             for (Productlist * product in storeList.productList) {
//                 
//                 [self.productlistArray addObject:product];
// 
//             }
//     
//             NSLog(@"%@ ==== productlistArray", self.productlistArray);
//             [self.mytableView reloadData];
//            
//        }
//        
//    } failure:^(NSError *error) {
//        NSLog(@"%@",error);
//        [self.view makeToast:@"网络错误" duration:2 position:@"center"];
//        
//    }];
}


-(NSMutableArray *)goodsPropArray
{
    if (!_goodsPropArray) {
        _goodsPropArray =[NSMutableArray array];
        
    }
    return _goodsPropArray;
}
-(NSMutableArray *)productlistArray
{
    if (!_productlistArray) {
        _productlistArray =[NSMutableArray array];
        
    }
    return _productlistArray;
}

@end
