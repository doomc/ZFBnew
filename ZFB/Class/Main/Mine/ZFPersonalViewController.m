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
#import "QuickOperationCell.h"//快捷操作

//配送端VC
#import "ZFSendSerViceViewController.h"//配送
#import "ZFHistoryViewController.h"//足记
#import "ZFCollectViewController.h"//收藏

//商户端VC
#import "BusinessServicerViewController.h"

//view
#import "ZFPersonalHeaderView.h"

//用户端VC
#import "RegisterViewController.h"//注册
#import "ZFAllOrderViewController.h"//全部订单
#import "ZFSettingViewController.h"//个人设置
#import "ZFSettingHeadViewController.h"//设置个人信息
#import "ZFFeedbackViewController.h"//意见反馈
#import "MineWalletViewController.h"//钱包
#import "ZFShoppingCarViewController.h"//购物车
#import "CouponViewController.h"//优惠券
#import "MineShareViewController.h"//我的共享
#import "AccountViewController.h"//交易明细
#import "RechargeViewController.h"//提现
#import "BandBackCarViewController.h"//绑卡
#import "PersonalMesViewController.h"//通知消息列表
#import "DetailMsgNoticeViewController.h"//通知消息
#import "iOpenStoreViewController.h"//我要开店
#import "iwantSendedViewController.h"//我要成为配送员
#import "EditCommentViewController.h"//评论
//base
#import "ZFBaseNavigationViewController.h"

typedef NS_ENUM(NSUInteger, TypeCell) {
    
    TypeCellOfMyCashBagCell,
    TypeCellOfMyProgressCell,
    TypeCellOfMyOderCell,
};
@interface ZFPersonalViewController ()
<
    UITableViewDelegate,
    UITableViewDataSource,
    ZFMyProgressCellDelegate,
    PersonalHeaderViewDelegate,
    ZFMyCashBagCellDelegate,
    QuickOperationCellDelegate
>
{
    NSString * _foolnum;//足记数量
    NSString * _collectNum ;//收藏数量
    NSString * _shopFlag   ;//判断是否是商家 1/0
    NSString * _deliveryFlag   ;//判断是否是快递员 审核状态 1.审核通过 2.待审核 3.审核失败 0 没有注册信息
    NSString * _storeId   ;
    NSString * _balance   ;//余额
    NSString * _unsettBalance  ;//不可用余额
    NSString * _deliveryStatus  ;//申请配送员的审核状态
    NSString * _couponNum  ;//优惠券数量
    NSString * _userImgAttachUrl  ;//头像URL
    NSString * _bankNum  ;//银行卡数量

}
@property (nonatomic,strong) UITableView          * myTableView;
@property (nonatomic,strong) ZFPersonalHeaderView * headview;

@end

@implementation ZFPersonalViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setCustomerTitle:@"我的" textColor:[UIColor whiteColor]];

    [self.view addSubview:self.myTableView];
    
    [self.myTableView registerNib:[UINib nibWithNibName:@"ZFMyCashBagCell" bundle:nil] forCellReuseIdentifier:@"ZFMyCashBagCell"];
    [self.myTableView registerNib:[UINib nibWithNibName:@"ZFMyProgressCell" bundle:nil] forCellReuseIdentifier:@"ZFMyProgressCell"];
    [self.myTableView registerNib:[UINib nibWithNibName:@"ZFMyOderCell" bundle:nil] forCellReuseIdentifier:@"ZFMyOderCell"];
    [self.myTableView registerNib:[UINib nibWithNibName:@"QuickOperationCell" bundle:nil] forCellReuseIdentifier:@"QuickOperationCell"];
    self.headview                    = [[NSBundle mainBundle]loadNibNamed:@"ZFPersonalHeaderView" owner:self options:nil].lastObject;
    self.myTableView.tableHeaderView = self.headview;
    self.myTableView.tableFooterView.height = 222;
    self.headview.delegate           = self;
    self.headview.unloginView        = [self.headview viewWithTag:911];//没登录之前的图
    self.headview.loginView          = [self.headview viewWithTag:912];//登录后的图
    
    [self initmyTableViewInterface];
    
}

