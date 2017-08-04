
//
//  ZFSureOrderViewController.m
//  ZFB
//
//  Created by  展富宝  on 2017/5/24.
//  Copyright © 2017年 com.zfb. All rights reserved.
//

#import "ZFSureOrderViewController.h"

#import "ZFOrderListCell.h"
#import "OrderWithAddressCell.h"
#import "OrderPriceCell.h"

#import "ZFAddressListViewController.h"
#import "ZFShopListViewController.h"
#import "AddressCommitOrderModel.h"
#import "ZFMainPayforViewController.h"

#import "AddressListModel.h"//地址模型
#import "JsonModel.h"
#import "SureOrderModel.h"
#import "CommitOrderlist.h"

@interface ZFSureOrderViewController ()<UITableViewDelegate ,UITableViewDataSource>
{
    NSString * _contactUserName;
    NSString * _postAddress;
    NSString * _contactMobilePhone;
    NSString * _postAddressId;//收货地址id
    
    NSString * _goodsCount;//商品总价
    NSString * _costNum;//配送费
    NSString * _userCostNum;//支付总金额
    NSString * _orderDeliveryfee;//每家门店的配送费
    
    UILabel  * lb_price;
    NSString * _datetime;
    NSString * _access_token;
    
}
@property (nonatomic,strong) NSMutableArray * goodsListArray;//用来接收的商品数组

@property (nonatomic,strong) UITableView    * mytableView;
@property (nonatomic,strong) UIView         * footerView;
@property (nonatomic,strong) NSMutableArray * imgArray;

@property (nonatomic,copy) NSString * anewJsonString;

@property (nonatomic,strong) NSMutableArray * goodlistArry;
@property (nonatomic,strong) NSMutableArray * storelistArry;
@property (nonatomic,strong) NSMutableArray * feeList;//价格

@property (nonatomic,strong) NSMutableArray * storeAttachListArr;//要拆分的数组
@property (nonatomic,strong) NSMutableArray * storeDeliveryfeeListArr;//要拆分的数组
@property (nonatomic,strong) NSMutableArray * mutOrderlistArr;//要拆分的数组



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
    
    ///网络请求
    [self addresslistPostRequst];//收货地址
    
    [self creatCustomfooterView];
    
    [self getPayAccessTokenUrl];
    
    
}
//拿到商品详情无规格的_userGoodsInfoJSON数组

/**
 goodsCostList	String	集合	否
 postAddressId	int(11)	收货地址id	否
 storeId	String(30)	门店id	否
 goodsId	String(100)	商品id	否
 goodsCount	int(11)	商品数量	否
 */
-(void)userGoodsInfoJSONanalysis
{
    NSMutableDictionary * jsondic = [NSMutableDictionary dictionary];
    [jsondic setValue:_userGoodsInfoJSON forKey:@"userGoodsInfoJSON"];
    
    //数组字典转 模型字典
    JsonModel * jsonModel = [JsonModel mj_objectWithKeyValues:jsondic];
    for (Usergoodsinfojson * storelist in jsonModel.userGoodsInfoJSON) {
        
        [self.storelistArry addObject:storelist];
        
        for (JosnGoodslist * goods in storelist.goodsList) {
            
            [self.goodlistArry addObject:goods];
        }
    }
    //////////   order/generateOrderNumber  ////////// 
    NSLog(@"storelistArry === %@",self.storelistArry);
    NSArray  * storeIdAarray = [Usergoodsinfojson mj_objectArrayWithKeyValuesArray:self.storelistArry];
    
    NSMutableDictionary * dic = [NSMutableDictionary dictionary];
    [dic setValue:storeIdAarray forKey:@"storeList"];
    [dic setValue:_postAddressId forKey:@"postAddressId"];
}


