//
//  ZFMainSendViewController.m
//  ZFB
//
//  Created by  展富宝  on 2017/5/22.
//  Copyright © 2017年 com.zfb. All rights reserved.
//

#import "ZFMainSendViewController.h"
#import "ZFSendingCell.h"

@interface ZFMainSendViewController ()<UITableViewDelegate,UITableViewDataSource>


@property(nonatomic ,strong) UITableView * send_tableView;
@property(nonatomic ,strong) UILabel * lb_naVtitle; //导航名字
@property(nonatomic ,strong) UIView * titleViewBar;//导航背景
@property(nonatomic ,strong) UIImageView * IMG_icon;//导航icon
@property(nonatomic ,strong) UITableViewCell * infoCell;//用户信息cell

@property(nonatomic ,strong)UIView * headerView;
@property(nonatomic ,strong)UIView * footerView;
@property(nonatomic ,strong)UIView * bgview;//蒙板
@property(nonatomic ,strong)UIView * popView;//弹框视图

@property(nonatomic ,strong)UIButton * Leftitem;//自定义左边按钮
@property(nonatomic ,strong)UIButton * backToHomeitem;//自定义左边按钮


@property(nonatomic ,strong)NSMutableArray * titlesArr;
@property(nonatomic ,strong)NSMutableArray * nickArr;

@property(nonatomic ,assign)BOOL isChange;//切换更改数据


@end

@implementation ZFMainSendViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title  = @"用户端";
    self.isChange = YES;

    self.send_tableView.hidden = YES;//默认隐藏
    self.isChange = YES;//默认已切换
    [self bgViewInit];
    
    [self.send_tableView registerNib:[UINib nibWithNibName:@"ZFSendingCell" bundle:nil] forCellReuseIdentifier:@"sendCellid"];
    
    [self addNavWithTitle:@"配送端"  didClickArrowsDown:@selector(navigationBarSelectedOther:) ishidden:self.isChange];

}

-(NSMutableArray *)titlesArr
{
    if (!_titlesArr) {
        _titlesArr = [NSMutableArray arrayWithObjects:@"收货人:",@"收货人电话:",@"收货地址:",@"取货地址:",@"配送费:", nil];
    }
    return _titlesArr;
}
-(NSMutableArray *)nickArr
{
    if (!_nickArr) {
        _nickArr = [NSMutableArray arrayWithObjects:@"张三",@"182139823",@"收货地址收货地址收货地址",@"取货地址取货地址取货地址取货地址:",@"¥19.00", nil];
    }
    return _nickArr;
}
#pragma mark  -tableView delegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        
        return 2;
    }else{
        return self.titlesArr.count;
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section== 0) {
        return 85;
    }
    return 40;
}
//设置headView视图
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
   
        return 40;
    }
    return 0;
}
//设置footerView视图
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (section == 0) {
        
        return 50;
    }
    return 0;
    
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return self.headerView;
}
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    return self.footerView;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        ZFSendingCell *sendCell = [self.send_tableView dequeueReusableCellWithIdentifier:@"sendCellid" forIndexPath:indexPath];
        sendCell.selectionStyle =  UITableViewCellSelectionStyleNone;
        return sendCell;
    }
   
    _infoCell = [self.send_tableView dequeueReusableCellWithIdentifier:@"infoCellid"];
    if (!_infoCell) {
        
        _infoCell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"infoCellid"];
    }

    _infoCell.textLabel.text = self.titlesArr[indexPath.row];
    _infoCell.detailTextLabel.text =self.nickArr[indexPath.row];
    _infoCell.textLabel.font = [UIFont systemFontOfSize:12];
    _infoCell.textLabel.textColor = HEXCOLOR(0x363636);
    _infoCell.detailTextLabel.font = [UIFont systemFontOfSize:12];
    _infoCell.selectionStyle =  UITableViewCellSelectionStyleNone;

    return _infoCell;

}

#pragma mark  -  初始化控件
-(UITableView *)send_tableView
{
    if (!_send_tableView) {
        _send_tableView =[[ UITableView alloc]initWithFrame:CGRectMake(0, 64, KScreenW, KScreenH - 44-64) style:UITableViewStylePlain];
        _send_tableView.separatorStyle =UITableViewCellSeparatorStyleNone;
        _send_tableView.delegate= self;
        _send_tableView.dataSource = self;
        [self.view addSubview:_send_tableView];
        
        self.send_tableView.tableHeaderView = _headerView;
        self.send_tableView.tableFooterView = _footerView;
    }
    return _send_tableView;
}

