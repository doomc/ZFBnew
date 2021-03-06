//
//  MineShareAllIncomeViewController.m
//  ZFB
//
//  Created by  展富宝  on 2017/9/14.
//  Copyright © 2017年 com.zfb. All rights reserved.
//  总收入

#import "MineShareAllIncomeViewController.h"
#import "MineShareIncomeCell.h"
#import "ReviewingModel.h"
#import "BandSelecteView.h"
#define  k_cellHeight 210

@interface MineShareAllIncomeViewController () <UITableViewDelegate,UITableViewDataSource,CYLTableViewPlaceHolderDelegate,WeChatStylePlaceHolderDelegate>


@property (strong, nonatomic)  UITableView * tableView;
@property (strong, nonatomic)  UIButton * edit_btn;
@property (strong, nonatomic)  NSMutableArray * orderList;
@property (strong, nonatomic)  NSArray * titles;

@end

@implementation MineShareAllIncomeViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"分享佣金";
    //0.全部 1.一个月前 2.一月前到三个月前 3.三个月前到六个月前 4.六个月前到一年前 5一年以前
    _titles = @[@"全部",@"一个月前",@"一月前到三个月",@"三个月前",@"六个月前",@"一年以前"];
    [self.view addSubview:self.tableView];
    self.zfb_tableView = self.tableView;
    [self.tableView registerNib:[UINib nibWithNibName:@"MineShareIncomeCell" bundle:nil] forCellReuseIdentifier:@"MineShareIncomeCellid"];
    
    [self setupRefresh];
    [self allOrderListGoodsPostAthistory:@"0"];
}

-(void)footerRefresh
{
    [super footerRefresh];
    [self allOrderListGoodsPostAthistory:@"0"];

}
-(void)headerRefresh
{
    [super headerRefresh];
    [self allOrderListGoodsPostAthistory:@"0"];

}
-(NSMutableArray *)orderList{
    if (!_orderList) {
        _orderList = [NSMutableArray array];
    }
    return _orderList;
}
////设置右边按键（如果没有右边 可以不重写）
//-(UIButton*)set_rightButton
//{
//     _edit_btn = [[UIButton alloc]init];
//    [_edit_btn setImage:[UIImage imageNamed:@"time"]  forState:UIControlStateNormal];
//     _edit_btn.titleLabel.textAlignment = NSTextAlignmentRight;
//    _edit_btn.frame =CGRectMake(0, 0, 22, 22);
//    [_edit_btn addTarget:self action:@selector(didClickEditing:) forControlEvents:UIControlEventTouchUpInside];
//    return _edit_btn;
//}

#pragma mark - 懒加载
-(UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, KScreenW, KScreenH- 64) style:UITableViewStylePlain
                      ];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.estimatedRowHeight = 0;
        _tableView.backgroundColor = HEXCOLOR(0xf7f7f7);
        _tableView.separatorStyle =  UITableViewCellSelectionStyleNone;
    }
    return _tableView;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.orderList.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return k_cellHeight;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ReViewData * alldata  = self.orderList[indexPath.row];
    
    MineShareIncomeCell * cell = [self.tableView dequeueReusableCellWithIdentifier:@"MineShareIncomeCellid" forIndexPath:indexPath];
    cell.allReviewData = alldata;
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

#pragma mark - 筛选时间
-(void)didClickEditing:(UIButton *) editing
{
    NSLog(@"%@",editing);
//    BandSelecteView * popView = [[BandSelecteView alloc]initWithBandSelecteViewFrame:CGRectMake(0, 50, KScreenW, 210+50)];
//    popView.delegate = self;
//    popView.brandListArray = _titles;
//    [self.view addSubview:popView];
}

#pragma mark  - 我的共享列表    myShare/allShareOrderList
-(void)allOrderListGoodsPostAthistory:(NSString *)history
{
    NSDictionary * parma = @{
                             @"history":history,//0.全部 1.一个月前 2.一月前到三个月前 3.三个月前到六个月前 4.六个月前到一年前 5一年以前
                             @"userId":BBUserDefault.cmUserId,
                             @"pageIndex":[NSNumber numberWithInteger:self.currentPage],
                             @"pageSize":[NSNumber numberWithInteger:kPageCount],
                             };
    [SVProgressHUD show];
    [MENetWorkManager post:[zfb_baseUrl stringByAppendingString:@"/myShare/allShareOrderList"] params:parma success:^(id response) {
        if ([response[@"resultCode"] isEqualToString:@"0"] ) {
            
            if (self.refreshType == RefreshTypeHeader) {
                if (self.orderList.count > 0) {
                    [self.orderList removeAllObjects];
                }
            }
            ReviewingModel * review =[ ReviewingModel mj_objectWithKeyValues:response];
            for (ReViewData * reviewData in review.data) {
                
                [self.orderList addObject:reviewData];
            }
            [self endRefresh];
            [self.tableView reloadData];
            [SVProgressHUD dismiss];
            if ([self isEmptyArray:self.orderList]) {
                [self.tableView cyl_reloadData];
                [SVProgressHUD dismiss];
            }
        }
        
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
