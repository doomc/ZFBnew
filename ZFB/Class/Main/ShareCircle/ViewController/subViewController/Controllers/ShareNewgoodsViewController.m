//
//  ShareNewgoodsViewController.m
//  ZFB
//
//  Created by  展富宝  on 2017/9/12.
//  Copyright © 2017年 com.zfb. All rights reserved.
//  新品推荐

#import "ShareNewgoodsViewController.h"
#import "ShareNewGoodsCell.h"
@interface ShareNewgoodsViewController ()<UITableViewDelegate,UITableViewDataSource>
@end

@implementation ShareNewgoodsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self initTableView];
}

-(void)initTableView
{
    self.zfb_tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, KScreenW, KScreenH - 64 -50 -44) style:UITableViewStylePlain];
    self.zfb_tableView.delegate = self;
    self.zfb_tableView.dataSource = self;
    self.zfb_tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.zfb_tableView];
    
    [self.zfb_tableView registerNib:[UINib nibWithNibName:@"ShareNewGoodsCell" bundle:nil] forCellReuseIdentifier:@"ShareNewGoodsCellid"];
}


#pragma mark - UITableViewDataSource ,UITableViewDelegate
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
    return 330;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ShareNewGoodsCell * goodCell = [self.zfb_tableView dequeueReusableCellWithIdentifier:@"ShareNewGoodsCellid" forIndexPath:indexPath];
    return goodCell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"%ld", indexPath.row);
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
