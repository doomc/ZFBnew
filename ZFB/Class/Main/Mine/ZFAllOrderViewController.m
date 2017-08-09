


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
//view
#import "ZFpopView.h"
#import "ZFSaleAfterTopView.h"
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
//model
#import "AllOrderModel.h"


static  NSString * headerCellid =@"ZFTitleCellid";//头id
static  NSString * contentCellid =@"ZFSendingCellid";//内容id
static  NSString * footerCellid =@"ZFFooterCellid";//尾部id

static  NSString * saleAfterHeadCellid =@"ZFSaleAfterHeadCellid";//头id
static  NSString * saleAfterContentCellid =@"saleAfterContentCellid";//内容id
static  NSString * saleAfterSearchCellid =@"ZFSaleAfterSearchCellid";//搜索cell
static  NSString * saleAfterProgressCellid =@"ZFCheckTheProgressCellid";//进度查询



@interface ZFAllOrderViewController ()<UITableViewDelegate,UITableViewDataSource,ZFpopViewDelegate,ZFSaleAfterTopViewDelegate,ZFCheckTheProgressCellDelegate,ZFSaleAfterContentCellDelegate,ZFFooterCellDelegate>
{
    NSInteger _pageCount;
    NSInteger _page;
    NSInteger _indexPath;
}

@property (nonatomic ,strong) UIView * titleView ;
@property (nonatomic ,strong) UIButton  *navbar_btn;//导航按钮
@property (nonatomic ,strong) UIView    * bgview;//蒙板
@property (nonatomic ,strong) NSArray   * titles;//选择页面

@property (nonatomic ,strong) NSArray   * saleTitles;//售后选择
@property (nonatomic ,assign) NSInteger tagNum;//售后选择


@property (nonatomic ,strong) UITableView * allOrder_tableView;//全部订单
@property (nonatomic ,strong) ZFpopView   * popView;

//售后搜索
@property (nonatomic ,strong) UISearchBar        * searchBar;
@property (nonatomic ,strong) ZFSaleAfterTopView * topView;

///全部订单-数据源
@property (nonatomic ,strong) NSMutableArray * orderListArray;//全部订单头数组


///售后申请-数据源
@property (nonatomic ,strong) NSMutableArray * salesAfterArray;//售后数组


@end

@implementation ZFAllOrderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.tagNum = 0;//默认为售后申请
    //默认一个页码 和 页数
    _pageCount = 15;
    _page      = 1;
    
    self.saleTitles = @[@"申请售后",@"进度查询"];
    
    self.titles =@[@"全部订单",@"待付款",@"待配送",@"配送中",@"已配送",@"交易完成",@"交易取消",@"售后申请",];
    
    [self.navbar_btn setTitle:_buttonTitle forState:UIControlStateNormal];
    
    [self.view addSubview:self.allOrder_tableView];
    
    [self.allOrder_tableView registerNib:[UINib nibWithNibName:@"ZFSendingCell" bundle:nil]
                  forCellReuseIdentifier:contentCellid];
    [self.allOrder_tableView registerNib:[UINib nibWithNibName:@"ZFTitleCell" bundle:nil]
                  forCellReuseIdentifier:headerCellid];
    [self.allOrder_tableView registerNib:[UINib nibWithNibName:@"ZFFooterCell" bundle:nil]
                  forCellReuseIdentifier:footerCellid];
    
    [self.allOrder_tableView registerNib:[UINib nibWithNibName:@"ZFSaleAfterHeadCell" bundle:nil]
                  forCellReuseIdentifier:saleAfterHeadCellid];
    [self.allOrder_tableView registerNib:[UINib nibWithNibName:@"ZFSaleAfterContentCell" bundle:nil]
                  forCellReuseIdentifier:saleAfterContentCellid];
    [self.allOrder_tableView registerNib:[UINib nibWithNibName:@"ZFSaleAfterSearchCell" bundle:nil]
                  forCellReuseIdentifier:saleAfterSearchCellid];
    [self.allOrder_tableView registerNib:[UINib nibWithNibName:@"ZFCheckTheProgressCell" bundle:nil]
                  forCellReuseIdentifier:saleAfterProgressCellid];
    
    [self allOrderPostRequsetWithOrderStatus:_orderStatus size:[NSString stringWithFormat:@"%ld",_pageCount] page:[NSString stringWithFormat:@"%ld",_page] orderNum:@""];
    
    //    [self refreshData];
}

