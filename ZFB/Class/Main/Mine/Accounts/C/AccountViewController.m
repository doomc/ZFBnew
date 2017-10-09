//
//  AccountViewController.m
//  ZFB
//
//  Created by  展富宝  on 2017/10/9.
//  Copyright © 2017年 com.zfb. All rights reserved.
//

#import "AccountViewController.h"
#import "AccountListCell.h"
#import "AccountModel.h"
#import "DetailAccountViewController.h"

@interface AccountViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic , strong) NSMutableArray * accountList;

@end

@implementation AccountViewController
-(NSMutableArray *)accountList
{
    if (!_accountList) {
        _accountList = [NSMutableArray array];
    }return _accountList;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"查看明细";
    
    [self initWithInterface];
    [self setupRefresh];
}
-(void)viewWillAppear:(BOOL)animated
{
    //暂时写着
    [self accountListPostRequstAtPayType:@"0"];
}
-(void)footerRefresh
{
    [super footerRefresh];
    [self accountListPostRequstAtPayType:@"0"];

}
-(void)headerRefresh
{
    [super headerRefresh];
    [self accountListPostRequstAtPayType:@"0"];

}

-(void)initWithInterface
{
    self.zfb_tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, KScreenW, KScreenH-64) style:UITableViewStylePlain];
    self.zfb_tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.zfb_tableView.delegate = self;
    self.zfb_tableView.dataSource = self;
    [self.view addSubview:self.zfb_tableView];
    [self.zfb_tableView registerNib:[UINib nibWithNibName:@"AccountListCell" bundle:nil] forCellReuseIdentifier:@"AccountListCell"];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.accountList.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 70;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    Cashflowlist * cashlist = self.accountList[indexPath.row];
    AccountListCell * cell = [self.zfb_tableView dequeueReusableCellWithIdentifier:@"AccountListCell" forIndexPath:indexPath];
    cell.cashlist = cashlist;
    return cell;
    
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"row == %ld",indexPath.row);
    Cashflowlist * cashlist = self.accountList[indexPath.row];
    DetailAccountViewController * detailVC = [[DetailAccountViewController alloc]init];
    detailVC.flowId = [NSString stringWithFormat:@"%ld",cashlist.flowId];
    [self.navigationController pushViewController:detailVC animated:NO];
 
}

/**
 流水列表

 @param payType 0.全部 1 转账 2 退款 3 充值 4 订单 5 提现 6佣金

 */
-(void)accountListPostRequstAtPayType:(NSString *)payType
{
    NSDictionary * param  = @{
                              @"operationAccount":BBUserDefault.userPhoneNumber,
                              @"page":[NSNumber numberWithInteger:self.currentPage],
                              @"size":[NSNumber numberWithInteger:kPageCount],
                              @"payType":payType,
                              };
    [SVProgressHUD show];
    [MENetWorkManager post:[NSString stringWithFormat:@"%@/flow/getFlowList",zfb_baseUrl] params:param success:^(id response) {
    
        if ([response[@"resultCode"] isEqualToString:@"0"]) {
            if (self.refreshType == RefreshTypeHeader) {
                [self.accountList removeAllObjects];
            }
            AccountModel * account  = [AccountModel mj_objectWithKeyValues:response];
        
            for (Cashflowlist * list in account.data.cashFlowList) {
                [self.accountList addObject:list];
            }
            [SVProgressHUD dismiss];
            [self.zfb_tableView reloadData];

        }
        [self endRefresh];
    } progress:^(NSProgress *progeress) {
        
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
        [SVProgressHUD dismiss];
        [self endRefresh];
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
