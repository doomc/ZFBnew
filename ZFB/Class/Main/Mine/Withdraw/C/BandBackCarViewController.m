
//
//  BandBackCarViewController.m
//  ZFB
//
//  Created by  展富宝  on 2017/10/20.
//  Copyright © 2017年 com.zfb. All rights reserved.
//  绑定银行卡

#import "BandBackCarViewController.h"
#import "BankCardListModel.h"
#import "BankCarListCell.h"
#import "AddBackButtonCell.h"
#import "AddBankCardViewController.h"
#import "CertificationViewController.h"
@interface BandBackCarViewController ()<UITableViewDelegate,UITableViewDataSource,AddBackButtonCellDelegate>
{
    NSString * _realNameFlag;

}
@property (nonatomic ,strong) UITableView * tableView;
@property (nonatomic ,strong) NSMutableArray * backCardList;

@end

@implementation BandBackCarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"银行卡";
    
    [self.view addSubview:self.tableView];
    [self.tableView registerNib:[UINib nibWithNibName:@"BankCarListCell" bundle:nil] forCellReuseIdentifier:@"BankCarListCellid"];
    [self.tableView registerNib:[UINib nibWithNibName:@"AddBackButtonCell" bundle:nil] forCellReuseIdentifier:@"AddBackButtonCell"];
    
    
}
-(void)viewWillAppear:(BOOL)animated
{
    [self backCardListPost];
}

-(NSMutableArray *)backCardList{
    if (!_backCardList) {
        _backCardList = [NSMutableArray array];
    }
    return  _backCardList;
    
}
-(UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, KScreenW, KScreenH - 64) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle =  UITableViewCellSeparatorStyleNone;
    }
    return  _tableView;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return  self.backCardList.count;
    }else{
        return 1;
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    CGFloat height = 0;
    if (indexPath.section == 0) {
        if (self.backCardList.count > 0) {
            height =  150;
        }else{
            height =  0;
        }
    }else{
        height =  125;
    }
    return height;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        BankCarListCell  * listCell = [self.tableView dequeueReusableCellWithIdentifier:@"BankCarListCellid" forIndexPath:indexPath];
        if (self.backCardList.count > 0) {
            BankList * list = self.backCardList[indexPath.row];
            listCell.banklist = list;
            return listCell;
        }else{
            [listCell setHidden:YES];
        }

    }
    AddBackButtonCell *buttonCell = [self.tableView dequeueReusableCellWithIdentifier:@"AddBackButtonCell" forIndexPath:indexPath];
    buttonCell.delegate  = self;
    buttonCell.sureWithdrawBtn.hidden = YES;
    return buttonCell;
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
}
#pragma mark- AddBackButtonCellDelegate 点击银行卡的代理
//添加银行卡
-(void)didClickAddBankCard{
    NSLog(@"我点击到了吗");
    [self realNamePost];

//    AddBankCardViewController * addVC = [AddBankCardViewController new];
//    [self.navigationController pushViewController:addVC animated:NO];
}
//银行卡列表
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
            [self.tableView reloadData];
        }
    } progress:^(NSProgress *progeress) {
        
    } failure:^(NSError *error) {
        
    }];
    
}
#pragma mark - 实名认证
-(void)realNamePost{
    NSDictionary * parma = @{
                             @"cmUserId":BBUserDefault.cmUserId,
                             };
    [MENetWorkManager post:[zfb_baseUrl stringByAppendingString:@"/getUserInfo"] params:parma success:^(id response) {
        NSString * code = [NSString stringWithFormat:@"%@",response [@"resultCode"]];
        if ([code isEqualToString:@"0"]) {
            //是否实名认证 1 是 2 否
            _realNameFlag = [NSString stringWithFormat:@"%@",response[@"userInfo"][@"realNameFlag"]];
            
            if ([_realNameFlag isEqualToString:@"1"]) {
                AddBankCardViewController * addVC = [AddBankCardViewController new];
                [self.navigationController pushViewController:addVC animated:NO];
                
            }else{
                CertificationViewController * cerVC = [CertificationViewController new];
                [self.navigationController pushViewController:cerVC animated:NO];

            }
        }
    } progress:^(NSProgress *progeress) {
    } failure:^(NSError *error) {
        NSLog(@"error=====%@",error);
        [self.view makeToast:@"网络出差了~" duration:2 position:@"center"];
        
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