-(UIView *)headerView
{
    if (!_headerView) {
        _headerView = [[UIView alloc]initWithFrame:CGRectMake(0 , 0, KScreenW, 40)];
        
        UILabel * time = [[UILabel alloc]initWithFrame:CGRectMake(15, 5, 200, 30)];
        time.text = @"2017-06-20";
        time.font = [UIFont systemFontOfSize:12.0];
        time.textColor = HEXCOLOR(0x363636);

        UILabel * status = [[UILabel alloc]initWithFrame:CGRectMake(KScreenW - 80, 5, 80, 30)];
        status.text = @"配送中";
        status.font = [UIFont systemFontOfSize:12.0];
        status.textColor = HEXCOLOR(0x363636);
        status.textAlignment = NSTextAlignmentCenter;

        UILabel *line = [[UILabel alloc]initWithFrame:CGRectMake(0, 39, KScreenW, 1)];
        line.backgroundColor =HEXCOLOR(0xdedede);

        [_headerView addSubview:line];
        [_headerView addSubview:time];
        [_headerView addSubview:status];
        
    }
    return _headerView;
}

-(UIView *)footerView
{
    if (!_footerView) {
        _footerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, KScreenW, 50)];
        _footerView.backgroundColor =[UIColor whiteColor];
        UILabel * lb_order = [[UILabel alloc]initWithFrame:CGRectMake(15, 5, 100, 30)];
        lb_order.text= @"订单金额:";
        lb_order.font = [UIFont systemFontOfSize:12.0];
        lb_order.textColor = HEXCOLOR(0x363636);
        
        UILabel * price = [[UILabel alloc]initWithFrame:CGRectMake(120, 5, 100, 30)];
        price.text = @"¥208.00";
        price.textAlignment = NSTextAlignmentLeft;
        price.font = [UIFont systemFontOfSize:12.0];
        price.textColor = HEXCOLOR(0xfe6d6a);
        
        UIButton * complete_Btn  = [UIButton buttonWithType:UIButtonTypeCustom];
        complete_Btn.frame =CGRectMake(KScreenW - 100, 5, 80, 25);
        [complete_Btn setTitle:@"配送完成" forState:UIControlStateNormal];
        complete_Btn.titleLabel.font =[UIFont systemFontOfSize:12.0];
        complete_Btn.backgroundColor = HEXCOLOR(0xfe6d6a);
        complete_Btn.layer.cornerRadius = 2;
        UILabel *line = [[UILabel alloc]initWithFrame:CGRectMake(0, 40, KScreenW, 10)];
        line.backgroundColor =HEXCOLOR(0xdedede);
        
        [_footerView addSubview:line];
        [_footerView addSubview: price];
        [_footerView addSubview:lb_order];
        [_footerView addSubview:complete_Btn];
        
    }
    return _footerView;
}
-(void)bgViewInit
{
    self.bgView1.layer.borderColor = HEXCOLOR(0xfe6d6a).CGColor ;
    self.bgView1.layer.cornerRadius = 2;
    self.bgView1.layer.borderWidth = 1 ;
    
    self.bgView2.layer.borderColor = HEXCOLOR(0xfe6d6a).CGColor ;
    self.bgView2.layer.cornerRadius = 2;
    self.bgView2.layer.borderWidth = 1 ;
    
    self.bgView3.layer.borderColor = HEXCOLOR(0xfe6d6a).CGColor ;
    self.bgView3.layer.cornerRadius = 2;
    self.bgView3.layer.borderWidth = 1 ;
}
-(UIView *)popView
{
    if (!_popView) {
        
        _popView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, KScreenW, 100)];
        _popView.backgroundColor = [UIColor whiteColor];
        
        for (int i = 0; i < self.titlesArr.count; i++) {
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            button = [[UIButton alloc] initWithFrame:CGRectMake(i%3 * (KScreenW*0.3333)+15,20+i/3*(25+20), KScreenW*0.3333 - 30, 25)];
            button.backgroundColor = HEXCOLOR(0xfe6d6a);
            [button setTitle:self.titlesArr[i] forState:UIControlStateNormal];
            button.titleLabel.font = [UIFont systemFontOfSize:12];
            [button addTarget:self action:@selector(didclickSendPopViewAction:) forControlEvents:UIControlEventTouchUpInside];
            [_popView addSubview:button];
            button.tag = i+1000;
            NSLog(@"%ld \n",button.tag);
        }

    }
    return _popView;
}

