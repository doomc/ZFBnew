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
#import "ShoppingCarModel.h"


static NSString  * shopCarContenCellID = @"ZFShopCarCell";
static NSString  * shoppingHeaderID = @"ShopCarSectionHeadViewCell";

@interface ZFShoppingCarViewController ()<UITableViewDelegate,UITableViewDataSource,ShoppingSelectedDelegate>
@property (nonatomic,strong) UITableView * shopCar_tableview;

@property (nonatomic,strong) UIView * underFootView;
@property (nonatomic,strong) NSMutableArray * carListArray;

//////////////////////--underFootView--//////////////////////

@property (nonatomic,strong) UIButton * complete_Btn;//结算按钮
@property (nonatomic,strong) UIButton * allSelectedButton;//全选
@property (nonatomic,strong) UILabel * totalPriceLabel;//价格
@property (nonatomic,copy) NSString * buttonTitle ;
@property (nonatomic,copy) NSString * price;

@end

@implementation ZFShoppingCarViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self.shopCar_tableview registerNib:[UINib nibWithNibName:shopCarContenCellID bundle:nil]
                 forCellReuseIdentifier:shopCarContenCellID];
    [self.shopCar_tableview registerNib:[UINib nibWithNibName:shoppingHeaderID bundle:nil]
                 forCellReuseIdentifier:shoppingHeaderID];
    
    [self.view addSubview:self.underFootView];
    
    [self refreshData];
    
    
    
}

//更新数据
-(void)refreshData
{
    
    self.allSelectedButton.selected = NO;
    self.complete_Btn.selected = NO;
    
    [self shoppingCarPostRequst];
}



