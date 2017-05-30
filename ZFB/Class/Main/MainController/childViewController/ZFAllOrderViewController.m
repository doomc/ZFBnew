


//
//  ZFAllOrderViewController.m
//  ZFB
//
//  Created by  展富宝  on 2017/5/25.
//  Copyright © 2017年 com.zfb. All rights reserved.
//  全部订单

#import "ZFAllOrderViewController.h"
#import "ZFSendingCell.h"
#import "ZFFooterCell.h"
#import "ZFTitleCell.h"
#import "ZFpopView.h"
#import "ZFSaleAfterTopView.h"
#import "ZFSaleAfterHeadCell.h"
#import "ZFSaleAfterContentCell.h"
#import "ZFSaleAfterSearchCell.h"
#import "ZFCheckTheProgressCell.h"
#import "ZFPregressCheckViewController.h"
#import "ZFDetailOrderViewController.h"


static  NSString * headerCellid =@"ZFTitleCellid";//头id
static  NSString * contentCellid =@"ZFSendingCellid";//内容id
static  NSString * footerCellid =@"ZFFooterCellid";//尾部id

static  NSString * saleAfterHeadCellid =@"ZFSaleAfterHeadCellid";//头id
static  NSString * saleAfterContentCellid =@"saleAfterContentCellid";//内容id
static  NSString * saleAfterSearchCellid =@"ZFSaleAfterSearchCellid";//搜索cell
static  NSString * saleAfterProgressCellid =@"ZFCheckTheProgressCellid";//进度查询



@interface ZFAllOrderViewController ()<UITableViewDelegate,UITableViewDataSource,ZFpopViewDelegate,ZFSaleAfterTopViewDelegate,ZFCheckTheProgressCellDelegate,ZFSaleAfterContentCellDelegate>


@property(nonatomic ,strong) UIView * titleView ;
@property(nonatomic ,strong) UIButton *navbar_btn;//导航按钮
@property(nonatomic ,strong) UIView * bgview;//蒙板
@property(nonatomic ,strong) NSArray * titles;//选择页面

@property(nonatomic ,strong) NSArray * saleTitles;//售后选择
@property(nonatomic ,assign) NSInteger tagNum;//售后选择


@property(nonatomic ,strong) UITableView * allOrder_tableView;//全部订单
@property(nonatomic ,strong) ZFpopView * popView;
@property(nonatomic ,assign) OrderType orderType;
@property(nonatomic ,assign) BOOL isChange;

//售后搜索
@property(nonatomic ,strong)UISearchBar * searchBar;
@property(nonatomic ,strong)ZFSaleAfterTopView * topView;
@end

@implementation ZFAllOrderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.isChange = NO;

    
    self.saleTitles = @[@"申请售后",@"进度查询"];
    self.titles =@[@"全部订单",@"待付款",@"待配送",@"配送中",@"已配送",@"交易完成",@"交易取消",@"售后申请",];
    [self.navbar_btn setTitle:@"全部订单" forState:UIControlStateNormal];
    [self.view addSubview:self.allOrder_tableView];

    [self.allOrder_tableView registerNib:[UINib nibWithNibName:@"ZFSendingCell" bundle:nil] forCellReuseIdentifier:contentCellid];
    [self.allOrder_tableView registerNib:[UINib nibWithNibName:@"ZFTitleCell" bundle:nil] forCellReuseIdentifier:headerCellid];
    [self.allOrder_tableView registerNib:[UINib nibWithNibName:@"ZFFooterCell" bundle:nil] forCellReuseIdentifier:footerCellid];
   
    [self.allOrder_tableView registerNib:[UINib nibWithNibName:@"ZFSaleAfterHeadCell" bundle:nil] forCellReuseIdentifier:saleAfterHeadCellid];
    [self.allOrder_tableView registerNib:[UINib nibWithNibName:@"ZFSaleAfterContentCell" bundle:nil] forCellReuseIdentifier:saleAfterContentCellid];
    [self.allOrder_tableView registerNib:[UINib nibWithNibName:@"ZFSaleAfterSearchCell" bundle:nil] forCellReuseIdentifier:saleAfterSearchCellid];
    [self.allOrder_tableView registerNib:[UINib nibWithNibName:@"ZFCheckTheProgressCell" bundle:nil] forCellReuseIdentifier:saleAfterProgressCellid];
    
    
    
    
}
-(ZFSaleAfterTopView *)topView{
    if (!_topView) {
        _topView  =[[ ZFSaleAfterTopView alloc]initWithFrame:CGRectMake(0, 64, KScreenW, 40) titleArr:self.saleTitles];
        _topView.delegate = self;
    }
    return _topView;
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
//初始化allOrder_tableView
-(UITableView *)allOrder_tableView
{
    if (!_allOrder_tableView) {
        _allOrder_tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, KScreenW, KScreenH-64) style:UITableViewStylePlain];
        _allOrder_tableView.delegate = self;
        _allOrder_tableView.dataSource = self;
        _allOrder_tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
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
         _navbar_btn.titleLabel.font = [UIFont systemFontOfSize:14];
        [_navbar_btn setTitleColor:HEXCOLOR(0xfe6d6a) forState:UIControlStateNormal];
        [_navbar_btn setImageEdgeInsets:UIEdgeInsetsMake(0, 80, 0, 0)];
        [_navbar_btn setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 0,40)];
        [_navbar_btn addTarget:self action:@selector(navigationBarSelectedOther:) forControlEvents:UIControlEventTouchUpInside];
        self.navigationItem.titleView = _navbar_btn;
    }
    return _navbar_btn;
}

