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
@interface ZFSureOrderViewController ()<UITableViewDelegate ,UITableViewDataSource>
@property(nonatomic,strong)UITableView * mtableView;

@property(nonatomic,strong)UIView * footerView;

@end

@implementation ZFSureOrderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"确认订单";
    self.mtableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, KScreenW, KScreenH -49-64) style:UITableViewStylePlain];
    self.mtableView.delegate = self;
    self.mtableView.dataSource =self;
    self.mtableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.mtableView];
    
    [self.mtableView registerNib:[UINib nibWithNibName:@"ZFOrderListCell" bundle:nil] forCellReuseIdentifier:@"ZFOrderListCellid"];
    [self.mtableView registerNib:[UINib nibWithNibName:@"OrderWithAddressCell" bundle:nil] forCellReuseIdentifier:@"OrderWithAddressCellid"];
    [self.mtableView registerNib:[UINib nibWithNibName:@"OrderPriceCell" bundle:nil] forCellReuseIdentifier:@"OrderPriceCellid"];
    
    [self creatCustomfooterView];
    
}

-(void)creatCustomfooterView
{
    
    NSString *buttonTitle = @"配送完成";
    NSString *price = @"¥208.00";
    NSString *caseOrder =  @"订单金额";
    
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
    return 4;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        return 60;
        
        
    }if (indexPath.row == 1) {
        
        return 70;
    }
    return  44;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        
        OrderWithAddressCell * addCell = [self.mtableView dequeueReusableCellWithIdentifier:@"OrderWithAddressCellid" forIndexPath:indexPath];
       
        return addCell;
    }
    if (indexPath.row == 1) {
        
        ZFOrderListCell * listCell = [self.mtableView dequeueReusableCellWithIdentifier:@"ZFOrderListCellid" forIndexPath:indexPath];
        return listCell;
    }
    OrderPriceCell * priceCell = [self.mtableView dequeueReusableCellWithIdentifier:@"OrderPriceCellid" forIndexPath:indexPath];
    return priceCell;
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"section = %ld ,row =%ld ",indexPath.section ,indexPath.row);
    
    if (indexPath.row == 0) {
        
        NSLog(@"编辑地址");
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}





@end
