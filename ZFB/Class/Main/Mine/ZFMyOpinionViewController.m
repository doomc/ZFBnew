//
//  ZFMyOpinionViewController.m
//  ZFB
//
//  Created by  展富宝  on 2017/6/8.
//  Copyright © 2017年 com.zfb. All rights reserved.
//  我的意见

#import "ZFMyOpinionViewController.h"
#import "ZFMyOpinionCell.h"
#import "UserFeedbackModel.h"

@interface ZFMyOpinionViewController () <UITableViewDataSource,UITableViewDelegate>
{
    NSInteger  _page;
    NSInteger  _pageCount;
}
@property(nonatomic,strong)UITableView  * tableView;
@property(nonatomic,strong)NSMutableArray * listArray;
@end

@implementation ZFMyOpinionViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self.view addSubview:self.tableView];
    [self.tableView registerNib:[UINib nibWithNibName:@"ZFMyOpinionCell" bundle:nil] forCellReuseIdentifier:@"ZFMyOpinionCellid"];
    
    _pageCount = 8;
    weakSelf(weakSelf);
    //上拉加载
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        
        _page ++ ;
        [weakSelf feedOpinionPostRequst];
        
    }];
    
    //下拉刷新
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        //需要将页码设置为1
        _page = 1;
        [weakSelf feedOpinionPostRequst];
    }];
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
    return self.listArray.count;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return 1;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat height = 0;
    Userfeedbacklist * list = self.listArray[indexPath.section];
    
    if ([list.ideaTime isEqualToString:@""]) {//判断图片地址是不是空
         //有图的是112  68
//        height = 68;
        height =    [tableView fd_heightForCellWithIdentifier:@"ZFMyOpinionCellid" configuration:^(id cell) {
        }];
    }
    else{
//        height = 112;
    height =    [tableView fd_heightForCellWithIdentifier:@"ZFMyOpinionCellid" configuration:^(id cell) {
        }];
    }

    return height;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return 10;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ZFMyOpinionCell *opinionCell = [self.tableView  dequeueReusableCellWithIdentifier:@"ZFMyOpinionCellid" forIndexPath:indexPath];
    opinionCell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    if (self.listArray.count > 0) {
        Userfeedbacklist * list = self.listArray[indexPath.section];
        opinionCell.imagerray  = self.listArray ;
        opinionCell.lb_title.text = list.idea;
        opinionCell.lb_time.text = list.ideaTime;
        opinionCell.lb_status.text =@"已采纳";
        
    }
    
    return opinionCell;
    
}
#pragma tableViewDataSource
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"%ld --------%ld",indexPath.section,indexPath.row);
}


#pragma mark - 意见反馈列表 -getCmUserFeedbackByUserId
-(void)feedOpinionPostRequst
{
    
    NSString * pageSize= [NSString stringWithFormat:@"%ld",_pageCount];
    NSString * pageIndex= [NSString stringWithFormat:@"%ld",_page];
    
    NSDictionary * parma = @{
                             
                             @"svcName":@"getCmUserFeedbackByUserId",
                             @"pageSize":pageSize,//每页显示条数
                             @"pageIndex":pageIndex,//当前页码
                             //                             @"cmUserId":BBUserDefault.cmUserId,
                             
                             };
    
    NSDictionary *parmaDic=[NSDictionary dictionaryWithDictionary:parma];
    [SVProgressHUD show];
    [PPNetworkHelper POST:zfb_url parameters:parmaDic responseCache:^(id responseCache) {
    } success:^(id responseObject) {
        
        if ([responseObject[@"resultCode"] isEqualToString:@"0"]) {
            
            [self.tableView.mj_header endRefreshing];
            [self.tableView.mj_footer endRefreshing];
            
            if (_page == 1) {
                
                for (;0 < self.listArray.count;) {
                    
                    [self.listArray removeObjectAtIndex:0];
                    
                }
            }
            NSString  * dataStr= [responseObject[@"data"] base64DecodedString];
            NSDictionary * jsondic = [NSString dictionaryWithJsonString:dataStr];
            //mjextention 数组转模
            UserFeedbackModel  *feedmodel = [UserFeedbackModel mj_objectWithKeyValues:jsondic];
            for (Userfeedbacklist *list in feedmodel.userFeedbackList) {
                [self.listArray addObject:list];
            }
            NSLog(@"listArray===== = %@",   self.listArray);
            [self.tableView reloadData];
            [SVProgressHUD dismiss];

        }
        [SVProgressHUD dismiss];

    } failure:^(NSError *error) {
        NSLog(@"%@",error);
        [SVProgressHUD dismiss];
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        [self.view makeToast:@"网络错误" duration:2 position:@"center"];
    }];
    
}


-(void)viewWillAppear:(BOOL)animated
{
    [self.tableView.mj_header beginRefreshing];
    
}

-(NSMutableArray *)listArray
{
    if (!_listArray) {
        _listArray =[NSMutableArray array];
    }
    return _listArray;
}
@end
