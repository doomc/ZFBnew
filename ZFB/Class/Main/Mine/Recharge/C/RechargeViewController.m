//
//  RechargeViewController.m
//  ZFB
//
//  Created by  展富宝  on 2017/10/17.
//  Copyright © 2017年 com.zfb. All rights reserved.
//  充值

#import "RechargeViewController.h"
#import "AddBankCardViewController.h"//添加银行卡

#import "BackCell.h"
#import "WithdrawCell.h"
#import "AddBackButtonCell.h"
#import "BankCardListModel.h"//可用银行卡model

#import "BankCarListViewController.h"//银行卡列表
#import "WithDrawViewController.h"//提现
#import "CertificationViewController.h"//实名认证
#import "WithDrawResultViewController.h"//提交提现
@interface RechargeViewController ()<UITableViewDelegate,UITableViewDataSource,WithdrawCellDelegate,AddBackButtonCellDelegate>
{
    NSString * _putInMoney;
    NSString * _realNameFlag;
}
@property (nonatomic , strong) UITableView * backTableView;
@property (nonatomic , strong) NSMutableArray * backCardList;
@end

@implementation RechargeViewController

-(NSMutableArray *)backCardList
{
    if (!_backCardList) {
        _backCardList= [ NSMutableArray array];
    }
    return _backCardList;
}
-(UITableView *)backTableView
{
    if (!_backTableView) {
        _backTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, KScreenW, KScreenH -64) style:UITableViewStylePlain];
        _backTableView.delegate = self;
        _backTableView.dataSource = self;
        _backTableView.separatorStyle =  UITableViewCellSeparatorStyleNone;
    }
    return  _backTableView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"提现";
    [self.view addSubview: self.backTableView];
    
    [self.backTableView registerNib:[UINib nibWithNibName:@"BackCell" bundle:nil] forCellReuseIdentifier:@"BackCell"];
    [self.backTableView registerNib:[UINib nibWithNibName:@"AddBackButtonCell" bundle:nil] forCellReuseIdentifier:@"AddBackButtonCell"];
    [self.backTableView registerNib:[UINib nibWithNibName:@"WithdrawCell" bundle:nil] forCellReuseIdentifier:@"WithdrawCell"];
    
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat height = 0;
    if (indexPath.section == 0) {
        height = 65;
    
    }else if (indexPath.section == 1)
    {
        height = 130;
    }else{
        height = 125;
 
    }
    return height;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView * view = nil;
    if (!view) {
        view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, KScreenW, 10)];
        view.backgroundColor = HEXCOLOR(0xf7f7f7);
        
    }
    return view;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 10;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        BackCell * cell = [self.backTableView dequeueReusableCellWithIdentifier:@"BackCell" forIndexPath:indexPath];
        BankList *  list  =  self.backCardList[0];
        cell.bankList = list;
        return cell;
    }
   else if (indexPath.section == 1) {
      
       WithdrawCell  * drawCell = [self.backTableView dequeueReusableCellWithIdentifier:@"WithdrawCell" forIndexPath:indexPath];
       drawCell.lb_CashAmount.text = _balance;
       drawCell.tf_putInMoney.text = _putInMoney;
       drawCell.delegate = self;
       return drawCell;
    }
    else{
        AddBackButtonCell * cell = [self.backTableView dequeueReusableCellWithIdentifier:@"AddBackButtonCell" forIndexPath:indexPath];
        cell.delegate = self;
        return cell;

    }
 }

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        BankCarListViewController * bankVC =[[BankCarListViewController alloc]init];
        [self.navigationController pushViewController:bankVC animated:NO];
    }
}
 
#pragma mark - AddBackButtonCellDelegate 添加银行卡代理
//添加银行卡
-(void)didClickAddBankCard
{
    NSLog(@"点击了  ---- 添加银行卡");
//    if ([_realNameFlag isEqualToString:@"2"] ) {            //是否实名认证 1 是 2 否
//        CertificationViewController * cerVC = [CertificationViewController new];
//        [self.navigationController pushViewController:cerVC animated:NO];
//
//    }else{
//        AddBankCardViewController * addVC = [AddBankCardViewController new];
//        [self.navigationController pushViewController:addVC animated:NO];
//    }
    AddBankCardViewController * addVC = [AddBankCardViewController new];
    [self.navigationController pushViewController:addVC animated:NO];
    
}
//确认提现
-(void)didClickcashWithdraw
{
    //先判断是不是满足条件了
    
    [self withDrawkCashPost];
    NSLog(@"点击了  ---- 确认提现");

}

#pragma mark - WithdrawCellDelegate 提现代理
//全部提现
-(void)didClickAllWithDraw
{
    NSLog(@"全部提现  ---- 显示金额");
    _putInMoney  =  _balance ;
    [self.backTableView reloadData];
}
//输入的金额
-(void)inputTextfiledText:(NSString *)resulet
{
    NSLog(@" 外部获取到的 ---%@",resulet);
    _putInMoney = resulet;
    
}

#pragma mark - 实名认证
-(void)realNamePost
{
    NSDictionary * parma = @{
                             @"cmUserId":BBUserDefault.cmUserId,
                             };
    
    [MENetWorkManager post:[zfb_baseUrl stringByAppendingString:@"/getUserInfo"] params:parma success:^(id response) {
        
        NSString * code = [NSString stringWithFormat:@"%@",response [@"resultCode"]];
        
        if ([code isEqualToString:@"0"]) {
            //是否实名认证 1 是 2 否
            _realNameFlag = [NSString stringWithFormat:@"%@",response[@"userInfo"][@"realNameFlag"]];
         }
        
    } progress:^(NSProgress *progeress) {
    } failure:^(NSError *error) {
        
        NSLog(@"error=====%@",error);
        [self.view makeToast:@"网络出差了~" duration:2 position:@"center"];
    }];
}

#pragma mark - 提现接口
-(void)withDrawkCashPost
{
    NSDictionary * param = @{
                             @"account":BBUserDefault.userPhoneNumber,
                             @"bankId":@"",//绑卡后银行卡编号
                             @"amount":@"12",//银行卡号
                             @"logoUrl":@"",//银行卡绑定电话
                             @"objectName":@"",//银行卡持有人姓名
                             
                             };
    [MENetWorkManager post:[NSString stringWithFormat:@"%@/QRCode/withdrawCash",zfb_baseUrl] params:param success:^(id response) {
       
        WithDrawResultViewController * drawVC = [WithDrawResultViewController new];
        [self.navigationController pushViewController:drawVC animated:NO];
        
    } progress:^(NSProgress *progeress) {
        
    } failure:^(NSError *error) {
        
    }];
    
}
//获取可用的银行卡列表
-(void)backCardListPost
{
    NSDictionary * param = @{
                             @"account":BBUserDefault.userPhoneNumber,
                             @"cardType":@"3"//所有银行卡
                             
                             };
    [MENetWorkManager post:[NSString stringWithFormat:@"%@/QRCode/getThirdBankCardList",zfb_baseUrl] params:param success:^(id response) {
        NSString * code = [NSString stringWithFormat:@"%@",response[@"resultCode"]];
        
        if ([code isEqualToString:@"0"]) {
            BankCardListModel  * bank = [BankCardListModel mj_objectWithKeyValues:response];
            for (BankList * list in bank.bankList) {
                [self.backCardList addObject:list];
            }
            [self.backTableView reloadData];
        }
    } progress:^(NSProgress *progeress) {
        
    } failure:^(NSError *error) {
        
    }];
    
}

-(void)viewWillAppear:(BOOL)animated{
    
    [self realNamePost];
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
