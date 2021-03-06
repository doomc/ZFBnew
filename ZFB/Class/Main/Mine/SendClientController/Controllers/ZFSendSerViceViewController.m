//
//  ZFSendSerViceViewController.m
//  ZFB
//
//  Created by  展富宝  on 2017/5/24.
//  Copyright © 2017年 com.zfb. All rights reserved.
//  配送端

#import "ZFSendSerViceViewController.h"

//view
#import "ZFSendPopView.h"
#import "SendMessageView.h"

//cell
#import "ZFSendingCell.h"
#import "ZFFooterCell.h"//尾部
#import "SendServiceTitleCell.h"//订单头部
#import "BusinessSendAccountCell.h"

#import "OrderPriceCell.h"
#import "ZFSendHomeCell.h"
#import "ZFSendHomeListCell.h"
#import "ZFTitleCell.h"//首页头部
#import "SendServiceFootCell.h"//订单尾部已配送

#import "SendStatisticsContentCell.h"//订单首页的内容cell
#import "SendStatisticsHeaderCell.h"//订单首页头部修改

//model
#import "SendServiceModel.h"
#import "SendServiceOrderModel.h"//订单模型
#import "CaculaterModel.h"

//vc
#import "SendOrderStatisticsViewController.h"
#import "ZFDetailOrderViewController.h"

#define  k_cellHeight 130
#define  k_sectionHeight 50
#define  k_footHeight 60

typedef NS_ENUM(NSUInteger, SelectType) {
    SelectTypeHomePage, //选择首页
    SelectTypeOrderPage, //选择订单
    SelectTypeCaculater,//选择结算
};
@interface ZFSendSerViceViewController ()<UITableViewDelegate,UITableViewDataSource,ZFSendPopViewDelegate,ZFFooterCellDelegate,ZFSendHomeListCellDelegate >
{
    //day
    NSString * _daydistriCount;
    NSString * _dayOrderDeliveryFee;//日配送费
    NSString * _daydate_time;
    NSString * _daystart_time;
    NSString * _dayend_time;
    
    //week
    NSString * _weekdistriCount;
    NSString * _weekOrderDeliveryFee;//周配送费
    NSString * _weekodate_time;
    NSString * _weekstart_time;
    NSString * _weekend_time;
    
    //month
    NSString * _monthdistriCount;
    NSString * _monthOrderDeliveryFee;//月配送费
    NSString * _monthodate_time;
    NSString * _monthstart_time;
    NSString * _monthend_time;
    
    //订单数
    NSString * _order_count;
    //订单id
    NSString * _order_id;
    NSString * _deliveryId;//配送员id
    
    //// 配送信息 ////
    NSString * msg_address ;
    NSString * msg_postPhone;
    NSString * msg_postName ;
    NSString * msg_postAddress;
    NSString * msg_orderDeliveryFee ;
    NSString * msg_contactPhone;
    
    
}

@property (weak, nonatomic) IBOutlet UITableView *send_tableView;


@property (nonatomic,strong) UIButton  * navbar_btn;//导航页
@property (nonatomic,strong) UIView    * titleView ;
@property (nonatomic,strong) UIView    * bgview;
@property (nonatomic,strong) UILabel    * navTitle ;

@property (nonatomic,strong) ZFSendPopView  * popView;
@property (nonatomic,assign) SendServicType servicType;//传一个type
@property (nonatomic,assign) SelectType    selectPageType;//选择类型

@property (strong,nonatomic) NSArray *titles;

@property (nonatomic ,strong) NSMutableArray *  orderListArray ;//订单列表
@property (nonatomic ,strong) NSMutableArray *  caculaterArray ;//结算列表

//根据footerView 的按钮判断切换到对应定订单的页面
@property (nonatomic ,copy)  NSString * buttonType;

//配送信息视图
@property (nonatomic ,strong) SendMessageView * messageView;
@property (nonatomic ,strong) UIView    * messagebgview;

//配送信息数组
@property (nonatomic ,strong) NSMutableArray * msgArray;

//返回按钮
@property (nonatomic ,strong) UIButton * navButton;

@end

@implementation ZFSendSerViceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.title = @"配送端";
    _titles = @[@"待配送",@"配送中",@"已配送"];
    
    _selectPageType = SelectTypeHomePage;

    [self initSend_tableView];
    
    [self segmentControlSetting];
    
    [self.send_tableView registerNib:[UINib nibWithNibName:@"ZFTitleCell" bundle:nil]
              forCellReuseIdentifier:@"ZFTitleCellid"];
    [self.send_tableView registerNib:[UINib nibWithNibName:@"ZFSendingCell" bundle:nil]
              forCellReuseIdentifier:@"ZFSendingCellid"];
    [self.send_tableView registerNib:[UINib nibWithNibName:@"ZFFooterCell" bundle:nil]
              forCellReuseIdentifier:@"ZFFooterCellid"];
    [self.send_tableView registerNib:[UINib nibWithNibName:@"ZFContactCell" bundle:nil]
              forCellReuseIdentifier:@"ZFContactCellid"];
    [self.send_tableView registerNib:[UINib nibWithNibName:@"SendServiceTitleCell" bundle:nil]
              forCellReuseIdentifier:@"SendServiceTitleCellid"];
    [self.send_tableView registerNib:[UINib nibWithNibName:@"ZFSendHomeCell" bundle:nil]
              forCellReuseIdentifier:@"ZFSendHomeCellid"];
    [self.send_tableView registerNib:[UINib nibWithNibName:@"ZFSendHomeListCell" bundle:nil]
              forCellReuseIdentifier:@"ZFSendHomeListCellid"];
    [self.send_tableView registerNib:[UINib nibWithNibName:@"OrderPriceCell" bundle:nil]
              forCellReuseIdentifier:@"OrderPriceCellid"];
    [self.send_tableView registerNib:[UINib nibWithNibName:@"SendServiceFootCell" bundle:nil]
              forCellReuseIdentifier:@"SendServiceFootCellid"];
    [self.send_tableView registerNib:[UINib nibWithNibName:@"BusinessSendAccountCell" bundle:nil]
              forCellReuseIdentifier:@"BusinessSendAccountCell"];
    [self.send_tableView registerNib:[UINib nibWithNibName:@"SendStatisticsHeaderCell" bundle:nil]
              forCellReuseIdentifier:@"SendStatisticsHeaderCell"];
    [self.send_tableView registerNib:[UINib nibWithNibName:@"SendStatisticsContentCell" bundle:nil]
              forCellReuseIdentifier:@"SendStatisticsContentCell"];
    [self setupRefresh];
    
}

