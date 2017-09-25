


//
//  ZFAllOrderViewController.m
//  ZFB
//
//  Created by  展富宝  on 2017/5/25.
//  Copyright © 2017年 com.zfb. All rights reserved.
//  全部订单

#import "ZFAllOrderViewController.h"
//cell
#import "ZFSendingCell.h"
#import "ZFFooterCell.h"
#import "ZFTitleCell.h"
#import "DealSucessCell.h"//交易完成cell

//view
#import "ZFpopView.h"//选择类型弹框
#import "ZFSaleAfterTopView.h"//选择售后类型
//售后Cell
#import "ZFSaleAfterHeadCell.h"
#import "ZFSaleAfterContentCell.h"
#import "ZFSaleAfterSearchCell.h"
#import "ZFCheckTheProgressCell.h"
//VC
#import "ZFPregressCheckViewController.h"
#import "ZFDetailOrderViewController.h"
#import "ZFMainPayforViewController.h"
#import "ZFPersonalViewController.h"
#import "ZFEvaluateGoodsViewController.h"//评价
#import "ZFApplyBackgoodsViewController.h"//申请售后
#import "PublishShareViewController.h"//发布共享
//model
#import "AllOrderModel.h"
#import "AllOrderProgress.h"

static  NSString * headerCellid =@"ZFTitleCellid";//头id
static  NSString * contentCellid =@"ZFSendingCellid";//内容id
static  NSString * footerCellid =@"ZFFooterCellid";//尾部id

static  NSString * saleAfterHeadCellid =@"ZFSaleAfterHeadCellid";//头id
static  NSString * saleAfterContentCellid =@"saleAfterContentCellid";//内容id
static  NSString * saleAfterSearchCellid =@"ZFSaleAfterSearchCellid";//搜索cell
static  NSString * saleAfterProgressCellid =@"ZFCheckTheProgressCellid";//进度查询
static  NSString * dealSucessCellid =@"dealSucessCellid";//晒单


@interface ZFAllOrderViewController ()<UITableViewDelegate,UITableViewDataSource,ZFpopViewDelegate,ZFSaleAfterTopViewDelegate,ZFCheckTheProgressCellDelegate,ZFSaleAfterContentCellDelegate,ZFFooterCellDelegate,SaleAfterSearchCellDelegate,CYLTableViewPlaceHolderDelegate, WeChatStylePlaceHolderDelegate,DealSucessCellDelegate>
 
@property (nonatomic ,strong) UIView *  titleView ;
@property (nonatomic ,strong) UIButton  *navbar_btn;//导航按钮
@property (nonatomic ,strong) UIView    * bgview;//蒙板
@property (nonatomic ,strong) NSArray   * titles;//选择页面

@property (nonatomic ,strong) NSArray   * saleTitles;//售后选择
@property (nonatomic ,assign) NSInteger tagNum;//售后选择

@property (nonatomic ,strong) ZFpopView   * popView;

//售后搜索
@property (nonatomic ,strong) UISearchBar        * searchBar;

@property (nonatomic ,strong) ZFSaleAfterTopView * topView;

///全部订单-数据源
@property (nonatomic ,strong) NSMutableArray * orderListArray;//全部订单头数组
///售后申请-数据源
@property (nonatomic ,strong) NSMutableArray * salesAfterArray;//售后数组

@property (nonatomic ,strong) NSMutableArray * progressArray;//售后数组

@end

@implementation ZFAllOrderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.tagNum = 0;//默认为售后申请
    
    self.saleTitles = @[@"申请售后",@"进度查询"];
    
    self.titles =@[@"全部订单",@"待付款",@"待配送",@"配送中",@"已配送",@"交易完成",@"交易取消",@"售后申请",];
    
    [self.navbar_btn setTitle:_buttonTitle forState:UIControlStateNormal];
    
    [self initZfb_tableView];
    
    [self allOrderPostRequsetWithOrderStatus:_orderStatus orderNum:@""];
    
    [self setupRefresh];
}


#pragma mark -数据请求
-(void)headerRefresh {
    
    [super headerRefresh];
    switch (_orderType) {//-1：关闭,0待配送 1配送中 2.配送完成，3交易完成（用户确认收货），4.待付款,5.待审批,6.待退回，7.服务完成
            
        case OrderTypeAllOrder://全部订单
            
            [self allOrderPostRequsetWithOrderStatus:@"" orderNum:@""];
            break;
        case OrderTypeWaitPay://待付款
            
            [self allOrderPostRequsetWithOrderStatus:@"4"  orderNum:@""];
            
            break;
        case OrderTypeWaitSend://待配送
            
            [self allOrderPostRequsetWithOrderStatus:@"0" orderNum:@""];
            
            break;
        case OrderTypeSending://配送中
            [self allOrderPostRequsetWithOrderStatus:@"1" orderNum:@""];
            
            break;
        case OrderTypeSended://已配送
            
            [self allOrderPostRequsetWithOrderStatus:@"2" orderNum:@""];
            
            break;
        case OrderTypeDealSuccess://交易成功
            
            [self allOrderPostRequsetWithOrderStatus:@"3"  orderNum:@""];
            
            break;
        case OrderTypeCancelSuccess://取消交易
            
            [self allOrderPostRequsetWithOrderStatus:@"-1"  orderNum:@""];
            
            break;
        case OrderTypeAfterSale://售后
           
            if (_tagNum == 0) {
            
                [self saleAfterCheckOrderlistPostwithOrderStatus:@"2" SearchWord:@"" ];
                
            }else{
                [self salesAfterPostRequste];

            }

            break;
    }
    
}
-(void)footerRefresh {
    [super footerRefresh];
    switch (_orderType) {//-1：关闭,0待配送 1配送中 2.配送完成，3交易完成（用户确认收货），4.待付款,5.待审批,6.待退回，7.服务完成
            
        case OrderTypeAllOrder://全部订单
            
            [self allOrderPostRequsetWithOrderStatus:@""  orderNum:@""];
          
            break;
        case OrderTypeWaitPay://待付款
            
            [self allOrderPostRequsetWithOrderStatus:@"4"  orderNum:@""];
            
            break;
        case OrderTypeWaitSend://待配送
            
            [self allOrderPostRequsetWithOrderStatus:@"0"  orderNum:@""];
            
            break;
        case OrderTypeSending://配送中
            [self allOrderPostRequsetWithOrderStatus:@"1"   orderNum:@""];
            
            break;
        case OrderTypeSended://已配送
            
            [self allOrderPostRequsetWithOrderStatus:@"2" orderNum:@""];
            
            break;
        case OrderTypeDealSuccess://交易成功
            
            [self allOrderPostRequsetWithOrderStatus:@"3"  orderNum:@""];
            
            break;
        case OrderTypeCancelSuccess://取消交易
            
            [self allOrderPostRequsetWithOrderStatus:@"-1"  orderNum:@""];
            
            break;
        
        case OrderTypeAfterSale://售后
            
            if (_tagNum == 0) {
                [self saleAfterCheckOrderlistPostwithOrderStatus:@"2" SearchWord:@"" ];
                
            }else{
                [self salesAfterPostRequste];
            }
            break;
    }
    
}


