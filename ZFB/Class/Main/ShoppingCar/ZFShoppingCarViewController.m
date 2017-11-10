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

@end

@implementation ZFShoppingCarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title                        = @"购物车";
    [self.shopCar_tableview registerNib:[UINib nibWithNibName:shopCarContenCellID bundle:nil]
                 forCellReuseIdentifier:shopCarContenCellID];
    [self.shopCar_tableview registerNib:[UINib nibWithNibName:shoppingHeaderID bundle:nil]
                 forCellReuseIdentifier:shoppingHeaderID];
    
    [self.view addSubview:self.underFootView];
    [self.view addSubview:_shopCar_tableview];

    self.allSelectedButton.selected = NO;
    self.complete_Btn.selected      = NO;
    
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


-(UITableView *)shopCar_tableview
{
    if (!_shopCar_tableview) {
        
        _shopCar_tableview =[[UITableView alloc]initWithFrame:CGRectMake(0, 0, KScreenW, KScreenH-49-64) style:UITableViewStyleGrouped];
        _shopCar_tableview.delegate       = self;
        _shopCar_tableview.dataSource     = self;
        _shopCar_tableview.estimatedRowHeight = 0;
        _shopCar_tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return _shopCar_tableview;
}

-(UIView *)underFootView
{
    if (!_underFootView) {
        _underFootView                 = [[UIView alloc]initWithFrame:CGRectMake(0,  KScreenH-49-64, KScreenW, 49)];
        _underFootView.backgroundColor = [UIColor whiteColor];
        UIFont * font  =[UIFont systemFontOfSize:14];
        
        //结算按钮
        _complete_Btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_complete_Btn setTitle:@"结算" forState:UIControlStateNormal];
        _complete_Btn.titleLabel.font = font;
        _complete_Btn.backgroundColor = HEXCOLOR(0xf95a70);
        _complete_Btn.frame           = CGRectMake(KScreenW -100, 0, 100 , 49);
        [_complete_Btn addTarget:self action:@selector(didClickClearingShoppingCar:) forControlEvents:UIControlEventTouchUpInside];
        [_underFootView addSubview:_complete_Btn];
        
        //全选按钮
        _allSelectedButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_allSelectedButton addTarget:self action:@selector(clickAllGoodsSelected:) forControlEvents:UIControlEventTouchUpInside];
        [_allSelectedButton setImage:[UIImage imageNamed:@"unchecked"] forState:UIControlStateNormal];
        [_allSelectedButton setImage:[UIImage imageNamed:@"selected2"] forState:UIControlStateSelected];
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
        
        
        
        //合计
        UILabel * lb_order  = [[UILabel alloc]init];
        lb_order.text       = @"合计:";
        lb_order.font       = font;
        lb_order.textColor  = HEXCOLOR(0x363636);
        [_underFootView addSubview:lb_order];
        
        [lb_order mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(lb_chooseAll.mas_right).with.offset(20);
            make.centerY.equalTo(_complete_Btn.mas_centerY);
            make.size.mas_equalTo(CGSizeMake(40, 20));
        }];
        
        //价格
        _totalPriceLabel               = [[UILabel alloc]init];
        _totalPriceLabel.text          = @"￥0.00";
        _totalPriceLabel.textAlignment = NSTextAlignmentLeft;
        _totalPriceLabel.font          = font;
        _totalPriceLabel.textColor     = HEXCOLOR(0xf95a70);
        CGSize lb_priceSize            = [_totalPriceLabel.text sizeWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:font,NSFontAttributeName, nil]];
        CGFloat lb_priceSizeW          = lb_priceSize.width;
        [_underFootView addSubview: _totalPriceLabel];
        
        [_totalPriceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(lb_order.mas_right).with.offset(10);
            make.right.equalTo(_complete_Btn.mas_left).with.offset(-10);
            make.centerY.equalTo(_complete_Btn.mas_centerY);
            make.size.mas_equalTo(CGSizeMake(lb_priceSizeW+30, 20));
        }];
        
    }
    return _underFootView;
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
    return actualHeight >= 140 ? actualHeight : 130;
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
    
    if ([self isEmptyArray:goodslist.goodsProp]) {
        NSLog(@"这是个空数组");
        cell.lb_prod.text = @"";
        cell.lb_editprod.text = @"";
        
    }else{
        NSMutableArray * mutNameArray = [NSMutableArray array];
        for (ShopGoodsprop * pro in goodslist.goodsProp) {
            NSString * value =  pro.value;
            [mutNameArray addObject:value];
            NSLog(@"name = %@",value);
        }
        cell.lb_prod.text = [NSString stringWithFormat:@"规格:%@",[mutNameArray componentsJoinedByString:@" "]];
        cell.lb_editprod.text = [NSString stringWithFormat:@"规格:%@",[mutNameArray componentsJoinedByString:@" "]];
    }
    
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
    // 每次点击都要统计底部的按钮是否全选
    self.allSelectedButton.selected = [self isAllProcductChoosed];
    [self.shopCar_tableview reloadData];
    
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
    
    // 每次点击都要统计底部的按钮是否全选
    self.allSelectedButton.selected = [self isAllProcductChoosed];
    [self.shopCar_tableview reloadData];
    [self.complete_Btn setTitle:[NSString stringWithFormat:@"结算"] forState:UIControlStateNormal];
    self.totalPriceLabel.text = [NSString stringWithFormat:@"￥%.2f",[self countTotalPrice]];
    
}


