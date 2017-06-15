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

#import "ZFAppySalesReturnViewController.h"
#import "ZFSendSerViceViewController.h"
#import "LoginViewController.h"
#import "ZFAllOrderViewController.h"

#import "ZFHistoryViewController.h"
#import "ZFCollectViewController.h"
#import "ZFSettingViewController.h"
#import "ZFSettingHeadViewController.h"
#import "ZFPersonalHeaderView.h"
#import "ZFFeedbackViewController.h"

typedef NS_ENUM(NSUInteger, TypeCell) {
    TypeCellOfMyCashBagCell,
    TypeCellOfMyProgressCell,
    TypeCellOfMyOderCell,
    
    
};
@interface ZFPersonalViewController ()<UITableViewDelegate,UITableViewDataSource,ZFMyProgressCellDelegate,PersonalHeaderViewDelegate>
{
    NSString * _foolnum ;//足记数量
    NSString * _collectNum ;//收藏数量
}
@property(nonatomic,strong)UITableView * myTableView;
@property(nonatomic,strong)UIView * myHeaderView;
@property(nonatomic,strong)ZFPersonalHeaderView * headview;

@end

@implementation ZFPersonalViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor =  randomColor;

    [self initmyTableViewInterface];
 
 

    //判断是否已经登录
    if ( [BBUserDefault.userStatus isEqualToString:@"1" ]) {
        UIView * logView = [self.headview viewWithTag:912];//登录后的图
        [logView removeFromSuperview];
   
    }
    else if ( [BBUserDefault.userStatus isEqualToString:@"0" ]) {
         //移除登录视图
        UIView * unlogView = [self.headview viewWithTag:911];//没登录之前的图
        [unlogView removeFromSuperview];
       
    }
   
}

#pragma mark - 注册
-(void)didClickRegisterAction:(UIButton *)sender
{
    NSLog(@"注册了");

}
#pragma mark - 登录
-(void)didClickLoginAction:(UIButton *)sender
{
    NSLog(@"登录了");
}
-(void)initmyTableViewInterface
{
    self.title = @"我的";
    self.myTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, KScreenW, KScreenH) style:UITableViewStylePlain];
    self.myTableView.delegate = self;
    self.myTableView.dataSource = self;
    self.myTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_myTableView];
    
    
    self.headview =  [[NSBundle mainBundle]loadNibNamed:@"ZFPersonalHeaderView" owner:self options:nil].lastObject;
    self.myTableView.tableHeaderView =self.headview;
    self.headview.delegate = self;


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
    
    ZFSettingViewController * settingVC = [[ZFSettingViewController alloc]init];
    [self.navigationController pushViewController:settingVC animated:YES];
    
    
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
        
        return 111;
        
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
        cashCell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        return cashCell;
        
    }
    
    else if (indexPath.row == 1) {
        ZFMyProgressCell * pressCell = [self.myTableView dequeueReusableCellWithIdentifier:@"ZFMyProgressCell" forIndexPath:indexPath];
        
        pressCell.delegate = self;
        pressCell.selectionStyle = UITableViewCellSelectionStyleNone;

        return pressCell;
        
    }
    
    else if (indexPath.row == 2) {
        
        ZFMyOderCell * orderCell = [self.myTableView dequeueReusableCellWithIdentifier:@"ZFMyOderCell" forIndexPath:indexPath];
        
        orderCell.order_imgicon.image =[UIImage imageNamed:@"order_icon"];
        orderCell.selectionStyle = UITableViewCellSelectionStyleNone;

        return orderCell;
    }
    else if (indexPath.row ==3) {
      
        ZFMyOderCell * orderCell = [self.myTableView dequeueReusableCellWithIdentifier:@"ZFMyOderCell" forIndexPath:indexPath];
        orderCell.selectionStyle = UITableViewCellSelectionStyleNone;
        orderCell.order_imgicon.image =[UIImage imageNamed:@"switchover_icon"];
        orderCell.order_title.text = @"切换到配送端";
        orderCell.order_hiddenTitle.hidden = YES;
        return orderCell;
    }
    else{
        ZFMyOderCell * orderCell = [self.myTableView dequeueReusableCellWithIdentifier:@"ZFMyOderCell" forIndexPath:indexPath];
        
        orderCell.selectionStyle = UITableViewCellSelectionStyleNone;
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
       
   
        ZFSendSerViceViewController * sendVC  = [[ZFSendSerViceViewController alloc]init];
        [self.navigationController pushViewController:sendVC animated:YES];
       
    }  if (indexPath.row == 4) {//意见反馈
        
       
        ZFFeedbackViewController * feedVC = [[ZFFeedbackViewController alloc]init];
        [self.navigationController pushViewController:feedVC animated:YES];
        
    }
}

/**
 push 退货 页面
 */
-(void)pushToSaleAfterview
{
    NSLog(@" push 退货 页面");
    
    ZFAppySalesReturnViewController * saleVC = [[ZFAppySalesReturnViewController alloc]init];
    [self.navigationController pushViewController:saleVC animated:YES];
}

//商品收藏的点击事件  需要参数的时候再修改
-(void)didClickCollectAction :(UIButton *)sender
{
    NSLog(@"收藏");
    ZFCollectViewController *collecVC=  [[ZFCollectViewController alloc]init];
    
    NSLog(@"%@", BBUserDefault.cmUserId);
    
    [self minePagePOSTRequste];//页面网络请求

//    [self.navigationController pushViewController:collecVC animated:NO];
}

//浏览足记的点击事件
-(void)didClickHistorytAction:(UIButton *)sender
{
 
    NSLog(@"历史");
    ZFHistoryViewController *hisVC=  [[ZFHistoryViewController alloc]init];
    [self.navigationController pushViewController:hisVC animated:NO];
}

//点击头像

-(void)didClickHeadImageViewAction:(UITapGestureRecognizer *)sender
{
 
    NSLog(@"%@ 头像",sender);
    ZFSettingHeadViewController *headVC =  [[ZFSettingHeadViewController alloc]init];
    [self.navigationController pushViewController:headVC animated:NO];
 
}
-(void)viewWillAppear:(BOOL)animated
{
    self.navigationController.navigationBar.hidden  = NO;
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark  - 网络请求 minePagePOSTRequste
-(void)minePagePOSTRequste
{
    NSDictionary * param = @{
                             @"cmUserId":BBUserDefault.cmUserId,
                             @"svcName":@"getUserInfo",
                             };
 
     [PPNetworkHelper POST:ZFB_11SendMessageUrl parameters:param responseCache:^(id responseCache) {
         
     } success:^(id responseObject) {
          ;
         NSLog(@"%@", responseObject);
         NSLog(@"%@", BBUserDefault.cmUserId);

         if ([responseObject [@"resultCode"] isEqualToString:@"0"]) {
             
             NSString  * dataStr= [responseObject[@"data"] base64DecodedString];
             NSDictionary * data = [NSString dictionaryWithJsonString:dataStr];
       
             BBUserDefault.nickName = data[@"userInfo"][@"nickName"];
             BBUserDefault.userKeyMd5 = data[@"userInfo"][@"userKeyMd5"];
             BBUserDefault.userStatus = data[@"userInfo"][@"userStatus"];
             _foolnum = data[@"foolNum"];
             _collectNum = data[@"collectNum"];

             NSLog(@"data = %@", data);
         }
         
 


   
     } failure:^(NSError *error) {
         NSLog(@"%@",error);
         [self.view makeToast:@"网络错误" duration:2 position:@"center"];
     }];
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
