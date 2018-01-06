//
//  FunctionUpdateViewController.m
//  ZFB
//
//  Created by  展富宝  on 2017/12/28.
//  Copyright © 2017年 com.zfb. All rights reserved.
//  更新列表

#import "FunctionUpdateViewController.h"
#import "FuncDetailViewController.h"
#import "UpdateCell.h"
#import "UpdateModel.h"

@interface FunctionUpdateViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic , strong) UITableView * tableView;
@property (nonatomic , strong) NSMutableArray * dataArray;

@end

@implementation FunctionUpdateViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"功能介绍";
    
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, KScreenW, KScreenH-64) style:UITableViewStylePlain];
    self.tableView.delegate =self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = HEXCOLOR(0xf7f7f7);
    [self.view addSubview:self.tableView];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"UpdateCell" bundle:nil] forCellReuseIdentifier:@"UpdateCell"];
    [self postlist];
}
-(NSMutableArray *)dataArray
{
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 55.0f;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UpdateCell *  updateCell = [self.tableView dequeueReusableCellWithIdentifier:@"UpdateCell" forIndexPath:indexPath];
    if (self.dataArray.count > 0) {
        UpdateData * data = self.dataArray[indexPath.row];
        updateCell.dataList = data;
    }
    return updateCell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UpdateData * data = self.dataArray[indexPath.row];

    FuncDetailViewController  * detailVC = [FuncDetailViewController new];
    detailVC.theme = [NSString stringWithFormat:@"展富宝 V%@",data.versionCode];
    detailVC.content =  [NSString stringWithFormat:@"%@",data.versionDesc];
    detailVC.date = data.createTime;
    [self.navigationController pushViewController:detailVC animated:NO];
}


-(void)postlist
{
    
    NSString * version =     [NSString stringWithFormat:@"版本号:%@",appMPVersion];
    NSDictionary * parma = @{
                             @"versionCode":version,
                             };
    [MENetWorkManager post:[zfb_baseUrl stringByAppendingString:@"/getAppVersionInfo"] params:parma success:^(id response) {
        UpdateModel * update = [UpdateModel mj_objectWithKeyValues:response];
        if ([update.resultCode isEqualToString:@"0"]) {
            if (self.dataArray.count > 0) {
                [self.dataArray removeAllObjects];
            }
            for (UpdateData * data in update.data) {
                [self.dataArray addObject:data];
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