#pragma mark - 页面切换
-(void)segmentControlSetting
{
    self.segmentControl.selectedSegmentIndex = 0;
    [self.segmentControl addTarget:self action:@selector(SegmentchangePage:) forControlEvents:UIControlEventValueChanged];
    UIFont *font = [UIFont boldSystemFontOfSize:15.0f];
    NSDictionary *attributes = [NSDictionary dictionaryWithObject:font forKey:NSFontAttributeName];
    [self.segmentControl setTitleTextAttributes:attributes forState:UIControlStateNormal];
    
}

-(void)headerRefresh
{
    [super headerRefresh];
    switch (_selectPageType) {
        case SelectTypeHomePage:
            [self selectDeliveryListPostRequst];
            break;
        case SelectTypeOrderPage:
            switch (_servicType) {
                case SendServicTypeWaitSend://待配送
                    [self orderlistDeliveryID:_deliveryId OrderStatus:@"1"   ];
                    
                    break;
                case SendServicTypeSending://配送中
                    
                    [self orderlistDeliveryID:_deliveryId OrderStatus:@"2" ] ;
                    
                    
                    break;
                case SendServicTypeSended://已配送
                    [self orderlistDeliveryID:_deliveryId OrderStatus:@"3"  ];
                    
                    break;
            }
            
            break;
        case SelectTypeCaculater:
            [self caculaterListPostRequset];
            
            break;
            
    }
    
}

-(void)footerRefresh
{
    [super footerRefresh];
    
    switch (_selectPageType) {
        case SelectTypeHomePage:
            [self selectDeliveryListPostRequst];

            break;
        case SelectTypeOrderPage:
            switch (_servicType) {
                    
                case SendServicTypeWaitSend://待派单
                    [self orderlistDeliveryID:_deliveryId OrderStatus:@"1"  ];
                    
                    break;
                case SendServicTypeSending://配送中
                    
                    [self orderlistDeliveryID:_deliveryId OrderStatus:@"2"  ] ;
                    
                    break;
                    
                case SendServicTypeSended://已配送
                    [self orderlistDeliveryID:_deliveryId OrderStatus:@"3" ];
                    
                    break;

            }
            break;
            
        case SelectTypeCaculater:
            [self caculaterListPostRequset];
            break;
    }
    
}
-(void)SegmentchangePage:(UISegmentedControl*)segmentPage
{
    _selectPageType = segmentPage.selectedSegmentIndex;
    
    switch (_selectPageType) {
        case SelectTypeHomePage:
            NSLog(@"点击首页");
        {
            self.navTitle.text  = @"配送端";
            self.navbar_btn.hidden = YES;
            self.navTitle.hidden = NO;
            self.navigationItem.titleView = _titleView;
            [self.send_tableView reloadData];
        }
            break;
            
        case SelectTypeOrderPage:
            NSLog(@"点击订单");
        {
            
            self.navbar_btn.hidden = NO;
            self.navTitle.hidden = YES;
            
            [self.navbar_btn setTitle:@"待配送" forState:UIControlStateNormal];
            [self.titleView addSubview:self.navbar_btn];
            self.navigationItem.titleView = _titleView;
            
            //订单列表
            [self orderlistDeliveryID:_deliveryId OrderStatus:@"1"  ];
            [self.send_tableView reloadData];
        }
            break;
        case SelectTypeCaculater:
            
        {
            self.navTitle.text  = @"结算列表";
            self.navbar_btn.hidden = YES;
            self.navTitle.hidden = NO;
            self.navigationItem.titleView = _titleView;

            [self caculaterListPostRequset];
            [self.send_tableView reloadData];
            
        }
            NSLog(@"点击的结算");
            break;
    }
    
}


#pragma mark - 懒加载
-(NSMutableArray *)msgArray
{
    if (!_msgArray) {
        
        _msgArray = [NSMutableArray array];
    }
    return _msgArray;
}
-(NSMutableArray *)orderListArray
{
    if (!_orderListArray) {
        _orderListArray = [NSMutableArray array];
    }
    return _orderListArray;
}
-(NSMutableArray *)caculaterArray{
    
    if (!_caculaterArray) {
        
        _caculaterArray = [NSMutableArray array];
    }
    return _caculaterArray;
    
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
        
        _navTitle = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 120, 30)];
        _navTitle.font =[UIFont systemFontOfSize:14];
        _navTitle.textColor              = HEXCOLOR(0x333333);
        _navTitle.textAlignment          = NSTextAlignmentCenter;
    }
    return _navTitle;
}

