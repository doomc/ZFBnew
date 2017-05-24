//
//  ZFAddressListViewController.m
//  ZFB
//
//  Created by 熊维东 on 2017/5/24.
//  Copyright © 2017年 com.zfb. All rights reserved.
//  收货地址列表

#import "ZFAddressListViewController.h"
#import "ZFEditAddressViewController.h"
#import "ZFAddOfListCell.h"

@interface ZFAddressListViewController ()<UITableViewDataSource,UITableViewDelegate>
@property(nonatomic,strong)UITableView *mytableView;

@end

@implementation ZFAddressListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title =@"选择收货地址";

    self.mytableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, KScreenW, KScreenH-64) style:UITableViewStylePlain];
    self.mytableView.delegate= self;
    self.mytableView.dataSource = self;
    [self.view addSubview:self.mytableView];
    self.mytableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.mytableView registerNib:[UINib nibWithNibName:@"ZFAddOfListCell" bundle:nil] forCellReuseIdentifier:@"ZFAddOfListCellid"];
    
    [self customHeaderView];
    
}
-(void)customHeaderView
{
    
    NSString *leftTitle = @"配送地址";
    NSString *rigntTitle = @"增加地址";
    
    
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
    [status addTarget:self action:@selector(didclickAdd:) forControlEvents:UIControlEventTouchUpInside];
    
    UILabel *lineDown =[[UILabel alloc]initWithFrame:CGRectMake(0, 39, KScreenW, 1)];
    lineDown.backgroundColor = HEXCOLOR(0xdedede);
    UILabel *lineUP =[[UILabel alloc]initWithFrame:CGRectMake(0,0, KScreenW, 10)];
    lineUP.backgroundColor = HEXCOLOR(0xdedede);
    
    [headerView addSubview:lineDown];
    //        [headerView addSubview:lineUP];
    [headerView addSubview:status];
    [headerView addSubview:title];
    self.mytableView.tableHeaderView = headerView;
    
}
-(void)didclickAdd:(UIButton*)add
{
    NSLog(@"添加地址");
    ZFEditAddressViewController * edit = [[ZFEditAddressViewController alloc]init];
    
    [self.navigationController pushViewController:edit animated:YES];
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
    
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 5;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 72;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ZFAddOfListCell * addCell = [self.mytableView dequeueReusableCellWithIdentifier:@"ZFAddOfListCellid" forIndexPath:indexPath];
    
    
    return addCell;
}

@end
