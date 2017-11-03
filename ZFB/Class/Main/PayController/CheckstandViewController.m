//
//  CheckstandViewController.m
//  ZFB
//
//  Created by  展富宝  on 2017/10/10.
//  Copyright © 2017年 com.zfb. All rights reserved.
//  收银台

#import "CheckstandViewController.h"
#import "PayforCell.h"
#import "PayFootCell.h"
#import "WXApi.h"
//支付密码
#import "CYPasswordView.h"
#import "MBProgressHUD+MJ.h"
#import "IQKeyboardManager.h"

//支付跳转
#import "DetailPayCashViewController.h"//支付失败
#import "DetailPaySuccessViewController.h"//支付成功


@interface CheckstandViewController () <UITableViewDelegate,UITableViewDataSource,PayFootCellDelegate>
{
    NSString * _balance;
    NSInteger  _indexRow;
    BOOL  _paySuccess;//判断是否支付成功  yes 成功 No 失败
}
@property (nonatomic , strong) UITableView * tableView;
@property (nonatomic , strong) NSArray * titles;
@property (nonatomic , strong) CYPasswordView *passwordView;

@end

@implementation CheckstandViewController

-(UITableView *)tableView
{
    if (!_tableView) {
        
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, KScreenW, KScreenH) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return _tableView;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"收银台";
    _titles = @[@"选择支付方式",@"余额",@"微信支付",@"实付金额"];
    [self.view addSubview:self.tableView];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"PayforCell" bundle:nil] forCellReuseIdentifier:@"PayforCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"PayFootCell" bundle:nil] forCellReuseIdentifier:@"PayFootCell"];
    /** 注册取消按钮点击的通知 */
    [CYNotificationCenter addObserver:self selector:@selector(cancel) name:CYPasswordViewCancleButtonClickNotification object:nil];
    [CYNotificationCenter addObserver:self selector:@selector(forgetPWD) name:CYPasswordViewForgetPWDButtonClickNotification object:nil];

    //注册微信支付
    [WXApi registerApp:WX_AppId enableMTA:YES];
    [self getThirdBalancePOSTRequste];
    
}
#pragma mark - 返回跳转到我的订单
-(void)backAction
{
    [self poptoUIViewControllerNibName:@"DetailFindGoodsViewController" AndObjectIndex:2];
}

- (void)cancel {
    CYLog(@"关闭密码框");
    [MBProgressHUD showSuccess:@"关闭密码框"];
}

- (void)forgetPWD {
    CYLog(@"忘记密码");
    [MBProgressHUD showSuccess:@"忘记密码"];
}
- (void)dealloc {
    CYLog(@"cy =========== %@：我走了", [self class]);
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 4;
}
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView * view = nil;
    if (!view) {
        PayFootCell * cell = [tableView dequeueReusableCellWithIdentifier:@"PayFootCell"];
        cell.delegate = self;
        view = cell;
    }
    return view;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 50;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    PayforCell * cell = [self.tableView dequeueReusableCellWithIdentifier:@"PayforCell" forIndexPath:indexPath];
    cell.lb_title.text = _titles[indexPath.row];
    if (indexPath.row == 0) {

    }
    else if (indexPath.row == 1) {//余额
        
        cell.lb_balance.hidden = NO;
        cell.btn_selected.hidden = NO;
        if ([_balance isEqualToString:@""] || _balance == nil) {
            cell.lb_balance.text = @"0.0元";

        }else{
            cell.lb_balance.text = [NSString stringWithFormat:@"%@元",_balance];
        }
    }else if (indexPath.row == 2) {//微信支付

        cell.btn_selected.hidden = NO;

    }else{//实付金额
        
        cell.lb_Price.hidden = NO;
        cell.lb_Price.text = _amount;
    }
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    _indexRow =  indexPath.row;
    
}