#pragma mark - tableView delegare
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    NSInteger num = 2;
    switch (_orderType) {
        case OrderTypeAllOrder:
 
            break;
        case OrderTypeWaitPay:
            
            break;
        case OrderTypeWaitSend:
            
            break;
        case OrderTypeSending:
            
            break;
        case OrderTypeSended:
            
            break;
        case OrderTypeDealSuccess:
            
            break;
        case OrderTypeCancelSuccess:
            
            break;
        case OrderTypeAfterSale:
            
            break;
    }
    return num;
    
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger sectionNum = 4;
    switch (_orderType) {
        case OrderTypeAllOrder:
            
            break;
        case OrderTypeWaitPay:
            
            break;
        case OrderTypeWaitSend:
            
            break;
        case OrderTypeSending:
            
            break;
        case OrderTypeSended:
            
            break;
        case OrderTypeDealSuccess:
            
            break;
        case OrderTypeCancelSuccess:
            
            break;
        case OrderTypeAfterSale:
            if (self.tagNum == 0) {
                
                if (section == 0) {
                    return 3;
                }else{
                    return 3;
                }
 
            }else if (self.tagNum ==1)
            {
                if (section==0) {
                    return 1;
                }
            }
            
            break;
    }
    return sectionNum;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
   
    CGFloat height = 0;

    if (section == 0) {
        height = 0.001;
    }else {
        height = 10;
    }
   

    switch (_orderType) {
        case OrderTypeAllOrder:

            break;
        case OrderTypeWaitPay:

            
            break;
        case OrderTypeWaitSend:
  
            break;
        case OrderTypeSending:

            break;
        case OrderTypeSended:
   
            break;
        case OrderTypeDealSuccess:
    
            break;
        case OrderTypeCancelSuccess:
  
            break;
        case OrderTypeAfterSale:
            if (section == 0) {
                return 40;
            }else{
                return 10;
            }
            break;
            
    }

    
    return height;
    
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView * view =nil;
    switch (_orderType) {
        case OrderTypeAllOrder:
            
            break;
        case OrderTypeWaitPay:
            
            
            break;
        case OrderTypeWaitSend:
            
            break;
        case OrderTypeSending:
            
            break;
        case OrderTypeSended:
            
            break;
        case OrderTypeDealSuccess:
            
            break;
        case OrderTypeCancelSuccess:
            
            break;
        case OrderTypeAfterSale:
            if (section == 0) {
            
                view = self.topView;
            }else{
              
                return  view;
            }
            break;
            
    }
    return view;

}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat height =0;

    switch (_orderType) {
        case OrderTypeAllOrder:
            
            if (indexPath.row == 0) {
                
                height  = [tableView fd_heightForCellWithIdentifier:@"ZFTitleCellid" configuration:^(id cell) {
                    
                }];
            }
            else if (indexPath.row == 1){
                
                height  = [tableView fd_heightForCellWithIdentifier:@"ZFTitleCellid" configuration:^(id cell) {
                    
                }];
                
            }
            else if(indexPath.row <3){
                
                height  = [tableView fd_heightForCellWithIdentifier:@"ZFSendingCellid" configuration:^(id cell) {
                    
                }];
                
            }else{
                height  = [tableView fd_heightForCellWithIdentifier:@"ZFFooterCellid" configuration:^(id cell) {
                    
                }];
            }

            break;
        case OrderTypeWaitPay:
            if (indexPath.row == 0) {
                
                height  = [tableView fd_heightForCellWithIdentifier:@"ZFTitleCellid" configuration:^(id cell) {
                    
                }];
            }
            else if (indexPath.row == 1){
                
                height  = [tableView fd_heightForCellWithIdentifier:@"ZFTitleCellid" configuration:^(id cell) {
                    
                }];
                
            }
            else if(indexPath.row <3){
                
                height  = [tableView fd_heightForCellWithIdentifier:@"ZFSendingCellid" configuration:^(id cell) {
                    
                }];
                
            }else{
                height  = [tableView fd_heightForCellWithIdentifier:@"ZFFooterCellid" configuration:^(id cell) {
                    
                }];
            }
            
            break;
        case OrderTypeWaitSend:
            if (indexPath.row == 0) {
                
                height  = [tableView fd_heightForCellWithIdentifier:@"ZFTitleCellid" configuration:^(id cell) {
                    
                }];
            }
            else if (indexPath.row == 1){
                
                height  = [tableView fd_heightForCellWithIdentifier:@"ZFTitleCellid" configuration:^(id cell) {
                    
                }];
                
            }
            else if(indexPath.row <3){
                
                height  = [tableView fd_heightForCellWithIdentifier:@"ZFSendingCellid" configuration:^(id cell) {
                    
                }];
                
            }else{
                height  = [tableView fd_heightForCellWithIdentifier:@"ZFFooterCellid" configuration:^(id cell) {
                    
                }];
            }
            
            break;
        case OrderTypeSending:
            if (indexPath.row == 0) {
                
                height  = [tableView fd_heightForCellWithIdentifier:@"ZFTitleCellid" configuration:^(id cell) {
                    
                }];
            }
            else if (indexPath.row == 1){
                
                height  = [tableView fd_heightForCellWithIdentifier:@"ZFTitleCellid" configuration:^(id cell) {
                    
                }];
                
            }
            else if(indexPath.row <3){
                
                height  = [tableView fd_heightForCellWithIdentifier:@"ZFSendingCellid" configuration:^(id cell) {
                    
                }];
                
            }else{
                height  = [tableView fd_heightForCellWithIdentifier:@"ZFFooterCellid" configuration:^(id cell) {
                    
                }];
            }
            
            break;
        case OrderTypeSended:
            if (indexPath.row == 0) {
                
                height  = [tableView fd_heightForCellWithIdentifier:@"ZFTitleCellid" configuration:^(id cell) {
                    
                }];
            }
            else if (indexPath.row == 1){
                
                height  = [tableView fd_heightForCellWithIdentifier:@"ZFTitleCellid" configuration:^(id cell) {
                    
                }];
                
            }
            else if(indexPath.row <3){
                
                height  = [tableView fd_heightForCellWithIdentifier:@"ZFSendingCellid" configuration:^(id cell) {
                    
                }];
                
            }else{
                height  = [tableView fd_heightForCellWithIdentifier:@"ZFFooterCellid" configuration:^(id cell) {
                    
                }];
            }
            
            break;
        case OrderTypeDealSuccess:
            if (indexPath.row == 0) {
                
                height  = [tableView fd_heightForCellWithIdentifier:@"ZFTitleCellid" configuration:^(id cell) {
                    
                }];
            }
            else if (indexPath.row == 1){
                
                height  = [tableView fd_heightForCellWithIdentifier:@"ZFTitleCellid" configuration:^(id cell) {
                    
                }];
                
            }
            else if(indexPath.row <3){
                
                height  = [tableView fd_heightForCellWithIdentifier:@"ZFSendingCellid" configuration:^(id cell) {
                    
                }];
                
            }else{
                height  = [tableView fd_heightForCellWithIdentifier:@"ZFFooterCellid" configuration:^(id cell) {
                    
                }];
            }
            
            break;
        case OrderTypeCancelSuccess:
            if (indexPath.row == 0) {
                
                height  = [tableView fd_heightForCellWithIdentifier:@"ZFTitleCellid" configuration:^(id cell) {
                    
                }];
            }
            else if (indexPath.row == 1){
                
                height  = [tableView fd_heightForCellWithIdentifier:@"ZFTitleCellid" configuration:^(id cell) {
                    
                }];
                
            }
            else if(indexPath.row <3){
                
                height  = [tableView fd_heightForCellWithIdentifier:@"ZFSendingCellid" configuration:^(id cell) {
                    
                }];
                
            }else{
                height  = [tableView fd_heightForCellWithIdentifier:@"ZFFooterCellid" configuration:^(id cell) {
                    
                }];
            }
            
            break;
        case OrderTypeAfterSale:
            if (self.tagNum == 0) {
                
                if (indexPath.section == 0) {
                    if (indexPath.row == 0) {
                        
                        height = [tableView fd_heightForCellWithIdentifier:saleAfterSearchCellid configuration:^(id cell) {
                            
                        }];
                        
                    }else if (indexPath.row ==1)
                    {
                        height = [tableView fd_heightForCellWithIdentifier:saleAfterHeadCellid configuration:^(id cell) {
                            
                        }];
                    }else{
                        
                        height = [tableView fd_heightForCellWithIdentifier:saleAfterContentCellid configuration:^(id cell) {
                            
                        }];
                        
                    }
                    
                }
                if (indexPath.section == 1) {
                    if (indexPath.row == 0) {
                        height = [tableView fd_heightForCellWithIdentifier:saleAfterHeadCellid configuration:^(id cell) {
                            
                        }];
                    }else{
                        height = [tableView fd_heightForCellWithIdentifier:saleAfterContentCellid configuration:^(id cell) {
                            
                        }];
                    }
                }

            }else{
                height = [tableView fd_heightForCellWithIdentifier:saleAfterProgressCellid configuration:^(id cell) {
                    
                }];
            }
            
          
            break;
    }

 
    return height;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.001;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell * cell ;
    
    switch (_orderType) {
        case OrderTypeAllOrder: //全部订单
           
            if (indexPath.section == 0){
                
                if (indexPath.row == 0) {
                   
                    ZFTitleCell *titleCell = [self.allOrder_tableView dequeueReusableCellWithIdentifier:@"ZFTitleCellid" forIndexPath:indexPath];
               
                    cell = titleCell;
                }
                else if (indexPath.row == 1){
                    
                    ZFTitleCell *titleCell = [self.allOrder_tableView dequeueReusableCellWithIdentifier:@"ZFTitleCellid" forIndexPath:indexPath];
                    
                    cell = titleCell;

                }
                else if(indexPath.row <3){
                    ZFSendingCell * shopCell = [self.allOrder_tableView dequeueReusableCellWithIdentifier:@"ZFSendingCellid" forIndexPath:indexPath];
                    
                    cell =shopCell;
                }else{
                   
                    ZFFooterCell* footCell = [self.allOrder_tableView dequeueReusableCellWithIdentifier:@"ZFFooterCellid" forIndexPath:indexPath];
                    
                    cell = footCell;

                }
        
            }
            if (indexPath.section == 1) {
               
                if (indexPath.row == 0) {
                    
                    ZFTitleCell *titleCell = [self.allOrder_tableView dequeueReusableCellWithIdentifier:@"ZFTitleCellid" forIndexPath:indexPath];
                    
                    cell = titleCell;
                }
                else if (indexPath.row == 1){
                    
                    ZFTitleCell *titleCell = [self.allOrder_tableView dequeueReusableCellWithIdentifier:@"ZFTitleCellid" forIndexPath:indexPath];
                    
                    cell = titleCell;
                    
                }
                else if(indexPath.row <3){
                    ZFSendingCell * shopCell = [self.allOrder_tableView dequeueReusableCellWithIdentifier:@"ZFSendingCellid" forIndexPath:indexPath];
                    
                    cell =shopCell;
                }else{
                    
                    ZFFooterCell* footCell = [self.allOrder_tableView dequeueReusableCellWithIdentifier:@"ZFFooterCellid" forIndexPath:indexPath];
                    
                    cell = footCell;
                    
                }
                
            }
            
            break;
        case OrderTypeWaitPay:  //待付款

                if (indexPath.section == 0){
                    
                    if (indexPath.row == 0) {
                        
                        ZFTitleCell *titleCell = [self.allOrder_tableView dequeueReusableCellWithIdentifier:@"ZFTitleCellid" forIndexPath:indexPath];
                        
                        cell = titleCell;
                    }
                    else if (indexPath.row == 1){
                        
                        ZFTitleCell *titleCell = [self.allOrder_tableView dequeueReusableCellWithIdentifier:@"ZFTitleCellid" forIndexPath:indexPath];
                        
                        cell = titleCell;
                        
                    }
                    else if(indexPath.row <3){
                        ZFSendingCell * shopCell = [self.allOrder_tableView dequeueReusableCellWithIdentifier:@"ZFSendingCellid" forIndexPath:indexPath];
                        
                        cell =shopCell;
                    }else{
                        
                        ZFFooterCell* footCell = [self.allOrder_tableView dequeueReusableCellWithIdentifier:@"ZFFooterCellid" forIndexPath:indexPath];
                        
                        cell = footCell;
                        
                    }
                    
                }
                if (indexPath.section == 1) {
                    
                    if (indexPath.row == 0) {
                        
                        ZFTitleCell *titleCell = [self.allOrder_tableView dequeueReusableCellWithIdentifier:@"ZFTitleCellid" forIndexPath:indexPath];
                        
                        cell = titleCell;
                    }
                    else if (indexPath.row == 1){
                        
                        ZFTitleCell *titleCell = [self.allOrder_tableView dequeueReusableCellWithIdentifier:@"ZFTitleCellid" forIndexPath:indexPath];
                        
                        cell = titleCell;
                        
                    }
                    else if(indexPath.row <3){
                        ZFSendingCell * shopCell = [self.allOrder_tableView dequeueReusableCellWithIdentifier:@"ZFSendingCellid" forIndexPath:indexPath];
                        
                        cell =shopCell;
                    }else{
                        
                        ZFFooterCell* footCell = [self.allOrder_tableView dequeueReusableCellWithIdentifier:@"ZFFooterCellid" forIndexPath:indexPath];
                        
                        cell = footCell;
                        
                    }
                    
                }
            
            break;
        case OrderTypeWaitSend: //待配送
            
            if (indexPath.section == 0){
                
                if (indexPath.row == 0) {
                    
                    ZFTitleCell *titleCell = [self.allOrder_tableView dequeueReusableCellWithIdentifier:@"ZFTitleCellid" forIndexPath:indexPath];
                    
                    cell = titleCell;
                }
                else if (indexPath.row == 1){
                    
                    ZFTitleCell *titleCell = [self.allOrder_tableView dequeueReusableCellWithIdentifier:@"ZFTitleCellid" forIndexPath:indexPath];
                    
                    cell = titleCell;
                    
                }
                else if(indexPath.row <3){
                    ZFSendingCell * shopCell = [self.allOrder_tableView dequeueReusableCellWithIdentifier:@"ZFSendingCellid" forIndexPath:indexPath];
                    
                    cell =shopCell;
                }else{
                    
                    ZFFooterCell* footCell = [self.allOrder_tableView dequeueReusableCellWithIdentifier:@"ZFFooterCellid" forIndexPath:indexPath];
                    
                    cell = footCell;
                    
                }
                
            }
            if (indexPath.section == 1) {
                
                if (indexPath.row == 0) {
                    
                    ZFTitleCell *titleCell = [self.allOrder_tableView dequeueReusableCellWithIdentifier:@"ZFTitleCellid" forIndexPath:indexPath];
                    
                    cell = titleCell;
                }
                else if (indexPath.row == 1){
                    
                    ZFTitleCell *titleCell = [self.allOrder_tableView dequeueReusableCellWithIdentifier:@"ZFTitleCellid" forIndexPath:indexPath];
                    
                    cell = titleCell;
                    
                }
                else if(indexPath.row <3){
                    ZFSendingCell * shopCell = [self.allOrder_tableView dequeueReusableCellWithIdentifier:@"ZFSendingCellid" forIndexPath:indexPath];
                    
                    cell =shopCell;
                }else{
                    
                    ZFFooterCell* footCell = [self.allOrder_tableView dequeueReusableCellWithIdentifier:@"ZFFooterCellid" forIndexPath:indexPath];
                    
                    cell = footCell;
                    
                }
                
            }
            break;
        case OrderTypeSending://配送中
            
            
            if (indexPath.section == 0){
                
                if (indexPath.row == 0) {
                    
                    ZFTitleCell *titleCell = [self.allOrder_tableView dequeueReusableCellWithIdentifier:@"ZFTitleCellid" forIndexPath:indexPath];
                    
                    cell = titleCell;
                }
                else if (indexPath.row == 1){
                    
                    ZFTitleCell *titleCell = [self.allOrder_tableView dequeueReusableCellWithIdentifier:@"ZFTitleCellid" forIndexPath:indexPath];
                    
                    cell = titleCell;
                    
                }
                else if(indexPath.row <3){
                    ZFSendingCell * shopCell = [self.allOrder_tableView dequeueReusableCellWithIdentifier:@"ZFSendingCellid" forIndexPath:indexPath];
                    
                    cell =shopCell;
                }else{
                    
                    ZFFooterCell* footCell = [self.allOrder_tableView dequeueReusableCellWithIdentifier:@"ZFFooterCellid" forIndexPath:indexPath];
                    
                    cell = footCell;
                    
                }
                
            }
            if (indexPath.section == 1) {
                
                if (indexPath.row == 0) {
                    
                    ZFTitleCell *titleCell = [self.allOrder_tableView dequeueReusableCellWithIdentifier:@"ZFTitleCellid" forIndexPath:indexPath];
                    
                    cell = titleCell;
                }
                else if (indexPath.row == 1){
                    
                    ZFTitleCell *titleCell = [self.allOrder_tableView dequeueReusableCellWithIdentifier:@"ZFTitleCellid" forIndexPath:indexPath];
                    
                    cell = titleCell;
                    
                }
                else if(indexPath.row <3){
                    ZFSendingCell * shopCell = [self.allOrder_tableView dequeueReusableCellWithIdentifier:@"ZFSendingCellid" forIndexPath:indexPath];
                    
                    cell =shopCell;
                }else{
                    
                    ZFFooterCell* footCell = [self.allOrder_tableView dequeueReusableCellWithIdentifier:@"ZFFooterCellid" forIndexPath:indexPath];
                    
                    cell = footCell;
                    
                }
                
            }
            break;
        case OrderTypeSended://已经配送
            
            if (indexPath.section == 0){
                
                if (indexPath.row == 0) {
                    
                    ZFTitleCell *titleCell = [self.allOrder_tableView dequeueReusableCellWithIdentifier:@"ZFTitleCellid" forIndexPath:indexPath];
                    
                    cell = titleCell;
                }
                else if (indexPath.row == 1){
                    
                    ZFTitleCell *titleCell = [self.allOrder_tableView dequeueReusableCellWithIdentifier:@"ZFTitleCellid" forIndexPath:indexPath];
                    
                    cell = titleCell;
                    
                }
                else if(indexPath.row <3){
                    ZFSendingCell * shopCell = [self.allOrder_tableView dequeueReusableCellWithIdentifier:@"ZFSendingCellid" forIndexPath:indexPath];
                    
                    cell =shopCell;
                }else{
                    
                    ZFFooterCell* footCell = [self.allOrder_tableView dequeueReusableCellWithIdentifier:@"ZFFooterCellid" forIndexPath:indexPath];
                    
                    cell = footCell;
                    
                }
                
            }
            if (indexPath.section == 1) {
                
                if (indexPath.row == 0) {
                    
                    ZFTitleCell *titleCell = [self.allOrder_tableView dequeueReusableCellWithIdentifier:@"ZFTitleCellid" forIndexPath:indexPath];
                    
                    cell = titleCell;
                }
                else if (indexPath.row == 1){
                    
                    ZFTitleCell *titleCell = [self.allOrder_tableView dequeueReusableCellWithIdentifier:@"ZFTitleCellid" forIndexPath:indexPath];
                    
                    cell = titleCell;
                    
                }
                else if(indexPath.row <3){
                    ZFSendingCell * shopCell = [self.allOrder_tableView dequeueReusableCellWithIdentifier:@"ZFSendingCellid" forIndexPath:indexPath];
                    
                    cell =shopCell;
                }else{
                    
                    ZFFooterCell* footCell = [self.allOrder_tableView dequeueReusableCellWithIdentifier:@"ZFFooterCellid" forIndexPath:indexPath];
                    
                    cell = footCell;
                    
                }
                
            }
            
            break;
        case OrderTypeDealSuccess://交易成功
            
            if (indexPath.section == 0){
                
                if (indexPath.row == 0) {
                    
                    ZFTitleCell *titleCell = [self.allOrder_tableView dequeueReusableCellWithIdentifier:@"ZFTitleCellid" forIndexPath:indexPath];
                    
                    cell = titleCell;
                }
                else if (indexPath.row == 1){
                    
                    ZFTitleCell *titleCell = [self.allOrder_tableView dequeueReusableCellWithIdentifier:@"ZFTitleCellid" forIndexPath:indexPath];
                    
                    cell = titleCell;
                    
                }
                else if(indexPath.row <3){
                    ZFSendingCell * shopCell = [self.allOrder_tableView dequeueReusableCellWithIdentifier:@"ZFSendingCellid" forIndexPath:indexPath];
                    
                    cell =shopCell;
                }else{
                    
                    ZFFooterCell* footCell = [self.allOrder_tableView dequeueReusableCellWithIdentifier:@"ZFFooterCellid" forIndexPath:indexPath];
                    
                    cell = footCell;
                    
                }
                
            }
            if (indexPath.section == 1) {
                
                if (indexPath.row == 0) {
                    
                    ZFTitleCell *titleCell = [self.allOrder_tableView dequeueReusableCellWithIdentifier:@"ZFTitleCellid" forIndexPath:indexPath];
                    
                    cell = titleCell;
                }
                else if (indexPath.row == 1){
                    
                    ZFTitleCell *titleCell = [self.allOrder_tableView dequeueReusableCellWithIdentifier:@"ZFTitleCellid" forIndexPath:indexPath];
                    
                    cell = titleCell;
                    
                }
                else if(indexPath.row <3){
                    ZFSendingCell * shopCell = [self.allOrder_tableView dequeueReusableCellWithIdentifier:@"ZFSendingCellid" forIndexPath:indexPath];
                    
                    cell =shopCell;
                }else{
                    
                    ZFFooterCell* footCell = [self.allOrder_tableView dequeueReusableCellWithIdentifier:@"ZFFooterCellid" forIndexPath:indexPath];
                    
                    cell = footCell;
                    
                }
                
            }
            
            break;
        case OrderTypeCancelSuccess://交易取消
            
            if (indexPath.section == 0){
                
                if (indexPath.row == 0) {
                    
                    ZFTitleCell *titleCell = [self.allOrder_tableView dequeueReusableCellWithIdentifier:@"ZFTitleCellid" forIndexPath:indexPath];
                    
                    cell = titleCell;
                }
                else if (indexPath.row == 1){
                    
                    ZFTitleCell *titleCell = [self.allOrder_tableView dequeueReusableCellWithIdentifier:@"ZFTitleCellid" forIndexPath:indexPath];
                    
                    cell = titleCell;
                    
                }
                else if(indexPath.row <3){
                    ZFSendingCell * shopCell = [self.allOrder_tableView dequeueReusableCellWithIdentifier:@"ZFSendingCellid" forIndexPath:indexPath];
                    
                    cell =shopCell;
                }else{
                    
                    ZFFooterCell* footCell = [self.allOrder_tableView dequeueReusableCellWithIdentifier:@"ZFFooterCellid" forIndexPath:indexPath];
                    
                    cell = footCell;
                    
                }
                
            }
            if (indexPath.section == 1) {
                
                if (indexPath.row == 0) {
                    
                    ZFTitleCell *titleCell = [self.allOrder_tableView dequeueReusableCellWithIdentifier:@"ZFTitleCellid" forIndexPath:indexPath];
                    
                    cell = titleCell;
                }
                else if (indexPath.row == 1){
                    
                    ZFTitleCell *titleCell = [self.allOrder_tableView dequeueReusableCellWithIdentifier:@"ZFTitleCellid" forIndexPath:indexPath];
                    
                    cell = titleCell;
                    
                }
                else if(indexPath.row <3){
                    ZFSendingCell * shopCell = [self.allOrder_tableView dequeueReusableCellWithIdentifier:@"ZFSendingCellid" forIndexPath:indexPath];
                    
                    cell =shopCell;
                }else{
                    
                    ZFFooterCell* footCell = [self.allOrder_tableView dequeueReusableCellWithIdentifier:@"ZFFooterCellid" forIndexPath:indexPath];
                    
                    cell = footCell;
                    
                }
                
            }
            break;
        case OrderTypeAfterSale://售后服务
            
            if (self.tagNum == 0) {
                if (indexPath.section == 0){
                    if (indexPath.row ==0) {
                        
                        ZFSaleAfterSearchCell* searchCell = [self.allOrder_tableView dequeueReusableCellWithIdentifier:saleAfterSearchCellid forIndexPath:indexPath];
                        
                        cell = searchCell;
                    }else if (indexPath.row ==1 )
                    {
                        ZFSaleAfterHeadCell* HeadCell = [self.allOrder_tableView dequeueReusableCellWithIdentifier:saleAfterHeadCellid forIndexPath:indexPath];
                        cell = HeadCell;
                        
                    }else{
                        ZFSaleAfterContentCell* contentell = [self.allOrder_tableView dequeueReusableCellWithIdentifier:saleAfterContentCellid forIndexPath:indexPath];
                        
                        cell = contentell;
                    }
                    
                }
                if (indexPath.section == 1) {
                    if (indexPath.row ==0) {
                        
                        ZFSaleAfterHeadCell* HeadCell = [self.allOrder_tableView dequeueReusableCellWithIdentifier:saleAfterHeadCellid forIndexPath:indexPath];
                        
                        cell = HeadCell;
                    }else{
                        
                        ZFSaleAfterContentCell* contentell = [self.allOrder_tableView dequeueReusableCellWithIdentifier:saleAfterContentCellid forIndexPath:indexPath];
                        contentell.delegate =self;
                        cell = contentell;
                    }
                    
                }

            }else{
                ZFCheckTheProgressCell *checkCell = [self.allOrder_tableView dequeueReusableCellWithIdentifier:saleAfterProgressCellid forIndexPath:indexPath];
                checkCell.deldegate =self;
                cell = checkCell;

            }
            
            break;
    }

    
    return cell;
    

    
}
#pragma mark - tableView datasource
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@" section = %ld ， row = %ld",indexPath.section,indexPath.row);
 
    ZFDetailOrderViewController * detailVc =[[ ZFDetailOrderViewController alloc]init];
    [self.navigationController pushViewController:detailVc animated:YES];
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