//自定义导航按钮选择定订单
-(UIButton *)navbar_btn
{
    if (!_navbar_btn) {
        _navbar_btn       = [UIButton buttonWithType:UIButtonTypeCustom];
        _navbar_btn.frame = CGRectMake(0, 0, 120, 30);
        [_navbar_btn setImage:[UIImage imageNamed:@"arrows_down_black"] forState:UIControlStateNormal];
        _navbar_btn.titleLabel.font = [UIFont systemFontOfSize:14];
        [_navbar_btn setTitleColor:HEXCOLOR(0x333333) forState:UIControlStateNormal];
        [_navbar_btn setImageEdgeInsets:UIEdgeInsetsMake(0, 80, 0, 0)];
        [_navbar_btn setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 0,30)];
        [_navbar_btn addTarget:self action:@selector(navigationBarSelectedOther:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _navbar_btn;
}

/**
 正选反选
 @param btn 切换
 */
-(void)navigationBarSelectedOther:(UIButton *)btn;
{
    [self.view addSubview:self.bgview];
    
}

-(void )initSend_tableView
{
    _send_tableView.estimatedSectionFooterHeight = 0;
    _send_tableView.estimatedSectionHeaderHeight = 0;
    _send_tableView.estimatedRowHeight = 0;
    _send_tableView.backgroundColor = HEXCOLOR(0xf7f7f7);
    _send_tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _send_tableView.delegate       = self;
    _send_tableView.dataSource     = self;
    self.zfb_tableView =  self.send_tableView;

}
-(ZFSendPopView *)popView
{
    if (!_popView) {
        
        _popView          = [[ZFSendPopView alloc]initWithFrame:CGRectMake(0, 0, KScreenW, 50 +10 ) titleArray:_titles];
        _popView.delegate = self;
    }
    return _popView;
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
//配送信息背景蒙板
-(UIView *)messagebgview
{
    if (!_messagebgview) {
        _messagebgview =[[ UIView alloc]initWithFrame:CGRectMake(0, 0, KScreenW, KScreenH)];
        _messagebgview.backgroundColor = RGBA(0, 0, 0, 0.2) ;
        [_messagebgview addSubview:self.messageView];
    }
    return _messagebgview;
    
}
/**
 配送信息
 @return messageView
 */
-(SendMessageView *)messageView{
    if (!_messageView) {
        _messageView = [[SendMessageView alloc]initWithFrame:CGRectMake(30, 0, KScreenW - 60, 240)];
        _messageView.center = self.view.center;
        _messageView.detailTitleArray = self.msgArray;//传值试试
    }
    return _messageView;
}
#pragma mark  -tableView delegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    NSInteger sectionNum = 2;
    switch (_selectPageType) {
        case SelectTypeHomePage:
            return sectionNum;
            
            break;
        case SelectTypeOrderPage:
            switch (_servicType) {
                case SendServicTypeWaitSend:
                    
                    sectionNum = self.orderListArray.count;
                    
                    break;
                case SendServicTypeSending:
                    
                    sectionNum = self.orderListArray.count;
                    
                    break;
                case SendServicTypeSended:
                    
                    sectionNum = self.orderListArray.count;
                    break;
 
            }
            
            break;
        case SelectTypeCaculater:
            
            sectionNum  = 1;
            break;
    }
    return sectionNum;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger sectionRow = 0;
    switch (_selectPageType) {
        case SelectTypeHomePage:
            if (section == 0) {
                sectionRow = 1;
            }else{
                sectionRow = 3;
            }
     
            break;
        case SelectTypeOrderPage:
            switch (_servicType) {
                    
                case SendServicTypeWaitSend://待配送
                {
                    
                    SendServiceStoreinfomap * store = self.orderListArray[section];
                    NSMutableArray * goodsArr = [NSMutableArray array];
                    for (SendServiceOrdergoodslist * goods in store.orderGoodsList) {
                        [goodsArr addObject:goods ];
                    }
                    sectionRow =  goodsArr.count;
                }
                    break;
                case SendServicTypeSending://配送中
                {
                    
                    SendServiceStoreinfomap * store = self.orderListArray[section];
                    NSMutableArray * goodsArr = [NSMutableArray array];
                    for (SendServiceOrdergoodslist * goods in store.orderGoodsList) {
                        [goodsArr addObject:goods ];
                    }
                    sectionRow =  goodsArr.count;
                }
                    break;
                case SendServicTypeSended://已配送
                {
                    SendServiceStoreinfomap * store = self.orderListArray[section];
                    NSMutableArray * goodsArr = [NSMutableArray array];
                    for (SendServiceOrdergoodslist * goods in store.orderGoodsList) {
                        [goodsArr addObject:goods ];
                    }
                    sectionRow =  goodsArr.count;
                }
                    break;
            }
            break;
        case SelectTypeCaculater:
            
            sectionRow = self.caculaterArray.count;
            break;
            
    }
    
    return sectionRow;
}
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
            ///根据  cellType 返回的高度
            switch (_servicType) {
                    
                case SendServicTypeWaitSend:
                    height = k_cellHeight;
                    break;
                case SendServicTypeSending:
                    height = k_cellHeight;
                    break;
                case SendServicTypeSended:
                    
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
    SendServiceTitleCell  *titleCell = [self.send_tableView
                                        dequeueReusableCellWithIdentifier:@"SendServiceTitleCellid"];
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
            
            switch (_servicType) {
                    
                case SendServicTypeWaitSend:
                {
                    [titleCell.statusButton setTitle:@"待配送" forState:UIControlStateNormal];
                    SendServiceStoreinfomap * sendService = self.orderListArray[section];
                    if (self.orderListArray.count > 0) {
                        titleCell.storlist = sendService;
                    }
                    view = titleCell;
                }
                    break;
                case SendServicTypeSending:
                {
                    [titleCell.statusButton setTitle:@"配送中" forState:UIControlStateNormal];
                    SendServiceStoreinfomap * sendService = self.orderListArray[section];
                    if (self.orderListArray.count > 0) {
                        
                        titleCell.storlist = sendService;
                    }
                    view = titleCell;
                }
                    break;
                case SendServicTypeSended:
                {
                    [titleCell.statusButton setTitle:@"已配送" forState:UIControlStateNormal];
                    SendServiceStoreinfomap * sendService = self.orderListArray[section];
                    if (self.orderListArray.count > 0) {
                        
                        titleCell.storlist = sendService;
                    }
                    view = titleCell;
                }
                    break;
 
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
    CGFloat height = 0;
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
                    
                case SendServicTypeWaitSend:
                    height = k_sectionHeight;
                    break;
                    
                case SendServicTypeSending:
                    height = k_sectionHeight;
                    
                    break;
                case SendServicTypeSended:
                    height = k_sectionHeight;
                    
                    break;
 
            }
            
            break;
        case SelectTypeCaculater:

            height = 0.001;
            break;
            
    }
    
    return height;
    
}

//设置footerView视图
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView * footerView = nil;
    ZFFooterCell * footcell = [self.send_tableView
                               dequeueReusableCellWithIdentifier:@"ZFFooterCellid"];
    switch (_selectPageType) {
        case SelectTypeHomePage:
            
            return footerView;
            break;
        case SelectTypeOrderPage:
            
            switch (_servicType) {
                case SendServicTypeWaitSend://待配送
                {
                    
                    footcell.footDelegate = self;
                    //没获取 当前的 indexPath
                    SendServiceStoreinfomap  * orderlist = self.orderListArray[section];
                    footcell.sendOrder             = orderlist;
                    [footcell.cancel_button setTitle:@"配送信息" forState:UIControlStateNormal];
                    [footcell.payfor_button setTitle:@"接单" forState:UIControlStateNormal];
                    footcell.section = section;
                    footerView                     = footcell;
                    
                }
                    break;
                case SendServicTypeSending://配送中
                {
                    
                    footcell.footDelegate = self;
                    //没获取 当前的 indexPath
                    SendServiceStoreinfomap  * orderlist = self.orderListArray[section];
                    footcell.sendOrder         = orderlist;
                    [footcell.cancel_button setTitle:@"配送信息" forState:UIControlStateNormal];
                    [footcell.payfor_button setTitle:@"配送完成" forState:UIControlStateNormal];
                    footcell.section = section;
                    
                    footerView                 = footcell;
                    
                }
                    
                    break;
                case SendServicTypeSended://已配送
                {
                    SendServiceFootCell * cell = [self.send_tableView
                                                  dequeueReusableCellWithIdentifier:@"SendServiceFootCellid"];
                    SendServiceStoreinfomap * storeModel = self.orderListArray[section];
                    cell.storeList = storeModel;
                    footerView = cell;
                    
                }
                    break;
 
            }
            
            break;
        case SelectTypeCaculater:
            return footerView;
            break;
            
    }
    
    
    return footerView;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    CGFloat height = 0;
    switch (_selectPageType) {
        case SelectTypeHomePage:
            height = 0.001;
            
            break;
        case SelectTypeOrderPage:
            switch (_servicType) {
                    
                case SendServicTypeWaitSend:
                    
                    height = k_footHeight;
                    break;
                    
                case SendServicTypeSending:
                    height = k_footHeight;
                    
                    break;
                    
                case SendServicTypeSended:
                    height = 76+10;
                    
                    break;

            }
            break;
        case SelectTypeCaculater:
            
            height = 0.0001;
            break;
    }
    return height;
    
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (_selectPageType) {
        case SelectTypeHomePage:
            if (indexPath.section == 0) {
                
                SendStatisticsHeaderCell *titleCell = [self.send_tableView
                                          dequeueReusableCellWithIdentifier:@"SendStatisticsHeaderCell"];
                titleCell.lb_orderNum.text = _order_count;
                return titleCell;
                
            }else{
                SendStatisticsContentCell * cell = [self.send_tableView dequeueReusableCellWithIdentifier:@"SendStatisticsContentCell" forIndexPath:indexPath];
                if (indexPath.row == 0) {
                    cell.lb_stautus.text = @"今日配送";
                    //日
                    cell.lb_sendTime.text = _daydate_time;
                    cell.lb_sendCount.text  = _daydistriCount;
                    cell.lb_sendFee.text = [NSString stringWithFormat:@"%.2f",[_dayOrderDeliveryFee floatValue]];
                    
                }else if (indexPath.row == 1)
                {
                    cell.lb_stautus.text = @"7日配送";
                    
                    //周
                    cell.lb_sendTime.text = _weekodate_time;
                    cell.lb_sendCount.text  = _weekdistriCount;
                    cell.lb_sendFee.text = [NSString stringWithFormat:@"%.2f",[_weekOrderDeliveryFee floatValue]];
                    
                }
                else{
                    cell.lb_stautus.text = @"30日配送";
                    //月
                    cell.lb_sendTime.text = _monthodate_time;
                    cell.lb_sendCount.text  = _monthdistriCount;
                    cell.lb_sendFee.text = [NSString stringWithFormat:@"%.2f",[_monthOrderDeliveryFee floatValue]] ;

                }
                return cell;
    
            }
                break;
        case SelectTypeOrderPage:
            switch (_servicType) {
#pragma mark - SendServicTypeWaitSend 待配送
                case SendServicTypeWaitSend:
                {
                    ZFSendingCell *contentCell = [self.send_tableView dequeueReusableCellWithIdentifier:@"ZFSendingCellid" forIndexPath:indexPath];

                    if (self.orderListArray.count > 0) {
                        
                        SendServiceStoreinfomap * store = self.orderListArray[indexPath.section];
                        NSMutableArray * goodsArr = [NSMutableArray array];
                        for (SendServiceOrdergoodslist * goods in store.orderGoodsList) {
                            [goodsArr addObject:goods ];
                        }
                        SendServiceOrdergoodslist * goods = goodsArr [indexPath.row];
                        contentCell.sendGoods = goods;
                    }
                    contentCell.selectionStyle = UITableViewCellSelectionStyleNone;
                    return contentCell;
                    
                }
                    break;
#pragma mark - SendServicTypeSending 配送中
                case SendServicTypeSending:
                {
                    ZFSendingCell *contentCell = [self.send_tableView dequeueReusableCellWithIdentifier:@"ZFSendingCellid" forIndexPath:indexPath];

                    if (self.orderListArray.count > 0) {
                        
                        SendServiceStoreinfomap * store = self.orderListArray[indexPath.section];
                        NSMutableArray * goodsArr = [NSMutableArray array];
                        for (SendServiceOrdergoodslist * goods in store.orderGoodsList) {
                            [goodsArr addObject:goods ];
                        }
                        
                        SendServiceOrdergoodslist * goods = goodsArr [indexPath.row];
                        contentCell.sendGoods = goods;
                    }
                    contentCell.selectionStyle = UITableViewCellSelectionStyleNone;
                    return contentCell;
                    
                }
                    break;
                    
#pragma mark - SendServicTypeSended 已配送
                case SendServicTypeSended:
                {
                    ZFSendingCell *contentCell = [self.send_tableView dequeueReusableCellWithIdentifier:@"ZFSendingCellid" forIndexPath:indexPath];

                    if (self.orderListArray.count > 0) {
                        SendServiceStoreinfomap * store = self.orderListArray[indexPath.section];
                        NSMutableArray * goodsArr = [NSMutableArray array];
                        for (SendServiceOrdergoodslist * goods in store.orderGoodsList) {
                            [goodsArr addObject:goods ];
                        }
                        
                        SendServiceOrdergoodslist * goods = goodsArr [indexPath.row];
                        contentCell.sendGoods = goods;
                    }
                    contentCell.selectionStyle = UITableViewCellSelectionStyleNone;
                    return contentCell;
                    
                }
                    
                    break;
            
            }
            
            break;
            
        case SelectTypeCaculater:
        {
            BusinessSendAccountCell * accountCell = [self.send_tableView dequeueReusableCellWithIdentifier:@"BusinessSendAccountCell" forIndexPath:indexPath];
            Settlementlist * list  = self.caculaterArray[indexPath.row];
            accountCell.sendList = list;
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
            if (indexPath.section ==0 ) {
                self.segmentControl.selectedSegmentIndex = 1;
                [self SegmentchangePage:self.segmentControl];
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
            switch (_servicType) {
#pragma mark - SendServicTypeWaitSend 待配送
                case SendServicTypeWaitSend:
                {
                    ZFDetailOrderViewController * detailVc =[[ ZFDetailOrderViewController alloc]init];
                    if (self.orderListArray.count > 0) {
                        SendServiceStoreinfomap * store = self.orderListArray[indexPath.section];
                        NSMutableArray * goodsArr = [NSMutableArray array];
                        for (SendServiceOrdergoodslist * goods in store.orderGoodsList) {
                            [goodsArr addObject:goods ];
                        }
                        SendServiceOrdergoodslist * goods = goodsArr [indexPath.row];
                        detailVc.cmOrderid = [NSString stringWithFormat:@"%ld",goods.orderId];
                        detailVc.storeId = [NSString stringWithFormat:@"%ld",goods.storeId];
                        detailVc.goodsId = [NSString stringWithFormat:@"%ld",goods.goodsId];
                        detailVc.imageUrl = goods.coverImgUrl;
                        detailVc.isUserType = 2;// 3 是用户 1 是商户 2 是配送
                    }
                    [self.navigationController pushViewController:detailVc animated:YES];
                }
                    break;
#pragma mark - SendServicTypeSending 配送中
                case SendServicTypeSending:
                {
                    ZFDetailOrderViewController * detailVc =[[ ZFDetailOrderViewController alloc]init];
                    if (self.orderListArray.count > 0) {
                        SendServiceStoreinfomap * store = self.orderListArray[indexPath.section];
                        NSMutableArray * goodsArr = [NSMutableArray array];
                        for (SendServiceOrdergoodslist * goods in store.orderGoodsList) {
                            [goodsArr addObject:goods ];
                        }
                        SendServiceOrdergoodslist * goods = goodsArr [indexPath.row];
                        detailVc.cmOrderid = [NSString stringWithFormat:@"%ld",goods.orderId];
                        detailVc.storeId = [NSString stringWithFormat:@"%ld",goods.storeId];
                        detailVc.goodsId = [NSString stringWithFormat:@"%ld",goods.goodsId];
                        detailVc.imageUrl = goods.coverImgUrl;
                        detailVc.isUserType = 2;// 3 是用户 1 是商户 2 是配送
                    }
                    [self.navigationController pushViewController:detailVc animated:YES];
                }
                    break;
                    
#pragma mark - SendServicTypeSended 已配送
                case SendServicTypeSended:
                {
                    ZFDetailOrderViewController * detailVc =[[ ZFDetailOrderViewController alloc]init];
                    if (self.orderListArray.count > 0) {
                        SendServiceStoreinfomap * store = self.orderListArray[indexPath.section];
                        NSMutableArray * goodsArr = [NSMutableArray array];
                        for (SendServiceOrdergoodslist * goods in store.orderGoodsList) {
                            [goodsArr addObject:goods ];
                        }
                        SendServiceOrdergoodslist * goods = goodsArr [indexPath.row];
                        detailVc.cmOrderid = [NSString stringWithFormat:@"%ld",goods.orderId];
                        detailVc.storeId = [NSString stringWithFormat:@"%ld",goods.storeId];
                        detailVc.goodsId = [NSString stringWithFormat:@"%ld",goods.goodsId];
                        detailVc.imageUrl = goods.coverImgUrl;
                        detailVc.isUserType = 2;// 3 是用户 1 是商户 2 是配送
                    }
                    [self.navigationController pushViewController:detailVc animated:YES];
                    break;

                }
            }
            break;
        case SelectTypeCaculater:
            
            break;
 
        }
    }
}

#pragma mark - ZFSendPopViewDelegate 选择类型 根据类型请求
-(void)sendTitle:(NSString *)title SendServiceType:(SendServicType)type
{
    _servicType = type;
    self.currentPage = 1;
    [self.orderListArray removeAllObjects];
    [self.navbar_btn setTitle:title forState:UIControlStateNormal];
 
    [UIView animateWithDuration:0.5 animations:^{
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
//            //status  1.待接单 2.已接单 3.已配送
//            switch (_servicType) {
//
//                case SendServicTypeWaitSend:
//
//                    [self orderlistDeliveryID:_deliveryId OrderStatus:@"1"  ];
//                    [self.send_tableView reloadData];
//
//                    break;
//                case SendServicTypeSending:
//
//                    [self orderlistDeliveryID:_deliveryId OrderStatus:@"2"  ];
//                    [self.send_tableView reloadData];
//
//                    break;
//                case SendServicTypeSended:
//
//                    [self orderlistDeliveryID:_deliveryId OrderStatus:@"3"  ];
//                    [self.send_tableView reloadData];
//
//                    break;
//
//            }
//
//            break;
//
//        case SelectTypeCaculater:
//
//            break;
//    }
//
}
#pragma mark - ZFSendHomeListCellDelegate 订单详情页事件
///今日订单统计
-(void)todayOrderDetial
{
    SendOrderStatisticsViewController * orderDeal =[[SendOrderStatisticsViewController alloc]init];
    orderDeal.deliveryId = _deliveryId;
    orderDeal.orderNum = _daydistriCount;
    orderDeal.orderStartTime = _daystart_time;
    orderDeal.orderEndTime = _dayend_time;
    orderDeal.dealPrice =  [NSString stringWithFormat:@"%.2f",[_dayOrderDeliveryFee floatValue]];
    
    [self.navigationController pushViewController:orderDeal animated:NO];
    
}

///周订单统计
-(void)weekOrderDetial
{
    SendOrderStatisticsViewController * orderDeal =[[SendOrderStatisticsViewController alloc]init];
    orderDeal.deliveryId = _deliveryId;
    orderDeal.orderNum = _weekdistriCount;
    orderDeal.orderStartTime = _weekstart_time;
    orderDeal.orderEndTime = _weekend_time;
    orderDeal.dealPrice = _weekOrderDeliveryFee;
    [self.navigationController pushViewController:orderDeal animated:NO];
}

///月订单统计
-(void)monthOrderDetial
{
    SendOrderStatisticsViewController * orderDeal =[[SendOrderStatisticsViewController alloc]init];
    orderDeal.deliveryId = _deliveryId;
    orderDeal.orderNum = _monthdistriCount;
    orderDeal.dealPrice = _monthOrderDeliveryFee;
    orderDeal.orderStartTime = _monthstart_time;
    orderDeal.orderEndTime = _monthend_time;
    [self.navigationController pushViewController:orderDeal animated:NO];
    
}
#pragma mark - ZFFooterCellDelegate footerView上的按钮事件
///调用接口-配送信息

-(void)cancelOrderActionbyOrderNum:(NSString *)orderNum
                       orderStatus:(NSString *)orderStatus
                        payStatus :(NSString *)payStatus
                       deliveryId :(NSString *)deliveryId
                        indexPath :(NSInteger )indexPath
{
    
    SendServiceStoreinfomap * store  = self.orderListArray[indexPath];
    
    switch (_servicType) {
            
        case SendServicTypeWaitSend:
            
            _order_id = [NSString stringWithFormat:@"%ld",store.orderId];
            //确认后调用该接口
            [self sendMsgOrderDeliveryByorderId:_order_id];
            
            break;
        case SendServicTypeSending:
            
            _order_id = [NSString stringWithFormat:@"%ld",store.orderId];
            //确认后调用该接口
            [self sendMsgOrderDeliveryByorderId:_order_id];
            
            
            break;
        case SendServicTypeSended:
            
            
            _order_id = [NSString stringWithFormat:@"%ld",store.orderId];
            //确认后调用该接口
            [self sendMsgOrderDeliveryByorderId:_order_id];
 
 
            break;
    }
    
    
}

///接单+配送完成
-(void)sendOrdersActionOrderId:(NSString*)orderId totalPrice:(NSString *)totalPrice  indexPath :(NSInteger)indexPath
{
    switch (_servicType) {
        case SendServicTypeWaitSend:
        {
            JXTAlertController * alertavc =[JXTAlertController alertControllerWithTitle:@"提示" message:@"亲,确定要接单吗？" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction * cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                
            }];
            UIAlertAction * sureAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
                
                SendServiceStoreinfomap * store = self.orderListArray[indexPath];
                
                switch (_servicType) {
                    case SendServicTypeWaitSend: // //OrderStatus 1.待接单 2.已接单 3.已配送
                        
                        [self getOrderbyOrderId:[NSString stringWithFormat:@"%ld",store.orderId] deliveryId:_deliveryId status:@"2"]; //接单2
                        break;
                    case SendServicTypeSending://配送中3
                        
                        [self getOrderbyOrderId:[NSString stringWithFormat:@"%ld",store.orderId] deliveryId:_deliveryId status:@"3"];
                        break;
                        
                    case SendServicTypeSended:
                        
                        NSLog(@"已配送接口");
                        break;
 
                }
                
                
            }];
            [alertavc addAction:cancelAction];
            [alertavc addAction:sureAction];
            
            [self presentViewController:alertavc animated:YES completion:nil];
        }
            break;
        case SendServicTypeSending:
        {
            JXTAlertController * alertavc =[JXTAlertController alertControllerWithTitle:@"提示" message:@"亲,确认配送完成了吗？" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction * cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                
            }];
            UIAlertAction * sureAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
                
                SendServiceStoreinfomap * store = self.orderListArray[indexPath];
                
                switch (_servicType) {
                    case SendServicTypeWaitSend:
                        
                        break;
                    case SendServicTypeSending:// 3.已配送
                        
                        [self getOrderbyOrderId:[NSString stringWithFormat:@"%ld",store.orderId] deliveryId:_deliveryId status:@"3"];
                        break;
                        
                    case SendServicTypeSended:
                        
                        NSLog(@"已配送接口");
 
                        break;
                }
            }];
            [alertavc addAction:cancelAction];
            [alertavc addAction:sureAction];
            
            [self presentViewController:alertavc animated:YES completion:nil];
        }
            
            break;
        case SendServicTypeSended:
            
            break;
 
    }
}

