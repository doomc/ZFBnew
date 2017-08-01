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

#import "OrderPriceCell.h"
#import "ZFSendHomeCell.h"
#import "ZFSendHomeListCell.h"
#import "ZFTitleCell.h"//首页头部
#import "SendServiceFootCell.h"//订单尾部已配送

//model
#import "SendServiceModel.h"
#import "SendServiceOrderModel.h"//订单模型

@interface ZFSendSerViceViewController ()<UITableViewDelegate,UITableViewDataSource,ZFSendPopViewDelegate,ZFFooterCellDelegate,ZFSendHomeListCellDelegate>
{
    //day
    NSString * _dayDistriCount;//订单数
    NSString * _dayOrderDeliveryFee;//配送费
    NSString * _daydate_time;
    NSString * _daystart_time;
    NSString * _dayend_time;
    
    //week
    NSString * _weekDistriCount;
    NSString * _weekOrderDeliveryFee;
    NSString * _weekodate_time;
    NSString * _weekstart_time;
    NSString * _weekend_time;
    //month
    NSString * _monthDistriCount;
    NSString * _monthOrderDeliveryFee;
    NSString * _monthodate_time;
    NSString * _monthstart_time;
    NSString * _monthend_time;
    
    //订单数
    NSString * _order_count;
    //订单id
    NSString * _order_id;
    NSString * _deliveryId;//配送员id
    
}
@property (strong, nonatomic) UITableView *send_tableView;
@property (weak, nonatomic  ) IBOutlet UIButton    *Home_btn;//首页安妞
@property (weak, nonatomic  ) IBOutlet UIButton    *Order_btn;//订单按钮

@property (nonatomic,strong) UIButton  * navbar_btn;//导航页
@property (nonatomic,strong) UIView    * titleView ;
@property (nonatomic,strong) UIView    * bgview;

@property (nonatomic,strong) ZFSendPopView  * popView;
@property (nonatomic,assign) SendServicType servicType;//传一个type

@property (nonatomic,assign) BOOL isSelectPage;//默认选择一个首页面

@property (strong,nonatomic) NSArray *titles;

@property (nonatomic ,strong) NSMutableArray *  orderListArray ;//订单列表
@property (nonatomic ,strong) NSMutableArray *  orderGoodsArry ;//订单商品
@property (nonatomic ,strong) NSMutableArray *  deliveryArray   ;//配送员列表

//根据footerView 的按钮判断切换到对应定订单的页面
@property (nonatomic ,copy)  NSString * buttonType;
//配送信息视图
@property (nonatomic ,strong) SendMessageView * messageView;
@property (nonatomic ,strong) UIView    * messagebgview;

@end

@implementation ZFSendSerViceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    _isSelectPage = YES;
    
    self.title = @"配送端";
    
    [self.view addSubview:self.send_tableView];
    
    self.send_tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [self.send_tableView registerNib:[UINib nibWithNibName:@"ZFTitleCell" bundle:nil] forCellReuseIdentifier:@"ZFTitleCellid"];
    [self.send_tableView registerNib:[UINib nibWithNibName:@"ZFSendingCell" bundle:nil] forCellReuseIdentifier:@"ZFSendingCellid"];
    [self.send_tableView registerNib:[UINib nibWithNibName:@"ZFFooterCell" bundle:nil] forCellReuseIdentifier:@"ZFFooterCellid"];
    [self.send_tableView registerNib:[UINib nibWithNibName:@"ZFContactCell" bundle:nil] forCellReuseIdentifier:@"ZFContactCellid"];
    
    [self.send_tableView registerNib:[UINib nibWithNibName:@"SendServiceTitleCell" bundle:nil] forCellReuseIdentifier:@"SendServiceTitleCellid"];
    
    [self.send_tableView registerNib:[UINib nibWithNibName:@"ZFSendHomeCell" bundle:nil] forCellReuseIdentifier:@"ZFSendHomeCellid"];
    [self.send_tableView registerNib:[UINib nibWithNibName:@"ZFSendHomeListCell" bundle:nil] forCellReuseIdentifier:@"ZFSendHomeListCellid"];
    [self.send_tableView registerNib:[UINib nibWithNibName:@"OrderPriceCell" bundle:nil] forCellReuseIdentifier:@"OrderPriceCellid"];
    [self.send_tableView registerNib:[UINib nibWithNibName:@"SendServiceFootCell" bundle:nil]
              forCellReuseIdentifier:@"SendServiceFootCellid"];
    
    _titles = @[@"待配送",@"配送中",@"已配送"];
    
    [self initButtonWithInterface];
}