#pragma mark -   视图售后初始化
-(ZFSaleAfterTopView *)topView{
    if (!_topView) {
        _topView  =[[ZFSaleAfterTopView alloc]initWithFrame:CGRectMake(0, 64, KScreenW, 44) titleArr:self.saleTitles];
        _topView.delegate = self;
    }
    return _topView;
}

//弹框初始化
-(ZFpopView *)popView
{
    if (!_popView) {
        _popView =[[ZFpopView alloc]initWithFrame:CGRectMake(0, 0, KScreenW, 155) titleArray:_titles];
        _popView.delegate = self;
        
    }
    return _popView;
}

//初始化allOrder_tableView
-(void)initZfb_tableView
{
    self.zfb_tableView                = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, KScreenW, KScreenH-64) style:UITableViewStylePlain];
    self.zfb_tableView .delegate       = self;
    self.zfb_tableView .dataSource     = self;
    self.zfb_tableView .separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [self.zfb_tableView registerNib:[UINib nibWithNibName:@"ZFSendingCell" bundle:nil]
             forCellReuseIdentifier:contentCellid];
    [self.zfb_tableView registerNib:[UINib nibWithNibName:@"ZFTitleCell" bundle:nil]
             forCellReuseIdentifier:headerCellid];
    [self.zfb_tableView registerNib:[UINib nibWithNibName:@"ZFFooterCell" bundle:nil]
             forCellReuseIdentifier:footerCellid];
    
    [self.zfb_tableView registerNib:[UINib nibWithNibName:@"ZFSaleAfterHeadCell" bundle:nil]
             forCellReuseIdentifier:saleAfterHeadCellid];
    [self.zfb_tableView registerNib:[UINib nibWithNibName:@"ZFSaleAfterContentCell" bundle:nil]
             forCellReuseIdentifier:saleAfterContentCellid];
    [self.zfb_tableView registerNib:[UINib nibWithNibName:@"ZFSaleAfterSearchCell" bundle:nil]
             forCellReuseIdentifier:saleAfterSearchCellid];
    [self.zfb_tableView registerNib:[UINib nibWithNibName:@"ZFCheckTheProgressCell" bundle:nil]
             forCellReuseIdentifier:saleAfterProgressCellid];
    
    [self.zfb_tableView registerNib:[UINib nibWithNibName:@"DealSucessCell" bundle:nil] forCellReuseIdentifier:dealSucessCellid];
    
    [self.view addSubview:self.zfb_tableView];

}

-(NSMutableArray *)orderListArray
{
    if (!_orderListArray) {
        _orderListArray = [NSMutableArray array];
    }
    return _orderListArray;
}


-(NSMutableArray *)salesAfterArray
{
    if (!_salesAfterArray) {
        _salesAfterArray = [NSMutableArray array];
    }
    return _salesAfterArray;
}
-(NSMutableArray *)progressArray
{
    if (!_progressArray) {
        _progressArray = [NSMutableArray array];
    }
    return _progressArray;
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
        [_navbar_btn setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 0,40)];
        [_navbar_btn addTarget:self action:@selector(navigationBarSelectedOther:) forControlEvents:UIControlEventTouchUpInside];
        self.navigationItem.titleView = _navbar_btn;
    }
    return _navbar_btn;
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

/**
 正选反选
 @param btn 切换
 */
-(void)navigationBarSelectedOther:(UIButton *)btn;
{
    [self.view addSubview:self.bgview];;
}

