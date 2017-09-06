
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


@interface SendOrderStatisticsViewController ()<UITableViewDelegate,UITableViewDataSource,CYLTableViewPlaceHolderDelegate, WeChatStylePlaceHolderDelegate>

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
    
    dealNum.text = [NSString stringWithFormat:@"交易笔数: %@ 笔",_orderNum];
    dealPrice.text = [NSString stringWithFormat:@"交易金额:%@ 元",_dealPrice];
    
    //富文本设置
    //关键字
    dealNum.keywords = _orderNum;
    dealNum.keywordsColor = HEXCOLOR(0xfe6d6a);
    dealNum.keywordsFont = [UIFont systemFontOfSize:20];
    //关键字
    dealPrice.keywords = _dealPrice;
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
        return self.orderListArray.count;
//    return 2;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    SendServiceStoreinfomap * store = self.orderListArray[section];
    
    if (self.orderGoodsArry.count > 0) {
        
        [self.orderGoodsArry removeAllObjects];
    }
    for (SendServiceOrdergoodslist  * goods in store.orderGoodsList) {
       
        [self.orderGoodsArry addObject:goods];
    }
    return self.orderGoodsArry.count;

 
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 41;
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
                             @"status": @"4",
                             @"orderStartTime": _orderStartTime,
                             @"orderEndTime": _orderEndTime,
                             
                             };
    
    [MENetWorkManager post:[NSString stringWithFormat:@"%@/getOrderDeliveryByDeliveryId",zfb_baseUrl] params:param success:^(id response) {
        
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
