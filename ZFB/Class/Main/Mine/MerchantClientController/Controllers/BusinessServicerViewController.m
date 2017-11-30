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
#import "ZFCheckTheProgressCell.h"//申请售后的
#import "BusinessSendAccountCell.h"//结算
#import "SendStatisticsContentCell.h"//订单首页的内容cell
#import "SendStatisticsHeaderCell.h"//订单首页头部修改
//controller
#import "OrderStatisticsViewController.h"
#import "ZFDetailOrderViewController.h"

//model
#import "BusinessHomeModel.h"
#import "DeliveryModel.h"//配送员列表
#import "AllOrderProgress.h"//售后申请的
#import "CaculaterModel.h"

//获取经纬度
#import <CoreLocation/CoreLocation.h>
#import "CLLocation+MPLocation.h"

#define  k_cellHeight 130
#define  k_sectionHeight 90
#define  k_footHeight 60

typedef NS_ENUM(NSUInteger, SelectType) {
    SelectTypeHomePage, //选择首页
    SelectTypeOrderPage, //选择订单
    SelectTypeCaculater,//选择结算
};
@interface BusinessServicerViewController ()<ZFFooterCellDelegate, BusinessServicPopViewDelegate,UITableViewDelegate,UITableViewDataSource,ZFSendHomeListCellDelegate,BusinessSendOrderViewDelegate,CLLocationManagerDelegate,ZFCheckTheProgressCellDelegate>

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
    
    NSInteger _pageCount;//每页显示条数
    NSInteger _page;//当前页码;
    
    NSString *currentCityAndStreet;//当前城市
    NSString *latitudestr;//经度
    NSString *longitudestr;//纬度
    
    NSInteger _currentSection;
    NSString * expressName ;//快递公司
    NSString * expressNumber ;//快递号
}
@property (nonatomic,strong) CLLocationManager * locationManager;

@property (weak, nonatomic) IBOutlet UITableView *homeTableView;


@property (weak, nonatomic) IBOutlet UIImageView *img_sendHome;
@property (weak, nonatomic) IBOutlet UIImageView *img_sendOrder;

@property (weak, nonatomic) IBOutlet UILabel *lb_sendHomeTitle;
@property (weak, nonatomic) IBOutlet UILabel *lb_sendOrderTitle;

@property (nonatomic,strong) UIButton  *  navbar_btn;//导航页选择器
@property (nonatomic,strong) UIView    *  bgview;//蒙板1
@property (nonatomic,strong) UIView    *  titleView ;
@property (nonatomic,strong) UILabel   *  navTitle  ;


@property (nonatomic ,strong) BusinessServicPopView * popView;
@property (nonatomic ,strong) NSArray               * titles;//pop数据源
@property (nonatomic ,assign) BusinessServicType    servicType;//传一个type
@property (nonatomic ,assign) SelectType            selectPageType;//选择类型

@property (nonatomic ,strong) BusinessSendOrderView * sendOrderPopView;
@property (nonatomic ,strong) UIView                *  orderBgview;//蒙板2

@property (nonatomic ,strong) NSMutableArray *  orderListArray ;//订单列表
@property (nonatomic ,strong) NSMutableArray *  deliveryArray    ;//配送员列表
@property (nonatomic ,strong) NSMutableArray *  progressArray    ;//待确认退回的数据
@property (nonatomic ,strong) NSMutableArray *  caculaterArray   ;//结算



//分类
@property (weak, nonatomic) IBOutlet UISegmentedControl *segementPage;

@end

@implementation BusinessServicerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.navigationItem.title = @"商户端";
    
    _titles = @[@"待派单",@"配送中",@"待付款",@"交易完成",@"待确认退回",@"已配送",@"取消订单",@"待发货",@"待收货"];
    
    //待派单 。配送中。待付款、交易完成。待确认退回；
    [self tableViewSetting];    
    [self segmentSetting];
    
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
    [self.homeTableView registerNib:[UINib nibWithNibName:@"ZFCheckTheProgressCell" bundle:nil]
             forCellReuseIdentifier:@"ZFCheckTheProgressCell"];
    [self.homeTableView registerNib:[UINib nibWithNibName:@"BusinessSendAccountCell" bundle:nil]
             forCellReuseIdentifier:@"BusinessSendAccountCell"];
    [self.homeTableView registerNib:[UINib nibWithNibName:@"SendStatisticsHeaderCell" bundle:nil]
             forCellReuseIdentifier:@"SendStatisticsHeaderCell"];
    [self.homeTableView registerNib:[UINib nibWithNibName:@"SendStatisticsContentCell" bundle:nil]
             forCellReuseIdentifier:@"SendStatisticsContentCell"];
    
}

-(void)tableViewSetting
{
    self.homeTableView.delegate       = self;
    self.homeTableView.dataSource     = self;
    self.homeTableView.estimatedSectionFooterHeight = 0;
    self.homeTableView.estimatedSectionHeaderHeight = 0;
    self.homeTableView.estimatedRowHeight = 0;
    self.zfb_tableView = self.homeTableView;
    [self setupRefresh];

}
 
#pragma mark -数据请求
-(void)headerRefresh {
    
    [super headerRefresh];
    switch (_selectPageType ) {
        case SelectTypeHomePage:
            [self storeHomePagePostRequst];
            break;
            
        case SelectTypeOrderPage:
            switch (_servicType) {
                    
                case BusinessServicTypeWaitSendlist://待派单
                    
                    [self businessOrderListPostRequstpayStatus:@"" orderStatus:@"0" storeId:_storeId];

                    break;
                case BusinessServicTypeSending://配送中
                    
                    [self businessOrderListPostRequstpayStatus:@"" orderStatus:@"1" storeId:_storeId];
                    
                    break;
                case BusinessServicTypeWaitPay://待付款
         
                    [self businessOrderListPostRequstpayStatus:@"" orderStatus:@"4" storeId:_storeId];

                    break;
                case BusinessServicTypeDealComplete://交易完成
                    
                    [self businessOrderListPostRequstpayStatus:@"" orderStatus:@"3" storeId:_storeId];

                    break;
                case BusinessServicTypeSureReturn://待确认退回
                    
                    [self salesAfterPostRequsteAtStoreId:_storeId];
                    
                    
                    break;
                case BusinessServicTypeSended://已配送
                    
                    [self businessOrderListPostRequstpayStatus:@"" orderStatus:@"2" storeId:_storeId];

                    break;
                case BusinessServicTypeCancelOrder://取消订单
   
                    [self businessOrderListPostRequstpayStatus:@"" orderStatus:@"-1" storeId:_storeId];

                    
                    break;

                case BusinessServicTypeWaitSending://待发货
                    [self businessOrderListPostRequstpayStatus:@"" orderStatus:@"9" storeId:_storeId];

                    break;
                case BusinessServicTypeWaitReceived://待收货
                    [self businessOrderListPostRequstpayStatus:@"" orderStatus:@"10" storeId:_storeId];

                    break;
            }
            
            break;
        case SelectTypeCaculater:
            [self caculaterListPostRequset];
            
            break;
            
    }
}
-(void)footerRefresh {
    [super footerRefresh];
    
    switch (_selectPageType ) {
        case SelectTypeHomePage:
            [self storeHomePagePostRequst];

            break;
            
        case SelectTypeOrderPage:
            switch (_servicType) {
                    
                case BusinessServicTypeWaitSendlist://待派单
                    
                    [self businessOrderListPostRequstpayStatus:@"" orderStatus:@"0" storeId:_storeId];
                    
                    break;
                case BusinessServicTypeSending://配送中
                    
                    [self businessOrderListPostRequstpayStatus:@"" orderStatus:@"1" storeId:_storeId];
                    
                    
                    break;
                case BusinessServicTypeWaitPay://待付款
                    
                    [self businessOrderListPostRequstpayStatus:@"" orderStatus:@"4" storeId:_storeId];
                    
                    break;
                case BusinessServicTypeDealComplete://交易完成
                    
                    [self businessOrderListPostRequstpayStatus:@"" orderStatus:@"3" storeId:_storeId];
                    
                    break;
                case BusinessServicTypeSureReturn://待确认退回
                    
                    [self salesAfterPostRequsteAtStoreId:_storeId];
                    
                    
                    break;
                case BusinessServicTypeSended://已配送
                    
                    [self businessOrderListPostRequstpayStatus:@"" orderStatus:@"2" storeId:_storeId];
                    
                    break;
                case BusinessServicTypeCancelOrder://取消订单
                    
                    [self businessOrderListPostRequstpayStatus:@"" orderStatus:@"-1" storeId:_storeId];
                    
                    
                    break;
//                case BusinessServicTypeWiatOrder://待接单
//                    
//                    [self businessOrderListPostRequstpayStatus:@"" orderStatus:@"8" storeId:_storeId];
//                    
//                    break;
                case BusinessServicTypeWaitSending://待发货
                    [self businessOrderListPostRequstpayStatus:@"" orderStatus:@"9" storeId:_storeId];
                    
                    break;
                case BusinessServicTypeWaitReceived://待收货
                    [self businessOrderListPostRequstpayStatus:@"" orderStatus:@"10" storeId:_storeId];
                    
                    break;
            }
            
            break;
        case SelectTypeCaculater:
            [self caculaterListPostRequset];
            break;
            
    }
    
}
-(UIView *)titleView
{
    if (!_titleView) {
        _titleView = [[UIView alloc]initWithFrame:self.navbar_btn.frame];
        [_titleView addSubview:self.navTitle];
    }
    return _titleView;
}
-(UILabel *)navTitle
{
    if (!_navTitle) {
        _navTitle               = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 140, 30)];
        _navTitle.font =[UIFont systemFontOfSize:14];
        _navTitle.textColor     = HEXCOLOR(0x333333);
        _navTitle.textAlignment = NSTextAlignmentCenter;
    }
    return _navTitle;
}

