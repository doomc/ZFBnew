//
//  ZFSureOrderViewController.m
//  ZFB
//
//  Created by  展富宝  on 2017/5/24.
//  Copyright © 2017年 com.zfb. All rights reserved.
//

#import "ZFSureOrderViewController.h"
#import "ZFOrderListCell.h"
#import "OrderWithAddressCell.h"
#import "OrderPriceCell.h"
#import "ZFAddressListViewController.h"
#import "ZFShopListViewController.h"
#import "AddressCommitOrderModel.h"

@interface ZFSureOrderViewController ()<UITableViewDelegate ,UITableViewDataSource>
{
    NSString * _contactUserName;
    NSString * _postAddress;
    NSString * _contactMobilePhone;
    NSString * _goodsCountMoney;//商品总价
    NSString * _deliveryFee;//配送费
    NSString * _goodsAllMoney;//支付总金额
    
}
@property (nonatomic,strong) UITableView * mytableView;
@property (nonatomic,strong) UIView * footerView;

@end

@implementation ZFSureOrderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"确认订单";
    self.mytableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, KScreenW, KScreenH -49-64) style:UITableViewStylePlain];
    self.mytableView.delegate = self;
    self.mytableView.dataSource =self;
    self.mytableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.mytableView];
    
    [self.mytableView registerNib:[UINib nibWithNibName:@"ZFOrderListCell" bundle:nil] forCellReuseIdentifier:@"ZFOrderListCellid"];
    [self.mytableView registerNib:[UINib nibWithNibName:@"OrderWithAddressCell" bundle:nil] forCellReuseIdentifier:@"OrderWithAddressCellid"];
    [self.mytableView registerNib:[UINib nibWithNibName:@"OrderPriceCell" bundle:nil] forCellReuseIdentifier:@"OrderPriceCellid"];
    
    [self commitOrderPostRequst];
    
    [self creatCustomfooterView];
    
}

-(void)creatCustomfooterView
{
    
    NSString *buttonTitle = @"提交订单";
    NSString *price = _goodsAllMoney;
    NSString *caseOrder =  @"实付金额";
    
    UIFont * font  =[UIFont systemFontOfSize:15];
    _footerView = [[UIView alloc]initWithFrame:CGRectMake(0,KScreenH -49, KScreenW, 49)];
    _footerView.backgroundColor =[UIColor clearColor];
    
    //结算按钮
    UIButton * complete_Btn  = [UIButton buttonWithType:UIButtonTypeCustom];
    [complete_Btn setTitle:buttonTitle forState:UIControlStateNormal];
    complete_Btn.titleLabel.font =font;
    complete_Btn.backgroundColor =HEXCOLOR(0xfe6d6a);
    
    complete_Btn.frame =CGRectMake(KScreenW - 120 , 1, 120 , 48);
    [complete_Btn addTarget:self action:@selector(didCleckClearing:) forControlEvents:UIControlEventTouchUpInside];
    
    
    //价格
    UILabel * lb_price = [[UILabel alloc]init];
    lb_price.text = price;
    lb_price.textAlignment = NSTextAlignmentLeft;
    lb_price.font = font;
    lb_price.textColor = HEXCOLOR(0xfe6d6a);
    CGSize lb_priceSize = [price sizeWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:font,NSFontAttributeName, nil]];
    CGFloat lb_priceW = lb_priceSize.width;
    lb_price.frame = CGRectMake(KScreenW - 120 -20 - lb_priceW, 1, lb_priceW, 48);
    
    //固定金额位置
    UILabel * lb_order = [[UILabel alloc]init];
    lb_order.text= caseOrder;
    lb_order.font = font;
    lb_order.textColor = HEXCOLOR(0x363636);
    CGSize lb_orderSiez = [caseOrder sizeWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:font,NSFontAttributeName, nil]];
    CGFloat lb_orderW = lb_orderSiez.width;
    lb_order.frame =  CGRectMake(KScreenW - 120-lb_priceW -20-10-lb_orderW, 1, lb_orderW, 48);
    
    UILabel * line =[[ UILabel alloc]initWithFrame:CGRectMake(0, 0, KScreenW, 1)];
    line.backgroundColor = HEXCOLOR(0xdedede);
    
    
    [_footerView addSubview:line];
    [_footerView addSubview:lb_order];
    [_footerView addSubview:lb_price];
    [_footerView addSubview:complete_Btn];
    
    [self.view addSubview:_footerView];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 3;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        return 60;
        
        
    }if (indexPath.row == 1) {
        
        return 70;
    }
    return  62;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (indexPath.row == 0) {
        
        OrderWithAddressCell * addCell = [self.mytableView
                                          dequeueReusableCellWithIdentifier:@"OrderWithAddressCellid" forIndexPath:indexPath];
        addCell.lb_address.text = _postAddress;
        addCell.lb_nameAndPhone.text = [NSString stringWithFormat:@"收货人: %@  %@",_contactUserName,_contactMobilePhone];
        addCell.selectionStyle = UITableViewCellSelectionStyleNone;
        return addCell;
    }
    
    else if (indexPath.row == 1) {
        ZFOrderListCell * listCell = [self.mytableView
                                      dequeueReusableCellWithIdentifier:@"ZFOrderListCellid" forIndexPath:indexPath];
        listCell.listArray = self.goodsListArray;
        listCell.lb_totalNum.text = [NSString stringWithFormat:@"一共%ld件",self.goodsListArray.count] ;
        listCell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        return listCell;
    }
    
    OrderPriceCell * priceCell = [self.mytableView dequeueReusableCellWithIdentifier:@"OrderPriceCellid" forIndexPath:indexPath];
    priceCell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    priceCell.lb_tipFree.text = [NSString stringWithFormat:@"+ ¥%@",_deliveryFee];
    priceCell.lb_priceTotal.text = [NSString stringWithFormat:@"¥%@",_goodsCountMoney];
    
    return priceCell;
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"section = %ld ,row =%ld ",indexPath.section ,indexPath.row);
    
    if (indexPath.row == 0) {
        ZFAddressListViewController * listVC =[[ ZFAddressListViewController alloc]init];
        [self.navigationController pushViewController:listVC animated:YES];
        NSLog(@"编辑地址");
    }
    if (indexPath.row == 1) {
        
        ZFShopListViewController * shoplistVc =[[ZFShopListViewController alloc]init];
        [self.navigationController pushViewController:shoplistVc animated:YES];
    }
}

