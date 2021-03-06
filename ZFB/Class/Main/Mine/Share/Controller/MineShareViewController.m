//
//  MineShareViewController.m
//  ZFB
//
//  Created by  展富宝  on 2017/9/14.
//  Copyright © 2017年 com.zfb. All rights reserved.
//

#import "MineShareViewController.h"
//cell
#import "MineShareContentCell.h"
#import "MineShareStatisticsCell.h"
#import "MTSegmentedControl.h"
//统计VC
#import "MineShareGoodsViewController.h"
#import "MineShareTodayincomeViewController.h"
#import "MineShareAllIncomeViewController.h"
//sub  VC
#import "MineShareDetailViewController.h"

//model
#import "ReviewingModel.h"
#import "CQPlaceholderView.h"

#define cellHeight 100

typedef NS_ENUM(NSUInteger, SelectType) {
    SelectTypeDefault,//未使用
    SelectTypeAlready,//已使用
    
};
@interface MineShareViewController () <UITableViewDelegate,UITableViewDataSource,MineShareStatisticsCellDelegate>
{
    NSString * _generalIncome;//总收入
    NSString * _goodsCount;
    NSString * _todayIncome;//今日收入
    
}
@property (strong, nonatomic)  MTSegmentedControl *segumentView;
@property (strong, nonatomic)  UITableView * tableView;
@property (assign, nonatomic)  SelectType selectType;
@property (strong, nonatomic)  NSMutableArray * reviewingList;//审核中表数组
@property (strong, nonatomic)  NSMutableArray * reviewedList;//已审核表数组
@property (strong, nonatomic)  CQPlaceholderView * _placeHolderView;



@end

@implementation MineShareViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"我的共享";
    [self setupPageView];
    
    self.zfb_tableView = self.tableView;
    [self.view addSubview:self.tableView];
    
    [self setupRefresh];
    [self mineShareListGoodsPost];
}
-(void)viewWillAppear:(BOOL)animated{
    
    [self settingNavBarBgName:@"nav64_gray"];
    
}
-(void)headerRefresh
{
    [super headerRefresh];
    switch (_selectType) {
        case SelectTypeDefault://未审核
            
            [self mineShareListGoodsPost];
            break;
        case SelectTypeAlready://已审核
            [self alreadlymineCheckedListPost];
            
            break;
    }

}
-(void)footerRefresh
{
    [super footerRefresh];
    switch (_selectType) {
        case SelectTypeDefault://未审核
            
            [self mineShareListGoodsPost];
            break;
        case SelectTypeAlready://已审核
            [self alreadlymineCheckedListPost];
            
            break;
    }
}
#pragma mark - 懒加载
-(UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 44, KScreenW, KScreenH  - 44  -64) style:UITableViewStylePlain
                      ];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = HEXCOLOR(0xf7f7f7);
        _tableView.separatorStyle =  UITableViewCellSelectionStyleNone;
    }
    return _tableView;
}

-(NSMutableArray *)reviewingList{
    if (!_reviewingList) {
        _reviewingList =[NSMutableArray array];
    }
    return _reviewingList;
}

-(NSMutableArray *)reviewedList{
    if (!_reviewedList) {
        _reviewedList =[NSMutableArray array];
    }
    return _reviewedList;
}
- (void)setupPageView {
    
    NSArray *titleArr = @[@"未审核",@"已审核"];
    _segumentView = [[MTSegmentedControl alloc]initWithFrame:CGRectMake(0, 0, KScreenW, 44)];
    [self.segumentView segmentedControl:titleArr Delegate:self];
    [self.view addSubview:_segumentView];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"MineShareContentCell" bundle:nil] forCellReuseIdentifier:@"MineShareContentCellid"];
    [self.tableView registerNib:[UINib nibWithNibName:@"MineShareStatisticsCell" bundle:nil] forCellReuseIdentifier:@"MineShareStatisticsCellid"];
}

#pragma mark - <MTSegmentedControlDelegate>  判断是点击的那个板块
- (void)segumentSelectionChange:(NSInteger)selection
{
    _selectType = selection ;
    
    switch (_selectType) {
        case SelectTypeDefault://未审核
            [self mineShareListGoodsPost];

            [self.tableView reloadData];
            break;
        case SelectTypeAlready://已审核
            
            [self alreadlymineCheckedListPost];
            [self.tableView reloadData];
            
            break;
            
    }
}