#pragma mark - 点击底部全选按钮 clickAllGoodsSelected:
- (void)clickAllGoodsSelected:(UIButton *)sender {
    
    NSLog(@"所有全选");
    sender.selected = !sender.selected;
    
    for (Shoppcartlist *list in self.carListArray) {
        
        list.leftShoppcartlistIsChoosed = sender.selected;
        
        for (ShopGoodslist * goods in list.goodsList) {
            
            goods.goodslistIsChoosed = list.leftShoppcartlistIsChoosed;
        }
    }
    
    [self.shopCar_tableview reloadData];
    CGFloat totalPrice = [self countTotalPrice];
    [self.complete_Btn setTitle:[NSString stringWithFormat:@"结算"] forState:UIControlStateNormal];
    self.totalPriceLabel.text = [NSString stringWithFormat:@"￥%.2f",totalPrice];
    
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
    self.totalPriceLabel.text       = [NSString stringWithFormat:@"￥%.2f",[self countTotalPrice]];
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
            [self updateGoodsNubBuycount:[NSString stringWithFormat:@"%ld",goods.goodsCount] AndcartItemId:goods.cartItemId];
            
        }
    }
    else if (tag == 666)
    {
        goods.goodsCount ++;
        [self updateGoodsNubBuycount:[NSString stringWithFormat:@"%ld",goods.goodsCount] AndcartItemId:goods.cartItemId];
    }
    
    self.totalPriceLabel.text = [NSString stringWithFormat:@"￥%.2f",[self countTotalPrice]];
    [self.shopCar_tableview reloadData];
    
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
    
    self.allSelectedButton.selected = NO;
    self.totalPriceLabel.text = @"¥0.00元";
    [self.shopCar_tableview reloadData];
    
}

