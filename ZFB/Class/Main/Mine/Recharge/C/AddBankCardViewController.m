//
//  AddBankCardViewController.m
//  ZFB
//
//  Created by  展富宝  on 2017/10/18.
//  Copyright © 2017年 com.zfb. All rights reserved.
//  添加银行卡

#import "AddBankCardViewController.h"
#import "AddBankCell.h"

@interface AddBankCardViewController () <UITableViewDelegate ,UITableViewDataSource>

@property (nonatomic ,strong) NSArray * titles;
@property (nonatomic ,strong) NSArray * placeHoder;
@property (nonatomic ,strong) UITableView * tableView;

@end

@implementation AddBankCardViewController

-(UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, KScreenW, KScreenH-64) style:UITableViewStylePlain];
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
    self.title = @"银行卡添加";
    _titles = @[@"银行卡号:",@"所属银行:",@"身份证号:",@"预留手机号:",@"持卡人姓名:"];
    _placeHoder = @[@"8888 8888 8888 8888",@"",@"预留身份证号码",@"预留手机号",@"姓名"];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"AddBankCell" bundle:nil] forCellReuseIdentifier:@"AddBankCell"];
    [self.view addSubview:self.tableView];
    
}


-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 5;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    AddBankCell * backCell = [self.tableView dequeueReusableCellWithIdentifier:@"AddBankCell" forIndexPath:indexPath];
    backCell.LB_title.text = _titles[indexPath.row];
    backCell.tf_content.placeholder = _placeHoder[indexPath.row];
    
    return backCell;
    
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

#pragma mark - 绑定银行卡
-(void)bandBankCardPost
{
    NSDictionary * param = @{
                              @"account":BBUserDefault.userPhoneNumber,
                                @"baseBankId":@"",//银行卡基本编号
                                @"bankCredNum":@"",//银行卡号
                                @"bankCredPhone":@"",//银行卡绑定电话
                                @"bankCredHolder":@"",//银行卡持有人姓名
                                @"bankCredType":@"",//银行卡类型   1.储蓄卡 2.信用卡	否
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