- (void)bizPayParterId:(NSString *)partnerId prepayId:(NSString *)prepayId package:(NSString *)package nonceStr:(NSString *)nonceStr timeStamp: (NSString *)timeStamp sign:(NSString *)sign
{
    [MBProgressHUD showMessage:@"请稍后..."];
    
    PayReq *req = [[PayReq alloc]init];
    req.openID = WX_AppId;
    req.partnerId = partnerId;
    req.prepayId = prepayId;
    req.nonceStr = nonceStr;
    req.timeStamp = [timeStamp intValue];
    // 根据财付通文档填写的数据和签名 
    //这个比较特殊，是固定的，只能是即req.package = Sign=WXPay
    req.package = package;
    req.sign = sign;
    BOOL flag = [WXApi sendReq:req];
    if (flag) {
        NSLog(@"发起微信支付成功");
        [MBProgressHUD hideHUD];
    }else{
        
        NSLog(@"发起微信支付失败");
        [MBProgressHUD hideHUD];

    }
    

}
#pragma mark - 选择支付方式--确定支付
-(void)didClickSurePay
{
    if (_indexRow == 1) {//余额支付
        //该步骤需要先检测是不是有支付密码 后再调该借口
        [self wakeUpPasswordAlert];
    }
    if (_indexRow == 2) {//微信支付
        [self jumpToWXPayPostRequst];
    }

}
//每次进来都需要重新请求签名
-(void)viewWillAppear:(BOOL)animated
{
    //关闭toolbar
    [IQKeyboardManager sharedManager].enableAutoToolbar = NO;

    [self WXparnerIdPost];
}
#pragma mark  - 网络请求 查询展易付余额
-(void)getThirdBalancePOSTRequste
{
    
    NSDictionary * parma = @{
                             @"account":BBUserDefault.userPhoneNumber,
                             };
    
    [MENetWorkManager post:[zfb_baseUrl stringByAppendingString:@"/QRCode/getThirdBalance"] params:parma success:^(id response) {
        
        if ([response [@"resultCode"] intValue] == 0) {
            _balance = response[@"balance"];
        }
        [self.tableView reloadData];
        
    } progress:^(NSProgress *progeress) {
        
    } failure:^(NSError *error) {
        
        NSLog(@"error=====%@",error);
        [self.view makeToast:@"网络错误" duration:2 position:@"center"];
    }];
    
}

//跳转到微信支付
-(void)jumpToWXPayPostRequst
{
    NSDictionary * param = @{
                             @"account":BBUserDefault.userPhoneNumber,
                             @"zavfpay_num":_zavfpay_num,//支付订单号
                             @"sign":_WXPaySign,
                             
                             };
    
    [NoEncryptionManager noEncryptionPost:[NSString stringWithFormat:@"%@/cashier/wxPay.do",paySign_baseUrl] params:param success:^(id response) {
    
        NSString * code = [NSString stringWithFormat:@"%@",response[@"result_code"]];
        if ([code isEqualToString:@"0000"]) {
            NSString * timeStamp = [NSString stringWithFormat:@"%@",response[@"timeStamp"]];
            NSString * sign = [NSString stringWithFormat:@"%@",response[@"sign"]];
            NSString * package = [NSString stringWithFormat:@"%@",response[@"package"]];
            NSString * partnerId = [NSString stringWithFormat:@"%@",response[@"partnerId"]];
            NSString * nonceStr = [NSString stringWithFormat:@"%@", response[@"nonceStr"]];
            NSString * prepayId = [NSString stringWithFormat:@"%@", response[@"prepayId"]];
//            NSString * appId = [NSString stringWithFormat:@"%@", response[@"appId"]];
            
            [self bizPayParterId:partnerId prepayId:prepayId package:package nonceStr:nonceStr timeStamp:timeStamp sign:sign] ;
        }
        NSLog(@"%@",response[@"result_msg"]);
    } progress:^(NSProgress *progeress) {
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
        
    }];
    
}
//获取微信的sign
-(void)wxPaySignPostRequst:(NSString *)zavfpay_num
{
    NSDictionary * param = @{
                             @"account":BBUserDefault.userPhoneNumber,
                             @"zavfpay_num":zavfpay_num,//支付订单号
                             };
    
    [MENetWorkManager post:[NSString stringWithFormat:@"%@/order/paySign",zfb_baseUrl] params:param success:^(id response) {
        NSString * code = [NSString stringWithFormat:@"%@",response[@"resultCode"]];
        if ([code isEqualToString:@"0"]) {
            
            _WXPaySign = [NSString stringWithFormat:@"%@", response[@"paySign"]];
            NSLog(@"这个是微信支付的:%@",response[@"resultMsg"]);
        }
    } progress:^(NSProgress *progeress) {
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
    }];
}
//获取余额的sign
-(void)balanceSignPostRequstWithPayPass:(NSString *)payPass
{
    NSDictionary * param = @{
                             @"account":BBUserDefault.userPhoneNumber,
                             @"zavfpay_num":_zavfpay_num,//支付订单号
                             @"pay_pass":payPass,
                             };
    
    [MENetWorkManager post:[NSString stringWithFormat:@"%@/order/paySign",zfb_baseUrl] params:param success:^(id response) {
        NSString * code = [NSString stringWithFormat:@"%@",response[@"resultCode"]];
        if ([code isEqualToString:@"0"]) {
            
            _BalancePaySign = [NSString stringWithFormat:@"%@", response[@"paySign"]];
            NSLog(@"这个是余额支付的%@",response[@"resultMsg"]);
            //获取到签名后再请求余额支付
            [self balancePostRequstAtPassword:payPass];

        }else
        {
            [self.view makeToast:response[@"result_msg"] duration:2 position:@"center"];

        }
    } progress:^(NSProgress *progeress) {
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
    }];
}

