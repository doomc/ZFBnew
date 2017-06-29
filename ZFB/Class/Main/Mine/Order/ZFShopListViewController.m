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

@property (nonatomic,strong) UITableView  * mytableView;
@property (nonatomic,strong) NSMutableArray  * goodsListArray;


@end

@implementation ZFShopListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title =@"商家清单";
    
    
    self.mytableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, KScreenW, KScreenH-64) style:UITableViewStyleGrouped];
    self.mytableView.delegate= self;
    self.mytableView.dataSource = self;
    [self.view addSubview:self.mytableView];
    self.mytableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [self.mytableView registerNib:[UINib nibWithNibName:@"ZFShopListCell" bundle:nil] forCellReuseIdentifier:@"ZFShopListCellid"];
    [self.mytableView registerNib:[UINib nibWithNibName:@"ShopOrderStoreNameCell" bundle:nil] forCellReuseIdentifier:@"ShopOrderStoreNameCellid"];
    
    [self goodslistDetailPostRequst];
     
}


-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
    
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

    return 1;
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
//    Productlist * list = self.goodsListArray[section];
    ShopOrderStoreNameCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ShopOrderStoreNameCellid"];
//    cell.lb_storeName.text = list.storeName;
    
    return cell;

}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{

    ZFShopListCell * listCell = [self.mytableView dequeueReusableCellWithIdentifier:@"ZFShopListCellid" forIndexPath:indexPath];
    
    
    return listCell;
}



#pragma mark - 商品详情页 getProductList
-(void)goodslistDetailPostRequst
{
    NSDictionary * parma = @{
                             
                             @"svcName":@"getProductList",
                             @"cmUserId":BBUserDefault.cmUserId,
                             @"storeId":@"1",//可能添加参数
                             
                             };
    
    NSDictionary *parmaDic=[NSDictionary dictionaryWithDictionary:parma];
    
    [SVProgressHUD show];
    
    [PPNetworkHelper POST:ZFB_11SendMessageUrl parameters:parmaDic responseCache:^(id responseCache) {
        
    } success:^(id responseObject) {
        
        if ([responseObject[@"resultCode"] isEqualToString:@"0"]) {
            if (self.goodsListArray.count >0) {
                
                [self.goodsListArray removeAllObjects];
            }
            
            NSString  * dataStr= [responseObject[@"data"] base64DecodedString];
            NSDictionary * jsondic = [NSString dictionaryWithJsonString:dataStr];
            
            ClearingStoreList *  storeList = [ClearingStoreList mj_objectWithKeyValues:jsondic];
//            
//            for (Cmgoodslist * goodsList in storeList.cmGoodsList) {
//                
//                [self.goodsListArray  addObject:goodsList];
//            }
            NSLog(@"%@ ==== self.goodsListArray",self.goodsListArray);
            
            [self.mytableView reloadData];
           
        }
        [SVProgressHUD dismiss];

    } failure:^(NSError *error) {
        NSLog(@"%@",error);
        [self.view makeToast:@"网络错误" duration:2 position:@"center"];
        [SVProgressHUD dismiss];
        
    }];
    
    
}


-(NSMutableArray *)goodsListArray
{
    if (!_goodsListArray) {
        _goodsListArray =[NSMutableArray array];
        
    }
    return _goodsListArray;
}

@end
