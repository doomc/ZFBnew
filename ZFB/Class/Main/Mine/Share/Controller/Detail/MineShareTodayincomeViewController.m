//
//  MineShareTodayincomeViewController.m
//  ZFB
//
//  Created by  展富宝  on 2017/9/14.
//  Copyright © 2017年 com.zfb. All rights reserved.
//

#import "MineShareTodayincomeViewController.h"
#import "MineShareIncomeCell.h"

@interface MineShareTodayincomeViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (strong, nonatomic)  UITableView * tableView;

@end

@implementation MineShareTodayincomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"我的共享";
    [self.view addSubview:self.tableView];
    [self.tableView registerNib:[UINib nibWithNibName:@"MineShareIncomeCell" bundle:nil] forCellReuseIdentifier:@"MineShareIncomeCellid"];
    
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
    return 3;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 104;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MineShareIncomeCell * cell = [self.tableView dequeueReusableCellWithIdentifier:@"MineShareIncomeCellid" forIndexPath:indexPath];
    
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
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
