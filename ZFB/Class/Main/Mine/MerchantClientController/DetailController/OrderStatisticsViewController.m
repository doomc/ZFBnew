//
//  OrderStatisticsViewController.m
//  ZFB
//
//  Created by  展富宝  on 2017/7/27.
//  Copyright © 2017年 com.zfb. All rights reserved.
//  订单统计

#import "OrderStatisticsViewController.h"
//cell
#import "ZFSendingCell.h"//内容
#import "ZFTitleCell.h"//头
#import "ZFFooterCell.h"//尾部
//model
#import "BusinessOrderModel.h"
@interface OrderStatisticsViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic ,strong) UITableView * orderdTableView ;
@property (nonatomic ,strong) UIView *  headView ;
@property (nonatomic ,strong) NSMutableArray *  orderListArray ;


@end

@implementation OrderStatisticsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"订单统计";
    
    
    [self.view addSubview:self.orderdTableView];
    
    [self.orderdTableView registerNib:[UINib nibWithNibName:@"ZFSendingCell" bundle:nil]
                  forCellReuseIdentifier:@"ZFSendingCell"];
    [self.orderdTableView registerNib:[UINib nibWithNibName:@"ZFTitleCell" bundle:nil]
                  forCellReuseIdentifier:@"ZFTitleCell"];
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
    dealPrice.text = [NSString stringWithFormat:@"交易金额:%@元",_dealPrice];

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
 
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    BusinessOrderlist * list = self.orderListArray[section];
    NSMutableArray  * goodsArr = [NSMutableArray array];
   
    for (BusinessOrdergoods  * goods in list.orderGoods) {
        [goodsArr addObject:goods];
    }
    
    return goodsArr.count;
 
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 82;
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
    ZFTitleCell * titleCell = [self.orderdTableView
                               dequeueReusableCellWithIdentifier:@"ZFTitleCell"];
    [titleCell.statusButton setTitle:@"交易完成" forState:UIControlStateNormal];
    BusinessOrderlist * orderlist  = self.orderListArray[section];
    titleCell.businessOrder = orderlist;
    return titleCell;
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    ZFFooterCell * cell = [self.orderdTableView
                           dequeueReusableCellWithIdentifier:@"ZFFooterCell"];
    BusinessOrderlist * orderlist  = self.orderListArray[section];
    cell.businessOrder = orderlist;
    
    [cell.cancel_button removeFromSuperview];
    [cell.payfor_button removeFromSuperview];
    return cell;
    
}

#pragma mark - UITableViewDataSource
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    ZFSendingCell * cell = [self.orderdTableView dequeueReusableCellWithIdentifier:@"ZFSendingCell" forIndexPath:indexPath];
    BusinessOrderlist * list = self.orderListArray[indexPath.section];
    NSMutableArray  * goodsArr = [NSMutableArray array];
    
    for (BusinessOrdergoods  * goods in list.orderGoods) {
        [goodsArr addObject:goods];
    }
    BusinessOrdergoods * goodslist = goodsArr[indexPath.row];
    
    cell.businesGoods = goodslist;
    
    return cell;
}


#pragma mark -  获取统计列表    order/storeHomePage
-(void)storeHomePagePostRequst
{

    NSDictionary * param = @{
                             @"storeId": _storeId ,

                             };
    
    [MENetWorkManager post:[NSString stringWithFormat:@"%@/order/storeHomePage",zfb_baseUrl] params:param success:^(id response) {
       
        BusinessOrderModel * orderModel = [BusinessOrderModel mj_objectWithKeyValues:response];
        
        for (BusinessOrderlist * orderlist in orderModel.orderList) {
            
            [self.orderListArray addObject:orderlist];
            
        }
        [self.orderdTableView reloadData];
        
    } progress:^(NSProgress *progeress) {
        
        NSLog(@"progeress=====%@",progeress);
        
    } failure:^(NSError *error) {
        
        NSLog(@"error=====%@",error);
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
