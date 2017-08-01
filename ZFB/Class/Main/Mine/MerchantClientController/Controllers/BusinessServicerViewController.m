//
//  BusinessServicerViewController.m
//  ZFB
//
//  Created by  展富宝  on 2017/7/28.
//  Copyright © 2017年 com.zfb. All rights reserved.
//

#import "BusinessServicerViewController.h"
//view
#import "BusinessServicPopView.h"//导航选择pop
#import "BusinessSendOrderView.h"//派单pop

//首页cell
#import "ZFTitleCell.h"
#import "ZFSendHomeListCell.h"
#import "SendServiceTitleCell.h"

//订单cell
#import "ZFSendingCell.h"//内容
#import "ZFTitleCell.h"//头
#import "ZFFooterCell.h"//尾部

//controller
#import "OrderStatisticsViewController.h"

//model
#import "BusinessHomeModel.h"
#import "DeliveryModel.h"//配送员列表

//获取经纬度
#import <CoreLocation/CoreLocation.h>

@interface BusinessServicerViewController ()<ZFFooterCellDelegate, BusinessServicPopViewDelegate,UITableViewDelegate,UITableViewDataSource,ZFSendHomeListCellDelegate,BusinessSendOrderViewDelegate,CLLocationManagerDelegate>

{
    //day
    NSString * _dayorder_count;
    NSString * _dayorder_amount;//订单金额
    NSString * _daydate_time;
    NSString * _daystart_time;
    NSString * _dayend_time;
    
    //week
    NSString * _weekorder_count;
    NSString * _weekorder_amount;//订单金额
    NSString * _weekodate_time;
    NSString * _weekstart_time;
    NSString * _weekend_time;
    //month
    NSString * _monthorder_count;
    NSString * _monthorder_amount;//订单金额
    NSString * _monthodate_time;
    NSString * _monthstart_time;
    NSString * _monthend_time;
    
    //订单数
    NSString * _order_count;
    //订单id
    NSString * _order_id;
    NSString * _order_amount;//当前价格
    
    CLLocationManager *locationmanager;//定位服务
    NSString *currentCity;//当前城市
    NSString *strlatitude;//经度
    NSString *strlongitude;//纬度
    
    
}

@property (nonatomic , strong) UITableView * homeTableView;

@property (weak, nonatomic) IBOutlet UIImageView *img_sendHome;
@property (weak, nonatomic) IBOutlet UIImageView *img_sendOrder;

@property (weak, nonatomic) IBOutlet UILabel *lb_sendHomeTitle;
@property (weak, nonatomic) IBOutlet UILabel *lb_sendOrderTitle;

@property (nonatomic,assign) BOOL     isSelectPage;//默认选择一个首页面
@property (nonatomic,strong) UIButton *  navbar_btn;//导航页选择器
@property (nonatomic,strong) UIView   *  titleView;
@property (nonatomic,strong) UIView   *  bgview;//蒙板1

@property (nonatomic ,strong) BusinessServicPopView * popView;
@property (nonatomic ,strong) NSArray               * titles;//pop数据源
@property (nonatomic ,assign) BusinessServicType    servicType;//传一个type

@property (nonatomic ,strong) BusinessSendOrderView * sendOrderPopView;
@property (nonatomic ,strong) UIView                *  orderBgview;//蒙板2

@property (nonatomic ,strong) NSMutableArray *  orderListArray ;//订单列表
@property (nonatomic ,strong) NSMutableArray *  orderGoodsArry ;//订单商品
@property (nonatomic ,strong) NSMutableArray *  deliveryArray  ;//配送员列表


@end

@implementation BusinessServicerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    
    _isSelectPage = YES;
    
    self.navigationItem.title = @"商户端";
    
    _titles = @[@"待派单",@"配送中",@"待付款",@"交易完成",@"待确认退回"];
    
    //待派单 。配送中。待付款、交易完成。待确认退回；
    [self.view addSubview:self.homeTableView];
    
    //register  nib
    [self.homeTableView registerNib:[UINib nibWithNibName:@"ZFTitleCell" bundle:nil]
             forCellReuseIdentifier:@"ZFTitleCell"];//商户首页头
    
    [self.homeTableView registerNib:[UINib nibWithNibName:@"ZFSendHomeListCell" bundle:nil]
             forCellReuseIdentifier:@"ZFSendHomeListCell"];//首页section =  2
    
    [self.homeTableView registerNib:[UINib nibWithNibName:@"SendServiceTitleCell" bundle:nil]
             forCellReuseIdentifier:@"SendServiceTitleCell"];//商户首页头2
    
    //订单 nib
    [self.homeTableView registerNib:[UINib nibWithNibName:@"ZFSendingCell" bundle:nil]
             forCellReuseIdentifier:@"ZFSendingCell"];
    
    [self.homeTableView registerNib:[UINib nibWithNibName:@"ZFFooterCell" bundle:nil]
             forCellReuseIdentifier:@"ZFFooterCell"];
    
    
    
}