#pragma mark - didClickClearingShoppingCar 购物车结算
-(void)didClickClearingShoppingCar:(UIButton *)sender
{
    NSLog(@" 结算");
    
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
#pragma - 点击单个商品cell选择按钮 goodsSelected :isSelected
- (void)goodsSelected:(ZFShopCarCell *)cell isSelected:(BOOL)choosed
{
    NSLog(@"单个选择");
 
    NSIndexPath *indexPath = [self.shopCar_tableview indexPathForCell:cell];
    Shoppcartlist * list = self.carListArray[indexPath.section];
    Goodslist *goods = list.goodsList[indexPath.row];
    goods.goodslistIsChoosed = !goods.goodslistIsChoosed;

    // 当点击单个的时候，判断是否该买手下面的商品是否全部选中
    __block NSInteger count = 0;
    [list.goodsList enumerateObjectsUsingBlock:^(Goodslist *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        if (obj.goodslistIsChoosed)
        {
            count ++;
        }
    }];
   
    if (count == list.goodsList.count)
    {
        list.leftShoppcartlistIsChoosed = YES;
    }
    else
    {
        list.leftShoppcartlistIsChoosed = NO;
    }
    
    [self.shopCar_tableview reloadData];
    // 每次点击都要统计底部的按钮是否全选
    self.allSelectedButton.selected = [self isAllProcductChoosed];
    
    [self.complete_Btn setTitle:[NSString stringWithFormat:@"结算(%ld)",[self countTotalSelectedNumber]] forState:UIControlStateNormal];
    self.totalPriceLabel.text = [NSString stringWithFormat:@"￥%.2f",[self countTotalPrice]];
    
}

#pragma mark - section 全选 shopStoreSelected
- (void)shopStoreSelected:(NSInteger)sectionIndex
{
    NSLog(@" section全选");
    Shoppcartlist *list = self.carListArray[sectionIndex];
    list.leftShoppcartlistIsChoosed = !list.leftShoppcartlistIsChoosed;
    
    //遍历数组元素
    [list.goodsList enumerateObjectsUsingBlock:^(Goodslist *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        obj.goodslistIsChoosed = list.leftShoppcartlistIsChoosed;
        
    }];
    
    [self.shopCar_tableview reloadData];
   
    // 每次点击都要统计底部的按钮是否全选
    self.allSelectedButton.selected = [self isAllProcductChoosed];
    [self.complete_Btn setTitle:[NSString stringWithFormat:@"结算(%ld)",[self countTotalSelectedNumber]] forState:UIControlStateNormal];
    self.totalPriceLabel.text = [NSString stringWithFormat:@"￥%.2f",[self countTotalPrice]];
    
}
#pragma mark - 点击底部全选按钮 clickAllGoodsSelected:
- (void)clickAllGoodsSelected:(UIButton *)sender {
    NSLog(@"所有全选");

    sender.selected = !sender.selected;

    for (Shoppcartlist *list in self.carListArray) {
        list.leftShoppcartlistIsChoosed = sender.selected;
        for (Goodslist *goods in list.goodsList) {
            goods.goodslistIsChoosed = list.leftShoppcartlistIsChoosed;
        }
    }
    [self.shopCar_tableview reloadData];
    
    CGFloat totalPrice = [self countTotalPrice];
    [self.complete_Btn setTitle:[NSString stringWithFormat:@"结算(%ld)",[self countTotalSelectedNumber]] forState:UIControlStateNormal];
    self.totalPriceLabel.text = [NSString stringWithFormat:@"￥%.2f",totalPrice];

}
#pragma mark -增加或者减少商品
-(void)addOrReduceCount:(ZFShopCarCell *)cell tag:(NSInteger)tag
{
    NSIndexPath *indexpath = [self.shopCar_tableview indexPathForCell:cell];
    Shoppcartlist *list = self.carListArray[indexpath.section];
    Goodslist * goods = list.goodsList[indexpath.row];
    if (tag == 555)
    {
        if (goods.goodsCount <= 1) {
            
        }
        else
        {
            goods.goodsCount --;
        }
    }
    else if (tag == 666)
    {
        goods.goodsCount ++;
    }
    self.totalPriceLabel.text = [NSString stringWithFormat:@"￥%.2f",[self countTotalPrice]];
    [self.shopCar_tableview reloadData];
    
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
    Shoppcartlist * shopList = self.carListArray[indexPath.section];
    Goodslist *goodslist = shopList.goodsList[indexPath.row];
    
    cell.chooseBtn.selected = goodslist.goodslistIsChoosed; //!< 商品是否需要选择的字段
    [cell.img_shopCar sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",goodslist.coverImgUrl]] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        
    }];
    
    cell.lb_price.text = [NSString stringWithFormat:@"¥%.2f",goodslist.storePrice];
    cell.editlb_price.text = [NSString stringWithFormat:@"¥%.2f",goodslist.storePrice];
    cell.lb_title.text =  goodslist.goodsName;
    cell.editlb_title.text =  goodslist.goodsName;
    cell.editTf_result.text = [NSString stringWithFormat:@"%ld",goodslist.goodsCount];
    cell.tf_result.text = [NSString stringWithFormat:@"%ld",goodslist.goodsCount];
    
    // 正常模式下面 非编辑
    if (!shopList.ShoppcartlistIsEditing)
    {
        cell.normalBackView.hidden = NO;
        cell.editBackView.hidden = YES;
    }
    else
    {
        cell.normalBackView.hidden = YES;
        cell.editBackView.hidden = NO;
    }
    
}
-(void)ChangeGoodsNumberCell:(ZFShopCarCell *)cell Number:(NSInteger)num
{
 
    NSLog(@"num = %ld ",num );

    
}

#pragma mark - tableView datasource
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSLog(@" section = %ld ， row = %ld",indexPath.section,indexPath.row);
    DetailFindGoodsViewController *deatilGoods =[[DetailFindGoodsViewController alloc]init];
    [self.navigationController pushViewController:deatilGoods animated:YES];
    
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
    NSLog(@"  -----选择了商品数量 %ld ---",count);
    
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