-(void)jsonArryanalysis123123123
{
    [SVProgressHUD show];
    //storeid数组
    NSDictionary * jsondic = [NSString dictionaryWithJsonString:_jsonString];
    
    JsonModel * jsonmodel =[JsonModel mj_objectWithKeyValues:jsondic];
    
    for ( Usergoodsinfojson  * storeList  in jsonmodel.userGoodsInfoJSON) {
        
        [self.storelistArry addObject:storeList];
        
        for (JosnGoodslist * goodlist in storeList.goodsList) {
            
            [self.goodlistArry addObject:goodlist];
            
        }
    }
    
    /////////////////////////////////////////////////////////
    NSArray * storeIdAarray   = [JsonModel mj_keyValuesArrayWithObjectArray:self.storelistArry];//拿到地店铺id
    NSMutableDictionary * dic = [NSMutableDictionary dictionary];
    
    [dic setValue:storeIdAarray forKey:@"storeList"];
    [dic setValue:_postAddressId forKey:@"postAddressId"];
    
    /////////////////////////////////////////////////////////
    NSMutableArray * arr = jsondic[@"userGoodsInfoJSON"];
    
    for (NSDictionary * adic in arr) {
        
        NSMutableDictionary * storeAttachDic = [NSMutableDictionary dictionary];
        NSMutableDictionary * storeidDic     = [NSMutableDictionary dictionary];
        
        /////////////////////////添加到cmgoodlis的storeid////////////////////////////////
        [storeidDic setValue:[adic objectForKey:@"storeId"]  forKey:@"storeId"];
        [self.goodsListArray addObject:storeidDic];
        
        /////////////////////////storeAttachListArr////////////////////////////////
        [storeAttachDic setValue:[adic objectForKey:@"storeId"]  forKey:@"storeId"];
        [storeAttachDic setValue:[adic objectForKey:@"storeName"]  forKey:@"storeName"];
        [storeAttachDic setValue:@"备注" forKey:@"comment"];
        [self.storeAttachListArr addObject:storeAttachDic];
        
        //////////////////////////storeDeliveryfeeListArr///////////////////////////////
        NSMutableDictionary *storeDeliveryfeeDic = [NSMutableDictionary dictionary];
        [storeDeliveryfeeDic setValue:[adic objectForKey:@"storeId"] forKey:@"storeId"];
        [storeDeliveryfeeDic setValue:_orderDeliveryfee forKey:@"orderDeliveryfee"];
        [self.storeDeliveryfeeListArr addObject:storeDeliveryfeeDic];
    }
    
    if (_postAddressId != nil) {
        
        [SVProgressHUD dismissWithDelay:1 completion:^{
            //
            //            [self getGoodsCostInfoListPostRequstWithJsonString:[NSDictionary dictionaryWithDictionary:dic]];//订单数据
            
        }];
        
    }
    
}

-(void)creatCustomfooterView
{
    NSString *buttonTitle = @"提交订单";
    NSString *price       = @"¥0.00";
    NSString *caseOrder   = @"实付金额:";
    
    UIFont * font  =[UIFont systemFontOfSize:14];
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
    CGSize lb_orderSiez = [caseOrder sizeWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:font,NSFontAttributeName, nil]];
    CGFloat lb_orderW   = lb_orderSiez.width;
    lb_order.frame      = CGRectMake(50, 1, lb_orderW+10, 48);
    [_footerView addSubview:lb_order];
    
    //价格
    lb_price               = [[UILabel alloc]init];
    lb_price.text          = price;
    lb_price.textAlignment = NSTextAlignmentLeft;
    lb_price.font          = font;
    lb_price.textColor     = HEXCOLOR(0xfe6d6a);
    lb_price.frame         = CGRectMake(50 +lb_orderW+20, 1, 100, 48);
    [_footerView addSubview:lb_price];
    
    
    UILabel * line =[[ UILabel alloc]initWithFrame:CGRectMake(0, 0, KScreenW, 1)];
    line.backgroundColor = HEXCOLOR(0xdedede);
    [_footerView addSubview:line];
    
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 3;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        return 60;
        
        
    }if (indexPath.row == 1) {
        
        return 70;
    }
    return  62;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (indexPath.row == 0) {
        
        OrderWithAddressCell * addCell = [self.mytableView
                                          dequeueReusableCellWithIdentifier:@"OrderWithAddressCellid" forIndexPath:indexPath];
        addCell.lb_address.text      = _postAddress;
        addCell.lb_nameAndPhone.text = [NSString stringWithFormat:@"收货人: %@  %@",_contactUserName,_contactMobilePhone];
        addCell.selectionStyle       = UITableViewCellSelectionStyleNone;
        return addCell;
    }
    
    else if (indexPath.row == 1) {
        ZFOrderListCell * listCell = [self.mytableView
                                      dequeueReusableCellWithIdentifier:@"ZFOrderListCellid" forIndexPath:indexPath];
        listCell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        if (self.goodlistArry.count > 0) {
            listCell.listArray        = self.goodlistArry;
            listCell.lb_totalNum.text = [NSString stringWithFormat:@"一共%ld件",self.goodlistArry.count] ;
            
        }
        return listCell;
    }
    
    OrderPriceCell * priceCell = [self.mytableView dequeueReusableCellWithIdentifier:@"OrderPriceCellid" forIndexPath:indexPath];
    priceCell.selectionStyle   = UITableViewCellSelectionStyleNone;
    //goodsCount	int(11)	商品总金额
    //costNum	int(11)	配送费总金额
    //userCostNum	int(11)	支付总金额
    
    priceCell.lb_tipFree.text    = _costNum ;
    priceCell.lb_priceTotal.text = _goodsCount ;
    
    return priceCell;
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"section = %ld ,row =%ld ",indexPath.section ,indexPath.row);
    
    if (indexPath.row == 0) {
        ZFAddressListViewController * listVC =[[ ZFAddressListViewController alloc]init];
        [self.navigationController pushViewController:listVC animated:YES];
        NSLog(@"编辑地址");
    }
    if (indexPath.row == 1) {
        
        ZFShopListViewController * shoplistVc =[[ZFShopListViewController alloc]init];
        [self.navigationController pushViewController:shoplistVc animated:YES];
    }
}