//自定义导航按钮选择定订单
-(UIButton *)navbar_btn
{
    if (!_navbar_btn) {
        _navbar_btn       = [UIButton buttonWithType:UIButtonTypeCustom];
        _navbar_btn.frame = CGRectMake(0, 0, 140, 30);
        [_navbar_btn setImage:[UIImage imageNamed:@"arrows_down_black"] forState:UIControlStateNormal];
        _navbar_btn.titleLabel.font = [UIFont systemFontOfSize:14];
        [_navbar_btn setTitleColor:HEXCOLOR(0x333333) forState:UIControlStateNormal];
        [_navbar_btn setImageEdgeInsets:UIEdgeInsetsMake(0, 85, 0, 0)];
        [_navbar_btn setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 0,35)];
        [_navbar_btn addTarget:self action:@selector(navigationBarSelectedOther:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _navbar_btn;
}

/**
 @return  背景蒙板
 */
-(UIView *)bgview
{
    if (!_bgview) {
        _bgview =[[ UIView alloc]initWithFrame:CGRectMake(0, 0, KScreenW, KScreenH)];
        _bgview.backgroundColor = RGBA(0, 0, 0, 0.2) ;
        [_bgview addSubview:self.popView];
    }
    return _bgview;
    
}
//弹框初始化
-(BusinessServicPopView *)popView
{
    if (!_popView) {
        _popView =[[BusinessServicPopView alloc]initWithFrame:CGRectMake(0, 0, KScreenW, 50*3) titleArray:_titles];
        _popView.delegate = self;
    }
    return _popView;
}

//配送员列表
-(BusinessSendOrderView *)sendOrderPopView
{
    if (!_sendOrderPopView) {
        _sendOrderPopView               = [[BusinessSendOrderView alloc]initWithFrame:CGRectMake(50, 0, KScreenW - 100, 40+44*5)];
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
        _orderBgview =[[ UIView alloc]initWithFrame:CGRectMake(0, 0, KScreenW, KScreenH)];
        _orderBgview.backgroundColor = RGBA(0, 0, 0, 0.2) ;
        
        
        [_orderBgview addSubview:self.sendOrderPopView];
    }
    return _orderBgview;
    
}
-(NSMutableArray *)progressArray
{
    if (!_progressArray) {
        _progressArray = [NSMutableArray array];
    }
    return _progressArray;
}
-(NSMutableArray *)caculaterArray
{
    if (!_caculaterArray) {
        _caculaterArray = [NSMutableArray array];
    }
    return _caculaterArray;
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

/**
 正选反选
 @param btn 切换
 */
-(void)navigationBarSelectedOther:(UIButton *)btn;
{
    [self.view addSubview:self.bgview];;
}

#pragma mark - 页面切换
-(void)segmentSetting
{
    self.segementPage.selectedSegmentIndex = 0;
    [self.segementPage addTarget:self action:@selector(segmentchangePage:) forControlEvents:UIControlEventValueChanged];
    UIFont *font                          = [UIFont boldSystemFontOfSize:14.0f];
    NSDictionary *attributes              = [NSDictionary dictionaryWithObject:font forKey:NSFontAttributeName];
    [self.segementPage setTitleTextAttributes:attributes forState:UIControlStateNormal];
}
-(void)segmentchangePage:(UISegmentedControl*)segmentPage
{
    NSInteger selectIndex = segmentPage.selectedSegmentIndex;
    _selectPageType       = selectIndex;
    NSLog(@" idex === %ld",selectIndex);
    switch (_selectPageType) {
        case SelectTypeHomePage:
            NSLog(@"点击首页");
        {
            self.navTitle.text  = @"商户送端";
            self.navigationItem.titleView = _titleView;
            self.navbar_btn.hidden = YES;
            self.navTitle.hidden = NO;
            
            [self.homeTableView reloadData];
        }
            break;
            
        case SelectTypeOrderPage:
            NSLog(@"点击订单");
        {
            self.navbar_btn.hidden = NO;
            self.navTitle.hidden = YES;
            
            [self.navbar_btn setTitle:@"待派单" forState:UIControlStateNormal];
            [self.titleView addSubview:self.navbar_btn];
            self.navigationItem.titleView = _titleView;

            [self businessOrderListPostRequstpayStatus:@"" orderStatus:@"0" storeId:_storeId];
            [self.homeTableView reloadData];
        }
            break;
        case SelectTypeCaculater:
            
        {
            self.navTitle.text  = @"结算列表";
            self.navigationItem.titleView = _titleView;
            self.navbar_btn.hidden = YES;
            self.navTitle.hidden = NO;
            
            self.navbar_btn.hidden = YES;
            [self caculaterListPostRequset];
            [self.homeTableView reloadData];
            
        }
            NSLog(@"点击的结算");
            
            break;
        default:
            break;
    }
    
}


#pragma mark  -tableView delegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    NSInteger sectionNum = 2;
    switch (_selectPageType) {//选择了哪个版块
        case SelectTypeHomePage:
            return sectionNum;
            
            break;
        case SelectTypeOrderPage:
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
                    return 1;
                    
                    break;
                case BusinessServicTypeSended://已配送
                    
                    return self.orderListArray.count;
                    break;
                case BusinessServicTypeCancelOrder://取消订单
                    
                    return self.orderListArray.count;
                    break;

                case BusinessServicTypeWaitSending://待发货
                    return self.orderListArray.count;

                    break;
                case BusinessServicTypeWaitReceived://待收货
                    return self.orderListArray.count;

                    break;
            }
            
            break;
        case SelectTypeCaculater:
            
            sectionNum = 1;
            
            break;
    }
    return  sectionNum;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger sectionRow = 2;
    NSMutableArray * goodsArr = [NSMutableArray array];
    if (goodsArr.count > 0) {
        [goodsArr removeAllObjects];
    }
    
    switch (_selectPageType) {//选择了哪个版块
        case SelectTypeHomePage:
            if (section == 0) {
                sectionRow = 1;
            }else{
                sectionRow = 3;
            }
            
            break;
        case SelectTypeOrderPage:
        {

            switch (_servicType) {
                case BusinessServicTypeWaitSendlist://待派单
                {
                    BusinessOrderlist * orderlist = self.orderListArray[section];
                    for (BusinessOrdergoods * goods in orderlist.orderGoods) {
                        [goodsArr addObject:goods];
                    }
                    sectionRow = goodsArr.count;
                }
                    break;
                case BusinessServicTypeSending://配送中
                {
                    BusinessOrderlist * orderlist = self.orderListArray[section];
                    for (BusinessOrdergoods * goods in orderlist.orderGoods) {
                        [goodsArr addObject:goods];
                    }
                    sectionRow = goodsArr.count;
                }
                    break;
                case BusinessServicTypeWaitPay://待付款
                {
                    BusinessOrderlist * orderlist = self.orderListArray[section];
                    for (BusinessOrdergoods * goods in orderlist.orderGoods) {
                        [goodsArr addObject:goods];
                    }
                    sectionRow = goodsArr.count;
                }
                    break;
                case BusinessServicTypeDealComplete://交易完成
                {
                    BusinessOrderlist * orderlist = self.orderListArray[section];
                    for (BusinessOrdergoods * goods in orderlist.orderGoods) {
                        [goodsArr addObject:goods];
                    }
                    sectionRow = goodsArr.count;
                }
                    break;
                case BusinessServicTypeSureReturn://待确认退回
                    
                    sectionRow = self.progressArray.count;
                    
                    break;
                case BusinessServicTypeSended://已配送
                {
                    BusinessOrderlist * orderlist = self.orderListArray[section];
                    for (BusinessOrdergoods * goods in orderlist.orderGoods) {
                        [goodsArr addObject:goods];
                    }
                    sectionRow = goodsArr.count;
                }
                    break;
                case BusinessServicTypeCancelOrder://取消订单
                    
                {
                    BusinessOrderlist * orderlist = self.orderListArray[section];
                    for (BusinessOrdergoods * goods in orderlist.orderGoods) {
                        [goodsArr addObject:goods];
                    }
                    sectionRow = goodsArr.count;
                }
                    break;

 
                    break;
                case BusinessServicTypeWaitSending://待发货
                {
                    BusinessOrderlist * orderlist = self.orderListArray[section];
                    for (BusinessOrdergoods * goods in orderlist.orderGoods) {
                        [goodsArr addObject:goods];
                    }
                    sectionRow = goodsArr.count;
                }
                    
                    break;
                case BusinessServicTypeWaitReceived://待收货
                {
                    BusinessOrderlist * orderlist = self.orderListArray[section];
                    for (BusinessOrdergoods * goods in orderlist.orderGoods) {
                        [goodsArr addObject:goods];
                    }
                    sectionRow = goodsArr.count;
                }
                    
                    break;
            }
        }
            break;
        case SelectTypeCaculater:
            
            sectionRow = self.caculaterArray.count;
            break;
            
    }
    return sectionRow;
    
}
//单元格高度
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat height = 0;
    switch (_selectPageType) {
        case SelectTypeHomePage:
            if (indexPath.section == 0) {
                
                height = 210;
            }
            else{
                
                height = 130;
            }
            
            break;
        case SelectTypeOrderPage:
            switch (_servicType) {
                case BusinessServicTypeWaitSendlist://待派单
                    height = k_cellHeight;
                    
                    break;
                case BusinessServicTypeSending://配送中
                    height = k_cellHeight;

                    break;
                case BusinessServicTypeWaitPay://待付款
                    height = k_cellHeight;

                    break;
                case BusinessServicTypeDealComplete://交易完成
                    height = k_cellHeight;

                    break;
                case BusinessServicTypeSureReturn://待确认退回
                    height = 180;
                    
                    break;
                case BusinessServicTypeSended://已配送
                    height = k_cellHeight;

                    break;
                case BusinessServicTypeCancelOrder://取消订单
                    
                    height = k_cellHeight;
                    break;

                case BusinessServicTypeWaitSending://待发货
                    height = k_cellHeight;

                    break;
                case BusinessServicTypeWaitReceived://待收货
                    height = k_cellHeight;

                    break;
            }
            
            break;
        case SelectTypeCaculater:
            
            height = 185;
            break;
            
    }
    return height;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView  * view = nil;
    switch (_selectPageType) {
        case SelectTypeHomePage:
        {
            if (section == 0) {
                return view;
            }
            
            if (view == nil ) {
                view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, KScreenW, 44)];
                view.backgroundColor = HEXCOLOR( 0xf7f7f7);
                UILabel * info = [[UILabel alloc]initWithFrame:view.frame];
                info.text  = @"统计信息";
                info.font = SYSTEMFONT(14);
                info.textAlignment = NSTextAlignmentCenter;
                info.textColor = HEXCOLOR(0x8d8d8d);
                [view addSubview:info];
            }
            return view;
        }
            break;
        case SelectTypeOrderPage:
        {
            ZFTitleCell * titleCell = [self.homeTableView
                                       dequeueReusableCellWithIdentifier:@"ZFTitleCell"];
            switch (_servicType) {
                case BusinessServicTypeWaitSendlist://待派单
                {
                    
                    BusinessOrderlist  * orderlist = self.orderListArray[section];
                    titleCell.businessOrder        = orderlist;
                    [titleCell.statusButton setTitle:orderlist.orderStatusName forState:UIControlStateNormal];
                    return titleCell;
                }
                    
                    break;
                case BusinessServicTypeSending://配送中
                {
                    
                    BusinessOrderlist  * orderlist = self.orderListArray[section];
                    titleCell.businessOrder        = orderlist;
                    [titleCell.statusButton setTitle:orderlist.orderStatusName forState:UIControlStateNormal];
                    
                    return titleCell;
                }
                    break;
                case BusinessServicTypeWaitPay://待付款
                {
                    
                    BusinessOrderlist  * orderlist = self.orderListArray[section];
                    titleCell.businessOrder        = orderlist;
                    titleCell.lb_payMethod.text    = orderlist.payModeName;
                    [titleCell.statusButton setTitle:orderlist.orderStatusName forState:UIControlStateNormal];
                    
                    return titleCell;
                }
                    break;
                case BusinessServicTypeDealComplete://交易完成
                {
                    
                    BusinessOrderlist  * orderlist = self.orderListArray[section];
                    titleCell.businessOrder        = orderlist;
                    [titleCell.statusButton setTitle:orderlist.orderStatusName forState:UIControlStateNormal];
                    
                    return titleCell;
                }
                    break;
                case BusinessServicTypeSureReturn://待确认退回
                  
                    return view;

                    break;
                case BusinessServicTypeSended://已配送
                {
                    BusinessOrderlist  * orderlist = self.orderListArray[section];
                    [titleCell.statusButton setTitle:orderlist.orderStatusName forState:UIControlStateNormal];
                    
                    titleCell.businessOrder = orderlist;
                    return titleCell;
                }
                    
                    break;
                case BusinessServicTypeCancelOrder://取消订单
                    
                {
                    BusinessOrderlist  * orderlist = self.orderListArray[section];
                    [titleCell.statusButton setTitle:orderlist.orderStatusName forState:UIControlStateNormal];
                    
                    titleCell.businessOrder = orderlist;
                    return titleCell;
                }
                    break;

                case BusinessServicTypeWaitSending://待发货
                {
                    BusinessOrderlist  * orderlist = self.orderListArray[section];
                    [titleCell.statusButton setTitle:orderlist.orderStatusName forState:UIControlStateNormal];
                    
                    titleCell.businessOrder = orderlist;
                    return titleCell;
                }
                    break;
                case BusinessServicTypeWaitReceived://待收货
                {
                    BusinessOrderlist  * orderlist = self.orderListArray[section];
                    [titleCell.statusButton setTitle:orderlist.orderStatusName forState:UIControlStateNormal];
                    
                    titleCell.businessOrder = orderlist;
                    return titleCell;
                }
                    break;
            }
        }
            break;
        case SelectTypeCaculater:
            
            return view;
            break;
    }
    return view;
}
//设置headView视图
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    CGFloat height = 0.001;
    switch (_selectPageType) {
        case SelectTypeHomePage:
            if (section == 0) {
                
                height = 0.001;
            }else{
                
                height = 41;
            }
            
            break;
        case SelectTypeOrderPage:
            switch (_servicType) {
                    
                case BusinessServicTypeWaitSendlist://待派单
                    height = k_sectionHeight;
                    
                    break;
                case BusinessServicTypeSending://配送中
                    height = k_sectionHeight;
                    
                    break;
                case BusinessServicTypeWaitPay://待付款
                    height = k_sectionHeight;
                    
                    break;
                case BusinessServicTypeDealComplete://交易完成
                    height = k_sectionHeight;
                    
                    break;
                case BusinessServicTypeSureReturn://待确认退回
                    height = 0;
                    
                    break;
                case BusinessServicTypeSended://已配送
                    height = k_sectionHeight;
                    
                    break;
                case BusinessServicTypeCancelOrder://取消订单
                    
                    height = k_sectionHeight;

                    break;

                case BusinessServicTypeWaitSending://待发货
                    height = k_sectionHeight;

                    break;
                case BusinessServicTypeWaitReceived://待收货
                    height = k_sectionHeight;

                    break;
            }
            break;
        case SelectTypeCaculater:
            height = 10;
            break;
    }
    return height;
    
}