-(UIView *)underFootView
{
    if (!_underFootView) {
        _underFootView= [[UIView alloc]initWithFrame:CGRectMake(0, KScreenH -49-49, KScreenW,  KScreenH -49-49-64)];
        _underFootView.backgroundColor = randomColor;
        
        NSString *caseOrder =  @"合计:";
        UIFont * font  =[UIFont systemFontOfSize:12];
        
        //结算按钮
        _complete_Btn  = [UIButton buttonWithType:UIButtonTypeCustom];
        [_complete_Btn setTitle:@"结算(0)" forState:UIControlStateNormal];
        _complete_Btn.titleLabel.font =font;
        _complete_Btn.backgroundColor =HEXCOLOR(0xfe6d6a);
        _complete_Btn.frame =CGRectMake(KScreenW -100, 0, 100 , 49);
        [_complete_Btn addTarget:self action:@selector(didClickClearingShoppingCar:) forControlEvents:UIControlEventTouchUpInside];
        [_underFootView addSubview:_complete_Btn];
        
        
        //价格
        _totalPriceLabel = [[UILabel alloc]init];
        _totalPriceLabel.text = @"￥0.00";
        _totalPriceLabel.textAlignment = NSTextAlignmentLeft;
        _totalPriceLabel.font = font;
        _totalPriceLabel.textColor = HEXCOLOR(0xfe6d6a);
        CGSize lb_priceSize = [_totalPriceLabel.text sizeWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:font,NSFontAttributeName, nil]];
        CGFloat lb_priceSizeW = lb_priceSize.width;
        [_underFootView addSubview: _totalPriceLabel];
        
        [_totalPriceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(_complete_Btn.mas_left).with.offset(-10);
            make.centerY.equalTo(_complete_Btn.mas_centerY);
            make.size.mas_equalTo(CGSizeMake(lb_priceSizeW+30, 20));
        }];
        
        //合计
        UILabel * lb_order = [[UILabel alloc]init];
        lb_order.text= caseOrder;
        lb_order.font = font;
        lb_order.textColor = HEXCOLOR(0x363636);
        CGSize lb_orderSiez = [caseOrder sizeWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:font,NSFontAttributeName, nil]];
        CGFloat lb_orderW = lb_orderSiez.width;
        [_underFootView addSubview:lb_order];
        
        [lb_order mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(_totalPriceLabel.mas_left).with.offset(-5);
            make.centerY.equalTo(_complete_Btn.mas_centerY);
            make.size.mas_equalTo(CGSizeMake(lb_orderW+10, 20));
        }];
        
        _allSelectedButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_allSelectedButton addTarget:self action:@selector(clickAllGoodsSelected:) forControlEvents:UIControlEventTouchUpInside];
        [_allSelectedButton setImage:[UIImage imageNamed:@"select_normal"] forState:UIControlStateNormal];
        [_allSelectedButton setImage:[UIImage imageNamed:@"select_selected"] forState:UIControlStateSelected];
        [_underFootView addSubview:_allSelectedButton];
        
        [_allSelectedButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_underFootView).with.offset(15);
            make.centerY.equalTo(_complete_Btn.mas_centerY);
            make.size.mas_equalTo(CGSizeMake(24, 24));
            
        }];
        
        //全选
        UILabel * lb_chooseAll = [UILabel new];
        lb_chooseAll.text = @"全选";
        lb_chooseAll.textColor = HEXCOLOR(0x363636);
        lb_chooseAll.font = font;
        [_underFootView addSubview:lb_chooseAll];
        [lb_chooseAll mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_allSelectedButton.mas_right).with.offset(10);
            make.centerY.equalTo(_complete_Btn.mas_centerY);
            make.size.mas_equalTo(CGSizeMake(30, 20));
        }];
    }
    
    return _underFootView;
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



#pragma mark - 购物车列表网络请求 getShoppingCartList
-(void)shoppingCarPostRequst
{
    NSDictionary * parma = @{
                             
                             @"svcName":@"getShoppingCartList",
                             @"cmUserId":BBUserDefault.cmUserId,
                             
                             };
    
    NSDictionary *parmaDic=[NSDictionary dictionaryWithDictionary:parma];
    __weak typeof(self)weakSelf = self;

    [PPNetworkHelper POST:ZFB_11SendMessageUrl parameters:parmaDic responseCache:^(id responseCache) {
        
    } success:^(id responseObject) {
        
        if ([responseObject[@"resultCode"] isEqualToString:@"0"]) {
            
            if (![self isEmptyArray:weakSelf.carListArray]) {
                
                [self.carListArray  removeAllObjects];
                
            }else{
                
                NSString  * dataStr= [responseObject[@"data"] base64DecodedString];
                //JSON字符串转化为字典
                NSDictionary * jsondic = [NSString dictionaryWithJsonString:dataStr];
                
                NSArray * dictArray = jsondic [@"shoppCartList"];
                
                NSArray *storArray = [Shoppcartlist mj_objectArrayWithKeyValuesArray:dictArray];
                
                for (Shoppcartlist *lists in storArray) {
                    
                    [weakSelf.carListArray addObject:lists];
                }
                NSLog(@"carListArray = %@",   weakSelf.carListArray);
                
                [weakSelf.shopCar_tableview reloadData];
            }

        }
        
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
        [self.view makeToast:@"网络错误" duration:2 position:@"center"];
    }];
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
