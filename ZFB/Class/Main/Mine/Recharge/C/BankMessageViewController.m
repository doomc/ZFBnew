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
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, KScreenW, 110+ 32+55) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
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
    
    [self settingButton];
    [self.view addSubview:self.tableView];
}
-(void)settingButton
{
    _nextBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_nextBtn setTitle:@"下一步" forState:UIControlStateNormal];
    _nextBtn.titleLabel.font = SYSTEMFONT(15);
    [_nextBtn addTarget: self action:@selector(bandNext) forControlEvents:UIControlEventTouchUpInside];
    _nextBtn.frame = CGRectMake( 15, 2*110+ 32, KScreenW -30, 45);
    
    [_nextBtn setTitleColor:HEXCOLOR(0x666666) forState:UIControlStateNormal];
    [_nextBtn setBackgroundColor:HEXCOLOR(0xe0e0e0)];
    _nextBtn.enabled = NO;
    
    [self.view addSubview:_nextBtn];
    
//    if (_massgeEnough == YES) {
//        [_nextBtn setTitleColor:HEXCOLOR(0xffffff) forState:UIControlStateNormal];
//        [_nextBtn setBackgroundColor:HEXCOLOR(0xF95A70)];
//        _nextBtn.enabled = YES;
//        
//    }else{
//        [_nextBtn setTitleColor:HEXCOLOR(0x666666) forState:UIControlStateNormal];
//        [_nextBtn setBackgroundColor:HEXCOLOR(0xe0e0e0)];
//        _nextBtn.enabled = NO;
    
//    }
    
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
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView * view = nil;
    if (!view) {
        view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, KScreenW, 32)];
    }
    return view;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 32;
}
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView * footview = nil;
    if (!footview) {
        footview = [[UIView alloc]initWithFrame:CGRectMake(0, 0, KScreenW, 32)];
        
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
            make.left.equalTo(argreeBtn).with.offset(5);
            make.top.equalTo(footview).with.offset(10);
        }];
        
        UIButton * protoclbtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [protoclbtn setTitleColor:HEXCOLOR(0xF95A70) forState:UIControlStateNormal];
        [protoclbtn setTitle:@"《展富宝代发服务协议》" forState:UIControlStateNormal];
        [protoclbtn addTarget:self action:@selector(protcolAction:) forControlEvents:UIControlEventTouchUpInside];
        [footview addSubview:protoclbtn];
        
        [protoclbtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(tag.right).with.offset(5);
            make.top.equalTo(footview).with.offset(10);
        }];
        
    }
    return footview;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    AddBankCell * backCell = [self.tableView dequeueReusableCellWithIdentifier:@"AddBankCell" forIndexPath:indexPath];
    backCell.LB_title.text = _titles[indexPath.row];
//    backCell.tf_content.placeholder = _placeHoder[indexPath.row];
    
    if (indexPath.row == 0) {
        [backCell.tf_content addTarget:self action:@selector(handCarText:) forControlEvents:UIControlEventEditingChanged];
        
    }else if(indexPath.row == 1)
    {
        [backCell.tf_content addTarget:self action:@selector(carNumText:) forControlEvents:UIControlEventEditingChanged];
        
    }else{
        [backCell.tf_content addTarget:self action:@selector(phoneNumText:) forControlEvents:UIControlEventEditingChanged];

    }
    return backCell;
    
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
        
        
    } progress:^(NSProgress *progeress) {
        
    } failure:^(NSError *error) {
        
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
