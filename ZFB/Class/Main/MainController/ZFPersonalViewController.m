//
//  ZFPersonalViewController.m
//  ZFB
//
//  Created by  展富宝  on 2017/5/11.
//  Copyright © 2017年 com.zfb. All rights reserved.
//   **** 我的 

#import "ZFPersonalViewController.h"

#import "ZFMyCashBagCell.h"
#import "ZFMyProgressCell.h"
#import "ZFMyOderCell.h"
#import "ZFHeaderView.h"
#import "ZFMainSendViewController.h"
#import "LoginViewController.h"
#import "ZFAllOrderViewController.h"
typedef NS_ENUM(NSUInteger, TypeCell) {
    TypeCellOfMyCashBagCell,
    TypeCellOfMyProgressCell,
    TypeCellOfMyOderCell,

    
};
@interface ZFPersonalViewController ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong)UITableView * myTableView;
@property(nonatomic,strong)UIView * myHeaderView;

@end

@implementation ZFPersonalViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor =  randomColor;
    
    [self initmyTableViewInterface];
}

-(void)initmyTableViewInterface
{
    self.title = @"我的";
    self.myTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, KScreenW, KScreenH) style:UITableViewStylePlain];
    self.myTableView.delegate = self;
    self.myTableView.dataSource = self;
    self.myTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_myTableView];
    
   
    UIView * headerView =  [[NSBundle mainBundle]loadNibNamed:@"ZFHeaderView" owner:self options:nil].lastObject;
    self.myTableView.tableHeaderView =headerView;
    
    [self.myTableView registerNib:[UINib nibWithNibName:@"ZFMyCashBagCell" bundle:nil] forCellReuseIdentifier:@"ZFMyCashBagCell"];
    [self.myTableView registerNib:[UINib nibWithNibName:@"ZFMyProgressCell" bundle:nil] forCellReuseIdentifier:@"ZFMyProgressCell"];
    [self.myTableView registerNib:[UINib nibWithNibName:@"ZFMyOderCell" bundle:nil] forCellReuseIdentifier:@"ZFMyOderCell"];
  
    
    //自定义导航按钮
    UIButton  * right_btn  =[ UIButton buttonWithType:UIButtonTypeCustom];
    right_btn.frame = CGRectMake(0, 0, 30, 30);
    [right_btn setBackgroundImage:[UIImage imageNamed:@"im_massage"] forState:UIControlStateNormal];
    [right_btn addTarget:self action:@selector(im_messageTag:) forControlEvents:UIControlEventTouchUpInside];
    //自定义button必须执行
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:right_btn];
    self.navigationItem.rightBarButtonItem = rightItem;

    UIButton  * left_btn  =[ UIButton buttonWithType:UIButtonTypeCustom];
    left_btn.frame = CGRectMake(0, 0, 30, 30);
    [left_btn setBackgroundImage:[UIImage imageNamed:@"setting"] forState:UIControlStateNormal];
    [left_btn addTarget:self action:@selector(im_SettingTag:) forControlEvents:UIControlEventTouchUpInside];
    //自定义button必须执行
    UIBarButtonItem *left_item = [[UIBarButtonItem alloc] initWithCustomView:left_btn];
    self.navigationItem.leftBarButtonItem = left_item;
    
 
    
 
}


/**
 消息列表

 @param sender 消息列表
 */
-(void)im_messageTag:(UIButton*)sender
{
    NSLog(@"消息列表");
}

/**
 设置

 @param sender  设置列表
 */
-(void)im_SettingTag:(UIButton *)sender{
    NSLog(@"设置");

}

#pragma mark - tableview delegate
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
    if ( indexPath.row ==0) {
        
        return 120;
        
    }
    else if ( indexPath.row == 1 ) {
        
        return 100;
        
    }else{
      
        return 50;
    }
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (indexPath.row == 0 ) {
        ZFMyCashBagCell  * cashCell = [ self.myTableView dequeueReusableCellWithIdentifier:@"ZFMyCashBagCell" forIndexPath:indexPath];

            return cashCell;

        }
    
    else if (indexPath.row == 1) {
        ZFMyProgressCell * pressCell = [self.myTableView dequeueReusableCellWithIdentifier:@"ZFMyProgressCell" forIndexPath:indexPath];

            return pressCell;
            
        }
   
    else if (indexPath.row == 2) {
       
        ZFMyOderCell * orderCell = [self.myTableView dequeueReusableCellWithIdentifier:@"ZFMyOderCell" forIndexPath:indexPath];
        
        orderCell.order_imgicon.image =[UIImage imageNamed:@"order_icon"];
        
        return orderCell;
    }
    else if (indexPath.row ==3) {
        ZFMyOderCell * orderCell = [self.myTableView dequeueReusableCellWithIdentifier:@"ZFMyOderCell" forIndexPath:indexPath];
        
        orderCell.order_imgicon.image =[UIImage imageNamed:@"switchover_icon"];
        orderCell.order_title.text = @"切换到配送端";
        orderCell.order_hiddenTitle.hidden = YES;
        return orderCell;
    }
    else{
        ZFMyOderCell * orderCell = [self.myTableView dequeueReusableCellWithIdentifier:@"ZFMyOderCell" forIndexPath:indexPath];
        
        orderCell.order_imgicon.image =[UIImage imageNamed:@"write"];
        orderCell.order_title.text = @"意见反馈";
        orderCell.order_hiddenTitle.hidden = YES;
        return orderCell;

    }
  
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"section = %ld , row = %ld",indexPath.section,indexPath.row);
    
    if (indexPath.row == 2) {//全部订单
        
        ZFAllOrderViewController *orderVC =[[ZFAllOrderViewController alloc]init];
        [self.navigationController pushViewController:orderVC animated:YES];

    }
    if (indexPath.row == 3) {//切换到配送端
        
        ZFMainSendViewController * MainVC  = [[ZFMainSendViewController alloc]init];
        [self.navigationController pushViewController:MainVC animated:YES];
        
    }  if (indexPath.row == 4) {//意见反馈
        
        LoginViewController * logvc = [[LoginViewController alloc]init];
        
        [self.navigationController pushViewController:logvc animated:YES];
        
    }
}

-(void)viewWillAppear:(BOOL)animated
{
    self.navigationController.navigationBar.hidden  = NO;

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
