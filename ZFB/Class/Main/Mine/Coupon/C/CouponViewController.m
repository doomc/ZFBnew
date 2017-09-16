//
//  CouponViewController.m
//  ZFB
//
//  Created by  展富宝  on 2017/9/13.
//  Copyright © 2017年 com.zfb. All rights reserved.
//

#import "CouponViewController.h"
#import "MTSegmentedControl.h"

//cell
#import "CouponCell.h"
#import "SectionCouponCell.h"
#import "CouponUsedCell.h"
#import "CouponOverDateCell.h"

//view
#import "CouponTableView.h"

//model
#import "CouponModel.h"

typedef NS_ENUM(NSUInteger, SelectCouponType) {
    SelectCouponTypeDefault,//未使用
    SelectCouponTypeUsed,//已使用
    SelectCouponTypeOverDate,//已过期
};

@interface CouponViewController ()<MTSegmentedControlDelegate,UITableViewDataSource,UITableViewDelegate,CouponTableViewDelegate>

@property (strong, nonatomic) MTSegmentedControl *segumentView;
@property (strong, nonatomic) UITableView        * tableView;
@property (assign, nonatomic) SelectCouponType   couponType;
@property (strong, nonatomic) CouponTableView    * popCouponView;
@property (strong, nonatomic) UIView             * popCouponBackgroundView;//背景图
@property (strong, nonatomic) UIButton           * edit_btn;
@property (strong, nonatomic) NSMutableArray     * couponList;



@end

@implementation CouponViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"优惠券";
    
    [self setupPageView];
    
    self.zfb_tableView = self.tableView;
    [self.view addSubview:self.tableView];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"SectionCouponCell" bundle:nil] forCellReuseIdentifier:@"SectionCouponCellid"];
    [self.tableView registerNib:[UINib nibWithNibName:@"CouponCell" bundle:nil] forCellReuseIdentifier:@"CouponCellid"];
    [self.tableView registerNib:[UINib nibWithNibName:@"CouponUsedCell" bundle:nil] forCellReuseIdentifier:@"CouponUsedCellid"];
    [self.tableView registerNib:[UINib nibWithNibName:@"CouponOverDateCell" bundle:nil] forCellReuseIdentifier:@"CouponOverDateCellid"];
    
    [self setupRefresh];
    //默认0 未领取  1 未使用  2 已使用 3 已失效
    [self recommentPostRequst:@"1"];
    
}
-(void)headerRefresh
{
    [super headerRefresh];
    switch (_couponType) {
        case SelectCouponTypeDefault://未使用
            [self recommentPostRequst:@"1"];

            break;
        case SelectCouponTypeUsed://已使用
            [self recommentPostRequst:@"2"];

            break;
        case SelectCouponTypeOverDate://已过期
            [self recommentPostRequst:@"3"];
            
            break;
        default:
            break;
    }

}
-(void)footerRefresh
{
    [super footerRefresh];
    switch (_couponType) {
        case SelectCouponTypeDefault://未使用
            [self recommentPostRequst:@"1"];
            
            break;
        case SelectCouponTypeUsed://已使用
            [self recommentPostRequst:@"2"];
            
            break;
        case SelectCouponTypeOverDate://已过期
            [self recommentPostRequst:@"3"];
            
            break;
        default:
            break;
    }

}
#pragma mark - 懒加载
-(UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 108, KScreenW, KScreenH - 64 - 44 - 50) style:UITableViewStylePlain
                      ];
        _tableView.delegate       = self;
        _tableView.dataSource     = self;
        _tableView.separatorStyle = UITableViewCellSelectionStyleNone;
    }
    return _tableView;
}
-(NSMutableArray *)couponList{
    if (!_couponList) {
        _couponList = [NSMutableArray array];
    }
    return _couponList;
}
-(UIView *)popCouponBackgroundView
{
    if (!_popCouponBackgroundView) {
        _popCouponBackgroundView                 = [[UIView alloc]initWithFrame:self.view.bounds];
        _popCouponBackgroundView.backgroundColor = RGBA(0, 0, 0, 0.2);
        [_popCouponBackgroundView addSubview:self.popCouponView];
    }
    return _popCouponBackgroundView;
}

-(CouponTableView *)popCouponView{
    if (!_popCouponView) {
        _popCouponView             = [[CouponTableView alloc]initWithFrame:CGRectMake(0, 200, KScreenW, KScreenH - 200 ) style:UITableViewStylePlain];
        _popCouponView.popDelegate = self;
        _popCouponView.couponesList = self.couponList;//获取到的数组传入内部
    }
    return _popCouponView;
}

//设置右边按键（如果没有右边 可以不重写）
-(UIButton*)set_rightButton
{
    NSString * saveStr = @"编辑";
    _edit_btn          = [[UIButton alloc]init];
    [_edit_btn setTitle:saveStr forState:UIControlStateNormal];
    _edit_btn.titleLabel.font = SYSTEMFONT(14);
    [_edit_btn setTitleColor:HEXCOLOR(0xfe6d6a)  forState:UIControlStateNormal];
    _edit_btn.titleLabel.textAlignment = NSTextAlignmentRight;
    CGSize size                        = [saveStr sizeWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:SYSTEMFONT(14),NSFontAttributeName, nil]];
    CGFloat width                      = size.width ;
    _edit_btn.frame                    = CGRectMake(0, 0, width+10, 22);
    [_edit_btn addTarget:self action:@selector(didClickEditing:) forControlEvents:UIControlEventTouchUpInside];
    return _edit_btn;
}