-(UITableView *)homeTableView
{
    if (!_homeTableView ) {
        _homeTableView                = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, KScreenW, KScreenH- 64-49) style:UITableViewStylePlain];
        _homeTableView.delegate       = self;
        _homeTableView.dataSource     = self;
        _homeTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        
    }
    return _homeTableView;
}

/**
 @return  背景蒙板
 */
-(UIView *)bgview
{
    if (!_bgview) {
        _bgview =[[ UIView alloc]initWithFrame:CGRectMake(0, 64, KScreenW, KScreenH)];
        _bgview.backgroundColor = RGBA(0, 0, 0, 0.2) ;
        [_bgview addSubview:self.popView];
    }
    return _bgview;
    
}
//弹框初始化
-(BusinessServicPopView *)popView
{
    if (!_popView) {
        _popView =[[BusinessServicPopView alloc]initWithFrame:CGRectMake(0, 0, KScreenW, 110) titleArray:_titles];
        _popView.delegate = self;
        
    }
    return _popView;
}


//自定义导航按钮选择定订单
-(UIButton *)navbar_btn
{
    if (!_navbar_btn) {
        _navbar_btn       = [UIButton buttonWithType:UIButtonTypeCustom];
        _navbar_btn.frame = CGRectMake(_titleView.centerX+40 , _titleView.centerY, 120, 24);
        [_navbar_btn setImage:[UIImage imageNamed:@"Order_down"] forState:UIControlStateNormal];
        _navbar_btn.titleLabel.font = [UIFont systemFontOfSize:14];
        [_navbar_btn setTitleColor:HEXCOLOR(0xfe6d6a) forState:UIControlStateNormal];
        [_navbar_btn setImageEdgeInsets:UIEdgeInsetsMake(0, 80, 0, 0)];
        [_navbar_btn setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 0,30)];
        [_navbar_btn addTarget:self action:@selector(navigationBarSelectedOther:) forControlEvents:UIControlEventTouchUpInside];
        self.navigationItem.titleView = _navbar_btn;
    }
    return _navbar_btn;
}
/**
 正选反选
 @param btn 切换
 */
-(void)navigationBarSelectedOther:(UIButton *)btn;
{
    [self.view addSubview:self.bgview];;
}

//切换首页
- (IBAction)homePageAction:(id)sender {
    
    self.navbar_btn.hidden = YES;
    self.isSelectPage      = YES;
    
    self.img_sendHome.image         = [UIImage imageNamed:@"home_red"];
    self.lb_sendHomeTitle.textColor = HEXCOLOR(0xfe6d6a);
    
    self.lb_sendOrderTitle.textColor=[UIColor whiteColor];
    self.img_sendOrder.image = [UIImage imageNamed:@"Order_normal"];
    
    UILabel * atitle              = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 100, 30)] ;
    atitle.text                   = @"商户端";
    atitle.font =[UIFont systemFontOfSize:14];
    atitle.textAlignment          = NSTextAlignmentCenter;
    atitle.textColor              = HEXCOLOR(0xfe6d6a);
    self.navigationItem.titleView = atitle;
    
    [self.homeTableView reloadData];
}
//切换订单
- (IBAction)orderPageAction:(id)sender {
    
    self.isSelectPage      = NO;
    self.navbar_btn.hidden = NO;
    [self.navbar_btn setTitle:@"待配送" forState:UIControlStateNormal];
    
    self.img_sendHome.image         = [UIImage imageNamed:@"home_normal"];
    self.lb_sendHomeTitle.textColor = [UIColor whiteColor];
    
    self.lb_sendOrderTitle.textColor = HEXCOLOR(0xfe6d6a);
    self.img_sendOrder.image         = [UIImage imageNamed:@"send_red"];
    
    self.navigationItem.titleView = self.navbar_btn;
    
    
    [self businessOrderListPostRequstpayStatus:@"" orderStatus:@"0" searchWord:@"" cmUserId:@"" startTime:@"" endTime:@"" payMode:@"1" page:@"1" size:@"6" storeId:@"1"];
    
    [self.homeTableView reloadData];
}