#pragma mark - 提交订单 didCleckClearing
-(void)didCleckClearing:(UIButton *)sender
{
    NSLog(@" 确认订单 ");
    
    //还原成字典数组
    NSArray * goodlistArr = [JosnGoodslist mj_keyValuesArrayWithObjectArray:self.goodlistArry];
    NSArray * feelistArr  = [NSArray arrayWithArray:self.storeDeliveryfeeListArr];
    
    NSLog(@"-----feelistArr-%@---------goodlistArr--%@------",feelistArr,goodlistArr);
    /////////////////////////// 一个大集合 /////////////////////////////////////////////
    NSMutableDictionary * jsondic = [NSMutableDictionary dictionary] ;
    
    [jsondic setValue:BBUserDefault.cmUserId forKey:@"cmUserId"];
    [jsondic setValue:_postAddressId forKey:@"postAddressId"];
    [jsondic setValue:_contactUserName forKey:@"contactUserName" ];
    [jsondic setValue:@"1" forKey:@"payMode" ];
    
    [jsondic setValue:_postAddress forKey:@"postAddress"];
    [jsondic setValue:_contactMobilePhone forKey:@"contactMobilePhone"];
    
    [jsondic setValue: goodlistArr forKey:@"cmGoodsList"];
    [jsondic setValue: feelistArr forKey:@"storeDeliveryfeeList"];
    [jsondic setValue: self.storeAttachListArr forKey:@"storeAttachList"];
    
    NSDictionary * successDic = [NSDictionary dictionaryWithDictionary:jsondic];
    NSLog(@"提交订单 -----------%@",successDic);
    
    
    //[self commitOrder:successDic];
    
    
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
        
        NSLog(@"progeress=====%@",progeress);
        
    } failure:^(NSError *error) {
        
        NSLog(@"error=====%@",error);
        [self.view makeToast:@"网络错误" duration:2 position:@"center"];
    }];
    //
    
}

