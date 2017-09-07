//
//  ZFShoppingCarViewController.m
//  ZFB
//
//  Created by  展富宝  on 2017/5/11.
//  Copyright © 2017年 com.zfb. All rights reserved.
//  ****购物车


#import "ZFShoppingCarViewController.h"
#import "ZFSureOrderViewController.h"
#import "DetailFindGoodsViewController.h"
#import "LoginViewController.h"

#import "ZFShopCarCell.h"
#import "ShoppingCarModel.h"

#import "ZFBaseNavigationViewController.h"
#import "ShopCarSectionHeadViewCell.h"

static NSString  * shopCarContenCellID = @"ZFShopCarCell";
static NSString  * shoppingHeaderID    = @"ShopCarSectionHeadViewCell";

@interface ZFShoppingCarViewController ()<UITableViewDelegate,UITableViewDataSource,ShoppingSelectedDelegate,ShopCarSectionHeadViewDelegate,CYLTableViewPlaceHolderDelegate, WeChatStylePlaceHolderDelegate>
{
    NSString * _cartItemId ;//购物车id
    NSString * _goodsCount; //商品数量
    
}
@property (nonatomic,strong) UITableView * shopCar_tableview;
@property (nonatomic,strong) UIView      * underFootView;

@property (nonatomic,strong) NSMutableArray * carListArray;
// 由于代理问题衍生出的来已经选择单个或者批量的数组装Cell
@property (nonatomic,strong) NSMutableArray *tempCellArray;


//////////////////////--underFootView--//////////////////////
@property (nonatomic,strong) UIButton    * complete_Btn;//结算按钮
@property (nonatomic,strong) UIButton    * allSelectedButton;//全选
@property (nonatomic,strong) UILabel     * totalPriceLabel;//价格
@property (nonatomic,copy  ) NSString    * buttonTitle ;
@property (nonatomic,copy  ) NSString    * price;

//////////////////////-- 保存为json回传后台--//////////////////////
@property (nonatomic,strong) NSMutableArray      * jsonGoodArray;
@property (nonatomic,strong) NSMutableDictionary * jsonDict;

//需要传到确认订单的数组
@property (nonatomic,strong) NSMutableArray * mutJsonArray;

@end

