//
//  BankMessageViewController.m
//  ZFB
//
//  Created by  展富宝  on 2017/10/20.
//  Copyright © 2017年 com.zfb. All rights reserved.
//

#import "BankMessageViewController.h"
#import "AddBankCell.h"

@interface BankMessageViewController () <UITableViewDelegate,UITableViewDataSource>
{
    NSString * _kcardNum; //卡号
    NSString * _phoneNum; //手机号
    BOOL * _isAgreeProtocol; //是否同意协议 yes 是

}
@property (nonatomic ,strong) NSArray * titles;
@property (nonatomic ,strong) NSArray * placeHoder;
@property (nonatomic ,strong) UITableView * tableView;
@property (nonatomic ,strong) UIButton * nextBtn;//下一步
@end

@implementation BankMessageViewController
-(UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, KScreenW, 110+ 32 + 55+40) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.scrollEnabled = NO;
        _tableView.backgroundColor = HEXCOLOR(0xeaeaea);
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return _tableView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"填写银行卡信息";
    _titles = @[@"卡类型",@"卡号人",@"手机号"];
    _placeHoder =  @[@"持卡卡类型",@"请输入有效姓名",@"预留手机号"];
    [self.tableView registerNib:[UINib nibWithNibName:@"AddBankCell" bundle:nil] forCellReuseIdentifier:@"AddBankCell"];
    
    [self settingButton];
    [self.view addSubview:self.tableView];
    self.view.backgroundColor = HEXCOLOR(0xf7f7f7);
}
-(void)settingButton
{
    _nextBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_nextBtn setTitle:@"下一步" forState:UIControlStateNormal];
    _nextBtn.titleLabel.font = SYSTEMFONT(15);
    [_nextBtn addTarget: self action:@selector(bandNext) forControlEvents:UIControlEventTouchUpInside];
    _nextBtn.frame = CGRectMake( 15, 2*110+ 32+55, KScreenW -30, 45);
    
    //暂时没有处理
    [_nextBtn setTitleColor:HEXCOLOR(0xffffff) forState:UIControlStateNormal];
    [_nextBtn setBackgroundColor:HEXCOLOR(0xF95A70)];
    _nextBtn.enabled = YES;
    [self.view addSubview:_nextBtn];
    
 
    
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 3;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 55;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    UIView * headView = nil;
    if (!headView) {
        headView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, KScreenW, 20)];
    }
    return headView;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 32;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 40;
}
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView * footview = nil;
    if (!footview) {
        footview = [[UIView alloc]initWithFrame:CGRectMake(0, 0, KScreenW, 40)];
        
        UIButton * argreeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [argreeBtn setImage:[UIImage imageNamed:@"s_normal"] forState:UIControlStateNormal];
        [argreeBtn setImage:[UIImage imageNamed:@"s_Selected.png"] forState:UIControlStateSelected];
        [argreeBtn addTarget:self action:@selector(chooseAction:) forControlEvents:UIControlEventTouchUpInside];
        argreeBtn.frame = CGRectMake(15, 10, 22, 22);
        [footview addSubview:argreeBtn];
        
        UILabel* tag = [[UILabel alloc]init];
        tag.text = @"我已经阅读并同意";
        tag.font = SYSTEMFONT(12);
        tag.textColor = HEXCOLOR(0x8d8d8d);
        [footview addSubview:tag];
        [tag mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(argreeBtn.mas_right).with.offset(5);
            make.top.equalTo(footview).with.offset(10);
            make.height.mas_equalTo(22);
        }];
        
        UIButton * protoclbtn = [UIButton buttonWithType:UIButtonTypeCustom];
        protoclbtn.titleLabel.font = SYSTEMFONT(12);
        [protoclbtn setTitleColor:HEXCOLOR(0xF95A70) forState:UIControlStateNormal];
        [protoclbtn setTitle:@"《展富宝代发服务协议》" forState:UIControlStateNormal];
        [protoclbtn addTarget:self action:@selector(protcolAction:) forControlEvents:UIControlEventTouchUpInside];
        [footview addSubview:protoclbtn];
        
        [protoclbtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(tag.mas_right).with.offset(5);
            make.top.equalTo(footview).with.offset(10);
            make.height.mas_equalTo(22);
        }];
        
    }
    return footview;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    AddBankCell * backCell = [self.tableView dequeueReusableCellWithIdentifier:@"AddBankCell" forIndexPath:indexPath];
    backCell.LB_title.text = _titles[indexPath.row];
    backCell.tf_content.placeholder = _placeHoder[indexPath.row];
    NSString * bankType ;
    if (indexPath.row == 0) {
        [backCell.tf_content addTarget:self action:@selector(handCarText:) forControlEvents:UIControlEventEditingChanged];
        
        if ([_bankCredType isEqualToString:@"1"]) {
            bankType = @"储蓄卡";
        }else{
            bankType = @"信用卡";

        }
        backCell.tf_content.text = [NSString stringWithFormat:@"%@  %@",_baseBankName,bankType];
        backCell.tf_content.userInteractionEnabled = NO;

        return backCell;

    }else if(indexPath.row == 1)
    {
        [backCell.tf_content addTarget:self action:@selector(carNumText:) forControlEvents:UIControlEventEditingChanged];
        backCell.tf_content.userInteractionEnabled = NO;
        backCell.tf_content.text = _bankCredHolder;
        return backCell;

    }else{
        [backCell.tf_content addTarget:self action:@selector(phoneNumText:) forControlEvents:UIControlEventEditingChanged];
        return backCell;

    }
    
}
//持卡人姓名
-(void)handCarText:(UITextField *)tf
{
    NSLog(@"%@ === text1",tf.text);
    _baseBankName = tf.text;
    
}
//卡号
-(void)carNumText:(UITextField *)tf
{
    NSLog(@"%@ === text2",tf.text);
    _kcardNum = tf.text;
    
}
//手机号
-(void)phoneNumText:(UITextField *)tf
{
    NSLog(@"%@ === text2",tf.text);
    _phoneNum = tf.text;
    
    if (tf.text.length > 0) {
        [_nextBtn setTitleColor:HEXCOLOR(0xffffff) forState:UIControlStateNormal];
        [_nextBtn setBackgroundColor:HEXCOLOR(0xF95A70)];
        _nextBtn.enabled = YES;
    } else{
        [_nextBtn setTitleColor:HEXCOLOR(0x666666) forState:UIControlStateNormal];
        [_nextBtn setBackgroundColor:HEXCOLOR(0xe0e0e0)];
        _nextBtn.enabled = NO;
    }
    
}