#pragma mark - 配送端首页 getOrderDeliveryInfo
-(void)selectDeliveryListPostRequst
{
    NSDictionary * param = @{
                             
                             @"cmUserId":BBUserDefault.cmUserId,//@"122",
                             
                             };
    [SVProgressHUD show];
    
    [MENetWorkManager post:[NSString stringWithFormat:@"%@/getOrderDeliveryInfo",zfb_baseUrl] params:param success:^(id response) {
        NSString * code = [NSString stringWithFormat:@"%@",response[@"resultCode"]];
        if ([code isEqualToString:@"0"]) {
            SendServiceModel * model = [SendServiceModel mj_objectWithKeyValues:response];
            
            //day
            _daydate_time = model.todayMap.nowDay;
            _dayOrderDeliveryFee = model.todayMap.orderDeliveryFee;
            _daydistriCount = model.todayMap.distriCount;
            _daystart_time = model.todayMap.completTimeStart;
            _dayend_time = model.todayMap.completTimeEnd;
            
            //week
            _weekodate_time = model.weedMap.time;
            _weekOrderDeliveryFee = model.weedMap.orderDeliveryFee;
            _weekdistriCount = model.weedMap.distriCount;
            _weekstart_time = model.weedMap.startDay;
            _weekend_time = model.weedMap.endTime;
            
            //month
            _monthOrderDeliveryFee = model.monthMap.orderDeliveryFee;
            _monthdistriCount = model.monthMap.distriCount;
            _monthodate_time = model.monthMap.betweenMonth;
            _monthend_time = model.monthMap.endMonth;
            _monthstart_time = model.monthMap.statusMbth;
            
            //配送员id
            _deliveryId = model.deliveryId;
            //配送订单数量
            _order_count = [NSString stringWithFormat:@"%ld",model.numArray.num];
            
            
            [self.send_tableView reloadData];
            [SVProgressHUD dismiss];
            
        }else{
            [SVProgressHUD dismiss];
            [self.view makeToast:response[@"resultMsg"] duration:2 position:@"center"];
        }
        [self endRefresh];
    } progress:^(NSProgress *progeress) {
    } failure:^(NSError *error) {
        [SVProgressHUD dismiss];
        [self endRefresh];
        NSLog(@"error=====%@",error);
    }];
    
}

