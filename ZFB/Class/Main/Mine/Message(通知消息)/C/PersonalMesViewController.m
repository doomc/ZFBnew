//
//  PersonalMesViewController.m
//  ZFB
//
//  Created by 熊维东 on 2017/10/22.
//  Copyright © 2017年 com.zfb. All rights reserved.
//

#import "PersonalMesViewController.h"
#import "PersonMessageModel.h"
#import "PersonalMessCell.h"
#import "DetailMsgNoticeViewController.h"

@interface PersonalMesViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) NSMutableArray * messagelist;

@end
@implementation PersonalMesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"消息中心";
    [self settingTableview];

}
-(void)viewWillAppear:(BOOL)animated
{
    [self settingNavBarBgName:@"nav64_gray"];
   
}
-(void)settingTableview
{
    self.zfb_tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, KScreenW, KScreenH-64) style:UITableViewStylePlain];
    self.zfb_tableView.delegate  = self;
    self.zfb_tableView.dataSource = self;
//    self.zfb_tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.zfb_tableView];
    
    [self.zfb_tableView registerNib:[UINib nibWithNibName:@"PersonalMessCell" bundle:nil] forCellReuseIdentifier:@"PersonalMessCell"];
 
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 65;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    PersonalMessCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PersonalMessCell" forIndexPath:indexPath];
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    DetailMsgNoticeViewController * msgVC = [DetailMsgNoticeViewController new];
    [self.navigationController pushViewController:msgVC animated:NO];
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
