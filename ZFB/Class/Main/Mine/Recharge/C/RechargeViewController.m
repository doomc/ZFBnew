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
#import "CertificationViewController.h"//实名认证
#import "WithDrawResultViewController.h"//提交提现

//支付密码
#import "CYPasswordView.h"
#import "MBProgressHUD+MJ.h"
#import "IQKeyboardManager.h"

@interface RechargeViewController ()<UITableViewDelegate,UITableViewDataSource,WithdrawCellDelegate,AddBackButtonCellDelegate>
{
    NSString * _putInMoney;
    NSString * _realNameFlag;

}
@property (nonatomic , strong) UITableView * backTableView;
@property (nonatomic , strong) NSMutableArray * backCardList;
@property (nonatomic , strong) CYPasswordView *passwordView;
@property (nonatomic , copy) NSString * randomString;

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
    
    /** 注册取消按钮点击的通知 */
    [CYNotificationCenter addObserver:self selector:@selector(cancel) name:CYPasswordViewCancleButtonClickNotification object:nil];
    [CYNotificationCenter addObserver:self selector:@selector(forgetPWD) name:CYPasswordViewForgetPWDButtonClickNotification object:nil];
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
//唤醒密码键盘
-(void)wakeUpPasswordAlert
{
    __weak RechargeViewController *weakSelf = self;
    self.passwordView = [[CYPasswordView alloc] init];
    self.passwordView.title = @"输入交易密码";
    self.passwordView.loadingText = @"提交中...";
    [self.passwordView showInView:self.view.window];
    self.passwordView.finish = ^(NSString *password) {
        
        [weakSelf.passwordView hideKeyboard];
        [weakSelf.passwordView startLoading];
        
        //password 需要加密
        NSString * base64 = [password base64EncodedString];
        NSMutableString* mutpassword=[[NSMutableString alloc]initWithString:base64];//存在堆区，可变字符串
        NSLog(@"str1:%@",mutpassword);
        [mutpassword insertString:weakSelf.randomString atIndex:1];//把一个字符串插入另一个字符串中的某一个位置
        NSLog(@"str2:%@",mutpassword);
        //获取请求接口
        [weakSelf PayoassWordPost:mutpassword];
        
    };
}

- (NSString *)shuffledAlphabet {
    NSString *alphabet = @"ABCDEFGHIJKLMNOPQRSTUVWXYZ";
    
    // Get the characters into a C array for efficient shuffling
    NSUInteger numberOfCharacters = [alphabet length];
    unichar *characters = calloc(numberOfCharacters, sizeof(unichar));
    [alphabet getCharacters:characters range:NSMakeRange(0, numberOfCharacters)];
    
    // Perform a Fisher-Yates shuffle
    for (NSUInteger i = 0; i < 5; ++i) {
        NSUInteger j = (arc4random_uniform(numberOfCharacters - i) + i);
        unichar c = characters[i];
        characters[i] = characters[j];
        characters[j] = c;
    }
    
    // Turn the result back into a string
    NSString *result = [NSString stringWithCharacters:characters length:5];
    free(characters);
    return result;
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
        if (self.backCardList.count >0) {
            cell.NOBankCardView.hidden = YES;
            BankList *  list  =  self.backCardList[0];
            cell.bankList = list;
        }else{
            
            cell.NOBankCardView.hidden = NO;
        }
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
    NSLog(@"section :%ld --- row:%ld",indexPath.section ,indexPath.row);
    if (indexPath.section == 0) {
        BankCarListViewController * bankVC =[[BankCarListViewController alloc]init];
        bankVC.bankBlock = ^(BankList *banklist) {
            if (self.backCardList.count > 0 ) {
                [self.backCardList removeAllObjects];
            }
            [self.backCardList addObject: banklist];
            [self.backTableView reloadData];
        };
        [self.navigationController pushViewController:bankVC animated:NO];
    }
}
 