@implementation ZFShoppingCarViewController
-(NSMutableArray *)mutJsonArray
{
    if (!_mutJsonArray) {
        _mutJsonArray = [NSMutableArray array];
    }
    return _mutJsonArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self.shopCar_tableview registerNib:[UINib nibWithNibName:shopCarContenCellID bundle:nil]
                 forCellReuseIdentifier:shopCarContenCellID];
    [self.shopCar_tableview registerNib:[UINib nibWithNibName:shoppingHeaderID bundle:nil]
                 forCellReuseIdentifier:shoppingHeaderID];
    
    [self.view addSubview:self.underFootView];
    self.allSelectedButton.selected = NO;
    self.complete_Btn.selected      = NO;
    
}
-(void)viewWillAppear:(BOOL)animated
{
    if (BBUserDefault.isLogin == 1) {
        [self shoppingCarPostRequst];
        
    }else{
        
        NSLog(@"登录了");
        LoginViewController * logvc          = [ LoginViewController new];
        ZFBaseNavigationViewController * nav = [[ZFBaseNavigationViewController alloc]initWithRootViewController:logvc];
        
        [self presentViewController:nav animated:NO completion:^{
            
            [nav.navigationBar setBarTintColor:HEXCOLOR(0xfe6d6a)];
            [nav.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:HEXCOLOR(0xffffff),NSFontAttributeName:[UIFont systemFontOfSize:15.0]}];
        }];
    }
    
}
#pragma mark - ShoppingSelectedDelegate  自定义代理
#pragma mark - 商品编辑状态回调 shopCarEditingSelected
- (void)shopCarEditingSelected:(NSInteger)sectionIdx
{
    
    Shoppcartlist * list        = self.carListArray[sectionIdx];
    list.ShoppcartlistIsEditing = !list.ShoppcartlistIsEditing;
    [self.shopCar_tableview reloadData];
    
}
#pragma - 点击单个商品cell选择按钮 goodsSelected :isSelected
- (void)goodsSelected:(ZFShopCarCell *)cell isSelected:(BOOL)choosed
{
    NSLog(@"单个选择 == %d 整个section选中了吗" ,choosed);
    NSIndexPath *indexPath   = [self.shopCar_tableview indexPathForCell:cell];
    Shoppcartlist *list      = self.carListArray[indexPath.section];
    ShopGoodslist *goods     = list.goodsList[indexPath.row];
    goods.goodslistIsChoosed = !goods.goodslistIsChoosed;
    
    // 当点击单个的时候，判断是否该买手下面的商品是否全部选中
    __block NSInteger count = 0;
    [list.goodsList enumerateObjectsUsingBlock:^(ShopGoodslist *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (obj.goodslistIsChoosed)
        {
            count ++;
            //获取规格数据
            NSLog(@" 便利了count = %ld 次",count);
        }
    }];
    if (count == list.goodsList.count){
        list.leftShoppcartlistIsChoosed = YES;
        
    }else{
        list.leftShoppcartlistIsChoosed = NO;
        
    }
    //保存当前section选中的数据
    NSMutableArray * goodsChoosedArray = [NSMutableArray array];
    for (ShopGoodslist * goodsChoosed in list.goodsList) {
        //如果选中单个商品了
        if (goodsChoosed.goodslistIsChoosed) {
            
            NSMutableDictionary * tempDic = [NSMutableDictionary dictionary];
            NSString * goodsId = [NSString stringWithFormat:@"%ld",goodsChoosed.goodsId];
            NSString * storeId = [NSString stringWithFormat:@"%ld",list.storeId];
            NSString * goodsCount = [NSString stringWithFormat:@"%ld",goodsChoosed.goodsCount];
            
            [tempDic setValue:storeId forKey:@"storeId"];
            [tempDic setValue:goodsId forKey:@"goodsId"];
            [tempDic setValue:goodsChoosed.goodsName forKey:@"goodsName"];
            [tempDic setValue:goodsChoosed.coverImgUrl forKey:@"coverImgUrl"];
            [tempDic setValue:goodsChoosed.goodsProp forKey:@"goodsProp"];
            [tempDic setValue:goodsCount forKey:@"goodsCount"];
            [tempDic setValue:goodsChoosed.netPurchasePrice forKey:@"purchasePrice"];
            [tempDic setValue:@"0" forKey:@"concessionalPrice"];
            [tempDic setValue:@"0" forKey:@"originalPrice"];
            [tempDic setValue:goodsChoosed.goodsUnit forKey:@"goodsUnit"];
            [tempDic setValue:goodsChoosed.cartItemId forKey:@"cartItemId"];
            
            [goodsChoosedArray addObject:tempDic];
        }
//
//                    NSLog(@"我选中了吗啊 ---------%d --- %d",goodsChoosed.goodslistIsChoosed,list.leftShoppcartlistIsChoosed);
//            if (list.leftShoppcartlistIsChoosed == NO) {
//                NSIndexSet * indexSet = [self.mutJsonArray indexesOfObjectsPassingTest:^BOOL(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
//                    
//                    return idx;
//                }];
//                [self.mutJsonArray removeObjectsAtIndexes:indexSet];
//                NSLog(@"%@",indexSet);
//            }
//            
//        }
    }
    NSLog(@"========选中单个商品的数据%@",goodsChoosedArray);
    [self.shopCar_tableview reloadData];
    
    
    
    // 每次点击都要统计底部的按钮是否全选
    self.allSelectedButton.selected = [self isAllProcductChoosed];
    [self.complete_Btn setTitle:[NSString stringWithFormat:@"结算"] forState:UIControlStateNormal];
    self.totalPriceLabel.text = [NSString stringWithFormat:@"￥%.2f",[self countTotalPrice]];
    
}

