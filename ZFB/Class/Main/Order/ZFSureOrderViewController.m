
//
//  ZFSureOrderViewController.m
//  ZFB
//
//  Created by  展富宝  on 2017/5/24.
//  Copyright © 2017年 com.zfb. All rights reserved.
//

#import "ZFSureOrderViewController.h"
//cell
#import "ZFOrderListCell.h"
#import "OrderWithAddressCell.h"
#import "OrderPriceCell.h"
#import "SureOrderCommonCell.h"
#import "SureOrderChooseTypeCell.h"//是否自提
//view
#import "SelectPayTypeView.h"//选择支付方式

//vc
#import "ZFAddressListViewController.h"
#import "ZFShopListViewController.h"
#import "AddressCommitOrderModel.h"
#import "ZFMainPayforViewController.h"
#import "ZFSelectCouponViewController.h"
#import "ZFBaseNavigationViewController.h"
#import "ZFAllOrderViewController.h"

//model
#import "AddressListModel.h"
#import "JsonModel.h"
#import "SureOrderModel.h"
#import "CommitOrderlist.h"
#import "CouponModel.h"
//wx
#import "MXWechatPayHandler.h"
#import "CheckstandViewController.h"//收银台

typedef NS_ENUM(NSUInteger, SureOrderCellType) {
    
    SureOrderCellTypeAddressCell = 0,//收货地址
    SureOrderCellTypeGoodsListCell,//商品清单
    SureOrderCellTypePayTypeCell,//支付类型
    SureOrderCellTypeChooseGetTypeCell,//是否自提
    SureOrderCellTypeCouponCell,//优惠券
    SureOrderCellTypeMoneyOrFreeCell,//配送费和金额
    
};

@interface ZFSureOrderViewController ()<UITableViewDelegate ,UITableViewDataSource,SelectPayTypeViewDelegate>
{
    NSString * _contactUserName;
    NSString * _postAddress;
    NSString * _contactMobilePhone;
    NSString * _postAddressId;//收货地址id
    
    NSString * _goodsCount;//商品总价
    NSString * _costNum;//配送费
    NSString * _userCostNum;//支付总金额
    NSString * _orderDeliveryfee;//每家门店的配送费
    
    NSString * _datetime;
    NSString * _access_token;
    
    NSString * _payType;// 0 在线支付，1 门店支付
    NSString * _storeIdAppding;
    NSString * _goodsIdAppding;
    ////使用范围   回传字段
    NSString * _useRange;
    NSString * _couponId;
    NSString * _couponAmount;//优惠的价格
    NSString * _couponStoreId;
    NSString * _couponGoodsIds;
    
    //totalPirce 最后支付的价格
    NSString * _totalPirce;
    
    //存放生成订单数组
    NSArray  * _orderArr ;
    NSString * _notify_url;
    NSString * _return_url;
    NSString * _gateWay_url;
    NSString * _goback_url;
    NSString * _paySign;//获取签名

}

@property (nonatomic,strong) UITableView * mytableView;
@property (nonatomic,strong) UIView      * footerView;
@property (nonatomic,strong) UILabel     * lb_price;

@property (nonatomic,strong) NSMutableArray * goodsListArray;//用来接收的商品数组
@property (nonatomic,strong) NSMutableArray * cmGoodsListArray;//cmgoodslist
@property (nonatomic,strong) NSMutableArray * storelistArry;//门店数组
@property (nonatomic ,strong) NSMutableArray * couponList;//优惠券数组

@property (nonatomic,strong) NSMutableArray    * storeAttachListArr;//有备注的数组
@property (nonatomic,strong) NSMutableArray    * storeDeliveryfeeListArr;//配送费数组
@property (nonatomic,assign) SureOrderCellType orderCellType;
@property (nonatomic,strong) SelectPayTypeView * selectPayView;//选择支付方式
@property (nonatomic,strong) UIView            * popCouponBackgroundView;//背景





@end

