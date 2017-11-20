//
//  CheckstandViewController.m
//  ZFB
//
//  Created by  展富宝  on 2017/10/10.
//  Copyright © 2017年 com.zfb. All rights reserved.
//  收银台

#import "CheckstandViewController.h"
#import "PayforCell.h"
#import "PayRealCell.h"
#import "WXApi.h"
//支付密码
#import "CYPasswordView.h"
#import "MBProgressHUD+MJ.h"
#import "IQKeyboardManager.h"

//支付跳转
#import "DetailPayCashViewController.h"//支付失败
#import "DetailPaySuccessViewController.h"//支付成功


@interface CheckstandViewController () <UITableViewDelegate,UITableViewDataSource>
{
    NSString * _balance;
    NSInteger  _indexRow;
    BOOL  _paySuccess;//判断是否支付成功  yes 成功 No 失败
}
@property (nonatomic , strong) UITableView * tableView;
@property (nonatomic , strong) UIButton * payBtn;
@property (nonatomic , strong) NSArray * titles;
@property (nonatomic , strong) NSArray * imageIcons;
@property (nonatomic , strong) CYPasswordView *passwordView;

@end

@implementation CheckstandViewController

-(UITableView *)tableView
{
    if (!_tableView) {
        
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, KScreenW, 300) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = HEXCOLOR(0xf7f7f7);
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return _tableView;
}
-(UIButton *)payBtn
{
    if (!_payBtn ) {
        _payBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_payBtn setTitle:@"确认支付" forState:UIControlStateNormal];
        _payBtn.titleLabel.font = SYSTEMFONT(15);
        _payBtn.frame = CGRectMake(20, 300+50, KScreenW -40, 44);
        _payBtn.backgroundColor = HEXCOLOR(0xf95a70);
        _payBtn.layer.masksToBounds = YES;
        _payBtn.layer.cornerRadius = 6;
        [_payBtn addTarget:self action:@selector(didClickSurePay) forControlEvents:UIControlEventTouchUpInside];
    }
    return _payBtn;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"收银台";
     _indexRow = 5;//默认一个值
    
    _titles = @[@"余额",@"微信",@"支付宝",@"快捷支付"];
    _imageIcons = @[@"yue",@"wechat",@"alipay",@"quick"];
    
    [self.view addSubview:self.tableView];
    [self.view addSubview:self.payBtn];
    self.view.backgroundColor = HEXCOLOR(0xf7f7f7);
    
    [self.tableView registerNib:[UINib nibWithNibName:@"PayforCell" bundle:nil] forCellReuseIdentifier:@"PayforCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"PayRealCell" bundle:nil] forCellReuseIdentifier:@"PayRealCell"];

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
    [self poptoUIViewControllerNibName:@"GoodsDeltailViewController" AndObjectIndex:2];
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
    return 2;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 4;
    }
    return 1;
}
-(UIView *)tableView:(UITableView *)tableView  viewForHeaderInSection:(NSInteger)section
{
    UIView * sectionView = nil;
    if (section == 0) {
        if (!sectionView) {
            sectionView =  [[UIView alloc]initWithFrame:CGRectMake(0, 0, KScreenW, 40)];
            sectionView.backgroundColor = HEXCOLOR(0xf7f7f7);
            UILabel *  title = [[UILabel alloc]initWithFrame:CGRectMake(15, 0, KScreenW, 40)];
            title.text = @"选择支付方式";
            title.textColor = HEXCOLOR(0x8d8d8d);
            title.font = SYSTEMFONT(12);
            title.textAlignment = NSTextAlignmentLeft;
            [sectionView addSubview:title];
        }
    }else
    {
        if (!sectionView) {
            sectionView =  [[UIView alloc]initWithFrame:CGRectMake(0, 0, KScreenW, 0.001)];
        }
    }
    return sectionView;

}
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView * footview = nil;
    if (!footview) {
        footview =  [[UIView alloc]initWithFrame:CGRectMake(0, 0, KScreenW, 10)];
    }
    return footview;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0) {
         return 40;
    }
    return 0.001;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 10;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (indexPath.section == 0 ) {
        
        PayforCell * cell = [self.tableView dequeueReusableCellWithIdentifier:@"PayforCell" forIndexPath:indexPath];
        NSString * iconName = _imageIcons[indexPath.row];
        cell.lb_title.text = _titles[indexPath.row];
        cell.icons.image = [UIImage imageNamed:iconName];
        
        if (indexPath.row == 0) {//余额
            cell.lb_balance.hidden = NO;
            cell.btn_selected.hidden = NO;
            if ([_balance isEqualToString:@""] || _balance == nil) {
                cell.lb_balance.text = @"0.0元";

            }else{
                cell.lb_balance.text = [NSString stringWithFormat:@"%@元",_balance];
            }
        }
        else if (indexPath.row == 1) {//微信

            cell.btn_selected.hidden = NO;

        }else if (indexPath.row == 2) {//支付宝
            cell.btn_selected.hidden = NO;

        }else{//快捷方式
            cell.btn_selected.hidden = NO;

        }
        
        return cell;
    }else{
        PayRealCell * realCell = [tableView dequeueReusableCellWithIdentifier:@"PayRealCell" forIndexPath:indexPath];
        realCell.lb_Price.text = _amount;
        return realCell;
    }
  
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        _indexRow =  indexPath.row;
    }
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
    if (_indexRow == 0) {//余额支付
        //该步骤需要先检测是不是有支付密码 后再调该借口
        [self wakeUpPasswordAlert];
    }
    if (_indexRow == 1) {//微信支付
        [self jumpToWXPayPostRequst];
    }

    if (_indexRow == 2) {//支付宝
     
        [self settingAlertView];
    }
    if (_indexRow == 3) {//快捷支付
        [self settingAlertView];

    }
    if ( _indexRow == 5 ) {
        [self.view makeToast:@"请选择支付方式！" duration:2 position:@"center"];
        
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
