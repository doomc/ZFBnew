
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
//model
#import "SendServiceOrderModel.h"


@interface SendOrderStatisticsViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic ,strong) UITableView * orderdTableView ;
@property (nonatomic ,strong) UIView *  headView ;
@property (nonatomic ,strong) NSMutableArray *  orderListArray ;
@property (nonatomic ,strong) NSMutableArray *  orderGoodsArry ;

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
    
    dealNum.text = [NSString stringWithFormat:@"交易笔数: 56 笔"];
    dealPrice.text = [NSString stringWithFormat:@"交易金额:230012.00元"];
    
    //富文本设置
    //关键字
    dealNum.keywords = @"56";
    dealNum.keywordsColor = HEXCOLOR(0xfe6d6a);
    dealNum.keywordsFont = [UIFont systemFontOfSize:20];
    //关键字
    dealPrice.keywords = @"230012.00";
    dealPrice.keywordsColor = HEXCOLOR(0xfe6d6a);
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
        _orderdTableView =[[ UITableView alloc]initWithFrame:CGRectMake(0, 64, KScreenW, KScreenH-64) style:UITableViewStylePlain];
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
    //    return self.orderListArray.count;
    return 2;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    //    return self.orderGoodsArry.count;
    
    return 2;
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
    SendServiceTitleCell * titleCell = [self.orderdTableView
                               dequeueReusableCellWithIdentifier:@"ZFTitleCell"];
  
    SendServiceStoreinfomap* storeInfo = self.orderListArray[section];
    titleCell.storlist = storeInfo ;
    
 
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
    
    SendServiceOrdergoodslist * goodslist = self.orderGoodsArry[indexPath.row];
    cell.sendGoods = goodslist;
    
    return cell;
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
                             @"status": @"3",
                             @"orderStartTime": _orderStartTime,
                             @"orderEndTime": _orderEndTime,
                             
                             };
    
    [MENetWorkManager post:[NSString stringWithFormat:@"%@/getOrderDeliveryByDeliveryId",zfb_baseUrl] params:param success:^(id response) {
        
        SendServiceOrderModel * orderModel = [SendServiceOrderModel mj_objectWithKeyValues:response];
        
        for (SendServiceStoreinfomap * orderlist in orderModel.storeInfoMap) {
            
            [self.orderListArray addObject:orderlist];
            
            for (SendServiceOrdergoodslist * goodslist in orderlist.orderGoodsList) {
                
                [self.orderGoodsArry addObject:goodslist];
            }
            
        }
        [self.orderdTableView reloadData];
        
    } progress:^(NSProgress *progeress) {
        
        NSLog(@"progeress=====%@",progeress);
        
    } failure:^(NSError *error) {
        
        NSLog(@"error=====%@",error);
        [self.view makeToast:@"网络错误" duration:2 position:@"center"];
    }];
    
    
}

-(void)viewWillAppear:(BOOL)animated
{   //网络请求
    [self getOrderPostRequst];
}

-(NSMutableArray *)orderListArray
{
    if (!_orderListArray) {
        _orderListArray = [NSMutableArray array];
    }
    return _orderListArray;
}
-(NSMutableArray *)orderGoodsArry
{
    if (!_orderGoodsArry) {
        _orderGoodsArry = [NSMutableArray array];
    }
    return _orderGoodsArry;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
