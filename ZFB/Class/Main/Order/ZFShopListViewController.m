//
//  ZFShopListViewController.m
//  ZFB
//
//  Created by 熊维东 on 2017/5/24.
//  Copyright © 2017年 com.zfb. All rights reserved.
//

#import "ZFShopListViewController.h"

#import "ZFSendingCell.h"
#import "ShopOrderStoreNameCell.h"
#import "BSListFooterCell.h"

#import "BussnissListModel.h"
@interface ZFShopListViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong) UITableView  * mytableView;
@property (nonatomic,strong) NSMutableArray  * storeArray;
@property (nonatomic,strong) NSMutableDictionary  * parmas;



@end

@implementation ZFShopListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title =@"商家清单";
    
    [self tableViewInterFaceView];
 
    _parmas = [NSMutableDictionary dictionary];
    [_parmas  setObject:_postAddressId forKey:@"postAddressId"];
    [_parmas  setObject:_userGoodsInfoJSON forKey:@"userGoodsInfoJSON"];
   
    [self  listPost];

//    NSLog(@"_userGoodsArray= %@",_userGoodsInfoJSON);
    
//    for (NSDictionary * dic in _userGoodsArray) {
//
//        [self.goodsArray addObject:dic];
//    }
}

-(void)tableViewInterFaceView
{
    
    self.mytableView            = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, KScreenW, KScreenH-64) style:UITableViewStylePlain];
    self.mytableView.delegate   = self;
    self.mytableView.dataSource = self;
    self.mytableView.backgroundColor = HEXCOLOR(0xffffff);

    [self.view addSubview:self.mytableView];
    self.mytableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [self.mytableView registerNib:[UINib nibWithNibName:@"ZFSendingCell" bundle:nil]
           forCellReuseIdentifier:@"ZFSendingCell"];
    [self.mytableView registerNib:[UINib nibWithNibName:@"ShopOrderStoreNameCell" bundle:nil]
           forCellReuseIdentifier:@"ShopOrderStoreNameCell"];
    [self.mytableView registerNib:[UINib nibWithNibName:@"BSListFooterCell" bundle:nil]
           forCellReuseIdentifier:@"BSListFooterCell"];
    
    
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.storeArray.count;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    BussnissUserStoreList * storelist = self.storeArray[section];
    return storelist.goodsInfoList.count;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
 
    ShopOrderStoreNameCell * titleCell = [self.mytableView
                                          dequeueReusableCellWithIdentifier:@"ShopOrderStoreNameCell"];
    if (self.storeArray.count > 0) {
        BussnissUserStoreList  * sectionList = self.storeArray[section];
        titleCell.storeList = sectionList;
    }
    return titleCell;

}
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
 
    BSListFooterCell * footCell = [self.mytableView
                                   dequeueReusableCellWithIdentifier:@"BSListFooterCell"];
    return footCell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 50;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    return 44+20+10;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 130;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
 
    ZFSendingCell * listCell = [self.mytableView dequeueReusableCellWithIdentifier:@"ZFSendingCell" forIndexPath:indexPath];
    listCell.share_btn.hidden = YES;
    listCell.sunnyOrder_btn.hidden = YES;
    
    BussnissUserStoreList  * sectionList  = self.storeArray[indexPath.section];
    NSMutableArray * goodArray = [NSMutableArray array];
    for (BussnissGoodsInfoList * goods in sectionList.goodsInfoList) {
        [goodArray addObject:goods];
    }
    BussnissGoodsInfoList * goodslist = goodArray[indexPath.row];
    listCell.goodlist = goodslist;
    return listCell;
}


-(void)viewWillAppear:(BOOL)animated
{
}
-(void)viewWillDisappear:(BOOL)animated
{
//    _storeArray = nil;
}
-(NSMutableArray *) storeArray{
    if (!_storeArray) {
        _storeArray =[NSMutableArray array];
    }
    return _storeArray;
}
#pragma mark -   获取用户商品列表接口 getProductList

//商品清单列表
-(void)listPost
{
 
    [SVProgressHUD show];
    [MENetWorkManager post:[NSString stringWithFormat:@"%@/getGoodsInfoList",zfb_baseUrl] params:_parmas success:^(id response) {
        NSString * code = [NSString stringWithFormat:@"%@",response[@"resultCode"]];
        if ([code isEqualToString:@"0"]) {
            BussnissListModel * listModel = [BussnissListModel mj_objectWithKeyValues:response];
    
            for (BussnissUserStoreList * storelist in listModel.userGoodsList) {
                [self.storeArray addObject:storelist];
            }
            [self.mytableView reloadData];
            [self.view makeToast:response[@"resultMsg"] duration:2 position:@"center"];
            [SVProgressHUD dismiss];

        }else{
            [self.view makeToast:response[@"resultMsg"] duration:2 position:@"center"];
            [SVProgressHUD dismiss];

        }

    } progress:^(NSProgress *progeress) {
    } failure:^(NSError *error) {
        [SVProgressHUD dismiss];
        NSLog(@"error=====%@",error);
        [self.view makeToast:@"网络错误" duration:2 position:@"center"];
    }];
}




@end