//设置右边按键（如果没有右边 可以不重写）
-(UIButton*)set_rightButton
{
//    NSString * saveStr = @"消息";
    UIButton *right_button = [[UIButton alloc]init];
    [right_button setImage:[UIImage imageNamed:@"message_white"] forState:UIControlStateNormal];
    right_button.frame =CGRectMake(0, 0, 22, 22);

    return right_button;
}
//设置右边事件
-(void)right_button_event:(UIButton*)sender{

    NSLog(@"消息列表");
    if (BBUserDefault.isLogin == 1) {
        DetailMsgNoticeViewController * messVC = [DetailMsgNoticeViewController new];
        [self.navigationController pushViewController:messVC animated:NO];
    }else{
        [self isloginSuccess];
    }
}
#pragma mark - 注册
-(void)didClickRegisterAction:(UIButton *)sender
{
    NSLog(@"注册了");
    RegisterViewController * regiVC = [ RegisterViewController new];
    ZFBaseNavigationViewController * nav  = [[ZFBaseNavigationViewController alloc]initWithRootViewController:regiVC];
    
    [self presentViewController:nav animated:NO completion:^{
        regiVC.mark = YES;
        [nav.navigationBar setBarTintColor:HEXCOLOR(0xf95a70)];
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
        _myTableView                = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, KScreenW, KScreenH -64 - 49) style:UITableViewStylePlain];
        _myTableView.delegate       = self;
        _myTableView.dataSource     = self;
        _myTableView.backgroundColor = HEXCOLOR(0xf7f7f7);
        _myTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return _myTableView;
}

