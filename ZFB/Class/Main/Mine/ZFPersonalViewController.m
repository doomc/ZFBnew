//
//  ZFPersonalViewController.m
//  ZFB
//
//  Created by  展富宝  on 2017/5/11.
//  Copyright © 2017年 com.zfb. All rights reserved.
//   **** 我的

#import "ZFPersonalViewController.h"
//cell
#import "ZFMyCashBagCell.h"
#import "ZFMyProgressCell.h"
#import "ZFMyOderCell.h"

//配送端VC
#import "ZFSendSerViceViewController.h"//配送
#import "ZFHistoryViewController.h"//足记
#import "ZFCollectViewController.h"//收藏

//商户端VC
#import "BusinessServicerViewController.h"

//view
#import "ZFPersonalHeaderView.h"
#import "ZFPersonalHeaderView.h"

//用户端VC
#import "LoginViewController.h"
#import "RegisterViewController.h"

#import "ZFAllOrderViewController.h"//全部订单
#import "ZFSettingViewController.h"//个人设置
#import "ZFSettingHeadViewController.h"//设置个人信息
#import "ZFFeedbackViewController.h"//意见反馈
#import "MineWalletViewController.h"//钱包
#import "ZFShoppingCarViewController.h"//购物车
//base
#import "ZFBaseNavigationViewController.h"


typedef NS_ENUM(NSUInteger, TypeCell) {
    
    TypeCellOfMyCashBagCell,
    TypeCellOfMyProgressCell,
    TypeCellOfMyOderCell,
};
@interface ZFPersonalViewController ()<UITableViewDelegate,UITableViewDataSource,ZFMyProgressCellDelegate,PersonalHeaderViewDelegate,
ZFMyCashBagCellDelegate


>

@property (nonatomic,strong) UITableView          * myTableView;
@property (nonatomic,strong) ZFPersonalHeaderView * headview;

@property (nonatomic,copy) NSString * foolnum    ;//足记数量
@property (nonatomic,copy) NSString * collectNum ;//收藏数量

@property (nonatomic,copy) NSString * shopFlag   ;//判断是否是商家 1/0
@property (nonatomic,copy) NSString * courierFlag   ;//判断是否是快递员 1/0
@property (nonatomic,copy) NSString * storeId   ;
@property (nonatomic,copy) NSString * balance   ;//余额
@property (nonatomic,copy) NSString * userImgAttachUrl  ;//头像URL




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
    ZFBaseNavigationViewController * nav  = [[ZFBaseNavigationViewController alloc]initWithRootViewController:regiVC];
    
    [self presentViewController:nav animated:NO completion:^{
        regiVC.mark = YES;
        [nav.navigationBar setBarTintColor:HEXCOLOR(0xfe6d6a)];
        [nav.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:HEXCOLOR(0xffffff),NSFontAttributeName:[UIFont systemFontOfSize:15.0]}];
    }];
    //    [self.navigationController pushViewController:regiVC animated:YES];
}
#pragma mark - 登录
-(void)didClickLoginAction:(UIButton *)sender
{
    NSLog(@"登录了");
    [self isloginSuccess];
}
-(UITableView *)myTableView
{
    if (!_myTableView) {
        _myTableView                = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, KScreenW, KScreenH -64 - 49) style:UITableViewStylePlain];
        _myTableView.delegate       = self;
        _myTableView.dataSource     = self;
        _myTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return _myTableView;
}

-(void)initmyTableViewInterface
{
    
    UIButton  * left_btn  =[ UIButton buttonWithType:UIButtonTypeCustom];
    left_btn.frame = CGRectMake(0, 0, 30, 30);
    [left_btn setBackgroundImage:[UIImage imageNamed:@"setting"] forState:UIControlStateNormal];
    [left_btn addTarget:self action:@selector(im_SettingTag:) forControlEvents:UIControlEventTouchUpInside];
    //自定义button必须执行
    UIBarButtonItem *left_item            = [[UIBarButtonItem alloc] initWithCustomView:left_btn];
    self.navigationItem.leftBarButtonItem = left_item;
    
}



/**
 设置
 
 @param sender  设置列表
 */