#pragma mark -  订单列表 网络请求getOrderDeliveryByDeliveryId
/**
 订单列表
 
 @param deliveryID 配送员id
 @param orderStatus  1.待接单 2.已接单 3.已配送
 @ orderStartTime 配送开始的结束订单时间
 @ orderEndTime 配送结束的结束订单时间
 */
-(void)orderlistDeliveryID:(NSString *)deliveryID
               OrderStatus:(NSString *)orderStatus
{
    
    NSDictionary * param = @{
                             @"deliveryId":deliveryID,
                             @"status":orderStatus,
                             @"page":[NSNumber numberWithInteger:self.currentPage],
                             @"size":[NSNumber numberWithInteger:kPageCount],
                             
                             };
    [SVProgressHUD show];
    
    [MENetWorkManager post:[NSString stringWithFormat:@"%@/getOrderDeliveryByDeliveryId",zfb_baseUrl] params:param success:^(id response) {
        NSString * code = [NSString stringWithFormat:@"%@",response[@"resultCode"]];
        if ([code isEqualToString:@"0"]) {
            if (self.refreshType == RefreshTypeHeader) {
                if (self.orderListArray.count > 0) {
                    [self.orderListArray removeAllObjects];
                }
            }
            SendServiceOrderModel * order = [SendServiceOrderModel mj_objectWithKeyValues:response];
            for (SendServiceStoreinfomap * infoStore in order.storeInfoMap) {
                
                [self.orderListArray addObject:infoStore];
            }
            [SVProgressHUD dismiss];
            [self.send_tableView reloadData];
            NSLog(@"%@ ====orderListArray ",self.orderListArray);
            
        }
        else{
            [SVProgressHUD dismiss];
            [self.view makeToast:response[@"resultMsg"] duration:2 position:@"center"];
        }
        
        [self endRefresh];
        
    } progress:^(NSProgress *progeress) {
        
        NSLog(@"progeress=====%@",progeress);
        
    } failure:^(NSError *error) {
        [SVProgressHUD dismiss];
        [self endRefresh];
        
        NSLog(@"error=====%@",error);
    }];
    
    
}
#pragma mark - 接单 getIsOrderDeliveryInfo（根据订单id修改配送员接单状态）
/**
 订单状态
 
 @param orderId 订单id
 @param deliveryId 配送员id
 @param status 选择状态1.待接单 2.已接单 3.已配送,4.已完成订单
 */