-(void)initmyTableViewInterface
{
    
    UIButton  * left_btn  =[ UIButton buttonWithType:UIButtonTypeCustom];
    left_btn.frame = CGRectMake(0, 0, 20, 20);
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
    return 2;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 1) {
        return 10;
    }
    return 0.001;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 6;
    }
    return 1;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat height = 0;
    if (indexPath.section == 0) {
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
                
//            case 4:
//#warning -------------------------总觉得这句话有问题-=------------=-
//                if (([_courierFlag isEqualToString:@"0"] && [_shopFlag isEqualToString:@"0"]) || _courierFlag == nil ||  _shopFlag == nil || [_courierFlag isEqualToString:@"-1"] || [_shopFlag isEqualToString:@"-1"])
//                {
//                    height = 0;
//
//                }else{
//                    height = 50;
//                }
//                break;
                
            case 4:
                height = 50;
                
                break;
            case 5:
                height = 50;
                
                break;
        }
   
    }else{
        
        height = 150;
    }
    return height;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        switch (indexPath.row) {
            case 0:
            {
                ZFMyCashBagCell  * cashCell = [ self.myTableView dequeueReusableCellWithIdentifier:@"ZFMyCashBagCell" forIndexPath:indexPath];
                cashCell.delegate = self;
                if (BBUserDefault.isLogin == 1) {
                    
                    cashCell.lb_balance.text = _balance;
                    cashCell.lb_discountCoupon.text = _couponNum;
                    cashCell.lb_fuBean.text = _bankNum;
                    cashCell.lb_unit.text = _unsettBalance;
                    
                }else{
                    cashCell.lb_balance.text = @"0";
                    cashCell.lb_discountCoupon.text = @"0";
                    cashCell.lb_fuBean.text = @"0";
                    cashCell.lb_unit.text = @"0";
                }
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
                
//            case 4:
//            {
//                ZFMyOderCell * orderCell = [self.myTableView dequeueReusableCellWithIdentifier:@"ZFMyOderCell" forIndexPath:indexPath];
//
//                orderCell.order_imgicon.image =[UIImage imageNamed:@"switchover_icon"];
//                orderCell.order_hiddenTitle.hidden = YES;
//
//                if (([_courierFlag isEqualToString:@"0"] && [_shopFlag isEqualToString:@"0"]) || _courierFlag == nil ||  _shopFlag == nil || [_courierFlag isEqualToString:@"-1"] || [_shopFlag isEqualToString:@"-1"]) {
//
//                    NSLog(@"我是普通用户");
//                    [orderCell setHidden:YES];
//
//                }else{
//
//                    [orderCell setHidden:NO];
//                    if ([_shopFlag isEqualToString:@"1"]) {//shopFlag = 1 商户端 0隐藏
//                        orderCell.order_title.text         = @"切换到商户端";
//
//                    }
//                    if ([_courierFlag isEqualToString:@"1"]) {//配送端
//                        orderCell.order_title.text         = @"切换到配送端";
//
//                    }
//                }
//                return orderCell;
//
//            }
//                break;
            case 4://我的共享
            {
                ZFMyOderCell * orderCell = [self.myTableView dequeueReusableCellWithIdentifier:@"ZFMyOderCell" forIndexPath:indexPath];
                
                orderCell.order_imgicon.image = [UIImage imageNamed:@"share_black"];
                orderCell.order_title.text = @"我的共享";
                orderCell.order_hiddenTitle.text = @"";
                return orderCell;
            }
                break;
            case 5://意见反馈
            {
                ZFMyOderCell * orderCell = [self.myTableView dequeueReusableCellWithIdentifier:@"ZFMyOderCell" forIndexPath:indexPath];
                
                orderCell.order_imgicon.image =[UIImage imageNamed:@"write"];
                orderCell.order_title.text         = @"意见反馈";
                orderCell.order_hiddenTitle.hidden = YES;
                return orderCell;
            }
                break;
        }
    }

    QuickOperationCell * quickCell = [self.myTableView dequeueReusableCellWithIdentifier:@"QuickOperationCell" forIndexPath:indexPath];
    if ([_shopFlag isEqualToString:@"1"] || [_deliveryFlag isEqualToString:@"1"] ) {
        quickCell.unCheckView.hidden = YES; //没有审核过的视图隐藏
    }
    if ([_deliveryFlag isEqualToString:@"0"] && [_shopFlag isEqualToString:@"0"]) {
         quickCell.unCheckView.hidden = NO;//显示
    }
    if ([_shopFlag isEqualToString:@"1"]){
        quickCell.lb_changeName.text = @"切换到商户端";
        quickCell.checkedView.hidden = NO;
    }
    if ([_deliveryFlag isEqualToString:@"1"]) {
        quickCell.lb_changeName.text = @"切换到配送端";
        quickCell.checkedView.hidden = NO;
    }
  
    quickCell.delegate = self;
    return quickCell;

}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"section = %ld , row = %ld",indexPath.section,indexPath.row);
    if (indexPath.section == 0) {
        switch (indexPath.row) {
            case 0:
                
                break;
            case 1:
                
                break;
            case 2:            //全部订单
            {
                NSLog(@"已经加载了");
                if (BBUserDefault.isLogin == 1) {
                    ZFAllOrderViewController *orderVC =[[ZFAllOrderViewController alloc]init];
                    orderVC.buttonTitle =@"全部订单";
                    orderVC.orderStatus = @"";//默认状态
                    [self.navigationController pushViewController:orderVC animated:NO];
                }
                else{
                    [self isloginSuccess];
                }
                
                
            }
                break;
            case 3:            //购物车
            {
                if (BBUserDefault.isLogin == 1) {
                    ZFShoppingCarViewController * shopcarVC =[[ZFShoppingCarViewController alloc]init];
                    [self.navigationController pushViewController:shopcarVC animated:NO];
                    
                }
                else{
                    [self isloginSuccess];
                    
                }
                
            }
                break;

            case 4://我的共享
                
            {
                if (BBUserDefault.isLogin == 1) {
                    
                    MineShareViewController * shareVC = [MineShareViewController new];
                    [self.navigationController pushViewController:shareVC animated:NO];
                }else{
                    
                    [self isloginSuccess];
                    
                }
                
            }
                break;
            case 5: {//意见反馈
                if (BBUserDefault.isLogin == 1) {
                    
                    ZFFeedbackViewController * feedVC = [[ZFFeedbackViewController alloc]init];
                    [self.navigationController pushViewController:feedVC animated:NO];
                    
                }else{
                    
                    [self isloginSuccess];
                }
            }
                
                break;
        }
    }
   
    
    
}
#pragma mark - 待付款didClickWaitForPayAction
///待付款
-(void)didClickWaitForPayAction:(UIButton *)button
{
    if (BBUserDefault.isLogin == 1) {
        
        ZFAllOrderViewController *orderVC =[[ZFAllOrderViewController alloc]init];
        [orderVC sendTitle:@"待付款" orderType:OrderTypeWaitPay];
        orderVC.orderType   = 1;
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
        orderVC.orderStatus = @"3";//原来是2  hj改成了3
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

#pragma  mark - 点击头像
-(void)didClickHeadImageViewAction:(UITapGestureRecognizer *)sender
{
    NSLog(@"点击了头像");
    if (BBUserDefault.isLogin == 0) {
        [self isloginSuccess];
        
    }else{
        ZFSettingHeadViewController *headVC = [[ZFSettingHeadViewController alloc]init];
        headVC.userImgAttachUrl = _userImgAttachUrl;
        [self.navigationController pushViewController:headVC animated:NO];
    }
}

#pragma  mark - ZFMyCashBagCellDelegate - 钱包d
///钱包 、查看明细
-(void)didClickCashBag
{
    NSLog(@"点击了明细");
    if (BBUserDefault.isLogin == 1) {
        AccountViewController * accontVC = [[AccountViewController alloc]init];
        [self.navigationController pushViewController:accontVC animated:NO];
    }else{
        [self isloginSuccess];
    }

    
}
///余额   --- (充值、提现)
-(void)didClickBalanceView
{
    if (BBUserDefault.isLogin == 1) {
        RechargeViewController * bankVC = [RechargeViewController new];
        bankVC.balance  = _balance;
        [self.navigationController pushViewController:bankVC animated:NO];
    }else{
        [self isloginSuccess];
    }

}
///不可用金额
-(void)didClickUnitView
{
    [self settingAlertView];

}
///优惠券
-(void)didClickDiscountCouponView
{
    if (BBUserDefault.isLogin == 0) {
        
        [self isloginSuccess];
        
    }else{
        CouponViewController * couponVC = [CouponViewController new];
        [self.navigationController pushViewController:couponVC animated:NO];
    }

}
///富豆  银行卡绑定
-(void)didClickFuBeanView
{
    if (BBUserDefault.isLogin == 1) {
        BandBackCarViewController * bankVC = [BandBackCarViewController new];
        [self.navigationController pushViewController:bankVC animated:NO];
    }else{
        [self isloginSuccess];
    }

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
        
        NSString * code = [NSString stringWithFormat:@"%@",response [@"resultCode"]];
        
        if ([code isEqualToString:@"0"]) {
            
            _couponNum  = [NSString stringWithFormat:@"%@",response[@"couponNum"]];//优惠券数量
            _foolnum    = [NSString stringWithFormat:@"%@",response[@"foolNum"] ];
            _collectNum = [NSString stringWithFormat:@"%@",response[@"collectNum"]];
            _shopFlag   = [NSString stringWithFormat:@"%@",response[@"userInfo"][@"shopFlag"]];// 1.是商家 0. 普通用户 -1待审核
            _deliveryFlag= [NSString stringWithFormat:@"%@",response[@"userInfo"][@"deliveryFlag"]];//是否是快递员 1.审核通过 2.待审核 3.审核失败
            _storeId    = [NSString stringWithFormat:@"%@",response[@"userInfo"][@"storeId"]];
 
            BBUserDefault.shopFlag = _shopFlag;
            BBUserDefault.deliveryFlag = _deliveryFlag;
            BBUserDefault.isSetPassword = response[@"userInfo"][@"isSetPassword"];
            //是否实名认证 1 是 2 否
            BBUserDefault.realNameFlag = [NSString stringWithFormat:@"%@",response[@"userInfo"][@"realNameFlag"]];
            BBUserDefault.nickName   = [NSString stringWithFormat:@"%@",response[@"userInfo"][@"nickName"]];
            BBUserDefault.sexType    = [response[@"userInfo"][@"sex"] integerValue];
            BBUserDefault.birthDay   = [NSString stringWithFormat:@"%@",response[@"userInfo"][@"cmBirthday"]];
            _userImgAttachUrl = [NSString stringWithFormat:@"%@",response[@"userInfo"][@"userImgAttachUrl"]];
        
            //赋值
            self.headview.lb_collectCount.text = _collectNum;
            self.headview.lb_historyCount.text = _foolnum;
            self.headview.lb_userNickname.text = BBUserDefault.nickName;
            BBUserDefault.userHeaderImg = _userImgAttachUrl;
            [self.headview.img_headview sd_setImageWithURL:[NSURL URLWithString:_userImgAttachUrl] placeholderImage:[UIImage imageNamed:@"head"]];
            
            [self.myTableView reloadData];
        }
        
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
                             @"account":BBUserDefault.userPhoneNumber,
                             };
    
    [MENetWorkManager post:[zfb_baseUrl stringByAppendingString:@"/QRCode/getThirdBalance"] params:parma success:^(id response) {
        if ([response [@"resultCode"] intValue] == 0) {
            _balance = response[@"balance"];
            _bankNum = response[@"bankNum"];
            _unsettBalance = response[@"unsettBalance"];

        }
        [self.myTableView reloadData];
        
    } progress:^(NSProgress *progeress) {
    } failure:^(NSError *error) {
        NSLog(@"error=====%@",error);
        [self.view makeToast:@"网络错误" duration:2 position:@"center"];
    }];
    
}
#pragma mark  - 配送员审核状态
-(void)checkStatusPost
{
    NSDictionary * parma = @{
                             @"cmUserId":BBUserDefault.cmUserId,
                             };
    
    [MENetWorkManager post:[zfb_baseUrl stringByAppendingString:@"/deliveryAuditStatus"] params:parma success:^(id response) {
        // 审核状态   1.审核通过 2.待审核 3.审核失败

        [self.myTableView reloadData];
      
    } progress:^(NSProgress *progeress) {
    } failure:^(NSError *error) {
        NSLog(@"error=====%@",error);
        [self.view makeToast:@"网络错误" duration:2 position:@"center"];
    }];
    
}


-(void)viewDidAppear:(BOOL)animated
{
    NSLog(@"已经加载了");
    if (BBUserDefault.isLogin == 1) {

    }
    else{
        //赋值
        self.headview.lb_collectCount.text = @"0";
        self.headview.lb_historyCount.text = @"0";
        [self.myTableView reloadData];
    }
    NSLog(@"_shopFlag = %@ ---- _deliveryFlag = %@",_shopFlag,_deliveryFlag);
}
-(void)viewWillAppear:(BOOL)animated
{
    [self settingNavBarBgName:@"nav64_red"];
 
    if (BBUserDefault.isLogin == 1) {
        [self getThirdBalancePOSTRequste];//余额查询
        [self minePagePOSTRequste];//页面网络请求
 
        //移除登录视图
        _headview.loginView.hidden   = NO;
        _headview.unloginView.hidden = YES;
    
    }else{
        _shopFlag = nil;
        _deliveryFlag = nil;
        _headview.loginView.hidden   = YES;
        _headview.unloginView.hidden = NO;
        _deliveryFlag = @"0";
        _shopFlag = @"0";
    }
 
    [self.myTableView reloadData];
}

//判断是否登录了
-(void)isloginSuccess
{
    [self isNotLoginWithTabbar:NO];
}

#pragma mark - 快捷操作 代理 QuickOperationCellDelegate
//我要开店
-(void)didClickOpenStore
{
    if (BBUserDefault.isLogin == 1) {
        if ([_deliveryFlag isEqualToString:@"0"] &&[_shopFlag isEqualToString:@"0"] )
        {
            iOpenStoreViewController * openVC  = [iOpenStoreViewController new];
            [self.navigationController pushViewController:openVC animated:NO];
            
        }else{
            if ([_shopFlag isEqualToString:@"-1"]) {
                [self.view makeToast:@"审核中..." duration:2 position:@"center"];
            }else{
                [self.view makeToast:@"配送和商户,只能选其一" duration:2 position:@"center"];
            }
        }
    }
    else{
        [self isloginSuccess];
    }
    NSLog(@"我要开店");
 
}
//成为配送
-(void)didClickSendGoods
{
    if (BBUserDefault.isLogin == 1) {
        if ([_deliveryFlag isEqualToString:@"0"] &&[_shopFlag isEqualToString:@"0"] ) {//普通用户
            
            iwantSendedViewController * sendVC  = [iwantSendedViewController new];
            [self.navigationController pushViewController:sendVC animated:NO];
            
        }else{
            if ([_deliveryStatus isEqualToString:@"3"]) {//如果失败
                iwantSendedViewController * sendVC  = [iwantSendedViewController new];
                [self.navigationController pushViewController:sendVC animated:NO];
            }
            else if ([_deliveryStatus isEqualToString:@"2"])//审核中
            {
                [self.view makeToast:@"审核中..." duration:2 position:@"center"];
            }
            else{
                [self.view makeToast:@"配送和商户,只能选其一" duration:2 position:@"center"];
                
            }
            
        }
    }else{
       
        [self isloginSuccess];
    }

}
//切换商户
-(void)didClickChangeID
{
    NSLog(@"切换商户");
    
    if (BBUserDefault.isLogin == 1) {
        if ([_shopFlag isEqualToString:@"1"]) {//shopFlag = 1 商户端 0隐藏
            //商户端
            BusinessServicerViewController * businessVC = [[BusinessServicerViewController alloc]init];
            businessVC.storeId = _storeId;
            [self.navigationController pushViewController:businessVC animated:NO];
            
        }
        if ([_deliveryFlag isEqualToString:@"1"]) {//配送员 = 1  0隐藏
            // 配送端
            ZFSendSerViceViewController * sendVC = [[ZFSendSerViceViewController alloc]init];
            [self.navigationController pushViewController:sendVC animated:NO];
        }
        
    }
    else{
        [self isloginSuccess];
        
    }

}
//我的评价
-(void)didClickMyevalution{
    NSLog(@"我的评价");
//    [self settingAlertView];
    EditCommentViewController * editVC = [EditCommentViewController new];
    [self.navigationController pushViewController:editVC animated:NO];
    

}
//我的动态
-(void)didClickmyDynamic{
    NSLog(@"我的动态");
    [self settingAlertView];

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