#pragma mark  -tableView delegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    NSInteger sectionNum = 2;
    if (_isSelectPage == YES ) {
        
        return sectionNum;
        
    }else{
        switch (_servicType) {
            case BusinessServicTypeWaitSendlist://待派单
                return  self.orderListArray.count;
                
                break;
            case BusinessServicTypeSending://配送中
                return  self.orderListArray.count;
                
                break;
            case BusinessServicTypeWaitPay://待付款
                return self.orderListArray.count;
                
                break;
            case BusinessServicTypeDealComplete://交易完成
                return  self.orderListArray.count;
                
                break;
            case BusinessServicTypeSureReturn://待确认退回
                return self.orderListArray.count;
                
                break;
        }
    }
    
    return sectionNum;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger sectionRow = 2;
    
    if (_isSelectPage == YES ) {
        
        sectionRow = 1;
        
        
    }else{
        switch (_servicType) {
            case BusinessServicTypeWaitSendlist://待派单
                return   self.orderGoodsArry.count;
                
                break;
            case BusinessServicTypeSending://配送中
                return   self.orderGoodsArry.count;
                
                break;
            case BusinessServicTypeWaitPay://待付款
                return   self.orderGoodsArry.count;
                
                break;
            case BusinessServicTypeDealComplete://交易完成
                return   self.orderGoodsArry.count;
                
                break;
            case BusinessServicTypeSureReturn://待确认退回
                return   self.orderGoodsArry.count;
                
                break;
        }
    }
    return sectionRow;
}
//单元格高度
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat height = 0;
    
    ///根据  cellType 返回的高度
    if (_isSelectPage == YES) {
        if (indexPath.section == 0) {
            
            height = 80;
        }
        else{
            
            height = 220;
        }
    }else{
        switch (_servicType) {
            case BusinessServicTypeWaitSendlist://待派单
                height = 82;
                
                break;
            case BusinessServicTypeSending://配送中
                height = 82;
                
                break;
            case BusinessServicTypeWaitPay://待付款
                height = 82;
                
                break;
            case BusinessServicTypeDealComplete://交易完成
                height = 82;
                
                break;
            case BusinessServicTypeSureReturn://待确认退回
                height = 82;
                
                break;
        }
    }
    
    
    return height;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView  * view = nil;
    if (_isSelectPage == YES) {
        
        if (section == 0) {
            return view;
        }
        SendServiceTitleCell  *titleCell = [self.homeTableView
                                            dequeueReusableCellWithIdentifier:@"SendServiceTitleCell"];
        titleCell.selectionStyle = UITableViewCellSelectionStyleNone;
        titleCell.lb_title.text  = @"订单统计信息";
        [titleCell.statusButton setTitle:@"" forState:UIControlStateNormal];
        
        view = titleCell;
        
    }else{
        
        switch (_servicType) {
            case BusinessServicTypeWaitSendlist://待派单
            {
                ZFTitleCell * titleCell = [self.homeTableView
                                           dequeueReusableCellWithIdentifier:@"ZFTitleCell"];
                BusinessOrderlist  * orderlist = self.orderListArray[section];
                titleCell.businessOrder        = orderlist;
                return titleCell;
            }
                
                break;
            case BusinessServicTypeSending://配送中
            {
                ZFTitleCell * titleCell = [self.homeTableView
                                           dequeueReusableCellWithIdentifier:@"ZFTitleCell"];
                BusinessOrderlist  * orderlist = self.orderListArray[section];
                titleCell.businessOrder        = orderlist;
                return titleCell;
            }
                break;
            case BusinessServicTypeWaitPay://待付款
            {
                ZFTitleCell * titleCell = [self.homeTableView
                                           dequeueReusableCellWithIdentifier:@"ZFTitleCell"];
                BusinessOrderlist  * orderlist = self.orderListArray[section];
                titleCell.businessOrder        = orderlist;
                return titleCell;
            }
                break;
            case BusinessServicTypeDealComplete://交易完成
            {
                ZFTitleCell * titleCell = [self.homeTableView
                                           dequeueReusableCellWithIdentifier:@"ZFTitleCell"];
                [titleCell.statusButton setTitle:@"交易完成" forState:UIControlStateNormal];
                BusinessOrderlist  * orderlist = self.orderListArray[section];
                titleCell.businessOrder        = orderlist;
                return titleCell;
            }
                break;
            case BusinessServicTypeSureReturn://待确认退回
            {
                ZFTitleCell * titleCell        = [self.homeTableView dequeueReusableCellWithIdentifier:@"ZFTitleCell"];
                BusinessOrderlist  * orderlist = self.orderListArray[section];
                titleCell.businessOrder        = orderlist;
                return titleCell;
            }
                break;
        }
        
    }
    
    
    return view;
}
//设置headView视图
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    CGFloat height = 0.001;
    if (_isSelectPage == YES) {
        if (section == 0) {
            
            height = 0.001;
        }else{
            
            height = 41;
        }
        
    }
    else{
        
        switch (_servicType) {
            case BusinessServicTypeWaitSendlist://待派单
                height = 82;
                break;
            case BusinessServicTypeSending://配送中
                height = 82;
                
                break;
            case BusinessServicTypeWaitPay://待付款
                height = 82;
                
                break;
            case BusinessServicTypeDealComplete://交易完成
                height = 82;
                
                break;
            case BusinessServicTypeSureReturn://待确认退回
                height = 82;
                
                break;
        }
        
    }
    return height;
    
}

