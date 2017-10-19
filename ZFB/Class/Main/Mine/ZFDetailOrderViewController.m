//
//  ZFDetailOrderViewController.m
//  ZFB
//
//  Created by  展富宝  on 2017/5/27.
//  Copyright © 2017年 com.zfb. All rights reserved.
//  订单详情

#import "ZFDetailOrderViewController.h"

#import "ZFOrderDetailCell.h" //公共cell
#import "OrderWithAddressCell.h"//地址
#import "ZFOrderDetailCountCell.h"//商品金额+配送费
#import "ZFOrderDetailPaycashCell.h"//付款
#import "ZFOrderDetailSectionCell.h" //店铺名称
#import "ZFOrderDetailGoosContentCell.h"//商品简要
#import "ZFDetailsStoreViewController.h"//门店详情
#import "DetailFindGoodsViewController.h"//商品详情

//#import "ZFMainPayforViewController.h"
#import "CheckstandViewController.h"//收银台
#import "DetailOrderModel.h"//模型

static  NSString * commonDetailCellid   = @"ZFOrderDetailCellid";
static  NSString * addressCellid        = @"ZFOrderWithAddressCellid";
static  NSString * kcountDetailCellid   = @"ZFOrderDetailCountCellid";
static  NSString * payCashDetailCellid  = @"ZFOrderDetailPaycashCellid";
static  NSString * sectionDetailCellid  = @"ZFOrderDetailSectionCellid";
static  NSString * kcontentDetailCellid = @"ZFOrderDetailGoosContentCellid";

@interface ZFDetailOrderViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    NSString * nickName;
    NSString * mobilePhone;
    NSString * postAddress;
    
    NSString * ordernum;//订单号
    NSString * orderStatusName;//订单状态
    NSString * payStatusName;
    NSString * storeName;
    
    NSString * createTime;
    NSString * payMethodName;
    
    NSString * deliveryName;
    NSString * deliveryPhone;
    
    NSString * goodsAmount;
    NSString * deliveryFee;
    NSString * payRelPrice;
    
    NSString * _datetime;
    NSString * _access_token;//token
    
    NSString * _payStatus;//支付状态
    NSString * _deliveryId;
    NSString * _couponAmount;//优惠价格
    
    NSString * _paySign;//签名
    
}
@property (nonatomic,strong) UITableView *  tableView;
@property (nonatomic,strong) UIView      *  footerView;
@property (nonatomic,strong) UIButton    *  sure_payfor;//确认支付

@property (nonatomic,assign) OrderDetailType orderDetailType;

@property (nonatomic,strong ) NSMutableArray * paySignArray;//签名数组
@property (nonatomic,strong ) NSMutableArray * shoppCartList;//商品数组
@property (nonatomic,strong ) NSArray * unpayOrderInfoArray;//传到下一级支付的参数
@property (nonatomic,strong ) NSDictionary * thirdUrlDic;//传到下一级支付的参数

@end

@implementation ZFDetailOrderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"订单详情";
    
    [self.view addSubview:self.tableView];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"ZFOrderDetailCell" bundle:nil]
         forCellReuseIdentifier:commonDetailCellid];//公共cell
    
    [self.tableView registerNib:[UINib nibWithNibName:@"OrderWithAddressCell" bundle:nil]
         forCellReuseIdentifier:addressCellid];//地址
    
    [self.tableView registerNib:[UINib nibWithNibName:@"ZFOrderDetailCountCell" bundle:nil]
         forCellReuseIdentifier:kcountDetailCellid];//商品金额+配送费
    
    [self.tableView registerNib:[UINib nibWithNibName:@"ZFOrderDetailPaycashCell" bundle:nil]
         forCellReuseIdentifier:payCashDetailCellid];//付款
    
    [self.tableView registerNib:[UINib nibWithNibName:@"ZFOrderDetailSectionCell" bundle:nil]
         forCellReuseIdentifier:sectionDetailCellid];//店铺名称
    
    [self.tableView registerNib:[UINib nibWithNibName:@"ZFOrderDetailGoosContentCell" bundle:nil]
         forCellReuseIdentifier:kcontentDetailCellid];//商品简要
    
    
}
-(UITableView *)tableView
{
    if (!_tableView) {
        _tableView            = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, KScreenW, KScreenH -64) style:UITableViewStylePlain];
        _tableView.delegate   = self;
        _tableView.dataSource = self;
    }
    return _tableView;
    
}

