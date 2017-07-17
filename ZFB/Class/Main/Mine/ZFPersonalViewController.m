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
#import "RegisterViewController.h"
#import "ZFAllOrderViewController.h"

#import "ZFHistoryViewController.h"
#import "ZFCollectViewController.h"
#import "ZFSettingViewController.h"
#import "ZFSettingHeadViewController.h"
#import "ZFPersonalHeaderView.h"
#import "ZFFeedbackViewController.h"

#import "ZFPersonalHeaderView.h"
#import "BaseNavigationController.h"
#import "AppDelegate.h"
typedef NS_ENUM(NSUInteger, TypeCell) {
    
    TypeCellOfMyCashBagCell,
    TypeCellOfMyProgressCell,
    TypeCellOfMyOderCell,
};
@interface ZFPersonalViewController ()<UITableViewDelegate,UITableViewDataSource,ZFMyProgressCellDelegate,PersonalHeaderViewDelegate>

@property (nonatomic,strong) UITableView          * myTableView;
@property (nonatomic,strong) ZFPersonalHeaderView * headview;

@property (nonatomic,copy) NSString * foolnum    ;//足记数量
@property (nonatomic,copy) NSString * collectNum ;//收藏数量
@property (nonatomic,copy) NSString * nickName   ;//用户

@end

@implementation ZFPersonalViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"我的";
    
    [self.view addSubview:self.myTableView];
    
    [self.myTableView registerNib:[UINib nibWithNibName:@"ZFMyCashBagCell" bundle:nil] forCellReuseIdentifier:@"ZFMyCashBagCell"];
    [self.myTableView registerNib:[UINib nibWithNibName:@"ZFMyProgressCell" bundle:nil] forCellReuseIdentifier:@"ZFMyProgressCell"];
    [self.myTableView registerNib:[UINib nibWithNibName:@"ZFMyOderCell" bundle:nil] forCellReuseIdentifier:@"ZFMyOderCell"];
    
    self.headview                    = [[NSBundle mainBundle]loadNibNamed:@"ZFPersonalHeaderView" owner:self options:nil].lastObject;
    self.myTableView.tableHeaderView = self.headview;
    self.headview.delegate           = self;
    self.headview.unloginView        = [self.headview viewWithTag:911];//没登录之前的图
    self.headview.loginView          = [self.headview viewWithTag:912];//登录后的图

    [self initmyTableViewInterface];
    
}

#pragma mark - 注册
-(void)didClickRegisterAction:(UIButton *)sender
{
    NSLog(@"注册了");
    RegisterViewController * regiVC = [ RegisterViewController new];
    BaseNavigationController * nav  = [[BaseNavigationController alloc]initWithRootViewController:regiVC];
    
    [self presentViewController:nav animated:NO completion:^{
        
        [nav.navigationBar setBarTintColor:HEXCOLOR(0xfe6d6a)];
        [nav.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:HEXCOLOR(0xffffff),NSFontAttributeName:[UIFont systemFontOfSize:15.0]}];
    }];
    //    [self.navigationController pushViewController:regiVC animated:YES];
}
#pragma mark - 登录
-(void)didClickLoginAction:(UIButton *)sender
{
    NSLog(@"登录了");
    LoginViewController * logvc    = [ LoginViewController new];
    BaseNavigationController * nav = [[BaseNavigationController alloc]initWithRootViewController:logvc];
    
    [self presentViewController:nav animated:NO completion:^{
        
        [nav.navigationBar setBarTintColor:HEXCOLOR(0xfe6d6a)];
        [nav.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:HEXCOLOR(0xffffff),NSFontAttributeName:[UIFont systemFontOfSize:15.0]}];
    }];
    
    //    [self.navigationController pushViewController:logvc animated:YES];
}
-(UITableView *)myTableView
{
    if (!_myTableView) {
        _myTableView                = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, KScreenW, KScreenH) style:UITableViewStylePlain];
        _myTableView.delegate       = self;
        _myTableView.dataSource     = self;
        _myTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return _myTableView;
}

