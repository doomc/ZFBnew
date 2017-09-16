//
//  MineShareTodayincomeViewController.m
//  ZFB
//
//  Created by  展富宝  on 2017/9/14.
//  Copyright © 2017年 com.zfb. All rights reserved.
//  今日收入

#import "MineShareTodayincomeViewController.h"
#import "MineShareIncomeCell.h"

@interface MineShareTodayincomeViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (strong, nonatomic)  UITableView * tableView;
@property (strong, nonatomic)  NSMutableArray * todayList;

@end

@implementation MineShareTodayincomeViewController

-(NSMutableArray *)todayList{

    if (!_todayList) {
        _todayList = [NSMutableArray array];
    }
    return _todayList;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"我的共享";
    [self.view addSubview:self.tableView];
    self.zfb_tableView = self.tableView;

    
    [self.tableView registerNib:[UINib nibWithNibName:@"MineShareIncomeCell" bundle:nil] forCellReuseIdentifier:@"MineShareIncomeCellid"];
    [self setupRefresh];
    [self todayListGoodsPost];

}
-(void)footerRefresh
{
    [super footerRefresh];
    [self todayListGoodsPost];
}
-(void)headerRefresh
{
    [super headerRefresh];
    [self todayListGoodsPost];

}
#pragma mark - 懒加载
-(UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, KScreenW, KScreenH - 64) style:UITableViewStylePlain
                      ];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle =  UITableViewCellSelectionStyleNone;
    }
    return _tableView;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.todayList.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 104;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MineShareIncomeCell * cell = [self.tableView dequeueReusableCellWithIdentifier:@"MineShareIncomeCellid" forIndexPath:indexPath];
    ReViewData * todayData = self.todayList[indexPath.row];
    cell.todayReviewData = todayData;
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}


#pragma mark  - 我的共享列表    myShare/allShareOrderList
-(void)todayListGoodsPost
{
    NSDictionary * parma = @{
                             @"userId":BBUserDefault.cmUserId,
                             @"pageIndex":[NSNumber numberWithInteger:self.currentPage],
                             @"pageSize":[NSNumber numberWithInteger:kPageCount],
                             };
    [SVProgressHUD show];
    [MENetWorkManager post:[zfb_baseUrl stringByAppendingString:@"/myShare/allShareOrderList"] params:parma success:^(id response) {
        if ([response[@"resultCode"] isEqualToString:@"0"] ) {
            
            if (self.refreshType == RefreshTypeHeader) {
                if (self.todayList.count > 0) {
                    [self.todayList removeAllObjects];
                }
            }
            ReviewingModel * review =[ ReviewingModel mj_objectWithKeyValues:response];
            for (ReViewData * reviewData in review.data) {
                
                [self.todayList addObject:reviewData];
            }
            [self endRefresh];
            [self.tableView reloadData];
            [SVProgressHUD dismiss];
        }
        
    } progress:^(NSProgress *progeress) {
        
    } failure:^(NSError *error) {
        [SVProgressHUD dismiss];
        [self endRefresh];
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