#pragma mark - AddBackButtonCellDelegate 添加银行卡代理
//添加银行卡
-(void)didClickAddBankCard
{
    NSLog(@"点击了  ---- 添加银行卡");
    if ([_realNameFlag isEqualToString:@"1"] ) {            //是否实名认证 1 是 2 否
        AddBankCardViewController * addVC = [AddBankCardViewController new];
        [self.navigationController pushViewController:addVC animated:NO];

    }else{

        CertificationViewController * cerVC = [CertificationViewController new];
        [self.navigationController pushViewController:cerVC animated:NO];
    }
 
}
//确认提现
-(void)didClickcashWithdraw
{
    //先生成随机数
    _randomString =  [self shuffledAlphabet];
    
    //先判断是不是满足条件了
    if (_putInMoney.length > 0) {
        BankList * list = self.backCardList[0];
        [self withDrawkCashPostAccount:list.phone bankId:list.bank_id amount:_putInMoney objectName:list.name logoUrl:list.bank_img];

    }else{
        [self.view makeToast:@"请输入提现金额" duration:2 position:@"center"];

    }
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
-(void)withDrawkCashPostAccount:(NSString *)account bankId:(NSString *)bankId amount:(NSString *)amount objectName:(NSString *)objectName logoUrl:(NSString *)logoUrl
{


    NSDictionary * param = @{
                             @"account":account,
                             @"bankId":bankId,//绑卡后银行卡编号
                             @"amount":amount,//银行卡号
                             @"logoUrl":logoUrl,//银行卡绑定电话
                             @"objectName":objectName,//银行卡持有人姓名
                             
                             };
    
    //withdraw/withdrawApply 新的提现
    [MENetWorkManager post:[NSString stringWithFormat:@"%@/QRCode/withdrawCash",zfb_baseUrl] params:param success:^(id response) {
        NSString * code = [NSString stringWithFormat:@"%@",response[@"resultCode"]];
        if ([code isEqualToString:@"0"]) {
            //唤醒支付键盘操作后
            [self wakeUpPasswordAlert];
        }
 

    } progress:^(NSProgress *progeress) {
        
    } failure:^(NSError *error) {
        [self.view makeToast:@"网络出差了~" duration:2 position:@"center"];

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
            if (self.backCardList.count > 0) {
                [self.backCardList removeAllObjects];
            }
            BankCardListModel  * bank = [BankCardListModel mj_objectWithKeyValues:response];
            for (BankList * list in bank.bankList) {
                [self.backCardList addObject:list];
            }
            [self.backTableView reloadData];
        }
    } progress:^(NSProgress *progeress) {
    } failure:^(NSError *error) {
        [self.view makeToast:@"网络出差了~" duration:2 position:@"center"];

    }];
}

#pragma mark - 提现支付密码
-(void)PayoassWordPost:(NSString *)payPassword
{
    BankList * list = self.backCardList[0];

    NSDictionary * param = @{
                             @"account":BBUserDefault.userPhoneNumber,
                             @"payPassword":payPassword//base64加密
                             };
    [MENetWorkManager post:[NSString stringWithFormat:@"%@/QRCode/validateZyfPayPassword",zfb_baseUrl] params:param success:^(id response) {
        NSString * code = [NSString stringWithFormat:@"%@",response[@"resultCode"]];
        if ([code isEqualToString:@"0"]) {
            WithDrawResultViewController * drawVC = [WithDrawResultViewController new];
            //后4位
            NSString *lastfourCardno = [list.bank_num  substringFromIndex:list.bank_num.length - 4];
            NSString * lastNum = [NSString stringWithFormat:@"尾号(%@)",lastfourCardno];
            drawVC.bankMsg = [NSString stringWithFormat:@"%@ %@",list.bank_name,lastNum];
            drawVC.amont = _putInMoney ;
            [self.navigationController pushViewController:drawVC animated:NO];
        }
        else{
            [self.view makeToast:response[@"resultMsg"] duration:2 position:@"center"];
        }
       
        //关闭键盘
        [self.passwordView stopLoading];
        [self.passwordView hide];
        
    } progress:^(NSProgress *progeress) {
    } failure:^(NSError *error) {
        [self.view makeToast:@"网络出差了~" duration:2 position:@"center"];

    }];
}

-(void)viewWillAppear:(BOOL)animated{
    [self settingNavBarBgName:@"nav64_gray"];
    [self realNamePost];
    [self backCardListPost];
    //关闭toolbar
    [IQKeyboardManager sharedManager].enableAutoToolbar = NO;
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
