//
//  OrderStatisticsViewController.m
//  ZFB
//
//  Created by  展富宝  on 2017/7/27.
//  Copyright © 2017年 com.zfb. All rights reserved.
//  订单统计

#import "OrderStatisticsViewController.h"
//cell
#import "ZFSendingCell.h"//内容
#import "ZFTitleCell.h"//头
#import "ZFFooterCell.h"//尾部
//model
#import "BusinessOrderModel.h"
@interface OrderStatisticsViewController ()<UITableViewDelegate,UITableViewDataSource,CYLTableViewPlaceHolderDelegate, WeChatStylePlaceHolderDelegate>

@property (nonatomic ,strong) UITableView * orderdTableView ;
@property (nonatomic ,strong) UIView *  headView ;
@property (nonatomic ,strong) NSMutableArray *  orderListArray ;


@end

@implementation OrderStatisticsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"订单统计";
    
    
    [self.view addSubview:self.orderdTableView];
    
    [self.orderdTableView registerNib:[UINib nibWithNibName:@"ZFSendingCell" bundle:nil]
                  forCellReuseIdentifier:@"ZFSendingCell"];
    [self.orderdTableView registerNib:[UINib nibWithNibName:@"ZFTitleCell" bundle:nil]
                  forCellReuseIdentifier:@"ZFTitleCell"];
    [self.orderdTableView registerNib:[UINib nibWithNibName:@"ZFFooterCell" bundle:nil]
                  forCellReuseIdentifier:@"ZFFooterCell"];
    
    [self storeHomePagePostRequst];
    
    [self setupRefresh];
}
#pragma mark -数据请求
-(void)headerRefresh {
    
    [super headerRefresh];
    [self storeHomePagePostRequst];

    
}
-(void)footerRefresh {
    [super footerRefresh];
    [self storeHomePagePostRequst];
    
}


-(UIView *)headView
{
    _headView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, KScreenW, 80)];
 
    UILabel * dealNum = [[UILabel alloc]init ];
    UILabel * dealPrice = [[UILabel alloc]init ];
    dealPrice.textColor = HEXCOLOR(0x363636);
    dealNum.textColor = HEXCOLOR(0x363636);
    UIFont  * font = [UIFont systemFontOfSize: 14];
    dealNum.font = font;
    dealPrice.font = font;
 
    dealNum.text = [NSString stringWithFormat:@"交易笔数: %@ 笔",_orderNum];
    dealPrice.text = [NSString stringWithFormat:@"交易金额:%@元",_dealPrice];

    //富文本设置
    //关键字
    dealNum.keywords = _orderNum;
    dealNum.keywordsColor = HEXCOLOR(0xf95a70);
    dealNum.keywordsFont = [UIFont systemFontOfSize:20];
    //关键字
    dealPrice.keywords = _dealPrice;
    dealPrice.keywordsColor = HEXCOLOR(0xf95a70);
    dealPrice.keywordsFont = [UIFont systemFontOfSize:20];
   
    ///必须设置计算宽高
    CGRect dealNumh =  [dealNum getLableHeightWithMaxWidth:300];
    dealNum.frame=CGRectMake(15, 10, dealNumh.size.width, dealNumh.size.height);
    
    CGRect dealPriceh =  [dealPrice getLableHeightWithMaxWidth:300];
    dealPrice.frame=CGRectMake(15, 40, dealPriceh.size.width, dealPriceh.size.height);

    
    //line
    UILabel * line = [[UILabel alloc]initWithFrame:CGRectMake(0, 70, KScreenW, 10)];
    line.backgroundColor = HEXCOLOR(0xf3f3f3);
    
    [_headView addSubview:line] ;
    [_headView addSubview:dealNum];
    [_headView addSubview:dealPrice];
    
    return _headView;
}
-(UITableView *)orderdTableView
{
    if (!_orderdTableView) {
        _orderdTableView =[[ UITableView alloc]initWithFrame:CGRectMake(0, 0, KScreenW, KScreenH -64) style:UITableViewStylePlain];
        _orderdTableView.delegate = self;
        _orderdTableView.dataSource =self;
        _orderdTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _orderdTableView.tableHeaderView = self.headView;
        _orderdTableView.tableHeaderView.height = 80;
    }
    return _orderdTableView;
}


#pragma mark - UITableViewDelegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.orderListArray.count;
 
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    BusinessOrderlist * list = self.orderListArray[section];
    NSMutableArray  * goodsArr = [NSMutableArray array];
   
    for (BusinessOrdergoods  * goods in list.orderGoods) {
        [goodsArr addObject:goods];
    }
    
    return goodsArr.count;
 
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 82;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 50;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 82;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    ZFTitleCell * titleCell = [self.orderdTableView
                               dequeueReusableCellWithIdentifier:@"ZFTitleCell"];
    [titleCell.statusButton setTitle:@"交易完成" forState:UIControlStateNormal];
    BusinessOrderlist * orderlist  = self.orderListArray[section];
    titleCell.businessOrder = orderlist;
    return titleCell;
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    ZFFooterCell * cell = [self.orderdTableView
                           dequeueReusableCellWithIdentifier:@"ZFFooterCell"];
    BusinessOrderlist * orderlist  = self.orderListArray[section];
    cell.businessOrder = orderlist;
    
    [cell.cancel_button removeFromSuperview];
    [cell.payfor_button removeFromSuperview];
    return cell;
    
}