- (void)setupPageView {
    NSString * unuserd  = @"未使用(0)";
    NSString * used     = @"已使用(0)";
    NSString * overdate = @"已过期(0)";
    NSArray *titleArr   = @[unuserd,used,overdate];
    _segumentView       = [[MTSegmentedControl alloc]initWithFrame:CGRectMake(0, 64, KScreenW, 44)];
    [self.segumentView segmentedControl:titleArr Delegate:self];
    [self.view addSubview:_segumentView];
}


#pragma mark - <MTSegmentedControlDelegate>
- (void)segumentSelectionChange:(NSInteger)selection
{
    _couponType = selection ;
    
    switch (_couponType) {
        case SelectCouponTypeDefault://未使用
            
            [self.tableView reloadData];
            break;
        case SelectCouponTypeUsed://已使用
            [self.tableView reloadData];
            
            break;
        case SelectCouponTypeOverDate://已过期
            [self.tableView reloadData];
            
            break;
        default:
            break;
    }
    
}
#pragma mark - <UITableViewDataSource>
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    NSInteger numSection = 0;
    switch (_couponType) {
        case SelectCouponTypeDefault://未使用
            numSection  = 2;
            
            break;
        case SelectCouponTypeUsed://已使用
            numSection  = 1;
            
            break;
        case SelectCouponTypeOverDate://已过期
            numSection  = 1;
            
            break;
        default:
            break;
    }
    return numSection;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger numRow = 0;
    switch (_couponType) {
        case SelectCouponTypeDefault://未使用
            if (section == 0) {
                numRow = 1;
            }else{
                numRow = self.couponList.count;
            }
            break;
        case SelectCouponTypeUsed://已使用
            numRow = self.couponList.count;
            break;
        case SelectCouponTypeOverDate://已过期
            numRow = self.couponList.count;
            
            break;
        default:
            break;
    }
    return numRow;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat height = 0;
    switch (_couponType) {
        case SelectCouponTypeDefault:
            
            if (indexPath.section == 0) {
                height = 44;
            }
            else{
                height = 100;
            }
            break;
        case SelectCouponTypeUsed:
            
            height = 100;
            
            break;
        case SelectCouponTypeOverDate:
            height = 100;
            
            break;
        default:
            break;
    }
    
    return height;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (_couponType) {
        case SelectCouponTypeDefault:
        {
            if (indexPath.section == 0) {
                
                SectionCouponCell * sectionCell = [ self.tableView dequeueReusableCellWithIdentifier:@"SectionCouponCellid" forIndexPath:indexPath];
                return sectionCell;
            }
            
            CouponCell * couponCell = [ self.tableView dequeueReusableCellWithIdentifier:@"CouponCellid" forIndexPath:indexPath];
            Couponlist * list       = self.couponList[indexPath.row];
            couponCell.couponlist   = list;
            
            return couponCell;
        }
            break;
        case SelectCouponTypeUsed:{
            
            CouponUsedCell * cell = [ self.tableView dequeueReusableCellWithIdentifier:@"CouponUsedCellid" forIndexPath:indexPath];
            Couponlist * list     = self.couponList[indexPath.row];
            cell.couponlist       = list;
            return cell;
        }
            break;
        case SelectCouponTypeOverDate:
        {
            CouponOverDateCell * couponCell = [ self.tableView dequeueReusableCellWithIdentifier:@"CouponOverDateCellid" forIndexPath:indexPath];
            Couponlist * list               = self.couponList[indexPath.row];
            couponCell.couponlist           = list;
            return couponCell;
        }
            break;
    }
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"%ld -  %ld",indexPath.section,indexPath.row);
    
    switch (_couponType) {
        case SelectCouponTypeDefault://未使用
            if (indexPath.section == 0) {
                
                [self recommentPostRequst:@"0"];
                
            }
            [self.tableView reloadData];
            break;
        case SelectCouponTypeUsed://已使用
            [self.tableView reloadData];
            
            break;
        case SelectCouponTypeOverDate://已过期
            [self.tableView reloadData];
            
            break;
        default:
            break;
    }
}


#pragma mark- <CouponTableViewDelegate>
//  关闭弹框
-(void)didClickCloseCouponView
{
    [self.popCouponBackgroundView removeFromSuperview];
    [self.popCouponView  reloadData];
}
// 点击领取优惠券 (或 点击获取到改优惠券的信息)
-(void)selectCouponWithIndex:(NSInteger)indexRow withResult:(NSString *)result
{
    Couponlist * list = self.couponList[indexRow];
    [self getCouponesPostRequst:[NSString stringWithFormat:@"%ld",list.couponId]];
    
    NSLog(@" 优惠券列表 ---外部 couponId=%ld ------ %@",list.couponId,result);

    
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
    [self.popCouponBackgroundView removeFromSuperview];
    
}