#pragma mark - getShoppCartUpdate 更新商品数量
-(void)updateGoodsNubBuycount:(NSString *)buyCount AndcartItemId:(NSString *)cartItemId
{
    NSDictionary  * param = @{
                              @"cartItemId":cartItemId,
                              @"buyNum":buyCount,
                              };
    [MENetWorkManager post:[NSString stringWithFormat:@"%@/getShoppCartUpdate",zfb_baseUrl] params:param success:^(id response) {
        
    } progress:^(NSProgress *progeress) {
        
    } failure:^(NSError *error) {
        
    }];
    
}
#pragma mark - didClickClearingShoppingCar 购物车结算
-(void)didClickClearingShoppingCar:(UIButton *)sender
{
    
    NSMutableArray * allJsonArray = [NSMutableArray array];
    [allJsonArray removeAllObjects];
    
    for (Shoppcartlist *list in self.carListArray) {
        
        NSMutableArray * mutGoodsArr = [NSMutableArray array];
        
        [mutGoodsArr removeAllObjects];
        for (ShopGoodslist * goods in list.goodsList) {
            
            if (goods.goodslistIsChoosed) {
                
                NSMutableDictionary * goodDic = [NSMutableDictionary dictionary];
                NSMutableArray  * goodsPropArr = [NSMutableArray array] ;
                NSArray *dictArray = [ShopGoodslist mj_keyValuesArrayWithObjectArray:goods.goodsProp];
                for (NSDictionary * value in dictArray) {
                    
                    [goodsPropArr addObject:value];
                }
                
                NSString * storeId = [NSString stringWithFormat:@"%ld",list.storeId];
                NSString * goodsId = [NSString stringWithFormat:@"%ld",goods.goodsId];
                NSString * goodsCount = [NSString stringWithFormat:@"%ld",goods.goodsCount];
                
                [goodDic setValue:storeId forKey:@"storeId"];
                [goodDic setValue:list.storeName forKey:@"storeName"];
                [goodDic setValue:goodsId forKey:@"goodsId"];
                [goodDic setValue:goods.goodsName forKey:@"goodsName"];
                [goodDic setValue:goods.coverImgUrl forKey:@"coverImgUrl"];
                [goodDic setValue:goods.productId forKey:@"productId"];
                [goodDic setValue:goodsCount forKey:@"goodsCount"];
                [goodDic setValue:goods.netPurchasePrice forKey:@"purchasePrice"];
                [goodDic setValue:goods.cartItemId forKey:@"cartItemId"];
                [goodDic setValue:@"0" forKey:@"concessionalPrice"];
                [goodDic setValue:@"0" forKey:@"originalPrice"];
                [goodDic setValue:goods.goodsUnit forKey:@"goodsUnit"];
                [goodDic setValue:goodsPropArr forKey:@"goodsProp"];
                if ( _shardId == nil) {
                    _shardId = @"";
                }
                if (_shareNum == nil) {
                    _shareNum = @"";
                }
                [goodDic setValue:_shardId forKey:@"shareId"];
                [goodDic setValue:_shareNum forKey:@"shareNum"];
                [mutGoodsArr addObject:goodDic];
            }
        }
        NSMutableDictionary * storeDic = [NSMutableDictionary dictionary];
        [storeDic setValue:mutGoodsArr forKey:@"goodsList"];
        [storeDic setValue:list.storeName forKey:@"storeName"];
        [storeDic setValue:[NSString stringWithFormat:@"%ld",list.storeId ]forKey:@"storeId"];
        [allJsonArray addObject:storeDic];
    }
    
    NSLog(@"我最后选中的数组222 %@",allJsonArray );
    
    
    ZFSureOrderViewController * orderVC = [[ZFSureOrderViewController alloc]init];
    //便利出所有的 cartItemId , 隔开
    NSMutableArray * cartArray = [NSMutableArray array];
    for (NSDictionary * storedict in allJsonArray) {
        for (NSDictionary * gooddic in storedict[@"goodsList"]) {
            
            [cartArray addObject:gooddic[@"cartItemId"]];
        }
    }
    if (![self isEmptyArray:cartArray])
    {
        orderVC.cartItemId = [cartArray componentsJoinedByString:@","];
        orderVC.userGoodsInfoJSON = allJsonArray;
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


-(void)viewWillAppear:(BOOL)animated
{
    [self settingNavBarBgName:@"nav64_gray"];

    if (BBUserDefault.isLogin == 1) {
        
        [self shoppingCarPostRequst];
        
    }else{
        
        [self isIfNotSignIn];
    }
    
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
