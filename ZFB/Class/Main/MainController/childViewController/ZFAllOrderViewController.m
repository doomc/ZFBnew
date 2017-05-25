


//
//  ZFAllOrderViewController.m
//  ZFB
//
//  Created by  展富宝  on 2017/5/25.
//  Copyright © 2017年 com.zfb. All rights reserved.
//  全部订单

#import "ZFAllOrderViewController.h"
#import "ZFSendingCell.h"
#import "PayforCell.h"
#import "AllStoreCell.h"

typedef NS_ENUM(NSUInteger, CellType) {
    allOrderWithCellType =0,
    waitPayWithCellType,
    sendingWithCellType,
};
typedef NS_ENUM(NSUInteger,  sectionType) {
    allOrderWithsectionType =0,
    waitPayWithsectionType,
    sendingWithsectionType,
};
typedef NS_ENUM(NSUInteger,  headerType) {
    allOrderWithHeaderType =0,
    waitPayWithHeaderType,
    sendingWithHeaderType,
};
@interface ZFAllOrderViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    NSString *titletext ;//head时间
    NSString *statusStr;//配送状态
    NSString *section_title;//店铺名称
    NSString *buttonTitle;//按钮名字
    NSString *price ;//订单金额
    
}
@property(nonatomic ,strong) UIView * titleView ;
@property(nonatomic ,strong) UIButton *navbar_btn;//导航按钮
@property(nonatomic ,strong) UIView * bgview;//蒙板
@property(nonatomic ,strong) UIView * popaView;//白板
@property(nonatomic ,strong) NSArray * titles;//选择页面
@property(nonatomic ,assign) BOOL isChoose;

@property(nonatomic ,strong) UITableView * allOrder_tableView;//全部订单
@property(nonatomic ,strong) UITableView * waitPay_tableView;//待付款
@property(nonatomic ,strong) UITableView * waitSend_tableView;//待配送
@property(nonatomic ,strong) UITableView * sending_tableView;//配送中
@property(nonatomic ,strong) UITableView * sended_tableView;//配送完成
@property(nonatomic ,strong) UITableView * dealSuccess_tableView;//交易完成
@property(nonatomic ,strong) UITableView * cancelSuccess_tableView;//交易取消
@property(nonatomic ,strong) UITableView * afterSale_tableView;//申请售后

@end

@implementation ZFAllOrderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    

    self.titles =@[@"全部订单",@"待付款",@"待配送",@"配送中",@"已配送",@"交易完成",@"交易取消",@"售后申请",];
    [self.navbar_btn setTitle:@"全部订单" forState:UIControlStateNormal];
    [self.allOrder_tableView registerNib:[UINib nibWithNibName:@"ZFSendingCell" bundle:nil] forCellReuseIdentifier:@"ZFSendingCellid"];
    [self.allOrder_tableView registerNib:[UINib nibWithNibName:@"PayforCell" bundle:nil] forCellReuseIdentifier:@"PayforCellid"];
    [self.allOrder_tableView registerNib:[UINib nibWithNibName:@"AllStoreCell" bundle:nil] forCellReuseIdentifier:@"AllStoreCellid"];

 
 
}

-(UITableView *)allOrder_tableView
{
    if (!_allOrder_tableView) {
        _allOrder_tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, KScreenW, KScreenH-64) style:UITableViewStylePlain];
        _allOrder_tableView.delegate = self;
        _allOrder_tableView.dataSource = self;
        _allOrder_tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [self.view addSubview:self.allOrder_tableView];
    }
    return _allOrder_tableView;
}
//自定义导航按钮选择定订单
-(UIButton *)navbar_btn
{
    if (!_navbar_btn) {
        _navbar_btn = [UIButton buttonWithType:UIButtonTypeCustom];
        _navbar_btn.frame =CGRectMake(_titleView.centerX+40 , _titleView.centerY, 120, 24);
        [_navbar_btn setImage:[UIImage imageNamed:@"Order_down"] forState:UIControlStateNormal];
        [_navbar_btn setTitle:statusStr forState:UIControlStateNormal];
        _navbar_btn.titleLabel.font = [UIFont systemFontOfSize:14];
        [_navbar_btn setTitleColor:HEXCOLOR(0xfe6d6a) forState:UIControlStateNormal];
        [_navbar_btn setImageEdgeInsets:UIEdgeInsetsMake(0, 80, 0, 0)];
        [_navbar_btn setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 0,40)];
        [_navbar_btn addTarget:self action:@selector(navigationBarSelectedOther:) forControlEvents:UIControlEventTouchUpInside];
        self.navigationItem.titleView = _navbar_btn;
    }
    return _navbar_btn;
}


