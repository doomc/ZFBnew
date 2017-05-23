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

@interface ZFShoppingCarViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong) UITableView * shopCar_tableview;
@property (nonatomic,strong) UIView * sectionHeadView;
@property (nonatomic,strong) UIView * sectionFooterView;


@end

@implementation ZFShoppingCarViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self.shopCar_tableview registerNib:[UINib nibWithNibName:@"ZFShopCarCell" bundle:nil] forCellReuseIdentifier:@"ShopCarCellid"];
//    self.sectionHeadView = [self AddwithAHeadViewOfLb_title:@"大王帅进口食品" Andstatus:@"编辑"];
//    self.sectionFooterView = [self creatWithAFooterViewOfCaseOrder:@"总计:" AndPrice:@"¥ 199.00" AndSetButtonTitle:@"结算"];
}
-(void)didclickEdit:(UIButton *)edit
{
    NSLog(@"edit");
}
-(UITableView *)shopCar_tableview
{
    if (!_shopCar_tableview) {
        self.title = @"购物车";
        _shopCar_tableview =[[UITableView alloc]initWithFrame:CGRectMake(0, 64, KScreenW, KScreenH-64-44) style:UITableViewStyleGrouped];
        _shopCar_tableview.delegate = self;
        _shopCar_tableview.dataSource = self;
        _shopCar_tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
        [self.view addSubview:_shopCar_tableview];
    }
    return _shopCar_tableview;
}
-(UIView *)sectionHeadView
{
    if (!_sectionHeadView) {
        _sectionHeadView = [[UIView alloc]initWithFrame:CGRectMake(0 , 0, KScreenW, 40)];
        
        UILabel * time = [[UILabel alloc]initWithFrame:CGRectMake(15, 5, 200, 30)];
        time.text = @"2017-06-20";
        time.font = [UIFont systemFontOfSize:12.0];
        time.textColor = HEXCOLOR(0x363636);
        
        UILabel * status = [[UILabel alloc]initWithFrame:CGRectMake(KScreenW - 80, 5, 80, 30)];
        status.text = @"配送中";
        status.font = [UIFont systemFontOfSize:12.0];
        status.textColor = HEXCOLOR(0x363636);
        status.textAlignment = NSTextAlignmentCenter;
        
        UILabel *line = [[UILabel alloc]initWithFrame:CGRectMake(0, 39, KScreenW, 1)];
        line.backgroundColor =HEXCOLOR(0xdedede);
        
        [_sectionHeadView addSubview:line];
        [_sectionHeadView addSubview:time];
        [_sectionHeadView addSubview:status];
        
    }
    return _sectionHeadView;
}

-(UIView *)sectionFooterView
{
    if (!_sectionFooterView) {
        _sectionFooterView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, KScreenW, 50)];
        _sectionFooterView.backgroundColor =[UIColor whiteColor];
        UILabel * lb_order = [[UILabel alloc]initWithFrame:CGRectMake(15, 5, 100, 30)];
        lb_order.text= @"订单金额:";
        lb_order.font = [UIFont systemFontOfSize:12.0];
        lb_order.textColor = HEXCOLOR(0x363636);
        
        UILabel * price = [[UILabel alloc]initWithFrame:CGRectMake(120, 5, 100, 30)];
        price.text = @"¥208.00";
        price.textAlignment = NSTextAlignmentLeft;
        price.font = [UIFont systemFontOfSize:12.0];
        price.textColor = HEXCOLOR(0xfe6d6a);
        
        UIButton * complete_Btn  = [UIButton buttonWithType:UIButtonTypeCustom];
        complete_Btn.frame =CGRectMake(KScreenW - 100, 5, 80, 25);
        [complete_Btn setTitle:@"配送完成" forState:UIControlStateNormal];
        complete_Btn.titleLabel.font =[UIFont systemFontOfSize:12.0];
        complete_Btn.backgroundColor = HEXCOLOR(0xfe6d6a);
        
        UILabel *line = [[UILabel alloc]initWithFrame:CGRectMake(0, 40, KScreenW, 10)];
        line.backgroundColor =HEXCOLOR(0xdedede);
        
        [_sectionFooterView addSubview:line];
        [_sectionFooterView addSubview: price];
        [_sectionFooterView addSubview:lb_order];
        [_sectionFooterView addSubview:complete_Btn];
        
    }
    return _sectionFooterView;
}
#pragma mark - tableView delegare
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 4;
    
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 165;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return 0.001;
    }
    return 5 ;

}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 5;
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ZFShopCarCell * shopCell = [self.shopCar_tableview dequeueReusableCellWithIdentifier:@"ShopCarCellid" forIndexPath:indexPath];
    shopCell.selectionStyle  = UITableViewCellSelectionStyleNone;
    return shopCell;
    
}
#pragma mark - tableView datasource
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@" section = %ld ， row = %ld",indexPath.section,indexPath.row);
    
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