//设置footerView视图
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView * footerView = nil;
    switch (_selectPageType) {
        case SelectTypeHomePage:
            
            return footerView;
            break;
        case SelectTypeOrderPage:
        {
            switch (_servicType)
            {
                case BusinessServicTypeWaitSendlist://待派单
                {
                    ZFFooterCell * cell = [self.homeTableView
                                           dequeueReusableCellWithIdentifier:@"ZFFooterCell"];
                    cell.footDelegate = self;
 
                    BusinessOrderlist  * orderlist = self.orderListArray[section];
                    cell.businessOrder             = orderlist;
                    cell.section                   = section;

                    //默认值
                    if ([orderlist.deliveryType isEqualToString:@"1"]) {
                        [cell.cancel_button setTitle:@"取消订单" forState:UIControlStateNormal];
                        [cell.payfor_button setTitle:@"派单" forState:UIControlStateNormal];
                    }
                    else {
                        [cell.cancel_button setTitle:@"取消订单" forState:UIControlStateNormal];
                        [cell.payfor_button setTitle:@"配送完成" forState:UIControlStateNormal];
                    }
 
 
                    footerView = cell;
                    
                }
                    break;
                case BusinessServicTypeSending://配送中
                {
                    ZFFooterCell * cell = [self.homeTableView
                                           dequeueReusableCellWithIdentifier:@"ZFFooterCell"];
                    cell.footDelegate = self;
                    //没获取 当前的 indexPath
                    cell.section = section;
                    [cell.cancel_button setHidden: YES];
                    [cell.payfor_button setHidden:YES];
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
                    cell.section = section;
                    //没获取 当前的 indexPath
                    //payStatus 0.未支付的初始状态 1.支付成功 -1.支付失败 3.付款发起 4.付款取消 (待付款) 5.退款成功（支付成功的）6.退款发起(支付成功)
                    if (orderlist.payType == 1) {// 0线上支付 1线下支付
                        [cell.cancel_button setTitle:@"取消订单" forState:UIControlStateNormal];
                        [cell.payfor_button setTitle:@"待确认取货" forState:UIControlStateNormal];
                    }else{
                        [cell.cancel_button setHidden: YES];
                        [cell.payfor_button setTitle:@"取消订单" forState:UIControlStateNormal];
                    }
       
                    
                    footerView = cell;
                    
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
                    //没获取 当前的 indexPath
                    cell.section = section;
                    [cell.payfor_button setTitle:@"晒单" forState:UIControlStateNormal];
                    
                    footerView = cell;
                    
                }
                    
                    break;
                case BusinessServicTypeSureReturn://待确认退回
                    
                    return footerView;
                
                    break;
                case BusinessServicTypeSended://已配送
                {
                    ZFFooterCell * cell = [self.homeTableView
                                           dequeueReusableCellWithIdentifier:@"ZFFooterCell"];
                    cell.footDelegate              = self;
                    BusinessOrderlist  * orderlist = self.orderListArray[section];
                    cell.businessOrder             = orderlist;
                    //没获取 当前的 indexPath
                    cell.section = section;
                    [cell.payfor_button setHidden:YES];
                    [cell.cancel_button setHidden:YES];
                    footerView = cell;
                    
                }
                    break;
                case BusinessServicTypeCancelOrder://取消订单
                {
                    ZFFooterCell * cell = [self.homeTableView
                                           dequeueReusableCellWithIdentifier:@"ZFFooterCell"];
                    cell.footDelegate              = self;
                    BusinessOrderlist  * orderlist = self.orderListArray[section];
                    cell.businessOrder             = orderlist;
                    //没获取 当前的 indexPath
                    cell.section = section;
                    [cell.payfor_button setHidden:YES];
                    [cell.cancel_button setHidden:YES];
                    footerView = cell;
                }
                    
                    break;
//                case BusinessServicTypeWiatOrder://待配送
//                {
//                    ZFFooterCell * cell = [self.homeTableView
//                                           dequeueReusableCellWithIdentifier:@"ZFFooterCell"];
//                    cell.footDelegate              = self;
//                    BusinessOrderlist  * orderlist = self.orderListArray[section];
//                    cell.businessOrder             = orderlist;
//                    //没获取 当前的 indexPath
//                    cell.section = section;
//                    [cell.payfor_button setHidden:YES];
//                    [cell.cancel_button setHidden:YES];
//                    footerView = cell;
//                }
//                    break;
                case BusinessServicTypeWaitSending://待发货
                {
                    ZFFooterCell * cell = [self.homeTableView
                                           dequeueReusableCellWithIdentifier:@"ZFFooterCell"];
                    cell.footDelegate              = self;
                    BusinessOrderlist  * orderlist = self.orderListArray[section];
                    cell.businessOrder             = orderlist;
                    //没获取 当前的 indexPath
                    cell.section = section;
       
                    //默认值
                    if ([orderlist.deliveryType isEqualToString:@"2"]) {
                        [cell.payfor_button  setTitle:@"发货" forState:UIControlStateNormal];
                        [cell.cancel_button  setHidden:YES];

                    }
                    footerView = cell;
                }
                    break;
                case BusinessServicTypeWaitReceived://待收货
                {
                    ZFFooterCell * cell = [self.homeTableView
                                           dequeueReusableCellWithIdentifier:@"ZFFooterCell"];
                    cell.footDelegate              = self;
                    BusinessOrderlist  * orderlist = self.orderListArray[section];
                    cell.businessOrder             = orderlist;
                    //没获取 当前的 indexPath
                    cell.section = section;
                    [cell.payfor_button setHidden:YES];
                    [cell.cancel_button setHidden:YES];
                    footerView = cell;
                }
                    break;
            }
            
            
        }
            break;
        case SelectTypeCaculater:
            
            return footerView ;
            break;
    }
    return footerView;
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    CGFloat height = 0.001;
    switch (_selectPageType) {
        case SelectTypeHomePage:
            
            break;
        case SelectTypeOrderPage:
            
            switch (_servicType) {
                case BusinessServicTypeWaitSendlist://待派单
                    height = k_footHeight;
                    break;
                case BusinessServicTypeSending://配送中
                    height = k_footHeight;
                    
                    break;
                case BusinessServicTypeWaitPay://待付款
                    height = k_footHeight;
                    
                    break;
                case BusinessServicTypeDealComplete://交易完成
                    height = k_footHeight;
                    
                    break;
                case BusinessServicTypeSureReturn://待确认退回
                    height = 0;
                    
                    break;
                case BusinessServicTypeSended://已配送
                    height = k_footHeight;
                    
                    break;
                case BusinessServicTypeCancelOrder://
                    height = k_footHeight;
                    
                    break;
//                case BusinessServicTypeWiatOrder://待配送
//                    height = k_footHeight;
//
//                    break;
                case BusinessServicTypeWaitSending://待发货
                    height = k_footHeight;

                    break;
                case BusinessServicTypeWaitReceived://待收货
                    height = k_footHeight;

                    break;
            }
            
            break;
        case SelectTypeCaculater:
            
            height = 0;
            
            break;
            
    }
    
    return height;
    
}