//设置footerView视图
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView * footerView = nil;
    
    if (_isSelectPage == YES) {
        
        return footerView;
        
    }else{
        switch (_servicType) {
                
            case BusinessServicTypeWaitSendlist://待派单
            {
                ZFFooterCell * cell = [self.homeTableView
                                       dequeueReusableCellWithIdentifier:@"ZFFooterCell"];
                cell.footDelegate = self;
                
                BusinessOrderlist  * orderlist = self.orderListArray[section];
                cell.businessOrder             = orderlist;
                footerView                     = cell;
                
            }
                break;
            case BusinessServicTypeSending://配送中
            {
                ZFFooterCell * cell = [self.homeTableView
                                       dequeueReusableCellWithIdentifier:@"ZFFooterCell"];
                cell.footDelegate = self;
                
                BusinessOrderlist  * orderlist = self.orderListArray[section];
                cell.businessOrder             = orderlist;
                footerView                     = cell;
                
            }
                
                break;
            case BusinessServicTypeWaitPay://待付款
            {
                ZFFooterCell * cell = [self.homeTableView
                                       dequeueReusableCellWithIdentifier:@"ZFFooterCell"];
                cell.footDelegate              = self;
                BusinessOrderlist  * orderlist = self.orderListArray[section];
                cell.businessOrder             = orderlist;
                footerView                     = cell;
                
            }
                
                break;
            case BusinessServicTypeDealComplete://交易完成
            {
                ZFFooterCell * cell = [self.homeTableView
                                       dequeueReusableCellWithIdentifier:@"ZFFooterCell"];
                [cell.cancel_button setHidden:YES];
                [cell.payfor_button setHidden:YES];
                cell.footDelegate              = self;
                BusinessOrderlist  * orderlist = self.orderListArray[section];
                cell.businessOrder             = orderlist;
                footerView                     = cell;
                
            }
                
                break;
            case BusinessServicTypeSureReturn://待确认退回
            {
                ZFFooterCell * cell = [self.homeTableView
                                       dequeueReusableCellWithIdentifier:@"ZFFooterCell"];
                cell.footDelegate = self;
                
                BusinessOrderlist  * orderlist = self.orderListArray[section];
                cell.businessOrder             = orderlist;
                footerView                     = cell;
                
            }
                
                break;
        }
    }
    
    return footerView;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    CGFloat height = 0.001;
    
    if (_isSelectPage == YES) {
        
        height = 10;
        
    }else{
        switch (_servicType) {
            case BusinessServicTypeWaitSendlist://待派单
                height = 50;
                break;
            case BusinessServicTypeSending://配送中
                height = 50;
                
                break;
            case BusinessServicTypeWaitPay://待付款
                height = 50;
                
                break;
            case BusinessServicTypeDealComplete://交易完成
                height = 50;
                
                break;
            case BusinessServicTypeSureReturn://待确认退回
                height = 50;
                
                break;
        }
    }
    return height;
    
}

#pragma mark - ZFSendHomeListCellDelegate 订单详情的代理
///日统计
-(void)todayOrderDetial{
    NSLog(@"--a--1");
    
    OrderStatisticsViewController * orderDatil = [[OrderStatisticsViewController alloc]init];
    orderDatil.orderNum                        = _dayorder_count;//订单数;
    orderDatil.dealPrice                       = _dayorder_amount;//订单金额数;
    
    [self businessOrderListPostRequstpayStatus:@"" orderStatus:@"3" searchWord:@"" cmUserId:@"" startTime:_daystart_time endTime:_dayend_time payMode:@"" page:@"1" size:@"6" storeId:@"1"];
    
    [self.navigationController pushViewController:orderDatil animated:NO];
    
    
}
///周统计
-(void)weekOrderDetial
{
    NSLog(@"--a--2");
    OrderStatisticsViewController * orderDatil = [[OrderStatisticsViewController alloc]init];
    orderDatil.orderNum                        = _weekorder_count ;//订单数;
    orderDatil.dealPrice                       = _weekorder_amount;//订单金额数;
    [self businessOrderListPostRequstpayStatus:@"" orderStatus:@"3" searchWord:@"" cmUserId:@"" startTime:_weekstart_time endTime:_weekend_time payMode:@"" page:@"1" size:@"6" storeId:@"1"];
    
    [self.navigationController pushViewController:orderDatil animated:NO];
    
    
    
}