-(void)getOrderbyOrderId:(NSString *)orderId deliveryId:(NSString *)deliveryId status:(NSString *)status
{
    
    NSDictionary * param = @{
                             @"orderId":orderId,
                             @"deliveryId":deliveryId,
                             @"status":status,
                             
                             };
    [SVProgressHUD show];
    
    [MENetWorkManager post:[NSString stringWithFormat:@"%@/getIsOrderDeliveryInfo",zfb_baseUrl] params:param success:^(id response) {
        
        NSString * code = [NSString stringWithFormat:@"%@",response[@"resultCode"]];
        if ([code isEqualToString:@"0"]) {
            
            [SVProgressHUD dismiss];
            [self.view makeToast:response[@"resultMsg"] duration:2 position:@"center"];
            
        }
        if ([status isEqualToString:@"2"]) {//查询已结单的列表
            
            [self orderlistDeliveryID:_deliveryId OrderStatus:@"1"  ];
            
        }
        if ([status isEqualToString:@"3"]) {//查询已配送
            
            [self orderlistDeliveryID:_deliveryId OrderStatus:@"2" ];
            
        }
        else{
            [SVProgressHUD dismiss];
            [self.view makeToast:response[@"resultMsg"] duration:2 position:@"center"];
        }
        
        [self.send_tableView reloadData];
        
    } progress:^(NSProgress *progeress) {
        
        NSLog(@"progeress=====%@",progeress);
        
    } failure:^(NSError *error) {
        [SVProgressHUD dismiss];
        NSLog(@"error=====%@",error);
        
    }];
    
    
}

