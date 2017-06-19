//
//  ZFShoppingCarViewController.m
//  ZFB
//
//  Created by  展富宝  on 2017/5/11.
//  Copyright © 2017年 com.zfb. All rights reserved.
//  ****购物车


#import "ZFShoppingCarViewController.h"
#import "LoginViewController.h"
#import "ZFShopCarCell.h"
#import "ZFMainPayforViewController.h"
#import "DetailFindGoodsViewController.h"


@interface ZFShoppingCarViewController ()<UITableViewDelegate,UITableViewDataSource,PPNumberButtonDelegate>

@property (nonatomic,strong) UITableView * shopCar_tableview;

@property (nonatomic,strong) UIView * footView;
@property (nonatomic,strong) UIView * sectionHeadView;


@end

@implementation ZFShoppingCarViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self.shopCar_tableview registerNib:[UINib nibWithNibName:@"ZFShopCarCell" bundle:nil] forCellReuseIdentifier:@"ShopCarCellid"];
    
    
    [self.view addSubview:self.footView];
    
    
}

-(UITableView *)shopCar_tableview
{
    if (!_shopCar_tableview) {
        self.title = @"购物车";
        _shopCar_tableview =[[UITableView alloc]initWithFrame:CGRectMake(0, 64, KScreenW, KScreenH-64-49*2) style:UITableViewStyleGrouped];
        _shopCar_tableview.delegate = self;
        _shopCar_tableview.dataSource = self;
        _shopCar_tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
//        _shopCar_tableview.backgroundColor = [UIColor whiteColor];
        [self.view addSubview:_shopCar_tableview];
    }
    return _shopCar_tableview;
}
-(UIView *)sectionHeadView
{
    
    NSString *statusStr = @"编辑";
    NSString *titletext = @"王大帅进口食品厂";
    UIFont * font  =[UIFont systemFontOfSize:12];
    _sectionHeadView  = [[UIView alloc]initWithFrame:CGRectMake(0 , 0, KScreenW, 40)];
    _sectionHeadView.backgroundColor = [UIColor whiteColor];
    UILabel * title = [[UILabel alloc]init];
    title.text = titletext;
    title.font = font;
    CGSize size = [title.text sizeWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:font,NSFontAttributeName,nil]];
    CGFloat titleW = size.width;
    
    title.frame = CGRectMake(15, 5, titleW, 30);
    title.textColor = HEXCOLOR(0x363636);
    
    
    UIButton * status = [[UIButton alloc]init ];
    [status setTitle:statusStr forState:UIControlStateNormal];
    status.titleLabel.font = font;
    [status setTitleColor: HEXCOLOR(0x7a7a7a) forState:UIControlStateNormal];
    CGSize statusSize = [statusStr sizeWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:font,NSFontAttributeName,nil]];
    CGFloat statusW = statusSize.width;
    
    status.frame = CGRectMake(KScreenW - statusW - 15, 5, statusW, 30);
    [status addTarget:self action:@selector(didclickEdit:) forControlEvents:UIControlEventTouchUpInside];
    
    UILabel *lineDown =[[UILabel alloc]initWithFrame:CGRectMake(0, 39, KScreenW, 0.5)];
    lineDown.backgroundColor = HEXCOLOR(0xffcccc);
    UILabel *lineUP =[[UILabel alloc]initWithFrame:CGRectMake(0,0, KScreenW, 10)];
    lineUP.backgroundColor = RGB(247, 247, 247);//#F7F7F7 16进制
    
    [_sectionHeadView addSubview:lineDown];
    //    [headerView addSubview:lineUP];
    [_sectionHeadView addSubview:status];
    [_sectionHeadView addSubview:title];
    
    
    
    return _sectionHeadView;
}
-(UIView *)footView
{
    if (!_footView) {
        
        _footView= [[UIView alloc]initWithFrame:CGRectMake(0, KScreenH -49-49, KScreenW,  KScreenH -49-49-64)];
        _footView.backgroundColor = randomColor;
        
        
        NSString *buttonTitle = @"结算";
        NSString *price = @"¥208.00";
        NSString *caseOrder =  @"订单金额";
        UIFont * font  =[UIFont systemFontOfSize:12];
        
        
        //结算按钮
        UIButton * complete_Btn  = [UIButton buttonWithType:UIButtonTypeCustom];
        [complete_Btn setTitle:buttonTitle forState:UIControlStateNormal];
        complete_Btn.titleLabel.font =font;
        complete_Btn.layer.cornerRadius = 2;
        complete_Btn.backgroundColor =HEXCOLOR(0xfe6d6a);
        CGSize complete_BtnSize = [buttonTitle sizeWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:font,NSFontAttributeName,nil]];
        CGFloat complete_BtnW = complete_BtnSize.width;
        complete_Btn.frame =CGRectMake(KScreenW - complete_BtnW - 25, 5, complete_BtnW +10, 25);
        [complete_Btn addTarget:self action:@selector(didClickClearing:) forControlEvents:UIControlEventTouchUpInside];
        
        
        //价格
        UILabel * lb_price = [[UILabel alloc]init];
        lb_price.text = price;
        lb_price.textAlignment = NSTextAlignmentLeft;
        lb_price.font = font;
        lb_price.textColor = HEXCOLOR(0xfe6d6a);
        CGSize lb_priceSize = [price sizeWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:font,NSFontAttributeName, nil]];
        CGFloat lb_priceW = lb_priceSize.width;
        lb_price.frame = CGRectMake(KScreenW - lb_priceW -35-complete_BtnW, 5, lb_priceW, 30);
        
        //固定金额位置
        UILabel * lb_order = [[UILabel alloc]init];
        lb_order.text= caseOrder;
        lb_order.font = font;
        lb_order.textColor = HEXCOLOR(0x363636);
        CGSize lb_orderSiez = [caseOrder sizeWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:font,NSFontAttributeName, nil]];
        CGFloat lb_orderW = lb_orderSiez.width;
        lb_order.frame =  CGRectMake(KScreenW - lb_priceW -35-complete_BtnW-15-lb_orderW, 5, lb_orderW, 30);
        
        [_footView addSubview: lb_price];
        [_footView addSubview:lb_order];
        [_footView addSubview:complete_Btn];
        
    }
    return _footView;
}

