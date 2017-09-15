
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
#import "LoginViewController.h"
#import "ZFBaseNavigationViewController.h"

//model
#import "AddressListModel.h"
#import "JsonModel.h"
#import "SureOrderModel.h"
#import "CommitOrderlist.h"

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
    
    NSInteger _payType;// 0 在线支付，1 门店支付
    
}

@property (nonatomic,strong) UITableView * mytableView;
@property (nonatomic,strong) UIView      * footerView;
@property (nonatomic,strong) UILabel     * lb_price;

@property (nonatomic,strong) NSMutableArray * goodsListArray;//用来接收的商品数组
@property (nonatomic,strong) NSMutableArray * cmGoodsListArray;//cmgoodslist
@property (nonatomic,strong) NSMutableArray * storelistArry;//门店数组

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
    [self getPayAccessTokenUrl]; //支付获取token
    
    
}

//拿到商品详情无规格的_userGoodsInfoJSON数组
-(void)userGoodsInfoJSONanalysis
{
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
    
    //获取配送配送费网络求情
    [self getGoodsCostInfoListPostRequstWithJsonString:[NSDictionary dictionaryWithDictionary:param]];
    NSLog(@"%@",param);
    
    if (self.storelistArry.count > 0 ) {
        
        [self.storelistArry removeAllObjects];
        
    }
    
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
            height = 60;
            
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
            height = 44;
            
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
            if (_postAddress == nil  && _contactUserName == nil && _contactMobilePhone == nil) {
                
                [addCell.nodataView setHidden:NO];
                
            }else{
                
                [addCell.nodataView setHidden:YES];
                addCell.lb_address.text      = _postAddress;
                addCell.lb_nameAndPhone.text = [NSString stringWithFormat:@"收货人: %@  %@",_contactUserName,_contactMobilePhone];
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
                listCell.lb_totalNum.text = [NSString stringWithFormat:@"一共%ld件",self.cmGoodsListArray.count] ;
                [listCell.order_collectionCell reloadData];
                
            }
            return listCell;
        }
            break;
        case SureOrderCellTypePayTypeCell://支付方式
        {
            SureOrderCommonCell * payCell = [self.mytableView dequeueReusableCellWithIdentifier:@"SureOrderCommonCellid" forIndexPath:indexPath];
            
            payCell.lb_title.text       = @"支付类型";
            payCell.lb_detailTitle.text = @"在线支付";
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
            couponCell.lb_title.text            = @"优惠券";
            couponCell.lb_detailTitle.text      = @"";
            couponCell.lb_detailTitle.textColor = HEXCOLOR(0xfe6d6a);
            return couponCell;
        }
            
            break;
        case SureOrderCellTypeMoneyOrFreeCell://商品金额
        {
            //goodsCount	int(11)	商品总金额
            //costNum	int(11)	配送费总金额
            //userCostNum	int(11)	支付总金额
            OrderPriceCell * priceCell   = [self.mytableView dequeueReusableCellWithIdentifier:@"OrderPriceCellid" forIndexPath:indexPath];
            priceCell.lb_tipFree.text    = _costNum ;
            priceCell.lb_priceTotal.text = _goodsCount ;
            
            return priceCell;
        }
            break;
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
            listVC.callBackBlock = ^(NSString *PossName, NSString *PossAddress, NSString *PossPhone) {
                
                _contactUserName                                = PossName ;
                _contactMobilePhone                             = PossPhone;
                _postAddress                                    = PossAddress;
                NSLog(@"编辑地址  PossName =%@  PossAddress         = %@ PossPhone = %@",PossName,PossAddress,PossPhone);
                [self userGoodsInfoJSONanalysis];
                [self.mytableView reloadData];
                
            };
            [self.navigationController pushViewController:listVC animated:YES];
        }
            break;
        case SureOrderCellTypeGoodsListCell://商品类型
        {
            
            ZFShopListViewController * shoplistVc =[[ZFShopListViewController alloc]init];
            shoplistVc.storeListArray = _userGoodsInfoJSON;
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
            [self.navigationController pushViewController:couponVC animated:NO];
        }
            break;
        case SureOrderCellTypeMoneyOrFreeCell://商品金额
            
            break;
            
    }
    
}