#pragma mark - ZFSendHomeListCellDelegate 订单详情的代理
///日统计
-(void)todayOrderDetial{
    NSLog(@"--a--1");
    
    OrderStatisticsViewController * orderDatil = [[OrderStatisticsViewController alloc]init];
    orderDatil.orderNum                        = _dayorder_count;//订单数;
    orderDatil.dealPrice                       =[NSString stringWithFormat:@"%.2f",[_dayorder_amount floatValue]]; ;//订单金额数;
    orderDatil.starTime                        = _daystart_time;
    orderDatil.endTime                         = _dayend_time;
    orderDatil.storeId                         = _storeId;
    [self.navigationController pushViewController:orderDatil animated:NO];
    
    
}
///周统计
-(void)weekOrderDetial
{
    NSLog(@"--a--2");
    OrderStatisticsViewController * orderDatil = [[OrderStatisticsViewController alloc]init];
    orderDatil.orderNum                        = _weekorder_count ;//订单数;
    orderDatil.dealPrice                       = _weekorder_amount;//订单金额数;
    orderDatil.storeId                         = _storeId;
    orderDatil.starTime                        = _weekstart_time;
    orderDatil.endTime                         = _weekend_time;
    
    [self.navigationController pushViewController:orderDatil animated:NO];
    
}

///月统计
-(void)monthOrderDetial
{
    OrderStatisticsViewController * orderDatil = [[OrderStatisticsViewController alloc]init];
    orderDatil.storeId                         = _storeId;
    orderDatil.orderNum                        = _monthorder_count;//订单数;
    orderDatil.dealPrice                       = _monthorder_amount;//订单金额数;
    orderDatil.starTime                        = _monthstart_time;
    orderDatil.endTime                         = _monthend_time;
    [self.navigationController pushViewController:orderDatil animated:NO];
    
    NSLog(@"--a--3");
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (_selectPageType) {
        case SelectTypeHomePage:
        {
            if (indexPath.section == 0) {
                
                SendStatisticsHeaderCell *titleCell = [self.homeTableView
                                                       dequeueReusableCellWithIdentifier:@"SendStatisticsHeaderCell"];
                titleCell.lb_orderNum.text = _order_count;
                return titleCell;
                
            }else{
                SendStatisticsContentCell * cell = [self.homeTableView dequeueReusableCellWithIdentifier:@"SendStatisticsContentCell" forIndexPath:indexPath];
                if (indexPath.row == 0) {
                    cell.lb_stautus.text = @"今日配送";
                    //日
                    cell.lb_sendTime.text = _daydate_time;
                    cell.lb_sendCount.text  = _dayorder_count;
                    cell.lb_sendFee.text =  [NSString stringWithFormat:@"%.2f",[_dayorder_amount floatValue]];
                    
                }else if (indexPath.row == 1)
                {
                    cell.lb_stautus.text = @"7日配送";
                    
                    //周
                    cell.lb_sendTime.text = _weekodate_time;
                    cell.lb_sendCount.text  = _weekorder_count;
                    cell.lb_sendFee.text = _weekorder_amount;
                    
                }
                else{
                    cell.lb_stautus.text = @"30日配送";
                    //月
                    cell.lb_sendTime.text = _monthodate_time;
                    cell.lb_sendCount.text  = _monthorder_count;
                    cell.lb_sendFee.text = _monthorder_amount ;
                    
                }
           
                return cell;
               }
        }
            break;
        case SelectTypeOrderPage:
            switch (_servicType) {
                    
                case BusinessServicTypeWaitSendlist://待派单
                {
                    ZFSendingCell * contentCell = [self.homeTableView dequeueReusableCellWithIdentifier:@"ZFSendingCell" forIndexPath:indexPath];
                    
                    BusinessOrderlist  * orderlist = self.orderListArray[indexPath.section];
                    NSMutableArray * goodArray     = [NSMutableArray array];
                    for (BusinessOrdergoods * goods in orderlist.orderGoods) {
                        [goodArray  addObject:goods];
                    }
                    
                    BusinessOrdergoods * goods = goodArray[indexPath.row];
                    contentCell.businesGoods   = goods;
                    
                    
                    return contentCell;
                }
                    break;
                case BusinessServicTypeSending://配送中
                {
                    ZFSendingCell * contentCell = [self.homeTableView dequeueReusableCellWithIdentifier:@"ZFSendingCell" forIndexPath:indexPath];
                    
                    BusinessOrderlist  * orderlist = self.orderListArray[indexPath.section];
                    NSMutableArray * goodArray     = [NSMutableArray array];
                    for (BusinessOrdergoods * goods in orderlist.orderGoods) {
                        [goodArray  addObject:goods];
                    }
                    
                    BusinessOrdergoods * goods = goodArray[indexPath.row];
                    contentCell.businesGoods   = goods;
                    
                    return contentCell;
                    
                }
                    break;
                case BusinessServicTypeWaitPay://待付款
                {
                    ZFSendingCell * contentCell = [self.homeTableView dequeueReusableCellWithIdentifier:@"ZFSendingCell" forIndexPath:indexPath];
                    
                    BusinessOrderlist  * orderlist = self.orderListArray[indexPath.section];
                    NSMutableArray * goodArray     = [NSMutableArray array];
                    for (BusinessOrdergoods * goods in orderlist.orderGoods) {
                        [goodArray  addObject:goods];
                    }
                    BusinessOrdergoods * goods = goodArray[indexPath.row];
                    contentCell.businesGoods   = goods;
                    
                    
                    return contentCell;
                    
                }
                    break;
                case BusinessServicTypeDealComplete://交易完成
                {
                    ZFSendingCell * contentCell = [self.homeTableView dequeueReusableCellWithIdentifier:@"ZFSendingCell" forIndexPath:indexPath];
                    
                    BusinessOrderlist  * orderlist = self.orderListArray[indexPath.section];
                    NSMutableArray * goodArray     = [NSMutableArray array];
                    for (BusinessOrdergoods * goods in orderlist.orderGoods) {
                        [goodArray  addObject:goods];
                    }
                    
                    BusinessOrdergoods * goods = goodArray[indexPath.row];
                    contentCell.businesGoods   = goods;
                    
                    return contentCell;
                    
                }
                    break;
                case BusinessServicTypeSureReturn://待确认退回
                {
                    ZFCheckTheProgressCell *checkCell = [self.zfb_tableView dequeueReusableCellWithIdentifier:@"ZFCheckTheProgressCell" forIndexPath:indexPath];
                    List * progress                   = self.progressArray[indexPath.row];
                    checkCell.deldegate               = self;
                    [checkCell.checkProgress_btn  setTitle:@"确认退回" forState:UIControlStateNormal];
                    checkCell.progressList = progress;
                    checkCell.indexpath    = indexPath.row;
                    return  checkCell;
                    
                    
                }
                    break;
                case BusinessServicTypeSended://已配送
                {
                    ZFSendingCell * contentCell = [self.homeTableView dequeueReusableCellWithIdentifier:@"ZFSendingCell" forIndexPath:indexPath];
                    
                    BusinessOrderlist  * orderlist = self.orderListArray[indexPath.section];
                    NSMutableArray * goodArray     = [NSMutableArray array];
                    for (BusinessOrdergoods * goods in orderlist.orderGoods) {
                        [goodArray  addObject:goods];
                    }
                    
                    BusinessOrdergoods * goods = goodArray[indexPath.row];
                    contentCell.businesGoods   = goods;
                    return contentCell;
                    
                }
                    break;
                case BusinessServicTypeCancelOrder://取消订单
                {
                    ZFSendingCell * contentCell = [self.homeTableView dequeueReusableCellWithIdentifier:@"ZFSendingCell" forIndexPath:indexPath];
                    
                    BusinessOrderlist  * orderlist = self.orderListArray[indexPath.section];
                    NSMutableArray * goodArray     = [NSMutableArray array];
                    for (BusinessOrdergoods * goods in orderlist.orderGoods) {
                        [goodArray  addObject:goods];
                    }
                    
                    BusinessOrdergoods * goods = goodArray[indexPath.row];
                    contentCell.businesGoods   = goods;
                    return contentCell;
                    
                }
                    break;
 
//
//                case BusinessServicTypeWiatOrder://待配送
//                {
//                    ZFSendingCell * contentCell = [self.homeTableView dequeueReusableCellWithIdentifier:@"ZFSendingCell" forIndexPath:indexPath];
//
//                    BusinessOrderlist  * orderlist = self.orderListArray[indexPath.section];
//                    NSMutableArray * goodArray     = [NSMutableArray array];
//                    for (BusinessOrdergoods * goods in orderlist.orderGoods) {
//                        [goodArray  addObject:goods];
//                    }
//
//                    BusinessOrdergoods * goods = goodArray[indexPath.row];
//                    contentCell.businesGoods   = goods;
//                    return contentCell;
//
//                }
//                    break;
                case BusinessServicTypeWaitSending://待发货
                {
                    ZFSendingCell * contentCell = [self.homeTableView dequeueReusableCellWithIdentifier:@"ZFSendingCell" forIndexPath:indexPath];
                    
                    BusinessOrderlist  * orderlist = self.orderListArray[indexPath.section];
                    NSMutableArray * goodArray     = [NSMutableArray array];
                    for (BusinessOrdergoods * goods in orderlist.orderGoods) {
                        [goodArray  addObject:goods];
                    }
                    
                    BusinessOrdergoods * goods = goodArray[indexPath.row];
                    contentCell.businesGoods   = goods;
                    return contentCell;
                }
                    break;
                case BusinessServicTypeWaitReceived://待收货
                {
                    ZFSendingCell * contentCell = [self.homeTableView dequeueReusableCellWithIdentifier:@"ZFSendingCell" forIndexPath:indexPath];
                    
                    BusinessOrderlist  * orderlist = self.orderListArray[indexPath.section];
                    NSMutableArray * goodArray     = [NSMutableArray array];
                    for (BusinessOrdergoods * goods in orderlist.orderGoods) {
                        [goodArray  addObject:goods];
                    }
                    
                    BusinessOrdergoods * goods = goodArray[indexPath.row];
                    contentCell.businesGoods   = goods;
                    return contentCell;
                }
                    break;
            }
            break;
            
        case SelectTypeCaculater:
        {
            BusinessSendAccountCell * accountCell = [self.homeTableView dequeueReusableCellWithIdentifier:@"BusinessSendAccountCell" forIndexPath:indexPath];
            Settlementlist * list                 = self.caculaterArray[indexPath.row];
            accountCell.cacuList                  = list;
            return  accountCell;
        }
            break;
    }
    return nil;
}