#pragma mark - 编辑/完成
-(void)didClickEditing:(UIButton *) editing
{
    NSLog(@"%@",editing);
}

-(void)dealloc
{
    self.popCouponView = nil;
}


#pragma mark - 获取用户优惠券列表   recomment/getUserCouponList
-(void)recommentPostRequst:(NSString *)status
{
    //idType	number	0 平台 1 商家 2 商品 3 所有	否
    //resultId	number	平台编号/商店编号/商品编号	是
    // userId	number	领优惠券用户编号	否
    // status	number	0 未领取 1 未使用 2 已使用 3 已失效	否
    
    NSDictionary * parma = @{
                             @"idType":@"3",
                             @"resultId":@"",
                             @"userId":BBUserDefault.cmUserId,
                             @"status":status,
                             @"pageIndex":[NSNumber numberWithInteger:self.currentPage],
                             @"pageSize":[NSNumber numberWithInteger:kPageCount],
                             };
    [SVProgressHUD show];
    [MENetWorkManager post:[zfb_baseUrl stringByAppendingString:@"/recomment/getUserCouponList"] params:parma success:^(id response) {
        if ([response[@"resultCode"] isEqualToString:@"0"] ) {
           
            if (self.refreshType == RefreshTypeHeader) {
                if (self.couponList.count > 0) {
                    [self.couponList removeAllObjects];
                }
            }
            CouponModel * coupon = [CouponModel mj_objectWithKeyValues:response];
            for (Couponlist * list in coupon.couponList) {
                [self.couponList addObject:list];
            }
           
            if ([status isEqualToString:@"0"]) {
                
                [self.view addSubview:self.popCouponBackgroundView];
                [self.tableView bringSubviewToFront:self.popCouponBackgroundView];
                [self.popCouponView reloadData];
                
            }else{//如果不为0只刷新外部
                
                [self.tableView reloadData];
            }
            [SVProgressHUD dismiss];
            [self endRefresh];
        }
        
    } progress:^(NSProgress *progeress) {
        
    } failure:^(NSError *error) {
        [self endRefresh];
        [SVProgressHUD dismiss];
        NSLog(@"error=====%@",error);
        [self.view makeToast:@"网络错误" duration:2 position:@"center"];
    }];
    
}

#pragma mark - 点击领取优惠券    recomment/receiveCoupon
-(void)getCouponesPostRequst:(NSString *)couponId
{
    NSDictionary * parma = @{
 
                             @"couponId":couponId,
                             @"userId":BBUserDefault.cmUserId,
                             };
    [SVProgressHUD show];
    [MENetWorkManager post:[zfb_baseUrl stringByAppendingString:@"/recomment/receiveCoupon"] params:parma success:^(id response) {
        if ([response[@"resultCode"] isEqualToString:@"0"] ) {
            
            [self.view makeToast:@"领取优惠券成功" duration:2 position:@"center"];

            [SVProgressHUD dismiss];
        }
        
    } progress:^(NSProgress *progeress) {
        
    } failure:^(NSError *error) {

        [SVProgressHUD dismiss];
        NSLog(@"error=====%@",error);
        [self.view makeToast:@"网络错误" duration:2 position:@"center"];
    }];
    
}


#pragma mark - 编辑删除优惠券    recomment/deleteCoupons status0 未领取 1 未使用 2 已使用 3 已失效
-(void)deleteCouponesPostRequstCouponId:(NSString *)couponId Andstatus:(NSString *)status
{
    NSDictionary * parma = @{
                             
                             @"couponId":couponId,//json字符串
                             @"userId":BBUserDefault.cmUserId,
                             @"status":status,
                             
                             };
    [SVProgressHUD show];
    [MENetWorkManager post:[zfb_baseUrl stringByAppendingString:@"/recomment/deleteCoupons"] params:parma success:^(id response) {
        if ([response[@"resultCode"] isEqualToString:@"0"] ) {
            
            [self.view makeToast:@"删除成功" duration:2 position:@"center"];
            
            [SVProgressHUD dismiss];
        }
        
    } progress:^(NSProgress *progeress) {
        
    } failure:^(NSError *error) {
        
        [SVProgressHUD dismiss];
        NSLog(@"error=====%@",error);
        [self.view makeToast:@"网络错误" duration:2 position:@"center"];
    }];
    
}

#pragma mark - 点击删除的方法 (暂时没有处理，删除事件没有写好)
-(void)didClickDeleteCoupon
{
    switch (_couponType) {
        case SelectCouponTypeDefault://未使用
         
            [self deleteCouponesPostRequstCouponId:@"" Andstatus:@"1"];
            [self.tableView reloadData];
          
            break;
        case SelectCouponTypeUsed://已使用
         
            [self deleteCouponesPostRequstCouponId:@"" Andstatus:@"2"];

            [self.tableView reloadData];
            
            break;
        case SelectCouponTypeOverDate://已过期

            [self deleteCouponesPostRequstCouponId:@"" Andstatus:@"3"];

            [self.tableView reloadData];
            
            break;
        default:
            break;
    }
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

