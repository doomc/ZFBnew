//
//  BusinessServiceViewController.m
//  ZFB
//
//  Created by  展富宝  on 2017/7/27.
//  Copyright © 2017年 com.zfb. All rights reserved.
//  商户端首页

#import "BusinessServiceViewController.h"
#import "ZFpopView.h"

@interface BusinessServiceViewController ()<UITableViewDelegate,UITableViewDataSource,ZFpopViewDelegate>

@property (nonatomic , strong) UITableView * homeTableView;
@property (nonatomic , strong) UITableView * orderTableView;

@property (weak, nonatomic) IBOutlet UIImageView *img_sendHome;
@property (weak, nonatomic) IBOutlet UIImageView *img_sendOrder;

@property (weak, nonatomic) IBOutlet UILabel *lb_sendHomeTitle;
@property (weak, nonatomic) IBOutlet UILabel *lb_sendOrderTitle;

@property (nonatomic,assign) BOOL     isSelectPage;//默认选择一个首页面
@property (nonatomic,strong) UIButton *  navbar_btn;//导航页选择器
@property (nonatomic,strong) UIView   *  titleView;
@property (nonatomic,strong) UIView   *  bgview;//蒙板

@property (nonatomic ,strong) ZFpopView * popView;
@property (nonatomic ,strong) NSArray   * titles;//pop数据源


@end

@implementation BusinessServiceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.title = @"商户端";
    
    _titles = @[@"待配送",@"配送中",@"已配送"];
    
    [self.view addSubview:self.homeTableView];
    
    [self set_leftButton];
    
}
/**
 @return  背景蒙板
 */
-(UIView *)bgview
{
    if (!_bgview) {
        _bgview =[[ UIView alloc]initWithFrame:CGRectMake(0, 64, KScreenW, KScreenH)];
        _bgview.backgroundColor = RGBA(0, 0, 0, 0.2) ;
        [_bgview addSubview:self.popView];
    }
    return _bgview;
    
}
//弹框初始化
-(ZFpopView *)popView
{
    if (!_popView) {
        _popView =[[ZFpopView alloc]initWithFrame:CGRectMake(0, 0, KScreenW, 155) titleArray:_titles];
        _popView.delegate = self;
        
    }
    return _popView;
}

//自定义导航按钮选择定订单
-(UIButton *)navbar_btn
{
    if (!_navbar_btn) {
        _navbar_btn       = [UIButton buttonWithType:UIButtonTypeCustom];
        _navbar_btn.frame = CGRectMake(_titleView.centerX+40 , _titleView.centerY, 120, 24);
        [_navbar_btn setImage:[UIImage imageNamed:@"Order_down"] forState:UIControlStateNormal];
        _navbar_btn.titleLabel.font = [UIFont systemFontOfSize:14];
        [_navbar_btn setTitleColor:HEXCOLOR(0xfe6d6a) forState:UIControlStateNormal];
        [_navbar_btn setImageEdgeInsets:UIEdgeInsetsMake(0, 80, 0, 0)];
        [_navbar_btn setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 0,30)];
        [_navbar_btn addTarget:self action:@selector(navigationBarSelectedOther:) forControlEvents:UIControlEventTouchUpInside];
        self.navigationItem.titleView = _navbar_btn;
    }
    return _navbar_btn;
}
/**
 正选反选
 @param btn 切换
 */
-(void)navigationBarSelectedOther:(UIButton *)btn;
{
    [self.view addSubview:self.bgview];;
}

//切换首页
- (IBAction)homePageAction:(id)sender {
    
    self.navbar_btn.hidden = YES;
    self.isSelectPage      = YES;
    
    self.img_sendHome.image         = [UIImage imageNamed:@"home_red"];
    self.lb_sendHomeTitle.textColor = HEXCOLOR(0xfe6d6a);
    
    self.lb_sendOrderTitle.textColor=[UIColor whiteColor];
    self.img_sendOrder.image = [UIImage imageNamed:@"Order_normal"];
    
    UILabel * atitle              = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 100, 30)] ;
    atitle.text                   = @"配送端";
    atitle.font =[UIFont systemFontOfSize:14];
    atitle.textAlignment          = NSTextAlignmentCenter;
    atitle.textColor              = HEXCOLOR(0xfe6d6a);
    self.navigationItem.titleView = atitle;
    
    [self.homeTableView reloadData];
}
//切换订单
- (IBAction)orderPageAction:(id)sender {
    
    self.isSelectPage      = NO;
    self.navbar_btn.hidden = NO;
    [self.navbar_btn setTitle:@"待配送" forState:UIControlStateNormal];
    
    self.img_sendHome.image         = [UIImage imageNamed:@"home_normal"];
    self.lb_sendHomeTitle.textColor = [UIColor whiteColor];
    
    self.lb_sendOrderTitle.textColor = HEXCOLOR(0xfe6d6a);
    self.img_sendOrder.image         = [UIImage imageNamed:@"send_red"];
    
    self.navigationItem.titleView = self.navbar_btn;
    [self.orderTableView reloadData];
}

