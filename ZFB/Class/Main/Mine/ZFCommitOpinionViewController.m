//
//  ZFCommitOpinionViewController.m
//  ZFB
//
//  Created by  展富宝  on 2017/6/8.
//  Copyright © 2017年 com.zfb. All rights reserved.
//  提交意见


#import "ZFCommitOpinionViewController.h"

@interface ZFCommitOpinionViewController () <UITableViewDataSource,UITableViewDelegate>

@property(nonatomic,strong)UITableView  * tableView;

@end

@implementation ZFCommitOpinionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.tableView.backgroundColor = randomColor;
    
    [self.view addSubview:self.tableView];
}

-(UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, KScreenW, KScreenH -104) style:UITableViewStylePlain];
        _tableView.dataSource =self;
        _tableView.delegate= self;
    }
    return _tableView;
}
#pragma mark - datasoruce  代理实现
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
    return 100;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
//    UITableViewCell *storeCell = [self.tableView  dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
//    storeCell.selectionStyle = UITableViewCellSelectionStyleNone;
    UITableViewCell *storeCell  =[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cell"];
    
    return storeCell;
    
}
#pragma tableViewDataSource
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
 
}


@end
