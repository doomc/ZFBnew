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



@end

@implementation ZFShopListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title =@"商家清单";
    
    [self tableViewInterFaceView];
 
    NSLog(@"_userGoodsArray= %@",_userGoodsArray);
    
    for (NSDictionary * dic in _userGoodsArray) {
        
        [self.goodsArray addObject:dic];
    }
    
 
}


-(void)tableViewInterFaceView
{
    
    self.mytableView            = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, KScreenW, KScreenH) style:UITableViewStylePlain];
    self.mytableView.delegate   = self;
    self.mytableView.dataSource = self;
    self.mytableView.estimatedRowHeight = 0;

    [self.view addSubview:self.mytableView];
    self.mytableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [self.mytableView registerNib:[UINib nibWithNibName:@"ZFShopListCell" bundle:nil]
           forCellReuseIdentifier:@"ZFShopListCellid"];
 
    
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
    return 1;
    
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

    return self.goodsArray.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 135+40;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
 
    ZFShopListCell * listCell = [self.mytableView dequeueReusableCellWithIdentifier:@"ZFShopListCellid" forIndexPath:indexPath];
 
    NSDictionary * goodsdic = self.goodsArray[indexPath.row];
    NSString * goodsProp =[NSString stringWithFormat:@"%@",[goodsdic objectForKey:@"goodsProp"]];
    
    if (![goodsProp isEqualToString:@"[]"]) {
        
        NSArray * goodsPropArray = [goodsdic objectForKey:@"goodsProp"];
    
        for (NSDictionary  * product in goodsPropArray) {
            NSString * appding = [NSString stringWithFormat:@"%@  %@",[product objectForKey:@"name"],[product objectForKey:@"value"]];
            listCell.lb_detailTitle.text = [NSString stringWithFormat:@"%@",appding];
        }
        
    }else{
        
        listCell.lb_detailTitle.text = @"";
    }

    [listCell.img_shopView sd_setImageWithURL:[NSURL URLWithString:[goodsdic objectForKey:@"coverImgUrl"]] placeholderImage:[UIImage imageNamed:@"230x235"]];
    listCell.lb_count.text = [NSString stringWithFormat:@"x%@",[goodsdic objectForKey:@"goodsCount"]];
    listCell.lb_title.text = [NSString stringWithFormat:@"%@",[goodsdic objectForKey:@"goodsName"]];
    listCell.lb_price.text = [NSString stringWithFormat:@"¥%@",[goodsdic objectForKey:@"purchasePrice"]];
    listCell.lb_storeName.text = [NSString stringWithFormat:@"%@",[goodsdic objectForKey:@"storeName"]];


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

 
 
                             };
    [MENetWorkManager post:[NSString stringWithFormat:@"%@/getGoodsInfoList",zfb_baseUrl] params:parma success:^(id response) {
        
        NSString * code = [NSString stringWithFormat:@"%@", response[@"resultCode"]];
        if  ([code isEqualToString:@"0"])
        {
            [self.view makeToast:response[@"resultMsg"] duration:2 position:@"center"];
   
        }
        
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

@end