/**
 @return  背景蒙板
 */
-(UIView *)bgview
{
    if (!_bgview) {
        _bgview =[[ UIView alloc]initWithFrame:CGRectMake(0, 64, KScreenW, KScreenH)];
        _bgview.backgroundColor = RGBA(0, 0, 0, 0.2) ;
        [self.view addSubview:_bgview];
        [_bgview addSubview:self.popView];


    }
    return _bgview;

}
-(UIButton *)Leftitem
{
    if (!_Leftitem) {
        _Leftitem = [UIButton buttonWithType:UIButtonTypeCustom];
        [_Leftitem setTitle:@"切换用户端" forState:UIControlStateNormal];
        [_Leftitem addTarget:self action:@selector(returnTohome) forControlEvents:UIControlEventTouchUpInside];
    }
    return _Leftitem;
}

-(UIButton *)backToHomeitem
{
    if (!_backToHomeitem) {
        _backToHomeitem = [UIButton buttonWithType:UIButtonTypeCustom];
        [_backToHomeitem setImage:[UIImage imageNamed:@"nav_back"] forState:UIControlStateNormal];
        [_backToHomeitem addTarget:self action:@selector(backToHomepage) forControlEvents:UIControlEventTouchUpInside];
    }
    return _backToHomeitem;
}
/**
  @sender popView 按钮tag时间
  */
-(void)didclickSendPopViewAction:(UIButton *)sender
{
    NSInteger tagNum ;
    tagNum = sender.tag ;
  
    NSString* idstr =  [_titlesArr objectAtIndex:tagNum-1000];
    [self  getdataWithId:idstr];
    
    NSLog(@"%ld" ,tagNum);
}

-(void)getdataWithId:(NSString *)idstr{


}


#pragma mark  -  点击事件处理
/**返回个人中心 */
-(void)returnTohom
{
    [self.navigationController popViewControllerAnimated:YES];
}
/**返回用户端首页 */
-(void)backToHomepage
{
    self.HomePageView.hidden = NO;
    self.send_tableView.hidden = YES;
    self.img_sendHome.image = [UIImage imageNamed:@"home_red"];
    self.lb_sendHomeTitle.textColor = HEXCOLOR(0xfe6d6a);
    self.lb_sendOrderTitle.textColor=[UIColor whiteColor];
    self.img_sendOrder.image = [UIImage imageNamed:@"Order_normal"];
}
/**点击首页  @param sender 切换页面*/
- (IBAction)didClickHomePage:(UIButton*)sender {
   
    self.HomePageView.hidden = NO;
    self.send_tableView.hidden = YES;
    self.img_sendHome.image = [UIImage imageNamed:@"home_red"];
    self.lb_sendHomeTitle.textColor = HEXCOLOR(0xfe6d6a);
    self.lb_sendOrderTitle.textColor=[UIColor whiteColor];
    self.img_sendOrder.image = [UIImage imageNamed:@"Order_normal"];

    
}

/**点击订单  @param sender 切换页面 */
- (IBAction)didClickOrderPage:(id)sender {
    
    [self addNavWithTitle:@"待配送"  didClickArrowsDown:@selector(navigationBarSelectedOther:) ishidden:self.isChange];
    self.send_tableView.hidden = NO;
    self.HomePageView.hidden = YES;
    self.img_sendHome.image = [UIImage imageNamed:@"home_normal"];
    self.lb_sendHomeTitle.textColor = [UIColor whiteColor];
    
    self.lb_sendOrderTitle.textColor= HEXCOLOR(0xfe6d6a);
    self.img_sendOrder.image = [UIImage imageNamed:@"send_red"];
    
//    [self.send_tableView reloadData];
  
}

/**
 正选反选
 @param btn 切换
 */
-(void)navigationBarSelectedOther:(UIButton *)btn;
{

    btn.selected = !btn.selected;
    if (btn.selected) {
        self.bgview.hidden = NO;
        self.popView.hidden = NO;
        

    }else{
        btn.selected=NO;
        self.bgview.hidden = YES;
        self.popView.hidden = YES;

    }
    
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