@implementation ZFSureOrderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"确认订单";
    _payType = @"1";//默认为线上支付
    
    self.mytableView                = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, KScreenW, KScreenH -49-64) style:UITableViewStylePlain];
    self.mytableView.delegate       = self;
    self.mytableView.dataSource     = self;
    self.mytableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.mytableView];
    
    [self.mytableView registerNib:[UINib nibWithNibName:@"ZFOrderListCell" bundle:nil] forCellReuseIdentifier:@"ZFOrderListCellid"];
    [self.mytableView registerNib:[UINib nibWithNibName:@"OrderWithAddressCell" bundle:nil] forCellReuseIdentifier:@"OrderWithAddressCellid"];
    [self.mytableView registerNib:[UINib nibWithNibName:@"OrderPriceCell" bundle:nil] forCellReuseIdentifier:@"OrderPriceCellid"];
    [self.mytableView registerNib:[UINib nibWithNibName:@"SureOrderCommonCell" bundle:nil] forCellReuseIdentifier:@"SureOrderCommonCellid"];
    [self.mytableView registerNib:[UINib nibWithNibName:@"SureOrderChooseTypeCell" bundle:nil] forCellReuseIdentifier:@"SureOrderChooseTypeCellid"];
    
    [self creatCustomfooterView];
    
    ///网络请求
    
    [self addresslistPostRequst];//收货地址
    
    //获取当前时间
    NSDate * date = [NSDate date];
    _datetime     = [dateTimeHelper timehelpFormatter: date];

//    [self getPayAccessTokenUrl]; //支付获取token

    
}

