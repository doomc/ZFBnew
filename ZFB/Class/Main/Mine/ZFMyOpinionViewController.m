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
#import "JZLPhotoBrowser.h"

@interface ZFMyOpinionViewController () <UITableViewDataSource,UITableViewDelegate,ZFMyOpinionCellDelegate,UIGestureRecognizerDelegate>

@property(nonatomic,strong)UITableView  * tableView;
@property(nonatomic,strong)NSMutableArray * listArray;
@end

@implementation ZFMyOpinionViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.zfb_tableView = self.tableView;
    [self.view addSubview:self.tableView];
    [self.tableView registerNib:[UINib nibWithNibName:@"ZFMyOpinionCell" bundle:nil] forCellReuseIdentifier:@"ZFMyOpinionCell"];
    [self setupRefresh];
}
    
-(void)footerRefresh{
    [super footerRefresh];
    [self feedOpinionPostRequst];
}
    
-(void)headerRefresh
{
    [super headerRefresh];
    [self feedOpinionPostRequst];

}



-(UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, KScreenW, KScreenH -104) style:UITableViewStylePlain];
        _tableView.dataSource =self;
        _tableView.delegate= self;
        _tableView.estimatedRowHeight = 0;
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
    height = [tableView fd_heightForCellWithIdentifier:@"ZFMyOpinionCell" configuration:^(id cell) {
        [self configCell:cell indexPath:indexPath];

    }];
    return height;
}


-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return 10;
}
    
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ZFMyOpinionCell *opinionCell = [self.tableView  dequeueReusableCellWithIdentifier:@"ZFMyOpinionCell" forIndexPath:indexPath];
   
    [self configCell:opinionCell indexPath:indexPath];

    return opinionCell;
    
}
    
-(void)configCell:(ZFMyOpinionCell *)cell indexPath:(NSIndexPath *)indexPath
{
    if (self.listArray.count > 0) {
        cell.delegate = self;
        Feedbacklist * list = self.listArray[indexPath.section];
        cell.feedList = list;
        [cell.feedCollectionView reloadData];
     }
}



#pragma mark - 意见反馈列表 -getFeedbackINfoByUserId
-(void)feedOpinionPostRequst
{
    NSDictionary * parma = @{
                             @"cmUserId":BBUserDefault.cmUserId,
                             @"page":[NSNumber numberWithInteger:self.currentPage],
                             @"size":[NSNumber numberWithInteger:kPageCount],
                             };
    
    [SVProgressHUD show];
    [MENetWorkManager post:[zfb_baseUrl stringByAppendingString:@"/getFeedbackINfoByUserId"] params:parma success:^(id response) {
        NSString * code = [NSString stringWithFormat:@"%@",response[@"resultCode"] ];
        if ([code isEqualToString:@"0"]) {
            if (self.refreshType == RefreshTypeHeader) {
                if (self.listArray.count > 0) {
                    
                    [self.listArray removeAllObjects];
                }
            }
 
            UserFeedbackModel * feedModel = [UserFeedbackModel mj_objectWithKeyValues:response];
            for (Feedbacklist * list in feedModel.feedbackList) {
                [self.listArray addObject:list];
            }
            
            [self.tableView reloadData];
//            if ([self isEmptyArray:self.listArray]) {
//                [self.tableView cyl_reloadData];
//            }
            [SVProgressHUD dismiss];

        }
        [self endRefresh];
    } progress:^(NSProgress *progeress) {
        
    } failure:^(NSError *error) {
        [self endRefresh];
        [SVProgressHUD dismiss];
        [self.view makeToast:@"网络错误" duration:2 position:@"center"];
    }];
    
}


-(void)viewWillAppear:(BOOL)animated
{
    [self feedOpinionPostRequst];

}
-(void)viewWillDisappear:(BOOL)animated
{
    [SVProgressHUD dismiss];
}


-(NSMutableArray *)listArray
{
    if (!_listArray) {
        _listArray =[NSMutableArray array];
    }
    return _listArray;
}


#pragma mark - ZFMyOpinionCellDelegate
-(void)didclickPhotoPicker:(NSInteger )index images:(NSArray *)images{
    
    [JZLPhotoBrowser showPhotoBrowserWithUrlArr:images currentIndex:index originalImageViewArr:nil];
    
}




@end
