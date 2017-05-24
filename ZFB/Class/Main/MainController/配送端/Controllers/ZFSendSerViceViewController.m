//
//  ZFSendSerViceViewController.m
//  ZFB
//
//  Created by  展富宝  on 2017/5/24.
//  Copyright © 2017年 com.zfb. All rights reserved.
//

#import "ZFSendSerViceViewController.h"
#import "ZFSendingCell.h"
#import "ZFContactCell.h"

typedef NS_ENUM(NSUInteger, TypeCell) {
    TypeCell_SendingCell = 0,
    TypeCell_ContactCell,
 
};
@interface ZFSendSerViceViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *send_tableView;
@property (weak, nonatomic) IBOutlet UIButton *Home_btn;
@property (weak, nonatomic) IBOutlet UIButton *Order_btn;

@property (strong,nonatomic) NSArray *titles;
@property (strong,nonatomic) NSArray *detailTitles;

@end

@implementation ZFSendSerViceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
  
    self.send_tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.send_tableView registerNib:[UINib nibWithNibName:@"ZFSendingCell" bundle:nil] forCellReuseIdentifier:@"ZFSendingCellid"];
    [self.send_tableView registerNib:[UINib nibWithNibName:@"ZFContactCell" bundle:nil] forCellReuseIdentifier:@"ZFContactCellid"];
    
    _titles = @[@"待配送",@"已配送",@"配送中",@"地上门取件"];
    _detailTitles =@[@"张三",@"182139823",@"收货地址收货地址收货地址",@"取货地址取货地址取货地址取货地址:",@"¥19.00"];

    [self customFooterView];
    [self customHeaderView];
    
}

#pragma mark - 创建视图

-(void)initButtonWithInterface
{
    [self.Home_btn  addTarget:self action:@selector(Home_btnaTargetAction) forControlEvents:UIControlEventTouchUpInside];
    [self.Order_btn  addTarget:self action:@selector(Order_btnaTargetAction) forControlEvents:UIControlEventTouchUpInside];

}
-(UIView*)customHeaderView
{
    
    NSString *leftTitle = @"2017-08-23";
    NSString *rigntTitle = @"配送中";
    
    
    UIView *  headerView = [[UIView alloc]initWithFrame:CGRectMake(0 , 0, KScreenW, 40)];
    headerView.backgroundColor =[ UIColor whiteColor];
    UIFont * font  =[UIFont systemFontOfSize:12];
    
    UILabel * title = [[UILabel alloc]init];
    title.text = leftTitle;
    title.font = font;
    CGSize size = [title.text sizeWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:font,NSFontAttributeName,nil]];
    CGFloat titleW = size.width;
    title.frame = CGRectMake(15, 5, titleW, 30);
    title.textColor = HEXCOLOR(0x363636);
    
    
    UIButton * status = [[UIButton alloc]init ];
    [status setTitle:rigntTitle forState:UIControlStateNormal];
    status.titleLabel.font = font;
    [status setTitleColor: HEXCOLOR(0x363636) forState:UIControlStateNormal];
    CGSize statusSize = [rigntTitle sizeWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:font,NSFontAttributeName,nil]];
    CGFloat statusW = statusSize.width;
    
    status.frame = CGRectMake(KScreenW - statusW - 15, 5, statusW, 30);
    [status addTarget:self action:@selector(didclickSend:) forControlEvents:UIControlEventTouchUpInside];
    
    UILabel *lineDown =[[UILabel alloc]initWithFrame:CGRectMake(0, 39, KScreenW, 1)];
    lineDown.backgroundColor = HEXCOLOR(0xdedede);
    UILabel *lineUP =[[UILabel alloc]initWithFrame:CGRectMake(0,0, KScreenW, 10)];
    lineUP.backgroundColor = HEXCOLOR(0xdedede);
    
    [headerView addSubview:lineDown];
    //        [headerView addSubview:lineUP];
    [headerView addSubview:status];
    [headerView addSubview:title];
    
    return headerView;
}
-(UIView*)customFooterView
{
    NSString *buttonTitle = @"配送完成";
    NSString *price = @"¥208.00";
    NSString *caseOrder =  @"订单金额";
    
    UIFont * font  =[UIFont systemFontOfSize:12];
    UIView* footerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, KScreenW, 50)];
    footerView.backgroundColor =[UIColor whiteColor];
    
    //结算按钮
    UIButton * complete_Btn  = [UIButton buttonWithType:UIButtonTypeCustom];
    [complete_Btn setTitle:buttonTitle forState:UIControlStateNormal];
    complete_Btn.titleLabel.font =font;
    complete_Btn.layer.cornerRadius = 2;
    complete_Btn.backgroundColor =HEXCOLOR(0xfe6d6a);
    CGSize complete_BtnSize = [buttonTitle sizeWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:font,NSFontAttributeName,nil]];
    CGFloat complete_BtnW = complete_BtnSize.width;
    complete_Btn.frame =CGRectMake(KScreenW - complete_BtnW - 25, 5, complete_BtnW +20, 30);
    [complete_Btn addTarget:self action:@selector(didCleckClearing:) forControlEvents:UIControlEventTouchUpInside];
    
    
    //固定金额位置
    UILabel * lb_order = [[UILabel alloc]init];
    lb_order.text= caseOrder;
    lb_order.font = font;
    lb_order.textColor = HEXCOLOR(0x363636);
    CGSize lb_orderSiez = [caseOrder sizeWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:font,NSFontAttributeName, nil]];
    CGFloat lb_orderW = lb_orderSiez.width;
    lb_order.frame =  CGRectMake(15, 5, lb_orderW, 30);
    
    //价格
    UILabel * lb_price = [[UILabel alloc]init];
    lb_price.text = price;
    lb_price.textAlignment = NSTextAlignmentLeft;
    lb_price.font = font;
    lb_price.textColor = HEXCOLOR(0xfe6d6a);
    CGSize lb_priceSize = [price sizeWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:font,NSFontAttributeName, nil]];
    CGFloat lb_priceW = lb_priceSize.width;
    lb_price.frame = CGRectMake(15+lb_orderW+10, 5, lb_priceW, 30);
    
    
    [footerView addSubview: lb_price];
    [footerView addSubview:lb_order];
    [footerView addSubview:complete_Btn];
    return footerView;
}