#pragma mark - section 全选 shopStoreSelected
- (void)shopStoreSelected:(NSInteger)sectionIndex
{
    NSLog(@" 全选当前section ,sectionIndex == %ld ",sectionIndex);
    Shoppcartlist *list             = self.carListArray[sectionIndex];
    list.leftShoppcartlistIsChoosed = !list.leftShoppcartlistIsChoosed;
    
    //遍历数组元素
    [list.goodsList enumerateObjectsUsingBlock:^(ShopGoodslist *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        obj.goodslistIsChoosed = list.leftShoppcartlistIsChoosed;
        
    }];
    

    for (ShopGoodslist * goods in list.goodsList) {
        
        //如果选中了所有 并且选中了全部
        if (list.leftShoppcartlistIsChoosed) {
            
            NSMutableDictionary * tempDic = [NSMutableDictionary dictionary];
            NSString * goodsId = [NSString stringWithFormat:@"%ld",goods.goodsId];
            NSString * storeId = [NSString stringWithFormat:@"%ld",list.storeId];
            NSString * goodsCount = [NSString stringWithFormat:@"%ld",goods.goodsCount];
            
            [tempDic setValue:storeId forKey:@"storeId"];
            [tempDic setValue:goodsId forKey:@"goodsId"];
            [tempDic setValue:goods.goodsName forKey:@"goodsName"];
            [tempDic setValue:goods.coverImgUrl forKey:@"coverImgUrl"];
            [tempDic setValue:goods.goodsProp forKey:@"goodsProp"];
            [tempDic setValue:goodsCount forKey:@"goodsCount"];
            [tempDic setValue:goods.netPurchasePrice forKey:@"purchasePrice"];
            [tempDic setValue:@"0" forKey:@"concessionalPrice"];
            [tempDic setValue:@"0" forKey:@"originalPrice"];
            [tempDic setValue:goods.goodsUnit forKey:@"goodsUnit"];
            [tempDic setValue:goods.cartItemId forKey:@"cartItemId"];

            [self.mutJsonArray addObject:tempDic];
            
        }else{
            if (  list.leftShoppcartlistIsChoosed == NO && goods.goodslistIsChoosed == NO) {
              
                NSLog(@"========取消当前选中的Sction 所有数据 %@",self.mutJsonArray);
                [self.mutJsonArray removeAllObjects];
            }

        }
    }
    NSLog(@"========选中整个Sction 的商品的数据%@",self.mutJsonArray);
    // 每次点击都要统计底部的按钮是否全选
    self.allSelectedButton.selected = [self isAllProcductChoosed];
    [self.shopCar_tableview reloadData];
    [self.complete_Btn setTitle:[NSString stringWithFormat:@"结算"] forState:UIControlStateNormal];
    self.totalPriceLabel.text = [NSString stringWithFormat:@"￥%.2f元",[self countTotalPrice]];
    
}