-(UIView *)CreatSectionHeadView
{
    titletext = @"2017-08-08";
    statusStr = @"已配送";
    section_title = @"茜茜服装店";
    UIFont * font  =[UIFont systemFontOfSize:12];
    
    UIView *  headerView = [[UIView alloc]initWithFrame:CGRectMake(0 , 0, KScreenW, 80)];
    headerView.backgroundColor = [UIColor whiteColor];
    UILabel * title = [[UILabel alloc]init];
    title.text = titletext;
    title.font = font;
    CGSize size = [title.text sizeWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:font,NSFontAttributeName,nil]];
    CGFloat titleW = size.width;
    title.frame = CGRectMake(15, 15, titleW, 25);
    title.textColor = HEXCOLOR(0x363636);
    
    
    UIButton * status = [[UIButton alloc]init ];
    [status setTitle:statusStr forState:UIControlStateNormal];
    status.titleLabel.font = font;
    [status setTitleColor: HEXCOLOR(0x7a7a7a) forState:UIControlStateNormal];
    CGSize statusSize = [statusStr sizeWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:font,NSFontAttributeName,nil]];
    CGFloat statusW = statusSize.width;
    status.frame = CGRectMake(KScreenW - statusW - 15, 15, statusW, 25);
    [status addTarget:self action:@selector(didclickEdit:) forControlEvents:UIControlEventTouchUpInside];
    
    
    UILabel *lineDown =[[UILabel alloc]initWithFrame:CGRectMake(0, 39, KScreenW, 1)];
    lineDown.backgroundColor = HEXCOLOR(0xdedede);
    
    //区头名
    UILabel * lb_sctionTitle = [[UILabel alloc]init];
    lb_sctionTitle.text = section_title;
    lb_sctionTitle.font = [UIFont systemFontOfSize:14];
    CGSize lb_sctionTitleSize = [lb_sctionTitle.text sizeWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:font,NSFontAttributeName,nil]];
    CGFloat lb_sctionTitletitleW = lb_sctionTitleSize.width;
    lb_sctionTitle.frame = CGRectMake(15, 40+10, lb_sctionTitletitleW+20, 25);
    lb_sctionTitle.textColor = HEXCOLOR(0x363636);
    
    UILabel *lineDown2 =[[UILabel alloc]initWithFrame:CGRectMake(0, 79, KScreenW, 1)];
    lineDown2.backgroundColor = HEXCOLOR(0xffcccc);
    
    [headerView addSubview:lb_sctionTitle];
    [headerView addSubview:lineDown];
    [headerView addSubview:lineDown2];
    [headerView addSubview:status];
    [headerView addSubview:title];
    
    return headerView;
    
}

