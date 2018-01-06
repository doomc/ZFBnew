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
#import "MainStoreViewController.h"//门店详情
//#import "DetailFindGoodsViewController.h"//商品详情
#import "GoodsDeltailViewController.h"

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
    NSString * orderStatus;//订单状态
    
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
    NSString * _payType;
    NSString * _orderComment;//备注
    CGFloat _commentTextHeight ;//备注 -文字高度

}
@property (nonatomic,strong) UITableView *  tableView;

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
        _tableView            = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, KScreenW, KScreenH -64 ) style:UITableViewStylePlain];
        _tableView.delegate   = self;
        _tableView.dataSource = self;
        
    }
    return _tableView;
    
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
    }
    return 6;
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
    MainStoreViewController * storeVC= [MainStoreViewController new];
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
    UIView * footerView = nil;
    if (section == 2) {
        if (footerView == nil) {
            footerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, KScreenW, 50)];
            footerView.backgroundColor = [UIColor whiteColor];
            _sure_payfor = [UIButton buttonWithType:UIButtonTypeCustom];
            _sure_payfor.layer.cornerRadius = 4;
            _sure_payfor.layer.masksToBounds = YES;
            [_sure_payfor setBackgroundColor:HEXCOLOR(0xf95a70)];
            UIFont *font  =[UIFont systemFontOfSize:15];
            _sure_payfor.titleLabel.font    = font;
            [_sure_payfor addTarget:self action:@selector(didClickPayFor:) forControlEvents:UIControlEventTouchUpInside];
            
            //orderStatus -1：关闭,0待配送 1配送中 2.配送完成，3交易完成（用户确认收货）,4.待付款,5.待审批,6.待退回，7.服务完成 8 待接单 9.代发货 10.已发货 11.处理付款中 12.付款失败
            NSLog(@"我当前是 _isUserType  %ld",_isUserType);
            if (_isUserType == 1) { //商户
                if ([_payType isEqualToString:@"1"] && [orderStatus isEqualToString:@"4"]) {
                    
                    [self.sure_payfor setTitle:@"确认取货" forState:UIControlStateNormal];
                    [self.sure_payfor setHidden:NO];
                }else{
                   
                    [self.sure_payfor setHidden:YES];
                }
            }else{//普通用户
                if([orderStatus isEqualToString:@"4"]){
                    self.sure_payfor.hidden = NO;
                    [self.sure_payfor setTitle:@"去付款" forState:UIControlStateNormal];
                }else{
                    [self.sure_payfor setHidden:YES];
                    
                }
            }if (_sure_payfor.titleLabel.text.length > 0) {
                CGSize size                     = [_sure_payfor.titleLabel.text sizeWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:font,NSFontAttributeName,nil]];
                CGFloat width                   = size.width;
                _sure_payfor.frame              = CGRectMake(KScreenW - width - 80, 10, width +50, 30);
            }
            [footerView addSubview:_sure_payfor];
        }
    }
    return footerView;
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
   
        }
        else if (indexPath.row == 1) {
            height = 60;
 
        }
    }
    else if (indexPath.section == 1) {
        height = 100+25;
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
        else if (indexPath.row  == 4) {
            
            height = _commentTextHeight;
        }
        else {
            height = 78;
        }
    }
    return height;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            
            ZFOrderDetailCell* detailCell       = [self.tableView dequeueReusableCellWithIdentifier:commonDetailCellid forIndexPath:indexPath];
            if (self.paySignArray.count > 0) {
                Unpayorderinfo * payinfo = self.paySignArray[indexPath.row];
                detailCell.lb_detailtitle.text      = [NSString stringWithFormat:@"订单号：%@",payinfo.order_num];
                detailCell.lb_detaileFootTitle.text = orderStatusName;
                detailCell.lb_detaileFootTitle.textColor = HEXCOLOR(0xf95a70);
             }
            return detailCell;
       }
        else if (indexPath.row == 1) {
            
            OrderWithAddressCell* addressCell = [self.tableView dequeueReusableCellWithIdentifier:addressCellid forIndexPath:indexPath];
            [addressCell.defaultButton setHidden:YES];
            [addressCell.img_arrow setHidden:YES];
            [addressCell.nodataView setHidden:YES];
            addressCell.lb_nameAndPhone.text = [NSString stringWithFormat:@"%@ %@",nickName,mobilePhone];
            addressCell.lb_address.text =  postAddress;
            return  addressCell;
            
        }
        
    }
    else if (indexPath.section == 1){
        
        ZFOrderDetailGoosContentCell* goodsCell = [self.tableView dequeueReusableCellWithIdentifier:kcontentDetailCellid forIndexPath:indexPath];
        
        if (self.shoppCartList.count > 0) {
            
            DetailGoodslist * goodlist = self.shoppCartList[indexPath.row];
            goodsCell.goodlist = goodlist;
        }
        
        return goodsCell;
        
    }else if (indexPath.section == 2){
        if (indexPath.row == 0) {
            
            ZFOrderDetailCell* detailCell = [self.tableView dequeueReusableCellWithIdentifier:commonDetailCellid forIndexPath:indexPath];
            detailCell.lb_detailtitle.text = @"支付方式";
            detailCell.lb_detaileFootTitle.text = payMethodName;
           return detailCell;
            
        }else if (indexPath.row == 1) {
            
            ZFOrderDetailCell* detailCell = [self.tableView dequeueReusableCellWithIdentifier:commonDetailCellid forIndexPath:indexPath];
            if (deliveryName == nil || [deliveryName isEqualToString:@""]) {
          
                [detailCell setHidden: YES];

            }else{
                detailCell.lb_detailtitle.text = @"配送信息";
                detailCell.lb_detaileFootTitle.text = [NSString stringWithFormat:@"%@ %@",deliveryName,deliveryPhone];
            }

           return detailCell;
            
        }
        else if (indexPath.row == 2) {//折扣信息
            
            ZFOrderDetailCell* detailCell = [self.tableView dequeueReusableCellWithIdentifier:commonDetailCellid forIndexPath:indexPath];
            if (_couponAmount == nil || [_couponAmount isEqualToString:@""]) {
                
                [detailCell setHidden: YES];
                
            }else{
                detailCell.lb_detailtitle.text = @"折扣信息";
                detailCell.lb_detaileFootTitle.text = [NSString stringWithFormat:@"已优惠%.2f元",[_couponAmount floatValue]];
            }
            return detailCell;
        }else if (indexPath.row == 3) {//配送金额
            
            ZFOrderDetailCountCell* countCell = [self.tableView dequeueReusableCellWithIdentifier:kcountDetailCellid forIndexPath:indexPath];
            countCell.lb_freeSendPrice.text = [NSString stringWithFormat:@"¥%.2f",[deliveryFee floatValue]]  ;
            countCell.lb_goodsAllPrice .text = [NSString stringWithFormat:@"¥%.2f",[goodsAmount floatValue]];
            return countCell;
            
        }else if (indexPath.row == 4) {//备注
            ZFOrderDetailCell* detailCell = [self.tableView dequeueReusableCellWithIdentifier:commonDetailCellid forIndexPath:indexPath];
            detailCell.lb_detailtitle.text = @"备注";
            detailCell.lb_detaileFootTitle.text = _orderComment;
            
            return detailCell;
            
        }
        else{
            
            ZFOrderDetailPaycashCell* payCell = [self.tableView dequeueReusableCellWithIdentifier:payCashDetailCellid forIndexPath:indexPath];
            payCell.lb_realPay.text = [NSString stringWithFormat:@"¥%.2f",[payRelPrice floatValue]] ;
            payCell.lb_orderCreatTime.text = createTime;
            return payCell;
            
        }
    }
    return nil;
 
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"%ld = section ,%ld = row ",indexPath.section,indexPath.row);
    GoodsDeltailViewController * goodVC= [GoodsDeltailViewController new];
   
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
            //-1：关闭,0待配送 1配送中 2.配送完成，3交易完成（用户确认收货），4.待付款,5.待审批,6.待退回，7.服务完成 8 待接单 9.代发货 10.已发货 11.处理付款中 12.付款失败
            orderStatus = [NSString stringWithFormat:@"%ld",orderModel.orderDetails.orderStatus];
            payMethodName   = orderModel.orderDetails.payMethodName;
            createTime      = [NSString stringWithFormat:@"下单时间:%@",orderModel.orderDetails.createTime] ;//订单时间
            
            //0.未支付的初始状态  1.支付成功 -1.支付失败  3.付款发起   4.付款取消 (待付款) 5.退款成功（支付成功的）6.退款发起(支付成功) 7.退款失败(支付成功)