-(void)im_SettingTag:(UIButton *)sender{
    NSLog(@"设置");
    if (BBUserDefault.isLogin == 1) {
        
        ZFSettingViewController * settingVC = [[ZFSettingViewController alloc]init];
        settingVC.userImgAttachUrl = _userImgAttachUrl;
        [self.navigationController pushViewController:settingVC animated:YES];
        
    }else{
        
        [self isloginSuccess];
    }
    
    
}

#pragma mark - tableview delegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
    
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 6;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat height = 0;
    switch (indexPath.row) {
        case 0:
            height = 112;
            
            break;
        case 1:
            height =  100;
            
            break;
            
        case 2:
            height = 50;
            
            break;
            
        case 3:
            height = 50;
            
            break;
            
        case 4:
            if (([_courierFlag isEqualToString:@"0"] && [_shopFlag isEqualToString:@"0"]) || _courierFlag == nil ||  _shopFlag == nil ) {
                
                height = 0;
            }else{
                height = 50;
            }
            break;
            
        case 5:
            height = 50;
            
            break;

    }
    return height;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
     switch (indexPath.row) {
        case 0:
        {
            ZFMyCashBagCell  * cashCell = [ self.myTableView dequeueReusableCellWithIdentifier:@"ZFMyCashBagCell" forIndexPath:indexPath];
            cashCell.lb_balance.text = _balance;
            return cashCell;
        }
            break;
        case 1:
        {
            ZFMyProgressCell * pressCell = [self.myTableView dequeueReusableCellWithIdentifier:@"ZFMyProgressCell" forIndexPath:indexPath];
            pressCell.delegate    = self;
            return pressCell;
        }
            break;
            
        case 2:
        {
            ZFMyOderCell * orderCell = [self.myTableView dequeueReusableCellWithIdentifier:@"ZFMyOderCell" forIndexPath:indexPath];
            
            orderCell.order_imgicon.image =[UIImage imageNamed:@"order_icon"];
            orderCell.order_title.text = @"全部订单";
            
            return orderCell;
        }
            break;
            
        case 3:
        {
            ZFMyOderCell * orderCell = [self.myTableView dequeueReusableCellWithIdentifier:@"ZFMyOderCell" forIndexPath:indexPath];
            
            orderCell.order_imgicon.image =[UIImage imageNamed:@"settingShopCar"];
            orderCell.order_title.text = @"购物车";
            orderCell.order_hiddenTitle.text = @"";
            return orderCell;

        }
            break;
            
        case 4:
        {
            ZFMyOderCell * orderCell = [self.myTableView dequeueReusableCellWithIdentifier:@"ZFMyOderCell" forIndexPath:indexPath];
            
            orderCell.order_imgicon.image =[UIImage imageNamed:@"switchover_icon"];
            orderCell.order_hiddenTitle.hidden = YES;
            
            if (([_courierFlag isEqualToString:@"0"] && [_shopFlag isEqualToString:@"0"]) || _courierFlag == nil ||  _shopFlag == nil ) {
                
                NSLog(@"我是普通用户");
                [orderCell setHidden:YES];
            }else{
                
                [orderCell setHidden:NO];
                if ([_shopFlag isEqualToString:@"1"]) {//shopFlag = 1 商户端 0隐藏
                    orderCell.order_title.text         = @"切换到商户端";
                    
                }
                if ([_courierFlag isEqualToString:@"1"]) {//配送端
                    orderCell.order_title.text         = @"切换到配送端";
                    
                }
            }
            return orderCell;
            
        }
            break;
            
        case 5:
        {
            ZFMyOderCell * orderCell = [self.myTableView dequeueReusableCellWithIdentifier:@"ZFMyOderCell" forIndexPath:indexPath];
            
            orderCell.order_imgicon.image =[UIImage imageNamed:@"write"];
            orderCell.order_title.text         = @"意见反馈";
            orderCell.order_hiddenTitle.hidden = YES;
            return orderCell;
        }
            break;
            
    }
    ZFMyOderCell * cell = [self.myTableView dequeueReusableCellWithIdentifier:@"ZFMyOderCell" forIndexPath:indexPath];
    cell.order_title.text         = @"切换到配送端";
    return cell;

}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"section = %ld , row = %ld",indexPath.section,indexPath.row);
    switch (indexPath.row) {
        case 0:
            
            break;
        case 1:
            
            break;
        case 2:             //全部订单
        {
            ZFAllOrderViewController *orderVC =[[ZFAllOrderViewController alloc]init];
            orderVC.buttonTitle =@"全部订单";
            orderVC.orderStatus = @"";//默认状态
            [self.navigationController pushViewController:orderVC animated:NO];
            
        }
            break;
        case 3:            //购物车
        {
            
            ZFShoppingCarViewController * shopcarVC =[[ZFShoppingCarViewController alloc]init];
            [self.navigationController pushViewController:shopcarVC animated:NO];
            
        }
            break;
        case 4:             //切换到配送端
        {
 
            if ([_shopFlag isEqualToString:@"1"]) {//shopFlag = 1 商户端 0隐藏
                
                //商户端
                BusinessServicerViewController * businessVC = [[BusinessServicerViewController alloc]init];
                businessVC.storeId = _storeId;
                [self.navigationController pushViewController:businessVC animated:NO];
                
            }
            if ([_courierFlag isEqualToString:@"1"]) {//配送员 = 1  0隐藏
                // 配送端
                ZFSendSerViceViewController * sendVC = [[ZFSendSerViceViewController alloc]init];
                [self.navigationController pushViewController:sendVC animated:NO];
            }
            
        }
            break;
        case 5: {//意见反馈
            
            ZFFeedbackViewController * feedVC = [[ZFFeedbackViewController alloc]init];
            [self.navigationController pushViewController:feedVC animated:NO];
            
        }
            
            break;
        default:
            break;
    }
    
    
}
#pragma mark - 待付款didClickWaitForPayAction
///待付款
-(void)didClickWaitForPayAction:(UIButton *)button
{
    if (BBUserDefault.isLogin == 1) {
        ZFAllOrderViewController *orderVC =[[ZFAllOrderViewController alloc]init];
        
        [orderVC sendTitle:@"待付款" orderType:OrderTypeWaitPay];
        orderVC.orderType   = 1 ;
        orderVC.orderStatus =@"4";
        orderVC.buttonTitle = @"待付款";
        
        [self.navigationController pushViewController:orderVC animated:YES];
    }else{
        [self isloginSuccess];
        
    }
    
}
#pragma mark - 已配送didClickSendedAction
///已配送
-(void)didClickSendedAction:(UIButton *)button
{
    if (BBUserDefault.isLogin == 1) {
        ZFAllOrderViewController *orderVC =[[ZFAllOrderViewController alloc]init];
        orderVC.orderType   = 4 ;
        orderVC.orderStatus = @"2";
        orderVC.buttonTitle = @"已配送";
        [self.navigationController pushViewController:orderVC animated:YES];
    }else{
        [self isloginSuccess];
        
    }
    
}
#pragma mark - 待评价didClickWaitForEvaluateAction
///待评价
-(void)didClickWaitForEvaluateAction:(UIButton *)button
{
    if (BBUserDefault.isLogin == 1) {
        
        ZFAllOrderViewController *orderVC =[[ZFAllOrderViewController alloc]init];
        orderVC.orderType   = 5 ;
        orderVC.orderStatus = @"3";
        orderVC.buttonTitle = @"交易完成";
        [self.navigationController pushViewController:orderVC animated:YES];
        
        
    }else{
        [self isloginSuccess];
        
    }
    
}
#pragma mark - 退货didClickBacKgoodsAction
///退货
-(void)didClickBacKgoodsAction:(UIButton *)button
{
    NSLog(@" push 退货 页面");
    if (BBUserDefault.isLogin == 1) {
        
        ZFAllOrderViewController *orderVC =[[ZFAllOrderViewController alloc]init];
        orderVC.orderType   = 7 ;
        orderVC.orderStatus = @"2";
        orderVC.buttonTitle = @"售后申请";
        [self.navigationController pushViewController:orderVC animated:YES];
        
        
    }else{
        [self isloginSuccess];
        
    }
    
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
        
        [self isloginSuccess];
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
        
        [self isloginSuccess];
    }
}