#pragma mark - 点击底部全选按钮 clickAllGoodsSelected:
- (void)clickAllGoodsSelected:(UIButton *)sender {
    
    NSLog(@"所有全选");
    sender.selected = !sender.selected;
    
    if (self.mutJsonArray.count > 0) {
        
        [self.mutJsonArray removeAllObjects];
    }
    
    for (Shoppcartlist *list in self.carListArray) {
        
        list.leftShoppcartlistIsChoosed = sender.selected;
        
        for (ShopGoodslist * goods in list.goodsList) {
            
            goods.goodslistIsChoosed = list.leftShoppcartlistIsChoosed;

            if (list.leftShoppcartlistIsChoosed == YES) {
                
                NSMutableDictionary * tempDic = [NSMutableDictionary dictionary];
                NSString * goodsId = [NSString stringWithFormat:@"%ld",goods.goodsId];
                NSString * storeId = [NSString stringWithFormat:@"%ld",list.storeId];
                NSString * goodsCount = [NSString stringWithFormat:@"%ld",goods.goodsCount];
                
                [tempDic setValue:storeId forKey:@"storeId"];
                [tempDic setValue:goodsId forKey:@"goodsId"];
                [tempDic setValue:goods.goodsName forKey:@"goodsName"];
                [tempDic setValue:goods.coverImgUrl forKey:@"coverImgUrl"];
                [tempDic setValue:goods.goodsProp forKey:@"goodsProp"];
                [tempDic setValue:goodsCount forKey:@"goodsCount"];
                [tempDic setValue:goods.netPurchasePrice forKey:@"purchasePrice"];
                [tempDic setValue:@"0" forKey:@"concessionalPrice"];
                [tempDic setValue:@"0" forKey:@"originalPrice"];
                [tempDic setValue:goods.goodsUnit forKey:@"goodsUnit"];
                [tempDic setValue:goods.cartItemId forKey:@"cartItemId"];

                [self.mutJsonArray addObject:tempDic];
                
            }
            if (![self isAllProcductChoosed] && list.leftShoppcartlistIsChoosed == NO && goods.goodslistIsChoosed == NO) {
                //如没有没有选择取消全部
                if (self.mutJsonArray.count > 0) {
                    
                    [self.mutJsonArray removeAllObjects];
                }
            }
        }
    }
    NSLog(@"========选中all所有 的商品的数据%@",self.mutJsonArray);
    
    [self.shopCar_tableview reloadData];
    CGFloat totalPrice = [self countTotalPrice];
    [self.complete_Btn setTitle:[NSString stringWithFormat:@"结算"] forState:UIControlStateNormal];
    self.totalPriceLabel.text = [NSString stringWithFormat:@"￥%.2f元",totalPrice];
    
}

#pragma mark - 删除数据
- (void)deleteRabishClick:(ZFShopCarCell *)cell
{
    [self.tempCellArray removeAllObjects];
    [self.tempCellArray addObject:cell];
    
    JXTAlertController * alertVC = [JXTAlertController alertControllerWithTitle:@"确认删除？" message:nil preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction * cancel       = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    UIAlertAction * sure = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        
        NSIndexPath *indexpath = [self.shopCar_tableview indexPathForCell:self.tempCellArray.firstObject];
        Shoppcartlist * list = self.carListArray[indexpath.section];
        ShopGoodslist *goods = list.goodsList[indexpath.row];
        if (list.goodsList.count == 1) {
            
            [self.carListArray removeObject:list];
        }
        else
        {
            [list.goodsList removeObject:goods];
        }
        _cartItemId = goods.cartItemId;//取到购物车id
        
        [self deleteShoppingCarPostRequst];
        
    }];
    
    [alertVC addAction:cancel];
    [alertVC addAction:sure];
    [self presentViewController:alertVC animated:YES completion:nil];
}
#pragma mark - 删除之后一些列更新操作
- (void)updateInfomation
{
    // 会影响到对应的选择
    NSInteger count = 0;
    for (Shoppcartlist * list in self.carListArray) {
        for (ShopGoodslist *goods in list.goodsList) {
            if (goods.goodslistIsChoosed) {
                count ++;
            }
        }
        if (count == list.goodsList.count) {
            
            list.leftShoppcartlistIsChoosed = YES;
        }
    }
    // 再次影响到全部选择按钮
    self.allSelectedButton.selected = [self isAllProcductChoosed];
    self.totalPriceLabel.text       = [NSString stringWithFormat:@"￥%.2f元",[self countTotalPrice]];
    [self.complete_Btn setTitle:[NSString stringWithFormat:@"结算"] forState:UIControlStateNormal];
    [self.shopCar_tableview reloadData];
    
}