#pragma mark - tableView delegare
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    NSInteger sectionNum = 0;
    switch (_orderType) {
        case OrderTypeAllOrder:
            
            sectionNum = self.orderListArray.count;
            
            break;
        case OrderTypeWaitPay:
            sectionNum = self.orderListArray.count;
            break;
        case OrderTypeWaitSend:
            sectionNum = self.orderListArray.count;
            break;
        case OrderTypeSending:
            sectionNum = self.orderListArray.count;
            break;
        case OrderTypeSended:
            sectionNum = self.orderListArray.count;
            break;
        case OrderTypeDealSuccess:
            sectionNum =  self.orderListArray.count;
            break;
        case OrderTypeCancelSuccess:
            sectionNum = self.orderListArray.count;
            break;
        case OrderTypeAfterSale:
            if (self.tagNum == 0) {
 
            sectionNum = self.orderListArray.count + 1;

            }else{
                
                sectionNum = 1;
            }
            break;
    }
    return sectionNum;
    
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger rowNum = 0;
    
    Orderlist * orderlist       = self.orderListArray[section];
    NSMutableArray * goodsArray = [NSMutableArray array];
    for (Ordergoods * goods in orderlist.orderGoods) {
        [goodsArray addObject:goods];
    }
    
    switch (_orderType) {
        case OrderTypeAllOrder:
            
            rowNum = goodsArray.count;
            
            break;
        case OrderTypeWaitPay:
            
            rowNum = goodsArray.count;
            break;
        case OrderTypeWaitSend:
            
            rowNum = goodsArray.count;
            break;
        case OrderTypeSending:
            
            rowNum = goodsArray.count;
            break;
        case OrderTypeSended:
            
            rowNum = goodsArray.count;
            break;
        case OrderTypeDealSuccess:
            
            rowNum =  goodsArray.count;
            break;
        case OrderTypeCancelSuccess:
            
            rowNum = goodsArray.count;
            break;
        case OrderTypeAfterSale:
            
            if (self.tagNum == 0) {
                
                if (section == 0) {
                    
                    rowNum = 1;
                    
                }else{
                    
                    Orderlist * orderlist       = self.orderListArray[section -1];
                    NSMutableArray * saleArray = [NSMutableArray array];
                    for (Ordergoods * goods in orderlist.orderGoods) {
                        [saleArray addObject:goods];
                    }
                    rowNum = saleArray.count;
                    NSLog(@" ------rowNum-----%ld=========",rowNum);
                }
                
            }
            else{
                
                rowNum = self.progressArray.count;
            }
            
            break;
    }
    return rowNum;
    
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    CGFloat height = 0;
    
    switch (_orderType) {
        case OrderTypeAllOrder:
            
            height = 82;
            break;
            
        case OrderTypeWaitPay:
            height = 82;
            
            break;
        case OrderTypeWaitSend:
            height = 82;
            
            break;
        case OrderTypeSending:
            height = 82;
            
            break;
        case OrderTypeSended:
            height = 82;
            
            break;
        case OrderTypeDealSuccess:
            height = 82;
            
            break;
        case OrderTypeCancelSuccess:
            height = 82;
            
            break;
        case OrderTypeAfterSale:
            if (self.tagNum == 0) {
                if (section == 0) {
                    height = 55;
                    
                }else{
                    height = 64;
                }
            }else{
                
                height = 50;
            }
            break;
    }
    return height;
    
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    
    switch (_orderType) {
        case OrderTypeAllOrder:
        {
            ZFTitleCell * titleCell = [self.zfb_tableView
                                       dequeueReusableCellWithIdentifier:@"ZFTitleCellid"];
            if (self.orderListArray.count > 0) {
                
                Orderlist  * sectionList = self.orderListArray[section];
                titleCell.orderlist      = sectionList;
            }
            return titleCell;
            
        }
            break;
            
        case OrderTypeWaitPay:
        {
            ZFTitleCell * titleCell = [self.zfb_tableView
                                       dequeueReusableCellWithIdentifier:@"ZFTitleCellid"];
            if (self.orderListArray.count > 0) {
                
                Orderlist  * sectionList = self.orderListArray[section];
                titleCell.orderlist      = sectionList;
            }
            return titleCell;
        }
            break;
        case OrderTypeWaitSend:
        {
            ZFTitleCell * titleCell = [self.zfb_tableView
                                       dequeueReusableCellWithIdentifier:@"ZFTitleCellid"];
            if (self.orderListArray.count > 0) {
                
                Orderlist  * sectionList = self.orderListArray[section];
                titleCell.orderlist      = sectionList;
            }
            return titleCell;
        }
            
            break;
        case OrderTypeSending:{
            ZFTitleCell * titleCell = [self.zfb_tableView
                                       dequeueReusableCellWithIdentifier:@"ZFTitleCellid"];
            if (self.orderListArray.count > 0) {
                
                Orderlist  * sectionList = self.orderListArray[section];
                titleCell.orderlist      = sectionList;
            }
            return titleCell;
        }
            
            break;
        case OrderTypeSended:
        {
            ZFTitleCell * titleCell = [self.zfb_tableView
                                       dequeueReusableCellWithIdentifier:@"ZFTitleCellid"];
            if (self.orderListArray.count > 0) {
                
                Orderlist  * sectionList = self.orderListArray[section];
                titleCell.orderlist      = sectionList;
            }
            return titleCell;
        }
            
            break;
        case OrderTypeDealSuccess:
        {
            ZFTitleCell * titleCell = [self.zfb_tableView
                                       dequeueReusableCellWithIdentifier:@"ZFTitleCellid"];
            if (self.orderListArray.count > 0) {
                
                Orderlist  * sectionList = self.orderListArray[section];
                titleCell.orderlist      = sectionList;
            }
            return titleCell;
        }
            
            break;
        case OrderTypeCancelSuccess:
        {
            ZFTitleCell * titleCell = [self.zfb_tableView
                                       dequeueReusableCellWithIdentifier:@"ZFTitleCellid"];
            if (self.orderListArray.count > 0) {
                
                Orderlist  * sectionList = self.orderListArray[section];
                titleCell.orderlist      = sectionList;
            }
            return titleCell;
        }
            
            break;
        case OrderTypeAfterSale:
            
            if (self.tagNum == 0) {
                
                if (section == 0) {
                    
                    return self.topView;
                    
                }else{
                    
                    ZFSaleAfterHeadCell* HeadCell = [self.zfb_tableView
                                                     dequeueReusableCellWithIdentifier:saleAfterHeadCellid ];
                    if (self.orderListArray.count > 0) {
                        
                        Orderlist  * sectionList = self.orderListArray[section- 1];
                        HeadCell.orderlist       = sectionList;
                    }
                    
                    return  HeadCell;
                }
                
            }else{
                
                return self.topView;
            }
            
            break;
    }
    
    return nil;
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    CGFloat height = 0;
    
    switch (_orderType) {
        case OrderTypeAllOrder:
            
            height = 50;
            break;
            
        case OrderTypeWaitPay:
            height = 50;
            
            break;
        case OrderTypeWaitSend:
            height = 50;
            
            break;
        case OrderTypeSending:
            height = 50;
            
            break;
        case OrderTypeSended:
            height = 50;
            
            break;
        case OrderTypeDealSuccess:
            height = 50;
            
            break;
        case OrderTypeCancelSuccess:
            height = 50;
            
            break;
        case OrderTypeAfterSale:
            
            height = 10;
            
            break;
    }
    
    return height;
    
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView * view = nil;
    
    switch (_orderType) {
        case OrderTypeAllOrder://待派单
        {
            ZFFooterCell * cell = [self.zfb_tableView
                                   dequeueReusableCellWithIdentifier:footerCellid];
            cell.footDelegate = self;
            Orderlist  * orderlist = self.orderListArray[section];
            cell.orderlist         = orderlist;
            cell.section           = section;
            //默认值
            
            if ([orderlist.orderStatusName isEqualToString:@"配送完成"]) {
                [cell.payfor_button  setTitle:@"确认收货" forState:UIControlStateNormal];
                [cell.cancel_button  setHidden:YES];
            }
            else if ([orderlist.orderStatusName isEqualToString:@"待付款"]) {
                if (orderlist.payType == 0) {
                    
                    [cell.cancel_button  setHidden:YES];
                    [cell.payfor_button  setTitle:@"取消" forState:UIControlStateNormal];

                }else{
                    [cell.cancel_button  setTitle:@"取消" forState:UIControlStateNormal];
                    [cell.payfor_button  setTitle:@"去付款" forState:UIControlStateNormal];
                }
            }
            else if ([orderlist.orderStatusName isEqualToString:@"待配送"] ||[orderlist.orderStatusName isEqualToString:@"交易取消"] ||[orderlist.orderStatusName isEqualToString:@"配送中"]) {
                [cell.cancel_button  setHidden:YES];
                [cell.payfor_button  setHidden:YES];
            }
            else if ([orderlist.orderStatusName isEqualToString:@"交易完成"]) {
                [cell.cancel_button  setHidden:YES];
                [cell.payfor_button  setTitle:@"晒单" forState:UIControlStateNormal];
            }
            else if ([orderlist.orderStatusName isEqualToString:@"关闭"]) {
                [cell.cancel_button  setHidden:YES];
                [cell.payfor_button  setHidden:YES];
            }
            view = cell;
            
        }
            break;
        case OrderTypeWaitPay://待付款
        {
            ZFFooterCell * cell = [self.zfb_tableView
                                   dequeueReusableCellWithIdentifier:footerCellid];
            cell.footDelegate = self;
            //没获取 当前的 indexPath
            Orderlist  * orderlist = self.orderListArray[section];
            cell.orderlist         = orderlist;
            cell.section           = section;
            
            if (orderlist.payType == 0) {
                [cell.payfor_button  setTitle:@"取消" forState:UIControlStateNormal];
            }else{
                [cell.cancel_button  setTitle:@"取消" forState:UIControlStateNormal];
                [cell.payfor_button  setTitle:@"去付款" forState:UIControlStateNormal];
            }

            view = cell;
            
        }
            
            break;
        case OrderTypeWaitSend://待配送
        {
            ZFFooterCell * cell = [self.zfb_tableView
                                   dequeueReusableCellWithIdentifier:footerCellid];
            
            cell.footDelegate      = self;
            Orderlist  * orderlist = self.orderListArray[section];
            cell.orderlist         = orderlist;
            cell.section           = section;
            
            if ([orderlist.payModeName isEqualToString:@"线下支付"]) {
                
                [cell.payfor_button setTitle:@"确认取货" forState:UIControlStateNormal];
            }else{
                [cell.cancel_button setHidden:YES];
                [cell.payfor_button setHidden:YES];
            }
            
            view = cell;
            
        }
            
            break;
        case OrderTypeSending://配送中
        {
            ZFFooterCell * cell = [self.zfb_tableView
                                   dequeueReusableCellWithIdentifier:footerCellid];
            cell.footDelegate     = self;
            Orderlist  * footList = self.orderListArray[section];
            cell.orderlist        = footList;
            cell.section          = section;
            
            [cell.cancel_button setHidden:YES];
            [cell.payfor_button setHidden:YES];
            
            view = cell;
            
        }
            break;
            
        case OrderTypeSended://已配送
        {
            ZFFooterCell * cell = [self.zfb_tableView
                                   dequeueReusableCellWithIdentifier:footerCellid];
            cell.footDelegate = self;
            
            Orderlist  * footList = self.orderListArray[section];
            cell.orderlist        = footList;
            cell.section          = section;
            
            [cell.cancel_button setHidden:YES];
            [cell.payfor_button setTitle:@"确认收货" forState:UIControlStateNormal];
            
            view = cell;
            
        }
            break;
        case OrderTypeDealSuccess://交易完成
        {
            ZFFooterCell * cell = [self.zfb_tableView
                                   dequeueReusableCellWithIdentifier:footerCellid];
            cell.footDelegate = self;
            
            Orderlist  * footList = self.orderListArray[section];
            cell.orderlist        = footList;
            cell.section          = section;
            
            [cell.cancel_button setHidden:YES];
            [cell.payfor_button setHidden: YES];
//            [cell.payfor_button setTitle:@"晒单" forState:UIControlStateNormal];
            view = cell;
            
        }
            break;
        case OrderTypeCancelSuccess://交易失败
        {
            ZFFooterCell * cell = [self.zfb_tableView
                                   dequeueReusableCellWithIdentifier:footerCellid];
            cell.footDelegate = self;
            
            Orderlist  * footList = self.orderListArray[section];
            cell.orderlist        = footList;
            cell.section          = section;
            
            [cell.cancel_button setHidden:YES];
            [cell.payfor_button setHidden:YES];
            view = cell;
            
        }
            break;
            
        case OrderTypeAfterSale:
            
            return view;
            break;
    }
 
    return view;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat height = 0;
    switch (_orderType) {
        case OrderTypeAllOrder:
            
            height = 84;
            
            break;
        case OrderTypeWaitPay:
            height = 84;
            
            break;
        case OrderTypeWaitSend:
            height = 84;
            
            break;
        case OrderTypeSending:
            height = 84;
            
            break;
        case OrderTypeSended:
            height = 84;
            
            break;
        case OrderTypeDealSuccess:
            height = 84;
            break;
            
        case OrderTypeCancelSuccess:
            height = 84;
            break;
        case OrderTypeAfterSale:
            if (self.tagNum == 0) {
                if (indexPath.section ==0) {
                    
                    height = 56;
                    
                }else{
                    
                    height = 100;
                }
            }
            else{
                height = 180;
            }
            break;
    }
    return height;
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    switch (_orderType) {
            
        case OrderTypeAllOrder:
        {
            ZFSendingCell * sendCell = [self.zfb_tableView
                                        dequeueReusableCellWithIdentifier:contentCellid forIndexPath:indexPath];
            
            Orderlist * list = self.orderListArray[indexPath.section];
            NSMutableArray * goodArray = [NSMutableArray array];
            for (Ordergoods * ordergoods in list.orderGoods) {
                
                [goodArray addObject:ordergoods];
            }
            Ordergoods * goods = goodArray[indexPath.row];
            sendCell.goods = goods;
            return sendCell;
        }
            break;
            
        case OrderTypeWaitPay:
        {
            ZFSendingCell * sendCell = [self.zfb_tableView
                                        dequeueReusableCellWithIdentifier:contentCellid forIndexPath:indexPath];
            
            Orderlist * list           = self.orderListArray[indexPath.section];
            NSMutableArray * goodArray = [NSMutableArray array];
            for (Ordergoods * ordergoods in list.orderGoods) {
                [goodArray addObject:ordergoods];
            }
            Ordergoods * goods = goodArray[indexPath.row];
            sendCell.goods = goods;
            return sendCell;
        }
            break;
            
            
        case OrderTypeWaitSend:
        {
            ZFSendingCell * sendCell = [self.zfb_tableView
                                        dequeueReusableCellWithIdentifier:contentCellid forIndexPath:indexPath];
            sendCell.selectionStyle = UITableViewCellSelectionStyleNone;
            Orderlist * list           = self.orderListArray[indexPath.section];
            NSMutableArray * goodArray = [NSMutableArray array];
            for (Ordergoods * ordergoods in list.orderGoods) {
                
                [goodArray addObject:ordergoods];
            }
            Ordergoods * goods = goodArray[indexPath.row];
            sendCell.goods = goods;
            return sendCell;
        }
            break;
            
        case OrderTypeSending:
        {
            
            ZFSendingCell * sendCell = [self.zfb_tableView
                                        dequeueReusableCellWithIdentifier:contentCellid forIndexPath:indexPath];
            sendCell.selectionStyle = UITableViewCellSelectionStyleNone;
            Orderlist * list           = self.orderListArray[indexPath.section];
            NSMutableArray * goodArray = [NSMutableArray array];
            for (Ordergoods * ordergoods in list.orderGoods) {
                [goodArray addObject:ordergoods];
            }
            Ordergoods * goods = goodArray[indexPath.row];
            sendCell.goods = goods;
            return sendCell;
        }
            break;
            
        case OrderTypeSended:
        {
            ZFSendingCell * sendCell = [self.zfb_tableView
                                        dequeueReusableCellWithIdentifier:contentCellid forIndexPath:indexPath];
            sendCell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            Orderlist * list           = self.orderListArray[indexPath.section];
            NSMutableArray * goodArray = [NSMutableArray array];
            for (Ordergoods * ordergoods in list.orderGoods) {
                
                [goodArray addObject:ordergoods];
            }
            Ordergoods * goods = goodArray[indexPath.row];
            sendCell.goods = goods;
            return sendCell;
        }
            break;
        case OrderTypeDealSuccess:
        {
            
            DealSucessCell * successCell = [self.zfb_tableView
                                        dequeueReusableCellWithIdentifier:dealSucessCellid forIndexPath:indexPath];
            successCell.indexRow = indexPath.row;
            successCell.indexPath = indexPath;

            Orderlist * list           = self.orderListArray[indexPath.section];
            NSMutableArray * goodArray = [NSMutableArray array];
            for (Ordergoods * ordergoods in list.orderGoods) {
                [goodArray addObject:ordergoods];
            }
            Ordergoods * goods = goodArray[indexPath.row];
            successCell.orderGoods = goods;
            successCell.delegate = self;

            return successCell;
        }
            break;
            
        case OrderTypeCancelSuccess:
        {
            
            ZFSendingCell * sendCell = [self.zfb_tableView
                                        dequeueReusableCellWithIdentifier:contentCellid forIndexPath:indexPath];
            sendCell.selectionStyle = UITableViewCellSelectionStyleNone;
            Orderlist * list           = self.orderListArray[indexPath.section];
            NSMutableArray * goodArray = [NSMutableArray array];
            for (Ordergoods * ordergoods in list.orderGoods) {
                
                [goodArray addObject:ordergoods];
            }
            Ordergoods * goods = goodArray[indexPath.row];
            sendCell.goods = goods;
            return sendCell;
        }
            break;
        case OrderTypeAfterSale:
        {
            if (self.tagNum == 0) {
                
                if (indexPath.section == 0){
                    
                    ZFSaleAfterSearchCell* searchCell = [self.zfb_tableView dequeueReusableCellWithIdentifier:saleAfterSearchCellid forIndexPath:indexPath];
                    searchCell.delegate = self;
                    return  searchCell;
                    
                }else{
                    
                    ZFSaleAfterContentCell* contentell = [self.zfb_tableView dequeueReusableCellWithIdentifier:saleAfterContentCellid forIndexPath:indexPath];
                    contentell.delegate                = self;
                    
                    Orderlist * list           = self.orderListArray[indexPath.section -1];
                    NSMutableArray * goodArray = [NSMutableArray array];
                    for (Ordergoods * ordergoods in list.orderGoods) {
                        [goodArray addObject:ordergoods];
                    }
                    Ordergoods * goods = goodArray[indexPath.row];
                    contentell.goods   = goods;
                    contentell.indexPath = indexPath;
                    return   contentell;
                }
                
            }else if (self.tagNum ==1){
                List * progress                   = self.progressArray[indexPath.row];
                ZFCheckTheProgressCell *checkCell = [self.zfb_tableView dequeueReusableCellWithIdentifier:saleAfterProgressCellid forIndexPath:indexPath];
                checkCell.deldegate      = self;
                checkCell.progressList   = progress;
                checkCell.indexpath      = indexPath.row;
                
                return  checkCell;
                
            }
        }
            break;
            
    }
    return nil;
    
}