//拿到商品详情无规格的_userGoodsInfoJSON数组
-(void)userGoodsInfoJSONanalysis
{
    
    ///////////////////////获取所有请求配送费用的参数/////////////////////////////////////////////

    NSMutableArray * storeArray = [NSMutableArray array];
    NSMutableDictionary * param = [NSMutableDictionary dictionary];

    for (NSDictionary * storeDic in _userGoodsInfoJSON) {
        NSMutableArray  * goodsList = [NSMutableArray array];
        
        for (NSDictionary * goodsDic in [storeDic objectForKey:@"goodsList"]) {
            
            NSDictionary * goodlistDic = @{
                                           @"goodsId":goodsDic[@"goodsId"],
                                           @"goodsCount":goodsDic[@"goodsCount"],
                                           @"productId":goodsDic[@"productId"]
                                           };
            
            [goodsList addObject:goodlistDic];
        }
        NSMutableDictionary * storeListdic = [NSMutableDictionary dictionary];
        [storeListdic setObject:goodsList forKey:@"goodsList"];
        [storeListdic setObject:storeDic[@"storeId"] forKey:@"storeId"];
        [storeArray addObject:storeListdic];
        
    }
    [param setObject:storeArray forKey:@"storeList"];
    [param setValue:_postAddressId forKey:@"postAddressId"];
    
///////////////////////获取所有的goodID和storeID/////////////////////////////////////////////
    NSMutableArray * goodsIdArr = [NSMutableArray array];
    NSMutableArray * storeIdArr = [NSMutableArray array];
    for (NSDictionary * storedic in storeArray) {
        NSString * stordID  = [storedic objectForKey:@"storeId"];
        
        for (NSDictionary * goodsDic in storedic[@"goodsList"]) {
        
            NSString * goodId= [goodsDic objectForKey:@"goodsId"];
            
            [goodsIdArr addObject:goodId];
        }
        [storeIdArr addObject:stordID];
    }
    _goodsIdAppding = [goodsIdArr componentsJoinedByString:@","];
    _storeIdAppding = [storeIdArr componentsJoinedByString:@","];
    NSLog(@" _storeIdAppding === %@ --%@",_storeIdAppding,_goodsIdAppding);

    
    /////////////////////// 发起请求/////////////////////////////////////////////
    //获取配送配送费网络求情
    [self getGoodsCostInfoListPostRequstWithJsonString:[NSDictionary dictionaryWithDictionary:param]];
    
    if (self.storelistArry.count > 0 ) {
        
        [self.storelistArry removeAllObjects];
        
    }
    if (self.cmGoodsListArray.count > 0) {
        [self.cmGoodsListArray removeAllObjects];
    }
    
    /////////////////////// 组装当前列表的数据/////////////////////////////////////////////

    //组装cmGoodsListArray
    NSMutableDictionary * storeAttachListDic = [NSMutableDictionary dictionary];
    for (NSDictionary * storeListDic  in _userGoodsInfoJSON) {
        for (NSDictionary * goodsListDic in storeListDic[@"goodsList"]) {
            [self.cmGoodsListArray addObject:goodsListDic];
        }
        [self.storelistArry addObject:storeListDic];
        
        //===================storeAttachList字段===================//
        [storeAttachListDic setValue:[storeListDic objectForKey:@"storeId"] forKey:@"storeId"];
        [storeAttachListDic setValue:[storeListDic objectForKey:@"storeName"] forKey:@"storeName"];
        [storeAttachListDic setValue:@"暂无备注" forKey:@"comment"];
        [self.storeAttachListArr addObject:storeAttachListDic];
    }
    NSLog(@"cmGoodsListArray = %@",self.cmGoodsListArray )
    [self.mytableView reloadData];

}
//创建UI
-(void)creatCustomfooterView
{
    NSString *buttonTitle = @"提交订单";
    NSString *price       = @"¥0.00";
    NSString *caseOrder   = @"实付金额:";
    
    UIFont * font  =[UIFont systemFontOfSize:15];
    _footerView = [[UIView alloc]initWithFrame:CGRectMake(0,KScreenH -49, KScreenW, 49)];
    _footerView.backgroundColor =[UIColor clearColor];
    [self.view addSubview:_footerView];
    
    //结算按钮
    UIButton * complete_Btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [complete_Btn setTitle:buttonTitle forState:UIControlStateNormal];
    complete_Btn.titleLabel.font = font;
    complete_Btn.backgroundColor = HEXCOLOR(0xfe6d6a);
    complete_Btn.frame = CGRectMake(KScreenW - 120 , 0, 120 , 49);
    [complete_Btn addTarget:self action:@selector(didCleckClearing:) forControlEvents:UIControlEventTouchUpInside];
    [_footerView addSubview:complete_Btn];
    
    //固定金额位置
    UILabel * lb_order  = [[UILabel alloc]init];
    lb_order.text       = caseOrder;
    lb_order.font       = font;
    lb_order.textColor  = HEXCOLOR(0x363636);
    lb_order.frame      = CGRectMake(15, 1, 80, 48);
    [_footerView addSubview:lb_order];
    
    //价格
    _lb_price               = [[UILabel alloc]init];
    _lb_price.text          = price;
    _lb_price.textAlignment = NSTextAlignmentLeft;
    _lb_price.font          = font;
    _lb_price.textColor     = HEXCOLOR(0xfe6d6a);
    _lb_price.frame         = CGRectMake(lb_order.width + 20, 1, 100, 48);
    [_footerView addSubview:_lb_price];
    
    
    UILabel * line =[[ UILabel alloc]initWithFrame:CGRectMake(0, 0, KScreenW, 1)];
    line.backgroundColor = HEXCOLOR(0xdedede);
    [_footerView addSubview:line];
    
}
#pragma  mark - UITableViewDelegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return 6;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    _orderCellType = indexPath.row;
    CGFloat height = 0;
    switch (_orderCellType) {
        case SureOrderCellTypeAddressCell://收货地址
        {
            if ([_payType isEqualToString:@"0"]) {
                
                height = 0;
            }else{
           
                height =  [tableView fd_heightForCellWithIdentifier:@"OrderWithAddressCellid" configuration:^(OrderWithAddressCell * cell) {
                [self configCell:cell indexpath:indexPath];

                }];
            }
        }
            
            break;
        case SureOrderCellTypeGoodsListCell://商品类型
            height = 70;
            break;
        case SureOrderCellTypePayTypeCell://支付方式
            height = 44;
            
            break;
        case SureOrderCellTypeChooseGetTypeCell://是否自提
            height = 0;
            
            break;
        case SureOrderCellTypeCouponCell://优惠券
            if (self.couponList.count > 0) {
                height = 44;
            }
            else{
                height = 0;
            }
            
            break;
        case SureOrderCellTypeMoneyOrFreeCell://商品金额
            height = 62;
            
            break;
            
    }
    return height;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    _orderCellType = indexPath.row;
    
    switch (_orderCellType) {
        case SureOrderCellTypeAddressCell://收货地址
        {
            OrderWithAddressCell * addCell = [self.mytableView
                                              dequeueReusableCellWithIdentifier:@"OrderWithAddressCellid" forIndexPath:indexPath];
            if ([_payType isEqualToString:@"0"]) {
                [addCell setHidden:YES];
            }
            else{
                
                [self configCell:addCell indexpath:indexPath];
 
            }

            
            return addCell;
        }
            break;
        case SureOrderCellTypeGoodsListCell://商品类型
        {
            ZFOrderListCell * listCell = [self.mytableView
                                          dequeueReusableCellWithIdentifier:@"ZFOrderListCellid" forIndexPath:indexPath];
            listCell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            if (self.cmGoodsListArray.count > 0) {
                listCell.listArray        = self.cmGoodsListArray;
                NSMutableArray * goodsCountArray = [NSMutableArray array];
                
                for (NSDictionary * goodDic in self.cmGoodsListArray) {
                   [goodsCountArray addObject:goodDic[@"goodsCount"]];
                }
                NSInteger sum = [[[NSArray arrayWithArray:goodsCountArray] valueForKeyPath:@"@sum.integerValue"] integerValue];
                listCell.lb_totalNum.text = [NSString stringWithFormat:@"一共%ld件",sum] ;
                [listCell.order_collectionCell reloadData];
                
            }
            return listCell;
        }
            break;
        case SureOrderCellTypePayTypeCell://支付方式
        {
            SureOrderCommonCell * payCell = [self.mytableView dequeueReusableCellWithIdentifier:@"SureOrderCommonCellid" forIndexPath:indexPath];
            [payCell.canUsedCouponNum setHidden:YES];

            payCell.lb_title.text       = @"支付类型";
            if ([_payType isEqualToString:@"1"]) {
                payCell.lb_detailTitle.text = @"在线支付";
            }
            else{
                payCell.lb_detailTitle.text = @"门店支付";
            }
            return payCell;
        }
            break;
        case SureOrderCellTypeChooseGetTypeCell://是否自提
        {
            SureOrderChooseTypeCell * cell = [self.mytableView dequeueReusableCellWithIdentifier:@"SureOrderChooseTypeCellid" forIndexPath:indexPath];
            cell.hidden                    = YES;
            return cell;
        }
            break;
        case SureOrderCellTypeCouponCell://优惠券
        {
            SureOrderCommonCell * couponCell    = [self.mytableView dequeueReusableCellWithIdentifier:@"SureOrderCommonCellid" forIndexPath:indexPath];
            if (self.couponList.count > 0) {
                couponCell.canUsedCouponNum.text =[NSString stringWithFormat:@"可使用%ld张",self.couponList.count];
                couponCell.lb_title.text            = @"优惠券";
                couponCell.lb_detailTitle.textColor = HEXCOLOR(0xfe6d6a);
               
                if (_couponAmount == nil || [_couponAmount isEqualToString:@""]) {
                    couponCell.lb_detailTitle.text      = @"";
                    
                }else{
                    couponCell.lb_detailTitle.text      =  [NSString stringWithFormat:@"- ¥%@",_couponAmount];
                    couponCell.lb_detailTitle.textColor = HEXCOLOR(0xfe6d6a);
                }

            }else{
                [couponCell setHidden:YES];
            }
           
            return couponCell;
        }
            
            break;
        case SureOrderCellTypeMoneyOrFreeCell://商品金额
        {
            //goodsCount	int(11)	商品总金额
            //costNum	int(11)	配送费总金额
            //userCostNum	int(11)	支付总金额
            OrderPriceCell * priceCell   = [self.mytableView dequeueReusableCellWithIdentifier:@"OrderPriceCellid" forIndexPath:indexPath];
            
            if ([_payType isEqualToString:@"0"] || _postAddressId == nil|| [_postAddressId isEqualToString:@""] ) {
                priceCell.lb_tipFree.text    = @"¥0" ;
              
            }
            else{
                //配送费总金额
                priceCell.lb_tipFree.text    =         [NSString stringWithFormat:@"+ ¥%@",_costNum]  ;
            }
            if ([_goodsCount isEqualToString:@""] || _goodsCount ==nil) {
               
                priceCell.lb_priceTotal.text = @"¥0" ;
            
            }else{
                
                priceCell.lb_priceTotal.text = [NSString stringWithFormat:@"¥%@",_goodsCount] ;
  
            }
            NSLog(@"原来的价格 --- %@",_goodsCount);
        
            return priceCell;
        }
            break;
    }
    
}
- (void)configCell:(OrderWithAddressCell *)cell indexpath:(NSIndexPath *)indexpath
{
    if (_postAddressId == nil || [_postAddressId isEqualToString:@""]) {
        
        [cell.nodataView setHidden:NO];
        
    }else{
        
        [cell.nodataView setHidden:YES];
        cell.lb_address.text      = _postAddress;
        cell.lb_nameAndPhone.text = [NSString stringWithFormat:@"收货人: %@  %@",_contactUserName,_contactMobilePhone];
    }
    
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"section = %ld ,row =%ld ",indexPath.section ,indexPath.row);
    _orderCellType = indexPath.row;
    switch (_orderCellType) {
        case SureOrderCellTypeAddressCell://收货地址
        {
            ZFAddressListViewController * listVC =[[ ZFAddressListViewController alloc]init];
            listVC.orderBackBlock = ^(NSString *PossName, NSString *PossAddress, NSString *PossPhone, NSString *PossAddressId) {
                
                _contactUserName                                = PossName ;
                _contactMobilePhone                             = PossPhone;
                _postAddress                                    = PossAddress;
                _postAddressId                                  = PossAddressId;
                
                NSLog(@"编辑地址  PossName =%@  PossAddress         = %@ PossPhone = %@ -- possid",PossName,PossAddress,PossPhone);
                [self userGoodsInfoJSONanalysis];
                [self.mytableView reloadData];
            };
            [self.navigationController pushViewController:listVC animated:YES];
        }
            break;
        case SureOrderCellTypeGoodsListCell://商品清单
        {
            ZFShopListViewController * shoplistVc =[[ZFShopListViewController alloc]init];
            shoplistVc.userGoodsArray = self.cmGoodsListArray;
            [self.navigationController pushViewController:shoplistVc animated:YES];
        }
            break;
        case SureOrderCellTypePayTypeCell://支付方式
        {
            [self.view addSubview:self.popCouponBackgroundView];
            [self.mytableView bringSubviewToFront:self.popCouponBackgroundView];
        }
            break;
        case SureOrderCellTypeChooseGetTypeCell://是否自提
            
            break;
        case SureOrderCellTypeCouponCell://优惠券
        {
            
            ZFSelectCouponViewController * couponVC =[ZFSelectCouponViewController new];
            couponVC.goodsAmount= _goodsCount; //订单总额
            couponVC.goodsIdJson = _goodsIdAppding;//商品id，
            couponVC.storeIdjosn = _storeIdAppding;//门店id，
            couponVC.couponBlock = ^(NSString *couponId, NSString *userRange, NSString *couponAmount, NSString *storeId, NSString *goodsIds) {
                _couponId = couponId;
                _useRange = userRange;
                _couponAmount = couponAmount;
                _couponStoreId = storeId;
                _couponGoodsIds = goodsIds;
                _lb_price.text = _totalPirce = [NSString stringWithFormat:@"¥%.2f",[_userCostNum floatValue] - [couponAmount floatValue]];
                NSLog(@"%@,%@,%@",_couponId,_useRange,_couponAmount);

                [self.mytableView reloadData];
            };
            
            [self.navigationController pushViewController:couponVC animated:NO];
        }
            break;
        case SureOrderCellTypeMoneyOrFreeCell://商品金额
            
            break;
    }
}



