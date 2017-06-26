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

#import "ShopCarFootView.h"
#import "ShoppingCarModel.h"


static NSString  * shopCarContenCellID = @"ZFShopCarCell";
static NSString  * shoppingHeaderID = @"ShopCarSectionHeadViewCell";

@interface ZFShoppingCarViewController ()<UITableViewDelegate,UITableViewDataSource,ShopCarFootViewDelegate,ShoppingSelectedDelegate>
@property (nonatomic,strong) UITableView * shopCar_tableview;

@property (nonatomic,strong) ShopCarFootView * footView;
@property (nonatomic,strong) NSMutableArray * carListArray;

@property (nonatomic,assign) BOOL isEditStatus;//是否编辑状态
@property (nonatomic,weak) UIButton *selectedBtn;



@end

@implementation ZFShoppingCarViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self.shopCar_tableview registerNib:[UINib nibWithNibName:shopCarContenCellID bundle:nil]
                 forCellReuseIdentifier:shopCarContenCellID];
    [self.shopCar_tableview registerNib:[UINib nibWithNibName:shoppingHeaderID bundle:nil]
                 forCellReuseIdentifier:shoppingHeaderID];
    
    [self shoppingCarPostRequst];
    
    [self.view addSubview:self.footView];
    
    //    _isEditStatus = NO; //默认没有编辑状态
    
    
}
//更新数据
-(void)refreshData
{
    
}


#pragma mark - 所有门店全选 chooseStoreBtnAction
-(void)chooseStoreBtnAction:(UIButton * )sender
{
    //    sender.selected = !sender.selected ;
    //
    //    for (Shoppcartlist *list in self.carListArray)
    //    {
    //        list.ShoppcartlistIsEditing = sender.selected;
    //    }
    //
    //    [self.shopCar_tableview reloadData];
    //    NSLog(@" 门店全选");
    //
    
}
#pragma mark - ShopCarFootViewDelegate 全选代理
-(void)selectAllgoods:(UIButton *)sender
{
    
    NSLog(@" 商品全选");
    
    //    sender.selected = !sender.selected ;
    //
    //    if (sender.selected) {
    //
    //        [sender setImage:[UIImage imageNamed:@"select_selected"] forState:UIControlStateSelected];
    //    }
    //    else{
    //
    //        [sender setImage:[UIImage imageNamed:@"select_normal"] forState:UIControlStateNormal];
    //    }
    
}
#pragma mark - didClickClearingShoppingCar 购物车结算
-(void)didClickClearingShoppingCar:(UIButton *)sender
{
    ZFMainPayforViewController * payVC = [[ZFMainPayforViewController alloc]init];
    
    [self.navigationController pushViewController:payVC animated:YES];
}

#pragma mark - 商品编辑状态回调 shopCarEditingSelected
- (void)shopCarEditingSelected:(NSInteger)sectionIdx
{
    
    Shoppcartlist * list = self.carListArray[sectionIdx];
    list.ShoppcartlistIsEditing = !list.ShoppcartlistIsEditing;
    [self.shopCar_tableview reloadData];
    
}
#pragma mark - 商品 全选择回调 shopCarEditingSelected
- (void)shopStoreSelected:(NSInteger)sectionIndex
{
    
    Shoppcartlist *list = self.carListArray[sectionIndex];
    list.leftShoppcartlistIsChoosed = !list.leftShoppcartlistIsChoosed;
    //遍历数组元素
    
#warning ======== 遍历有错误
    [list.goodsList enumerateObjectsUsingBlock:^(Goodslist *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        obj.goodslistIsChoosed = obj.goodslistIsChoosed;
    }];
    [self.shopCar_tableview reloadData];
    // 每次点击都要统计底部的按钮是否全选
    //    self.allSelectedButton.selected = [self isAllProcductChoosed];
    //
    //    [self.accountButton setTitle:[NSString stringWithFormat:@"结算(%ld)",[self countTotalSelectedNumber]] forState:UIControlStateNormal];
    //
    //    self.totalPriceLabel.text = [NSString stringWithFormat:@"合计￥%.2f",[self countTotalPrice]];
    
}
#pragma mark - tableView delegare
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.carListArray.count;
    
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    Shoppcartlist * list  = self.carListArray[section];
    
    return list.goodsList.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat actualHeight = [tableView fd_heightForCellWithIdentifier:shopCarContenCellID cacheByIndexPath:indexPath configuration:^(ZFShopCarCell *cell) {
        
        [self configCell:cell indexPath:indexPath];
        
    }];
    return actualHeight >= 100 ? actualHeight : 92;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    Shoppcartlist * list = self.carListArray[section];
    ZFShopCarCell *cell = [tableView dequeueReusableCellWithIdentifier:shoppingHeaderID];
    cell.chooseStore_btn.selected = list.leftShoppcartlistIsChoosed; //!<  是否需要勾选的字段
    [cell.enterStore_btn setTitle:[NSString stringWithFormat:@"%@",list.storeName] forState:UIControlStateNormal];
    cell.sectionIndex = section;
    cell.editStore_btn.selected = list.ShoppcartlistIsEditing;//是否处于编辑
    cell.selectDelegate = self;
    
    return cell;
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 40.001 ;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 10;
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    ZFShopCarCell * shopCell = [self.shopCar_tableview dequeueReusableCellWithIdentifier:shopCarContenCellID forIndexPath:indexPath];
    shopCell.selectionStyle  = UITableViewCellSelectionStyleNone;
    shopCell.selectDelegate = self;
    
    [self configCell:shopCell indexPath:indexPath];
    

    
    
    return shopCell;
    
}
// 组装cell
- (void)configCell:(ZFShopCarCell *)cell indexPath:(NSIndexPath *)indexPath
{
    
    
        Shoppcartlist * shopList = self.carListArray[indexPath.row];
    
//        shopCell.lb_title.text = shopList.goodsName;
//        shopCell.lb_price.text = shopList.storePrice;
//    //    shopCell.lb_result.text = shopList.goodsCount;
//        [shopCell.img_shopCar sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",shopList.coverImgUrl]] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
//    
//        }];
}
-(void)ChangeGoodsNumberCell:(ZFShopCarCell *)cell Number:(NSInteger)num
{
    
}
-(void)selectResult:(NSInteger)result
{
    
}