//余额支付
-(void)balancePostRequstAtPassword:(NSString *)pass
{
    NSDictionary * param = @{
                             @"account":BBUserDefault.userPhoneNumber,
                             @"zavfpay_num":_zavfpay_num,//支付订单号
                             @"sign":_BalancePaySign,//支付平台支付密码
                             @"pay_pass":pass
                             };
    
    [NoEncryptionManager noEncryptionPost:[NSString stringWithFormat:@"%@/cashier/balancePay.do",paySign_baseUrl] params:param success:^(id response) {
        NSString* code = [NSString stringWithFormat:@"%@",response[@"result_code"]];
        if ([code isEqualToString:@"0000"]) {//支付成功
            [MBProgressHUD showSuccess:response[@"result_msg"]];
            DetailPaySuccessViewController * successVC =[ DetailPaySuccessViewController new];
            [self.navigationController pushViewController:successVC  animated:NO];
            
  
        }
        if ([code isEqualToString:@"0001"]) {//支付密码不正确
            [self.view makeToast:response[@"result_msg"] duration:2 position:@"center"];

        }
        if ([code isEqualToString:@"0002"]) {//未设置支付密码
            [self.view makeToast:response[@"result_msg"] duration:2 position:@"center"];

        }
        else
        {
            [self.view makeToast:response[@"result_msg"] duration:2 position:@"center"];
            
        }
        [self.passwordView stopLoading];
        [self.passwordView hide];
        
    } progress:^(NSProgress *progeress) {
        
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
        
    }];
    
}
//获取预下单订单
-(void)WXparnerIdPost
{
    //非加密的请求 获取预订单
    [NoEncryptionManager noEncryptionPost:[NSString stringWithFormat:@"%@/cashier/order.do",paySign_baseUrl] params:_signDic success:^
     (id response) {
         
         NSLog(@"预下单订单 order.do : %@",response[@"result_msg"]);
         
         NSString * code = [NSString stringWithFormat:@"%@",response[@"result_code"]];
         if ([code isEqualToString:@"0000"]) {
             
             _zavfpay_num = [NSString stringWithFormat:@"%@",response[@"zavfpay_num"]];
             [self wxPaySignPostRequst:_zavfpay_num];//获取微信签名
         }
         else{
             [self.view makeToast:response[@"result_msg"] duration:2 position:@"center"];
         }
     } progress:^(NSProgress *progeress) {
     } failure:^(NSError *error) {
         NSLog(@"%@",error);
     }];

}

//唤醒密码键盘
-(void)wakeUpPasswordAlert
{
    __weak CheckstandViewController *weakSelf = self;
    self.passwordView = [[CYPasswordView alloc] init];
    self.passwordView.title = @"输入交易密码";
    self.passwordView.loadingText = @"提交中...";
    [self.passwordView showInView:self.view.window];
    self.passwordView.finish = ^(NSString *password) {
        
        [weakSelf.passwordView hideKeyboard];
        [weakSelf.passwordView startLoading];
        
        NSLog(@"cy ========= 发送网络请求  pwd=%@", password);
        //获取到余额签名
        [weakSelf balanceSignPostRequstWithPayPass:password];
        
    };
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