//-(void)setCustomerNavgationBarWithNavTitle:(NSString *)Navtitle  btnisHidden :(BOOL)isHidden
//{
//    self.navigationController.navigationBar.hidden = YES;
//    
//    UIView * bgView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, KScreenW, 64)];
//    [self.view addSubview:bgView];
//    bgView.backgroundColor = HEXCOLOR(0xffcccc);
//    
//    UIButton * left_btn = [UIButton buttonWithType:UIButtonTypeCustom];
//    left_btn.frame =CGRectMake(10, bgView.centerY, 24, 24);
//    [left_btn setImage:[UIImage imageNamed:@"nav_back"] forState:UIControlStateNormal];
//    //    [left_btn addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
//    [bgView addSubview:left_btn];
//    
//    
//    UILabel * lb_title = [[UILabel alloc]initWithFrame:CGRectMake(bgView.centerX-20,bgView.centerY, 60, 24)];
//    lb_title.text = Navtitle;
//    lb_title.adjustsFontSizeToFitWidth = YES;
//    lb_title.textAlignment = NSTextAlignmentCenter;
//    lb_title.font = [UIFont systemFontOfSize:15];
//    lb_title.textColor = HEXCOLOR(0xfe6d6a);
//    [bgView addSubview:lb_title];
//    //  CGSize titleSize = [lb_title.text sizeWithFont:lb_title.font constrainedToSize:CGSizeMake(MAXFLOAT, 30)];
//    
//    
//    
//    UIButton * btn_Action = [UIButton buttonWithType:UIButtonTypeCustom];
//    btn_Action.frame =CGRectMake(bgView.centerX+40 , bgView.centerY, 24, 24);
//    [btn_Action setImage:[UIImage imageNamed:@"Order_down"] forState:UIControlStateNormal];
//    [btn_Action addTarget:self action:@selector(didclickSendPopViewAction) forControlEvents:UIControlEventTouchUpInside];
//    btn_Action.hidden = isHidden;
//    [bgView addSubview:btn_Action];
//}


#pragma mark  -tableView delegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        
        return 2;
    }else{
        return _titles.count;
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section== 0) {
        return 85;
    }
    return 40;
}
//设置headView视图
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        
        return 40;
    }
    return 40;
}
//设置footerView视图
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (section == 0) {
        
        return 50;
    }
    return 0;
    
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return  [self customHeaderView];
}
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    return [self customFooterView];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        ZFSendingCell *sendCell = [self.send_tableView dequeueReusableCellWithIdentifier:@"sendCellid" forIndexPath:indexPath];
        sendCell.selectionStyle =  UITableViewCellSelectionStyleNone;
        return sendCell;
    }
    
    ZFContactCell * contactCell = [self.send_tableView dequeueReusableCellWithIdentifier:@"ZFContactCellid" forIndexPath:indexPath];
    contactCell.lb_title.text = self.titles[indexPath.row];
    contactCell.lb_detailTitle.text =self.detailTitles[indexPath.row];
    contactCell.selectionStyle =  UITableViewCellSelectionStyleNone;
 
    return contactCell;
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
    NSLog(@"首页");
    self.title = @"配送端";
    self.img_sendHome.image = [UIImage imageNamed:@"home_red"];
    self.lb_sendHomeTitle.textColor = HEXCOLOR(0xfe6d6a);
    
    self.lb_sendOrderTitle.textColor=[UIColor whiteColor];
    self.img_sendOrder.image = [UIImage imageNamed:@"Order_normal"];
    
}
-(void)Order_btnaTargetAction
{
    self.title = @"已配送";
    NSLog(@"订单");
    self.img_sendHome.image = [UIImage imageNamed:@"home_normal"];
    self.lb_sendHomeTitle.textColor = [UIColor whiteColor];
    
    self.lb_sendOrderTitle.textColor= HEXCOLOR(0xfe6d6a);
    self.img_sendOrder.image = [UIImage imageNamed:@"send_red"];
}
@end