#pragma mark - 创建视图
-(void)initButtonWithInterface
{
    [self.Home_btn  addTarget:self action:@selector(Home_btnaTargetAction) forControlEvents:UIControlEventTouchUpInside];
    [self.Order_btn  addTarget:self action:@selector(Order_btnaTargetAction) forControlEvents:UIControlEventTouchUpInside];
    
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
-(UITableView *)send_tableView
{
    if (!_send_tableView) {
        _send_tableView                = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, KScreenW, KScreenH-64-49) style:UITableViewStyleGrouped];
        _send_tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _send_tableView.delegate       = self;
        _send_tableView.dataSource     = self;
    }
    return _send_tableView;
}
-(ZFSendPopView *)popView
{
    if (!_popView) {
        
        _popView          = [[ZFSendPopView alloc]initWithFrame:CGRectMake(0, 0, KScreenW, 60) titleArray:self.titles];
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
        _bgview =[[ UIView alloc]initWithFrame:CGRectMake(0, 64, KScreenW, KScreenH)];
        _bgview.backgroundColor = RGBA(0, 0, 0, 0.2) ;
        [_bgview addSubview:self.popView];
    }
    return _bgview;
    
}
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
    }
    return _messageView;
}
#pragma mark  -tableView delegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    NSInteger sectionNum = 2;
    if (_isSelectPage == YES ) {
        
        return sectionNum;
        
    }else{
        
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
    }
    
    return sectionNum;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger sectionRow = 0;
    
    if (_isSelectPage == YES ) {
        
        sectionRow = 1;
        
    }else{
        
        switch (_servicType) {
                
            case SendServicTypeWaitSend://待配送
                
                sectionRow = self.orderGoodsArry.count;
                
                break;
            case SendServicTypeSending://配送中
                
                sectionRow = self.orderGoodsArry.count;
                break;
            case SendServicTypeSended://已配送
                
                sectionRow = self.orderGoodsArry.count;
                
                break;
                
                
        }
        
    }
    return sectionRow;
}
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
        ///根据  cellType 返回的高度
        switch (_servicType) {
#pragma mark - 待配送 返回height
            case SendServicTypeWaitSend:
                
                height = 84;
                
                break;
#pragma mark - 配送中 返回height
            case SendServicTypeSending:
                
                height = 84;
                
                
                break;
#pragma mark - 已配送 返回height
            case SendServicTypeSended:
                
                height = 84;
                
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
        
        SendServiceTitleCell  *titleCell = [self.send_tableView
                                            dequeueReusableCellWithIdentifier:@"SendServiceTitleCellid"];
        titleCell.selectionStyle = UITableViewCellSelectionStyleNone;
        titleCell.lb_title.text  = @"订单统计信息";
        [titleCell.statusButton setTitle:@"" forState:UIControlStateNormal];
        
        view = titleCell;
        
    }
    else{
        switch (_servicType) {
            case SendServicTypeWaitSend:
            {
                SendServiceTitleCell * titleCell = [self.send_tableView
                                                    dequeueReusableCellWithIdentifier:@"SendServiceTitleCellid"];
                [titleCell.statusButton setTitle:@"待配送" forState:UIControlStateNormal];
                
                SendServiceStoreinfomap * sendService = self.orderListArray[section];
                if (self.orderListArray.count > 0) {
                    
                    titleCell.storlist = sendService;
                }
                
                return titleCell;
            }
                break;
            case SendServicTypeSending:
            {
                SendServiceTitleCell * titleCell = [self.send_tableView
                                                    dequeueReusableCellWithIdentifier:@"SendServiceTitleCellid"];
                [titleCell.statusButton setTitle:@"配送中" forState:UIControlStateNormal];
                SendServiceStoreinfomap * sendService = self.orderListArray[section];
                if (self.orderListArray.count > 0) {
                    
                    titleCell.storlist = sendService;
                }
                return titleCell;
            }
                break;
            case SendServicTypeSended:
            {
                SendServiceTitleCell * titleCell = [self.send_tableView
                                                    dequeueReusableCellWithIdentifier:@"SendServiceTitleCellid"];
                [titleCell.statusButton setTitle:@"已配送" forState:UIControlStateNormal];
                SendServiceStoreinfomap * sendService = self.orderListArray[section];
                if (self.orderListArray.count > 0) {
                    
                    titleCell.storlist = sendService;
                }
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
                
            case SendServicTypeWaitSend:
                height = 40;
                break;
                
            case SendServicTypeSending:
                height = 40;
                
                break;
            case SendServicTypeSended:
                height = 40;
                
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
                
            case SendServicTypeWaitSend://待配送
            {
                ZFFooterCell * cell = [self.send_tableView
                                       dequeueReusableCellWithIdentifier:@"ZFFooterCellid"];
                cell.footDelegate = self;
                [cell.cancel_button setTitle:@"配送信息" forState:UIControlStateNormal];
                [cell.payfor_button setTitle:@"接单" forState:UIControlStateNormal];
                
                BusinessOrderlist  * orderlist = self.orderListArray[section];
                cell.businessOrder             = orderlist;
                footerView                     = cell;
                
            }
                break;
            case SendServicTypeSending://配送中
            {
                ZFFooterCell * cell = [self.send_tableView
                                       dequeueReusableCellWithIdentifier:@"ZFFooterCellid"];
                cell.footDelegate = self;
                [cell.cancel_button setTitle:@"配送信息" forState:UIControlStateNormal];
                [cell.payfor_button setTitle:@"配送完成" forState:UIControlStateNormal];
                
                BusinessOrderlist  * orderlist = self.orderListArray[section];
                cell.businessOrder             = orderlist;
                footerView                     = cell;
                
            }
                
                break;
            case SendServicTypeSended://已配送
            {
                SendServiceFootCell * cell = [self.send_tableView
                                              dequeueReusableCellWithIdentifier:@"SendServiceFootCellid"];
                footerView = cell;
                
            }
                
                break;
        }
    }
    
    return footerView;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    CGFloat height = 0.001;
    
    if (self.isSelectPage == YES) {
        
        height = 10;
        
    }else{
        
        switch (_servicType) {
                
            case SendServicTypeWaitSend:
                
                height = 50;
                break;
                
            case SendServicTypeSending:
                height = 50;
                
                break;
                
            case SendServicTypeSended:
                height = 76;
                
                break;
                
        }
    }
    return height;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = nil;
    if (_isSelectPage == YES) {
        
        if (indexPath.section == 0) {
            
            ZFTitleCell *titleCell = [self.send_tableView
                                      dequeueReusableCellWithIdentifier:@"ZFTitleCellid"];
            titleCell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            titleCell.lb_nameOrTime.text = @"待配送信息";
            titleCell.lb_storeName.text  = [NSString stringWithFormat:@"待派送订单 %@ 笔   >",_order_count];
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
        ZFSendHomeListCell * cell = [self.send_tableView dequeueReusableCellWithIdentifier:@"ZFSendHomeListCellid" forIndexPath:indexPath];
        cell.selectionStyle       = UITableViewCellSelectionStyleNone;
        cell.delegate             = self;
        //日
        cell.lb_todayCreatTime.text = _daydate_time;
        cell.lb_todayOrderNum.text  = _dayDistriCount;
        cell.lb_todayPriceFree.text = _dayOrderDeliveryFee;
        //周
        cell.lb_weekCreatTime.text = _weekodate_time;
        cell.lb_weekOrderNum.text  = _weekDistriCount;
        cell.lb_weekPriceFree.text = _weekOrderDeliveryFee;
        //月
        cell.lb_monthOrderNum.text  = _weekDistriCount;
        cell.lb_monthPriceFree.text = _weekOrderDeliveryFee;
        cell.lb_monthCreatTime.text = _monthodate_time;
        
        return cell;
        
    }else{
        //     NSLog(@"切换到我的订单 列表")
        switch (_servicType) {
#pragma mark - SendServicTypeWaitSend 待配送
            case SendServicTypeWaitSend:
                {
                    
                    ZFSendingCell *contentCell = [self.send_tableView dequeueReusableCellWithIdentifier:@"ZFSendingCellid" forIndexPath:indexPath];
                    if (self.orderGoodsArry.count > 0) {
                        SendServiceOrdergoodslist * goods = self.orderGoodsArry [indexPath.row];
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
                contentCell.selectionStyle = UITableViewCellSelectionStyleNone;

                if (self.orderGoodsArry.count > 0) {
                    SendServiceOrdergoodslist * goods = self.orderGoodsArry [indexPath.row];
                    contentCell.sendGoods = goods;
                }
                return contentCell;
                
            }
                break;
                
#pragma mark - SendServicTypeSended 已配送
            case SendServicTypeSended:
            {
                
                ZFSendingCell *contentCell = [self.send_tableView dequeueReusableCellWithIdentifier:@"ZFSendingCellid" forIndexPath:indexPath];
                contentCell.selectionStyle = UITableViewCellSelectionStyleNone;
                
                if (self.orderGoodsArry.count > 0) {
                    SendServiceOrdergoodslist * goods = self.orderGoodsArry [indexPath.row];
                    contentCell.sendGoods = goods;
                }

                return contentCell;
                
            }
                
                break;
                
        }
        
    }
    return cell;
}

#pragma mark - didSelectRowAtIndexPath

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"section  =%ld , row = %ld",indexPath.section ,indexPath.row);
    
    
    
}

