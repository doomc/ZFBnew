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

#import "ZFMainPayforViewController.h"
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
    
    [self getPayAccessTokenUrl];//获取token 和签名
    
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
    return 4;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView * view = nil;
    if (section == 1) {
        //店铺名称
        
        ZFOrderDetailSectionCell* storeCell = [self.tableView dequeueReusableCellWithIdentifier:sectionDetailCellid ];
        storeCell.lb_storeName.text =  storeName;
        
        return storeCell;
        
    }
    
    return view;
    
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
        if (indexPath.row  < 2) {
            
            height = 44;
            
        }
        else {
            
            height = 70;
            
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
            [addressCell.image_noData setHidden:YES];
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
            detailCell.lb_detaileFootTitle.text =payMethodName;
            cell  = detailCell;
            
        }
        else if (indexPath.row == 1) {
            
            ZFOrderDetailCell* detailCell = [self.tableView dequeueReusableCellWithIdentifier:commonDetailCellid forIndexPath:indexPath];
            detailCell.lb_detailtitle.text = @"配送信息";
            detailCell.lb_detaileFootTitle.text = [NSString stringWithFormat:@"%@ %@",deliveryName,deliveryPhone];
            cell  = detailCell;
            
        }
        
        else if (indexPath.row == 2) {
            
            ZFOrderDetailCountCell* countCell = [self.tableView dequeueReusableCellWithIdentifier:kcountDetailCellid forIndexPath:indexPath];
            countCell.lb_freeSendPrice.text = deliveryFee;
            countCell.lb_goodsAllPrice .text = goodsAmount;
            
            cell                              = countCell;
            
        }
        else  {
            
            ZFOrderDetailPaycashCell* payCell = [self.tableView dequeueReusableCellWithIdentifier:payCashDetailCellid forIndexPath:indexPath];
            payCell.lb_realPay.text = payRelPrice;
            payCell.lb_orderCreatTime.text = createTime;
            cell                              = payCell;
            
        }
    }
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"%ld = section ,%ld = row ",indexPath.section,indexPath.row);
}

#pragma mark  - 网络请求 getUserInfo
-(void)getOrderDetailsInfoPostResquestcmOrderid:(NSString*) cmOrderId
{
    NSDictionary * parma = @{
                             
                             @"cmOrderid":cmOrderId,
                             };
    [SVProgressHUD show];
    [MENetWorkManager post:[zfb_baseUrl stringByAppendingString:@"/order/getOrderDetailsInfo"] params:parma success:^(id response) {
        
        if ([response[@"resultCode"]intValue ]==0) {
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

            _payStatus = orderModel.orderDetails.payStatus;//支付状态
            //0.未支付的初始状态  1.支付成功 -1.支付失败  3.付款发起   4.付款取消 (待付款) 5.退款成功（支付成功的）6.退款发起(支付成功) 7.退款失败(支付成功)
            
            //配送信息
            deliveryName  = orderModel.deliveryInfo.deliveryName;
            deliveryPhone  = orderModel.deliveryInfo.deliveryPhone;
            
            //价格
            goodsAmount = orderModel.orderDetails.goodsAmount;//总价
            deliveryFee = orderModel.orderDetails.deliveryFee;//配送费用
            payRelPrice = orderModel.orderDetails.payRelPrice;//实际支付
            
            //店铺名称
            storeName = orderModel.shoppCartList.storeName;
 
            NSLog(@"我当前是 属于商户端还是配送端 %@",BBUserDefault.shopFlag);
            if ([BBUserDefault.shopFlag isEqualToString:@"1"] && [orderStatusName isEqualToString:@"待付款"] && [payMethodName isEqualToString:@"线下支付"]) {
            
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
#pragma mark -商户端确认收货   userConfirmReceipt
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

#pragma mark - 获取支付accessToken值，通过accessToken值获取支付签名
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
        
        NSLog(@"_access_token = %@",_access_token);
        NSLog(@"\n 我的当前的时间是====================_datetime = %@",_datetime);

    } progress:^(NSProgress *progeress) {
        
    } failure:^(NSError *error) {
        
        NSLog(@"error=====%@",error);
        [self.view makeToast:@"网络错误" duration:2 position:@"center"];
    }];
    
}
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
        
        [self paysignData];
        
    }
    
}
//需要签名的数据 ***************** 进入支付 *****************
-(void)paysignData
{
    NSLog(@"_unpayOrderInfoArray === %@",_unpayOrderInfoArray);
    NSMutableDictionary * mutOrderDic = [NSMutableDictionary dictionary];
    NSMutableArray * mutOrderArray  = [NSMutableArray array];
    for (NSDictionary * orderdic in _unpayOrderInfoArray) {
        
        [mutOrderDic setValue:[orderdic objectForKey:@"order_num"] forKey:@"order_num"];
        [mutOrderDic setValue:[orderdic objectForKey:@"body"]forKey:@"body"];
        [mutOrderDic setValue:[orderdic objectForKey:@"pay_money"] forKey:@"pay_money"];
        [mutOrderDic setValue:[orderdic objectForKey:@"title"] forKey:@"title"];

        [mutOrderArray addObject:mutOrderDic];
    }
    
    //跳转到webview
    ZFMainPayforViewController * payVC = [[ZFMainPayforViewController alloc]init];
    //支付的回调地址
    payVC.notify_url    = _thirdUrlDic[@"notify_url"];
    payVC.return_url    = _thirdUrlDic[@"return_url"];
    payVC.gateWay_url   = _thirdUrlDic[@"gateWay_url"];
    
    payVC.orderListArray  = [NSArray arrayWithArray:mutOrderArray];
    payVC.datetime        = _datetime;
    payVC.access_token    = _access_token;
    [self.navigationController pushViewController:payVC animated:YES];

}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
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