-(void)didCleckClearing:(UIButton *)sender
{
    NSLog(@" 确认订单 ");
}

#pragma mark - 创建 提交订单getOrderFix
-(void)commitOrderPostRequst
{
    NSDictionary * parma = @{
                             
                             @"svcName":@"getOrderFix",
                             @"cmUserId":BBUserDefault.cmUserId,
                             @"cartItemId":@"1",//可能添加参数
                             
                             };
    
    NSDictionary *parmaDic=[NSDictionary dictionaryWithDictionary:parma];
    
    [SVProgressHUD show];
    
    [PPNetworkHelper POST:ZFB_11SendMessageUrl parameters:parmaDic responseCache:^(id responseCache) {
        
    } success:^(id responseObject) {
        
        if ([responseObject[@"resultCode"] isEqualToString:@"0"]) {
            if (self.goodsListArray.count >0) {
                
                [self.goodsListArray removeAllObjects];
            }
            NSString  * dataStr= [responseObject[@"data"] base64DecodedString];
            NSDictionary * jsondic = [NSString dictionaryWithJsonString:dataStr];
            
            AddressCommitOrderModel *  orderModel = [AddressCommitOrderModel mj_objectWithKeyValues:jsondic];
            
            _goodsCountMoney= orderModel.goodsCountMoney ;
            _goodsAllMoney= orderModel.goodsAllMoney ;
            _deliveryFee = orderModel.deliveryFee;
            
            _contactUserName =  orderModel.orderFixInfo.contactUserName;
            _postAddress = orderModel.orderFixInfo.postAddress;
            _contactMobilePhone = orderModel.orderFixInfo.contactMobilePhone;
            
            for (Cmgoodslist * goodsList in orderModel.cmGoodsList) {
                
                [self.goodsListArray  addObject:goodsList];
            }
            NSLog(@"%@ ==== self.goodsListArray",self.goodsListArray);
            
            [self.mytableView reloadData];
            [SVProgressHUD dismiss];
            
        }
        
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
        [self.view makeToast:@"网络错误" duration:2 position:@"center"];
        [SVProgressHUD dismiss];
        
    }];
    
    
}


-(NSMutableArray *)goodsListArray
{
    if (!_goodsListArray) {
        _goodsListArray =[NSMutableArray array];
        [_goodsListArray addObjectsFromArray:[NSArray arrayWithObjects:@"3",@"1",@"4",@"5",@"2",nil]];
        
    }
    return _goodsListArray;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}





@end