///月统计
-(void)monthOrderDetial
{
    OrderStatisticsViewController * orderDatil = [[OrderStatisticsViewController alloc]init];
    
    [self businessOrderListPostRequstpayStatus:@"" orderStatus:@"3" searchWord:@"" cmUserId:@"" startTime:_monthstart_time endTime:_monthend_time payMode:@"" page:@"1" size:@"6" storeId:@"1"];
    orderDatil.orderNum  = _monthorder_count;//订单数;
    orderDatil.dealPrice = _monthorder_amount;//订单金额数;
    [self.navigationController pushViewController:orderDatil animated:NO];
    
    NSLog(@"--a--3");
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (_isSelectPage == YES) {
        
        if (indexPath.section == 0) {
            
            ZFTitleCell *titleCell = [self.homeTableView
                                      dequeueReusableCellWithIdentifier:@"ZFTitleCell"];
            titleCell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            titleCell.lb_nameOrTime.text = @"待配送信息";
            titleCell.lb_storeName.text  = [NSString stringWithFormat:@"待派送订单 %@ 笔 >",_order_count];
            [titleCell.statusButton setTitle:@"" forState:UIControlStateNormal];
            
            //关键字
            titleCell.lb_storeName.keywords      = _order_count;
            titleCell.lb_storeName.keywordsColor = HEXCOLOR(0xfe6d6a);
            titleCell.lb_storeName.keywordsFont  = [UIFont systemFontOfSize:18];
            ///必须设置计算宽高
            CGRect dealNumh              = [titleCell.lb_storeName getLableHeightWithMaxWidth:300];
            titleCell.lb_storeName.frame = CGRectMake(15, 10, dealNumh.size.width, dealNumh.size.height);
            
            return titleCell;
            
        }
        ZFSendHomeListCell * cell = [self.homeTableView dequeueReusableCellWithIdentifier:@"ZFSendHomeListCell" forIndexPath:indexPath];
        cell.selectionStyle       = UITableViewCellSelectionStyleNone;
        cell.delegate             = self;
        //日
        cell.lb_todayCreatTime.text = _daydate_time;
        cell.lb_todayOrderNum.text  = _dayorder_count;
        cell.lb_todayPriceFree.text = _dayorder_amount;
        //周
        cell.lb_weekCreatTime.text = _weekodate_time;
        cell.lb_weekOrderNum.text  = _weekorder_count;
        cell.lb_weekPriceFree.text = _weekorder_amount;
        //月
        cell.lb_monthOrderNum.text  = _monthorder_count;
        cell.lb_monthPriceFree.text = _monthorder_amount;
        cell.lb_monthCreatTime.text = _monthodate_time;
        
        return cell;
        
    }else{
        
        //公用cell
        ZFSendingCell * contentCell = [self.homeTableView dequeueReusableCellWithIdentifier:@"ZFSendingCell" forIndexPath:indexPath];
        
        switch (_servicType) {
                
            case BusinessServicTypeWaitSendlist://待派单
            {
                BusinessOrdergoods * goodlist = self.orderGoodsArry[indexPath.row];
#warning - 不知道这个能获取到orderid吗
                //获取_order_id
                _order_id = goodlist.order_id;
                
                contentCell.businesGoods = goodlist;
                return contentCell;
            }
                break;
            case BusinessServicTypeSending://配送中
            {
                BusinessOrdergoods * goodlist = self.orderGoodsArry[indexPath.row];
                contentCell.businesGoods      = goodlist;
                return contentCell;
            }
                break;
            case BusinessServicTypeWaitPay://待付款
            {
                BusinessOrdergoods * goodlist = self.orderGoodsArry[indexPath.row];
                contentCell.businesGoods      = goodlist;
                return contentCell;
            }
                break;
            case BusinessServicTypeDealComplete://交易完成
            {
                BusinessOrdergoods * goodlist = self.orderGoodsArry[indexPath.row];
                contentCell.businesGoods      = goodlist;
                return contentCell;
            }
                break;
            case BusinessServicTypeSureReturn://待确认退回
            {
                BusinessOrdergoods * goodlist = self.orderGoodsArry[indexPath.row];
                contentCell.businesGoods      = goodlist;
                return contentCell;
            }
                break;
                
        }
        return contentCell;
    }
    return nil;
    
}

#pragma mark - didSelectRowAtIndexPath

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"section  =%ld , row = %ld",indexPath.section ,indexPath.row);
    
    if (_isSelectPage == YES) {
        
        if (indexPath.section == 0) {
            
        }
        
    }else{
        
        switch (_servicType) {
            case BusinessServicTypeWaitSendlist://待派单
                
                break;
            case BusinessServicTypeSending://配送中
                
                break;
            case BusinessServicTypeWaitPay://待付款
                
                break;
            case BusinessServicTypeDealComplete://交易完成
                
                break;
            case BusinessServicTypeSureReturn://待确认退回
                
                break;
        }
    }
}


#pragma mark - BusinessServicPopViewDelegate 选择一个type
-(void)sendTitle:(NSString *)title businessServicType:(BusinessServicType)type
{
    [UIView animateWithDuration:0.3 animations:^{
        
        if (self.bgview.superview) {
            
            [self.bgview removeFromSuperview];
            
        }
    }];
    
    //    _servicType = type;//赋值type ，根据type请求
    
    [self.navbar_btn setTitle:title forState:UIControlStateNormal];
    
    switch (_servicType) {
            
        case BusinessServicTypeWaitSendlist://待派单
            
            [self businessOrderListPostRequstpayStatus:@"" orderStatus:@"0" searchWord:@"" cmUserId:@"" startTime:@"" endTime:@"" payMode:@"1" page:@"1" size:@"6" storeId:@"1"];
            
            [self.homeTableView reloadData];
            
            break;
        case BusinessServicTypeSending://配送中
            
            [self businessOrderListPostRequstpayStatus:@"" orderStatus:@"1" searchWord:@"" cmUserId:@"" startTime:@"" endTime:@"" payMode:@"1" page:@"1" size:@"6" storeId:@"1"] ;
            [self.homeTableView reloadData];
            
            break;
        case BusinessServicTypeWaitPay://待付款
            
            [self businessOrderListPostRequstpayStatus:@"" orderStatus:@"4" searchWord:@"" cmUserId:@"" startTime:@"" endTime:@"" payMode:@"1" page:@"1" size:@"6" storeId:@"1"];
            [self.homeTableView reloadData];
            
            break;
        case BusinessServicTypeDealComplete://交易完成
            
            [self businessOrderListPostRequstpayStatus:@"" orderStatus:@"3" searchWord:@"" cmUserId:@"" startTime:@"" endTime:@"" payMode:@"1" page:@"1" size:@"6" storeId:@"1"];
            break;
        case BusinessServicTypeSureReturn://待确认退回
            
            [self businessOrderListPostRequstpayStatus:@"" orderStatus:@"6" searchWord:@"" cmUserId:@"" startTime:@"" endTime:@"" payMode:@"1" page:@"1" size:@"6" storeId:@"1"];
            [self.homeTableView reloadData];
            
            
            break;
    }
    
    
    //待派单 。配送中。待付款、交易完成。待去人退回；
    
}