#pragma mark -  getOrderFix 用户地址接口
-(void)addresslistPostRequst
{
    NSDictionary * parma = @{
                             
                             @"cmUserId":BBUserDefault.cmUserId,
                             
                             };
    
    [MENetWorkManager post:[NSString stringWithFormat:@"%@/getOrderFix",zfb_baseUrl] params:parma success:^(id response) {
        
        NSString * code = [NSString stringWithFormat:@"%@",response[@"resultCode"]];
        if ([code isEqualToString:@"0"]) {
            
            AddressListModel * addressModel = [AddressListModel mj_objectWithKeyValues:response ];
            
            _contactUserName    = addressModel.userAddressMap.userName;
            _postAddress        = addressModel.userAddressMap.postAddress;
            _contactMobilePhone = addressModel.userAddressMap.mobilePhone;
            _postAddressId      = addressModel.userAddressMap.postAddressId;
            
            //解析json在重新组装新的json
            [self userGoodsInfoJSONanalysis];
        }
        
    } progress:^(NSProgress *progeress) {
    } failure:^(NSError *error) {
        
        NSLog(@"error=====%@",error);
        [self.view makeToast:@"网络错误" duration:2 position:@"center"];
    }];
    
}

#pragma mark -  getGoodsCostInfo 用户订单确定费用信息接口
-(void)getGoodsCostInfoListPostRequstWithJsonString:(NSDictionary *) jsondic
{
    _storeDeliveryfeeListArr =[NSMutableArray array];
    
    [MENetWorkManager post:[NSString stringWithFormat:@"%@/getGoodsCostInfo",zfb_baseUrl] params:jsondic success:^(id response) {
     
        NSString * code = [NSString stringWithFormat:@"%@", response[@"resultCode"]];
        if([code isEqualToString:@"0"])
        {            
            SureOrderModel * suremodel = [SureOrderModel mj_objectWithKeyValues:response];
            
            _storeDeliveryfeeListArr = response[@"storeDeliveryfeeList"];
            _goodsCount              = [NSString stringWithFormat:@"%.2f",suremodel.goodsCount]  ;//商品总金额
            _costNum                 = [NSString stringWithFormat:@"%.2f",suremodel.costNum];//配送费
            _userCostNum             = [NSString stringWithFormat:@"%.2f",suremodel.userCostNum]  ;//支付总金额
            _lb_price.text           = _totalPirce = [NSString stringWithFormat:@"¥%@",_userCostNum];//支付总金额
           
            //获取优惠券列表
            [self getUserNotUseCouponListPostRequset];
            
        }

        [self.mytableView reloadData];
        
    } progress:^(NSProgress *progeress) {
    } failure:^(NSError *error) {
        
        NSLog(@"error=====%@",error);
        [self.view makeToast:@"网络错误" duration:2 position:@"center"];
    }];
    
    [SVProgressHUD dismiss];
    
    
}