#pragma mark - tableView datasource
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@" section = %ld ， row = %ld",indexPath.section,indexPath.row);
    
    ZFDetailOrderViewController * detailVc =[[ ZFDetailOrderViewController alloc]init];
    Orderlist * orderlist    = self.orderListArray [indexPath.section];
    NSMutableArray * goodarr = [NSMutableArray array];
    
    for (Ordergoods * goods in orderlist.orderGoods) {
        
        [goodarr addObject:goods];
    }
    Ordergoods * goods = goodarr[indexPath.row];
    
    detailVc.cmOrderid = goods.order_id;
    detailVc.storeId = orderlist.storeId;
    
    switch (_orderType) {
        case OrderTypeAllOrder:
            
            [self.navigationController pushViewController:detailVc animated:YES];
            
            break;
        case OrderTypeWaitPay:
            
            [self.navigationController pushViewController:detailVc animated:YES];
            
            break;
        case OrderTypeWaitSend:
            
            [self.navigationController pushViewController:detailVc animated:YES];
            
            break;
        case OrderTypeSending:
            
            [self.navigationController pushViewController:detailVc animated:YES];
            
            break;
        case OrderTypeSended:
            
            [self.navigationController pushViewController:detailVc animated:YES];
            
            break;
        case OrderTypeDealSuccess:
            
            [self.navigationController pushViewController:detailVc animated:YES];
            
            break;
        case OrderTypeCancelSuccess:
            
            [self.navigationController pushViewController:detailVc animated:YES];
            
            break;
        case OrderTypeAfterSale:
            
            if (self.tagNum == 0) {
                if (indexPath.section ==0) {
                    
                    NSLog(@" tagNum 0  section = %ld ， row = %ld",indexPath.section,indexPath.row);
                    
                }else{
                    NSLog(@" tagNum 0  section = %ld ， row = %ld",indexPath.section,indexPath.row);

                }
                
            }
            else{
                NSLog(@" tagNum 1  section = %ld ， row = %ld",indexPath.section,indexPath.row);

            }
 
            break;
    }
    
    
}