-(void)refreshData
{
    
    weakSelf(weakSelf);
    weakSelf.allOrder_tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        
        if (self.orderListArray.count > _pageCount * _page) {
            
            _page ++ ;
            
        }else{
            
            _page = 1;
        }
        
        switch (_orderType) {//-1：关闭,0待配送 1配送中 2.配送完成，3交易完成（用户确认收货），4.待付款,5.待审批,6.待退回，7.服务完成
                
            case OrderTypeAllOrder://全部订单
                
                [weakSelf allOrderPostRequsetWithOrderStatus:@"" size:[NSString stringWithFormat:@"%ld",_pageCount] page:[NSString stringWithFormat:@"%ld",_page ]orderNum:@""];
                break;
            case OrderTypeWaitPay://待付款
                
                [weakSelf allOrderPostRequsetWithOrderStatus:@"4" size:[NSString stringWithFormat:@"%ld",_pageCount] page:[NSString stringWithFormat:@"%ld",_page]orderNum:@""];
                
                break;
            case OrderTypeWaitSend://待配送
                
                [weakSelf allOrderPostRequsetWithOrderStatus:@"0" size:[NSString stringWithFormat:@"%ld",_pageCount] page:[NSString stringWithFormat:@"%ld",_page]orderNum:@""];
                
                break;
            case OrderTypeSending://配送中
                [weakSelf allOrderPostRequsetWithOrderStatus:@"1" size:[NSString stringWithFormat:@"%ld",_pageCount] page:[NSString stringWithFormat:@"%ld",_page]orderNum:@""];
                
                break;
            case OrderTypeSended://已配送
                
                [weakSelf allOrderPostRequsetWithOrderStatus:@"2" size:[NSString stringWithFormat:@"%ld",_pageCount] page:[NSString stringWithFormat:@"%ld",_page]orderNum:@""];
                
                break;
            case OrderTypeDealSuccess://交易成功
                
                [weakSelf allOrderPostRequsetWithOrderStatus:@"3" size:[NSString stringWithFormat:@"%ld",_pageCount] page:[NSString stringWithFormat:@"%ld",_page]orderNum:@""];
                
                break;
            case OrderTypeCancelSuccess://取消交易
                
                [weakSelf allOrderPostRequsetWithOrderStatus:@"-1" size:[NSString stringWithFormat:@"%ld",_pageCount] page:[NSString stringWithFormat:@"%ld",_page]orderNum:@""];
                
                break;
            case OrderTypeAfterSale://售后
                
                
                [weakSelf allOrderPostRequsetWithOrderStatus:@"2" size:[NSString stringWithFormat:@"%ld",_pageCount] page:[NSString stringWithFormat:@"%ld",_page]orderNum:@""];
                
                break;
        }
        
    }];
    
    //下拉刷新
    weakSelf.allOrder_tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        //需要将页码设置为1
        _page = 1;
        switch (_orderType) {//-1：关闭,0待配送 1配送中 2.配送完成，3交易完成（用户确认收货），4.待付款,5.待审批,6.待退回，7.服务完成
                
            case OrderTypeAllOrder://全部订单
                
                [weakSelf allOrderPostRequsetWithOrderStatus:@"" size:[NSString stringWithFormat:@"%ld",_pageCount] page:[NSString stringWithFormat:@"%ld",_page ]orderNum:@""];
                break;
            case OrderTypeWaitPay://待付款
                
                [weakSelf allOrderPostRequsetWithOrderStatus:@"4" size:[NSString stringWithFormat:@"%ld",_pageCount] page:[NSString stringWithFormat:@"%ld",_page]orderNum:@""];
                
                break;
            case OrderTypeWaitSend://待配送
                
                [weakSelf allOrderPostRequsetWithOrderStatus:@"0" size:[NSString stringWithFormat:@"%ld",_pageCount] page:[NSString stringWithFormat:@"%ld",_page]orderNum:@""];
                
                break;
            case OrderTypeSending://配送中
                [weakSelf allOrderPostRequsetWithOrderStatus:@"1" size:[NSString stringWithFormat:@"%ld",_pageCount] page:[NSString stringWithFormat:@"%ld",_page]orderNum:@""];
                
                break;
            case OrderTypeSended://已配送
                
                [weakSelf allOrderPostRequsetWithOrderStatus:@"2" size:[NSString stringWithFormat:@"%ld",_pageCount] page:[NSString stringWithFormat:@"%ld",_page]orderNum:@""];
                
                break;
            case OrderTypeDealSuccess://交易成功
                
                [weakSelf allOrderPostRequsetWithOrderStatus:@"3" size:[NSString stringWithFormat:@"%ld",_pageCount] page:[NSString stringWithFormat:@"%ld",_page]orderNum:@""];
                
                break;
            case OrderTypeCancelSuccess://取消交易
                
                [weakSelf allOrderPostRequsetWithOrderStatus:@"-1" size:[NSString stringWithFormat:@"%ld",_pageCount] page:[NSString stringWithFormat:@"%ld",_page]orderNum:@""];
                
                break;
            case OrderTypeAfterSale://售后
                
                
                [weakSelf allOrderPostRequsetWithOrderStatus:@"2" size:[NSString stringWithFormat:@"%ld",_pageCount] page:[NSString stringWithFormat:@"%ld",_page]orderNum:@""];
                
                break;
        }
    }];
    
}