//用户协议
-(void)protcolAction:(UIButton *)sender
{
    NSLog(@"用户协议");
}
-(void)chooseAction:(UIButton *)sender
{
    NSLog(@"切换协议");
}
#pragma mark- 绑卡下一步
-(void)bandNext
{
    NSLog(@"下一步");
    [self bandBankCardPost];
    
}

#pragma mark - 绑定银行卡
-(void)bandBankCardPost
{
    NSDictionary * param = @{
                             @"account":BBUserDefault.userPhoneNumber,
                             @"baseBankId":_baseBankId,//银行卡基本编号
                             @"bankCredNum":_bankCredNum,//银行卡号
                             @"bankCredPhone":_phoneNum,//银行卡绑定电话
                             @"bankCredHolder":_bankCredHolder,//银行卡持有人姓名
                             @"bankCredType":_bankCredType,//银行卡类型   1.储蓄卡 2.信用卡	否
                             @"validDate":@"",//信用卡有效期，格式YYMM	是	银行卡类型   为 2 必填
                             @"cvv3":@"",//信用卡背后三后数
                             };
    [MENetWorkManager post:[NSString stringWithFormat:@"%@/QRCode/bindBank",zfb_baseUrl] params:param success:^(id response) {
        NSString * code = [NSString stringWithFormat:@"%@",response[@"resultCode"]];
        if ([code isEqualToString:@"0"]) {
            [SVProgressHUD showSuccessWithStatus:@"绑卡成功!"];
            [self backAction];
        }
        
    } progress:^(NSProgress *progeress) {
    } failure:^(NSError *error) {
        [SVProgressHUD showErrorWithStatus:@"网络出差了~"];

    }];
}

-(void)backAction
{
    [self poptoUIViewControllerNibName:@"RechargeViewController" AndObjectIndex:1];
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
