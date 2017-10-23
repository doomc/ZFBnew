//
//  MineShareGoodsViewController.m
//  ZFB
//
//  Created by  展富宝  on 2017/9/14.
//  Copyright © 2017年 com.zfb. All rights reserved.
//  我的共享商品数量

#import "MineShareGoodsViewController.h"
#import "MineShareContentCell.h"

@interface MineShareGoodsViewController ()<UITableViewDelegate,UITableViewDataSource,CYLTableViewPlaceHolderDelegate,WeChatStylePlaceHolderDelegate>

@property (strong, nonatomic)  UITableView * tableView;
@property (strong, nonatomic)  NSMutableArray * goodsList;

@end

@implementation MineShareGoodsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"我的共享";

    [self.view addSubview:self.tableView];

    self.zfb_tableView = self.tableView;
    
    [self.tableView registerNib:[UINib nibWithNibName:@"MineShareContentCell" bundle:nil] forCellReuseIdentifier:@"MineShareContentCellid"];
    
    [self goodsListGoodsPost];
    [self setupRefresh];
}

#pragma mark - 懒加载
-(UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, KScreenW, KScreenH ) style:UITableViewStylePlain
                      ];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle =  UITableViewCellSelectionStyleNone;
    }
    return _tableView;
}
-(NSMutableArray *)goodsList{
    if (!_goodsList) {
        _goodsList = [NSMutableArray array];
    }
    return _goodsList;
}

-(void)footerRefresh
{
    [super footerRefresh];
    [self goodsListGoodsPost];
}
-(void)headerRefresh
{
    [super headerRefresh];
    [self goodsListGoodsPost];

}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.goodsList.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 84;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MineShareContentCell * cell = [self.tableView dequeueReusableCellWithIdentifier:@"MineShareContentCellid" forIndexPath:indexPath];
    ReViewData * goodslist = self.goodsList[indexPath.row];
    cell.goodsReviewData = goodslist;
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

#pragma mark  - 我的共享列表    myShare/allShareOrderList
-(void)goodsListGoodsPost
{
    NSDictionary * parma = @{
                             @"userId":BBUserDefault.cmUserId,
                             @"pageIndex":[NSNumber numberWithInteger:self.currentPage],
                             @"pageSize":[NSNumber numberWithInteger:kPageCount],
                             };
    [SVProgressHUD show];
    [MENetWorkManager post:[zfb_baseUrl stringByAppendingString:@"/myShare/shareGoodsList"] params:parma success:^(id response) {
        if ([response[@"resultCode"] isEqualToString:@"0"] ) {
            
            if (self.refreshType == RefreshTypeHeader) {
                if (self.goodsList.count > 0) {
                    [self.goodsList removeAllObjects];
                }
            }
            ReviewingModel * review =[ ReviewingModel mj_objectWithKeyValues:response];
            for (ReViewData * reviewData in review.data) {
                [self.goodsList addObject:reviewData];
            }
            [self.tableView reloadData];
            [SVProgressHUD dismiss];
            
            if ([self isEmptyArray:self.goodsList]) {
                [self.tableView cyl_reloadData];
                [SVProgressHUD dismiss];
            }
        }
        [self endRefresh];

    } progress:^(NSProgress *progeress) {
        
    } failure:^(NSError *error) {
        [self endRefresh];
        [SVProgressHUD dismiss];
        NSLog(@"error=====%@",error);
        [self.view makeToast:@"网络错误" duration:2 position:@"center"];
    }];
}

#pragma mark - CYLTableViewPlaceHolderDelegate Method
- (UIView *)makePlaceHolderView {
    
    UIView *weChatStyle = [self weChatStylePlaceHolder];
    return weChatStyle;
}

//暂无数据
- (UIView *)weChatStylePlaceHolder {
    WeChatStylePlaceHolder *weChatStylePlaceHolder = [[WeChatStylePlaceHolder alloc] initWithFrame:self.tableView.frame];
    weChatStylePlaceHolder.delegate = self;
    return weChatStylePlaceHolder;
}
#pragma mark - WeChatStylePlaceHolderDelegate Method
- (void)emptyOverlayClicked:(id)sender {
    [self goodsListGoodsPost];
    
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