#pragma mark - didSelectRowAtIndexPath

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"section  =%ld , row = %ld",indexPath.section ,indexPath.row);
    
    switch (_selectPageType) {
        case SelectTypeHomePage:
            if (indexPath.section == 0) {
                
                self.segementPage.selectedSegmentIndex = 1;
                [self segmentchangePage:self.segementPage];
            }else{
                if (indexPath.row == 0) {
                    [self todayOrderDetial];
                    
                }else if (indexPath.row == 1)
                {
                    [self weekOrderDetial];
                }
                else{
                    
                    [self monthOrderDetial];
                    
                }
            }
            
            break;
        case SelectTypeOrderPage:
        {
            BusinessOrderlist * storelist          = self.orderListArray[indexPath.section];
            ZFDetailOrderViewController * detailVC = [ZFDetailOrderViewController new];
            NSMutableArray * goodArray             = [NSMutableArray array];
            for (BusinessOrdergoods * goods in storelist.orderGoods) {
                [goodArray  addObject:goods];
            }
            BusinessOrdergoods * goods = goodArray[indexPath.row];
            detailVC.cmOrderid = goods.order_id;
            detailVC.goodsId   = goods.goodsId;
            detailVC.storeId   = storelist.storeId;
            detailVC.imageUrl  = goods.coverImgUrl;
            
            switch (_servicType) {
                case BusinessServicTypeWaitSendlist://待派单
                    
                    [self.navigationController pushViewController:detailVC animated:NO];
             
                    break;
                case BusinessServicTypeSending://配送中
 
                    [self.navigationController pushViewController:detailVC animated:NO];
                    
                    break;
                case BusinessServicTypeWaitPay://待付款
 
                    [self.navigationController pushViewController:detailVC animated:NO];
            
                    
                    break;
                case BusinessServicTypeDealComplete://交易完成
 
                    [self.navigationController pushViewController:detailVC animated:NO];
                    
                    break;
                case BusinessServicTypeSureReturn://待确认退回
                    
                    
                    break;
                case BusinessServicTypeSended://已配送
     
                    [self.navigationController pushViewController:detailVC animated:NO];
                    
                    break;
                case BusinessServicTypeCancelOrder://待配送
 
                    [self.navigationController pushViewController:detailVC animated:NO];
                    break;
                    
//                case BusinessServicTypeWiatOrder://待配送
//
//
//                    [self.navigationController pushViewController:detailVC animated:NO];
//                    break;
                case BusinessServicTypeWaitSending://待发货
                    [self.navigationController pushViewController:detailVC animated:NO];

                    break;
                case BusinessServicTypeWaitReceived://待收货
                    [self.navigationController pushViewController:detailVC animated:NO];

                    break;
            }
            
        }
            break;
        case SelectTypeCaculater:
            
            break;
            
    }
    
}


#pragma mark - BusinessServicPopViewDelegate 选择切换type
-(void)sendTitle:(NSString *)title businessServicType:(BusinessServicType)type
{
//    self.currentPage = 1;
    _servicType = type;//赋值type ，根据type请求
    [self.navbar_btn setTitle:title forState:UIControlStateNormal];
    
//    NSIndexPath *indexpath = [NSIndexPath indexPathForRow:0 inSection:0];
//    [self.homeTableView scrollToRowAtIndexPath:indexpath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
//
    
    [UIView animateWithDuration:0.3 animations:^{
        if (self.bgview.superview) {
            [self.bgview removeFromSuperview];
        }
    }];
    [self headerRefresh];

//    switch (_selectPageType) {
//        case SelectTypeHomePage:
//
//            break;
//        case SelectTypeOrderPage:
//            _servicType = type;//把类型赋值一下
//            switch (_servicType) {
//                case BusinessServicTypeWaitSendlist://待派单
//
//                    [self businessOrderListPostRequstpayStatus:@"" orderStatus:@"0"  storeId:_storeId];
//
//                    [self.homeTableView reloadData];
//
//                    break;
//                case BusinessServicTypeSending://配送中
//
//                    [self businessOrderListPostRequstpayStatus:@"" orderStatus:@"1"  storeId:_storeId] ;
//                    [self.homeTableView reloadData];
//
//                    break;
//                case BusinessServicTypeWaitPay://待付款
//
//                    [self businessOrderListPostRequstpayStatus:@"" orderStatus:@"4"  storeId:_storeId];
//                    [self.homeTableView reloadData];
//
//                    break;
//                case BusinessServicTypeDealComplete://交易完成
//
//                    [self businessOrderListPostRequstpayStatus:@"" orderStatus:@"3"  storeId:_storeId];
//                    [self.homeTableView reloadData];
//
//                    break;
//                case BusinessServicTypeSureReturn://待确认退回
//
//                    [self salesAfterPostRequsteAtStoreId:_storeId];
//
//                    [self.homeTableView reloadData];
//
//                    break;
//                case BusinessServicTypeSended://已配送
//                    [self businessOrderListPostRequstpayStatus:@"" orderStatus:@"2"  storeId:_storeId];
//                    [self.homeTableView reloadData];
//
//                    break;
//                case BusinessServicTypeCancelOrder://取消订单
//                    [self businessOrderListPostRequstpayStatus:@"" orderStatus:@"-1"  storeId:_storeId];
//                    [self.homeTableView reloadData];
//
//                    break;
//
////                case  BusinessServicTypeWiatOrder://待接单
////                    [self businessOrderListPostRequstpayStatus:@"" orderStatus:@"8"   storeId:_storeId];
////                    [self.homeTableView reloadData];
////                    break;
//                case BusinessServicTypeWaitSending://待发货
//                    [self businessOrderListPostRequstpayStatus:@"" orderStatus:@"9"   storeId:_storeId];
//                    [self.homeTableView reloadData];
//                    break;
//                case BusinessServicTypeWaitReceived://待收货
//                    [self businessOrderListPostRequstpayStatus:@"" orderStatus:@"10"   storeId:_storeId];
//                    [self.homeTableView reloadData];
//                    break;
//
//            }
//
//            break;
//        case SelectTypeCaculater:
//
//            break;
//    }
}