//点击头像
-(void)didClickHeadImageViewAction:(UITapGestureRecognizer *)sender
{
    
    NSLog(@"点击了头像");
    ZFSettingHeadViewController *headVC = [[ZFSettingHeadViewController alloc]init];
    headVC.userImgAttachUrl = _userImgAttachUrl;
    [self.navigationController pushViewController:headVC animated:NO];
    
}


#pragma  mark - ZFMyCashBagCellDelegate - 钱包
///钱包
-(void)didClickCashBag
{
    MineWalletViewController * walletVC = [[MineWalletViewController alloc]init];
    [self.navigationController pushViewController:walletVC animated:NO];
    
}
///余额
-(void)didClickBalanceView
{
    
}
///提成金额
-(void)didClickUnitView
{
    
}
///优惠券
-(void)didClickDiscountCouponView
{
    
}
///富豆
-(void)didClickFuBeanView
{
    
}


#pragma mark  - 网络请求 getUserInfo
-(void)minePagePOSTRequste
{
    if (BBUserDefault.cmUserId == nil || BBUserDefault.cmUserId == NULL) {
        BBUserDefault.cmUserId = @"";
    }
    NSDictionary * parma = @{
                             @"cmUserId":BBUserDefault.cmUserId,
                             };
    
    [MENetWorkManager post:[zfb_baseUrl stringByAppendingString:@"/getUserInfo"] params:parma success:^(id response) {
        
        if ([response [@"resultCode"] intValue]== 0) {
            
            _foolnum    = [NSString stringWithFormat:@"%@",response[@"foolNum"] ];
            _collectNum = [NSString stringWithFormat:@"%@",response[@"collectNum"]];
            _shopFlag   = [NSString stringWithFormat:@"%@",response[@"userInfo"][@"shopFlag"]];//是否是商户
            _courierFlag= [NSString stringWithFormat:@"%@",response[@"userInfo"][@"courierFlag"]];//是否是快递员
            _storeId    = [NSString stringWithFormat:@"%@",response[@"userInfo"][@"storeId"]];

            
            BBUserDefault.shopFlag = _shopFlag;
            BBUserDefault.courierFlag = _courierFlag;
            
            BBUserDefault.nickName   = [NSString stringWithFormat:@"%@",response[@"userInfo"][@"nickName"]];
            BBUserDefault.sexType    = [response[@"userInfo"][@"sex"] integerValue];
            BBUserDefault.birthDay   = [NSString stringWithFormat:@"%@",response[@"userInfo"][@"cmBirthday"]];
            _userImgAttachUrl = [NSString stringWithFormat:@"%@",response[@"userInfo"][@"userImgAttachUrl"]];
            
            //赋值
            self.headview.lb_collectCount.text = _collectNum;
            self.headview.lb_historyCount.text = _foolnum;
            self.headview.lb_userNickname.text = BBUserDefault.nickName;
            
            [self.headview.img_headview sd_setImageWithURL:[NSURL URLWithString:_userImgAttachUrl] placeholderImage:[UIImage imageNamed:@"avatar_user"]];
        }
        [self.myTableView reloadData];
        
    } progress:^(NSProgress *progeress) {
    } failure:^(NSError *error) {
        
        NSLog(@"error=====%@",error);
        [self.view makeToast:@"网络出差了~" duration:2 position:@"center"];
    }];
    
}