-(UIButton *)sure_payfor
{
    if (!_sure_payfor) {
        _sure_payfor = [UIButton buttonWithType:UIButtonTypeCustom];
        [_sure_payfor setTitle:@"去付款" forState:UIControlStateNormal];
        [_sure_payfor setBackgroundColor:HEXCOLOR(0xfe6d6a)];
        UIFont *font  =[UIFont systemFontOfSize:15];
        _sure_payfor.titleLabel.font    = font;
        CGSize size                     = [_sure_payfor.titleLabel.text sizeWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:font,NSFontAttributeName,nil]];
        CGFloat width                   = size.width;
        _sure_payfor.frame              = CGRectMake(KScreenW - width - 80, 10, width +50, 30);
        _sure_payfor.layer.cornerRadius = 2;
        [_sure_payfor addTarget:self action:@selector(didClickPayFor:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _sure_payfor;
}

-(UIView *)footerView
{
    if (!_footerView) {
        
        _footerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, KScreenW, 50)];
        _footerView.backgroundColor = [UIColor whiteColor];
        [_footerView addSubview:self.sure_payfor];
    }
    return  _footerView;
}


-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 2;
    }
    if (section == 1) {
        
        return self.shoppCartList.count;
        //        return 1;//暂时写死
    }
    return 5;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView * view = nil;
    if (section == 1) {
        //店铺名称
        
        ZFOrderDetailSectionCell* storeCell = [self.tableView dequeueReusableCellWithIdentifier:sectionDetailCellid ];
        storeCell.lb_storeName.text =  storeName;
        [storeCell.storeBtn addTarget:self action:@selector(didClickStoreMessage) forControlEvents:UIControlEventTouchUpInside];
        return storeCell;
        
    }
    
    return view;
}
///点击门店信息
-(void)didClickStoreMessage
{
    ZFDetailsStoreViewController * storeVC= [ZFDetailsStoreViewController new];
    storeVC.storeId = _storeId;
    [self.navigationController pushViewController:storeVC animated:NO];
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 1) {
        return 40;
    }
    return 0.001;
}
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    return self.footerView;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    CGFloat footHight = 0.001;
    
    if ( section == 2) {
        
        return 50;
    }
    return footHight;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat height = 0;
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            
            height = 40;
            return height;
        }
        else if (indexPath.row == 1) {
            
            height = 60;
            
            return height;
        }
        
    }
    else if (indexPath.section == 1) {
        
        height = 100;
        
    }
    if (indexPath.section == 2) {
        if (indexPath.row  == 0) {
           
            height = 44;

        }
        else if (indexPath.row  == 1) {
            
            if (deliveryName == nil || [deliveryName isEqualToString:@""]) {
                
                height = 0;
                
            }else{
                height = 44;
                
            }
        }
        else if (indexPath.row  == 2) {
            if (_couponAmount == nil || [_couponAmount isEqualToString:@""]) {
                
                height = 0;
                
            }else{
                height = 44;
            }
        }
        else if (indexPath.row  == 3) {
            
            height = 70;

        }
        else {
            
            height = 78;
            
        }
    }
    return height;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell  * cell = nil;
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            
            ZFOrderDetailCell* detailCell       = [self.tableView dequeueReusableCellWithIdentifier:commonDetailCellid forIndexPath:indexPath];
            Unpayorderinfo * payinfo = self.paySignArray[indexPath.row];
            detailCell.lb_detailtitle.text      = [NSString stringWithFormat:@"订单号：%@",payinfo.order_num];
            detailCell.lb_detaileFootTitle.text = orderStatusName;
            detailCell.lb_detaileFootTitle.textColor = HEXCOLOR(0xfe6d6a);
            cell = detailCell;
            
        }
        else if (indexPath.row == 1) {
            
            OrderWithAddressCell* addressCell = [self.tableView dequeueReusableCellWithIdentifier:addressCellid forIndexPath:indexPath];
            [addressCell.defaultButton setHidden:YES];
            [addressCell.img_arrow setHidden:YES];
            [addressCell.nodataView setHidden:YES];
            addressCell.lb_nameAndPhone.text = [NSString stringWithFormat:@"%@ %@",nickName,mobilePhone];
            addressCell.lb_address.text =  postAddress;
            cell                              = addressCell;
            
        }
        
    }
    else if (indexPath.section == 1)
    {
        
        ZFOrderDetailGoosContentCell* goodsCell = [self.tableView dequeueReusableCellWithIdentifier:kcontentDetailCellid forIndexPath:indexPath];
        
        if (self.shoppCartList.count > 0) {
            
            DetailGoodslist * goodlist = self.shoppCartList[indexPath.row];
            goodsCell.goodlist = goodlist;
        }
        
        cell = goodsCell;
        
    }
    
    else if (indexPath.section == 2)
    {
        if (indexPath.row == 0) {
            
            ZFOrderDetailCell* detailCell = [self.tableView dequeueReusableCellWithIdentifier:commonDetailCellid forIndexPath:indexPath];
            detailCell.lb_detailtitle.text = @"支付方式";
            detailCell.lb_detaileFootTitle.text = payMethodName;
            cell  = detailCell;
            
        }
        else if (indexPath.row == 1) {
            
            ZFOrderDetailCell* detailCell = [self.tableView dequeueReusableCellWithIdentifier:commonDetailCellid forIndexPath:indexPath];
            if (deliveryName == nil || [deliveryName isEqualToString:@""]) {
          
                [detailCell setHidden: YES];

            }else{
                detailCell.lb_detailtitle.text = @"配送信息";
                detailCell.lb_detaileFootTitle.text = [NSString stringWithFormat:@"%@ %@",deliveryName,deliveryPhone];
            }

            cell  = detailCell;
            
        }
        else if (indexPath.row == 2) {//折扣信息
            
            ZFOrderDetailCell* detailCell = [self.tableView dequeueReusableCellWithIdentifier:commonDetailCellid forIndexPath:indexPath];
            if (_couponAmount == nil || [_couponAmount isEqualToString:@""]) {
                
                [detailCell setHidden: YES];
                
            }else{
                detailCell.lb_detailtitle.text = @"折扣信息";
                detailCell.lb_detaileFootTitle.text = [NSString stringWithFormat:@"已优惠%@元",_couponAmount];
            }

            cell  = detailCell;
        }

        else if (indexPath.row == 3) {//配送金额
            
            ZFOrderDetailCountCell* countCell = [self.tableView dequeueReusableCellWithIdentifier:kcountDetailCellid forIndexPath:indexPath];
            countCell.lb_freeSendPrice.text = [NSString stringWithFormat:@"¥%@",deliveryFee]  ;
            countCell.lb_goodsAllPrice .text = [NSString stringWithFormat:@"¥%@",goodsAmount] ;
            
            cell                              = countCell;
            
        }
        else  {
            
            ZFOrderDetailPaycashCell* payCell = [self.tableView dequeueReusableCellWithIdentifier:payCashDetailCellid forIndexPath:indexPath];
            payCell.lb_realPay.text = [NSString stringWithFormat:@"¥%@",payRelPrice] ;
            payCell.lb_orderCreatTime.text = createTime;
            cell                              = payCell;
            
        }
    }
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"%ld = section ,%ld = row ",indexPath.section,indexPath.row);
    DetailFindGoodsViewController * goodVC= [DetailFindGoodsViewController new];
   
    if (indexPath.section == 1) {

        DetailGoodslist * goodlist = self.shoppCartList[indexPath.row];
        goodVC.goodsId = goodlist.goodsId;
        goodVC.headerImage = _imageUrl;
        [self.navigationController pushViewController:goodVC animated:NO];
        
        
    }
}