-(void)initmyTableViewInterface
{
    
 
    //自定义导航按钮
    UIButton  * right_btn  =[ UIButton buttonWithType:UIButtonTypeCustom];
    right_btn.frame = CGRectMake(0, 0, 30, 30);
    [right_btn setBackgroundImage:[UIImage imageNamed:@"im_massage"] forState:UIControlStateNormal];
    [right_btn addTarget:self action:@selector(im_messageTag:) forControlEvents:UIControlEventTouchUpInside];
    //自定义button必须执行
    UIBarButtonItem *rightItem             = [[UIBarButtonItem alloc] initWithCustomView:right_btn];
    self.navigationItem.rightBarButtonItem = rightItem;
    
    UIButton  * left_btn  =[ UIButton buttonWithType:UIButtonTypeCustom];
    left_btn.frame = CGRectMake(0, 0, 30, 30);
    [left_btn setBackgroundImage:[UIImage imageNamed:@"setting"] forState:UIControlStateNormal];
    [left_btn addTarget:self action:@selector(im_SettingTag:) forControlEvents:UIControlEventTouchUpInside];
    //自定义button必须执行
    UIBarButtonItem *left_item            = [[UIBarButtonItem alloc] initWithCustomView:left_btn];
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
        cashCell.selectionStyle     = UITableViewCellSelectionStyleNone;
        
        return cashCell;
        
    }
    
    else if (indexPath.row == 1) {
        ZFMyProgressCell * pressCell = [self.myTableView dequeueReusableCellWithIdentifier:@"ZFMyProgressCell" forIndexPath:indexPath];
        
        pressCell.delegate       = self;
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
        
        ZFMyOderCell * orderCell           = [self.myTableView dequeueReusableCellWithIdentifier:@"ZFMyOderCell" forIndexPath:indexPath];
        orderCell.selectionStyle           = UITableViewCellSelectionStyleNone;
        orderCell.order_imgicon.image =[UIImage imageNamed:@"switchover_icon"];
        orderCell.order_title.text         = @"切换到配送端";
        orderCell.order_hiddenTitle.hidden = YES;
        return orderCell;
    }
    else{
        ZFMyOderCell * orderCell = [self.myTableView dequeueReusableCellWithIdentifier:@"ZFMyOderCell" forIndexPath:indexPath];
        
        orderCell.selectionStyle           = UITableViewCellSelectionStyleNone;
        orderCell.order_imgicon.image =[UIImage imageNamed:@"write"];
        orderCell.order_title.text         = @"意见反馈";
        orderCell.order_hiddenTitle.hidden = YES;
        return orderCell;
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"section = %ld , row = %ld",indexPath.section,indexPath.row);
    
    if (indexPath.row == 2) {//全部订单
        
        ZFAllOrderViewController *orderVC =[[ZFAllOrderViewController alloc]init];
        orderVC.buttonTitle =@"全部订单";
        orderVC.orderStatus = @"";//默认状态
        [self.navigationController pushViewController:orderVC animated:YES];
        
    }
    if (indexPath.row == 3) {//切换到配送端
        
        
        ZFSendSerViceViewController * sendVC = [[ZFSendSerViceViewController alloc]init];
        [self.navigationController pushViewController:sendVC animated:YES];
        
    }  if (indexPath.row == 4) {//意见反馈
        
        
        ZFFeedbackViewController * feedVC = [[ZFFeedbackViewController alloc]init];
        [self.navigationController pushViewController:feedVC animated:YES];
        
    }
}

#pragma mark - 待付款didClickWaitForPayAction
///待付款
-(void)didClickWaitForPayAction:(UIButton *)button
{
    
    ZFAllOrderViewController *orderVC =[[ZFAllOrderViewController alloc]init];
    orderVC.orderType   = 1 ;
    orderVC.orderStatus =@"4";
    orderVC.buttonTitle = @"待付款";
    [self.navigationController pushViewController:orderVC animated:YES];
}
#pragma mark - 已配送didClickSendedAction
///已配送
-(void)didClickSendedAction:(UIButton *)button
{
    ZFAllOrderViewController *orderVC =[[ZFAllOrderViewController alloc]init];
    orderVC.orderType   = 4 ;
    orderVC.orderStatus =@"2";
    orderVC.buttonTitle = @"已配送";
    [self.navigationController pushViewController:orderVC animated:YES];
}
#pragma mark - 待评价didClickWaitForEvaluateAction
///待评价
-(void)didClickWaitForEvaluateAction:(UIButton *)button
{
    ZFAllOrderViewController *orderVC =[[ZFAllOrderViewController alloc]init];
    orderVC.orderType   = 5 ;
    orderVC.buttonTitle = @"待评价";
    [self.navigationController pushViewController:orderVC animated:YES];
    
}
#pragma mark - 退货didClickBacKgoodsAction
///退货
-(void)didClickBacKgoodsAction:(UIButton *)button
{
    NSLog(@" push 退货 页面");
    
    ZFAppySalesReturnViewController * saleVC = [[ZFAppySalesReturnViewController alloc]init];
    [self.navigationController pushViewController:saleVC animated:YES];
    
}

