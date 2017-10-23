//
//  ShareNewgoodsViewController.m
//  ZFB
//
//  Created by  展富宝  on 2017/9/12.
//  Copyright © 2017年 com.zfb. All rights reserved.
//  新品推荐

#import "ShareNewgoodsViewController.h"
#import "ShareNewGoodsCell.h"
#import "ShareCommendModel.h"
#import "ShareRecommedDetailViewController.h"

@interface ShareNewgoodsViewController ()<UITableViewDelegate,UITableViewDataSource,ShareNewGoodsCellDelegate>

@property (nonatomic , strong) NSMutableArray * commendList;
@property (nonatomic , copy) NSString * isThumbed;
@property (nonatomic , copy) NSString * recommentId;

@property (nonatomic, strong) Recommentlist *currentList;
@end

@implementation ShareNewgoodsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self initTableView];

    [self setupRefresh];
    
    [self recommentPostRequst];
    
    
}
-(void)headerRefresh{
    [super headerRefresh];
    [self recommentPostRequst];
    
}
-(void)footerRefresh
{
    [super footerRefresh];
    [self recommentPostRequst];
}

-(void)initTableView
{
    self.zfb_tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, KScreenW, KScreenH  -50 -44) style:UITableViewStylePlain];
    self.zfb_tableView.delegate = self;
    self.zfb_tableView.dataSource = self;
    self.zfb_tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.zfb_tableView];

    [self.zfb_tableView registerNib:[UINib nibWithNibName:@"ShareNewGoodsCell" bundle:nil] forCellReuseIdentifier:@"ShareNewGoodsCellid"];
}

-(NSMutableArray *)commendList{
    if (!_commendList) {
        _commendList  = [NSMutableArray array];
    }
    return _commendList;
}

#pragma mark - UITableViewDataSource ,UITableViewDelegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.commendList.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return [tableView fd_heightForCellWithIdentifier:@"ShareNewGoodsCellid" configuration:^(id cell) {
        
        [self configCell:cell indexPath:indexPath];

    }];
 
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ShareNewGoodsCell * goodCell = [self.zfb_tableView dequeueReusableCellWithIdentifier:@"ShareNewGoodsCellid" forIndexPath:indexPath];
    [self configCell:goodCell indexPath:indexPath];
    
    return goodCell;
}
//组装cell
-(void)configCell:(ShareNewGoodsCell *)cell indexPath:(NSIndexPath *)indexPath
{
    Recommentlist * list = self.commendList[indexPath.row];
    cell.recommend = list;
    cell.delegate = self;
    cell.indexRow = indexPath.row;
    cell.isThumbed = _isThumbed;
    
}


#pragma -mark   ShareNewGoodsCellDelegate 新品推荐代理
-(void)didClickZanAtIndex:(NSInteger)index
{
    NSLog(@"_indexx --- %ld",index);
    
    Recommentlist * list = self.commendList[index];
    _currentList = list;
    NSString *thumsId =  [NSString stringWithFormat:@"%ld", list.recommentId];
    if (list.isThumbed == 0) {
        if ([BBUserDefault.cmUserId isEqualToString:@""]||[BBUserDefault.cmUserId isEqualToString:@"0"] ||BBUserDefault.cmUserId ==nil) {
            [self isIfNotSignIn];
            
        }else{
            [self didclickZanPostRequsetAtthumsId:thumsId];
 
        }
        
    }else{
        [self.view makeToast:@"您已经点过赞了" duration:2 position:@"center"];
        
    }
}
-(void)didClickPictureDetailAtIndex:(NSInteger)index
{
    Recommentlist * list = self.commendList[index];
    ShareRecommedDetailViewController * detailVC = [ShareRecommedDetailViewController new];
    detailVC.recommentId = [NSString stringWithFormat:@"%ld",list.recommentId];
    [self.navigationController pushViewController:detailVC animated:NO];
}

#pragma mark -  获取新品推荐列表  recomment/recommentList
-(void)recommentPostRequst
{
    NSString * userId =  [NSString stringWithFormat:@"%@",BBUserDefault.cmUserId];
    if ([userId isEqualToString:@""] || userId == nil) {
        userId = @"0";
    }
    NSDictionary * parma = @{
                             @"userId":userId,
                             @"pageIndex":[NSNumber numberWithInteger:self.currentPage],
                             @"pageSize":[NSNumber numberWithInteger:kPageCount],
                             };
    [SVProgressHUD show];
    [MENetWorkManager post:[zfb_baseUrl stringByAppendingString:@"/recomment/recommentList"] params:parma success:^(id response) {
       
        NSString * code = [NSString stringWithFormat:@"%@",response[@"resultCode"] ];
        if ([code isEqualToString:@"0"]) {
            if (self.refreshType == RefreshTypeHeader) {
                if (self.commendList.count > 0) {
                    [self.commendList removeAllObjects];
                }
            }
            ShareCommendModel * commend = [ShareCommendModel mj_objectWithKeyValues:response];
            for (Recommentlist * list in commend.recommentList) {
    
                [self.commendList addObject:list];
            }
            [SVProgressHUD dismiss];
            [self endRefresh];
            [self.zfb_tableView reloadData];
        }
    } progress:^(NSProgress *progeress) {
        
    } failure:^(NSError *error) {
        [self endRefresh];
        [SVProgressHUD dismiss];
        NSLog(@"error=====%@",error);
        [self.view makeToast:@"网络错误" duration:2 position:@"center"];
    }];
}


#pragma mark  - 点赞请求 newrecomment/toLike
-(void)didclickZanPostRequsetAtthumsId:(NSString *)thumsId
{
    NSDictionary * parma = @{
                             @"userId":BBUserDefault.cmUserId,
                             @"thumsId":thumsId,//分享编号，新品推荐编号
                             @"type":@"0",//0 新品推荐 1 分享
                             };
    [MENetWorkManager post:[zfb_baseUrl stringByAppendingString:@"/newrecomment/toLike"] params:parma success:^(id response) {
        if ([response[@"resultCode"] isEqualToString:@"0"] ) {
            
            _currentList.isThumbed = 1;
            _currentList.thumbs += 1;
            [self.zfb_tableView reloadData];
        }
    } progress:^(NSProgress *progeress) {
        
    } failure:^(NSError *error) {
        
        [SVProgressHUD dismiss];
        NSLog(@"error=====%@",error);
        [self.view makeToast:@"网络错误" duration:2 position:@"center"];
    }];
}




-(void)viewWillDisappear:(BOOL)animated{
    
    [SVProgressHUD dismiss];
    
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
