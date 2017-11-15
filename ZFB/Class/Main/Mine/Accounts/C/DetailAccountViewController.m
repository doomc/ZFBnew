//
//  DetailAccountViewController.m
//  ZFB
//
//  Created by  展富宝  on 2017/10/9.
//  Copyright © 2017年 com.zfb. All rights reserved.
//

#import "DetailAccountViewController.h"
#import "DetailAcountTitleCell.h"
#import "DetailAcountHeaderCell.h"

@interface DetailAccountViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    NSString * _transaction_no ;//商户订单号
    NSString * _order_num ;//订单号
    NSString * _transaction_amount ;//交易金额
    NSString * _flow_pay_type; // 流水支付类型 0支出 1 收入
    NSString * _object_name ;//名称
    NSString * _pay_mode_name ;//付款方式
    NSString * _create_time ;//创建时间
    NSString * _target_account ;//对方账户
    NSString * _transfer_description ;//商品说明
    NSString * _delivery_address ;//收货地址
    NSString * _transaction_status ;//交易状态 0 交易成功，1等待付款, -1 交易关闭
    NSString * _logo_url ;//头像
    NSInteger cellCount;//返回cell的个数

}
@property (nonatomic , strong) UITableView * tableview;
@property (nonatomic , strong) NSArray * titles;//标题
@property (nonatomic , strong) NSMutableArray * subTitles;//子标题

@end

@implementation DetailAccountViewController
-(UITableView *)tableview
{
    if (!_tableview) {
        _tableview = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, KScreenW, KScreenH) style:UITableViewStylePlain];
        _tableview.delegate = self;
        _tableview.dataSource = self;
        _tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return _tableview;
}
-(NSMutableArray *)subTitles
{
    if (!_subTitles) {
        _subTitles = [NSMutableArray array];
    }
    return _subTitles;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"明细详情";
    [self.view addSubview:self.tableview];

    _titles = @[@"付款方式",@"商品说明",@"收货地址",@"创建时间",@"订单号",@"商户订单号"];
    
    [self.tableview registerNib:[UINib nibWithNibName:@"DetailAcountHeaderCell" bundle:nil] forCellReuseIdentifier:@"DetailAcountHeaderCellid"];
    [self.tableview registerNib:[UINib nibWithNibName:@"DetailAcountTitleCell" bundle:nil] forCellReuseIdentifier:@"DetailAcountTitleCellid"];
    
    // 支付类型	1 转账 2 退款 3 充值 4 交易订单 5 提现 6佣金
//    if ([_pay_type isEqualToString:@"1"] || [_pay_type isEqualToString:@"2"]) {
//        
//        cellCount = 5;
//    }
//    if ([_pay_type isEqualToString:@"3"] || [_pay_type isEqualToString:@"3"]) {
//        cellCount = 6;
//    }
//    if ([_pay_type isEqualToString:@"4"]) {
//        cellCount = 6;
//    }
}

-(void)viewWillAppear:(BOOL)animated
{
    [self accountListPostRequst];
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return 1;
    }else {
     // 支付类型	1 转账 2 退款 3 充值 4 订单 5 提现 6佣金
//        if ([_pay_type isEqualToString:@"4"]) {
//            return 6;
//        }
        return _titles.count;
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return 120;
    }
    return 50;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        
        DetailAcountHeaderCell * headCell = [self.tableview dequeueReusableCellWithIdentifier:@"DetailAcountHeaderCellid" forIndexPath:indexPath];
        headCell.lb_name.text = _object_name;
        [headCell.headImg sd_setImageWithURL:[NSURL URLWithString:_logo_url] placeholderImage:[UIImage imageNamed:@"head"]];

        if ([_flow_pay_type isEqualToString:@"0"]) {//流水支付类型 0支出 1 收入
            headCell.lb_price.text = [NSString stringWithFormat:@"-%@",_transaction_amount];
        }else{
            headCell.lb_price.text = [NSString stringWithFormat:@"+%@",_transaction_amount];
        }
        if ([_transaction_status isEqualToString:@"0"]) {//交易状态 0 交易成功，1等待付款, -1 交易关闭
            headCell.lb_dealStatus.text = @"交易成功";
        }
        if ([_transaction_status isEqualToString:@"1"]) {//交易状态 0 交易成功，1等待付款, -1 交易关闭
            headCell.lb_dealStatus.text = @"等待付款";
        }
        if ([_transaction_status isEqualToString:@"-1"]) {//交易状态 0 交易成功，1等待付款, -1 交易关闭
            headCell.lb_dealStatus.text = @"交易关闭";
        }
        return headCell;
        
    }else{
        DetailAcountTitleCell * titleCell = [self.tableview dequeueReusableCellWithIdentifier:@"DetailAcountTitleCellid" forIndexPath:indexPath];

        if (self.subTitles.count>0) {
            titleCell.lb_title.text = _titles[indexPath.row];
            titleCell.lb_descirption.text = self.subTitles[indexPath.row];
        }
        return titleCell;

    }
    
}

-(void)accountListPostRequst
{
    NSDictionary * param  = @{
                              @"operationAccount":BBUserDefault.userPhoneNumber,
                              @"flowId":_flowId,
 
                              };
    [SVProgressHUD show];
    [MENetWorkManager post:[NSString stringWithFormat:@"%@/flow/getFlowDetails",zfb_baseUrl] params:param success:^(id response) {
        NSString * code = [NSString stringWithFormat:@"%@",response[@"resultCode"]];
        if ([code isEqualToString:@"0"]) {
   
            _object_name = [NSString stringWithFormat:@"%@",response[@"data"][@"object_name"]];
            _logo_url = [NSString stringWithFormat:@"%@",response[@"data"][@"logo_url"]];
            //交易状态 0 交易成功，1等待付款, -1 交易关闭
            _transaction_status = [NSString stringWithFormat:@"%@",response[@"data"][@"transaction_status"]];
            _flow_pay_type = [NSString stringWithFormat:@"%@",response[@"data"][@"flow_pay_type"]];
            //价格
            _transaction_amount =  [NSString stringWithFormat:@"%@",response[@"data"][@"transaction_amount"]];
            
            //下
            _transaction_no = [NSString stringWithFormat:@"%@",response[@"data"][@"transaction_no"]];
            _transfer_description = [NSString stringWithFormat:@"%@",response[@"data"][@"transfer_description"]];
            _order_num = [NSString stringWithFormat:@"%@",response[@"data"][@"order_num"]];
            _pay_mode_name = [NSString stringWithFormat:@"%@",response[@"data"][@"pay_mode_name"]];
            _delivery_address = [NSString stringWithFormat:@"%@",response[@"data"][@"delivery_address"]];
            _create_time = [NSString stringWithFormat:@"%@",response[@"data"][@"create_time"]];
            
            [self.subTitles addObject:_pay_mode_name];
            [self.subTitles addObject:_transfer_description];
            [self.subTitles addObject:_delivery_address];
            [self.subTitles addObject:_create_time];
            [self.subTitles addObject:_order_num];
            [self.subTitles addObject:_transaction_no];
            
            [self.tableview reloadData];
            [SVProgressHUD dismiss];

        }
    } progress:^(NSProgress *progeress) {
        
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
        [SVProgressHUD dismiss];
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