#pragma mark -  order/generateOrderNumber 用户订单提交
-(void)commitOrder:(NSDictionary *) jsondic
{
    [SVProgressHUD show];
 
    [MENetWorkManager post:[NSString stringWithFormat:@"%@/order/generateOrderNumber",zfb_baseUrl] params:jsondic success:^(id response) {
        if ([response[@"resultCode"] intValue] == 0) {
            //paytype 支付类型 0 线下 1 线上
            if ([_payType isEqualToString:@"0"]) {
                //选择线下
                ZFAllOrderViewController * allVC = [ZFAllOrderViewController new];
                allVC.orderType = OrderTypeAllOrder;
                allVC.buttonTitle = @"全部订单";
                [self.navigationController pushViewController:allVC animated:NO];
          
            }else{ //跳转到收银台
                _orderArr = response[@"orderList"];
 
                //支付的回调地址
                _notify_url = response[@"thirdURI"][@"notify_url"];
                _return_url  = response[@"thirdURI"][@"return_url"];
                _gateWay_url  = response[@"thirdURI"][@"gateWay_url"];
                _goback_url   = response[@"thirdURI"][@"goback_url"];
                
                [self getPaypaySignAccessTokenUrl];
                
            }
            [SVProgressHUD dismiss];
        }
    } progress:^(NSProgress *progeress) {
        
    } failure:^(NSError *error) {
        [SVProgressHUD dismiss];
        NSLog(@"error=====%@",error);
        [self.view makeToast:@"网络错误" duration:2 position:@"center"];

    }];
 
    
}

