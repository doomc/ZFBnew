//
//  ZFSendSerViceViewController.m
//  ZFB
//
//  Created by  展富宝  on 2017/5/24.
//  Copyright © 2017年 com.zfb. All rights reserved.
//

#import "ZFSendSerViceViewController.h"
#import "ZFSendingCell.h"
#import "ZFContactCell.h"
#import "ZFFooterCell.h"
#import "ZFTitleCell.h"
#import "ZFSendPopView.h"

#import "ZFSendHomeCell.h"
#import "ZFSendHomeListCell.h"
//订单待配送cell  section0
static  NSString * headerCellid =@"ZFTitleCellid";
static  NSString * sendingCellid =@"ZFSendingCellid";
static  NSString * footerCellid =@"ZFFooterCellid";
//订单待配送cell  section1
static  NSString * contactCellid =@"ZFContactCellid";
//首页 section0
static  NSString * homeCellid =@"ZFSendHomeCellid";
//首页 section1
static  NSString * homeListCellid =@"ZFSendHomeListCellid";


@interface ZFSendSerViceViewController ()<UITableViewDelegate,UITableViewDataSource,ZFSendPopViewDelegate>

@property (strong, nonatomic)  UITableView *send_tableView;
@property (weak, nonatomic) IBOutlet UIButton *Home_btn;//首页安妞
@property (weak, nonatomic) IBOutlet UIButton *Order_btn;//订单按钮

@property (nonatomic,strong) UIButton *navbar_btn;//导航页
@property (nonatomic,strong) UIView * titleView ;
@property (nonatomic,strong) UIView * bgview;
@property (nonatomic,strong) ZFSendPopView * popView;
@property (nonatomic,assign) SendServicType  servicType;//传一个type

@property (nonatomic,assign) BOOL  isSelectPage;//默认选择一个首页面

@property (strong,nonatomic) NSArray *titles;
@property (strong,nonatomic) NSArray *detailTitles;

 @end

@implementation ZFSendSerViceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
  
    _isSelectPage = YES;
    self.title = @"配送端";

    [self.view addSubview:self.send_tableView];

    self.send_tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.send_tableView registerNib:[UINib nibWithNibName:@"ZFTitleCell" bundle:nil] forCellReuseIdentifier:headerCellid];
    [self.send_tableView registerNib:[UINib nibWithNibName:@"ZFSendingCell" bundle:nil] forCellReuseIdentifier:sendingCellid];
    [self.send_tableView registerNib:[UINib nibWithNibName:@"ZFFooterCell" bundle:nil] forCellReuseIdentifier:footerCellid];
    [self.send_tableView registerNib:[UINib nibWithNibName:@"ZFContactCell" bundle:nil] forCellReuseIdentifier:contactCellid];
    
    [self.send_tableView registerNib:[UINib nibWithNibName:@"ZFSendHomeCell" bundle:nil] forCellReuseIdentifier:homeCellid];
    [self.send_tableView registerNib:[UINib nibWithNibName:@"ZFSendHomeListCell" bundle:nil] forCellReuseIdentifier:homeListCellid];

    _titles = @[@"待配送",@"配送中",@"已配送",@"上门取件"];
    _detailTitles =@[@"张三",@"182139823",@"收货地址收货地址收货地址",@"取货地址取货地址取货地址取货地址:",@"¥19.00"];

    [self initButtonWithInterface];
}

#pragma mark - 创建视图

-(void)initButtonWithInterface
{
    [self.Home_btn  addTarget:self action:@selector(Home_btnaTargetAction) forControlEvents:UIControlEventTouchUpInside];
    [self.Order_btn  addTarget:self action:@selector(Order_btnaTargetAction) forControlEvents:UIControlEventTouchUpInside];

}
//自定义导航按钮选择定订单
-(UIButton *)navbar_btn
{
    if (!_navbar_btn) {
        _navbar_btn = [UIButton buttonWithType:UIButtonTypeCustom];
        _navbar_btn.frame =CGRectMake(_titleView.centerX+40 , _titleView.centerY, 120, 24);
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
-(UITableView *)send_tableView
{
    if (!_send_tableView) {
        _send_tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, KScreenW, KScreenH-64-49) style:UITableViewStyleGrouped];
        _send_tableView.delegate = self;
        _send_tableView.dataSource= self;
    }
    return _send_tableView;
}
-(ZFSendPopView *)popView
{
    if (!_popView) {
        
        _popView = [[ZFSendPopView alloc]initWithFrame:CGRectMake(0, 0, KScreenW, 110) titleArray:self.titles];
        _popView.delegate = self;
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
        [_bgview addSubview:self.popView];
    }
    return _bgview;
    
}