#pragma mark - UITableViewDataSource
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    ZFSendingCell * cell = [self.orderdTableView dequeueReusableCellWithIdentifier:@"ZFSendingCell" forIndexPath:indexPath];
    BusinessOrderlist * list = self.orderListArray[indexPath.section];
    NSMutableArray  * goodsArr = [NSMutableArray array];
    
    for (BusinessOrdergoods  * goods in list.orderGoods) {
        [goodsArr addObject:goods];
    }
    BusinessOrdergoods * goodslist = goodsArr[indexPath.row];
    
    cell.businesGoods = goodslist;
    
    return cell;
}


#pragma mark -  获取统计列表    order/getStoreOrderList
-(void)storeHomePagePostRequst
{

    NSDictionary * param = @{
                             @"page": [NSNumber numberWithInteger:self.currentPage],
                             @"size": [NSNumber numberWithInteger:kPageCount],
                             @"orderStatus": @"3",
                             @"payStatus": @"",
                             @"searchWord":@"",
                             @"startTime": _starTime,
                             @"endTime": _endTime,
                             @"payMode": @"1",
                             @"storeId": _storeId,
                             
                             };
    [SVProgressHUD show];
    [MENetWorkManager post:[NSString stringWithFormat:@"%@/order/getStoreOrderList",zfb_baseUrl] params:param success:^(id response) {
       
        NSString * code = [NSString stringWithFormat:@"%@",response[@"resultCode"]];
        if ([code isEqualToString:@"0"]) {
            BusinessOrderModel * orderModel = [BusinessOrderModel mj_objectWithKeyValues:response];
            
            if (self.refreshType == RefreshTypeHeader) {
                
                if (self.orderListArray.count > 0) {
                    
                    [self.orderListArray removeAllObjects];
                }
                
            }
            for (BusinessOrderlist * orderlist in orderModel.orderList) {
                
                [self.orderListArray addObject:orderlist];
                
            }
            [SVProgressHUD dismiss];
            [self.orderdTableView reloadData];
            
            if ([self isEmptyArray:self.orderListArray]) {
                [self.orderdTableView cyl_reloadData];
            }
        }
      
        
    
        [self endRefresh];

    } progress:^(NSProgress *progeress) {
        
        NSLog(@"progeress=====%@",progeress);
        
    } failure:^(NSError *error) {
        [self endRefresh];
        [SVProgressHUD dismiss];
        NSLog(@"error=====%@",error);
        [self.view makeToast:@"网络错误" duration:2 position:@"center"];
    }];
    
    
}

-(NSMutableArray *)orderListArray
{
    if (!_orderListArray) {
        _orderListArray = [NSMutableArray array];
    }
    return _orderListArray;
}
-(void)viewWillDisappear:(BOOL)animated
{
    [SVProgressHUD dismiss];

}

//既可以让headerView不悬浮在顶部，也可以让footerView不停留在底部。
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    CGFloat sectionHeaderHeight = 80;
    CGFloat sectionFooterHeight = 50;
    CGFloat offsetY = scrollView.contentOffset.y;
    if (offsetY >= 0 && offsetY <= sectionHeaderHeight)
    {
        scrollView.contentInset = UIEdgeInsetsMake(-offsetY, 0, -sectionFooterHeight, 0);
    }else if (offsetY >= sectionHeaderHeight && offsetY <= scrollView.contentSize.height - scrollView.frame.size.height - sectionFooterHeight)
    {
        scrollView.contentInset = UIEdgeInsetsMake(-sectionHeaderHeight, 0, -sectionFooterHeight, 0);
    }else if (offsetY >= scrollView.contentSize.height - scrollView.frame.size.height - sectionFooterHeight && offsetY <= scrollView.contentSize.height - scrollView.frame.size.height)
    {
        scrollView.contentInset = UIEdgeInsetsMake(-offsetY, 0, -(scrollView.contentSize.height - scrollView.frame.size.height - sectionFooterHeight), 0);
    }
}

#pragma mark - CYLTableViewPlaceHolderDelegate Method
- (UIView *)makePlaceHolderView {
    
    UIView *weChatStyle = [self weChatStylePlaceHolder];
    return weChatStyle;
}
//暂无数据
- (UIView *)weChatStylePlaceHolder {
    WeChatStylePlaceHolder *weChatStylePlaceHolder = [[WeChatStylePlaceHolder alloc] initWithFrame:self.orderdTableView.frame];
    weChatStylePlaceHolder.delegate = self;
    return weChatStylePlaceHolder;
}
#pragma mark - WeChatStylePlaceHolderDelegate Method
- (void)emptyOverlayClicked:(id)sender {
    
    [self storeHomePagePostRequst];
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