#pragma mark - 获取支付accessToken值，通过accessToken值获取支付签名1111111111111
//-(void)getPayAccessTokenUrl
//{
//    NSDictionary * param = @{
//                             @"account": BBUserDefault.userPhoneNumber,                             
//                             };
//    
//    [MENetWorkManager post:[NSString stringWithFormat:@"%@/order/getPayAccessToken",zfb_baseUrl] params:param success:^(id response) {
//        NSString * code = [NSString stringWithFormat:@"%@", response[@"resultCode"]];
//        if([code isEqualToString:@"0"])
//        {
//            NSDate * date = [NSDate date];
//            _datetime     = [dateTimeHelper timehelpFormatter: date];//2017-07-20 17:08:54
//            _access_token = response[@"accessToken"];
//            
//            NSLog(@"=======%@_access_token",_access_token);
//            NSLog(@"=======%@_datetime",_datetime);
//        }
//    } progress:^(NSProgress *progeress) {
//        
//        NSLog(@"progeress=====%@",progeress);
//        
//    } failure:^(NSError *error) {
//        
//        NSLog(@"error=====%@",error);
//        [self.view makeToast:@"网络错误" duration:2 position:@"center"];
//    }];
//    
//}


#pragma mark - 获取用户未使用优惠券列表   recomment/getUserNotUseCouponList
-(void)getUserNotUseCouponListPostRequset{
    NSDictionary * parma = @{
                             
                             @"status":@"1",
                             @"idType":@"3",
                             @"resultId":@"",
                             @"goodsAmount":_goodsCount,//商品金额
                             @"goodsId":_goodsIdAppding,
                             @"storeId":_storeIdAppding,
                             @"userId":BBUserDefault.cmUserId,
                             @"pageIndex":[NSNumber numberWithInteger:self.currentPage],
                             @"pageSize":@"30",
                             };
 
    [MENetWorkManager post:[zfb_baseUrl stringByAppendingString:@"/recomment/getUserNotUseCouponList"] params:parma success:^(id response) {
        if ([response[@"resultCode"] isEqualToString:@"0"] ) {
            if (self.couponList.count > 0) {
               
                [self.couponList removeAllObjects];
            }
            CouponModel * coupon = [CouponModel mj_objectWithKeyValues:response];
            for (Couponlist * list in coupon.couponList) {
                if ([list.validPeriod isEqualToString:@"1"]) {//有效期内
                    [self.couponList addObject:list];
                }
            }
        }
    } progress:^(NSProgress *progeress) {
        
    } failure:^(NSError *error) {
        [self endRefresh];
        [SVProgressHUD dismiss];
        NSLog(@"error=====%@",error);
        [self.view makeToast:@"网络错误" duration:2 position:@"center"];
    }];
    
}

