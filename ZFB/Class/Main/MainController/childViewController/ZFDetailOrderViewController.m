//
//  ZFDetailOrderViewController.m
//  ZFB
//
//  Created by  展富宝  on 2017/5/27.
//  Copyright © 2017年 com.zfb. All rights reserved.
//  订单详情

#import "ZFDetailOrderViewController.h"

#import "ZFOrderDetailCell.h" //公共cell
#import "OrderWithAddressCell.h"//地址
#import "ZFOrderDetailCountCell.h"//商品金额+配送费
#import "ZFOrderDetailPaycashCell.h"//付款
#import "ZFOrderDetailSectionCell.h" //店铺名称
#import "ZFOrderDetailGoosContentCell.h"//商品简要


static  NSString * commonDetailCellid = @"ZFOrderDetailCellid";
static  NSString * addressCellid      = @"ZFOrderWithAddressCellid";
static  NSString * kcountDetailCellid = @"ZFOrderDetailCountCellid";
static  NSString * payCashDetailCellid = @"ZFOrderDetailPaycashCellid";
static  NSString * sectionDetailCellid = @"ZFOrderDetailSectionCellid";
static  NSString * kcontentDetailCellid = @"ZFOrderDetailGoosContentCellid";

@interface ZFDetailOrderViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong) UITableView* tableView;
@property (nonatomic,strong) UIView*  footerView;
@property (nonatomic,strong) UIButton * sure_payfor;//确认支付

@property (nonatomic,assign)OrderDetailType  orderDetailType;

@end

@implementation ZFDetailOrderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"订单详情";
    
    [self.view addSubview:self.tableView];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"ZFOrderDetailCell" bundle:nil]
         forCellReuseIdentifier:commonDetailCellid];//公共cell
    
    [self.tableView registerNib:[UINib nibWithNibName:@"OrderWithAddressCell" bundle:nil]
         forCellReuseIdentifier:addressCellid];//地址
    
    [self.tableView registerNib:[UINib nibWithNibName:@"ZFOrderDetailCountCell" bundle:nil]
         forCellReuseIdentifier:kcountDetailCellid];//商品金额+配送费
    
    [self.tableView registerNib:[UINib nibWithNibName:@"ZFOrderDetailPaycashCell" bundle:nil]
         forCellReuseIdentifier:payCashDetailCellid];//付款
    
    [self.tableView registerNib:[UINib nibWithNibName:@"ZFOrderDetailSectionCell" bundle:nil]
         forCellReuseIdentifier:sectionDetailCellid];//店铺名称
    
    [self.tableView registerNib:[UINib nibWithNibName:@"ZFOrderDetailGoosContentCell" bundle:nil]
         forCellReuseIdentifier:kcontentDetailCellid];//商品简要

    
}
-(UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, KScreenW, KScreenH -64) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
    }
    return _tableView;
    
}
-(UIButton *)sure_payfor
{
    if (!_sure_payfor) {
        
        _sure_payfor = [UIButton buttonWithType:UIButtonTypeCustom];
        [_sure_payfor setTitle:@"付款" forState:UIControlStateNormal];
        [_sure_payfor setBackgroundColor:HEXCOLOR(0xfe6d6a)];
        UIFont *font  =[UIFont systemFontOfSize:15];
        _sure_payfor.titleLabel.font =font;
        CGSize size = [_sure_payfor.titleLabel.text sizeWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:font,NSFontAttributeName,nil]];
        CGFloat width = size.width;
        _sure_payfor.frame = CGRectMake(KScreenW - width -20, 10, width +20, 30);
        _sure_payfor.layer.cornerRadius = 2;
        [_sure_payfor addTarget:self action:@selector(didClickPayFor:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _sure_payfor;
}
-(UIView *)footerView
{
    if (!_footerView) {
        _footerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, KScreenW, 50)];
      
        
        [_footerView addSubview:self.sure_payfor];
    }
    return  _footerView;
}


-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 9;
}
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    return self.footerView;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    CGFloat footHight = 0;
    if ( section == 0) {
        return 50;
    }
    return footHight;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat height = 0;
    
    if (indexPath.row == 0) {
        
        height = 44;
         return height;
    }
    else if (indexPath.row == 1) {
        
        height = 60;

        return height;
    }
    else if (indexPath.row == 2) {

        height = 40;

        return height;
    }
    else if (indexPath.row == 3) {
        
        height =  100;

        return height;
    }
    else if (indexPath.row == 4) {
        
        height = 44;

        return height;
    } else if (indexPath.row ==5) {
        
        height = 44;

        return height;
    } else if (indexPath.row ==6) {
        
        height = 44;

        return height;
    }
    else if (indexPath.row == 7) {
        
        height = 70;

        return height;
    }
    else if (indexPath.row == 8) {
        
        height = 70;

        return height;
    }
    
    return height;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell  * cell = nil;
    
    if (indexPath.row == 0) {
        
        ZFOrderDetailCell* detailCell = [self.tableView dequeueReusableCellWithIdentifier:commonDetailCellid forIndexPath:indexPath];
        cell = detailCell;
        
    }
    else if (indexPath.row == 1) {
        
        OrderWithAddressCell* addressCell = [self.tableView dequeueReusableCellWithIdentifier:addressCellid forIndexPath:indexPath];
        cell = addressCell;
        
    }
    else if (indexPath.row == 2) {//店铺名称
        
        ZFOrderDetailSectionCell* storeCell = [self.tableView dequeueReusableCellWithIdentifier:sectionDetailCellid forIndexPath:indexPath];
        cell = storeCell;
        
    }
    else if (indexPath.row == 3) {
        
        ZFOrderDetailGoosContentCell* goodsCell = [self.tableView dequeueReusableCellWithIdentifier:kcontentDetailCellid forIndexPath:indexPath];
        cell = goodsCell;
        
    }
    else if (indexPath.row == 4) {
        
        ZFOrderDetailCell* detailCell = [self.tableView dequeueReusableCellWithIdentifier:commonDetailCellid forIndexPath:indexPath];
        cell = detailCell;
        
    }
    else if (indexPath.row == 5) {
        
        ZFOrderDetailCell* detailCell = [self.tableView dequeueReusableCellWithIdentifier:commonDetailCellid forIndexPath:indexPath];
        cell = detailCell;
        
    }
    else if (indexPath.row == 6) {
        
        ZFOrderDetailCell* detailCell = [self.tableView dequeueReusableCellWithIdentifier:commonDetailCellid forIndexPath:indexPath];
        cell = detailCell;
        
    }
    else if (indexPath.row == 7) {
        
        ZFOrderDetailCountCell* countCell = [self.tableView dequeueReusableCellWithIdentifier:kcountDetailCellid forIndexPath:indexPath];
        cell = countCell;
        
    }
    else  {
        
        ZFOrderDetailPaycashCell* payCell= [self.tableView dequeueReusableCellWithIdentifier:payCashDetailCellid forIndexPath:indexPath];
        cell = payCell;
        
    }
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"%ld = section ,%ld = row ",indexPath.section,indexPath.row);
}

- (void)didClickPayFor:(UIButton *)sender {
 
    NSLog(@"  = section   row ");

}


@end