#pragma mark -  getOrderFix 用户订单确定地址接口
-(void)addresslistPostRequst
{
    NSDictionary * parma = @{
                             
                             @"cmUserId":BBUserDefault.cmUserId,
                             
                             };
    
    [MENetWorkManager post:[NSString stringWithFormat:@"%@/getOrderFix",zfb_baseUrl] params:parma success:^(id response) {
        
        if ([response[@"resultCode"] intValue] == 0) {
            
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
        
        if ([response[@"resultCode"] intValue ] == 0) {
            
            SureOrderModel * suremodel = [SureOrderModel mj_objectWithKeyValues:response];
            
            _storeDeliveryfeeListArr = response[@"storeDeliveryfeeList"];
            _goodsCount              = [NSString stringWithFormat:@"¥%.2f",suremodel.goodsCount]  ;//商品总金额
            _costNum                 = [NSString stringWithFormat:@"+ ¥%.2f",suremodel.costNum]  ;//配送费总金额
            _userCostNum             = [NSString stringWithFormat:@"¥%.2f",suremodel.userCostNum]  ;//支付总金额
            _lb_price.text           = _userCostNum;//支付总金额
            
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
            
            NSArray * orderArr = response[@"orderList"];
            
//            NSMutableDictionary * mutOrderDic = [NSMutableDictionary dictionary];
//            NSMutableArray * mutOrderArray    = [NSMutableArray array];
//            for (NSDictionary * orderdic in orderArr) {
//
//                [mutOrderDic setValue:[orderdic objectForKey:@"order_num"] forKey:@"order_num"];
//                [mutOrderDic setValue:[orderdic objectForKey:@"body"] forKey:@"body"];
//                [mutOrderDic setValue:[orderdic objectForKey:@"title"] forKey:@"title"];
//                [mutOrderDic setValue:[orderdic objectForKey:@"pay_money"] forKey:@"pay_money"];
//                [mutOrderArray addObject:mutOrderDic];
//            }
//            
            //跳转到webview
            ZFMainPayforViewController * payVC = [[ZFMainPayforViewController alloc]init];
            payVC.orderListArray               = orderArr;//[NSArray arrayWithArray:mutOrderArray];
            payVC.datetime                     = _datetime;
            payVC.access_token                 = _access_token;
            
            //支付的回调地址
            NSString  * notify_url  = response[@"thirdURI"][@"notify_url"];
            NSString  * return_url  = response[@"thirdURI"][@"return_url"];
            NSString  * gateWay_url = response[@"thirdURI"][@"gateWay_url"];
            NSString  * goback_url  = response[@"thirdURI"][@"goback_url"];
            
            payVC.notify_url  = notify_url;
            payVC.return_url  = return_url;
            payVC.gateWay_url = gateWay_url;
            payVC.goback_url  = goback_url;
            [self.navigationController pushViewController:payVC animated:YES];
            
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
-(void)getPayAccessTokenUrl
{
#warning -- 此账号为测试时账号  正式时 需要修改成正式账号
    NSDictionary * param = @{
                             
                             @"account": @"18602343931",
                             @"pass"   : @"123456",
                             
                             };
    
    [MENetWorkManager post:[NSString stringWithFormat:@"%@/order/getPayAccessToken",zfb_baseUrl] params:param success:^(id response) {
        
        NSDate * date = [NSDate date];
        _datetime     = [dateTimeHelper timehelpFormatter: date];//2017-07-20 17:08:54
        _access_token = response[@"accessToken"];
        
        NSLog(@"=======%@_access_token",_access_token);
        NSLog(@"=======%@_datetime",_datetime);
        
    } progress:^(NSProgress *progeress) {
        
        NSLog(@"progeress=====%@",progeress);
        
    } failure:^(NSError *error) {
        
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
    //    [jsondic setValue:@"" forKey:@"payMode" ];//1.支付宝  2.微信支付 3.线下,4.展易付
    [jsondic setValue:@"1" forKey:@"payType" ];//支付类型 0 线下 1 线上
    [jsondic setValue:_cartItemId forKey:@"cartItemId"];//立即购买不传，购物车加入的订单需要传
    
    [jsondic setValue: cmgoodsList forKey:@"cmGoodsList"];
    [jsondic setValue: storeDeliveryfeeList forKey:@"storeDeliveryfeeList"];
    [jsondic setValue: storeAttachList forKey:@"storeAttachList"];
    
    NSDictionary * successDic = [NSDictionary dictionaryWithDictionary:jsondic];
    //    NSLog(@"提交订单 -----------%@",successDic);
    if (BBUserDefault.isLogin == 1) {
        [self commitOrder:successDic];
        
    }else
    {
        LoginViewController * logVc          = [[LoginViewController alloc]init];
        ZFBaseNavigationViewController * nav = [[ZFBaseNavigationViewController alloc ]initWithRootViewController:logVc];
        [self.navigationController presentViewController:nav animated:NO completion:^{
            [nav.navigationBar setBarTintColor:HEXCOLOR(0xfe6d6a)];
            [nav.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:HEXCOLOR(0xffffff),NSFontAttributeName:[UIFont systemFontOfSize:15.0]}];
            BBUserDefault.isLogin = 0;//登录状态为0
        }];
    }
}


#pragma mark - 懒加载
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


#pragma mark - SelectPayTypeViewDelegate
/**
 选择支付类型
 
 @param index  0 在线支付，1 门店支付
 */
-(void)didClickWithIndex:(NSInteger)index
{
    _payType    = index;
    NSLog(@"%ld = index",index);
    
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