-(UIView *)CreatSectionFooterView
{
    NSString *buttonTitle = @"结算";
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
    complete_Btn.frame =CGRectMake(KScreenW - complete_BtnW - 25, 5, complete_BtnW +10, 25);
    [complete_Btn addTarget:self action:@selector(didClickClearing:) forControlEvents:UIControlEventTouchUpInside];
    
    
    //价格
    UILabel * lb_price = [[UILabel alloc]init];
    lb_price.text = price;
    lb_price.textAlignment = NSTextAlignmentLeft;
    lb_price.font = font;
    lb_price.textColor = HEXCOLOR(0xfe6d6a);
    CGSize lb_priceSize = [price sizeWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:font,NSFontAttributeName, nil]];
    CGFloat lb_priceW = lb_priceSize.width;
    lb_price.frame = CGRectMake(KScreenW - lb_priceW -35-complete_BtnW, 5, lb_priceW, 30);
    
    //固定金额位置
    UILabel * lb_order = [[UILabel alloc]init];
    lb_order.text= caseOrder;
    lb_order.font = font;
    lb_order.textColor = HEXCOLOR(0x363636);
    CGSize lb_orderSiez = [caseOrder sizeWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:font,NSFontAttributeName, nil]];
    CGFloat lb_orderW = lb_orderSiez.width;
    lb_order.frame =  CGRectMake(KScreenW - lb_priceW -35-complete_BtnW-15-lb_orderW, 5, lb_orderW, 30);
    
    
    [footerView addSubview: lb_price];
    [footerView addSubview:lb_order];
    [footerView addSubview:complete_Btn];
    
    return footerView;
    
}
-(void)didclickEdit:(UIButton *)edit
{
    NSLog(@"edit");
}
#pragma mark - tableView delegare
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 4;
    
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 92;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    
    return [self sectionHeadView] ;
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    //    if (section == 0) {
    //        return 0.001;
    //    }
    return 40.001 ;
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 10;
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ZFShopCarCell * shopCell = [self.shopCar_tableview dequeueReusableCellWithIdentifier:@"ShopCarCellid" forIndexPath:indexPath];
    shopCell.selectionStyle  = UITableViewCellSelectionStyleNone;
    shopCell.ppNumberView.delegate = self;
    shopCell.ppNumberView.resultBlock = ^(NSInteger num ,BOOL increaseStatus){
        
        NSLog(@"该方法 没有执行 %ld",num);
        
    };
    
    return shopCell;
    
}
-(void)selectResult:(NSInteger)result
{
    
}
#pragma mark - tableView datasource
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@" section = %ld ， row = %ld",indexPath.section,indexPath.row);
    DetailFindGoodsViewController *deatilGoods =[[DetailFindGoodsViewController alloc]init];
    [self.navigationController pushViewController:deatilGoods animated:YES];
    
}


-(void )didClickClearing :(UIButton *)sender
{
    ZFMainPayforViewController * payVC = [[ZFMainPayforViewController alloc]init];
    
    [self.navigationController pushViewController:payVC animated:YES];
    
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
