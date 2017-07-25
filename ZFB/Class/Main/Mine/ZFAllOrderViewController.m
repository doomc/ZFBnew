


//
//  ZFAllOrderViewController.m
//  ZFB
//
//  Created by  展富宝  on 2017/5/25.
//  Copyright © 2017年 com.zfb. All rights reserved.
//  全部订单

#import "ZFAllOrderViewController.h"

#import "ZFSendingCell.h"
#import "ZFFooterCell.h"
#import "ZFTitleCell.h"

#import "ZFpopView.h"
#import "ZFSaleAfterTopView.h"
#import "ZFSaleAfterHeadCell.h"
#import "ZFSaleAfterContentCell.h"
#import "ZFSaleAfterSearchCell.h"
#import "ZFCheckTheProgressCell.h"
#import "ZFPregressCheckViewController.h"
#import "ZFDetailOrderViewController.h"
#import "ZFMainPayforViewController.h"

#import "AllOrderModel.h"

static  NSString * headerCellid =@"ZFTitleCellid";//头id
static  NSString * contentCellid =@"ZFSendingCellid";//内容id
static  NSString * footerCellid =@"ZFFooterCellid";//尾部id

static  NSString * saleAfterHeadCellid =@"ZFSaleAfterHeadCellid";//头id
static  NSString * saleAfterContentCellid =@"saleAfterContentCellid";//内容id
static  NSString * saleAfterSearchCellid =@"ZFSaleAfterSearchCellid";//搜索cell
static  NSString * saleAfterProgressCellid =@"ZFCheckTheProgressCellid";//进度查询



@interface ZFAllOrderViewController ()<UITableViewDelegate,UITableViewDataSource,ZFpopViewDelegate,ZFSaleAfterTopViewDelegate,ZFCheckTheProgressCellDelegate,ZFSaleAfterContentCellDelegate>


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
@property (nonatomic ,strong) NSMutableArray * orderGoodsArray;//全部订单尾部数组

///售后申请-数据源
//@property (nonatomic ,strong) NSMutableArray * orderListArray;//全部订单数组
//@property (nonatomic ,strong) NSMutableArray * orderGoodsArray;//全部订单数组

@end

@implementation ZFAllOrderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.tagNum = 0;//默认为售后申请
    
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
    
    [self allOrderPostRequsetWithOrderStatus:@""];
    
    
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