#pragma mark - didclick 点击事件
-(void)didclickSend:(UIButton *)send
{
    NSLog(@"派送");
}

-(void)didCleckClearing:(UIButton *)clear
{
    NSLog(@"结算");
}
#pragma mark -Home_btnaTargetAction 切换到首页
-(void)Home_btnaTargetAction
{
    NSLog(@"首页页");
    
    self.navbar_btn.hidden = YES;
    self.isSelectPage      = YES;
    
    self.img_sendHome.image         = [UIImage imageNamed:@"home_red"];
    self.lb_sendHomeTitle.textColor = HEXCOLOR(0xfe6d6a);
    
    self.lb_sendOrderTitle.textColor=[UIColor whiteColor];
    self.img_sendOrder.image = [UIImage imageNamed:@"Order_normal"];
    
    UILabel * atitle              = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 100, 30)] ;
    atitle.text                   = @"配送端";
    atitle.font =[UIFont systemFontOfSize:14];
    atitle.textAlignment          = NSTextAlignmentCenter;
    atitle.textColor              = HEXCOLOR(0xfe6d6a);
    self.navigationItem.titleView = atitle;
    
    [self selectDeliveryListPostRequst];//首页请求数据
    
    [self.send_tableView reloadData];
}
#pragma mark - Order_btnaTargetAction切换到订单页
-(void)Order_btnaTargetAction
{
    NSLog(@"订单页");
    self.isSelectPage      = NO;
    self.navbar_btn.hidden = NO;
    [self.navbar_btn setTitle:@"待配送" forState:UIControlStateNormal];
    
    self.img_sendHome.image         = [UIImage imageNamed:@"home_normal"];
    self.lb_sendHomeTitle.textColor = [UIColor whiteColor];
    
    self.lb_sendOrderTitle.textColor = HEXCOLOR(0xfe6d6a);
    self.img_sendOrder.image         = [UIImage imageNamed:@"send_red"];
    
    self.navigationItem.titleView = self.navbar_btn;
    
    //订单列表
    [self orderlistDeliveryID:_deliveryId OrderStatus:@"1" orderStartTime:@"" orderEndTime:@""];
    
    [self.send_tableView reloadData];
    
}