#pragma mark - 提交订单 didCleckClearing
-(void)didCleckClearing:(UIButton *)sender
{
    NSLog(@" 提交订单 ");
    //还原成字典数组
    NSArray * cmgoodsList          = [NSArray arrayWithArray:self.cmGoodsListArray];
    NSArray * storeDeliveryfeeList = [NSArray arrayWithArray:self.storeDeliveryfeeListArr];
    NSArray * storeAttachList      = [NSArray arrayWithArray:self.storeAttachListArr];
    
    /////////////////////////// 一个大集合 /////////////////////////////////////////////
    NSMutableDictionary * jsondic = [NSMutableDictionary dictionary] ;
    
    [jsondic setValue:BBUserDefault.cmUserId forKey:@"cmUserId"];
    [jsondic setValue:_postAddressId forKey:@"postAddressId"];
    [jsondic setValue:_contactUserName forKey:@"contactUserName" ];
    [jsondic setValue:_contactMobilePhone forKey:@"contactMobilePhone"];
    [jsondic setValue:_contactMobilePhone forKey:@"mobilePhone"];
    [jsondic setValue:_postAddress forKey:@"postAddress"];
    [jsondic setValue:_payType forKey:@"payType" ];//支付类型 0 线下 1 线上
    [jsondic setValue:_cartItemId forKey:@"cartItemId"];//立即购买不传，购物车加入的订单需要传
    
    [jsondic setValue: cmgoodsList forKey:@"cmGoodsList"];
    [jsondic setValue: storeDeliveryfeeList forKey:@"storeDeliveryfeeList"];
    [jsondic setValue: storeAttachList forKey:@"storeAttachList"];
    ////////优惠券新加字段
    [jsondic setValue: _useRange forKey:@"useRange"];
    [jsondic setValue: _couponId forKey:@"couponId"];
    [jsondic setValue: _couponStoreId forKey:@"storeId"];
    [jsondic setValue: _couponAmount forKey:@"couponAmount"];
    [jsondic setValue: _couponGoodsIds forKey:@"goodsIds"];
 
    NSDictionary * successDic = [NSDictionary dictionaryWithDictionary:jsondic];
    //    NSLog(@"提交订单 -----------%@",successDic);
    if (_postAddress == nil  || _contactUserName == nil || _contactMobilePhone == nil) {
        JXTAlertController * alertavc = [JXTAlertController alertControllerWithTitle:@"提示" message:@"您现在还没有默认地址，马上添加默认地址" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction * cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        UIAlertAction * sureAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
            ZFAddressListViewController * listVC =[[ZFAddressListViewController alloc]init];
            [self.navigationController pushViewController:listVC animated:YES];
        }];
        [alertavc addAction:cancelAction];
        [alertavc addAction:sureAction];
        [self presentViewController:alertavc animated:YES completion:nil];
        
    }else{
 
        //进入请求
        [self commitOrder:successDic];
 
    }
}

#pragma mark - 获取支付paySign值
-(void)getPaypaySignAccessTokenUrl
{
    [SVProgressHUD show];
    NSString * listJsonString  =  [NSString arrayToJSONString:_orderArr];
    NSMutableDictionary * params = [NSMutableDictionary dictionary];

    [params setValue:BBUserDefault.userPhoneNumber forKey:@"account"];
    [params setValue:_datetime forKey:@"datetime"];//yyyy-MM-dd HH:mm:ss（北京时间）
    [params setValue:_notify_url forKey:@"notify_url"];//异步通知地址（用于接收订单支付通知）
    [params setValue:_return_url forKey:@"return_url"];//同步通知地址（支付成功后的跳转）
    [params setValue:listJsonString forKey:@"order_list"];//Json格式的订单字符集
    [params setValue:@"" forKey:@"passback_params"];//回传参数：商户可自定义该参数，在支付回调后带回
    
    [MENetWorkManager post:[NSString stringWithFormat:@"%@/order/paySign",zfb_baseUrl] params:[NSDictionary dictionaryWithDictionary:params] success:^(id response) {
        
        _paySign = response[@"paySign"];
        
        [SVProgressHUD dismissWithCompletion:^{
            
            [self getGoodsCostPayResulrUrlL];
        }];
        
    } progress:^(NSProgress *progeress) {
    } failure:^(NSError *error) {
        [SVProgressHUD dismiss];
        NSLog(@"error=====%@",error);
        [self.view makeToast:@"网络错误" duration:2 position:@"center"];
    }];
    
}