-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
    
    [self.bgview removeFromSuperview];
    [self.orderBgview removeFromSuperview];
    
    
}
-(void)viewWillDisappear:(BOOL)animated{
    
    [SVProgressHUD dismiss];
    
}
-(void)viewWillAppear:(BOOL)animated
{
    //获取商户端数据列表
    [self storeHomePagePostRequst];
    
    //获取定位
    [self startLocation];
    
}
-(NSMutableArray *)orderGoodsArry
{
    if (!_orderGoodsArry) {
        _orderGoodsArry = [NSMutableArray array];
    }
    return _orderGoodsArry;
}
-(NSMutableArray *)orderListArray
{
    if (!_orderListArray) {
        _orderListArray = [NSMutableArray array];
    }
    return _orderListArray;
}
-(NSMutableArray *)deliveryArray{
    if (!_deliveryArray) {
        _deliveryArray = [NSMutableArray array];
    }
    return _deliveryArray;
}


#pragma mark - ZFFooterCellDelegate   footerview的所有代理方法
//取消订单
-(void)cancelOrderAction{//取消操作
    NSLog(@"取消操作")
    
    JXTAlertController * alertavc =[JXTAlertController alertControllerWithTitle:@"提示" message:@"是否取消该订单！" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction * cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    UIAlertAction * sureAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        
        if (_order_id != nil) {
            //确认后调用该接口
            [self cancleOrderPostRequst];
        }
        
    }];
    [alertavc addAction:cancelAction];
    [alertavc addAction:sureAction];
    
    [self presentViewController:alertavc animated:YES completion:nil];
    
    
}
#pragma mark - ZFFooterCellDelegate 派单代理
///派单列表添加   自定义tableview
-(void)sendOrdersActionOrderId:(NSString *)orderId totalPrice:(NSString *)totalPrice//派单
{
    _order_id                                      = orderId;
    _order_amount                                  = totalPrice;//当前总价
    NSLog(@"派单操作 - orderId =%@ ,totalPrice         = %@ ",_order_id,_order_amount);
    
    [self selectDeliveryListPostRequst];//请求配送员接口
    
    [self.view addSubview:self.orderBgview];
    
}

#pragma mark - BusinessSendOrderViewDelegate 选择派单给谁
-(void)didClickPushdeliveryId:(NSString *)deliveryId
                 deliveryName:(NSString *)deliveryName
                deliveryPhone:(NSString *)deliveryPhone
                        Index:(NSInteger)index
{
    //这里需要网络请求，派单操作
    //orderid Huoqu
    [self sendOrderPostRequstStoreID:@"1" deliveryId:deliveryId orderId:_order_id postAddress:@"" status:@"" orderAmount:_order_amount deliveryName:deliveryName deliveryPhone:deliveryPhone];
    
}

-(BusinessSendOrderView *)sendOrderPopView
{
    if (!_sendOrderPopView) {
        _sendOrderPopView               = [[BusinessSendOrderView alloc]initWithFrame:CGRectMake(50, 0, KScreenW - 100, 250)];
        _sendOrderPopView.deliveryArray = self.deliveryArray;
        _sendOrderPopView.center        = self.view.center;
        _sendOrderPopView.delegate      = self;
        
    }
    return _sendOrderPopView;
}
/**
 @return  背景蒙板
 */