#pragma mark  -tableView delegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    NSInteger sectionNum = 2;
    switch (_servicType) {
        
        case SendServicTypeWaitSend:
            
            break;
        case SendServicTypeSending:
            
            sectionNum = 3;

            break;
        case SendServicTypeSended:
            
            break;
        case SendServicTypeUpdoor:
            
            break;
 
    }
    return sectionNum;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger sectionRow = 0;
    
    if (_isSelectPage == YES ) {
        
        if (section == 0) {
        
            return 2;
            
        }
        return 2;

    }else{
       
        switch (_servicType) {
                
            case SendServicTypeWaitSend://待配送
                if (section == 0) {
                    return 4;
                }
                return 1;
                break;
            case SendServicTypeSending://配送中
                
                return 4;//全部返回4行
                break;
            case SendServicTypeSended://已配送
                if (section == 0) {
                    return 5;
                }
                return 0;
                break;
            case SendServicTypeUpdoor://上门取件
                if (section == 0) {
                    return 4;
                }
                return 4;
                break;
                
        }
 
    }
       return sectionRow;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat height = 0;
   
///根据  cellType 返回的高度
    if (_isSelectPage == YES) {
        if (indexPath.section == 0) {

            if (indexPath.row == 0) {
                height  = [tableView fd_heightForCellWithIdentifier:headerCellid configuration:^(id cell) {
                }];
            }
            else {
                height  = [tableView fd_heightForCellWithIdentifier:homeCellid configuration:^(id cell) {
                }];
            }
        }
        if (indexPath.section== 1) {
            if (indexPath.row == 0) {
                height  = [tableView fd_heightForCellWithIdentifier:headerCellid configuration:^(id cell) {
                }];
            }
            else{
                height  = [tableView fd_heightForCellWithIdentifier:homeListCellid configuration:^(id cell) {
                }];
            }
        }
        
    }else{
///根据  cellType 返回的高度
        switch (_servicType) {
#pragma mark - 待配送 返回height
            case SendServicTypeWaitSend:
                if (indexPath.section == 0) {
                    
                    if (indexPath.row == 0) {
                       
                        height  = [tableView fd_heightForCellWithIdentifier:headerCellid configuration:^(id cell) {
                        }];
                    }
                    else if(indexPath.row < 3){
                        height  = [tableView fd_heightForCellWithIdentifier:sendingCellid configuration:^(id cell) {
                        }];
                    }
                    else{
                        height  = [tableView fd_heightForCellWithIdentifier:footerCellid configuration:^(id cell) {
                        }];
                    }
                }
                if (indexPath.section== 1) {
                  
                    height  = [tableView fd_heightForCellWithIdentifier:homeCellid configuration:^(id cell) {
                    }];
                    
                }

                
                break;
#pragma mark - 配送中 返回height
            case SendServicTypeSending:
                
                if (indexPath.row == 0) {
                    
                    height  = [tableView fd_heightForCellWithIdentifier:headerCellid configuration:^(id cell) {
                    }];
                }
                else if(indexPath.row < 3){
                    height  = [tableView fd_heightForCellWithIdentifier:sendingCellid configuration:^(id cell) {
                    }];
                }
                else{
                    height  = [tableView fd_heightForCellWithIdentifier:footerCellid configuration:^(id cell) {
                    }];
                }

                
                break;
#pragma mark - 已配送 返回height
            case SendServicTypeSended:
                if (indexPath.section == 0) {
                    
                    if (indexPath.row == 0) {
                        height  = [tableView fd_heightForCellWithIdentifier:headerCellid configuration:^(id cell) {
                        }];
                    }
                    else if(indexPath.row < 3){
                        height  = [tableView fd_heightForCellWithIdentifier:sendingCellid configuration:^(id cell) {
                        }];
                    }
                    else if(indexPath.row ==3){
                        height  = [tableView fd_heightForCellWithIdentifier:footerCellid configuration:^(id cell) {
                        }];
                    }else{
                       
                        height  = [tableView fd_heightForCellWithIdentifier:footerCellid configuration:^(id cell) {
                        }];
                        
                    }
                }


                
                break;
#pragma mark - 上门取货 返回height
            case SendServicTypeUpdoor:
              
                if (indexPath.row == 0) {
                    
                    height  = [tableView fd_heightForCellWithIdentifier:headerCellid configuration:^(id cell) {
                    }];
                }
                else if(indexPath.row < 3){
                    height  = [tableView fd_heightForCellWithIdentifier:sendingCellid configuration:^(id cell) {
                    }];
                }
                else{
                    height  = [tableView fd_heightForCellWithIdentifier:footerCellid configuration:^(id cell) {
                    }];
                }
                
                break;
                
        }
    }

    return height;
}
//设置headView视图
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        
        return 0.001;
    }
    return 10;
}
//设置footerView视图
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{

    return 0.001;
    
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = nil;
    
    if (self.isSelectPage == YES) {
        
        if (indexPath.section == 0) {
            if (indexPath.row == 0) {
               
                ZFTitleCell *headCell = [self.send_tableView dequeueReusableCellWithIdentifier:headerCellid forIndexPath:indexPath];
                headCell.selectionStyle =  UITableViewCellSelectionStyleNone;
                return headCell;

            }else{
                ZFSendHomeCell * contactCell = [self.send_tableView dequeueReusableCellWithIdentifier:homeCellid forIndexPath:indexPath];
                contactCell.selectionStyle =  UITableViewCellSelectionStyleNone;
                return contactCell;
            }
      
        }else if (indexPath.section == 1){
                if (indexPath.row == 0) {
                ZFTitleCell *headCell = [self.send_tableView dequeueReusableCellWithIdentifier:headerCellid forIndexPath:indexPath];
                headCell.selectionStyle =  UITableViewCellSelectionStyleNone;
                return headCell;
                
            }
            ZFSendHomeListCell *listCell = [self.send_tableView dequeueReusableCellWithIdentifier:homeListCellid forIndexPath:indexPath];
            listCell.selectionStyle =  UITableViewCellSelectionStyleNone;
            return listCell;
        }
        
    }else{
   //     NSLog(@"切换到我的订单 列表")
        switch (_servicType) {
#pragma mark - SendServicTypeWaitSend 待配送
            case SendServicTypeWaitSend:
                if (indexPath.section == 0) {
                    if (indexPath.row == 0) {
                       
                        ZFTitleCell *headCell = [self.send_tableView dequeueReusableCellWithIdentifier:headerCellid forIndexPath:indexPath];
                        headCell.selectionStyle =  UITableViewCellSelectionStyleNone;
                        return headCell;
                  
                    }else if (indexPath.row < 3){
                        ZFSendingCell *contentCell = [self.send_tableView dequeueReusableCellWithIdentifier:sendingCellid forIndexPath:indexPath];
                        contentCell.selectionStyle =  UITableViewCellSelectionStyleNone;
                        return contentCell;
                    
                    }else{
                        ZFFooterCell *footCell = [self.send_tableView dequeueReusableCellWithIdentifier:footerCellid forIndexPath:indexPath];
                        footCell.selectionStyle =  UITableViewCellSelectionStyleNone;
                        return footCell;
                    }
                    
                }else if(indexPath.section == 1){
                    //可切换2种cell   ZFSendHomeCell ZFContactCell
                    ZFSendHomeCell *homeCell = [self.send_tableView dequeueReusableCellWithIdentifier:homeCellid   forIndexPath:indexPath];
                    homeCell.selectionStyle =  UITableViewCellSelectionStyleNone;
                    return homeCell;
                }
                
                break;
#pragma mark - SendServicTypeSending 配送中
            case SendServicTypeSending:
              
                    if (indexPath.row == 0) {
                        ZFTitleCell *headCell = [self.send_tableView dequeueReusableCellWithIdentifier:headerCellid forIndexPath:indexPath];
                        headCell.selectionStyle =  UITableViewCellSelectionStyleNone;
                        return headCell;
                    
                    }else if (indexPath.row < 3){
                        ZFSendingCell *contentCell = [self.send_tableView dequeueReusableCellWithIdentifier:sendingCellid forIndexPath:indexPath];
                        contentCell.selectionStyle =  UITableViewCellSelectionStyleNone;
                        return contentCell;
                   
                    }else{
                       
                        ZFFooterCell *footCell = [self.send_tableView dequeueReusableCellWithIdentifier:footerCellid forIndexPath:indexPath];
                        footCell.selectionStyle =  UITableViewCellSelectionStyleNone;
                       
                        return footCell;
              
                    }
                break;
                
#pragma mark - SendServicTypeSended 已配送
            case SendServicTypeSended:
                if (indexPath.section == 0) {
                    if (indexPath.row == 0) {
                        ZFTitleCell *headCell = [self.send_tableView dequeueReusableCellWithIdentifier:headerCellid forIndexPath:indexPath];
                        headCell.selectionStyle =  UITableViewCellSelectionStyleNone;
                        return headCell;
                    }else if (indexPath.row < 3){
                        ZFSendingCell *contentCell = [self.send_tableView dequeueReusableCellWithIdentifier:sendingCellid forIndexPath:indexPath];
                        contentCell.selectionStyle =  UITableViewCellSelectionStyleNone;
                        return contentCell;
                    }else if (indexPath.row == 3){
                        ZFFooterCell *footCell = [self.send_tableView dequeueReusableCellWithIdentifier:footerCellid forIndexPath:indexPath];
                        footCell.selectionStyle =  UITableViewCellSelectionStyleNone;
                        return footCell;
                    }else{
                        ZFTitleCell *headCell = [self.send_tableView dequeueReusableCellWithIdentifier:headerCellid forIndexPath:indexPath];
                        headCell.selectionStyle =  UITableViewCellSelectionStyleNone;
                        return headCell;
 
                    }
                    
                }
                
                break;
#pragma mark - SendServicTypeUpdoor 上门取货
            case SendServicTypeUpdoor:
                
                    if (indexPath.row == 0) {
                        ZFTitleCell *headCell = [self.send_tableView dequeueReusableCellWithIdentifier:headerCellid forIndexPath:indexPath];
                        headCell.selectionStyle =  UITableViewCellSelectionStyleNone;
                        return headCell;
                    }else if (indexPath.row < 3){
                        ZFSendingCell *contentCell = [self.send_tableView dequeueReusableCellWithIdentifier:sendingCellid forIndexPath:indexPath];
                        contentCell.selectionStyle =  UITableViewCellSelectionStyleNone;
                        return contentCell;
                    }else{
                        ZFFooterCell *footCell = [self.send_tableView dequeueReusableCellWithIdentifier:footerCellid forIndexPath:indexPath];
                        footCell.selectionStyle =  UITableViewCellSelectionStyleNone;
                        return footCell;
                    }

                break;
        }
 
    }
    return cell;
}