/**
 正选反选
 @param btn 切换
 */
-(void)navigationBarSelectedOther:(UIButton *)btn;
{
    [self.view addSubview:self.bgview];
    
}

#pragma mark - ZFSendPopViewDelegate 选择类型 根据类型请求
-(void)sendTitle:(NSString *)title SendServiceType:(SendServicType)type
{
    [UIView animateWithDuration:0.3 animations:^{
        if (self.bgview.superview) {
            [self.bgview removeFromSuperview];
        }
    }];
    
    _servicType = type;
    
    [self.navbar_btn setTitle:title forState:UIControlStateNormal];
    //status  1.待接单 2.已接单 3.已配送
    switch (_servicType) {
            
        case SendServicTypeWaitSend:
            [self orderlistDeliveryID:_deliveryId OrderStatus:@"1" orderStartTime:@"" orderEndTime:@""];
            
            break;
        case SendServicTypeSending:
            [self orderlistDeliveryID:_deliveryId OrderStatus:@"2" orderStartTime:@"" orderEndTime:@""];
            
            break;
        case SendServicTypeSended:
            [self orderlistDeliveryID:_deliveryId OrderStatus:@"3" orderStartTime:@"" orderEndTime:@""];
            
            break;
            
    }
    [self.send_tableView reloadData];
    
    
}
#pragma mark - ZFSendHomeListCellDelegate 订单详情页事件
///查看订单详情
-(void)todayOrderDetial
{
    
}

