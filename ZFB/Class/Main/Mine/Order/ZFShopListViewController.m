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
    
    [self goodslistDetailPostRequst];
    
}


-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
    
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return 2;
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
    
    if (self.productlistArray.count >0) {
        
        Productlist * list = self.productlistArray[section];
        cell.lb_storeName.text = list.storeName;
    }

    return cell;
    
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    ZFShopListCell * listCell = [self.mytableView dequeueReusableCellWithIdentifier:@"ZFShopListCellid" forIndexPath:indexPath];
    
    if (self.goodsListArray.count > 0) {
        Cmmgoodslist * list  =self.goodsListArray[indexPath.row];
        listCell.lb_title.text = list.goodsName;
        listCell.lb_count.text = list.goodsCount;
        listCell.lb_price.text = [NSString stringWithFormat:@"¥%@",list.storePrice];
       [listCell.img_shopView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",list.coverImgUrl]] placeholderImage:nil];
    
        NSString *str = @"";
        for (Goodsprop * sku in list.goodsProp) {
            
            [self.goodsPropArray addObject:sku];
            NSLog(@"%@ --:--%@",sku.name ,sku.value);
            NSString * goodstr = [NSString stringWithFormat:@"%@:%@ ",sku.name,sku.value];
            str = [str stringByAppendingString:goodstr];
        }
        listCell.lb_detailTitle.text = str;
    }
    
    return listCell;
}



#pragma mark -   获取用户商品列表接口 getProductList
-(void)goodslistDetailPostRequst
{
//    NSDictionary * parma = @{
//                             
//                             @"svcName":@"getProductList",
//                            //@"cmUserId":BBUserDefault.cmUserId,
//                             @"storeId":@"1",//可能添加参数
//                             
//                             };
//    
//    NSDictionary *parmaDic=[NSDictionary dictionaryWithDictionary:parma];
//    
//    [SVProgressHUD show];
//    
//    [PPNetworkHelper POST:zfb_url parameters:parmaDic responseCache:^(id responseCache) {
//        
//    } success:^(id responseObject) {
    
        NSDictionary * dic =  @{
                                @"productList":@{
                                        @"storeId": @"1",
                                        @"storeName": @"陶妈妈服装店"
                                        },
                                @"cmGoodsList": @[
                                        @{
                                            @"goodsId":  @"1",
                                            @"goodsName":  @"精装女装修身",
                                            @"coverImgUrl":  @"http://192.168.1.107:8086/upload/20170615110845_",
                                            @"goodsProp": @[
                                                    @{
                                                        @"name": @"颜色",
                                                        @"value": @"红色"
                                                        },
                                                    @{
                                                        @"name": @"大小",
                                                        @"value": @"xxl"
                                                        }
                                                    ],
                                            @"storePrice":  @"238",
                                            @"goodsCount": @"2"
                                            },
                                        @{
                                            @"goodsId": @"2",
                                            @"goodsName": @"精品女装-韩妆",
                                            @"coverImgUrl": @"http://192.168.1.107:8086/upload/20170615110845_",
                                            @"goodsProp": @[
                                                    @{
                                                        @"name": @"颜色",
                                                        @"value": @"红色"
                                                        },
                                                    @{
                                                        @"name": @"大小",
                                                        @"value": @"xxl"
                                                        }
                                                    ],
                                            @"storePrice": @"238",
                                            @"goodsCount": @"2"
                                            }
                                        ],
                                @"goodsAllCount": @"4",
                                @"resultCode": @0,
                                };
//
//        if ([responseObject[@"resultCode"] isEqualToString:@"0"]) {
//            if (self.goodsListArray.count >0) {
//                
//                [self.goodsListArray removeAllObjects];
//                [self.goodsPropArray removeAllObjects];
//
//            }
        
           //            NSString  * dataStr    = [responseObject[@"data"] base64DecodedString];
//            NSDictionary * jsondic = [NSString dictionaryWithJsonString:dataStr];
//            
//            ClearingStoreList * storeList = [ClearingStoreList mj_objectWithKeyValues:dic];
//            
//            for (Productlist * list in storeList.productList) {
//             
//                for (Cmmgoodslist * goods in list.cmGoodsList) {
//                    
//                    [self.goodsListArray  addObject:goods];
//                }
//                   [self.productlistArray addObject:list];
//            }
    
    Productlist * proList = [Productlist mj_objectWithKeyValues:dic];
    for (Cmmgoodslist * goodlist in proList.cmGoodsList) {
        
        [self.goodsListArray addObject:goodlist];
        
    
    }
            NSLog(@"%@ ==== goodsListArray",self.goodsListArray);
    
            
            [self.mytableView reloadData];
            
//        }
        [SVProgressHUD dismiss];
//        
//    } failure:^(NSError *error) {
//        NSLog(@"%@",error);
//        [self.view makeToast:@"网络错误" duration:2 position:@"center"];
//        [SVProgressHUD dismiss];
//        
//    }];
//    
    
}


-(NSMutableArray *)goodsListArray
{
    if (!_goodsListArray) {
        _goodsListArray =[NSMutableArray array];
        
    }
    return _goodsListArray;
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
