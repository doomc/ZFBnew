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
#import "ZFMainPayforViewController.h"

@interface ZFSureOrderViewController ()<UITableViewDelegate ,UITableViewDataSource>
{
    NSString * _contactUserName;
    NSString * _postAddress;
    NSString * _contactMobilePhone;
    NSString * _goodsCountMoney;//商品总价
    NSString * _deliveryFee;//配送费
    NSString * _goodsAllMoney;//支付总金额
    UILabel * lb_price;
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
    NSString *price = @"¥0.00";
    NSString *caseOrder =  @"实付金额:";
    
    UIFont * font  =[UIFont systemFontOfSize:14];
    _footerView = [[UIView alloc]initWithFrame:CGRectMake(0,KScreenH -49, KScreenW, 49)];
    _footerView.backgroundColor =[UIColor clearColor];
    [self.view addSubview:_footerView];
    
    //结算按钮
    UIButton * complete_Btn  = [UIButton buttonWithType:UIButtonTypeCustom];
    [complete_Btn setTitle:buttonTitle forState:UIControlStateNormal];
    complete_Btn.titleLabel.font =font;
    complete_Btn.backgroundColor =HEXCOLOR(0xfe6d6a);
    
    complete_Btn.frame =CGRectMake(KScreenW - 120 , 0, 120 , 49);
    [complete_Btn addTarget:self action:@selector(didCleckClearing:) forControlEvents:UIControlEventTouchUpInside];
    [_footerView addSubview:complete_Btn];
    
    //固定金额位置
    UILabel * lb_order = [[UILabel alloc]init];
    lb_order.text= caseOrder;
    lb_order.font = font;
    lb_order.textColor = HEXCOLOR(0x363636);
    CGSize lb_orderSiez = [caseOrder sizeWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:font,NSFontAttributeName, nil]];
    CGFloat lb_orderW = lb_orderSiez.width;
    lb_order.frame =  CGRectMake(50, 1, lb_orderW+10, 48);
    [_footerView addSubview:lb_order];
    
    //价格
    lb_price = [[UILabel alloc]init];
    lb_price.text = price;
    lb_price.textAlignment = NSTextAlignmentLeft;
    lb_price.font = font;
    lb_price.textColor = HEXCOLOR(0xfe6d6a);
    lb_price.frame =  CGRectMake(50 +lb_orderW+20, 1, 100, 48);
    [_footerView addSubview:lb_price];
    
    
    UILabel * line =[[ UILabel alloc]initWithFrame:CGRectMake(0, 0, KScreenW, 1)];
    line.backgroundColor = HEXCOLOR(0xdedede);
    [_footerView addSubview:line];
    
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
        listCell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        if (self.goodsListArray.count > 0) {
            listCell.listArray = self.goodsListArray;
            listCell.lb_totalNum.text = [NSString stringWithFormat:@"一共%ld件",self.goodsListArray.count] ;
        }
        return listCell;
    }
    
    OrderPriceCell * priceCell = [self.mytableView dequeueReusableCellWithIdentifier:@"OrderPriceCellid" forIndexPath:indexPath];
    priceCell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    priceCell.lb_tipFree.text = [NSString stringWithFormat:@"+ ¥%.2f",[_deliveryFee floatValue]];
    priceCell.lb_priceTotal.text = [NSString stringWithFormat:@"¥%.2f",[_goodsCountMoney floatValue]];
    
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

#pragma mark - 提交订单 didCleckClearing
-(void)didCleckClearing:(UIButton *)sender
{
    NSLog(@" 确认订单 ");
    ZFMainPayforViewController * payVC = [[ZFMainPayforViewController alloc]init];
    
    [self.navigationController pushViewController:payVC animated:YES];
}

#pragma mark - 创建 提交订单getOrderFix
-(void)commitOrderPostRequst
{
    NSDictionary * parma = @{
                             
                             @"cmUserId":BBUserDefault.cmUserId,
                             
                             };
    
    [MENetWorkManager post:[NSString stringWithFormat:@"%@/order/getOrderFix",zfb_baseUrl] params:parma success:^(id response) {
        
        if ([response[@"resultCode"] intValue] == 0) {
            
            if (self.goodsListArray.count >0) {
                
                [self.goodsListArray removeAllObjects];
                
            }
            AddressCommitOrderModel *  orderModel = [AddressCommitOrderModel mj_objectWithKeyValues:response];
            
            _goodsCountMoney= orderModel.goodsCountMoney ;
            _deliveryFee = orderModel.deliveryFee;
            _goodsAllMoney= orderModel.goodsAllMoney ;
            
            _contactUserName =  orderModel.orderFixInfo.contactUserName;
            _postAddress = orderModel.orderFixInfo.postAddress;
            _contactMobilePhone = orderModel.orderFixInfo.contactMobilePhone;
            
            for (Cmgoodslist * goodsList in orderModel.cmGoodsList) {
                
                [self.goodsListArray  addObject:goodsList];
            }
            
            NSLog(@"%@ ==== self.goodsListArray",self.goodsListArray);
            
            lb_price.text = [NSString stringWithFormat:@"¥ %.2f",[_goodsAllMoney floatValue]];
            
            [self.mytableView reloadData];

        }
        [self.view makeToast:response[@"resultMsg"] duration:2 position:@"center"];

    } progress:^(NSProgress *progeress) {
        
        NSLog(@"progeress=====%@",progeress);
        
    } failure:^(NSError *error) {
        
        NSLog(@"error=====%@",error);
        [self.view makeToast:@"网络错误" duration:2 position:@"center"];
    }];
 
    
}


-(NSMutableArray *)goodsListArray
{
    if (!_goodsListArray) {
        _goodsListArray =[NSMutableArray array];
        
    }
    return _goodsListArray;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}





@end