///查看订单详情
-(void)weekOrderDetial
{
    
}

///查看订单详情
-(void)monthOrderDetial
{
    
    
}

#pragma mark - ZFFooterCellDelegate footerView上的按钮事件
///配送信息 + 取消
-(void)cancelOrderAction
{
    [self.view addSubview:self.messagebgview];
}
///接单+配送完成
-(void)sendOrdersActionOrderId:(NSString*)orderId totalPrice:(NSString *)totalPrice{
    
    
    JXTAlertController * alertavc =[JXTAlertController alertControllerWithTitle:@"提示" message:@"亲,确定要接单吗？" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction * cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    UIAlertAction * sureAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        
        if (_order_id != nil) {
            //确认后调用该接口
        }
        
    }];
    [alertavc addAction:cancelAction];
    [alertavc addAction:sureAction];
    
    [self presentViewController:alertavc animated:YES completion:nil];
    
}

#pragma mark - 配送端首页 getOrderDeliveryInfo
-(void)selectDeliveryListPostRequst
{
    NSDictionary * param = @{
                             @"cmUserId":BBUserDefault.cmUserId,
                             
                             };
    [SVProgressHUD show];
    
    [MENetWorkManager post:[NSString stringWithFormat:@"%@/getOrderDeliveryInfo",zfb_baseUrl] params:param success:^(id response) {
        
        SendServiceModel * model = [SendServiceModel mj_objectWithKeyValues:response];
        
        //配送订单数量
        _order_count = [NSString stringWithFormat:@"%ld",model.numArray.num];
        
        //配送员id
        _deliveryId = [NSString stringWithFormat:@"%ld",model.deliveryId];
        
        //day
        _daydate_time        = model.todayMap.nowDay;
        _dayDistriCount      = [NSString stringWithFormat:@"%ld",model.todayMap.distriCount];
        _dayOrderDeliveryFee = [NSString stringWithFormat:@"%ld",model.todayMap.distriCount];
        
        //week
        _weekodate_time       = model.weedMap.time;
        _weekDistriCount      = [NSString stringWithFormat:@"%ld",model.weedMap.distriCount];
        _weekOrderDeliveryFee = [NSString stringWithFormat:@"%ld",model.weedMap.distriCount];
        
        //month
        _monthodate_time       = model.monthMap.betweenMonth;
        _monthDistriCount      = [NSString stringWithFormat:@"%ld",model.weedMap.distriCount];
        _monthOrderDeliveryFee = [NSString stringWithFormat:@"%ld",model.weedMap.distriCount];
        
        [self.send_tableView reloadData];
        [SVProgressHUD dismissWithDelay:1];
        
    } progress:^(NSProgress *progeress) {
        
        NSLog(@"progeress=====%@",progeress);
        
    } failure:^(NSError *error) {
        [SVProgressHUD dismiss];
        NSLog(@"error=====%@",error);
    }];
    
}