#pragma mark - 收藏
//商品收藏的点击事件  需要参数的时候再修改
-(void)didClickCollectAction :(UIButton *)sender
{
    NSLog(@"收藏");
    if (BBUserDefault.isLogin == 1) {
        
        ZFCollectViewController *collecVC = [[ZFCollectViewController alloc]init];
        
        NSLog(@" cmUserId  === %@", BBUserDefault.cmUserId);
        [self.navigationController pushViewController:collecVC animated:NO];
 
    }else{
        
        LoginViewController * logvc    = [ LoginViewController new];
        BaseNavigationController * nav = [[BaseNavigationController alloc]initWithRootViewController:logvc];
        [self presentViewController:nav animated:NO completion:^{
            
            [nav.navigationBar setBarTintColor:HEXCOLOR(0xfe6d6a)];
            [nav.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:HEXCOLOR(0xffffff),NSFontAttributeName:[UIFont systemFontOfSize:15.0]}];
        }];
        

    }
    
}

//浏览足记的点击事件
-(void)didClickHistorytAction:(UIButton *)sender
{
    
    if (BBUserDefault.isLogin == 1) {
        
        NSLog(@"历史");
        ZFHistoryViewController *hisVC = [[ZFHistoryViewController alloc]init];
        [self.navigationController pushViewController:hisVC animated:NO];
        
    }else{
        
        LoginViewController * logvc    = [ LoginViewController new];
        BaseNavigationController * nav = [[BaseNavigationController alloc]initWithRootViewController:logvc];
        [self presentViewController:nav animated:NO completion:^{
            
            [nav.navigationBar setBarTintColor:HEXCOLOR(0xfe6d6a)];
            [nav.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:HEXCOLOR(0xffffff),NSFontAttributeName:[UIFont systemFontOfSize:15.0]}];
        }];
    
    }
}

//点击头像
-(void)didClickHeadImageViewAction:(UITapGestureRecognizer *)sender
{
    
    NSLog(@"点击了头像");
    ZFSettingHeadViewController *headVC = [[ZFSettingHeadViewController alloc]init];
    [self.navigationController pushViewController:headVC animated:NO];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark  - 网络请求 getUserInfo
-(void)minePagePOSTRequste
{
    if (BBUserDefault.cmUserId == nil) {
        BBUserDefault.cmUserId = @"";
    }
    NSDictionary * parma = @{
                             
                             @"cmUserId":BBUserDefault.cmUserId,
                              };
    
    [MENetWorkManager post:[zfb_baseUrl stringByAppendingString:@"/getUserInfo"] params:parma success:^(id response) {
        
        NSLog(@"%@",response);
        int resultCode = [response [@"resultCode"] intValue];
        
        if (resultCode == 0) {
            
            _nickName   = [NSString stringWithFormat:@"%@",response[@"nickName"] ];
            _foolnum    = [NSString stringWithFormat:@"%@",response[@"foolNum"] ];
            _collectNum = [NSString stringWithFormat:@"%@",response[@"collectNum"]];
            
            //赋值
            self.headview.lb_collectCount.text = _collectNum;
            self.headview.lb_historyCount.text = _foolnum;
            self.headview.lb_userNickname.text = _nickName;
            
        }
        [self.myTableView reloadData];
        
    } progress:^(NSProgress *progeress) {
    } failure:^(NSError *error) {
        
        NSLog(@"error=====%@",error);
        [self.view makeToast:@"网络错误" duration:2 position:@"center"];
    }];
    
}
-(void)viewWillAppear:(BOOL)animated
{
    //    AppDelegate *appdelegate = (AppDelegate*)[[UIApplication sharedApplication]delegate];
    
    if (BBUserDefault.isLogin == 1) {
        [self minePagePOSTRequste];//页面网络请求
        //判断是否已经登录
        
        //移除登录视图
        _headview.loginView.hidden   = NO;
        _headview.unloginView.hidden = YES;
    }
    else{
        _headview.loginView.hidden   = YES;
        _headview.unloginView.hidden = NO;
    }
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