#pragma mark - didSelectRowAtIndexPath

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"section  =%ld , row = %ld",indexPath.section ,indexPath.row);
    
}

#pragma mark - didclick 点击事件
-(void)didclickSend:(UIButton *)send
{
    NSLog(@"派送");
}

-(void)didCleckClearing:(UIButton *)clear
{
    NSLog(@"结算");
}
-(void)Home_btnaTargetAction
{
    NSLog(@"首页");
   
    self.navbar_btn.hidden =YES;
    self.isSelectPage = YES;
 
    self.img_sendHome.image = [UIImage imageNamed:@"home_red"];
    self.lb_sendHomeTitle.textColor = HEXCOLOR(0xfe6d6a);
    
    self.lb_sendOrderTitle.textColor=[UIColor whiteColor];
    self.img_sendOrder.image = [UIImage imageNamed:@"Order_normal"];
    
    
    UILabel * atitle= [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 100, 30)] ;
    atitle.text = @"配送端";
    atitle.font =[UIFont systemFontOfSize:14];
    atitle.textAlignment = NSTextAlignmentCenter;
    atitle.textColor = HEXCOLOR(0xfe6d6a);
    self.navigationItem.titleView  = atitle;
    
    [self.send_tableView reloadData];
    
   
}
-(void)Order_btnaTargetAction
{
    NSLog(@"订单");
    
    self.isSelectPage =  NO;
    self.navbar_btn.hidden =NO;
    [self.navbar_btn setTitle:@"待配送" forState:UIControlStateNormal];

    self.img_sendHome.image = [UIImage imageNamed:@"home_normal"];
    self.lb_sendHomeTitle.textColor = [UIColor whiteColor];
    
    self.lb_sendOrderTitle.textColor= HEXCOLOR(0xfe6d6a);
    self.img_sendOrder.image = [UIImage imageNamed:@"send_red"];
   
    self.navigationItem.titleView  =self.navbar_btn;
   [self.send_tableView reloadData];

}

/**
 正选反选
 @param btn 切换
 */
-(void)navigationBarSelectedOther:(UIButton *)btn;
{
    [self.view addSubview:self.bgview];
    
//    btn.selected = !btn.selected;
//    if (btn.selected) {
//        self.bgview.hidden = NO;
//        
//    }else{
//        btn.selected=NO;
//        self.bgview.hidden = YES;
//    }
    
}
#pragma mark - ZFSendPopViewDelegate
-(void)sendTitle:(NSString *)title SendServiceType:(SendServicType)type
{
    [UIView animateWithDuration:0.3 animations:^{
        if (self.bgview.superview) {
            [self.bgview removeFromSuperview];
        }
    }];
    
    _servicType = type;

    [self.navbar_btn setTitle:title forState:UIControlStateNormal];
    
    [self.send_tableView reloadData];

    
}


@end