/**
 确认付款
 @param clearbtn pay
 */
-(void)didClickClearing:(UIButton *)clearbtn
{
    ZFMainPayforViewController * payVC = [[ZFMainPayforViewController alloc]init];
    
    [self.navigationController pushViewController:payVC animated:YES];
}

#pragma mark - ZFpopViewDelegate 选择一个type
-(void)sendTitle:(NSString *)title orderType:(OrderType)type
{
    self.titles =@[@"全部订单",@"待付款",@"待配送",@"配送中",@"已配送",@"交易完成",@"交易取消",@"售后申请",];

    [UIView animateWithDuration:0.3 animations:^{
        if (self.bgview.superview) {
            [self.bgview removeFromSuperview];
            
        }
    }];
    
    _orderType = type;//赋值type ，根据type请求
    
    [self.navbar_btn setTitle:title forState:UIControlStateNormal];
    
    //0待配送 1配送中 2配送完成,3.交易完成，4.待付款，6,待上门取件，-1.关闭
    
    switch (_orderType) {//-1：关闭,0待配送 1配送中 2.配送完成，3交易完成（用户确认收货），4.待付款,5.待审批,6.待退回，7.服务完成
            
        case OrderTypeAllOrder://全部订单
            
            [self allOrderPostRequsetWithOrderStatus:@"" orderNum:@""];
            break;
        case OrderTypeWaitPay://待付款
            
            [self allOrderPostRequsetWithOrderStatus:@"4" orderNum:@""];
            
            break;
        case OrderTypeWaitSend://待配送
            
            [self allOrderPostRequsetWithOrderStatus:@"0"  orderNum:@""];
            
            break;
        case OrderTypeSending://配送中
            [self allOrderPostRequsetWithOrderStatus:@"1"  orderNum:@""];
            
            break;
        case OrderTypeSended://已配送
            
            [self allOrderPostRequsetWithOrderStatus:@"2"  orderNum:@""];
            
            break;
        case OrderTypeDealSuccess://交易成功
            
            [self allOrderPostRequsetWithOrderStatus:@"3" orderNum:@""];

            break;
        case OrderTypeCancelSuccess://取消交易
            
            [self allOrderPostRequsetWithOrderStatus:@"-1" orderNum:@""];
            
            break;
        case OrderTypeAfterSale://售后
            
            
            [self allOrderPostRequsetWithOrderStatus:@"2" orderNum:@""];
            
            BBUserDefault.keyWord = @"";
            
            self.searchBar.text = @"";
            
            break;
            
    }
    
    
}

#pragma mark - ZFSaleAfterTopViewDelegate   售后申请的2种状态
-(void)sendAtagNum:(NSInteger)tagNum
{
    self.tagNum = tagNum;
    
    if (tagNum == 0) {
        
        NSLog(@"申请售后,刷新列表tagnum                 = %ld",tagNum);
        [self allOrderPostRequsetWithOrderStatus:@"2" orderNum:@""];
        [self.zfb_tableView reloadData];
        
    }else{
        
        NSLog(@"进度查询,刷新列表tagnum                 = %ld",tagNum);
        [self salesAfterPostRequste];
        [self.zfb_tableView reloadData];
        
        
    }
}