-(UIView *)orderBgview
{
    if (!_orderBgview) {
        _orderBgview =[[ UIView alloc]initWithFrame:CGRectMake(0, 64, KScreenW, KScreenH)];
        _orderBgview.backgroundColor = RGBA(0, 0, 0, 0.2) ;
        
        [_orderBgview addSubview:self.sendOrderPopView];
    }
    return _orderBgview;
    
}
#pragma mark -  获取商户端数据列表    order/storeHomePage
-(void)storeHomePagePostRequst
{
    
    NSDictionary * param = @{
                             @"storeId": @"1",
                             
                             };
    
    [MENetWorkManager post:[NSString stringWithFormat:@"%@/order/storeHomePage",zfb_baseUrl] params:param success:^(id response) {
        
        BusinessHomeModel * homeModel = [BusinessHomeModel mj_objectWithKeyValues:response];
        _order_count                  = homeModel.orderUnpayInfo.order_count;//订单数
        
        _daydate_time    = homeModel.monthOrderInfo.date_time;
        _dayorder_count  = homeModel.monthOrderInfo.order_count;
        _dayorder_amount = homeModel.monthOrderInfo.order_amount;
        _daystart_time   = homeModel.monthOrderInfo.start_time;
        _dayend_time     = homeModel.monthOrderInfo.end_time;
        
        _weekodate_time   = homeModel.sevenDayOrderInfo.date_time;
        _weekorder_count  = homeModel.sevenDayOrderInfo.order_count;
        _weekorder_amount = homeModel.sevenDayOrderInfo.order_amount;
        _weekstart_time   = homeModel.sevenDayOrderInfo.start_time;
        _weekend_time     = homeModel.sevenDayOrderInfo.end_time;
        
        _monthorder_amount = homeModel.monthOrderInfo.order_amount;
        _monthorder_count  = homeModel.monthOrderInfo.order_count;
        _monthodate_time   = homeModel.monthOrderInfo.date_time;
        _monthstart_time   = homeModel.monthOrderInfo.start_time;
        _monthend_time     = homeModel.monthOrderInfo.end_time;
        
        [self.homeTableView reloadData];
        
    } progress:^(NSProgress *progeress) {
        
        NSLog(@"progeress=====%@",progeress);
        
    } failure:^(NSError *error) {
        
        NSLog(@"error=====%@",error);
        [self.view makeToast:@"网络错误" duration:2 position:@"center"];
    }];
    
    
}


#pragma mark -  获取商户端订单列表       order/getStoreOrderList

/**
 商户端订单列表
 
 @param payStatus 0.未支付的初始状态 1.支付成功 -1.支付失败 3.付款发起 4.付款取消 (待付款) 5.退款成功（支付成功的）6.退款发起(支付成功) 7.退款失败(支付成功)',
 @param orderStatus -1：关闭,0待配送 1配送中 2.配送完成，3交易完成（用户确认收货），4.待付款,5.待审批,6.待退回，7.服务完成
 @param searchWord 关键词
 @param cmUserId 注意：商户端查询订单式 ，该字段不传
 @param startTime 开始时间
 @param endTime 结束时间
 @param payMode 支付模式
 */
-(void)businessOrderListPostRequstpayStatus:(NSString * )payStatus
                                orderStatus:(NSString *)orderStatus
                                 searchWord:(NSString *)searchWord
                                   cmUserId:(NSString *)cmUserId
                                  startTime:(NSString *)startTime
                                    endTime:(NSString *)endTime
                                    payMode:(NSString *)payMode
                                       page:(NSString *)page
                                       size:(NSString *)size
                                    storeId:(NSString *)storeId
{
    
    NSDictionary * param = @{
                             @"page": page,
                             @"size": size,
                             @"payStatus": payStatus,
                             @"orderStatus": orderStatus,
                             @"searchWord":searchWord,
                             @"cmUserId": cmUserId,
                             @"startTime": startTime,
                             @"endTime": endTime,
                             @"payMode": payMode,
                             @"storeId": storeId,
                             
                             };
    
    [MENetWorkManager post:[NSString stringWithFormat:@"%@/order/getStoreOrderList",zfb_baseUrl] params:param success:^(id response) {
        
        BusinessOrderModel * orderModel = [BusinessOrderModel mj_objectWithKeyValues:response];
        
        for (BusinessOrderlist * orderlist in orderModel.orderList) {
            
            [self.orderListArray addObject:orderlist];
            
            for (BusinessOrdergoods * goodslist in orderlist.orderGoods) {
                
                [self.orderGoodsArry addObject:goodslist];
                
            }
            
        }
        
        [self.homeTableView reloadData];
        
    } progress:^(NSProgress *progeress) {
        
        NSLog(@"progeress=====%@",progeress);
        
    } failure:^(NSError *error) {
        
        NSLog(@"error=====%@",error);
        [self.view makeToast:@"网络错误" duration:2 position:@"center"];
    }];
    
    
}
#pragma mark -  取消订单接口    order/cancelOrder
-(void)cancleOrderPostRequst
{
    NSLog(@" ==== %@ ==_order_id" ,_order_id);
    NSDictionary * param = @{
                             @"orderId":_order_id,
                             };
    
    
    [MENetWorkManager post:[NSString stringWithFormat:@"%@/order/cancelOrder",zfb_baseUrl] params:param success:^(id response) {
        if (self.orderListArray.count > 0) {
            [self.orderListArray removeAllObjects];
            
        }
        if (self.orderGoodsArry.count > 0) {
            [self.orderGoodsArry removeAllObjects];
        }
        BusinessOrderModel * orderModel = [BusinessOrderModel mj_objectWithKeyValues:response];
        
        for (BusinessOrderlist * orderlist in orderModel.orderList) {
            
            [self.orderListArray addObject:orderlist];
            
            for (BusinessOrdergoods * goodslist in orderlist.orderGoods) {
                
                [self.orderGoodsArry addObject:goodslist];
            }
            
        }
        
        [self.homeTableView reloadData];
        
    } progress:^(NSProgress *progeress) {
        
        NSLog(@"progeress=====%@",progeress);
        
    } failure:^(NSError *error) {
        
        NSLog(@"error=====%@",error);
        [self.view makeToast:@"网络错误" duration:2 position:@"center"];
    }];
    
}

