//
//  ZFShopListViewController.m
//  ZFB
//
//  Created by 熊维东 on 2017/5/24.
//  Copyright © 2017年 com.zfb. All rights reserved.
//

#import "ZFShopListViewController.h"
#import "ZFShopListCell.h"

@interface ZFShopListViewController ()<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic,strong)UITableView  * mytableView;

@end

@implementation ZFShopListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title =@"商家清单";
    
    
    self.mytableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, KScreenW, KScreenH-64) style:UITableViewStylePlain];
    self.mytableView.delegate= self;
    self.mytableView.dataSource = self;
    [self.view addSubview:self.mytableView];
    self.mytableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [self.mytableView registerNib:[UINib nibWithNibName:@"ZFShopListCell" bundle:nil] forCellReuseIdentifier:@"ZFShopListCellid"];
     
}


-(UIView *)customHeaderView
{
    NSString *leftTitle = @"周妈妈服饰店";
    
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
    
    
    UILabel *lineDown =[[UILabel alloc]initWithFrame:CGRectMake(0, 39, KScreenW, 1)];
    lineDown.backgroundColor = HEXCOLOR(0xdedede);

    [headerView addSubview:lineDown];
    [headerView addSubview:title];
    return headerView;
    
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
    
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

    return 1;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{

    return 118;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 40;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return  [self customHeaderView];

}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{

    ZFShopListCell * listCell = [self.mytableView dequeueReusableCellWithIdentifier:@"ZFShopListCellid" forIndexPath:indexPath];
    
    
    return listCell;
}


@end