#pragma mark -增加或者减少商品
-(void)addOrReduceCount:(ZFShopCarCell *)cell tag:(NSInteger)tag
{
    NSIndexPath *indexpath = [self.shopCar_tableview indexPathForCell:cell];
    Shoppcartlist *list    = self.carListArray[indexpath.section];
    ShopGoodslist * goods  = list.goodsList[indexpath.row];
    
    if (tag == 555)
    {
        if (goods.goodsCount <= 1) {
            
            NSLog(@" 加减操作 ===== %ld", goods.goodsCount);
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
    
    self.totalPriceLabel.text = [NSString stringWithFormat:@"￥%.2f元",[self countTotalPrice]];
    [self.shopCar_tableview reloadData];
    
}

#pragma mark - tableView delegare
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.carListArray.count;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    Shoppcartlist * list = self.carListArray[section];
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
    Shoppcartlist * list             = self.carListArray[section];
    ShopCarSectionHeadViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ShopCarSectionHeadViewCell"];
    cell.chooseStore_btn.selected    = list.leftShoppcartlistIsChoosed;//!<  是否需要勾选的字段
    cell.lb_storeName.text           = list.storeName;
    cell.sectionIndex                = section;
    cell.editStore_btn.selected      = list.ShoppcartlistIsEditing;//是否处于编辑
    cell.delegate                    = self;
    
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
    shopCell.selectDelegate  = self;
    
    [self configCell:shopCell indexPath:indexPath];
    return shopCell;
    
}
// 组装cell
- (void)configCell:(ZFShopCarCell *)cell indexPath:(NSIndexPath *)indexPath
{
    Shoppcartlist * shopList = self.carListArray[indexPath.section];
    ShopGoodslist *goodslist = shopList.goodsList[indexPath.row];
    
    cell.chooseBtn.selected = goodslist.goodslistIsChoosed;//!< 商品是否需要选择的字段
    [cell.img_shopCar sd_setImageWithURL:[NSURL URLWithString:goodslist.coverImgUrl] placeholderImage:[UIImage imageNamed:@""]];
    
    cell.lb_price.text  = [NSString stringWithFormat:@"¥%@",goodslist.netPurchasePrice];
    cell.lb_title.text  = goodslist.goodsName;
    cell.tf_result.text = [NSString stringWithFormat:@"%ld",goodslist.goodsCount];
    
    cell.editlb_price.text  = [NSString stringWithFormat:@"¥%@",goodslist.netPurchasePrice];
    cell.editlb_title.text  = goodslist.goodsName;
    cell.editTf_result.text = [NSString stringWithFormat:@"%.ld",goodslist.goodsCount];
    
    // 正常模式下面 非编辑
    if (!shopList.ShoppcartlistIsEditing)
    {
        cell.normalBackView.hidden = NO;
        cell.editBackView.hidden   = YES;
    }
    else
    {
        cell.normalBackView.hidden = YES;
        cell.editBackView.hidden   = NO;
    }
    
}
-(void)ChangeGoodsNumberCell:(ZFShopCarCell *)cell Number:(NSInteger)num
{
    
#warning ------ 没有处理价格加减 乘
    NSLog(@"num = %ld ",num );
}

#pragma mark - tableView datasource
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //    DetailFindGoodsViewController *deatilGoods =[[DetailFindGoodsViewController alloc]init];
    //    NSLog(@" section = %ld ， row = %ld",indexPath.section,indexPath.row);
    //    if (self.carListArray.count > 0 ) {
    //        Goodslist * goodlist = self.carListArray[indexPath.row];
    //        deatilGoods.goodsId  = goodlist.goodsId;
    //
    //    }
    //    [self.navigationController pushViewController:deatilGoods animated:YES];
    
}