#pragma mark  - ZFCheckTheProgressCellDelegate 进度查询delegete
-(void)progressWithCheckoutIndexPath:(NSInteger)indexpath
{
    NSLog(@"我点击了 ------- %ld行",indexpath);
    List * progress                         = self.progressArray[indexpath];
    ZFPregressCheckViewController * checkVC = [[ZFPregressCheckViewController alloc]init];
    checkVC.afterSaleId                     = progress.saleId;
    [self.navigationController pushViewController:checkVC animated:YES];
    
}

#pragma mark - ZFSaleAfterContentCellDelegate 申请售后
-(void)salesAfterDetailPageWithIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"申请售后 --- %@",indexPath);
    Orderlist * orderlist = self.orderListArray[indexPath.section-1];
    NSMutableArray * goodArray = [NSMutableArray array];
    for (Ordergoods * ordergoods in orderlist.orderGoods) {
        [goodArray addObject:ordergoods];
    }
    Ordergoods * goods = goodArray[indexPath.row];
    ZFApplyBackgoodsViewController * saleAfterVC  = [ZFApplyBackgoodsViewController new];
    

    
    saleAfterVC.goodsName = goods.goods_name;
    saleAfterVC.price = [NSString stringWithFormat:@"%@",goods.purchase_price];
    saleAfterVC.goodCount = [NSString stringWithFormat:@"%ld",goods.goodsCount];
    saleAfterVC.img_urlStr = goods.coverImgUrl;
    
    ///需要发送到售后申请的数据
    saleAfterVC.orderId = goods.order_id;
    saleAfterVC.goodsId = goods.goodsId;
    saleAfterVC.coverImgUrl = goods.coverImgUrl;
    saleAfterVC.orderGoodsId = goods.orderGoodsId;//商品唯一编号
    
    saleAfterVC.serviceType = @"0";///服务类型	否	 0 退货 1 换货
    saleAfterVC.orderNum = orderlist.orderCode;
    saleAfterVC.storeId = orderlist.storeId;
    saleAfterVC.orderTime = orderlist.createTime;
    saleAfterVC.storeName = orderlist.storeName;
    saleAfterVC.postPhone = orderlist.post_phone;
    saleAfterVC.postName = orderlist.post_name;
    //规格转成json
    NSString * jsonGoodsPro =[ NSString arrayToJSONString:goods.goods_properties];
    if (jsonGoodsPro == nil) {
        jsonGoodsPro = @"[]";
    }
    saleAfterVC.goodsProperties = jsonGoodsPro;
    
    [self.navigationController pushViewController: saleAfterVC animated:NO];
    
    
}

#pragma mark - 全部订单 网络请求 getOrderListBystatus
-(void)allOrderPostRequsetWithOrderStatus :(NSString *)orderStatus
                                 orderNum :(NSString *)orderNum
{
    NSDictionary * param = @{
                             
                             @"size":[NSNumber numberWithInteger:kPageCount] ,
                             @"page":[NSNumber numberWithInteger:self.currentPage],
                             @"orderStatus":orderStatus,
                             @"cmUserId":BBUserDefault.cmUserId,
                             @"orderNum":orderNum,
                             
                             };
    
    [SVProgressHUD show];
    
    [MENetWorkManager post:[zfb_baseUrl stringByAppendingString:@"/order/getOrderListBystatus"] params:param success:^(id response) {
        
        if ([response[@"resultCode"] intValue] == 0) {
            
            if (self.refreshType == RefreshTypeHeader) {
             
                if (self.orderListArray.count > 0 ) {
                    
                    [self.orderListArray removeAllObjects];
                }
                
            }
            AllOrderModel * allorder = [AllOrderModel mj_objectWithKeyValues:response];
            
            for (Orderlist * list in allorder.orderList) {
                
                [self.orderListArray addObject:list];
                
            }
            [SVProgressHUD dismiss];
            [self.zfb_tableView reloadData];
            
//            if ([self isEmptyArray:self.orderListArray]) {
//                
//                [self.zfb_tableView cyl_reloadData];
//            }
        }
        NSLog(@"orderListArray ====%@",self.orderListArray);
        [self endRefresh];
        
    } progress:^(NSProgress *progeress) {
        
    } failure:^(NSError *error) {
        [SVProgressHUD dismiss];
        [self endRefresh];
        
        NSLog(@"error=====%@",error);
        [self.view makeToast:@"网络错误" duration:2 position:@"center"];
    }];
}

#pragma mark -  取消订单接口    order/updateOrderInfo
-(void)cancleOrderPostWithOrderNum:(NSString *)orderNum orderStatus:(NSString *)orderStatus{
    NSDictionary * param = @{
                             
                             @"orderNum":orderNum,
                             @"orderStatus":orderStatus,
                             
                             };
    
    [MENetWorkManager post:[NSString stringWithFormat:@"%@/order/updateOrderInfo",zfb_baseUrl] params:param success:^(id response) {
        
        [self.view makeToast:response[@"resultMsg"] duration:2 position:@"center"];
        //成功后需要刷新列表
        switch (_orderType) {//-1：关闭,0待配送 1配送中 2.配送完成，3交易完成（用户确认收货），4.待付款,5.待审批,6.待退回，7.服务完成
                
            case OrderTypeAllOrder://全部订单
                
                [self allOrderPostRequsetWithOrderStatus:@"" orderNum:@""];
                break;
            case OrderTypeWaitPay://待付款
                
                [self allOrderPostRequsetWithOrderStatus:@"4"  orderNum:@""];
                
                break;
            case OrderTypeWaitSend://待配送
                
                break;
            case OrderTypeSending://配送中
                
                break;
            case OrderTypeSended://已配送
                
                break;
            case OrderTypeDealSuccess://交易成功
                
                break;
            case OrderTypeCancelSuccess://取消交易
                
                break;
            case OrderTypeAfterSale://售后
                
                break;
        }
        
    } progress:^(NSProgress *progeress) {
        
        NSLog(@"progeress=====%@",progeress);
        
    } failure:^(NSError *error) {
        
        NSLog(@"error=====%@",error);
        [self.view makeToast:@"网络错误" duration:2 position:@"center"];
    }];
    
}

#pragma mark - 用户确认收货接口 order/userConfirmReceipt
-(void)receiveUserConfirmReceiptPostDeliveryId:(NSString *)deliveryId
                                       storeId:(NSString *)storeId
                                   deliveryFee:(NSString *)deliveryFee
                                      orderNum:(NSString *)orderNum
                                        userId:(NSString *)userId
                                   orderAmount:(NSString *)orderAmount
                                     storeName:(NSString *)storeName
                                   orderDetail:(NSString *)orderDetail

