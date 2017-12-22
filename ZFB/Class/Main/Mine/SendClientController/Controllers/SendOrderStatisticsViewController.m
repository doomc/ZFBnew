
//
//  SendOrderStatisticsViewController.m
//  ZFB
//
//  Created by  展富宝  on 2017/8/2.
//  Copyright © 2017年 com.zfb. All rights reserved.
//

#import "SendOrderStatisticsViewController.h"

//cell
#import "ZFSendingCell.h"//内容
#import "SendServiceTitleCell.h"//头
#import "ZFFooterCell.h"//尾部
#import "SendStatisticsTitleView.h"
//model
#import "SendServiceOrderModel.h"
#import "ZFDetailOrderViewController.h"


@interface SendOrderStatisticsViewController ()<UITableViewDelegate,UITableViewDataSource,CYLTableViewPlaceHolderDelegate, WeChatStylePlaceHolderDelegate>

@property (nonatomic ,strong) UITableView * orderdTableView ;
@property (nonatomic ,strong) UIView *  headView ;
@property (nonatomic ,strong) NSMutableArray *  orderListArray ;


@end

@implementation SendOrderStatisticsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"订单统计";
    
    
    [self.view addSubview:self.orderdTableView];
    
    [self.orderdTableView registerNib:[UINib nibWithNibName:@"ZFSendingCell" bundle:nil]
               forCellReuseIdentifier:@"ZFSendingCell"];
    [self.orderdTableView registerNib:[UINib nibWithNibName:@"SendServiceTitleCell" bundle:nil]
               forCellReuseIdentifier:@"SendServiceTitleCell"];
    [self.orderdTableView registerNib:[UINib nibWithNibName:@"ZFFooterCell" bundle:nil]
               forCellReuseIdentifier:@"ZFFooterCell"];
    [self.orderdTableView registerNib:[UINib nibWithNibName:@"SendStatisticsTitleCell" bundle:nil]
               forCellReuseIdentifier:@"SendStatisticsTitleCell"];
    
    [self getOrderPostRequst];
    
}
-(UIView *)headView
{
    _headView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, KScreenW, 100)];

    SendStatisticsTitleView * head = [[SendStatisticsTitleView alloc]initWithHeadViewFrame:_headView.frame];
    head.lb_orderCount.text = _orderNum;
    head.lb_orderPrice.text = _dealPrice;
    [_headView addSubview:head];
 
    return _headView;
}
-(UITableView *)orderdTableView
{
    if (!_orderdTableView) {
        _orderdTableView =[[ UITableView alloc]initWithFrame:CGRectMake(0, 0, KScreenW, KScreenH - 64) style:UITableViewStylePlain];
        _orderdTableView.delegate = self;
        _orderdTableView.dataSource =self;
        _orderdTableView.estimatedRowHeight = 0;
        _orderdTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _orderdTableView.tableHeaderView = self.headView;
        _orderdTableView.tableHeaderView.height = 100;
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
    NSMutableArray *  goodsArr  = [NSMutableArray array];
    SendServiceStoreinfomap * store = self.orderListArray[section];
    for (SendServiceOrdergoodslist  * goods in store.orderGoodsList) {
        [goodsArr addObject:goods];
    }
    return goodsArr.count;
 
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 41;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 60;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 118;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    SendServiceTitleCell * titleCell = [self.orderdTableView
                               dequeueReusableCellWithIdentifier:@"SendServiceTitleCell"];
  
    SendServiceStoreinfomap* storeInfo = self.orderListArray[section];
    titleCell.storlist = storeInfo ;
    if ( storeInfo.orderStatus == 3) {
        [titleCell.statusButton setTitle:@"交易完成" forState:UIControlStateNormal];
    }
    return titleCell;
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    ZFFooterCell * cell = [self.orderdTableView
                           dequeueReusableCellWithIdentifier:@"ZFFooterCell"];
    SendServiceStoreinfomap * store  = self.orderListArray[section];
    cell.sendOrder = store;
    
    [cell.cancel_button removeFromSuperview];
    [cell.payfor_button removeFromSuperview];
    return cell;
    
}

#pragma mark - UITableViewDataSource
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ZFSendingCell * cell = [self.orderdTableView dequeueReusableCellWithIdentifier:@"ZFSendingCell" forIndexPath:indexPath];
    if (self.orderListArray.count > 0) {
        NSMutableArray *  goodsArr  = [NSMutableArray array];
        SendServiceStoreinfomap * store = self.orderListArray[indexPath.section];
        for (SendServiceOrdergoodslist  * goods in store.orderGoodsList) {
            [goodsArr addObject:goods];
        }
        
        SendServiceOrdergoodslist * goodslist = goodsArr[indexPath.row];
        cell.sendGoods = goodslist;
    }
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    ZFDetailOrderViewController * detailVc =[[ ZFDetailOrderViewController alloc]init];
    if (self.orderListArray.count > 0) {
        SendServiceStoreinfomap * store = self.orderListArray[indexPath.section];
        NSMutableArray *  goodsArr  = [NSMutableArray array];
        for (SendServiceOrdergoodslist  * goods in store.orderGoodsList) {
            [goodsArr addObject:goods];
        }
        SendServiceOrdergoodslist * goodslist = goodsArr[indexPath.row];
        detailVc.cmOrderid = [NSString stringWithFormat:@"%ld",goodslist.orderId];
        detailVc.storeId = [NSString stringWithFormat:@"%ld",goodslist.storeId];
        detailVc.goodsId = [NSString stringWithFormat:@"%ld",goodslist.goodsId];
        detailVc.imageUrl = goodslist.coverImgUrl;
        detailVc.isUserType = 2;// 3 是用户 1 是商户 2 是配送
    }
    [self.navigationController pushViewController:detailVc animated:YES];
}

