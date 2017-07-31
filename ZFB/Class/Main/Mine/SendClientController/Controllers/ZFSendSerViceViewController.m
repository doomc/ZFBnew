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

@interface ZFSendSerViceViewController ()<UITableViewDelegate,UITableViewDataSource,ZFSendPopViewDelegate,ZFFooterCellDelegate,ZFSendHomeListCellDelegate>
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
    
    NSString * deliveryId;//配送员id
    NSString * distriCount;//配送员完成总数
    NSString * orderDeliveryFee;//配送费	配送员获取的收入
    
}
@property (strong, nonatomic) UITableView *send_tableView;
@property (weak, nonatomic  ) IBOutlet UIButton    *Home_btn;//首页安妞
@property (weak, nonatomic  ) IBOutlet UIButton    *Order_btn;//订单按钮

@property (nonatomic,strong) UIButton       *navbar_btn;//导航页
@property (nonatomic,strong) UIView * titleView      ;
@property (nonatomic,strong) UIView         * bgview;
@property (nonatomic,strong) ZFSendPopView  * popView;
@property (nonatomic,assign) SendServicType servicType;//传一个type

@property (nonatomic,assign) BOOL isSelectPage;//默认选择一个首页面

@property (strong,nonatomic) NSArray *titles;

@property (nonatomic ,strong) NSMutableArray *  orderListArray ;//订单列表
@property (nonatomic ,strong) NSMutableArray *  orderGoodsArry ;//订单商品
@property (nonatomic ,strong) NSMutableArray *  deliveryArray  ;//配送员列表

@end

@implementation ZFSendSerViceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    _isSelectPage = YES;
    
    self.title    = @"配送端";
    
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

#pragma mark  -tableView delegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    NSInteger sectionNum = 2;
    if (_isSelectPage == YES ) {
        
        return sectionNum;
        
    }else{
        
        switch (_servicType) {
                
            case SendServicTypeWaitSend:
                sectionNum = 1;
                break;
            case SendServicTypeSending:
                
                sectionNum = 1;
                
                break;
            case SendServicTypeSended:
                sectionNum = 1;
                
                break;
                
        }
    }
    
    return sectionNum;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger sectionRow = 0;
    
    if (_isSelectPage == YES ) {
        
        sectionRow =  1;
        
    }else{
        
        switch (_servicType) {
                
            case SendServicTypeWaitSend://待配送
                if (section == 0) {
                    sectionRow = 4;
                }
                return 1;
                break;
            case SendServicTypeSending://配送中
                
                sectionRow = 3;//全部返回4行
                break;
            case SendServicTypeSended://已配送
                
                sectionRow = 2;
                
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
            
            height = 82;
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
                return titleCell;
            }
                break;
            case SendServicTypeSending:
            {
                SendServiceTitleCell * titleCell = [self.send_tableView
                                                    dequeueReusableCellWithIdentifier:@"SendServiceTitleCellid"];
                [titleCell.statusButton setTitle:@"配送中" forState:UIControlStateNormal];

                return titleCell;
            }
                break;
            case SendServicTypeSended:
            {
                SendServiceTitleCell * titleCell = [self.send_tableView
                                                    dequeueReusableCellWithIdentifier:@"SendServiceTitleCellid"];
                [titleCell.statusButton setTitle:@"已配送" forState:UIControlStateNormal];

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
        ZFSendHomeListCell * cell = [self.send_tableView dequeueReusableCellWithIdentifier:@"ZFSendHomeListCellid" forIndexPath:indexPath];
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
        //     NSLog(@"切换到我的订单 列表")
        switch (_servicType) {
#pragma mark - SendServicTypeWaitSend 待配送
            case SendServicTypeWaitSend:
                if (indexPath.section == 0) {
                    
                    ZFSendingCell *contentCell = [self.send_tableView dequeueReusableCellWithIdentifier:@"ZFSendingCellid" forIndexPath:indexPath];
                    contentCell.selectionStyle = UITableViewCellSelectionStyleNone;
                    return contentCell;
                    
                }else{
                    
                    //可切换2种cell   ZFSendHomeCell ZFContactCell
                    ZFSendHomeCell *homeCell = [self.send_tableView dequeueReusableCellWithIdentifier:@"ZFSendHomeCellid"   forIndexPath:indexPath];
                    homeCell.selectionStyle  = UITableViewCellSelectionStyleNone;
                    return homeCell;
                }
                
                break;
#pragma mark - SendServicTypeSending 配送中
            case SendServicTypeSending:
            {
                
                ZFSendingCell *contentCell = [self.send_tableView dequeueReusableCellWithIdentifier:@"ZFSendingCellid" forIndexPath:indexPath];
                
                contentCell.selectionStyle = UITableViewCellSelectionStyleNone;
                return contentCell;
                
            }
                break;
                
#pragma mark - SendServicTypeSended 已配送
            case SendServicTypeSended:
            {
                
                ZFSendingCell *contentCell = [self.send_tableView dequeueReusableCellWithIdentifier:@"ZFSendingCellid" forIndexPath:indexPath];
                
                contentCell.selectionStyle = UITableViewCellSelectionStyleNone;
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
    
    [self.send_tableView reloadData];
}
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
#pragma mark - ZFSendPopViewDelegate
-(void)sendTitle:(NSString *)title SendServiceType:(SendServicType)type
{
    [UIView animateWithDuration:0.3 animations:^{
        if (self.bgview.superview) {
            [self.bgview removeFromSuperview];
        }
    }];
    
    _servicType = type;
    
    [self.navbar_btn setTitle:title forState:UIControlStateNormal];
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
///取消
-(void)cancelOrderAction
{
    
}

///确认
-(void)sendOrdersActionOrderId:(NSString*)orderId totalPrice:(NSString *)totalPrice{
    
}

#pragma mark - 配送端
-(void)selectDeliveryListPostRequst
{
    NSDictionary * param = @{
                             @"cmUserId":BBUserDefault.cmUserId,
                             
                             };
    [SVProgressHUD show];
    
    [MENetWorkManager post:[NSString stringWithFormat:@"%@/getOrderDeliveryInfo",zfb_baseUrl] params:param success:^(id response) {
        
        SendServiceModel * model = [SendServiceModel mj_objectWithKeyValues:response];
        
        //        model.weedMap.distriCount ;
        
        [self.send_tableView reloadData];
        
        [SVProgressHUD dismissWithDelay:1];
        
    } progress:^(NSProgress *progeress) {
        
        NSLog(@"progeress=====%@",progeress);
        
    } failure:^(NSError *error) {
        [SVProgressHUD dismiss];
        NSLog(@"error=====%@",error);
    }];
    
}

-(void)viewWillAppear:(BOOL)animated
{
    [self selectDeliveryListPostRequst];
}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
    
    [self.bgview removeFromSuperview];
     
    
}

@end