#pragma mark - <UITableViewDataSource>
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    NSInteger numSection = 0;
    switch (_selectType) {
        case SelectTypeDefault://未审核
            numSection = 1;
            break;
        case SelectTypeAlready://已审核
            
            numSection = 2;
            break;
    }
    
    return numSection;
    
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger numRow = 0;
    switch (_selectType) {
        case SelectTypeDefault://未审核
            numRow = self.reviewingList.count;
            break;
        case SelectTypeAlready://已审核
            if (section == 0) {
                return 1;
            }
            numRow = self.reviewedList.count;
            break;
    }
    return numRow;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat height = 0;
    switch (_selectType) {
        case SelectTypeDefault://未审核
            height = cellHeight;
            break;
        case SelectTypeAlready://已审核
            if (indexPath.section == 0) {
                
                return 128;
            }
            height = cellHeight;
            break;
    }
    return height;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    CGFloat sectionRow = 0.0;
    switch (_selectType) {
        case SelectTypeDefault://未审核
            sectionRow = 0;
            break;
        case SelectTypeAlready://已审核
            if (section == 1) {
                sectionRow = 40;
            }
            else{
                sectionRow = 0.0;
            }
            break;
    }
    return sectionRow;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView * headerView = nil;
    
    switch (_selectType) {
        case SelectTypeDefault://未审核
            
            break;
        case SelectTypeAlready://已审核
        {
            if (section == 1) {
                    headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, KScreenW, 40)];
                    headerView.backgroundColor = [UIColor clearColor];
                    
                    UILabel * title = [[UILabel alloc]initWithFrame:CGRectMake(15, 0, 200, 39)];
                    title.text = @"最新交易";
                    title.font = [UIFont systemFontOfSize:15];
                    title.textColor = HEXCOLOR(0x333333);
                    [headerView addSubview:title];
            }
        }
            break;
    }
    return headerView;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (_selectType) {
        case SelectTypeDefault://未审核
        {
            MineShareContentCell * contextCell =[self.tableView dequeueReusableCellWithIdentifier:@"MineShareContentCellid" forIndexPath:indexPath];
            ReViewData * data = self.reviewingList[indexPath.row];
            contextCell.reviewingList = data;
            return contextCell;
        }
            break;
        case SelectTypeAlready://已审核
            if (indexPath.section == 0) {
                
                MineShareStatisticsCell * statcisCell = [self.tableView dequeueReusableCellWithIdentifier:@"MineShareStatisticsCellid" forIndexPath:indexPath];
                statcisCell.shareDelegate = self;
                statcisCell.lb_goodsnum.text = [NSString stringWithFormat:@"商品数:%@",_goodsCount];
                statcisCell.lb_todayIncome.text = [NSString stringWithFormat:@"今日收入:%@元", _todayIncome];
                statcisCell.lb_allIncome.text = [NSString stringWithFormat:@"总收入:%@元",_generalIncome];
                return statcisCell;
                
            }
            MineShareContentCell * contextCell = [self.tableView dequeueReusableCellWithIdentifier:@"MineShareContentCellid" forIndexPath:indexPath];
            ReViewData * data = self.reviewedList[indexPath.row];
            contextCell.reviewedData = data;
            
            return contextCell;
            break;
    }
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"%ld -  %ld",indexPath.section,indexPath.row);
    switch (_selectType) {
        case SelectTypeDefault://未审核
        {
            MineShareDetailViewController * detailVC = [MineShareDetailViewController new];
            ReViewData * data = self.reviewingList[indexPath.row];
            detailVC.goodsId = data.goodsId;
            [self.navigationController pushViewController:detailVC animated:NO];
        }
            break;
        case SelectTypeAlready://已审核
 
            break;
    }
}

#pragma mark - MineShareStatisticsCellDelegate 统计代理
//统计全部收入
-(void)didClickAllincomeView
{
    MineShareAllIncomeViewController * allVC = [MineShareAllIncomeViewController new];
    [self.navigationController pushViewController:allVC animated:NO];
    
}
//统计商品
-(void)didClickgoodsNumView{
    
    MineShareGoodsViewController * goodsVC = [MineShareGoodsViewController new];
    [self.navigationController pushViewController:goodsVC animated:NO];
}
//统计今日收入
-(void)didClicktodayIncomeView
{
    MineShareTodayincomeViewController * todayVC = [MineShareTodayincomeViewController new];
    [self.navigationController pushViewController:todayVC animated:NO];
}



#pragma mark  - 审核中   myShare/unCheckedList
-(void)mineShareListGoodsPost
{
    NSDictionary * parma = @{
                             @"userId":BBUserDefault.cmUserId,
                             @"pageIndex":[NSNumber numberWithInteger:self.currentPage],
                             @"pageSize":[NSNumber numberWithInteger:kPageCount],
                             };
    [SVProgressHUD show];
    [MENetWorkManager post:[zfb_baseUrl stringByAppendingString:@"/myShare/unCheckedList"] params:parma success:^(id response) {
        if ([response[@"resultCode"] isEqualToString:@"0"] ) {
          
            [SVProgressHUD dismiss];
            if (self.refreshType == RefreshTypeHeader) {
                if (self.reviewingList.count > 0) {
                    [self.reviewingList removeAllObjects];
                }
            }
            ReviewingModel * review =[ ReviewingModel mj_objectWithKeyValues:response];
            for (ReViewData * reviewData in review.data) {
                
                [self.reviewingList addObject:reviewData];
            }
            [self.tableView reloadData];

//            if ([self isEmptyArray:self.reviewingList]) {
//                [self.tableView cyl_reloadData];
//                [SVProgressHUD dismiss];
//            }
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


#pragma mark  - 已审核列表   myShare/checkedList
-(void)alreadlymineCheckedListPost
{
    NSDictionary * parma = @{
                             @"userId":BBUserDefault.cmUserId,
                             @"pageIndex":[NSNumber numberWithInteger:self.currentPage],
                             @"pageSize":[NSNumber numberWithInteger:kPageCount],
                             };
    [SVProgressHUD show];
    [MENetWorkManager post:[zfb_baseUrl stringByAppendingString:@"/myShare/checkedList"] params:parma success:^(id response) {
        if ([response[@"resultCode"] isEqualToString:@"0"] ) {
            [SVProgressHUD dismiss];

            if (self.refreshType == RefreshTypeHeader) {

                if (self.reviewedList.count > 0) {
                    [self.reviewedList removeAllObjects];
                }
            }
            ReviewingModel * review = [ReviewingModel mj_objectWithKeyValues:response];
            for (ReViewData * reviewData in review.data) {
                
                [self.reviewedList addObject:reviewData];
            }
            _generalIncome = review.generalIncome;
            _goodsCount = review.goodsCount;
            _todayIncome = review.todayIncome;
            [self.tableView reloadData];
 
        }
        [self endRefresh];

    } progress:^(NSProgress *progeress) {
        
    } failure:^(NSError *error) {
        [SVProgressHUD dismiss];
        [self endRefresh];
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