#pragma mark - tableView datasource
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
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
            
            if (self.carListArray.count > 0) {
                
                [self.carListArray  removeAllObjects];
                
            }else{
                
                NSString  * dataStr= [responseObject[@"data"] base64DecodedString];
                //JSON字符串转化为字典
                NSDictionary * jsondic = [NSString dictionaryWithJsonString:dataStr];
              
                NSArray * dictArray = jsondic [@"shoppCartList"];
                
                NSArray *storArray = [Shoppcartlist mj_objectArrayWithKeyValuesArray:dictArray];
                
                for (Shoppcartlist *lists in storArray) {
                    
                    [self.carListArray addObject:lists];
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

#pragma mark - 计算商品被选择了数量
- (NSInteger)countTotalSelectedNumber
{
    NSInteger count = 0;
    for (Shoppcartlist *list in self.carListArray) {
        for (Goodslist *goods in list.goodsList) {
            if (goods.goodslistIsChoosed) {
                count ++;
            }
        }
    }
    NSLog(@"  -----------%ld ------------",count);
    
    return count;
}

#pragma mark - 计算选出商品的总价
- (CGFloat)countTotalPrice
{
    CGFloat totalPrice = 0.0;
    for (Shoppcartlist *list in self.carListArray) {
        if (list.leftShoppcartlistIsChoosed) {
            for (Goodslist * goods  in list.goodsList) {
                totalPrice += goods.storePrice * goods.goodsCount;
            }
        }else{
            for (Goodslist * goods  in list.goodsList) {
                if (goods.goodslistIsChoosed) {
                    totalPrice += goods.storePrice * goods.goodsCount;
                }
            }
            
        }
    }
    return totalPrice;
}
#pragma mark - 判断是否全部选中了
- (BOOL)isAllProcductChoosed
{
    if ([self isEmptyArray:self.carListArray] ) {
        return NO;
    }
    NSInteger count = 0;
    for (Shoppcartlist * list in self.carListArray) {
        if (list.leftShoppcartlistIsChoosed) {
            count ++;
        }
    }
    return (count == self.carListArray.count);
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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

-(ShopCarFootView *)footView
{
    if (!_footView) {
        _footView= [[ShopCarFootView alloc]initWithFrame:CGRectMake(0, KScreenH -49-49, KScreenW,  KScreenH -49-49-64)];
        _footView.backgroundColor = randomColor;
        _footView.delegate = self;
    }
    return _footView;
}

-(NSMutableArray *)carListArray
{
    if (!_carListArray) {
        _carListArray = [NSMutableArray array];
    }
    return _carListArray;
}

//判断是不是空数组
- (BOOL)isEmptyArray:(NSArray *)array
{
    return (array.count ==0 || array == nil);
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