#pragma mark - ZFFooterCellDelegate   footerview的所有代理方法
-(void)cancelOrderActionbyOrderNum:(NSString *)orderNum orderStatus:(NSString *)orderStatus payStatus:(NSString *)payStatus deliveryId:(NSString *)deliveryId indexPath:(NSInteger)indexPath
{//取消操作
    NSLog(@"取消操作")
    NSLog(@"--------------%ld----------",indexPath);
    
    switch (_selectPageType) {
        case SelectTypeHomePage:
            
            break;
        case SelectTypeOrderPage:
            switch (_servicType) {
                case BusinessServicTypeWaitSendlist:
                {
                    JXTAlertController * alertavc =[JXTAlertController alertControllerWithTitle:@"提示" message:@"是否取消该订单！" preferredStyle:UIAlertControllerStyleAlert];
                    UIAlertAction * cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                        
                    }];
                    UIAlertAction * sureAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
                        
                        //确认后调用该接口 取消订单
                        [self cancleOrderPostWithOrderNum:orderNum orderStatus:@"-1" payStatus:payStatus deliveryId:deliveryId];
                        
                    }];
                    [alertavc addAction:cancelAction];
                    [alertavc addAction:sureAction];
                    
                    [self presentViewController:alertavc animated:YES completion:nil];
                    
                }
                    
                    break;
                case BusinessServicTypeSending:
                    
                    break;
                case BusinessServicTypeWaitPay:
                {
                    JXTAlertController * alertavc =[JXTAlertController alertControllerWithTitle:@"提示" message:@"是否取消该订单！" preferredStyle:UIAlertControllerStyleAlert];
                    UIAlertAction * cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                        
                    }];
                    UIAlertAction * sureAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
                        
                        //确认后调用该接口 取消订单
                        [self cancleOrderPostWithOrderNum:orderNum orderStatus:@"-1" payStatus:payStatus deliveryId:deliveryId];
                        
                    }];
                    [alertavc addAction:cancelAction];
                    [alertavc addAction:sureAction];
                    
                    [self presentViewController:alertavc animated:YES completion:nil];
                }
                    break;
                case BusinessServicTypeDealComplete:
                    
                    break;
                case BusinessServicTypeSureReturn:
                    
                    break;
                case BusinessServicTypeSended:
                    
                    break;
                case BusinessServicTypeCancelOrder://
                    
                    break;
//                case BusinessServicTypeWiatOrder://待配送
//
//                    break;
                case BusinessServicTypeWaitSending://待发货
              
                    break;
                case BusinessServicTypeWaitReceived://待收货
                    
                    break;
            }
            break;
        case SelectTypeCaculater:
            
            break;
    }
}

#pragma mark -   确认退回代理 
/** * 确认退货代理 */
-(void)progressWithCheckoutIndexPath:(NSInteger)indexpath
{
    List * progress              = self.progressArray[indexpath];
    JXTAlertController * alertvc = [JXTAlertController alertControllerWithTitle:@"是否确认退货？" message:nil preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction * cancle =[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    UIAlertAction * sure =[UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        NSLog(@"点击了确认退货");
        [self returnBackStoreConfirmReceiptPostRequstAtOrderNum:progress.orderNum afterServiceId:progress.saleId goodsId:progress.goodsId orderGoodsId:progress.orderGoodsId goodsCount:[NSString stringWithFormat:@"%ld",progress.goodsCount] refund:progress.refund userId:progress.userId];
        
    }];
    
    [alertvc addAction:sure];
    [alertvc addAction:cancle];
    [self presentViewController:alertvc animated:NO completion:^{
        
    }];
    
    
    
}
#pragma mark - ZFFooterCellDelegate  payfor_button 派单代理
///派单列表添加   自定义tableview
-(void)sendOrdersActionOrderId:(NSString*)orderId totalPrice:(NSString *)totalPrice  indexPath :(NSInteger )indexPath
{
    _order_id       = orderId;
    _order_amount   = totalPrice;//当前总价
    NSLog(@"  currentSection ====%ld ",indexPath);
    _currentSection = indexPath;
    
    BusinessOrderlist * orderlist = self.orderListArray[indexPath];
    switch (_selectPageType) {
        case SelectTypeHomePage:
            break;
            
        case SelectTypeOrderPage:
            switch (_servicType) {
                case BusinessServicTypeWaitSendlist:
                     // deliveryType 配送类型：1 配送员配送 ----派单   2 快递-----发货  3 商家配送--按钮配送完成
                {
                    NSLog(@"派单操作 - orderId =%@ ,totalPrice         = %@ ",_order_id,_order_amount);
//                    [self selectDeliveryListPostRequst];//请求配送员接口
                    ////warn ------- 选择派单
                    if ( [orderlist.deliveryType isEqualToString:@"1"]){//派单
                        JXTAlertController * alertvc = [JXTAlertController alertControllerWithTitle:@"确认要立刻派单吗?" message:nil preferredStyle:UIAlertControllerStyleAlert];
                        
                        UIAlertAction * cancle =[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                            
                        }];
                        UIAlertAction * sure =[UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
                            [self autoSendOrderId:_order_id];
                            
                        }];
                        
                        [alertvc addAction:sure];
                        [alertvc addAction:cancle];
                        [self presentViewController:alertvc animated:NO completion:^{
                            
                        }];

                    }
                    if ([orderlist.deliveryType isEqualToString:@"3"]) {//配送完成
                        
                        [self businessOrderbyOrderId:_order_id];
                    }
   
                }
                    break;
                case BusinessServicTypeSending:
                    
                    break;
                case BusinessServicTypeWaitPay:
                    if (orderlist.payType == 1) {// 0线上支付 1线下支付
                        JXTAlertController * alertvc = [JXTAlertController alertControllerWithTitle:@"用户是否确认取货了？" message:nil preferredStyle:UIAlertControllerStyleAlert];
                        
                        UIAlertAction * cancle =[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                            
                        }];
                        UIAlertAction * sure =[UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
                            ////////// 确认取货
                            NSLog(@"点击了确认取货");
                            [self cancleOrderPostWithOrderNum:orderlist.orderNum orderStatus:@"3" payStatus:orderlist.payStatus deliveryId:orderlist.deliveryId];

                        }];
                        
                        [alertvc addAction:sure];
                        [alertvc addAction:cancle];
                        [self presentViewController:alertvc animated:NO completion:^{
                            
                        }];
                    }else{
                        JXTAlertController * alertvc = [JXTAlertController alertControllerWithTitle:@"确认取消订单 ？" message:nil preferredStyle:UIAlertControllerStyleAlert];
                        
                        UIAlertAction * cancle =[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                            
                        }];
                        UIAlertAction * sure =[UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
                            NSLog(@"点击了确认取消订单");
                            //确认后调用该接口 取消订单
                            [self cancleOrderPostWithOrderNum:orderlist.orderNum orderStatus:@"-1" payStatus:orderlist.payStatus deliveryId:orderlist.deliveryId];
                        }];
                        
                        [alertvc addAction:sure];
                        [alertvc addAction:cancle];
                        [self presentViewController:alertvc animated:NO completion:^{
                            
                        }];
                    }
 
                    break;
                case BusinessServicTypeDealComplete:
                    
                    break;
                case BusinessServicTypeSureReturn:

                    break;
                case BusinessServicTypeSended:
                    
                    break;
                case BusinessServicTypeCancelOrder://
                    
                    break;

                case BusinessServicTypeWaitSending://待发货
                {

                    if ([orderlist.deliveryType isEqualToString:@"2"])
                    {
                        
                        JXTAlertController * alertvc = [JXTAlertController alertControllerWithTitle:@"发货"  message:nil preferredStyle:UIAlertControllerStyleAlert];
                        [alertvc addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
                            textField.placeholder = @"请输入快递公司";
                            [textField addTarget:self action:@selector(expressNameTextFiled:) forControlEvents:UIControlEventEditingChanged];
                        }];
                        [alertvc addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
                            textField.placeholder = @"请输入运单号";
                            [textField addTarget:self action:@selector(expressNumberTextFiled:) forControlEvents:UIControlEventEditingChanged];
                        }];
                        
            
                        UIAlertAction * cancle =[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                            
                        }];
                        UIAlertAction * sure =[UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
                            
                            if (expressName.length > 0 && expressNumber.length >0) {
                                //收货接口 expressName   快递公司名字   expressNumber   快递单号     expressCoding   快递公司编码
                                [self sendGoodsPostOrderId:_order_id expressName:expressName expressNumber:expressNumber expressCoding:@"110"];
                            }else{
                                [self.view makeToast:@"请填写完整信息" duration:2 position:@"center"];
                            }
                        }];
                        
                        [alertvc addAction:sure];
                        [alertvc addAction:cancle];
                        [self presentViewController:alertvc animated:NO completion:^{
                            
                        }];
                    }
                }
                    
                    
                    break;
                case BusinessServicTypeWaitReceived://待收货
                    
                    break;
            }
            
            break;
        case SelectTypeCaculater:
            
            break;
            
    }
    
    
}


#pragma mark --  输入快递公司和订单号
-(void)expressNameTextFiled:(UITextField*)textfield
{
    expressName = textfield.text;
}

-(void)expressNumberTextFiled:(UITextField*)textfield
{
    expressNumber = textfield.text;

}
#pragma mark - BusinessSendOrderViewDelegate 3333 选择派单给谁 派单之前的操作（方法暂时弃用）
-(void)didClickPushdeliveryId:(NSString*)deliveryId
                 deliveryName:(NSString *)deliveryName
                deliveryPhone:(NSString *)deliveryPhone
             orderDeliveryFee:(NSString *)orderDeliveryFee
                        Index:(NSInteger)index
{

    
    
    BusinessOrderlist * orderlist = self.orderListArray[_currentSection];
    NSLog(@"_currentSection  =========   %ld",_currentSection);
    [self sendOrderPostRequstStoreID:_storeId
                          deliveryId:deliveryId
                             orderId:orderlist.order_id
                         postAddress:orderlist.post_address
                            postName:orderlist.post_name
                         orderAmount:orderlist.orderAmount
                        deliveryName:deliveryName
                       deliveryPhone:deliveryPhone
                           postPhone:orderlist.post_phone
                    orderDeliveryFee:orderDeliveryFee];
    
    
}

