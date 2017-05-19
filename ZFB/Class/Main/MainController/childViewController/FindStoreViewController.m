

//
//  FindStoreViewController.m
//  ZFB
//
//  Created by  展富宝  on 2017/5/15.
//  Copyright © 2017年 com.zfb. All rights reserved.
//

#import "FindStoreViewController.h"
#import "FindStoreCell.h"
#import "HP_LocationViewController.h"
#import "DetailStoreViewController.h"
#import "ZFAllStoreViewController.h"
@interface FindStoreViewController ()<UITableViewDataSource,UITableViewDelegate>
@property(strong,nonatomic )UITableView * home_tableView;


@end

@implementation FindStoreViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    [self initWithHome_Tableview];
 
    [self initInTerfaceView];
    
    [self initWithLocation];
    
}

-(void)initInTerfaceView{
   
    UIView * loc_view =[[ UIView alloc]initWithFrame:CGRectMake(0, 0, KScreenW, 39)];//背景图
    UIView * bg_view =[[UIView alloc]initWithFrame:CGRectMake(5, 5, KScreenW-10, 30)];
    [loc_view addSubview:bg_view];
   
    bg_view.layer.borderWidth = 1.0;
    bg_view.layer.cornerRadius = 4.0;
    bg_view.layer.borderColor = HEXCOLOR(0xfa6d6a).CGColor;
    
    //定位icon
    UIImageView * icon_locationView = [[UIImageView alloc]initWithFrame:CGRectMake(5, 5, 18, 20) ];    icon_locationView.image =  [UIImage imageNamed:@"location_find2"];
    UIButton * location_btn  = [UIButton buttonWithType:UIButtonTypeCustom];//定位按钮
    location_btn.frame = CGRectMake(25, 0, 100, 30);
    [location_btn addTarget:self action:@selector(pushToLocationView:) forControlEvents:UIControlEventTouchUpInside];
    
    [location_btn setTitle:@"龙湖水晶国际 >" forState:UIControlStateNormal];
    [location_btn setTitleColor: HEXCOLOR(0xfa6d6a) forState:UIControlStateNormal];
    location_btn.titleLabel.font = [UIFont systemFontOfSize:12];
    location_btn.titleLabel.textAlignment = NSTextAlignmentLeft;
    
    
    [bg_view addSubview:location_btn];
    [bg_view addSubview: icon_locationView ];
    self.home_tableView.tableHeaderView = loc_view;
}

/**
 定位

 @param sender 跳转到定位
 */
-(void)pushToLocationView:(UIButton *)sender
{
    HP_LocationViewController * locationVC =[[ HP_LocationViewController alloc]init];
    [self.navigationController pushViewController: locationVC animated:YES];

}
/**
 初始化home_tableView
 */
-(void)initWithHome_Tableview
{

    self.home_tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, KScreenW, KScreenH -48-64-44) style:UITableViewStylePlain];
    self.home_tableView.delegate = self;
    self.home_tableView.dataSource = self;
    [self.view addSubview:_home_tableView];

    [self.home_tableView registerNib:[UINib nibWithNibName:@"FindStoreCell" bundle:nil] forCellReuseIdentifier:@"FindStoreCell"];

}

#pragma mark - datasoruce  代理实现
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

    return 5;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{

    return 35;
}
-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = nil;
    if (section == 0) {
        view = [[UIView alloc] initWithFrame:CGRectMake(30, 0,KScreenW, 35)];
        UILabel *labelTitle = [[UILabel alloc] initWithFrame:CGRectMake(35, 0, 100, 35)];
        view.backgroundColor = HEXCOLOR(0xffffff);
        labelTitle.textAlignment = NSTextAlignmentLeft;
        labelTitle.text = @"附近门店";
        labelTitle.textColor = HEXCOLOR(0x363636);
        labelTitle.font =[ UIFont systemFontOfSize:12];
        [view addSubview:labelTitle];

        UIButton * more_btn = [UIButton buttonWithType:UIButtonTypeSystem];
        [more_btn addTarget:self action:@selector(more_btnAction:) forControlEvents:UIControlEventTouchUpInside];
        more_btn.frame =CGRectMake( KScreenW - 65 , 0, 50, 35);
        [more_btn setTitle:@"更多" forState:UIControlStateNormal];
        more_btn.titleLabel.font = [UIFont systemFontOfSize:12];
        [more_btn setTitleColor: HEXCOLOR(0xfa6d6a) forState:UIControlStateNormal];
        [view addSubview:more_btn];
        
        UIImageView * icon_locationView = [[UIImageView alloc]init ];//定位icon
        icon_locationView.frame =CGRectMake(5, 0, 30, 35);
        icon_locationView.image = [UIImage imageNamed:@"location_find"];

        [view addSubview:icon_locationView];
    }

    return view;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 145;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"FindStoreCell";
    FindStoreCell *storeCell = [self.home_tableView  dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];

    return storeCell;

}
#pragma tableViewDataSource
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    DetailStoreViewController * vc = [[DetailStoreViewController alloc]init];
    
    [self.navigationController pushViewController:vc animated:YES];
}

/**
  更多门店

 @param sender  跳转到更多门店
 */
-(void)more_btnAction:(UIButton*)sender
{
    NSLog(@"更多门店");
    
    ZFAllStoreViewController * allVC =[[ ZFAllStoreViewController alloc]init];
    [self.navigationController pushViewController:allVC animated:YES];
}
/**定位 */
-(void)initWithLocation
{
    
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