{
    NSDictionary * param = @{
                             
                             @"deliveryId":deliveryId,
                             @"storeId":storeId,
                             @"deliveryFee":deliveryFee,
                             @"orderNum":orderNum,
                             @"userId":BBUserDefault.cmUserId,
                             @"orderAmount":orderAmount,//订单金额
                             @"orderDetail":orderDetail,//订单详情
                             @"storeName":storeName,
                             
                             };
    
    [SVProgressHUD show];
    [MENetWorkManager post:[zfb_baseUrl stringByAppendingString:@"/order/userConfirmReceipt"] params:param success:^(id response) {
        
        if ([response[@"resultCode"] intValue] == 0) {
            
            [SVProgressHUD dismiss];
        }
        
    } progress:^(NSProgress *progeress) {
        
    } failure:^(NSError *error) {
        [SVProgressHUD dismiss];
        
        NSLog(@"error=====%@",error);
        [self.view makeToast:@"网络错误" duration:2 position:@"center"];
    }];
    
}
#pragma mark - 售后申请 ------  列表 getOrderListBystatus
-(void)saleAfterCheckOrderlistPostwithOrderStatus :(NSString *)orderStatus
                                    SearchWord :(NSString *)searchWord
{
    NSDictionary * param = @{
                             
                             @"size":[NSNumber numberWithInteger:kPageCount] ,
                             @"page":[NSNumber numberWithInteger:self.currentPage],
                             @"orderStatus":orderStatus,
                             @"cmUserId":BBUserDefault.cmUserId,//如果是商户端不传userid
                             @"searchWord":searchWord,
                             };
    
    [SVProgressHUD show];
    
    [MENetWorkManager post:[zfb_baseUrl stringByAppendingString:@"/order/getOrderListBystatus"] params:param success:^(id response) {
        
        if ([response[@"resultCode"] intValue] == 0) {
            
            if (self.refreshType == RefreshTypeHeader) {
                if (self.orderListArray.count > 0 ) {
                    
                    [self.orderListArray removeAllObjects];
                }
            }
            AllOrderModel * allorder = [AllOrderModel mj_objectWithKeyValues:response];
            
            for (Orderlist * list in allorder.orderList) {
                
                [self.orderListArray addObject:list];
                
            }
            [SVProgressHUD dismiss];
            [self.zfb_tableView reloadData];

        }
        NSLog(@"orderListArray ====%@",self.orderListArray);
        [self endRefresh];
        
    } progress:^(NSProgress *progeress) {
        
    } failure:^(NSError *error) {
        [SVProgressHUD dismiss];
        [self endRefresh];
        
        NSLog(@"error=====%@",error);
        [self.view makeToast:@"网络错误" duration:2 position:@"center"];
    }];
}

#pragma mark - 查询进度 列表     zfb/InterfaceServlet/afterSale/afterSaleList
-(void)salesAfterPostRequste
{
    NSDictionary * param = @{
                             
                             @"size":[NSNumber numberWithInteger:kPageCount] ,
                             @"page":[NSNumber numberWithInteger:self.currentPage],
                             @"cmUserId":BBUserDefault.cmUserId,
                             
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
            
            [self.zfb_tableView reloadData];
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
#pragma mark - DealSucessCellDelegate 晒单、共享代理
/**
 晒单代理
 @param indexPath 当前下标
 @param orderId 订单id
 */
-(void)shareOrderWithIndexPath:(NSIndexPath*)indexPath AndOrderId:(NSString *)orderId
{
    NSLog(@"indexPath ==%@,orderId== %@",indexPath,orderId);
    Orderlist * list           = self.orderListArray[indexPath.section];
    NSMutableArray * goodArray = [NSMutableArray array];
    for (Ordergoods * ordergoods in list.orderGoods) {
        [goodArray addObject:ordergoods];
    }
    Ordergoods * goods = goodArray[indexPath.row];
    //去晒单
    ZFEvaluateGoodsViewController * vc = [ZFEvaluateGoodsViewController new];
    vc.goodsImg =  goods.coverImgUrl;
    vc.goodId = goods.goodsId;
    vc.storeId = list.storeId;
    vc.storeName = list.storeName;
    vc.orderId = list.order_id;
    vc.orderNum = list.orderNum;
    [self.navigationController pushViewController:vc animated:NO];
}

//共享
-(void)didclickShareToFriendWithIndexPath:(NSIndexPath *)indexPath AndOrderId:(NSString *)orderId;
{
    Orderlist * list           = self.orderListArray[indexPath.section];
    NSMutableArray * goodArray = [NSMutableArray array];
    for (Ordergoods * ordergoods in list.orderGoods) {
        [goodArray addObject:ordergoods];
    }
    Ordergoods * goods = goodArray[indexPath.row];
    PublishShareViewController *  publishvc = [PublishShareViewController new];
    publishvc.goodId = goods.goodsId;
    [self.navigationController pushViewController:publishvc animated:NO];
}
#pragma mark - ZFFooterCellDelegate footer跳转的代理
-(void)allOrdersActionOfindexPath:(NSInteger)indexPath
{
    ZFDetailOrderViewController * detailVc =[[ ZFDetailOrderViewController alloc]init];
    Orderlist * orderlist = self.orderListArray [indexPath];
    NSLog(@"---------%ld",indexPath);
    switch (_orderType) {
        case OrderTypeAllOrder://全部订单
            
            if ([orderlist.orderStatusName isEqualToString:@"已配送"]) {//button
                
                JXTAlertController * alertavc =[JXTAlertController alertControllerWithTitle:@"提示" message:@"亲,确认要收货吗" preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction * cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                    
                }];
                UIAlertAction * sureAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
                    //确认收货 - 成功后跳转交易完成 - 晒单
                    [self receiveUserConfirmReceiptPostDeliveryId:orderlist.deliveryId storeId:orderlist.storeId deliveryFee:[NSString stringWithFormat:@"%.2f",orderlist.orderDeliveryFee] orderNum:orderlist.orderCode userId:@"" orderAmount:orderlist.orderAmount storeName:orderlist.storeName orderDetail:orderlist.orderDetail];
                    
                }];
                [alertavc addAction:cancelAction];
                [alertavc addAction:sureAction];
                
                [self presentViewController:alertavc animated:YES completion:nil];
                
            }
            else if ([orderlist.orderStatusName isEqualToString:@"待付款"]) {
                if ( orderlist.payType == 0) {//如果 支付类型为线下则不跳转
                    //取消交易  - 取消后跳转到交易取消
                    JXTAlertController * alertavc =[JXTAlertController alertControllerWithTitle:@"提示" message:@"亲,是否取消该交易！" preferredStyle:UIAlertControllerStyleAlert];
                    UIAlertAction * cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                        
                    }];
                    UIAlertAction * sureAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
                        //取消交易  - 取消后跳转到交易取消
                        [self cancleOrderPostWithOrderNum:orderlist.orderCode orderStatus:@"-1"];
                    }];
                    
                    [alertavc addAction:cancelAction];
                    [alertavc addAction:sureAction];
                    
                    [self presentViewController:alertavc animated:YES completion:nil];
                }else{
                    //马上去付款页面
                    detailVc.cmOrderid = orderlist.order_id;
                    [self.navigationController pushViewController:detailVc animated:YES];
                }
            }
            
            else if ([orderlist.orderStatusName isEqualToString:@"交易完成"]) {
                
                //去晒单
                ZFEvaluateGoodsViewController * vc = [ZFEvaluateGoodsViewController new];
                [self.navigationController pushViewController:vc animated:NO];
            }
            
            break;
            
        case OrderTypeWaitPay:
            
            //马上去付款页面
            detailVc.cmOrderid = orderlist.order_id;
            [self.navigationController pushViewController:detailVc animated:YES];
            
            
            break;
        case OrderTypeWaitSend:
            
            break;
        case OrderTypeSending:
            
            break;
        case OrderTypeSended:
        {
            JXTAlertController * alertavc =[JXTAlertController alertControllerWithTitle:@"提示" message:@"亲,确认要收货吗" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction * cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                
            }];
            UIAlertAction * sureAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
                
                //确认收货 - 成功后跳转交易完成 - 晒单
                [self receiveUserConfirmReceiptPostDeliveryId:orderlist.deliveryId storeId:orderlist.storeId deliveryFee:[NSString stringWithFormat:@"%.2f",orderlist.orderDeliveryFee] orderNum:orderlist.orderCode userId:@"" orderAmount:orderlist.orderAmount storeName:orderlist.storeName orderDetail:orderlist.orderDetail];
                
            }];
            [alertavc addAction:cancelAction];
            [alertavc addAction:sureAction];
            
            [self presentViewController:alertavc animated:YES completion:nil];
            
        }
            break;
        case OrderTypeDealSuccess://交易成功后去晒单

            break;
        case OrderTypeCancelSuccess:
            
            break;
        case OrderTypeAfterSale:
            
            if (self.tagNum == 0) {
                
                if (indexPath == 0) {
                    
                }
                
            }else  if (self.tagNum == 1) {
                
                
            }
            
            break;
    }
    
}

