//
//  ZFShoppingCarViewController.m
//  ZFB
//
//  Created by  展富宝  on 2017/5/11.
//  Copyright © 2017年 com.zfb. All rights reserved.
//  ****购物车


#import "ZFShoppingCarViewController.h"
#import "LoginViewController.h"

#import "ZFMainPayforViewController.h"
#import "DetailFindGoodsViewController.h"

#import "ZFShopCarCell.h"
#import "ZFShopCarEditCell.h"

#import "ShopCarFootView.h"
#import "ShoppingCarModel.h"

@interface ZFShoppingCarViewController ()<UITableViewDelegate,UITableViewDataSource,ShopCarFootViewDelegate>
@property (nonatomic,strong) UITableView * shopCar_tableview;

@property (nonatomic,strong) ShopCarFootView * footView;
@property (nonatomic,strong) UIView * sectionHeadView;
@property (nonatomic,strong) NSMutableArray * carListArray;

@property (nonatomic,assign) BOOL isEditStatus;//是否编辑状态
@property (nonatomic,weak) UIButton *selectedBtn;



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
    [self.shopCar_tableview registerNib:[UINib nibWithNibName:@"ZFShopCarEditCell" bundle:nil] forCellReuseIdentifier:@"ZFShopCarEditCellid"];
 
    [self shoppingCarPostRequst];
    
    [self.view addSubview:self.footView];
    
    _isEditStatus = NO; //默认没有编辑状态
    
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

-(UIView *)sectionHeadView
{
    _sectionHeadView  = [[UIView alloc]initWithFrame:CGRectMake(0 , 0, KScreenW, 40)];
    _sectionHeadView.backgroundColor = [UIColor whiteColor];
    
    NSString *statusStr = @"编辑";
    NSString *titletext = @"王大帅进口食品厂";
    UIFont * font  =[UIFont systemFontOfSize:12];
    
    //x门店全选
    UIButton * chooseStore_btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [chooseStore_btn setImage:[UIImage imageNamed:@"select_normal"] forState:UIControlStateNormal];
    [chooseStore_btn addTarget:self action:@selector(chooseStoreBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [_sectionHeadView addSubview:chooseStore_btn];
    
    [chooseStore_btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).with.offset(15);
        make.centerY.equalTo(_sectionHeadView.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(24, 24));
        
    }];
    //门店名字
    UIButton* storeName_btn = [[UIButton alloc]init ];
    [storeName_btn setTitle:titletext forState:UIControlStateNormal];
    storeName_btn.titleLabel.font = font;
    [storeName_btn setTitleColor: HEXCOLOR(0x7a7a7a) forState:UIControlStateNormal];
    storeName_btn.height = 20;
    [_sectionHeadView addSubview:storeName_btn];

    [storeName_btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(chooseStore_btn.mas_right).with.offset(10);
        make.centerY.equalTo(_sectionHeadView.mas_centerY);
        
    }];
    
    //编辑状态
    UIButton * edit_btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [edit_btn setTitle:statusStr forState:UIControlStateNormal];
    edit_btn.titleLabel.font = font;
    [edit_btn addTarget:self action:@selector(editAction:) forControlEvents:UIControlEventTouchUpInside];
    [edit_btn setTitleColor: HEXCOLOR(0x7a7a7a) forState:UIControlStateNormal];
    edit_btn.height = 20;
    [_sectionHeadView addSubview:edit_btn];
    
    [edit_btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(_sectionHeadView).with.offset(-15);
        make.centerY.equalTo(_sectionHeadView.mas_centerY);
        
    }];

    
    UILabel *lineDown =[[UILabel alloc]initWithFrame:CGRectMake(0, 39, KScreenW, 0.5)];
    lineDown.backgroundColor = HEXCOLOR(0xffcccc);
    UILabel *lineUP =[[UILabel alloc]initWithFrame:CGRectMake(0,0, KScreenW, 10)];
    lineUP.backgroundColor = RGB(247, 247, 247);//#F7F7F7 16进制
    [_sectionHeadView addSubview:lineDown];

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
#pragma mark - 门店全选 chooseStoreBtnAction
-(void)chooseStoreBtnAction:(UIButton * )sender
{
    sender.selected = !sender.selected ;
    
    if (sender.selected) {
        
        [sender setImage:[UIImage imageNamed:@"select_selected"] forState:UIControlStateSelected];
    }
    else{
        
        [sender setImage:[UIImage imageNamed:@"select_normal"] forState:UIControlStateNormal];
    }
    
}
#pragma mark - didClickClearingShoppingCar 购物车结算
-(void)didClickClearingShoppingCar:(UIButton *)sender
{
    ZFMainPayforViewController * payVC = [[ZFMainPayforViewController alloc]init];
    
    [self.navigationController pushViewController:payVC animated:YES];
}
#pragma mark - 编辑状态 editAction
-(void)editAction:(UIButton *)sender
{
    sender.selected = YES;
    self.selectedBtn = sender;
    if (sender != self.selectedBtn) {
       
        self.selectedBtn.selected = NO;
        self.selectedBtn = sender;
        _isEditStatus = NO;
        [self.selectedBtn setTitle:@"编辑" forState:UIControlStateNormal];
        NSLog(@"edit 0");
        
    }else{
        
        self.selectedBtn.selected = YES;
        _isEditStatus = YES;
        [self.selectedBtn setTitle:@"完成" forState:UIControlStateNormal];
        NSLog(@"edit 1");

    }
    [self.shopCar_tableview reloadData];

    
    
    
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
    UITableViewCell * cell = nil;
    if (_isEditStatus == NO) {
        ZFShopCarCell * shopCell = [self.shopCar_tableview dequeueReusableCellWithIdentifier:@"ShopCarCellid" forIndexPath:indexPath];
        shopCell.selectionStyle  = UITableViewCellSelectionStyleNone;
       
         cell = shopCell;
    }else{
        
        ZFShopCarEditCell *editCell = [self.shopCar_tableview dequeueReusableCellWithIdentifier:@"ZFShopCarEditCellid" forIndexPath:indexPath];
        editCell.selectionStyle  = UITableViewCellSelectionStyleNone;
 
        cell= editCell;
    }

    

//    Shoppcartlist * shopList = self.carListArray[indexPath.row];
//    shopCell.lb_title.text = shopList.goodsName;
//    shopCell.lb_price.text = shopList.storePrice;
////    shopCell.lb_result.text = shopList.goodsCount;
//    [shopCell.img_shopCar sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",shopList.coverImgUrl]] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
//        
//    }];
    
    
    return cell;
    
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



#pragma mark - 购物车列表网络请求 getShoppingCartList
-(void)shoppingCarPostRequst
{
 
 
    NSDictionary * parma = @{
                             
                             @"svcName":@"getShoppingCartList",
                             @"cmUserId":BBUserDefault.cmUserId,
                             
                             };
    
    NSDictionary *parmaDic=[NSDictionary dictionaryWithDictionary:parma];
    
    [PPNetworkHelper POST:ZFB_11SendMessageUrl parameters:parmaDic responseCache:^(id responseCache) {
        
    } success:^(id responseObject) {
        
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
