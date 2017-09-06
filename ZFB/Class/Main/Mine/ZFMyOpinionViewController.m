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

@interface ZFMyOpinionViewController () <UITableViewDataSource,UITableViewDelegate,CYLTableViewPlaceHolderDelegate, WeChatStylePlaceHolderDelegate>
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
    
}

-(UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, KScreenW, KScreenH -104) style:UITableViewStylePlain];
        _tableView.dataSource =self;
        _tableView.delegate= self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
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
    Feedbacklist * list = self.listArray[indexPath.section];
    
    if ([list.feedbackUrl isEqualToString:@""]) {//判断图片地址是不是空
        
        return [tableView fd_heightForCellWithIdentifier:@"ZFMyOpinionCellid" configuration:^(id cell) {
          
            [self configCell:cell indexPath:indexPath];
        }];
    }
    else{
        
        return [tableView fd_heightForCellWithIdentifier:@"ZFMyOpinionCellid" configuration:^(id cell) {
            
            [self configCell:cell indexPath:indexPath];
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
    
    [self configCell:opinionCell indexPath:indexPath];

    return opinionCell;
    
}
-(void)configCell:(ZFMyOpinionCell *)cell indexPath:(NSIndexPath *)indexPath
{
    if (self.listArray.count > 0) {
       
        Feedbacklist * list = self.listArray[indexPath.section];
        cell.feedList = list;
        [cell.feedCollectionView reloadData];

    }
}

#pragma tableViewDataSource
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"%ld --------%ld",indexPath.section,indexPath.row);
}


#pragma mark - 意见反馈列表 -getFeedbackINfoByUserId
-(void)feedOpinionPostRequst
{
    NSDictionary * parma = @{
                             @"cmUserId":BBUserDefault.cmUserId,
                             @"page":@"1",
                             @"size":@"10",
                             };
    [MENetWorkManager post:[zfb_baseUrl stringByAppendingString:@"/getFeedbackINfoByUserId"] params:parma success:^(id response) {
        
        if ([response[@"resultCode"] intValue] == 0) {
            if (self.listArray.count > 0) {
                
                [self.listArray removeAllObjects];
            }
            UserFeedbackModel * feedModel = [UserFeedbackModel mj_objectWithKeyValues:response];
            
            for (Feedbacklist * list in feedModel.feedbackList) {
                
                [self.listArray addObject:list];
                
            }
            
            [self.tableView reloadData];
 
            if ([self isEmptyArray:self.listArray]) {
                [self.tableView cyl_reloadData];
            }
        }
       
        
    } progress:^(NSProgress *progeress) {
        
    } failure:^(NSError *error) {
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        NSLog(@"error=====%@",error);
        [self.view makeToast:@"网络错误" duration:2 position:@"center"];
    }];
    
}


-(void)viewWillAppear:(BOOL)animated
{
    [self feedOpinionPostRequst];

}
#pragma mark - CYLTableViewPlaceHolderDelegate Method
- (UIView *)makePlaceHolderView {
    
    UIView *weChatStyle = [self weChatStylePlaceHolder];
    return weChatStyle;
}
//暂无数据
- (UIView *)weChatStylePlaceHolder {
    WeChatStylePlaceHolder *weChatStylePlaceHolder = [[WeChatStylePlaceHolder alloc] initWithFrame:self.zfb_tableView.frame];
    weChatStylePlaceHolder.delegate = self;
    return weChatStylePlaceHolder;
}
#pragma mark - WeChatStylePlaceHolderDelegate Method
- (void)emptyOverlayClicked:(id)sender {

    [self feedOpinionPostRequst];

}

-(NSMutableArray *)listArray
{
    if (!_listArray) {
        _listArray =[NSMutableArray array];
    }
    return _listArray;
}
@end