#pragma mark  - 网络请求 getUserInfo
-(void)getOrderDetailsInfoPostResquestcmOrderid:(NSString*) cmOrderId
{
    NSDictionary * parma = @{
                             
                             @"cmOrderid":cmOrderId,
                             };
    [SVProgressHUD show];
    [MENetWorkManager post:[zfb_baseUrl stringByAppendingString:@"/order/getOrderDetailsInfo"] params:parma success:^(id response) {
        
        NSString * code = [NSString stringWithFormat:@"%@", response[@"resultCode"]];
        
        if([code isEqualToString:@"0"]){
            
            if (self.shoppCartList.count > 0) {
                [self.shoppCartList removeAllObjects];
            }
            DetailOrderModel * orderModel = [DetailOrderModel mj_objectWithKeyValues:response];
            
            //签名数据
            _unpayOrderInfoArray = response[@"unpayOrderInfo"];
            _thirdUrlDic = response[@"thirdURI"];
            
            //签名数组
            for (Unpayorderinfo * unpay in orderModel.unpayOrderInfo) {
                [self.paySignArray addObject:unpay];
                ordernum = unpay.order_num ;
                
            }
            //商品列表
            for (DetailShoppcartlist * list in orderModel.shoppCartList.goodsList) {
                
                [self.shoppCartList addObject:list];
            }
            //地址信息
            nickName    = orderModel.cmUserInfo.nickName ;
            mobilePhone = orderModel.cmUserInfo.mobilePhone ;
            postAddress = orderModel.cmUserInfo.postAddress ;
            
            //订单信息
            orderStatusName = orderModel.orderDetails.orderStatusName ;//配送状态
            payMethodName   = orderModel.orderDetails.payMethodName;
            createTime      = [NSString stringWithFormat:@"下单时间:%@",orderModel.orderDetails.createTime] ;//订单时间
            
            //0.未支付的初始状态  1.支付成功 -1.支付失败  3.付款发起   4.付款取消 (待付款) 5.退款成功（支付成功的）6.退款发起(支付成功) 7.退款失败(支付成功)
            _payStatus = orderModel.orderDetails.payStatus;//支付状态
            
            //1.支付宝  2.微信支付 3.线下,4.展易付
            NSInteger payMethod = orderModel.orderDetails.payMethod;
            
            //配送信息
            deliveryName  = orderModel.deliveryInfo.deliveryName;
            deliveryPhone  = orderModel.deliveryInfo.deliveryPhone;
            
            //价格
            goodsAmount = orderModel.orderDetails.goodsAmount;//总价
            deliveryFee = orderModel.orderDetails.deliveryFee;//配送费用
            payRelPrice = orderModel.orderDetails.payRelPrice;//实际支付
            
            //店铺名称
            storeName = orderModel.shoppCartList.storeName;
            //优惠价格
            _couponAmount = orderModel.orderDetails.couponAmount; 

            NSLog(@"我当前是 属于商户端还是配送端 %@",BBUserDefault.shopFlag);
            if ([BBUserDefault.shopFlag isEqualToString:@"1"] && [orderStatusName isEqualToString:@"待付款"] &&  payMethod == 3  ) {
                
                [self.sure_payfor setTitle:@"确认取货" forState:UIControlStateNormal];
                [self.sure_payfor setHidden:NO];
                
            }else{
                [self.sure_payfor setHidden:YES];
                self.sure_payfor.enabled = NO;
                
                if ([orderStatusName isEqualToString:@"待付款"]) {
                    
                    [self.sure_payfor setTitle:@"去付款" forState:UIControlStateNormal];
                    self.sure_payfor.enabled = YES;
                    self.sure_payfor.hidden = NO;
                    
                }
                else{
                    [self.sure_payfor setHidden:YES];
                    self.sure_payfor.enabled = NO;
                    
                }
            }
            [SVProgressHUD dismiss];
        }
        [self.tableView reloadData];
        
        
    } progress:^(NSProgress *progeress) {
        
    } failure:^(NSError *error) {
        [SVProgressHUD dismiss];
        NSLog(@"error=====%@",error);
        [self.view makeToast:@"网络错误" duration:2 position:@"center"];
    }];
    
}
#pragma mark - 商户端确认收货   userConfirmReceipt 用户确认取货
-(void)bussniessAcceptgoodsPost
{
    NSDictionary * param = @{
                             
                             @"orderStatus": @"2",
                             @"orderNum"   : ordernum,
                             @"payStatus"  : _payStatus,
                             @"deliveryId" : _deliveryId,
                             
                             };
    
    [MENetWorkManager post:[NSString stringWithFormat:@"%@/order/userConfirmReceipt",zfb_baseUrl] params:param success:^(id response) {
        
        [self.view makeToast:response[@"resultMsg"] duration:2 position:@"center"];
        //取货完毕后刷新状态
        [self getOrderDetailsInfoPostResquestcmOrderid:_cmOrderid];
        
    } progress:^(NSProgress *progeress) {
        
        NSLog(@"progeress=====%@",progeress);
        
    } failure:^(NSError *error) {
        
        NSLog(@"error=====%@",error);
        [self.view makeToast:@"网络错误" duration:2 position:@"center"];
    }];
    
}