#pragma mark -  getGoodsCostInfo 用户订单确定费用信息接口
-(void)getGoodsCostInfoListPostRequstWithJsonString:(NSDictionary *) jsondic
{
    
    [MENetWorkManager post:[NSString stringWithFormat:@"%@/getGoodsCostInfo",zfb_baseUrl] params:jsondic success:^(id response) {
        
        if ([response[@"resultCode"] intValue ] == 0) {
            SureOrderModel * suremodel = [SureOrderModel mj_objectWithKeyValues:response];
            
            for (Storedeliveryfeelist * feelist in suremodel.storeDeliveryfeeList) {
                
                [self.feeList addObject:feelist];
                
            }
            //        orderDeliveryfee	int(11)	每家门店的配送费
            //        goodsCount	int(11)	商品总金额
            //        costNum	int(11)	配送费总金额
            //        userCostNum	int(11)	支付总金额
            self.storeDeliveryfeeListArr = response[@"storeDeliveryfeeList"];
            
            _goodsCount   = [NSString stringWithFormat:@"¥%.2f",suremodel.goodsCount]  ;//商品总金额
            _costNum      = [NSString stringWithFormat:@"+ ¥%.2f",suremodel.costNum]  ;//配送费总金额
            _userCostNum  = [NSString stringWithFormat:@"¥%.2f",suremodel.userCostNum]  ;//支付总金额
            lb_price.text = _userCostNum;
            
        }
        
        [self.mytableView reloadData];
        
    } progress:^(NSProgress *progeress) {
        
        NSLog(@"progeress=====%@",progeress);
        
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
        
        NSDictionary * orderListdic = [NSDictionary dictionaryWithDictionary:response] ;
        
        NSArray * array = orderListdic[@"orderList"];
        
        for (NSDictionary * dicto in array) {
            NSMutableDictionary * mutOrder = [NSMutableDictionary dictionary];
            
            [mutOrder setValue:[dicto objectForKey:@"orderNum"] forKey:@"orderNum"];
            [mutOrder setValue:[dicto objectForKey:@"body"] forKey:@"body"];
            [mutOrder setValue:[dicto objectForKey:@"title"] forKey:@"title"];
            [mutOrder setValue:[dicto objectForKey:@"pay_money"] forKey:@"pay_money"];
            [mutOrder setValue:@"10"forKey:@"total_amount"];
            [mutOrder setValue:@"11"forKey:@"discountable_amount"];
            
            [self.mutOrderlistArr addObject:mutOrder];
        }
        NSLog(@"self.mutOrderlistArr == %@",self.mutOrderlistArr);
        
        NSMutableDictionary * listdict = [NSMutableDictionary dictionary];
        [listdict setValue:[NSArray arrayWithArray:self.mutOrderlistArr] forKey:@"orderList"];
        
        NSString * jsonstr = [NSString convertToJsonData:listdict];
        
        [SVProgressHUD dismissWithDelay:2];
        
        //跳转到webview
        ZFMainPayforViewController * payVC = [[ZFMainPayforViewController alloc]init];
        if (listdict != nil) {
            
            payVC.orderjsonString = jsonstr;
            payVC.datetime        = _datetime;
            payVC.access_token    = _access_token;
            
            [self.navigationController pushViewController:payVC animated:YES];
            
        }
    } progress:^(NSProgress *progeress) {
        
        NSLog(@"progeress=====%@",progeress);
        
    } failure:^(NSError *error) {
        
        NSLog(@"error=====%@",error);
        [self.view makeToast:@"网络错误" duration:2 position:@"center"];
    }];
    [SVProgressHUD dismissWithDelay:2];
    
    
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
        
    } progress:^(NSProgress *progeress) {
        
        NSLog(@"progeress=====%@",progeress);
        
    } failure:^(NSError *error) {
        
        NSLog(@"error=====%@",error);
        [self.view makeToast:@"网络错误" duration:2 position:@"center"];
    }];
    
    
}



#pragma webview


-(NSMutableArray *)mutOrderlistArr{
    if (!_mutOrderlistArr) {
        _mutOrderlistArr = [NSMutableArray array];
    }
    return  _mutOrderlistArr;
}
-(NSMutableArray *)storeDeliveryfeeListArr
{
    if (!_storeDeliveryfeeListArr) {
        _storeDeliveryfeeListArr =[NSMutableArray array];
        
    }
    return _storeDeliveryfeeListArr;
}
-(NSMutableArray *)storeAttachListArr
{
    if (!_storeAttachListArr) {
        _storeAttachListArr =[NSMutableArray array];
        
    }
    return _storeAttachListArr;
}

-(NSMutableArray *)feeList
{
    if (!_feeList) {
        _feeList =[NSMutableArray array];
        
    }
    return _feeList;
}

-(NSMutableArray *)goodsListArray
{
    if (!_goodsListArray) {
        _goodsListArray =[NSMutableArray array];
        
    }
    return _goodsListArray;
}

-(NSMutableArray *)storelistArry
{
    if (!_storelistArry) {
        _storelistArry = [NSMutableArray array];
    }
    return _storelistArry;
}

-(NSMutableArray *)imgArray
{
    if (!_imgArray) {
        _imgArray =[NSMutableArray array];
        
    }
    return _imgArray;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