#pragma mark -  获取商户端数据列表    order/storeHomePage
-(void)storeHomePagePostRequst
{
    
    NSDictionary * param = @{
                             @"storeId": _storeId,
                             };
    
    [MENetWorkManager post:[NSString stringWithFormat:@"%@/order/storeHomePage",zfb_baseUrl] params:param success:^(id response) {
        
        NSString * code = [NSString stringWithFormat:@"%@",response[@"resultCode"]];
        if ([code isEqualToString:@"0"]) {
            
            BusinessHomeModel * homeModel = [BusinessHomeModel mj_objectWithKeyValues:response];
            _order_count                  = homeModel.orderUnpayInfo.order_count;//订单数
            
            _daydate_time    = homeModel.todayOrderInfo.date_time;
            _dayorder_count  = homeModel.todayOrderInfo.order_count;
            _dayorder_amount = homeModel.todayOrderInfo.order_amount;
            _daystart_time   = homeModel.todayOrderInfo.start_time;
            _dayend_time     = homeModel.todayOrderInfo.end_time;
            
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
        
        }
        [self endRefresh];
    } progress:^(NSProgress *progeress) {
    } failure:^(NSError *error) {
        [self endRefresh];
        NSLog(@"error=====%@",error);
        [self.view makeToast:@"网络错误" duration:2 position:@"center"];
    }];
    
    
}


#pragma mark -  获取商户端订单列表       order/getStoreOrderList
/**
 商户端订单列表
 
 @param payStatus 0.未支付的初始状态 1.支付成功 -1.支付失败 3.付款发起 4.付款取消 (待付款) 5.退款成功（支付成功的）6.退款发起(支付成功) 7.退款失败(支付成功)',
 @param orderStatus -1：关闭,0待配送 1配送中 2.配送完成，3交易完成（用户确认收货），4.待付款,5.待审批,6.待退回，7.服务完成
 @re cmUserId 注意：商户端查询订单式 ，该字段不传
 @re searchWord 关键词
 @re startTime 开始时间
 @re endTime 结束时间
 
 */