#pragma mark -  PayResulrUrl支付页面地址
-(void)getGoodsCostPayResulrUrlL
{
    NSMutableDictionary * params = [NSMutableDictionary dictionary];
    NSString * listJsonString  = [NSString arrayToJSONString:_orderArr];
    
    [params setValue:_paySign forKey:@"sign"];//回传参数：商户可自定义该参数，在支付回调后带回
    [params setValue:BBUserDefault.userPhoneNumber forKey:@"account"];
    [params setValue:_datetime forKey:@"datetime"];//yyyy-MM-dd HH:mm:ss（北京时间）
    [params setValue:_notify_url forKey:@"notify_url"];//异步通知地址（用于接收订单支付通知）
    [params setValue:_return_url forKey:@"return_url"];//同步通知地址（支付成功后的跳转）
    [params setValue:listJsonString forKey:@"order_list"];//Json格式的订单字符集
    [params setValue:@"" forKey:@"passback_params"];//回传参数：商户可自定义该参数，在支付回调后带回
    NSDictionary * dic  = [NSDictionary dictionaryWithDictionary:params];
    
    CheckstandViewController * payVC = [CheckstandViewController new];
    payVC.amount = _totalPirce;
    payVC.notifyUrl = _notify_url;
    payVC.signDic = dic;
    [self.navigationController pushViewController:payVC animated:NO];
    
}

#pragma mark - 懒加载
-(NSMutableArray *)couponList
{
    if (!_couponList) {
        _couponList = [NSMutableArray array];
    }
    return _couponList;
}

-(NSMutableArray *)storeAttachListArr
{
    if (!_storeAttachListArr) {
        _storeAttachListArr =[NSMutableArray array];
    }
    return _storeAttachListArr;
}

-(NSMutableArray *)goodsListArray
{
    if (!_goodsListArray) {
        _goodsListArray =[NSMutableArray array];
    }
    return _goodsListArray;
}

-(NSMutableArray *)cmGoodsListArray
{
    if (!_cmGoodsListArray) {
        _cmGoodsListArray = [NSMutableArray array];
    }
    return _cmGoodsListArray;
}

-(NSMutableArray *)storelistArry
{
    if (!_storelistArry) {
        _storelistArry = [NSMutableArray array];
    }
    return _storelistArry;
}

-(SelectPayTypeView *)selectPayView
{
    if (!_selectPayView) {
        _selectPayView                 = [[SelectPayTypeView alloc]initWithFrame:CGRectMake(0, 0, KScreenW, 184) style:UITableViewStylePlain];
        _selectPayView.center = self.popCouponBackgroundView.center;
        _selectPayView.PayTypeDelegate = self;
    }
    return _selectPayView;
}

-(UIView *)popCouponBackgroundView
{
    if (!_popCouponBackgroundView) {
        _popCouponBackgroundView                 = [[UIView alloc]initWithFrame:self.view.bounds];
        _popCouponBackgroundView.backgroundColor = RGBA(0, 0, 0, 0.2);
        [_popCouponBackgroundView addSubview:self.selectPayView];
    }
    return _popCouponBackgroundView;
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
    [self.popCouponBackgroundView removeFromSuperview];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [SVProgressHUD dismiss];
    
}


#pragma mark - SelectPayTypeViewDelegate 选择支付类型
/**
 选择支付类型
 
 @param index  0 线下支付，1 线上支付
 */
-(void)didClickWithIndex:(NSInteger)index
{
    _payType    = [NSString stringWithFormat:@"%ld",index];
    NSLog(@"%ld = index",index);
    [self.popCouponBackgroundView removeFromSuperview];
    
    if ([_payType isEqualToString:@"0"]) {//如果是门店
        _lb_price.text   = _totalPirce = [NSString stringWithFormat:@"¥%.2f",[_userCostNum floatValue] - [_costNum floatValue]];
    }else{
        _lb_price.text   = _totalPirce = [NSString stringWithFormat:@"¥%.2f",[_userCostNum floatValue] ];

    }
    [self.mytableView reloadData];
    [self.selectPayView reloadData];
}

/**
 关闭视图
 */
-(void)didClickClosePayTypeView
{
    [self.popCouponBackgroundView removeFromSuperview];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
