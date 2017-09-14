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

typedef NS_ENUM(NSUInteger, SelectType) {
    SelectTypeDefault,//未使用
    SelectTypeAlready,//已使用

};
@interface MineShareViewController () <UITableViewDelegate,UITableViewDataSource,MineShareStatisticsCellDelegate>

@property (strong, nonatomic)  MTSegmentedControl *segumentView;
@property (strong, nonatomic)  UITableView * tableView;
@property (assign, nonatomic)  SelectType selectType;

@end

@implementation MineShareViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
   self.title = @"我的共享";
    [self setupPageView];
    [self.view addSubview:self.tableView];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"MineShareContentCell" bundle:nil] forCellReuseIdentifier:@"MineShareContentCellid"];
    [self.tableView registerNib:[UINib nibWithNibName:@"MineShareStatisticsCell" bundle:nil] forCellReuseIdentifier:@"MineShareStatisticsCellid"];
}

#pragma mark - 懒加载
-(UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 108, KScreenW, KScreenH - 64 - 44 - 50) style:UITableViewStylePlain
                      ];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle =  UITableViewCellSelectionStyleNone;
    }
    return _tableView;
}


- (void)setupPageView {
 
    NSArray *titleArr = @[@"审核中",@"已审核"];
    _segumentView = [[MTSegmentedControl alloc]initWithFrame:CGRectMake(0, 64, KScreenW, 44)];
    [self.segumentView segmentedControl:titleArr Delegate:self];
    [self.view addSubview:_segumentView];
}

#pragma mark - <MTSegmentedControlDelegate>
- (void)segumentSelectionChange:(NSInteger)selection
{
    _selectType = selection ;
    
    switch (_selectType) {
        case SelectTypeDefault://未审核
            
            [self.tableView reloadData];
            break;
        case SelectTypeAlready://已审核
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
            numRow = 2;
            break;
        case SelectTypeAlready://已审核
            if (section == 0) {
              
                return 1;
            }
            numRow = 2;
            break;
    }
    return numRow;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat height = 0;
    switch (_selectType) {
        case SelectTypeDefault://未审核
            height = 84;
            break;
        case SelectTypeAlready://已审核
            if (indexPath.section == 0) {
                
                return 128;
            }
            height = 84;
            break;
    }
    return height;
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
                if (headerView == nil) {
                    headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, KScreenW, 40)];
                    headerView.backgroundColor = [UIColor whiteColor];
                    
                    UILabel * title = [[UILabel alloc]initWithFrame:CGRectMake(15, 0, 200, 39)];
                    title.text = @"最新交易";
                    title.font = [UIFont systemFontOfSize:15];
                    title.textColor = HEXCOLOR(0x363636);
                    [headerView addSubview:title];
                    
                    UILabel * line = [[UILabel alloc]initWithFrame:CGRectMake(0, 39.5, KScreenW, 0.5)];
                    line.backgroundColor = RGBA(244, 244, 244, 1);
                    [headerView addSubview:line];
                }
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
            return contextCell;
        }
             break;
        case SelectTypeAlready://已审核
            if (indexPath.section == 0) {
                
                MineShareStatisticsCell * statcisCell = [self.tableView dequeueReusableCellWithIdentifier:@"MineShareStatisticsCellid" forIndexPath:indexPath];
                statcisCell.shareDelegate = self;
                return statcisCell;
                
            }
            MineShareContentCell * contextCell = [self.tableView dequeueReusableCellWithIdentifier:@"MineShareContentCellid" forIndexPath:indexPath];
            return contextCell;
            break;
    }
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"%ld -  %ld",indexPath.section,indexPath.row);
    
    MineShareDetailViewController * detailVC = [MineShareDetailViewController new];
    [self.navigationController pushViewController:detailVC animated:NO];
    
    switch (_selectType) {
        case SelectTypeDefault://未审核
            
            
            break;
        case SelectTypeAlready://已审核
            if (indexPath.section == 0) {
                
                
            }
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