#pragma mark -   视图售后初始化
-(ZFSaleAfterTopView *)topView{
    if (!_topView) {
        _topView  =[[ZFSaleAfterTopView alloc]initWithFrame:CGRectMake(0, 64, KScreenW, 40) titleArr:self.saleTitles];
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
-(UITableView *)allOrder_tableView
{
    if (!_allOrder_tableView) {
        _allOrder_tableView                = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, KScreenW, KScreenH-64) style:UITableViewStylePlain];
        _allOrder_tableView.delegate       = self;
        _allOrder_tableView.dataSource     = self;
        _allOrder_tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return _allOrder_tableView;
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
            sectionNum = self.orderListArray.count;
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
            
            rowNum = goodsArray.count;
            break;
        case OrderTypeCancelSuccess:
            
            rowNum = goodsArray.count;
            break;
        case OrderTypeAfterSale:
            
            if (self.tagNum == 0) {
                
                if (section == 0) {
                    
                    rowNum = 1;
                    
                }
                
                rowNum = goodsArray.count;
                
            }else  if (self.tagNum == 1) {
                
                rowNum = 3;
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
                    
                    height = 56;
                    
                }
                height = 50;
                
                
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
            ZFTitleCell * titleCell = [self.allOrder_tableView
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
            ZFTitleCell * titleCell = [self.allOrder_tableView
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
            ZFTitleCell * titleCell = [self.allOrder_tableView
                                       dequeueReusableCellWithIdentifier:@"ZFTitleCellid"];
            if (self.orderListArray.count > 0) {
                
                Orderlist  * sectionList = self.orderListArray[section];
                titleCell.orderlist      = sectionList;
            }
            return titleCell;
        }
            
            break;
        case OrderTypeSending:{
            ZFTitleCell * titleCell = [self.allOrder_tableView
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
            ZFTitleCell * titleCell = [self.allOrder_tableView
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
            ZFTitleCell * titleCell = [self.allOrder_tableView
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
            ZFTitleCell * titleCell = [self.allOrder_tableView
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
                    
                }
                if (section > 0){
                    
                    ZFSaleAfterHeadCell* HeadCell = [self.allOrder_tableView
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
            ZFFooterCell * cell = [self.allOrder_tableView
                                   dequeueReusableCellWithIdentifier:footerCellid];
            cell.footDelegate = self;
#warning -----没获取 当前的 indexPath
            Orderlist  * orderlist = self.orderListArray[section];
            cell.orderlist         = orderlist;
            _indexPath             = section;
            //默认值
            if ([orderlist.orderStatusName isEqualToString:@"已配送"]) {
                [cell.payfor_button  setTitle:@"确认收货" forState:UIControlStateNormal];
                [cell.cancel_button  setHidden:YES];
            }
            else if ([orderlist.orderStatusName isEqualToString:@"待付款"]) {
                [cell.cancel_button  setTitle:@"取消" forState:UIControlStateNormal];
                [cell.payfor_button  setTitle:@"去付款" forState:UIControlStateNormal];
            }
            else if ([orderlist.orderStatusName isEqualToString:@"待配送"] ||[orderlist.orderStatusName isEqualToString:@"交易取消"] ||[orderlist.orderStatusName isEqualToString:@"配送中"]) {
                [cell.cancel_button  setHidden:YES];
                [cell.payfor_button  setHidden:YES];
            }
            else if ([orderlist.orderStatusName isEqualToString:@"交易完成"]) {
                [cell.cancel_button  setHidden:YES];
                [cell.payfor_button  setTitle:@"晒单" forState:UIControlStateNormal];
            }
            
            view = cell;
            
        }
            break;
        case OrderTypeWaitPay://待付款
        {
            ZFFooterCell * cell = [self.allOrder_tableView
                                   dequeueReusableCellWithIdentifier:footerCellid];
            cell.footDelegate = self;
            //没获取 当前的 indexPath
            Orderlist  * orderlist = self.orderListArray[section];
            cell.orderlist         = orderlist;
            _indexPath             = section;
            
            [cell.payfor_button  setTitle:@"去付款" forState:UIControlStateNormal];
            [cell.cancel_button  setTitle:@"取消" forState:UIControlStateNormal];
            
            view = cell;
            
        }
            
            break;
        case OrderTypeWaitSend://待配送
        {
            ZFFooterCell * cell = [self.allOrder_tableView
                                   dequeueReusableCellWithIdentifier:footerCellid];
            
            cell.footDelegate      = self;
            Orderlist  * orderlist = self.orderListArray[section];
            cell.orderlist         = orderlist;
            _indexPath             = section;
            
            
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
            ZFFooterCell * cell = [self.allOrder_tableView
                                   dequeueReusableCellWithIdentifier:footerCellid];
            cell.footDelegate = self;
            
            Orderlist  * footList = self.orderListArray[section];
            cell.orderlist        = footList;
            _indexPath            = section;
            
            [cell.cancel_button setHidden:YES];
            [cell.payfor_button setHidden:YES];
            
            view = cell;
            
        }
            break;
            
        case OrderTypeSended://已配送
        {
            ZFFooterCell * cell = [self.allOrder_tableView
                                   dequeueReusableCellWithIdentifier:footerCellid];
            cell.footDelegate = self;
            
            Orderlist  * footList = self.orderListArray[section];
            cell.orderlist        = footList;
            _indexPath            = section;
            
            [cell.cancel_button setHidden:YES];
            [cell.payfor_button setTitle:@"确认收货" forState:UIControlStateNormal];
            
            view = cell;
            
        }
            break;
        case OrderTypeDealSuccess://交易完成
        {
            ZFFooterCell * cell = [self.allOrder_tableView
                                   dequeueReusableCellWithIdentifier:footerCellid];
            cell.footDelegate = self;
            
            Orderlist  * footList = self.orderListArray[section];
            cell.orderlist        = footList;
            _indexPath            = section;
            
            [cell.cancel_button setHidden:YES];
            [cell.payfor_button setTitle:@"晒单" forState:UIControlStateNormal];
            view = cell;
            
        }
            break;
        case OrderTypeCancelSuccess://交易失败
        {
            ZFFooterCell * cell = [self.allOrder_tableView
                                   dequeueReusableCellWithIdentifier:footerCellid];
            cell.footDelegate = self;
            
            Orderlist  * footList = self.orderListArray[section];
            cell.orderlist        = footList;
            _indexPath            = section;
            
            [cell.cancel_button setHidden:YES];
            [cell.payfor_button setHidden:YES];
            view = cell;
            
        }
            break;
            
        case OrderTypeAfterSale:
            
            return view;
            break;
    }
    //
    return view;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
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
                if (indexPath.section ==0) {
                    
                    return 56;
                }
                height = 82;
                
            }
            else{
                height = 154;
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
            ZFSendingCell * sendCell = [self.allOrder_tableView
                                        dequeueReusableCellWithIdentifier:contentCellid forIndexPath:indexPath];
            sendCell.selectionStyle = UITableViewCellSelectionStyleNone;
            
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
            
            ZFSendingCell * sendCell = [self.allOrder_tableView
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
            
            
        case OrderTypeWaitSend:
        {
            
            ZFSendingCell * sendCell = [self.allOrder_tableView
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
            
            ZFSendingCell * sendCell = [self.allOrder_tableView
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
            
            ZFSendingCell * sendCell = [self.allOrder_tableView
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
            
            ZFSendingCell * sendCell = [self.allOrder_tableView
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
            
        case OrderTypeCancelSuccess:
        {
            
            ZFSendingCell * sendCell = [self.allOrder_tableView
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
                    
                    ZFSaleAfterSearchCell* searchCell = [self.allOrder_tableView dequeueReusableCellWithIdentifier:saleAfterSearchCellid forIndexPath:indexPath];
                    searchCell.selectionStyle         = UITableViewCellSelectionStyleNone;
                    return  searchCell;
                    
                }
                
                ZFSaleAfterContentCell* contentell = [self.allOrder_tableView dequeueReusableCellWithIdentifier:saleAfterContentCellid forIndexPath:indexPath];
                contentell.selectionStyle          = UITableViewCellSelectionStyleNone;
                contentell.delegate                = self;
                
                Orderlist * list           = self.orderListArray[indexPath.section];
                NSMutableArray * goodArray = [NSMutableArray array];
                for (Ordergoods * ordergoods in list.orderGoods) {
                    [goodArray addObject:ordergoods];
                }
                Ordergoods * goods = goodArray[indexPath.row];
                contentell.goods   = goods;
                
                return   contentell;
                
            }else if (self.tagNum ==1){
                
                ZFCheckTheProgressCell *checkCell = [self.allOrder_tableView
                                                     
                                                     dequeueReusableCellWithIdentifier:saleAfterProgressCellid forIndexPath:indexPath];
                checkCell.selectionStyle = UITableViewCellSelectionStyleNone;
                
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
    
#warning 改动过 需要把修改的值放到里面
    [self.navigationController pushViewController:detailVc animated:YES];
    
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
            
            [self allOrderPostRequsetWithOrderStatus:@"" size:[NSString stringWithFormat:@"%ld",_pageCount] page:[NSString stringWithFormat:@"%ld",_page ] orderNum:@""];
            [self.allOrder_tableView reloadData];
            break;
        case OrderTypeWaitPay://待付款
            
            [self allOrderPostRequsetWithOrderStatus:@"4" size:[NSString stringWithFormat:@"%ld",_pageCount] page:[NSString stringWithFormat:@"%ld",_page] orderNum:@""];
            [self.allOrder_tableView reloadData];
            
            break;
        case OrderTypeWaitSend://待配送
            
            [self allOrderPostRequsetWithOrderStatus:@"0" size:[NSString stringWithFormat:@"%ld",_pageCount] page:[NSString stringWithFormat:@"%ld",_page]  orderNum:@""];
            [self.allOrder_tableView reloadData];
            
            break;
        case OrderTypeSending://配送中
            [self allOrderPostRequsetWithOrderStatus:@"1" size:[NSString stringWithFormat:@"%ld",_pageCount] page:[NSString stringWithFormat:@"%ld",_page]  orderNum:@""];
            [self.allOrder_tableView reloadData];
            
            break;
        case OrderTypeSended://已配送
            
            [self allOrderPostRequsetWithOrderStatus:@"2" size:[NSString stringWithFormat:@"%ld",_pageCount] page:[NSString stringWithFormat:@"%ld",_page]  orderNum:@""];
            [self.allOrder_tableView reloadData];
            
            break;
        case OrderTypeDealSuccess://交易成功
            
            [self allOrderPostRequsetWithOrderStatus:@"3" size:[NSString stringWithFormat:@"%ld",_pageCount] page:[NSString stringWithFormat:@"%ld",_page]  orderNum:@""];
            [self.allOrder_tableView reloadData];
            
            break;
        case OrderTypeCancelSuccess://取消交易
            
            [self allOrderPostRequsetWithOrderStatus:@"-1" size:[NSString stringWithFormat:@"%ld",_pageCount] page:[NSString stringWithFormat:@"%ld",_page]  orderNum:@""];
            [self.allOrder_tableView reloadData];
            
            break;
        case OrderTypeAfterSale://售后
            
            
            [self allOrderPostRequsetWithOrderStatus:@"2" size:[NSString stringWithFormat:@"%ld",_pageCount] page:[NSString stringWithFormat:@"%ld",_page]  orderNum:@""];
            [self.allOrder_tableView reloadData];
            
            break;
            
    }
    
    
}

#pragma mark - ZFSaleAfterTopViewDelegate   售后申请的2种状态
-(void)sendAtagNum:(NSInteger)tagNum
{
    self.tagNum = tagNum;
    
    if (tagNum == 0) {
        
        NSLog(@"申请售后,刷新列表tagnum                 = %ld",tagNum);
        [self.allOrder_tableView reloadData];
        
    }else{
        
        NSLog(@"进度查询,刷新列表tagnum                 = %ld",tagNum);
        [self salesAfterPostRequsteSize:[NSString stringWithFormat:@"%ld",_pageCount] page:[NSString stringWithFormat:@"%ld",_page] ];
        [self.allOrder_tableView reloadData];
        
        
    }
}

#pragma mark - ZFCheckTheProgressCellDelegate 查询进度
-(void)progressWithCheckout
{
    ZFPregressCheckViewController * checkVC = [[ZFPregressCheckViewController alloc]init];
    [self.navigationController pushViewController:checkVC animated:YES];
}


#pragma mark - ZFSaleAfterContentCellDelegate 申请售后
-(void)salesAfterDetailPage{
    
    NSLog(@"申请售后");
    
}

#pragma mark - 全部订单 网络请求 getOrderListBystatus
-(void)allOrderPostRequsetWithOrderStatus :(NSString *)orderStatus
                                     size :(NSString *)size
                                     page :(NSString *)page
                                 orderNum :(NSString *)orderNum
{
    NSDictionary * param = @{
                             
                             @"size":size,
                             @"page":page,
                             @"orderStatus":orderStatus,
                             @"cmUserId":BBUserDefault.cmUserId,
                             @"orderNum":orderNum,
                             
                             };
    
    [SVProgressHUD show];
    
    [MENetWorkManager post:[zfb_baseUrl stringByAppendingString:@"/order/getOrderListBystatus"] params:param success:^(id response) {
        
        if ([response[@"resultCode"] intValue] == 0) {
            if (self.orderListArray.count > 0 ) {
                
                [self.orderListArray removeAllObjects];
            }
            AllOrderModel * allorder = [AllOrderModel mj_objectWithKeyValues:response];
            
            for (Orderlist * list in allorder.orderList) {
                
                [self.orderListArray addObject:list];
                
            }
            [SVProgressHUD dismiss];
            
        }
        NSLog(@"orderListArray ====%@",self.orderListArray);
        [self.allOrder_tableView reloadData];
        
        [self.allOrder_tableView.mj_header endRefreshing];
        [self.allOrder_tableView.mj_footer endRefreshing];
        
    } progress:^(NSProgress *progeress) {
        
    } failure:^(NSError *error) {
        [SVProgressHUD dismiss];
        [self.allOrder_tableView.mj_header endRefreshing];
        [self.allOrder_tableView.mj_footer endRefreshing];
        NSLog(@"error=====%@",error);
        [self.view makeToast:@"网络错误" duration:2 position:@"center"];
    }];
    
}

#pragma mark - 申请售后 进度查询列表     zfb/InterfaceServlet/afterSale/afterSaleList
-(void)salesAfterPostRequsteSize :(NSString *)size
                            page :(NSString *)page
{
    NSDictionary * param = @{
                             
                             @"size":size,
                             @"page":page,
                             @"cmUserId":BBUserDefault.cmUserId,
                             
                             };
    
    [SVProgressHUD show];
    
    [MENetWorkManager post:[zfb_baseUrl stringByAppendingString:@"/afterSale/afterSaleList"] params:param success:^(id response) {
        
        if ([response[@"resultCode"] intValue] == 0) {
            
            [self.allOrder_tableView reloadData];
            [SVProgressHUD dismiss];
        }
        
    } progress:^(NSProgress *progeress) {
        
    } failure:^(NSError *error) {
        [SVProgressHUD dismiss];
        
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
        
        //        [self businessOrderListPostRequstpayStatus:@"" orderStatus:@"0" searchWord:@"" cmUserId:@"" startTime:@"" endTime:@"" payMode:@"1" page:[NSString stringWithFormat:@"%ld",_page] size:[NSString stringWithFormat:@"%ld",_pageCount] storeId:_storeId];
        
        
    } progress:^(NSProgress *progeress) {
        
        NSLog(@"progeress=====%@",progeress);
        
    } failure:^(NSError *error) {
        
        NSLog(@"error=====%@",error);
        [self.view makeToast:@"网络错误" duration:2 position:@"center"];
    }];
    
}

#pragma mark - 用户确认收货接口 order/userConfirmReceipt
-(void)receiveUserConfirmReceiptPost
{
    NSDictionary * param = @{
                             @"deliveryId":@"",
                             @"storeId":@"",
                             @"deliveryFee":@"",
                             @"orderNum":@"",
                             @"userId":@"",
                             @"orderAmount":@"",//订单金额
                             @"orderDetail":@"",//订单详情
                             @"storeName":@"",
                             
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

#pragma mark - ZFFooterCellDelegate footer代理
-(void)sendOrdersActionOrderId:(NSString *)orderId totalPrice:(NSString *)totalPrice indexPath:(NSInteger)indexPath
{
    ZFDetailOrderViewController * detailVc =[[ ZFDetailOrderViewController alloc]init];
    Orderlist * orderlist = self.orderListArray [_indexPath];
    NSLog(@"---------%ld",_indexPath);
    
    switch (_orderType) {
        case OrderTypeAllOrder://全部订单
            
            if ([orderlist.orderStatusName isEqualToString:@"已配送"]) {//button
                
                JXTAlertController * alertavc =[JXTAlertController alertControllerWithTitle:@"提示" message:@"亲,确认要收货吗" preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction * cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                    
                }];
                UIAlertAction * sureAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
                    //确认收货 - 成功后跳转交易完成 - 晒单
                    [self sendTitle:@"交易完成" orderType:OrderTypeDealSuccess];
                    
                }];
                [alertavc addAction:cancelAction];
                [alertavc addAction:sureAction];
                
                [self presentViewController:alertavc animated:YES completion:nil];
                
            }
            else if ([orderlist.orderStatusName isEqualToString:@"待付款"]) {
                //马上去付款页面
                detailVc.cmOrderid = orderlist.order_id;
                
                [self.navigationController pushViewController:detailVc animated:YES];
            }
            
            else if ([orderlist.orderStatusName isEqualToString:@"已配送"]) {
                
            }
            else if ([orderlist.orderStatusName isEqualToString:@"交易完成"]) {
                
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
                [self receiveUserConfirmReceiptPost];
            }];
            [alertavc addAction:cancelAction];
            [alertavc addAction:sureAction];
            
            [self presentViewController:alertavc animated:YES completion:nil];
            
        }
            break;
        case OrderTypeDealSuccess://交易成功后去晒单
        {
            NSLog(@"晒单啦");
            
        }
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
            NSLog(@"---------%ld",_indexPath);
            
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
            Orderlist * orderlist = self.orderListArray [_indexPath];
            
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

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
    
    [self.bgview removeFromSuperview];
    
    
}
-(void)viewWillDisappear:(BOOL)animated{
    
    [SVProgressHUD dismiss];
    
}
//判断是不是空数组
- (BOOL)isEmptyArray:(NSArray *)array
{
    return (array.count ==0 || array == nil);
}

//重写返回方法
-(void)backAction{
    
    [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:0] animated:YES];
    for(UIViewController * controller in self.navigationController.viewControllers) {
        
        if([controller isKindOfClass:[ZFPersonalViewController class]]) {
            
            [self.navigationController popToViewController:controller animated:YES];
            
        }
        
    }
    
    
}

@end