//取消订单的代理方法
-(void)cancelOrderActionbyOrderNum:(NSString *)orderNum orderStatus:(NSString *)orderStatus payStatus:(NSString *)payStatus deliveryId:(NSString *)deliveryId indexPath:(NSInteger)indexPath
{
    switch (_orderType) {
        case OrderTypeAllOrder://确认付款
        {
            Orderlist * orderlist = self.orderListArray [indexPath];
            NSLog(@"---------%ld",indexPath);
            
            if ([orderlist.orderStatusName isEqualToString:@"已配送"]) {//button
                
            }
            else if ([orderlist.orderStatusName isEqualToString:@"待付款"]) {
                
                JXTAlertController * alertavc =[JXTAlertController alertControllerWithTitle:@"提示" message:@"亲,是否取消该交易！" preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction * cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                    
                }];
                UIAlertAction * sureAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
                    
                    //取消交易  - 取消后跳转到交易取消
                    [self cancleOrderPostWithOrderNum:orderlist.orderCode orderStatus:@"-1"];
                    
                }];
                [alertavc addAction:cancelAction];
                [alertavc addAction:sureAction];
                
                [self presentViewController:alertavc animated:YES completion:nil];
                
            }
            else if ([orderlist.orderStatusName isEqualToString:@"交易完成"]) {
                
            }
        }
            break;
            
        case OrderTypeWaitPay:
        {
            Orderlist * orderlist = self.orderListArray [indexPath];
            
            if ([orderlist.orderStatusName isEqualToString:@"待付款"]) {
                
                JXTAlertController * alertavc =[JXTAlertController alertControllerWithTitle:@"提示" message:@"亲,是否取消该交易！" preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction * cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                    
                }];
                UIAlertAction * sureAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
                    //取消交易  - 取消后跳转到交易取消
                    [self cancleOrderPostWithOrderNum:orderlist.orderCode orderStatus:@"-1"];
                    
                }];
                
                [alertavc addAction:cancelAction];
                [alertavc addAction:sureAction];
                
                [self presentViewController:alertavc animated:YES completion:nil];
                
            }
            
        }
            break;
        case OrderTypeWaitSend:
            
            break;
        case OrderTypeSending:
            
            break;
        case OrderTypeSended:
            
            break;
        case OrderTypeDealSuccess:
            
            break;
        case OrderTypeCancelSuccess:
            
            break;
        case OrderTypeAfterSale:
            
            if (self.tagNum == 0) {
                
                if (indexPath == 0) {
               
                }
                
            }else  if (self.tagNum == 1) {
                
            }
            
            break;
    }
}
#pragma mark - SaleAfterSearchCellDelegate 搜索代理
-(void)didClickSearchButtonSearchText:(NSString *)searchText
{
    if ([searchText isEqualToString:@""]) {
        
        NSLog(@"搜索条件不能为空");
        JXTAlertController * alertavc = [JXTAlertController alertControllerWithTitle:@"提示" message:@"搜索条件不能为空" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction * sureAction = [UIAlertAction actionWithTitle:@"知道了" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
 
        }];
        [alertavc addAction:sureAction];
        
        [self presentViewController:alertavc animated:YES completion:nil];

    }else{
        //开始搜索
        [self saleAfterCheckOrderlistPostwithOrderStatus:@"2" SearchWord:searchText];
         BBUserDefault.keyWord = searchText;
        
    }
}


-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
    
    [self.bgview removeFromSuperview];
    
    
}
-(void)viewWillDisappear:(BOOL)animated{
    
    [SVProgressHUD dismiss];
    
}

//重写返回方法
-(void)backAction{
    
    [self poptoUIViewControllerNibName:@"ZFPersonalViewController" AndObjectIndex:0];
    
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
    
    WeChatStylePlaceHolder *weChatStylePlaceHolder = [[WeChatStylePlaceHolder alloc] initWithFrame:self.zfb_tableView.frame];
    weChatStylePlaceHolder.delegate = self;
    return weChatStylePlaceHolder;
}
#pragma mark - WeChatStylePlaceHolderDelegate Method
- (void)emptyOverlayClicked:(id)sender {

    switch (_orderType) {//-1：关闭,0待配送 1配送中 2.配送完成，3交易完成（用户确认收货），4.待付款,5.待审批,6.待退回，7.服务完成
            
        case OrderTypeAllOrder://全部订单
            
            [self allOrderPostRequsetWithOrderStatus:@"" orderNum:@""];
            break;
        case OrderTypeWaitPay://待付款
            
            [self allOrderPostRequsetWithOrderStatus:@"4"  orderNum:@""];
            
            break;
        case OrderTypeWaitSend://待配送
            
            [self allOrderPostRequsetWithOrderStatus:@"0" orderNum:@""];
            
            break;
        case OrderTypeSending://配送中
            [self allOrderPostRequsetWithOrderStatus:@"1" orderNum:@""];
            
            break;
        case OrderTypeSended://已配送
            
            [self allOrderPostRequsetWithOrderStatus:@"2" orderNum:@""];
            
            break;
        case OrderTypeDealSuccess://交易成功
            
            [self allOrderPostRequsetWithOrderStatus:@"3"  orderNum:@""];
            
            break;
        case OrderTypeCancelSuccess://取消交易
            
            [self allOrderPostRequsetWithOrderStatus:@"-1"  orderNum:@""];
            
            break;
        case OrderTypeAfterSale://售后
            if (_tagNum == 0) {
                [self saleAfterCheckOrderlistPostwithOrderStatus:@"2" SearchWord:BBUserDefault.keyWord ];

            }else{
                [self salesAfterPostRequste];

            }
            
            break;
    }
}


-(void)dealloc
{
    BBUserDefault.keyWord = @"";
}
@end