#pragma mark - 计算商品被选择了数量
- (NSInteger)countTotalSelectedNumber
{
    NSInteger count = 0;
    for (Shoppcartlist *list in self.carListArray) {
        for (ShopGoodslist *goods in list.goodsList) {
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
            for (ShopGoodslist * goods  in list.goodsList) {
                totalPrice += [goods.netPurchasePrice floatValue]  * goods.goodsCount;
            }
        }else{
            for (ShopGoodslist * goods  in list.goodsList) {
                if (goods.goodslistIsChoosed) {
                    totalPrice += [goods.netPurchasePrice floatValue] * goods.goodsCount;
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
        self.title                        = @"购物车";
        _shopCar_tableview =[[UITableView alloc]initWithFrame:CGRectMake(0, 64, KScreenW, KScreenH-64-49) style:UITableViewStyleGrouped];
        _shopCar_tableview.delegate       = self;
        _shopCar_tableview.dataSource     = self;
        _shopCar_tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
        [self.view addSubview:_shopCar_tableview];
    }
    return _shopCar_tableview;
}

-(UIView *)underFootView
{
    if (!_underFootView) {
        _underFootView                 = [[UIView alloc]initWithFrame:CGRectMake(0, KScreenH -49, KScreenW,  KScreenH -49-64)];
        _underFootView.backgroundColor = [UIColor whiteColor];
        
        NSString *caseOrder = @"合计:";
        UIFont * font  =[UIFont systemFontOfSize:12];
        
        //结算按钮
        _complete_Btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_complete_Btn setTitle:@"结算" forState:UIControlStateNormal];
        _complete_Btn.titleLabel.font = font;
        _complete_Btn.backgroundColor = HEXCOLOR(0xfe6d6a);
        _complete_Btn.frame           = CGRectMake(KScreenW -100, 0, 100 , 49);
        [_complete_Btn addTarget:self action:@selector(didClickClearingShoppingCar:) forControlEvents:UIControlEventTouchUpInside];
        [_underFootView addSubview:_complete_Btn];
        
        
        //价格
        _totalPriceLabel               = [[UILabel alloc]init];
        _totalPriceLabel.text          = @"￥0.00";
        _totalPriceLabel.textAlignment = NSTextAlignmentLeft;
        _totalPriceLabel.font          = font;
        _totalPriceLabel.textColor     = HEXCOLOR(0xfe6d6a);
        CGSize lb_priceSize            = [_totalPriceLabel.text sizeWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:font,NSFontAttributeName, nil]];
        CGFloat lb_priceSizeW          = lb_priceSize.width;
        
        NSLog(@"%f",lb_priceSizeW);
        [_underFootView addSubview: _totalPriceLabel];
        
        [_totalPriceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(_complete_Btn.mas_left).with.offset(-10);
            make.centerY.equalTo(_complete_Btn.mas_centerY);
            make.size.mas_equalTo(CGSizeMake(lb_priceSizeW+30, 20));
        }];
        
        //合计
        UILabel * lb_order  = [[UILabel alloc]init];
        lb_order.text       = caseOrder;
        lb_order.font       = font;
        lb_order.textColor  = HEXCOLOR(0x363636);
        CGSize lb_orderSiez = [caseOrder sizeWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:font,NSFontAttributeName, nil]];
        CGFloat lb_orderW   = lb_orderSiez.width;
        [_underFootView addSubview:lb_order];
        
        [lb_order mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(_totalPriceLabel.mas_left).with.offset(-5);
            make.centerY.equalTo(_complete_Btn.mas_centerY);
            make.size.mas_equalTo(CGSizeMake(lb_orderW+10, 20));
        }];
        
        _allSelectedButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_allSelectedButton addTarget:self action:@selector(clickAllGoodsSelected:) forControlEvents:UIControlEventTouchUpInside];
        [_allSelectedButton setImage:[UIImage imageNamed:@"select_normal"] forState:UIControlStateNormal];
        [_allSelectedButton setImage:[UIImage imageNamed:@"select_red"] forState:UIControlStateSelected];
        [_underFootView addSubview:_allSelectedButton];
        
        [_allSelectedButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_underFootView).with.offset(15);
            make.centerY.equalTo(_complete_Btn.mas_centerY);
            make.size.mas_equalTo(CGSizeMake(24, 24));
            
        }];
        
        //全选
        UILabel * lb_chooseAll = [UILabel new];
        lb_chooseAll.text      = @"全选";
        lb_chooseAll.textColor = HEXCOLOR(0x363636);
        lb_chooseAll.font      = font;
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
- (NSMutableArray *)tempCellArray
{
    if (_tempCellArray == nil) {
        _tempCellArray = [[NSMutableArray alloc] init];
    }
    return _tempCellArray;
}

