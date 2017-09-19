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
#import "ShopCarJsonModel.h"

@interface ZFShopListViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong) UITableView  * mytableView;
@property (nonatomic,strong) NSMutableArray  * storeArray;
@property (nonatomic,strong) NSMutableArray  * goodsArray;



@end

@implementation ZFShopListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title =@"商家清单";
    
    [self tableViewInterFaceView];
    
    ShopCarJsonModel * jsonmodel = [ShopCarJsonModel mj_objectWithKeyValues:_storeParam];
    
    for (StoreList * storeList in jsonmodel.storeList) {
        
        [self.storeArray addObject:storeList];
    
    }
    NSLog(@"storeArray= %@",self.storeArray);

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
    StoreList * storeModel  = self.storeArray[section];
    NSMutableArray *goodsArr = [NSMutableArray array];
    for (UserJsonGoodslist * goods in storeModel.goodsList) {
        [goodsArr addObject:goods];
    }
    return goodsArr.count;
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
   
    StoreList * storeModel  = self.storeArray[section];
    cell.lb_storeName.text = storeModel.storeName;

    return cell;
    
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
 
    ZFShopListCell * listCell = [self.mytableView dequeueReusableCellWithIdentifier:@"ZFShopListCellid" forIndexPath:indexPath];
    StoreList * storeModel  = self.storeArray[indexPath.section];
    UserJsonGoodslist * goodlist = storeModel.goodsList[indexPath.row];
    
    
//  //获取规格
//    for (UserJsonGoodsprop * goodsprop  in goodlist.goodsProp) {
//    
//    }
//    
    [listCell.img_shopView sd_setImageWithURL:[NSURL URLWithString:goodlist.coverImgUrl] placeholderImage:[UIImage imageNamed:@""]];
    listCell.lb_count.text = [NSString stringWithFormat:@"x%@",goodlist.goodsCount];
    listCell.lb_title.text = [NSString stringWithFormat:@"%@",goodlist.goodsName];
    listCell.lb_detailTitle.text = [NSString stringWithFormat:@"%@",goodlist.goodsProp];
    listCell.lb_price.text = [NSString stringWithFormat:@"¥%@",goodlist.purchasePrice];
    
    
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
 
}
-(void)viewWillDisappear:(BOOL)animated
{
//    _storeArray = nil;
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