#pragma mark -  获取统计列表  getOrderDeliveryByDeliveryId
-(void)getOrderPostRequst
{
//    deliveryId	int(11)	配送员id
//    orderStartTime	string	配送开始的结束订单时间
//    orderEndTime	string	配送结束的结束订单时间
//    status	int(11)	接单状态
    NSDictionary * param = @{
                             @"deliveryId": _deliveryId,
                             @"status": @"4",
                             @"orderStartTime": _orderStartTime,
                             @"orderEndTime": _orderEndTime,
                             
                             };
    
    [MENetWorkManager post:[NSString stringWithFormat:@"%@/getOrderDeliveryByDeliveryId",zfb_baseUrl] params:param success:^(id response) {
        
        NSString * code = [NSString stringWithFormat:@"%@",response[@"resultCode"]];
        if ([code isEqualToString:@"0"]) {
            
            if (self.orderListArray.count > 0) {
                
                [self.orderListArray  removeAllObjects];
            }
            SendServiceOrderModel * orderModel = [SendServiceOrderModel mj_objectWithKeyValues:response];
            
            for (SendServiceStoreinfomap * orderlist in orderModel.storeInfoMap) {
                
                [self.orderListArray addObject:orderlist];
                
            }
            [self.orderdTableView reloadData];
            
            if ([self isEmptyArray:self.orderListArray]) {
                
                [self.orderdTableView cyl_reloadData];
            }
   
        }
        else{
            [SVProgressHUD dismiss];
            [self.view makeToast:response[@"resultMsg"] duration:2 position:@"center"];
        }

    } progress:^(NSProgress *progeress) {
    } failure:^(NSError *error) {
        
        NSLog(@"error=====%@",error);
        [self.view makeToast:@"网络错误" duration:2 position:@"center"];
    }];
    
    
}

-(void)viewWillAppear:(BOOL)animated
{   //网络请求

    [self settingNavBarBgName:@"nav64_gray"];

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
    
    [self getOrderPostRequst];
}

-(NSMutableArray *)orderListArray
{
    if (!_orderListArray) {
        _orderListArray = [NSMutableArray array];
    }
    return _orderListArray;
}
//既可以让headerView不悬浮在顶部，也可以让footerView不停留在底部。
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    CGFloat sectionHeaderHeight = 50 ;
    CGFloat sectionFooterHeight = 60;
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


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