#pragma mark -  商户派单接口    order/orderSheet
-(void)sendOrderPostRequstStoreID:(NSString *)storeId
                       deliveryId:(NSString *)deliveryId
                          orderId:(NSString *)orderId
                      postAddress:(NSString *)postAddress
                           status:(NSString *)status
                      orderAmount:(NSString *)orderAmount
                     deliveryName:(NSString *)deliveryName
                    deliveryPhone:(NSString *)deliveryPhone
{
    NSDictionary * param = @{
                             @"storeId":@"1",
                             @"deliveryId":deliveryId,//配送员id
                             @"orderId":@"",//订单编号
                             @"postAddress":@"",//接收人地址
                             @"postName":@"",//接收人名称
                             @"status":@"1",//订单状态		0:配送完成,1:待配送，2:上门取件，3：配送中
                             @"orderAmount":@"100",//订单金额
                             @"deliveryName": deliveryName,
                             @"deliveryPhone":deliveryPhone,//配送员电话
                             };
    
    
    [MENetWorkManager post:[NSString stringWithFormat:@"%@/order/cancelOrder",zfb_baseUrl] params:param success:^(id response) {
        
        [self.view makeToast:response[@"resultMsg"] duration:2 position:@"center"];
        
    } progress:^(NSProgress *progeress) {
        
        NSLog(@"progeress=====%@",progeress);
        
    } failure:^(NSError *error) {
        
        NSLog(@"error=====%@",error);
    }];
    
}

#pragma mark -  配送员列表接口       order/selectDeliveryList
-(void)selectDeliveryListPostRequst
{
    NSDictionary * param = @{
                             @"longitude":strlongitude,
                             @"latitude":strlatitude,
                             
                             };
    
    [SVProgressHUD show];
    [MENetWorkManager post:[NSString stringWithFormat:@"%@/order/selectDeliveryList",zfb_baseUrl] params:param success:^(id response) {
        
        DeliveryModel * model = [DeliveryModel mj_objectWithKeyValues:response];
        
        for (Deliverylist * list in model.deliveryList) {
            
            [self.deliveryArray addObject:list];
        }
        [SVProgressHUD dismissWithDelay:1];
        
    } progress:^(NSProgress *progeress) {
        
        NSLog(@"progeress=====%@",progeress);
        
    } failure:^(NSError *error) {
        [SVProgressHUD dismiss];
        NSLog(@"error=====%@",error);
    }];
    
}


#pragma mark - 获取经纬度
//开始定位
- (void)startLocation {
    //判断定位功能是否打开
    if ([CLLocationManager locationServicesEnabled]) {
        locationmanager          = [[CLLocationManager alloc]init];
        locationmanager.delegate = self;
        [locationmanager requestAlwaysAuthorization];
        currentCity = [NSString new];
        [locationmanager requestWhenInUseAuthorization];
        
        //设置寻址精度
        locationmanager.desiredAccuracy = kCLLocationAccuracyBest;
        locationmanager.distanceFilter  = 5.0;
        [locationmanager startUpdatingLocation];
    }
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    //设置提示提醒用户打开定位服务
    [self.view makeToast:[NSString stringWithFormat:@"%@",error] duration:2 position:@"center"];
    
//    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"允许定位提示" message:@"请在设置中打开定位" preferredStyle:UIAlertControllerStyleAlert];
//    UIAlertAction *okAction  = [UIAlertAction actionWithTitle:@"打开定位" style:UIAlertActionStyleDefault handler:nil];
//    
//    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
//    [alert addAction:okAction];
//    [alert addAction:cancelAction];
//    [self presentViewController:alert animated:YES completion:nil];
}
//定位代理经纬度回调
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations {
    
    //旧址
    CLLocation *currentLocation = [locations lastObject];
    
    //打印当前的经度与纬度
    NSLog(@"%f,%f",currentLocation.coordinate.latitude,currentLocation.coordinate.longitude);
    
    strlatitude  = [NSString stringWithFormat:@"%f",currentLocation.coordinate.latitude];
    strlongitude = [NSString stringWithFormat:@"%f",currentLocation.coordinate.longitude];
    
    //系统会一直更新数据，直到选择停止更新，因为我们只需要获得一次经纬度即可，所以获取之后就停止更新
    [manager stopUpdatingLocation];
    
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