-(NSMutableArray *)orderGoodsArray
{
    if (!_orderGoodsArray) {
        _orderGoodsArray = [NSMutableArray array];
    }
    return _orderGoodsArray;
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
            sectionNum = 2;
            break;
        case OrderTypeWaitSend:
            sectionNum = 2;
            break;
        case OrderTypeSending:
            sectionNum = 2;
            break;
        case OrderTypeSended:
            sectionNum = self.orderListArray.count;
            break;
        case OrderTypeDealSuccess:
            sectionNum = 2;
            break;
        case OrderTypeCancelSuccess:
            sectionNum = 2;
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
    switch (_orderType) {
            
        case OrderTypeAllOrder:
            
            if (self.orderGoodsArray.count > 0) {
                
                rowNum = self.orderGoodsArray.count;
                
            }
            break;
        case OrderTypeWaitPay:
            rowNum = 2;
            break;
        case OrderTypeWaitSend:
            rowNum = 2;
            break;
        case OrderTypeSending:
            rowNum = 2;
            break;
        case OrderTypeSended:
            rowNum = self.orderListArray.count;
            break;
        case OrderTypeDealSuccess:
            rowNum = 2;
            break;
        case OrderTypeCancelSuccess:
            rowNum = 2;
            break;
        case OrderTypeAfterSale:
            
            if (self.tagNum == 0) {
                
                if (section == 0) {
                    
                    rowNum = 1;
                    
                }
                
                rowNum = self.orderGoodsArray.count;
                
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
            
            break;
        case OrderTypeWaitSend:
            
            break;
        case OrderTypeSending:
            
            break;
        case OrderTypeSended:
            height = 82;

            break;
        case OrderTypeDealSuccess:
            
            break;
        case OrderTypeCancelSuccess:
            
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
                
                Orderlist  * sectionList   = self.orderListArray[section];
                titleCell.orderlist = sectionList;
            }
            return titleCell;
            
            break;
            
        }
        case OrderTypeWaitPay:
        {
            ZFTitleCell * titleCell = [self.allOrder_tableView
                                       dequeueReusableCellWithIdentifier:@"ZFTitleCellid"];
            if (self.orderListArray.count > 0) {
                
                Orderlist  * sectionList   = self.orderListArray[section];
                titleCell.orderlist = sectionList;
            }
            return titleCell;
        }
            break;
        case OrderTypeWaitSend:
        {
            ZFTitleCell * titleCell = [self.allOrder_tableView
                                       dequeueReusableCellWithIdentifier:@"ZFTitleCellid"];
            if (self.orderListArray.count > 0) {
                
                Orderlist  * sectionList   = self.orderListArray[section];
                titleCell.orderlist = sectionList;
            }
            return titleCell;
        }
            
            break;
        case OrderTypeSending:{
            ZFTitleCell * titleCell = [self.allOrder_tableView
                                       dequeueReusableCellWithIdentifier:@"ZFTitleCellid"];
            if (self.orderListArray.count > 0) {
                
                Orderlist  * sectionList   = self.orderListArray[section];
                titleCell.orderlist = sectionList;
            }
            return titleCell;
        }
            
            break;
        case OrderTypeSended:
        {
            ZFTitleCell * titleCell = [self.allOrder_tableView
                                       dequeueReusableCellWithIdentifier:@"ZFTitleCellid"];
            if (self.orderListArray.count > 0) {
                
                Orderlist  * sectionList   = self.orderListArray[section];
                titleCell.orderlist = sectionList;
            }
            return titleCell;
        }
            
            break;
        case OrderTypeDealSuccess:
        {
            ZFTitleCell * titleCell = [self.allOrder_tableView
                                       dequeueReusableCellWithIdentifier:@"ZFTitleCellid"];
            if (self.orderListArray.count > 0) {
                
                Orderlist  * sectionList   = self.orderListArray[section];
                titleCell.orderlist = sectionList;
            }
            return titleCell;
        }
            
            break;
        case OrderTypeCancelSuccess:
        {
            ZFTitleCell * titleCell = [self.allOrder_tableView
                                       dequeueReusableCellWithIdentifier:@"ZFTitleCellid"];
            if (self.orderListArray.count > 0) {
                
                Orderlist  * sectionList   = self.orderListArray[section];
                titleCell.orderlist = sectionList;
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
                        
                        Orderlist  * sectionList   = self.orderListArray[section- 1];
                        HeadCell.orderlist = sectionList;
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
        case OrderTypeAllOrder:
        {
            ZFFooterCell * cell = [self.allOrder_tableView
                                   dequeueReusableCellWithIdentifier:footerCellid];
            if (self.orderListArray.count > 0) {
                
                Orderlist  * footList   = self.orderListArray[section];
                cell.orderlist = footList;
                
            }
            return cell;
            
            break;
            
        }
        case OrderTypeWaitPay:{
            ZFFooterCell * cell = [self.allOrder_tableView
                                   dequeueReusableCellWithIdentifier:footerCellid];
            if (self.orderListArray.count > 0) {
                
                Orderlist  * footList   = self.orderListArray[section];
                cell.orderlist = footList;
                
            }
            return cell;
        }
            
            break;
        case OrderTypeWaitSend:{
            ZFFooterCell * cell = [self.allOrder_tableView
                                   dequeueReusableCellWithIdentifier:footerCellid];
            if (self.orderListArray.count > 0) {
                
                Orderlist  * footList   = self.orderListArray[section];
                cell.orderlist = footList;
                
            }
            return cell;
        }
            
            break;
        case OrderTypeSending:
        {
            ZFFooterCell * cell = [self.allOrder_tableView
                                   dequeueReusableCellWithIdentifier:footerCellid];
            if (self.orderListArray.count > 0) {
                
                Orderlist  * footList   = self.orderListArray[section];
                cell.orderlist = footList;
                
            }
            return cell;
        }
            break;
        case OrderTypeSended:
        {
            ZFFooterCell * cell = [self.allOrder_tableView
                                   dequeueReusableCellWithIdentifier:footerCellid];
            if (self.orderListArray.count > 0) {
                
                Orderlist  * footList   = self.orderListArray[section];
                cell.orderlist = footList;
                
            }
            return cell;
        }
            
            break;
        case OrderTypeDealSuccess:{
            ZFFooterCell * cell = [self.allOrder_tableView
                                   dequeueReusableCellWithIdentifier:footerCellid];
            if (self.orderListArray.count > 0) {
                
                Orderlist  * footList   = self.orderListArray[section];
                cell.orderlist = footList;
                
            }
            return cell;
        }
            
            break;
        case OrderTypeCancelSuccess:
        {
            ZFFooterCell * cell = [self.allOrder_tableView
                                   dequeueReusableCellWithIdentifier:footerCellid];
            if (self.orderListArray.count > 0) {
                
                Orderlist  * footList   = self.orderListArray[section];
                cell.orderlist = footList;
                
            }
            return cell;
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
            if (self.orderGoodsArray.count > 0 ) {
                
                Orderlist * list  = self.orderListArray[indexPath.section];
                sendCell.list = list;

                Ordergoods * goods = self.orderGoodsArray[indexPath.row];
                sendCell.goods = goods;
                
            }
            return sendCell;
        }
            break;
            
        case OrderTypeWaitPay:
        {
            ZFSendingCell * sendCell = [self.allOrder_tableView
                                        dequeueReusableCellWithIdentifier:contentCellid forIndexPath:indexPath];
            sendCell.selectionStyle = UITableViewCellSelectionStyleNone;
            if (self.orderGoodsArray.count > 0 ) {
                
                Orderlist * list  = self.orderListArray[indexPath.section];
                sendCell.list = list;
                
                Ordergoods * goods = self.orderGoodsArray[indexPath.row];
                sendCell.goods = goods;
                
            }
            return sendCell;
            break;
            
        }
        case OrderTypeWaitSend:
            
        {
            ZFSendingCell * sendCell = [self.allOrder_tableView
                                        dequeueReusableCellWithIdentifier:contentCellid forIndexPath:indexPath];
            sendCell.selectionStyle = UITableViewCellSelectionStyleNone;
            if (self.orderGoodsArray.count > 0 ) {
                
                Orderlist * list  = self.orderListArray[indexPath.section];
                sendCell.list = list;
                
                Ordergoods * goods = self.orderGoodsArray[indexPath.row];
                sendCell.goods = goods;
                
            }
            return sendCell;
            break;
            
        }
        case OrderTypeSending:
            
        {
            ZFSendingCell * sendCell = [self.allOrder_tableView
                                        dequeueReusableCellWithIdentifier:contentCellid forIndexPath:indexPath];
            sendCell.selectionStyle = UITableViewCellSelectionStyleNone;
            if (self.orderGoodsArray.count > 0 ) {
                
                Orderlist * list  = self.orderListArray[indexPath.section];
                sendCell.list = list;
                
                Ordergoods * goods = self.orderGoodsArray[indexPath.row];
                sendCell.goods = goods;
                
            }
            return sendCell;
            break;
            
        }
        case OrderTypeSended:
            
        {
            ZFSendingCell * sendCell = [self.allOrder_tableView
                                        dequeueReusableCellWithIdentifier:contentCellid forIndexPath:indexPath];
            sendCell.selectionStyle = UITableViewCellSelectionStyleNone;
            if (self.orderGoodsArray.count > 0 ) {
                
                Orderlist * list  = self.orderListArray[indexPath.section];
                sendCell.list = list;
                
                Ordergoods * goods = self.orderGoodsArray[indexPath.row];
                sendCell.goods = goods;
                
            }
            return sendCell;
            break;
            
        }
        case OrderTypeDealSuccess:
            
        {      ZFSendingCell * sendCell = [self.allOrder_tableView
                                           dequeueReusableCellWithIdentifier:contentCellid forIndexPath:indexPath];
            sendCell.selectionStyle = UITableViewCellSelectionStyleNone;
            if (self.orderGoodsArray.count > 0 ) {
                
                Orderlist * list  = self.orderListArray[indexPath.section];
                sendCell.list = list;
                
                Ordergoods * goods = self.orderGoodsArray[indexPath.row];
                sendCell.goods = goods;
                
            }
            return sendCell;
            
            break;
            
        }
        case OrderTypeCancelSuccess:
            
        {
            ZFSendingCell * sendCell = [self.allOrder_tableView
                                        dequeueReusableCellWithIdentifier:contentCellid forIndexPath:indexPath];
            sendCell.selectionStyle = UITableViewCellSelectionStyleNone;
            if (self.orderGoodsArray.count > 0 ) {
                
                Orderlist * list  = self.orderListArray[indexPath.section];
                sendCell.list = list;
                
                Ordergoods * goods = self.orderGoodsArray[indexPath.row];
                sendCell.goods = goods;
                
            }
            return sendCell;
            break;
            
        }
        case OrderTypeAfterSale:
        {
            if (self.tagNum == 0) {
                
                if (indexPath.section == 0){
                    
                    ZFSaleAfterSearchCell* searchCell = [self.allOrder_tableView dequeueReusableCellWithIdentifier:saleAfterSearchCellid forIndexPath:indexPath];
                    searchCell.selectionStyle = UITableViewCellSelectionStyleNone;
                    return  searchCell;
                    
                }
                
                ZFSaleAfterContentCell* contentell = [self.allOrder_tableView dequeueReusableCellWithIdentifier:saleAfterContentCellid forIndexPath:indexPath];
                contentell.selectionStyle = UITableViewCellSelectionStyleNone;
                contentell.delegate = self;
                
                Ordergoods * goods = self.orderGoodsArray[indexPath.row];
                contentell.goods = goods;
                
                
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
    Ordergoods * goodlist = _orderGoodsArray [indexPath.row];
    ZFDetailOrderViewController * detailVc =[[ ZFDetailOrderViewController alloc]init];
    if (goodlist.order_id != nil) {
        
        detailVc.cmOrderid = goodlist.order_id;

    }
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
    
    
    ///payStatus	null	   1	  1	      1	      0	       5	   1	  1
    ///orderStatus	null	   0	  1	      2	     null	   2	   3	  3
    ///            所有订单	待配送	配送中	已配送   待付款  交易取消   交易完成	 售后申请
    
    //0待配送 1配送中 2配送完成,3.交易完成，4.待付款，6,待上门取件，-1.关闭
    switch (_orderType) {
        case OrderTypeAllOrder:///全部订单
            
  
            [self allOrderPostRequsetWithOrderStatus:@""];
            [self.allOrder_tableView reloadData];
            break;
            
        case OrderTypeWaitPay:///待付款
      
            [self allOrderPostRequsetWithOrderStatus:@"4"];
            [self.allOrder_tableView reloadData];
            
            break;
        case OrderTypeWaitSend:///待配送
    
            [self allOrderPostRequsetWithOrderStatus:@"0"];
            [self.allOrder_tableView reloadData];
            
            break;
        case OrderTypeSending:///配送中
            
     
            [self allOrderPostRequsetWithOrderStatus:@"1"];
            [self.allOrder_tableView reloadData];
            break;
        case OrderTypeSended:///已配送
            
      
            [self allOrderPostRequsetWithOrderStatus:@"2"];
            [self.allOrder_tableView reloadData];
            break;
        case OrderTypeDealSuccess:///交易成功
      
            [self allOrderPostRequsetWithOrderStatus:@"3"];
            [self.allOrder_tableView reloadData];
            break;
        case OrderTypeCancelSuccess:///交易取消
 
            [self allOrderPostRequsetWithOrderStatus:@"-1"];
            [self.allOrder_tableView reloadData];
            break;
        case OrderTypeAfterSale:///售后申请
  
            [self allOrderPostRequsetWithOrderStatus:@"3"];
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
    
    
    
}


#pragma mark - 全部订单 网络请求 getOrderListBystatus
-(void)allOrderPostRequsetWithOrderStatus :(NSString *)orderStatus
{
 
    
    NSDictionary * param = @{
                             
                             @"size":@"2",
                             @"page":@"1",
                             @"orderStatus":orderStatus,
//                             @"searchWord":@"",
                             @"cmUserId":BBUserDefault.cmUserId,
                             
                             };
    
    MJWeakSelf;
    
    [MENetWorkManager post:[zfb_baseUrl stringByAppendingString:@"/order/getOrderListBystatus"] params:param success:^(id response) {
        
        if ([response[@"resultCode"] intValue] == 0) {
            if (weakSelf.orderListArray.count > 0 ) {
                
                [weakSelf.orderListArray removeAllObjects];

            }
            if (weakSelf.orderGoodsArray.count >0 ) {
                
                [weakSelf.orderGoodsArray removeAllObjects];

            }

            AllOrderModel * allorder  = [AllOrderModel mj_objectWithKeyValues:response];
            
            for (Orderlist * list in allorder.orderList) {
                
                [weakSelf.orderListArray addObject:list];
                
                for (Ordergoods * goodlist in list.orderGoods) {
                    
                    [weakSelf.orderGoodsArray addObject:goodlist];
                }
            }
            
            NSLog(@"orderListArray ====%@",weakSelf.orderListArray);
            NSLog(@"orderGoodsArray ====%@",weakSelf.orderGoodsArray);
            
            [weakSelf.allOrder_tableView reloadData];
            
        }
        
    } progress:^(NSProgress *progeress) {
        
    } failure:^(NSError *error) {
        
        NSLog(@"error=====%@",error);
        [self.view makeToast:@"网络错误" duration:2 position:@"center"];
    }];

    
}

//判断是不是空数组
- (BOOL)isEmptyArray:(NSArray *)array
{
    return (array.count ==0 || array == nil);
}


@end