//#pragma mark - 获取支付accessToken值，通过accessToken值获取支付签名
//-(void)getPayAccessTokenUrl
//{
// 
//    NSDictionary * param = @{
//                             @"account":  BBUserDefault.userPhoneNumber,
//                             };
//    
//    [MENetWorkManager post:[NSString stringWithFormat:@"%@/order/getPayAccessToken",zfb_baseUrl] params:param success:^(id response) {
//        NSString * code = [NSString stringWithFormat:@"%@", response[@"resultCode"]];
//        if([code isEqualToString:@"0"]){
//
//            _access_token = response[@"accessToken"];
//            
//            NSLog(@"_access_token = %@",_access_token);
//            NSLog(@"\n 我的当前的时间是====================_datetime = %@",_datetime);
//        }
//    } progress:^(NSProgress *progeress) {
//        
//    } failure:^(NSError *error) {
//        
//        NSLog(@"error=====%@",error);
//        [self.view makeToast:@"网络错误" duration:2 position:@"center"];
//    }];
//    
//}
#pragma mark  - didClickPayFor  去付款
- (void)didClickPayFor:(UIButton *)sender {
    NSLog(@" --------去付款了 ---------");
    
    if ([BBUserDefault.shopFlag isEqualToString:@"1"] && [self.sure_payfor.titleLabel.text isEqualToString:@"确认取货"]) {
        
        JXTAlertController * alertavc =[JXTAlertController alertControllerWithTitle:@"提示" message:@"确认用户已经收货了吗" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction * cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        UIAlertAction * sureAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
            //确认收货吗
            [self bussniessAcceptgoodsPost];
            
        }];
        [alertavc addAction:cancelAction];
        [alertavc addAction:sureAction];
        [self presentViewController:alertavc animated:YES completion:nil];
        
    }else{
        
        //签名数据
        [self getPaypaySignAccessTokenUrl];
        
    }
    
}

