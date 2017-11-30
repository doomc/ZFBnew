//
//  EditCommentViewController.m
//  ZFB
//
//  Created by  展富宝  on 2017/11/30.
//  Copyright © 2017年 com.zfb. All rights reserved.
//

#import "EditCommentViewController.h"
#import "EditCommentFootView.h"
#import "EditCommetCell.h"

@interface EditCommentViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic , strong) UITableView * tableView;
@property (nonatomic , strong) NSMutableArray * commentList;//评论列表

@end

@implementation EditCommentViewController
-(UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, KScreenW, KScreenH - 64) style:UITableViewStylePlain];
        _tableView.delegate = self ;
        _tableView.dataSource  = self;
    }
    return _tableView;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"评论";
    
    [self.view addSubview:self.tableView];
    self.zfb_tableView = self.tableView;
    [self.tableView registerNib:[UINib nibWithNibName:@"EditCommetCell" bundle:nil] forCellReuseIdentifier:@"EditCommetCell"];
    [self setupRefresh];
    
}
-(void)headerRefresh
{
    [super headerRefresh];
}
-(void)footerRefresh
{
    [super footerRefresh];
}


//发布
-(void)commitPublishPost
{
    
}
//列表
-(void)commentPostList
{
    
}

-(void)viewWillAppear:(BOOL)animated
{
    [self settingNavBarBgName:@"nav64_gray"];
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