/**
 正选反选
 @param btn 切换
 */
-(void)navigationBarSelectedOther:(UIButton *)btn;
{
  

    [self.view addSubview:self.bgview];;

  
}


/**
 确认付款
 @param clearbtn pay
 */
-(void)didClickClearing:(UIButton *)clearbtn
{
    
}

#pragma mark - ZFpopViewDelegate
-(void)sendTitle:(NSString *)title orderType:(OrderType)type
{
 
    [UIView animateWithDuration:0.3 animations:^{
        if (self.bgview.superview) {
            [self.bgview removeFromSuperview];

        }
    }];
    
    _orderType = type;
    
    [self.navbar_btn setTitle:title forState:UIControlStateNormal];
//    if (_orderType ==OrderTypeAfterSale ) {
//        
//        
//     }
    [self.allOrder_tableView reloadData];

}

#pragma mark - ZFSaleAfterTopViewDelegate   售后申请的2种状态
-(void)sendAtagNum:(NSInteger)tagNum
{
    self.tagNum = tagNum;
    if (tagNum == 0) {
        
        NSLog(@"申请售后,刷新列表tagnum = %ld",tagNum);
        [self.allOrder_tableView reloadData];
        
    
    }else{
        NSLog(@"进度查询,刷新列表tagnum = %ld",tagNum);
       
        [self.allOrder_tableView reloadData];


    }
}

#pragma mark - ZFCheckTheProgressCellDelegate 查询进度
-(void)progressWithCheckout
{
    ZFPregressCheckViewController * checkVC = [[ZFPregressCheckViewController alloc]init];
    [self.navigationController pushViewController:checkVC animated:YES];
}
#pragma mark - ZFSaleAfterContentCellDelegate 申请售后
-(void)salesAfterDetailPage{
    
}
@end