//            _payStatus = orderModel.orderDetails.payStatus;//支付状态
            
            //1.支付宝  2.微信支付 3.线下,4.展易付
//            NSInteger payMethod = orderModel.orderDetails.payMethod;
            
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

            //备注
            _orderComment = orderModel.orderDetails.orderComment;

            _commentTextHeight = [self heightForString:_orderComment andWidth:KScreenW - 30-60];
            if (_commentTextHeight < 50) {
                _commentTextHeight = 50;
            } else{
                _commentTextHeight = _commentTextHeight +20;
            }
            
            //配送员id
            _deliveryId = [NSString stringWithFormat:@"%ld",orderModel.deliveryInfo.deliveryId];
            
            // payType 0线上支付 1线下支付
            _payType = orderModel.payType;
          
            [SVProgressHUD dismiss];
            [self.tableView reloadData];

        }
        
    } progress:^(NSProgress *progeress) {
    } failure:^(NSError *error) {
        [SVProgressHUD dismiss];
        NSLog(@"error=====%@",error);
        [self.view makeToast:@"网络错误" duration:2 position:@"center"];
    }];
    
}
/**
 @method 获取指定宽度width,字体大小fontSize,字符串value的高度
 @param value 待计算的字符串
 @result float 返回的高度
 */
- (float)heightForString:(NSString *)value andWidth:(float)width{
    //获取当前文本的属性
    UILabel * label = [[UILabel alloc]init];
    NSAttributedString *attrStr = [[NSAttributedString alloc] initWithString:value];
    label.attributedText = attrStr;
    NSRange range = NSMakeRange(0, attrStr.length);
    // 获取该段attributedString的属性字典
    NSDictionary *dic = [attrStr attributesAtIndex:0 effectiveRange:&range];
    // 计算文本的大小
    CGSize sizeToFit = [value boundingRectWithSize:CGSizeMake(width - 16.0, MAXFLOAT) // 用于计算文本绘制时占据的矩形块
                                           options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading // 文本绘制时的附加选项
                                        attributes:dic        // 文字的属性
                                           context:nil].size; // context上下文。包括一些信息，例如如何调整字间距以及缩放。该对象包含的信息将用于文本绘制。该参数可为nil
    return sizeToFit.height + 16.0;
}

