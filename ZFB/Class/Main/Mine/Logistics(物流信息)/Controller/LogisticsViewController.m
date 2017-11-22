//
//  LogisticsViewController.m
//  ZFB
//
//  Created by  展富宝  on 2017/11/22.
//  Copyright © 2017年 com.zfb. All rights reserved.
//

#import "LogisticsViewController.h"
#import "LogisticsCell.h"
#import "LogisticsProgressCell.h"
#import "LogisticsModel.h"

@interface LogisticsViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    NSString * _company ;
    NSString * _expressNumber ;
}
@property (nonatomic , strong ) UITableView * tableView;
@property (nonatomic , strong ) NSMutableArray * progressArray;

@end

@implementation LogisticsViewController
-(NSMutableArray *)progressArray{
    if (!_progressArray) {
        _progressArray =[ NSMutableArray array];
    }return _progressArray;
}
-(UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, KScreenW, KScreenH-64) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSelectionStyleNone;
 
    }return _tableView;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"物流信息";
    self.tableView.backgroundColor = self.view.backgroundColor = HEXCOLOR(0xf7f7f7);
    [self.view addSubview:self.tableView];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"LogisticsProgressCell" bundle:nil] forCellReuseIdentifier:@"LogisticsProgressCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"LogisticsCell" bundle:nil] forCellReuseIdentifier:@"LogisticsCell"];

    [self postRequest];

}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 1;
    }
    return self.progressArray.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat height = 0;
    if (indexPath.section == 0) {
        height = 65;
    }else{
        height = [tableView fd_heightForCellWithIdentifier:@"LogisticsProgressCell" configuration:^(id cell) {
            [self setUpCell:cell AtIndexPath:indexPath];
        }];
    }
    return height;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return 0.001;
    }
    return 40;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (section == 0) {
        return 10;
    }
    return 0.001;
}
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView * footView = nil;
    if (footView == nil) {
        footView  = [[UIView alloc]initWithFrame:CGRectMake(0, 0,KScreenW, 10)];
    }
    return footView;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView * headview = nil;
    if (section == 1) {
        if (headview == nil) {
            headview  = [[UIView alloc]initWithFrame:CGRectMake(15, 0,KScreenW, 40)];
            headview.backgroundColor = [UIColor whiteColor];
            UILabel * lab = [[UILabel alloc]initWithFrame:headview.frame];
            lab.text = @"订单跟踪";
            lab.font = SYSTEMFONT(14);
            lab.textColor =HEXCOLOR(0x333333);
            [headview addSubview:lab];
        }
    }
    return headview;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        LogisticsCell * cell = [self.tableView dequeueReusableCellWithIdentifier:@"LogisticsCell" forIndexPath:indexPath];
        cell.lb_company.text = _company;
        cell.lb_orderNum.text = _expressNumber;
        return cell;
    }
    else{
        LogisticsProgressCell * cell = [self.tableView dequeueReusableCellWithIdentifier:@"LogisticsProgressCell" forIndexPath:indexPath];
        [self setUpCell:cell AtIndexPath:indexPath];
        return cell;
    }
}

-(void)setUpCell:(LogisticsProgressCell *)cell AtIndexPath:(NSIndexPath *)indexPath
{
    LogisticsList * list  = self.progressArray[indexPath.row];
    cell.list = list;
    
}
#pragma mark -  查看物流
-(void)postRequest
{
    NSDictionary * param = @{
                            @"num": _orderNum
                             };
    
    [MENetWorkManager post:[zfb_baseUrl stringByAppendingString:@"/wuliu/queryWuliu"] params:param success:^(id response) {
        LogisticsModel * logistics  = [LogisticsModel mj_objectWithKeyValues:response];
        if ([logistics.resultCode isEqualToString:@"0"]) {
            _expressNumber = logistics.data.expressNumber;
            _company =logistics.data.company;
            
            if (self.progressArray.count  > 0) {
                [self.progressArray removeAllObjects];
            }
            for (LogisticsList * list in logistics.data.list) {
                [self.progressArray addObject:list];
            }
            [self.tableView reloadData];

        }
    } progress:^(NSProgress *progeress) {
    } failure:^(NSError *error) {
 
        NSLog(@"error=====%@",error);
        [self.view makeToast:@"网络错误" duration:2 position:@"center"];
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