#pragma mark - 购物车列表网络请求 getShoppCartList
-(void)shoppingCarPostRequst
{
    NSDictionary * parma = @{
                             
                             @"cmUserId":BBUserDefault.cmUserId,
                             };
    
    [SVProgressHUD show];
    [MENetWorkManager post:[zfb_baseUrl stringByAppendingString:@"/getShoppCartList"] params:parma success:^(id response) {
        
        if ([response[@"resultCode"] intValue] == 0 ) {
            
            if (self.carListArray.count > 0) {
                
                [self.carListArray  removeAllObjects];
            }
            
            ShoppingCarModel * shopModel = [ShoppingCarModel mj_objectWithKeyValues:response];
            for (Shoppcartlist * list in shopModel.shoppCartList) {
                [self.carListArray addObject:list];
            }
            [SVProgressHUD dismiss];
            [self.shopCar_tableview reloadData];
            
            if ([self isEmptyArray:self.carListArray]) {
                [self.shopCar_tableview cyl_reloadData];
            }
        }

    } progress:^(NSProgress *progeress) {
        
    } failure:^(NSError *error) {
        
        [SVProgressHUD dismiss];
        NSLog(@"error=====%@",error);
        [self.view makeToast:@"网络错误" duration:2 position:@"center"];
    }];
    
}

#pragma mark - 删除网络请求后一些列更新操作delShoppingCart
-(void)deleteShoppingCarPostRequst
{
    NSDictionary * parma = @{
                             
                             @"cmUserId":BBUserDefault.cmUserId,
                             @"cartItemId":_cartItemId,
                             
                             };
    
    
    [MENetWorkManager post:[zfb_baseUrl stringByAppendingString:@"/delShoppingCart"] params:parma success:^(id response) {
        
        
        [self.view makeToast:response[@"resultMsg"] duration:2 position:@"center"];
        [self.shopCar_tableview reloadData];
        
    } progress:^(NSProgress *progeress) {
        
    } failure:^(NSError *error) {
        
        NSLog(@"error=====%@",error);
        [self.view makeToast:@"网络错误" duration:2 position:@"center"];
    }];
}

//////////////////////-- 保存为json回传后台--//////////////////////
-(NSMutableArray *)jsonGoodArray
{
    if (!_jsonGoodArray ) {
        _jsonGoodArray = [NSMutableArray array];
    }
    return _jsonGoodArray;
}


#pragma mark - CYLTableViewPlaceHolderDelegate Method
- (UIView *)makePlaceHolderView {
    
    UIView *weChatStyle = [self weChatStylePlaceHolder];
    return weChatStyle;
}
//暂无数据
- (UIView *)weChatStylePlaceHolder {
    WeChatStylePlaceHolder *weChatStylePlaceHolder = [[WeChatStylePlaceHolder alloc] initWithFrame:self.shopCar_tableview.frame];
    weChatStylePlaceHolder.delegate = self;
    return weChatStylePlaceHolder;
}
#pragma mark - WeChatStylePlaceHolderDelegate Method
- (void)emptyOverlayClicked:(id)sender {
    
    [self shoppingCarPostRequst];
}


#pragma mark -当购物车页面消失后   取消选中
-(void)viewWillDisappear:(BOOL)animated
{
    [SVProgressHUD dismiss];
}


#pragma mark - didClickClearingShoppingCar 购物车结算
-(void)didClickClearingShoppingCar:(UIButton *)sender
{
    NSLog(@" 结算");
    
#warning  ----- 进入到结算前提是要选择一个商品 暂时没有处理
    ZFSureOrderViewController * orderVC = [[ZFSureOrderViewController alloc]init];
    if (![self isEmptyArray:self.mutJsonArray])
    {
        //便利出所有的 cartItemId , 隔开
        NSMutableArray * cartArray = [NSMutableArray array];
        for (NSDictionary * dict in self.mutJsonArray) {
            [cartArray addObject:dict[@"cartItemId"]];
        }
        orderVC.cartItemId = [cartArray componentsJoinedByString:@","];
        orderVC.userGoodsInfoJSON =  self.mutJsonArray;
        [self.navigationController pushViewController:orderVC animated:YES];
        
    }
    else{
        JXTAlertController * alert = [JXTAlertController alertControllerWithTitle:nil message:@"您还没有选择商品" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction * action     = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        [alert addAction:action];
        [self presentViewController:alert animated:YES completion:nil];
    }
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