#pragma mark - 商户端确认收货   userConfirmReceipt 用户确认取货
-(void)bussniessAcceptgoodsPost
{
    NSDictionary * param = @{
                             
                             @"orderNum":ordernum,
                             @"orderStatus":@"3",
                             
                             };
    
    [MENetWorkManager post:[NSString stringWithFormat:@"%@/order/updateOrderInfo",zfb_baseUrl] params:param success:^(id response) {
        [self.view makeToast:response[@"resultMsg"] duration:2 position:@"center"];
        //取货完毕后刷新状态
        [self getOrderDetailsInfoPostResquestcmOrderid:_cmOrderid];
        
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
  
    //用于支付成功失败的参数
    NSMutableDictionary * payDealParam = [NSMutableDictionary dictionary];
    [payDealParam setValue:BBUserDefault.userPhoneNumber forKey:@"account"];
    [payDealParam setValue:listJsonString forKey:@"orderList"];//Json格式的订单字符集

    
    CheckstandViewController * payVC = [CheckstandViewController new];
    payVC.amount = [NSString stringWithFormat:@"%.2f",[payRelPrice floatValue]];
    payVC.notifyUrl = _thirdUrlDic[@"notify_url"];
    payVC.signDic = dic;
    payVC.payParam = payDealParam;
    payVC.isOrderDeal = NO;
    [self.navigationController pushViewController:payVC animated:NO];
    
}


- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    NSDate * date = [NSDate date];
    _datetime     = [dateTimeHelper timehelpFormatter: date];//2017-07-20 17:08:54
    [self getOrderDetailsInfoPostResquestcmOrderid:_cmOrderid];

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
