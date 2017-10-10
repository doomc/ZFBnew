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
@interface CheckstandViewController () <UITableViewDelegate,UITableViewDataSource,PayFootCellDelegate>
{
    NSString * _balance;
}
@property (nonatomic , strong) UITableView * tableView;
@property (nonatomic , strong) NSArray * titles;

@end

@implementation CheckstandViewController

-(UITableView *)tableView
{
    if (!_tableView) {
        
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, KScreenW, KScreenH) style:UITableViewStylePlain];
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
    
    [self getThirdBalancePOSTRequste];
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
        cell.lb_balance.text = [NSString stringWithFormat:@"%@元",_balance];
        cell.btn_selected.hidden = NO;
    
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
    if (indexPath.row == 2 ) {//如果是微信支付
        

    }
    
}

- (void)bizPay {

    PayReq *req = [[PayReq alloc]init];
    req.openID = WX_AppId;
//    req.partnerId = [payDic valueForKey:@"partnerid"];
//    req.prepayId = [payDic valueForKey:@"prepayid"];
//    req.nonceStr = [payDic valueForKey:@"noncestr"];
//    req.timeStamp = [[payDic valueForKey:@"timestamp"] intValue];
//    req.package = [payDic valueForKey:@"package"];
//    req.sign = [payDic valueForKey:@"sign"];
    
    BOOL flag = [WXApi sendReq:req];
    if (flag) {
        
        NSLog(@"发起微信支付成功");
    }else{
        
        NSLog(@"发起微信支付失败");
    }
    
//    [MXWechatPayHandler jumpToWxPayAtOrderNo:_zavfpay_num totalFee:_amount notifyUrl:_notifyUrl];
    [self wxPaySignPostRequst];

}
#pragma mark - 选择支付方式--确定支付
-(void)didClickSurePay
{
    NSLog(@"吊起支付");
    [self bizPay] ;
    
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

//接入微信支付
-(void)wxPaySignPostRequst
{
    NSDictionary * param = @{
                             @"account":wx_MCH_ID,
                             @"zavfpay_num":_zavfpay_num,//支付订单号
                             @"sign":_paySign,
                             
                             };
    
    [NoEncryptionManager noEncryptionPost:[NSString stringWithFormat:@"%@/cashier/wxPay.do",paySign_baseUrl] params:param success:^(id response) {
        NSLog(@"%@",response[@"result_msg"]);
        
    } progress:^(NSProgress *progeress) {
        
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
        
    }];
    
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