#pragma mark - getDistriInfo 根据订单id查询订单配送信息
-(void)sendMsgOrderDeliveryByorderId:(NSString *)orderId

{
    NSDictionary * param = @{
                             @"orderId":orderId,
                             
                             };
    [SVProgressHUD show];
    [MENetWorkManager post:[NSString stringWithFormat:@"%@/getDistriInfo",zfb_baseUrl] params:param success:^(id response) {
        
        NSString * code = [NSString stringWithFormat:@"%@",response[@"resultCode"]];
        if ([code isEqualToString:@"0"]) {
            
            if (self.msgArray.count > 0) {
                [self.msgArray removeAllObjects];
            }
            //懒得转模型
            msg_address = response[@"orderInfoMap"][@"address"];
            msg_postPhone = response[@"orderInfoMap"][@"postPhone"];
            msg_postName = response[@"orderInfoMap"][@"postName"];
            msg_postAddress = response[@"orderInfoMap"][@"postAddress"];
            msg_orderDeliveryFee = response[@"orderInfoMap"][@"orderDeliveryFee"];
            msg_contactPhone = response[@"orderInfoMap"][@"contactPhone"];
            
            [self.msgArray addObject:msg_postName];
            [self.msgArray addObject:msg_contactPhone];
            [self.msgArray addObject:msg_address];
            [self.msgArray addObject:msg_orderDeliveryFee];
            [self.msgArray addObject:msg_postPhone];
            [self.msgArray addObject:msg_postAddress];
            [SVProgressHUD dismiss];
            //弹出 配送信息----当前视图
            [self.view addSubview:self.messagebgview];
            [self.messageView.tableView reloadData];
        }
        else{
            [SVProgressHUD dismiss];
            [self.view makeToast:response[@"resultMsg"] duration:2 position:@"center"];
        }
    } progress:^(NSProgress *progeress) {
    } failure:^(NSError *error) {
        [SVProgressHUD dismiss];
        NSLog(@"error=====%@",error);
    }];
    
}

#pragma mark - 结算列表 网络请求    order/getSettlementListById
-(void)caculaterListPostRequset
{
    NSDictionary * param = @{
                             
                             @"startSize":[NSNumber numberWithInteger:self.currentPage],
                             @"endSize":[NSNumber numberWithInteger:kPageCount],
                             @"deliveryId":_deliveryId,

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
            [self.send_tableView reloadData];
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


-(void)viewWillDisappear:(BOOL)animated
{
    [SVProgressHUD dismiss];
}

-(void)viewWillAppear:(BOOL)animated
{
    [self selectDeliveryListPostRequst];
    [self settingNavBarBgName:@"nav64_gray"];
    
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
    
    [self.bgview removeFromSuperview];
    [self.messagebgview removeFromSuperview];
    
}

//既可以让headerView不悬浮在顶部，也可以让footerView不停留在底部。
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    switch (_selectPageType) {
        case SelectTypeHomePage:
 
            break;
        case SelectTypeOrderPage:
        {
            CGFloat sectionHeaderHeight = 50 ;
            CGFloat sectionFooterHeight = 80;
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



@end
