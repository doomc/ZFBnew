//
//  BankCarListViewController.m
//  ZFB
//
//  Created by  展富宝  on 2017/10/20.
//  Copyright © 2017年 com.zfb. All rights reserved.
//

#import "BankCarListViewController.h"
#import "BankCardListModel.h"
#import "BankCarListCell.h"
@interface BankCarListViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic , strong) UITableView *tableView;
@property (nonatomic ,strong) NSMutableArray * backCardList;


@end

@implementation BankCarListViewController
-(NSMutableArray *)backCardList
{
    if (!_backCardList) {
        _backCardList = [NSMutableArray array];
    }
    return  _backCardList;
}
-(UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, KScreenW, KScreenH-64) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle =  UITableViewCellSeparatorStyleNone;
    }
    return  _tableView;
}

-(void)viewWillAppear:(BOOL)animated
{
    [self backCardListPost];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"银行卡列表";
    [self.view addSubview:self.tableView];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"BankCarListCell" bundle:nil] forCellReuseIdentifier:@"BankCarListCell"];
    
}


-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return  self.backCardList.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    BankCarListCell  * listCell = [self.tableView dequeueReusableCellWithIdentifier:@"BankCarListCell" forIndexPath:indexPath];
    Base_Bank_List * bankCard = self.backCardList[indexPath.row];
    listCell.bankList = bankCard;
    return listCell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    //传一个block回调当前银行卡信息
    
}
//银行卡列表
-(void)backCardListPost
{
    NSDictionary * param = @{
                             @"account":BBUserDefault.userPhoneNumber
                             };
    [MENetWorkManager post:[NSString stringWithFormat:@"%@/QRCode/getBaseBankList",zfb_baseUrl] params:param success:^(id response) {
        NSString * code = [NSString stringWithFormat:@"%@",response[@"resultCode"]];
        
        if ([code isEqualToString:@"0"]) {
            
            BankCardListModel  * bank = [BankCardListModel mj_objectWithKeyValues:response];
            for (Base_Bank_List * list in bank.base_bank_list) {
                [self.backCardList addObject:list];
            }
            
            [self.tableView reloadData];
        }
    } progress:^(NSProgress *progeress) {
        
    } failure:^(NSError *error) {
        
    }];
    
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