#pragma mark  - 网络请求 查询展易付余额
-(void)getThirdBalancePOSTRequste
{
    NSDictionary * parma = @{
                             @"account":@"18602343931",
                             };
    
    [MENetWorkManager post:[zfb_baseUrl stringByAppendingString:@"/QRCode/getThirdBalance"] params:parma success:^(id response) {
        
        if ([response [@"resultCode"] intValue] == 0) {
            
            _balance = response[@"balance"];
            
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
    if (BBUserDefault.isLogin == 1) {
        
        [self minePagePOSTRequste];//页面网络请求
        [self getThirdBalancePOSTRequste];//余额查询
        
        //移除登录视图
        _headview.loginView.hidden   = NO;
        _headview.unloginView.hidden = YES;
    }
    else{
        _headview.loginView.hidden   = YES;
        _headview.unloginView.hidden = NO;
    }
}

//判断是否登录了
-(void)isloginSuccess
{
    
    LoginViewController * logvc    = [ LoginViewController new];
    ZFBaseNavigationViewController * nav = [[ZFBaseNavigationViewController alloc]initWithRootViewController:logvc];
    [self presentViewController:nav animated:NO completion:^{
        
        [nav.navigationBar setBarTintColor:HEXCOLOR(0xfe6d6a)];
        [nav.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:HEXCOLOR(0xffffff),NSFontAttributeName:[UIFont systemFontOfSize:15.0]}];
    }];
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
//


/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