-(UIButton *)set_leftButton
{
    UIButton * reback = [UIButton buttonWithType:UIButtonTypeCustom];
    [reback setTitle:@"切换到用户" forState:UIControlStateNormal];
    [reback setTintColor:HEXCOLOR(0xfe6d6a)];
    UIBarButtonItem * left                                     = [[UIBarButtonItem alloc]initWithCustomView:reback];
    self.navigationController.navigationItem.leftBarButtonItem = left;
    
    
    return reback;
}
-(UITableView *)homeTableView
{
    if (!_homeTableView ) {
        _homeTableView            = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, KScreenW, KScreenH- 64-49) style:UITableViewStylePlain];
        _homeTableView.delegate   = self;
        _homeTableView.dataSource = self;
        //register  nib
    }
    return _homeTableView;
}
-(UITableView *)orderTableView
{
    if (!_orderTableView ) {
        _orderTableView            = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, KScreenW, KScreenH- 64-49) style:UITableViewStylePlain];
        _orderTableView.delegate   = self;
        _orderTableView.dataSource = self;
        //register  nib
    }
    return _orderTableView;
}


#pragma mark  -tableView delegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    NSInteger sectionNum = 2;
    //    if (_isSelectPage == YES ) {
    //
    //        return sectionNum;
    //
    //    }
    //
    return sectionNum;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger sectionRow = 1;
    
    //    if (_isSelectPage == YES ) {
    //
    //        return 1;
    //
    //
    //    }
    return sectionRow;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat height = 40;
    
    //    ///根据  cellType 返回的高度
    //    if (_isSelectPage == YES) {
    //        if (indexPath.section == 0) {
    //
    //            height = 140;
    //
    //        }
    //        else{
    //
    //            height = 220;
    //        }
    //    }
    //
    
    return height;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView  * view = nil;
    
    //    SendServiceTitleCell *titleCell = [self.send_tableView
    //                                       dequeueReusableCellWithIdentifier:headerCellid];
    //    titleCell.selectionStyle = UITableViewCellSelectionStyleNone;
    //
    //    view = titleCell;
    
    return view;
}
//设置headView视图
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    //    if (_isSelectPage == YES) {
    //
    //        return 41;
    //    }
    //    else{
    //
    //        return 41;
    //
    //    }
    //    return 0.001;
    
    return 40;
}

//设置footerView视图
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView * footerView = nil;
    
    //    if (_isSelectPage == YES) {
    //
    //        return footerView;
    //    }
    //
    //
    //
    return footerView;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    //    CGFloat height = 0.001;
    //
    //    if (self.isSelectPage == YES) {
    //
    //        height = 10;
    //
    //
    //    }
    //    return height;
    return 30;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //    UITableViewCell *cell = nil;
    //
    //    if (self.isSelectPage == YES) {
    //
    //
    //    }
    //    return cell;
    
    UITableViewCell * cell = [self.homeTableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    
    return cell;
}

#pragma mark - didSelectRowAtIndexPath

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"section  =%ld , row = %ld",indexPath.section ,indexPath.row);
    
}


#pragma mark - ZFpopViewDelegate 选择一个type
-(void)sendTitle:(NSString *)title orderType:(OrderType)type
{
    [UIView animateWithDuration:0.3 animations:^{
        
        if (self.bgview.superview) {
            [self.bgview removeFromSuperview];
            
        }
    }];
    
    //    _orderType = type;//赋值type ，根据type请求
    
    [self.navbar_btn setTitle:title forState:UIControlStateNormal];
    
    
    //待派单 。配送中。待付款、交易完成。待去人退回；
    
}




-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
    
    [self.bgview removeFromSuperview];
    
    
}
-(void)viewWillDisappear:(BOOL)animated{
    
    [SVProgressHUD dismiss];
    
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