#pragma mark - 获取支付paySign值
-(void)getPaypaySignAccessTokenUrl
{
    NSLog(@"_unpayOrderInfoArray === %@",_unpayOrderInfoArray);

    [SVProgressHUD show];
    NSString * listJsonString  =  [NSString arrayToJSONString:_unpayOrderInfoArray];
    NSMutableDictionary * params = [NSMutableDictionary dictionary];

    [params setValue:BBUserDefault.userPhoneNumber forKey:@"account"];
    [params setValue:_datetime forKey:@"datetime"];//yyyy-MM-dd HH:mm:ss（北京时间）
    [params setValue:_thirdUrlDic[@"notify_url"] forKey:@"notify_url"];//异步通知地址（用于接收订单支付通知）
    [params setValue:_thirdUrlDic[@"return_url"] forKey:@"return_url"];//同步通知地址（支付成功后的跳转）
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
    NSString * listJsonString  = [NSString arrayToJSONString:_unpayOrderInfoArray];
    [params setValue:_paySign forKey:@"sign"];//回传参数：商户可自定义该参数，在支付回调后带回
    [params setValue:BBUserDefault.userPhoneNumber forKey:@"account"];
    [params setValue:_datetime forKey:@"datetime"];//yyyy-MM-dd HH:mm:ss（北京时间）
    [params setValue:_thirdUrlDic[@"notify_url"] forKey:@"notify_url"];//异步通知地址（用于接收订单支付通知）
    [params setValue:_thirdUrlDic[@"return_url"] forKey:@"return_url"];//同步通知地址（支付成功后的跳转）
    [params setValue:listJsonString forKey:@"order_list"];//Json格式的订单字符集
    [params setValue:@"" forKey:@"passback_params"];//回传参数：商户可自定义该参数，在支付回调后带回
    NSDictionary * dic  = [NSDictionary dictionaryWithDictionary:params];
  
    CheckstandViewController * payVC = [CheckstandViewController new];
    payVC.amount = payRelPrice;
    payVC.notifyUrl = _thirdUrlDic[@"notify_url"];
    payVC.signDic = dic;
    [self.navigationController pushViewController:payVC animated:NO];
    
}


- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    NSDate * date = [NSDate date];
    _datetime     = [dateTimeHelper timehelpFormatter: date];//2017-07-20 17:08:54

    if ([_cmOrderid isEqual:[NSNull null]]) {
        _cmOrderid = @"";
    }
    
    NSLog(@"_cmOrderid  == ==== == == %@",_cmOrderid);
    if ( ![_cmOrderid isEqualToString:@"null"]) {
        
        [self getOrderDetailsInfoPostResquestcmOrderid:_cmOrderid];
        
    }
    
}
-(void)viewWillDisappear:(BOOL)animated
{
    [SVProgressHUD dismiss];
}

-(NSMutableArray *)shoppCartList
{
    if (!_shoppCartList) {
        _shoppCartList = [NSMutableArray array];
    }
    return _shoppCartList;
}

-(NSMutableArray *)paySignArray
{
    if (!_paySignArray) {
        _paySignArray = [NSMutableArray array];
    }
    return _paySignArray;
}
@end
