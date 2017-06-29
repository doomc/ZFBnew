


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

#pragma mark - 网络请求必传的参数
@property (nonatomic ,copy) NSString * payStatus     ;//支付状态
@property (nonatomic ,copy) NSString * orderStatus ;//订单状态

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

@property (nonatomic ,strong) NSMutableArray * orderListArray;//全部订单数组
@property (nonatomic ,strong) NSMutableArray * orderGoodsArray;//全部订单数组

@end

@implementation ZFAllOrderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    
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
    
    
    _payStatus   = @"";
    _orderStatus = @"";
    
    //  [self allOrderPostRequset];
    
    
}
#pragma mark -   视图售后初始化
-(ZFSaleAfterTopView *)topView{
    if (!_topView) {
        _topView  =[[ ZFSaleAfterTopView alloc]initWithFrame:CGRectMake(0, 64, KScreenW, 40) titleArr:self.saleTitles];
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

#pragma mark - tableView delegare
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    NSInteger num = 2;
    switch (_orderType) {
        case OrderTypeAllOrder:
            
            break;
        case OrderTypeWaitPay:
            
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
            
            break;
    }
    return num;
    
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger sectionNum = 4;
    
    if (_orderType == OrderTypeAfterSale) {
        
        if (self.tagNum == 0) {
            
            if (section == 0) {
                
                sectionNum = 3;
                
            }else{
                sectionNum = 3;
            }
            
        }else if (self.tagNum ==1)
        {
            if (section==0) {
                
                sectionNum = 1;
            }
        }
    }
    
    return sectionNum;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    CGFloat height = 62;
    
    if (_orderType == OrderTypeAfterSale) {
        
        if (section == 0) {
            
            height = 40;
            
        }else{
            height = 10;
        }
    }
    
    return height;
    
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView * view = nil;
    
    ZFTitleCell * titleCell = [self.allOrder_tableView
                               dequeueReusableCellWithIdentifier:@"ZFTitleCellid"];
    view = titleCell ;
    
    if (_orderType == OrderTypeAllOrder) {
        
    }
    
    if (_orderType == OrderTypeAfterSale) {
        if (section == 0) {
            
            view = self.topView;
        }else{
            
            return  view;
        }
    }
    
    return view;
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (_orderType == OrderTypeAfterSale) {
        
        return 0.0001;
    }
    
    return 40;
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView * view = nil;
    
    ZFFooterCell * cell = [self.allOrder_tableView dequeueReusableCellWithIdentifier:footerCellid];
    view                = cell;
    
    return view;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat height = 0;
    
    if (_orderType == OrderTypeAllOrder) {
        
        height = [tableView fd_heightForCellWithIdentifier:contentCellid configuration:^(id cell) {
            
        }];
        
    }
    else  if (_orderType == OrderTypeWaitPay) {
        
        height = [tableView fd_heightForCellWithIdentifier:contentCellid configuration:^(id cell) {
            
        }];
        
    }
    
    else  if (_orderType == OrderTypeWaitSend) {
        
        height = [tableView fd_heightForCellWithIdentifier:contentCellid configuration:^(id cell) {
            
        }];
        
    }
    
    else  if (_orderType == OrderTypeSending) {
        
        height = [tableView fd_heightForCellWithIdentifier:contentCellid configuration:^(id cell) {
            
        }];
        
    }
    else  if (_orderType == OrderTypeSended) {
        
        height = [tableView fd_heightForCellWithIdentifier:contentCellid configuration:^(id cell) {
            
        }];
        
    }
    else  if (_orderType == OrderTypeDealSuccess) {
        
        height = [tableView fd_heightForCellWithIdentifier:contentCellid configuration:^(id cell) {
            
        }];
        
    }
    else  if (_orderType == OrderTypeCancelSuccess) {
        
        height = [tableView fd_heightForCellWithIdentifier:contentCellid configuration:^(id cell) {
            
        }];
        
    }
    else  if (_orderType == OrderTypeAfterSale) {
        
        if (self.tagNum == 0) {
            
            if (indexPath.section == 0) {
                if (indexPath.row == 0) {
                    
                    height = [tableView fd_heightForCellWithIdentifier:saleAfterSearchCellid configuration:^(id cell) {
                        
                    }];
                    
                }else if (indexPath.row ==1)
                {
                    height = [tableView fd_heightForCellWithIdentifier:saleAfterHeadCellid configuration:^(id cell) {
                        
                    }];
                }else{
                    
                    height = [tableView fd_heightForCellWithIdentifier:saleAfterContentCellid configuration:^(id cell) {
                        
                    }];
                    
                }
                
            }
            if (indexPath.section == 1) {
                if (indexPath.row == 0) {
                    height = [tableView fd_heightForCellWithIdentifier:saleAfterHeadCellid configuration:^(id cell) {
                        
                    }];
                }else{
                    height = [tableView fd_heightForCellWithIdentifier:saleAfterContentCellid configuration:^(id cell) {
                        
                    }];
                }
            }
            
        }else{
            height = [tableView fd_heightForCellWithIdentifier:saleAfterProgressCellid configuration:^(id cell) {
                
            }];
        }
        
    }
    
    
    return height;
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell * cell ;
    
    ZFSendingCell * sendCell = [self.allOrder_tableView dequeueReusableCellWithIdentifier:contentCellid forIndexPath:indexPath];
    cell                     = sendCell;
    
    if (_orderType == OrderTypeAfterSale)
    {
        if (self.tagNum == 0) {
            if (indexPath.section == 0){
                if (indexPath.row ==0) {
                    
                    ZFSaleAfterSearchCell* searchCell = [self.allOrder_tableView dequeueReusableCellWithIdentifier:saleAfterSearchCellid forIndexPath:indexPath];
                    
                    cell = searchCell;
                }else if (indexPath.row ==1 )
                {
                    ZFSaleAfterHeadCell* HeadCell = [self.allOrder_tableView dequeueReusableCellWithIdentifier:saleAfterHeadCellid forIndexPath:indexPath];
                    cell                          = HeadCell;
                    
                }else{
                    ZFSaleAfterContentCell* contentell = [self.allOrder_tableView dequeueReusableCellWithIdentifier:saleAfterContentCellid forIndexPath:indexPath];
                    
                    cell = contentell;
                }
                
            }
            if (indexPath.section == 1) {
                if (indexPath.row ==0) {
                    
                    ZFSaleAfterHeadCell* HeadCell = [self.allOrder_tableView dequeueReusableCellWithIdentifier:saleAfterHeadCellid forIndexPath:indexPath];
                    
                    cell = HeadCell;
                }else{
                    
                    ZFSaleAfterContentCell* contentell = [self.allOrder_tableView dequeueReusableCellWithIdentifier:saleAfterContentCellid forIndexPath:indexPath];
                    contentell.delegate                = self;
                    cell                               = contentell;
                }
                
            }
            
        }else{
            ZFCheckTheProgressCell *checkCell = [self.allOrder_tableView dequeueReusableCellWithIdentifier:saleAfterProgressCellid forIndexPath:indexPath];
            checkCell.deldegate               = self;
            cell                              = checkCell;
            
        }
    }
    
    
    return cell;
    
    
    
}
#pragma mark - tableView datasource
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@" section = %ld ， row = %ld",indexPath.section,indexPath.row);
    
    ZFDetailOrderViewController * detailVc =[[ ZFDetailOrderViewController alloc]init];
    [self.navigationController pushViewController:detailVc animated:YES];
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
    
    /// 赋值payStatus ,orderStatus
    if (_orderType == OrderTypeAllOrder ) {///全部订单
        
        _payStatus   = @"";
        _orderStatus = @"";
        [self allOrderPostRequset];
        
    }
    else if (_orderType == OrderTypeWaitPay ) {///待付款
        
        _payStatus   = @"0";
        _orderStatus = @"";
        [self allOrderPostRequset];
        
    }
    else if (_orderType == OrderTypeWaitSend ) {///待配送
        
        _payStatus   = @"1";
        _orderStatus = @"0";
        [self allOrderPostRequset];
        
    }
    else if (_orderType == OrderTypeSending ) {///配送中
        _payStatus   = @"1";
        _orderStatus = @"1";
        [self allOrderPostRequset];
        
    }
    else if (_orderType == OrderTypeSended ) {///已配送
        
        _payStatus   = @"1";
        _orderStatus = @"2";
        [self allOrderPostRequset];
        
    }
    else if (_orderType == OrderTypeDealSuccess ) {///取消交易
        
        _payStatus   = @"5";
        _orderStatus = @"2";
        [self allOrderPostRequset];
        
    }
    else if (_orderType == OrderTypeCancelSuccess ) {
        
        _payStatus   = @"1";
        _orderStatus = @"3";
        [self allOrderPostRequset];
        
    }
    else if (_orderType == OrderTypeAfterSale ) {
        
        _payStatus   = @"1";
        _orderStatus = @"3";
        [self allOrderPostRequset];
        
    }
    
    
    [self.allOrder_tableView reloadData];
    
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
-(void)allOrderPostRequset
{
    NSDictionary * param = @{
                             @"cmUserId":BBUserDefault.cmUserId,
                             @"svcName":@"getOrderListBystatus",
                             @"size":@"1",
                             @"page":@"1",
                             @"payStatus":_payStatus,
                             @"orderStatus":_orderStatus,
                             };
    
    NSDictionary *parmaDic=[NSDictionary dictionaryWithDictionary:param];
    
    MJWeakSelf;
    [PPNetworkHelper POST:ZFB_11SendMessageUrl parameters:parmaDic responseCache:^(id responseCache) {
        
    } success:^(id responseObject) {
        
        if ([responseObject[@"resultCode"] isEqualToString:@"0"]) {
            
            if (![self isEmptyArray:weakSelf.orderGoodsArray]) {
                
                [weakSelf.orderGoodsArray  removeAllObjects];
                
            }else{
                
                NSString  * dataStr    = [responseObject[@"data"] base64DecodedString];
                NSDictionary * jsondic = [NSString dictionaryWithJsonString:dataStr];
                
                AllOrderModel * allOrder = [AllOrderModel mj_objectWithKeyValues:jsondic];
                NSInteger allcount       = allOrder.totalCount  ;//总个数
                
                for (Orderlist * orderList in allOrder.orderList) {
                    
                    for (Ordergoods * goodslist in orderList.orderGoods) {
                        
                        [weakSelf.orderGoodsArray addObject:goodslist];
                    }
                    [weakSelf.orderListArray addObject:orderList];
                }
                NSLog(@"orderGoodsArray---------------=%@",weakSelf.orderGoodsArray);
                NSLog(@"orderListArray ===========%@",weakSelf.orderListArray);
                
            }
        }
        
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
        [self.view makeToast:@"网络错误" duration:2 position:@"center"];
    }];
    
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

//判断是不是空数组
- (BOOL)isEmptyArray:(NSArray *)array
{
    return (array.count ==0 || array == nil);
}


@end