-(UIView *)CreatSectionFooterView
{
    buttonTitle = @"确认付款";
    price = @"¥208.00";
    NSString *caseOrder =  @"订单金额:";
    
    UIFont * font  =[UIFont systemFontOfSize:12];
    UIView* footerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, KScreenW, 40)];
    footerView.backgroundColor =[UIColor whiteColor];
    
    //结算按钮
    UIButton * complete_Btn  = [UIButton buttonWithType:UIButtonTypeCustom];
    [complete_Btn setTitle:buttonTitle forState:UIControlStateNormal];
    complete_Btn.titleLabel.font =font;
    complete_Btn.layer.cornerRadius = 2;
    complete_Btn.backgroundColor =HEXCOLOR(0xfe6d6a);
    CGSize complete_BtnSize = [buttonTitle sizeWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:font,NSFontAttributeName,nil]];
    CGFloat complete_BtnW = complete_BtnSize.width;
    complete_Btn.frame =CGRectMake(KScreenW - complete_BtnW - 40, 10, complete_BtnW +10, 25);
    [complete_Btn addTarget:self action:@selector(didClickClearing:) forControlEvents:UIControlEventTouchUpInside];
    
    //取消交易按钮
    UIButton * cancel_Btn  = [UIButton buttonWithType:UIButtonTypeCustom];
    [cancel_Btn setTitle:@"取消" forState:UIControlStateNormal];
    cancel_Btn.titleLabel.font =font;
    cancel_Btn.layer.cornerRadius = 2;
    cancel_Btn.backgroundColor =HEXCOLOR(0xfe6d6a);
    CGSize cancel_BtnSize = [buttonTitle sizeWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:font,NSFontAttributeName,nil]];
    CGFloat cancel_BtnW = cancel_BtnSize.width;
    cancel_Btn.frame =CGRectMake(KScreenW - complete_BtnW - 40 -cancel_BtnW, 10, cancel_BtnW +10, 25);
    [cancel_Btn addTarget:self action:@selector(didClickCancel_Btn:) forControlEvents:UIControlEventTouchUpInside];
    
    //固定金额位置
    UILabel * lb_order = [[UILabel alloc]init];
    lb_order.text= caseOrder;
    lb_order.font = font;
    lb_order.textColor = HEXCOLOR(0x363636);
    CGSize lb_orderSiez = [caseOrder sizeWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:font,NSFontAttributeName, nil]];
    CGFloat lb_orderW = lb_orderSiez.width;
    lb_order.frame =  CGRectMake(15, 5, lb_orderW, 30);
    
    //价格
    UILabel * lb_price = [[UILabel alloc]init];
    lb_price.text = price;
    lb_price.textAlignment = NSTextAlignmentLeft;
    lb_price.font = font;
    lb_price.textColor = HEXCOLOR(0xfe6d6a);
    CGSize lb_priceSize = [price sizeWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:font,NSFontAttributeName, nil]];
    CGFloat lb_priceW = lb_priceSize.width;
    lb_price.frame = CGRectMake(lb_orderW+15+10 , 5, lb_priceW, 30);
    
    [footerView addSubview: lb_price];
    [footerView addSubview:lb_order];
    [footerView addSubview:complete_Btn];
    [footerView addSubview:cancel_Btn];//需要隐藏

    return footerView;
    
}
#pragma mark - tableView delegare
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 4;
    
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 85;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return [self CreatSectionHeadView];
    
}
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    return [self CreatSectionFooterView];
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    
    return 80.0 ;
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 40.0;
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    ZFSendingCell * shopCell = [self.allOrder_tableView dequeueReusableCellWithIdentifier:@"ZFSendingCellid" forIndexPath:indexPath];
    shopCell.selectionStyle  = UITableViewCellSelectionStyleNone;
    
    return shopCell;
    
}
#pragma mark - tableView datasource
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@" section = %ld ， row = %ld",indexPath.section,indexPath.row);
    
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
        [_bgview addSubview:self.popaView];
    }
    return _bgview;
    
}
/**
 弹框选择器
 */
-(UIView *)popaView
{
    if (!_popaView) {
        _popaView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, KScreenW, 155)];
        _popaView.backgroundColor = [UIColor whiteColor];
        
        for (int i = 0; i <  self.titles.count; i++) {
            
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            button = [[UIButton alloc] initWithFrame:CGRectMake(i%3 * (KScreenW*0.3333)+20,20+i/3*(25+20), KScreenW*0.3333 - 40, 25)];
            button.layer.cornerRadius = 2;
            button.layer.borderWidth = 1;
            button.layer.borderColor = HEXCOLOR(0xdedede).CGColor;
            [button setTitleColor:HEXCOLOR(0x363636) forState:UIControlStateNormal];
            [button setTitle:  _titles[i] forState:UIControlStateNormal];
            button.titleLabel.font = [UIFont systemFontOfSize:12];
            [button addTarget:self action:@selector(didclickSendPopViewAction:) forControlEvents:UIControlEventTouchUpInside];
            [_popaView addSubview:button];
            button.tag = i+2000;
            NSLog(@"%ld \n",button.tag);
            
        }
    }
    return _popaView;
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
        self.popaView.hidden = NO;
        
    }else{
        btn.selected=NO;
        self.bgview.hidden = YES;
        self.popaView.hidden = YES;
    }
}
//选择进入那个页面？
-(void)didclickSendPopViewAction:(UIButton*)sender
{
 
    [self.navbar_btn setTitle:sender.titleLabel.text forState:UIControlStateNormal];
//    
//    sender.selected= !sender.selected;
//    [sender setTitleColor:HEXCOLOR(0xfe6d6a) forState:UIControlStateNormal];
//    sender.layer.borderColor =HEXCOLOR(0xfe6d6a).CGColor;
//
//    self.bgview.hidden = YES;
//    self.popaView.hidden = YES;
//    
//    [self.allOrder_tableView reloadData];
    
    NSInteger tagNum ;
    tagNum = sender.tag ;
    NSString* idstr =  [_titles objectAtIndex:tagNum-2000];
    NSLog(@"%ld ,%@" ,tagNum,idstr);
  
    NSDictionary * dic ;
    [dic objectForKey:idstr];
    [dic setValue:idstr forKey:@"keyid"];
    NSLog(@"dic = %@",dic);
    
    //[self  getdataWithId:idstr];
    
}

/**
 确认付款
 @param clearbtn pay
 */
-(void)didClickClearing:(UIButton *)clearbtn
{
    NSLog(@"确认付款");
}
@end