#pragma mark -  订单列表 网络请求getOrderDeliveryByDeliveryId
/**
 订单列表
 
 @param deliveryID 配送员id
 @param orderStatus  1.待接单 2.已接单 3.已配送
 @param orderStartTime 配送开始的结束订单时间
 @param orderEndTime 配送结束的结束订单时间
 */
-(void)orderlistDeliveryID:(NSString *)deliveryID
               OrderStatus:(NSString *)orderStatus
            orderStartTime:(NSString *)orderStartTime
              orderEndTime:(NSString *)orderEndTime
{
    
    NSDictionary * param = @{
                             @"deliveryId":deliveryID,
                             @"orderStartTime":orderStartTime,
                             @"orderEndTime":orderEndTime,
                             @"status":orderStatus,
                             
                             };
    [SVProgressHUD show];
    
    [MENetWorkManager post:[NSString stringWithFormat:@"%@/getOrderDeliveryByDeliveryId",zfb_baseUrl] params:param success:^(id response) {
        
        SendServiceOrderModel * order = [SendServiceOrderModel mj_objectWithKeyValues:response];
        
        for (SendServiceStoreinfomap * infoStore in order.storeInfoMap) {
            
            [self.orderListArray addObject:infoStore];
            
            for (SendServiceOrdergoodslist * infoGoods in infoStore.orderGoodsList) {
                
                [self.orderGoodsArry addObject:infoGoods];
            }
        }

        [self.send_tableView reloadData];
        
        [SVProgressHUD dismissWithDelay:1];
        
    } progress:^(NSProgress *progeress) {
        
        NSLog(@"progeress=====%@",progeress);
        
    } failure:^(NSError *error) {
        [SVProgressHUD dismiss];
        NSLog(@"error=====%@",error);
    }];
    
    
}
#pragma mark - 接单 getIsOrderDeliveryInfo（根据订单id修改配送员接单状态）
/**
 订单状态
 
 @param orderId 订单id
 @param deliveryId 配送员id
 @param status 选择状态1.待接单 2.已接单 3.已配送
 */
-(void)getOrderbyOrderId:(NSString *)orderId deliveryId:(NSString *)deliveryId status:(NSString *)status
{
    
    NSDictionary * param = @{
                             @"orderId":orderId,
                             @"deliveryId":deliveryId,
                             @"status":status,
                             
                             };
    [SVProgressHUD show];
    
    [MENetWorkManager post:[NSString stringWithFormat:@"%@/getOrderDeliveryInfo",zfb_baseUrl] params:param success:^(id response) {
        if ([response[@"resultCode"] intValue] == 0) {
            
        
            [self.send_tableView reloadData];
            
            [SVProgressHUD dismissWithDelay:1];
            
        }
        
    } progress:^(NSProgress *progeress) {
        
        NSLog(@"progeress=====%@",progeress);
        
    } failure:^(NSError *error) {
        [SVProgressHUD dismiss];
        NSLog(@"error=====%@",error);
    }];
    
    
}

#pragma mark - 配送信息 getOrderDeliveryByDeliveryId 根据配送员ID、配送状态查询对应的订单配送信息接口
-(void)sendMsgOrderDeliveryByDeliveryId:(NSString *)orderId deliveryId:(NSString *)deliveryId status:(NSString *)status
{
    
}

-(void)viewWillAppear:(BOOL)animated
{
    [self selectDeliveryListPostRequst];
}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
    
    [self.bgview removeFromSuperview];
    [self.messagebgview removeFromSuperview];
    
}

@end
