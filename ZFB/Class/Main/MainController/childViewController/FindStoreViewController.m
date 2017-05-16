

//
//  FindStoreViewController.m
//  ZFB
//
//  Created by  展富宝  on 2017/5/15.
//  Copyright © 2017年 com.zfb. All rights reserved.
//

#import "FindStoreViewController.h"
#import "FindStoreCell.h"


@interface FindStoreViewController ()<UITableViewDataSource,UITableViewDelegate>
@property(strong,nonatomic )UITableView * home_tableView;


@end

@implementation FindStoreViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
        [self initWithHome_Tableview];
 
        [self initInTerfaceView];
}

-(void)initInTerfaceView{
    UIView * loc_view =[[ UIView alloc]initWithFrame:CGRectMake(0, 0, KScreenW, 39)];//背景图
    UIImageView * icon_locationView = [[UIImageView alloc]init ];//定位icon
    icon_locationView.frame =CGRectMake(5, 5, 20, 30);
    UIButton * location_btn  =[ UIButton buttonWithType:UIButtonTypeCustom];//定位按钮
    [location_btn setTitle:@"龙湖水晶国际" forState:UIControlStateNormal];
    location_btn.frame = CGRectMake(30, 10, KScreenW, 30);
    
    loc_view.backgroundColor = randomColor;
    icon_locationView.backgroundColor = [UIColor greenColor];
    location_btn.backgroundColor = randomColor;
    
    [loc_view addSubview:location_btn];
    [loc_view addSubview: icon_locationView ];
    
    self.home_tableView.tableHeaderView = loc_view;
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
        view = [[UIView alloc] initWithFrame:CGRectMake(30, 0, self.view.frame.size.width, 35)];
        [view setBackgroundColor:[UIColor orangeColor]];

        UILabel *labelTitle = [[UILabel alloc] initWithFrame:CGRectMake(50.0f, 10.0f, 200.0f, 30.0f)];
        [labelTitle setBackgroundColor:[UIColor clearColor]];
        labelTitle.textAlignment = NSTextAlignmentCenter;
        labelTitle.text = @"附近门店";
        [view addSubview:labelTitle];


        UIImageView * icon_locationView = [[UIImageView alloc]init ];//定位icon
        icon_locationView.frame =CGRectMake(5, 5, 20, 30);
        icon_locationView.backgroundColor = [UIColor greenColor];

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