-(void)businessOrderListPostRequstpayStatus:(NSString *)payStatus
                                orderStatus:(NSString *)orderStatus
                                    storeId:(NSString *)storeId
{ 
    NSDictionary * param = @{
                             @"page": [NSNumber numberWithInteger:self.currentPage],
                             @"size": [NSNumber numberWithInteger:kPageCount],
                             @"orderStatus": orderStatus,
                             @"storeId": storeId,
                             
                             };
    
    [MENetWorkManager post:[NSString stringWithFormat:@"%@/order/getStoreOrderList",zfb_baseUrl] params:param success:^(id response) {
        NSString * code = [NSString stringWithFormat:@"%@",response[@"resultCode"]];
        if ([code isEqualToString:@"0"]) {
            if (self.refreshType == RefreshTypeHeader) {
                if (self.orderListArray.count > 0) {
                    [self.orderListArray removeAllObjects];
                }
            }
            BusinessOrderModel * orderModel = [BusinessOrderModel mj_objectWithKeyValues:response];
            for (BusinessOrderlist * orderlist in orderModel.orderList) {
                [self.orderListArray addObject:orderlist];
            }
            NSLog(@"orderListArray = %@",self.orderListArray);
            [self.homeTableView reloadData];
        
        }
        [self endRefresh];
    } progress:^(NSProgress *progeress) {
    } failure:^(NSError *error) {
        [self endRefresh];
        NSLog(@"error=====%@",error);
        [self.view makeToast:@"网络错误" duration:2 position:@"center"];
    }];
    
    
}
#pragma mark - 结算列表 网络请求    order/getSettlementListById
-(void)caculaterListPostRequset
{
    NSDictionary * param = @{
                             
                             @"settlementCount":@"",
                             @"startSize":[NSNumber numberWithInteger:self.currentPage],
                             @"endSize":[NSNumber numberWithInteger:kPageCount],
                             @"userId":BBUserDefault.cmUserId,
                             @"deliveryId":@"",
                             @"storeId":_storeId,
                             @"orderStartTime":@"",
                             @"orderEndTime":@"",
                             };
    
    [SVProgressHUD show];
    [MENetWorkManager post:[zfb_baseUrl stringByAppendingString:@"/order/getSettlementListById"] params:param success:^(id response) {
        NSString * code = [NSString stringWithFormat:@"%@",response[@"resultCode"]];
        if ([code isEqualToString:@"0"]) {
            if (self.refreshType == RefreshTypeHeader) {
                
                if (self.caculaterArray.count > 0) {
                    
                    [self.caculaterArray removeAllObjects];
                }
            }
            CaculaterModel * caculater = [CaculaterModel mj_objectWithKeyValues:response];
            
            for (Settlementlist * list in caculater.settlementList) {
                
                [self.caculaterArray addObject:list];
            }
            [self.homeTableView reloadData];
            [SVProgressHUD dismiss];
            
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
#pragma mark -  取消订单接口  确认取货    order/updateOrderInfo
-(void)cancleOrderPostWithOrderNum:(NSString *)orderNum orderStatus:(NSString *)orderStatus payStatus:(NSString *)payStatus deliveryId :(NSString *)deliveryId
{
    NSDictionary * param = @{
                             
                             @"orderNum":orderNum,
                             @"orderStatus":orderStatus,
                             @"payStatus":payStatus,
                             @"deliveryId":deliveryId,
                             
                             };
    
    [MENetWorkManager post:[NSString stringWithFormat:@"%@/order/updateOrderInfo",zfb_baseUrl] params:param success:^(id response) {
        
        [self.view makeToast:response[@"resultMsg"] duration:2 position:@"center"];
        //成功后需要刷新列表
        switch (_servicType) {
                
            case BusinessServicTypeWaitSendlist://待派单
                
                [self businessOrderListPostRequstpayStatus:@"" orderStatus:@"0" storeId:_storeId];//待配送

                break;
            case BusinessServicTypeSending://配送中
                
                [self businessOrderListPostRequstpayStatus:@"" orderStatus:@"1" storeId:_storeId];
                
                break;
            case BusinessServicTypeWaitPay://待付款
                
                [self businessOrderListPostRequstpayStatus:@"" orderStatus:@"4" storeId:_storeId];
                
                break;
            case BusinessServicTypeDealComplete://交易完成
                
                [self businessOrderListPostRequstpayStatus:@"" orderStatus:@"3" storeId:_storeId];
                
                break;
            case BusinessServicTypeSureReturn://待确认退回
                
                [self salesAfterPostRequsteAtStoreId:_storeId];
                
                
                break;
            case BusinessServicTypeSended://已配送
                
                [self businessOrderListPostRequstpayStatus:@"" orderStatus:@"2" storeId:_storeId];
                
                break;
            case BusinessServicTypeCancelOrder://取消订单
                
                [self businessOrderListPostRequstpayStatus:@"" orderStatus:@"-1" storeId:_storeId];
                
                
                break;
                
            case BusinessServicTypeWaitSending://待发货
                [self businessOrderListPostRequstpayStatus:@"" orderStatus:@"9" storeId:_storeId];
                
                break;
            case BusinessServicTypeWaitReceived://待收货
                [self businessOrderListPostRequstpayStatus:@"" orderStatus:@"10" storeId:_storeId];
                
                break;
        }
    } progress:^(NSProgress *progeress) {
    } failure:^(NSError *error) {
        
        NSLog(@"error=====%@",error);
        [self.view makeToast:@"网络错误" duration:2 position:@"center"];
    }];
    
}

#pragma mark -  商户派单接口  222222  order/orderSheet
-(void)sendOrderPostRequstStoreID:(NSString *)storeId
                       deliveryId:(NSString *)deliveryId
                          orderId:(NSString *)orderId
                      postAddress:(NSString *)postAddress
                         postName:(NSString *)postName
                      orderAmount:(NSString *)orderAmount
                     deliveryName:(NSString *)deliveryName
                    deliveryPhone:(NSString *)deliveryPhone
                        postPhone:(NSString *)postPhone
                 orderDeliveryFee:(NSString *)orderDeliveryFee
{
    NSDictionary * param = @{
                             @"storeId":_storeId,
                             @"deliveryId":deliveryId,//配送员id
                             @"orderId":orderId,//订单编号
                             @"postAddress":postAddress,//接收人地址
                             @"postName":postName,//接收人名称
                             @"orderAmount":orderAmount,//订单金额
                             @"deliveryName": deliveryName,
                             @"deliveryPhone":deliveryPhone,//配送员电话
                             @"postPhone":postPhone,//配送员电话
                             @"orderDeliveryFee":orderDeliveryFee,//配送费
                             };
    
    
    [MENetWorkManager post:[NSString stringWithFormat:@"%@/order/orderSheet",zfb_baseUrl] params:param success:^(id response) {
        
        [self.view makeToast:response[@"resultMsg"] duration:2 position:@"center"];
        [self.orderBgview removeFromSuperview];
        
        //派单成功后刷新
        [self.homeTableView reloadData];
        
    } progress:^(NSProgress *progeress) {
    } failure:^(NSError *error) {
        
        NSLog(@"error=====%@",error);
    }];
    
}

#pragma mark -  配送员列表接口     order/selectDeliveryList（方法暂时弃用）
-(void)selectDeliveryListPostRequst
{
    NSDictionary * param = @{
                             @"longitude":longitudestr,
                             @"latitude":latitudestr,
                             };
    [SVProgressHUD show];
    [MENetWorkManager post:[NSString stringWithFormat:@"%@/order/selectDeliveryList",zfb_baseUrl] params:param success:^(id response) {
        
        if ([response[@"resultCode"] intValue] == 0) {
            
            DeliveryModel * model = [DeliveryModel mj_objectWithKeyValues:response];
            if (self.deliveryArray.count > 0) {
                [self.deliveryArray removeAllObjects];
            }
            for (Deliverylist * list in model.deliveryList) {
                [self.deliveryArray addObject:list];
            }
            [SVProgressHUD dismiss];
            [self reloadDeliveryList];//刷新
            [self.view addSubview:self.orderBgview];
        }
    } progress:^(NSProgress *progeress) {
    } failure:^(NSError *error) {
        [SVProgressHUD dismiss];
        NSLog(@"error=====%@",error);
    }];
    
}
#pragma mark - 111111    deliveryType 配送类型：1  派单   2  发货  3  按钮配送完成
-(void)autoSendOrderId:(NSString *)orderId
{
    NSDictionary * param = @{
                             @"orderId":orderId,
                             };
    [SVProgressHUD showWithStatus:@"系统派单中，请稍后"];
    [MENetWorkManager post:[NSString stringWithFormat:@"%@/automaticDispatNew",zfb_baseUrl] params:param success:^(id response) {
        NSString *code = [NSString stringWithFormat:@"%@",response[@"resultCode"]];
        
        if ([code isEqualToString:@"0"]) {
            [SVProgressHUD showSuccessWithStatus:response[@"resultMsg"]];
            
            [self businessOrderListPostRequstpayStatus:@"" orderStatus:@"0"  storeId:_storeId];
            [self.homeTableView reloadData];

        }else{
            [SVProgressHUD showErrorWithStatus:response[@"resultMsg"]];

        }

    } progress:^(NSProgress *progeress) {
    } failure:^(NSError *error) {
        [SVProgressHUD showErrorWithStatus:@"网络错误~"];
    }];
}
#pragma mark - 333333  deliveryType 配送类型：1  派单   2  发货  3  按钮配送完成
-(void)businessOrderbyOrderId:(NSString *)orderId
{
    NSDictionary * param = @{
                             @"orderId":orderId,
                             };
    
    [SVProgressHUD showWithStatus:@"派单中，请稍后"];
    [MENetWorkManager post:[NSString stringWithFormat:@"%@/merchantSendOrders",zfb_baseUrl] params:param success:^(id response) {
        
        NSString * code = [NSString stringWithFormat:@"%@",response[@"resultCode"]];
        if ([code isEqualToString:@"0"]) {
 
            [SVProgressHUD showSuccessWithStatus:response[@"resultMsg"]];
            [self businessOrderListPostRequstpayStatus:@"" orderStatus:@"0"  storeId:_storeId];
            [self.homeTableView reloadData];

        }else{
            [self.view makeToast:response[@"resultMsg"] duration:2 position:@"center"];
            
        }

    } progress:^(NSProgress *progeress) {
    } failure:^(NSError *error) {
        [SVProgressHUD dismiss];
        NSLog(@"error=====%@",error);
        [SVProgressHUD showErrorWithStatus:@"网络错误~"];

    }];
    
}
#pragma mark - 发货 ---
-(void)sendGoodsPostOrderId:(NSString *)orderId
                expressName:(NSString*)expressName
              expressNumber:(NSString *)expressNumber
              expressCoding:(NSString *)expressCoding

{
    NSDictionary * param = @{
                             @"orderId":orderId,
                             @"expressName":expressName,//快递公司名字
                             @"expressNumber":expressNumber,//快递单号
                             @"expressCoding":expressCoding,//快递公司编码
                             };
    
    [SVProgressHUD showWithStatus:@"派单中，请稍后"];
    [MENetWorkManager post:[NSString stringWithFormat:@"%@/expressOrders",zfb_baseUrl] params:param success:^(id response) {
        
        NSString * code = [NSString stringWithFormat:@"%@",response[@"resultCode"]];
        if ([code isEqualToString:@"0"]) {
            
            [SVProgressHUD showSuccessWithStatus:response[@"resultMsg"]];
            //刷新了收货
            [self businessOrderListPostRequstpayStatus:@"" orderStatus:@"9" storeId:_storeId];
            [self.homeTableView reloadData];
            
        }else{
            [self.view makeToast:response[@"resultMsg"] duration:2 position:@"center"];
            
        }
        
    } progress:^(NSProgress *progeress) {
    } failure:^(NSError *error) {
        [SVProgressHUD dismiss];
        NSLog(@"error=====%@",error);
        [SVProgressHUD showErrorWithStatus:@"网络错误~"];
        
    }];
    
}

#pragma mark -  确认退款的参数   order/storeConfirmReceipt
-(void)returnBackStoreConfirmReceiptPostRequstAtOrderNum:(NSString *)orderNum
                                          afterServiceId:(NSString *)afterServiceId
                                                 goodsId:(NSString *)goodsId
                                            orderGoodsId:(NSString *)orderGoodsId
                                              goodsCount:(NSString *)goodsCount
                                                  refund:(NSString *)refund
                                                  userId:(NSString *)userId
{
    NSDictionary * param = @{
                             
                             @"orderNum":orderNum,
                             @"afterServiceId":afterServiceId,
                             @"goodsId":goodsId,
                             @"orderGoodsId":orderGoodsId,
                             @"goodsCount":goodsCount,
                             @"refund":refund,
                             @"userId":userId,//退款用户的 id
                             
                             };
    [SVProgressHUD show];
    [MENetWorkManager post:[NSString stringWithFormat:@"%@/order/storeConfirmReceipt",zfb_baseUrl] params:param success:^(id response) {
        NSString *code = [NSString stringWithFormat:@"%@",response[@"resultCode"]];
        
        if ([code isEqualToString:@"0"]) {
            [SVProgressHUD dismiss];
            [self.view makeToast:response[@"resultMsg"] duration:2 position:@"center"];
        }else
        {
            [self.view makeToast:response[@"resultMsg"] duration:2 position:@"center"];
            [SVProgressHUD dismiss];

        }
        
    } progress:^(NSProgress *progeress) {
    } failure:^(NSError *error) {
        [SVProgressHUD dismiss];
        NSLog(@"error=====%@",error);
    }];
    
}


#pragma mark - 查询进度 列表     zfb/InterfaceServlet/afterSale/afterSaleList
-(void)salesAfterPostRequsteAtStoreId:(NSString *)storeId
{
    //状态:0:退货待审批   1:审批通过 2:审批未通过,3.待返回货物，4：服务完成 5.待寄货 6.待取件 7.服务关闭 8.商户待确认
    NSDictionary * param = @{
                             
                             @"size":[NSNumber numberWithInteger:kPageCount] ,
                             @"page":[NSNumber numberWithInteger:self.currentPage],
                             @"status":@"1",
                             @"storeId":storeId,
                             };
    
    [SVProgressHUD show];
    [MENetWorkManager post:[zfb_baseUrl stringByAppendingString:@"/afterSale/afterSaleList"] params:param success:^(id response) {
        if ([response[@"resultCode"] isEqualToString:@"0"]) {
            if (self.refreshType == RefreshTypeHeader) {
                if (self.progressArray.count > 0) {
                    [self.progressArray removeAllObjects];
                }
            }
            AllOrderProgress * progressModel = [AllOrderProgress mj_objectWithKeyValues:response];
            for (List * cheakList in progressModel.data.list) {
                [self.progressArray addObject:cheakList];
            }
            [SVProgressHUD dismiss];
            [self.homeTableView reloadData];

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

//取消操作
-(void)cancelAction
{
    [self.orderBgview removeFromSuperview];
}
-(void)reloadDeliveryList
{
    [self.sendOrderPopView reloadDeliveryList];
}

#pragma mark  - 定位当前
/**定位当前 */
-(void)LocationMapManagerInit
{
    //判断定位功能是否打开
    if ([CLLocationManager locationServicesEnabled]) {
        
        _locationManager                = [[CLLocationManager alloc]init];
        _locationManager.distanceFilter = 200;
        _locationManager.delegate       = self;
        [_locationManager requestWhenInUseAuthorization];
        
        //设置寻址精度
        _locationManager.desiredAccuracy = kCLLocationAccuracyBest;
        [_locationManager startUpdatingLocation];
    }
    
}
#pragma mark CoreLocation delegate (定位失败)
//定位失败后调用此代理方法
-(void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    [self.view makeToast:[NSString stringWithFormat:@"%@",error] duration:2 position:@"center"];
}

#pragma mark 定位成功后则执行此代理方法
-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations
{
    [_locationManager stopUpdatingLocation];
    
    //旧址
    CLLocation *currentLocation = [locations lastObject];
    //打印当前的经度与纬度
    currentLocation = [currentLocation locationMarsFromEarth];
    NSLog(@"%f,%f",currentLocation.coordinate.latitude,currentLocation.coordinate.longitude);
    latitudestr  = [NSString stringWithFormat:@"%.6f",currentLocation.coordinate.latitude];
    longitudestr = [NSString stringWithFormat:@"%.6f",currentLocation.coordinate.longitude];
    
    
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
    [self settingNavBarBgName:@"nav64_gray"];

    //获取商户端数据列表
    [self storeHomePagePostRequst];
    
    //获取定位
    [self LocationMapManagerInit];
    
}

//既可以让headerView不悬浮在顶部，也可以让footerView不停留在底部。
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    switch (_selectPageType ) {
        case SelectTypeHomePage:
             break;
            
        case SelectTypeOrderPage:
        {
            CGFloat sectionHeaderHeight = k_sectionHeight ;
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
            break;
        case SelectTypeCaculater:
 
            break;
            
    }
   
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
