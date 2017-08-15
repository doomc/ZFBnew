//
//  QRCollectHistoryViewController.m
//  ZFB
//
//  Created by  展富宝  on 2017/8/14.
//  Copyright © 2017年 com.zfb. All rights reserved.
//  收款记录

#import "QRCollectHistoryViewController.h"
#import "QRPayHistoryCell.h"
#import "DetailCollectMoneyViewController.h"

static NSString * identiHisyCell = @"QRPayHistoryCell";

@interface QRCollectHistoryViewController ()<UITableViewDelegate ,UITableViewDataSource>

@property (nonatomic, strong) UITableView * tableView;
@property (nonatomic, strong) NSMutableArray * recordArray;

@end

@implementation QRCollectHistoryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Do any additional setup after loading the view.
    self.title = @"收款记录";
    [self.view addSubview:self.tableView];
    
    [self.tableView registerNib:[UINib nibWithNibName:identiHisyCell bundle:nil] forCellReuseIdentifier:identiHisyCell];
}

-(NSMutableArray *)recordArray
{
    if (!_recordArray) {
        _recordArray = [NSMutableArray array];
    }
    return _recordArray;
}

-(UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, KScreenW, KScreenH - 64) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        
    }
    return  _tableView;
}


-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
    
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 4;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 75;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 44;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    
    UITableViewHeaderFooterView * headView = [[UITableViewHeaderFooterView alloc]initWithFrame:CGRectMake(0, 0, KScreenW, 44)];
    UILabel * month = [[UILabel alloc]initWithFrame:CGRectMake(15, 10, KScreenW, 22)];
    month.text = @"8月";
    [headView addSubview:month];

    return headView;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    QRPayHistoryCell * historyCell = [self.tableView dequeueReusableCellWithIdentifier:identiHisyCell forIndexPath:indexPath];
    
    return historyCell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    DetailCollectMoneyViewController * detailVC = [ DetailCollectMoneyViewController new];
    [self.navigationController pushViewController:detailVC animated:NO];
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
