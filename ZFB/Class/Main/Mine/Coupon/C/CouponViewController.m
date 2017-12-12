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
#import "CouponFooterView.h"
#import "CQPlaceholderView.h"

//model
#import "CouponModel.h"

#define  k_cellHeight  112


typedef NS_ENUM(NSUInteger, SelectCouponType) {
    
    SelectCouponTypeDefault,//未使用
    SelectCouponTypeUsed,//已使用
    SelectCouponTypeOverDate,//已过期
};

@interface CouponViewController ()<MTSegmentedControlDelegate,UITableViewDataSource,UITableViewDelegate,CouponTableViewDelegate,CouponFooterViewDelegate,CouponCellDelegate,CouponUsedCellDelegate,CouponOverDateCellDelegate>

@property (strong, nonatomic) MTSegmentedControl * segumentView;
@property (strong, nonatomic) UITableView        * tableView;
@property (assign, nonatomic) SelectCouponType     couponType;
@property (strong, nonatomic) CouponTableView    * popCouponView;
@property (strong, nonatomic) UIView             * popCouponBackgroundView;//背景图
@property (strong, nonatomic) UIButton           * edit_btn;
@property (strong, nonatomic) NSMutableArray     * couponList;//可领取的优惠券
@property (strong, nonatomic) NSMutableArray     * outSideCouponList;//外部优惠券列表

@property (strong, nonatomic) CouponFooterView   * couponFootView;
@property (assign, nonatomic) BOOL  isEditing;//编辑状态
@property (strong, nonatomic) NSString    * couponIdAppdding;
@property (nonatomic , strong) CQPlaceholderView *placeholderView;


@end

@implementation CouponViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"优惠券";
    
    [self setupPageView];
    
    self.zfb_tableView = self.tableView;
    [self.view addSubview:self.tableView];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"SectionCouponCell" bundle:nil]
         forCellReuseIdentifier:@"SectionCouponCellid"];
    [self.tableView registerNib:[UINib nibWithNibName:@"CouponCell" bundle:nil]
         forCellReuseIdentifier:@"CouponCellid"];
    [self.tableView registerNib:[UINib nibWithNibName:@"CouponUsedCell" bundle:nil]
         forCellReuseIdentifier:@"CouponUsedCellid"];
    [self.tableView registerNib:[UINib nibWithNibName:@"CouponOverDateCell" bundle:nil] forCellReuseIdentifier:@"CouponOverDateCellid"];
    [self.tableView registerNib:[UINib nibWithNibName:@"EditCouponCell" bundle:nil]
         forCellReuseIdentifier:@"EditCouponCellid"];
    
    [self setupRefresh];

    //默认0 未领取  1 未使用  2 已使用 3 已失效
    [self recommentPostRequst:@"1"];
    
    _isEditing = NO; //默认未编辑状态
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
-(CouponFooterView *)couponFootView
{
    if (!_couponFootView) {
        _couponFootView = [[CouponFooterView alloc ]initWithCouponFooterViewFrame:CGRectMake(0, KScreenH -50 -64, KScreenW, 50)];
        _couponFootView.delegate  = self;
    }
    return _couponFootView;
}
-(UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 44, KScreenW, KScreenH  - 44 - 50) style:UITableViewStylePlain
                      ];
        _tableView.delegate       = self;
        _tableView.dataSource     = self;
        _tableView.estimatedRowHeight = 0;
        _tableView.separatorStyle = UITableViewCellSelectionStyleNone;
    }
    return _tableView;
}
-(NSMutableArray *)outSideCouponList{
    
    if (!_outSideCouponList) {
        _outSideCouponList = [NSMutableArray array];
    }
    return _outSideCouponList;
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
        _popCouponView             = [[CouponTableView alloc]initWithFrame:CGRectMake(0, 200, KScreenW, KScreenH - 200- 64) style:UITableViewStylePlain];
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
    [_edit_btn setTitleColor:HEXCOLOR(0x333333)  forState:UIControlStateNormal];
    _edit_btn.titleLabel.textAlignment = NSTextAlignmentRight;
    CGSize size                        = [saveStr sizeWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:SYSTEMFONT(14),NSFontAttributeName, nil]];
    CGFloat width                      = size.width ;
    _edit_btn.frame                    = CGRectMake(0, 0, width+10, 22);
//    [_edit_btn addTarget:self action:@selector(didClickEditing:) forControlEvents:UIControlEventTouchUpInside];
    return _edit_btn;
}

- (void)setupPageView {
    NSString * unuserd  = @"未使用";
    NSString * used     = @"已使用";
    NSString * overdate = @"已过期";
    NSArray *titleArr   = @[unuserd,used,overdate];
    _segumentView       = [[MTSegmentedControl alloc]initWithFrame:CGRectMake(0, 0, KScreenW, 44)];
    [self.segumentView segmentedControl:titleArr Delegate:self];
    [self.view addSubview:_segumentView];
}


#pragma mark - <MTSegmentedControlDelegate> 切换
- (void)segumentSelectionChange:(NSInteger)selection
{
    _couponType = selection ;
    self.currentPage = 1;
    [self.couponList removeAllObjects];
    
    switch (_couponType) {
        case SelectCouponTypeDefault://未使用
            
            //获取用户优惠券列表
            [self recommentPostRequst:@"1"];
            break;
        case SelectCouponTypeUsed://已使用
            
            //获取用户优惠券列表
            [self recommentPostRequst:@"2"];
            
            break;
        case SelectCouponTypeOverDate://已过期
            
            [self recommentPostRequst:@"3"];
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
                numRow = self.outSideCouponList.count;
            }
            break;
        case SelectCouponTypeUsed://已使用
            numRow = self.outSideCouponList.count;
            break;
        case SelectCouponTypeOverDate://已过期
            numRow = self.outSideCouponList.count;
            
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
                height = k_cellHeight;
            }
            break;
        case SelectCouponTypeUsed:
            
            height = k_cellHeight;
            
            break;
        case SelectCouponTypeOverDate:
            height = k_cellHeight;
            
            break;
        default:
            break;
    }
    
    return height;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //编辑状态
    if (_isEditing == NO) {
        switch (_couponType) {
            case SelectCouponTypeDefault:
            {
                if (indexPath.section == 0) {
                    
                    SectionCouponCell * sectionCell = [ self.tableView dequeueReusableCellWithIdentifier:@"SectionCouponCellid" forIndexPath:indexPath];
                    sectionCell.lb_title.text = @"您有待领取的优惠券";
                    return sectionCell;
                }
                
                CouponCell * couponCell = [ self.tableView dequeueReusableCellWithIdentifier:@"CouponCellid" forIndexPath:indexPath];
                couponCell.couponDelegate = self;
                Couponlist * list       = self.outSideCouponList[indexPath.row];
                couponCell.buttonWidthConstraint.constant = 0;
                couponCell.couponlist   = list;
                return couponCell;
            }
                break;
            case SelectCouponTypeUsed:{
                
                CouponCell * couponCell = [ self.tableView dequeueReusableCellWithIdentifier:@"CouponCellid" forIndexPath:indexPath];
                couponCell.couponDelegate = self;
                Couponlist * list       = self.outSideCouponList[indexPath.row];
                couponCell.buttonWidthConstraint.constant = 0;
                couponCell.couponlist   = list;
                return couponCell;
            }
                break;
            case SelectCouponTypeOverDate:
            {
                CouponCell * couponCell = [ self.tableView dequeueReusableCellWithIdentifier:@"CouponCellid" forIndexPath:indexPath];
                couponCell.couponDelegate = self;
                Couponlist * list       = self.outSideCouponList[indexPath.row];
                couponCell.buttonWidthConstraint.constant = 0;
                couponCell.couponlist   = list;
                return couponCell;
            }
                break;
        }
    }
    else{//如果为编辑状态
        switch (_couponType) {
            case SelectCouponTypeDefault:
            {
                if (indexPath.section == 0) {
                    
                    SectionCouponCell * sectionCell = [ self.tableView dequeueReusableCellWithIdentifier:@"SectionCouponCellid" forIndexPath:indexPath];
                    sectionCell.lb_title.text = @"您有待领取的优惠券";
                    return sectionCell;
                }
                
                CouponCell * couponCell = [ self.tableView dequeueReusableCellWithIdentifier:@"CouponCellid" forIndexPath:indexPath];
                couponCell.couponDelegate = self;
                Couponlist * list       = self.outSideCouponList[indexPath.row];
                couponCell.buttonWidthConstraint.constant = 30;
                couponCell.couponlist   = list;

                return couponCell;
            }
                break;
            case SelectCouponTypeUsed:{
                
                CouponCell * couponCell = [ self.tableView dequeueReusableCellWithIdentifier:@"CouponCellid" forIndexPath:indexPath];
                couponCell.couponDelegate = self;
                Couponlist * list       = self.outSideCouponList[indexPath.row];
                couponCell.buttonWidthConstraint.constant = 30;
                couponCell.couponlist   = list;
                
                return couponCell;
            }
                break;
            case SelectCouponTypeOverDate:
            {
                CouponCell * couponCell = [ self.tableView dequeueReusableCellWithIdentifier:@"CouponCellid" forIndexPath:indexPath];
                couponCell.couponDelegate = self;
                Couponlist * list       = self.outSideCouponList[indexPath.row];
                couponCell.couponlist   = list;
                couponCell.buttonWidthConstraint.constant = 30;

                return couponCell;
            }
                break;
        }

    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"%ld -  %ld",indexPath.section,indexPath.row);
    
    switch (_couponType) {
        case SelectCouponTypeDefault://未使用
            if (indexPath.section == 0) {
                
                //获取用户优惠券列表
                [self recommentPostRequst:@"0"];
                [self.tableView reloadData];

            }
            break;
        case SelectCouponTypeUsed://已使用
            
            
            break;
        case SelectCouponTypeOverDate://已过期
            

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
-(void)selectCouponWithIndex:(NSInteger)indexRow AndCouponId :(NSString *)couponId withResult:(NSString *)result
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
            if ([status isEqualToString:@"0"]) {//查询未领取列表
                
                if (self.couponList.count > 0) {
                    [self.couponList removeAllObjects];
                }
                CouponModel * coupon = [CouponModel mj_objectWithKeyValues:response];
                for (Couponlist * list in coupon.couponList) {
                    [self.couponList addObject:list];
                }
                [self.view addSubview:self.popCouponBackgroundView];
                [self.tableView bringSubviewToFront:self.popCouponBackgroundView];
                
                [_placeholderView removeFromSuperview];
                if ([self isEmptyArray:self.couponList]) {
                    _placeholderView = [[CQPlaceholderView alloc]initWithFrame:CGRectMake(0, 50+64, KScreenH, KScreenH - 50+64) type:CQPlaceholderViewTypeNoCoupon delegate:self];
                    [self.tableView addSubview:_placeholderView];
                }

                [SVProgressHUD dismiss];
                [self.popCouponView reloadData];

            }else{//如果不为0只刷新外部
                if (self.refreshType == RefreshTypeHeader) {
                    if (self.outSideCouponList.count > 0) {
                        [self.outSideCouponList removeAllObjects];
                    }
                }
                CouponModel * coupon = [CouponModel mj_objectWithKeyValues:response];
                for (Couponlist * list in coupon.couponList) {
                    [self.outSideCouponList addObject:list];
                }
                [_placeholderView removeFromSuperview];
                if ([self isEmptyArray:self.couponList]) {
                    _placeholderView = [[CQPlaceholderView alloc]initWithFrame:CGRectMake(0, 50+64, KScreenH, KScreenH - 50+64) type:CQPlaceholderViewTypeNoCoupon delegate:self];
                    [self.tableView addSubview:_placeholderView];
                }
                [self.tableView reloadData];
                [SVProgressHUD dismiss];
            }
        }
        [self endRefresh];
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
                             @"userName":BBUserDefault.nickName,
                             @"userPhone":BBUserDefault.userPhoneNumber,
                             @"couponId":couponId,
                             @"userId":BBUserDefault.cmUserId,
                             };
    [SVProgressHUD show];
    [MENetWorkManager post:[zfb_baseUrl stringByAppendingString:@"/recomment/receiveCoupon"] params:parma success:^(id response) {
        NSString * code = [NSString stringWithFormat:@"%@",response[@"resultCode"]];
        if ([code isEqualToString:@"0"] ) {
            
            [self.view makeToast:@"领取优惠券成功" duration:2 position:@"center"];
            [self recommentPostRequst:@"1"];

            [self.popCouponView reloadData];
            [self didClickCloseCouponView];

            //成功后请求下未使用列表
            [SVProgressHUD dismiss];
        }
        else
        {
            [self.view makeToast:response[@"resultMsg"] duration:2 position:@"center"];
        }
        
    } progress:^(NSProgress *progeress) {
        
    } failure:^(NSError *error) {

        [SVProgressHUD dismiss];
        NSLog(@"error=====%@",error);
        [self.view makeToast:@"网络错误" duration:2 position:@"center"];
    }];
    
}


#pragma mark - 删除优惠券    recomment/deleteCoupons status0 未领取 1 未使用 2 已使用 3 已失效
-(void)deleteCouponesPostRequstCouponId:(NSString *)couponId Andstatus:(NSString *)status
{
    NSDictionary * parma = @{
                             
                             @"couponIds":couponId,//json字符串
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

#pragma mark -  点击编辑
-(void)right_button_event:(UIButton*)sender{
    
    _edit_btn = sender;
    _edit_btn.selected = !_edit_btn.selected;
    
    if (_edit_btn.selected == YES) {
        _isEditing = YES;
        [_edit_btn setTitle:@"完成" forState:UIControlStateNormal];
        [self.view addSubview:self.couponFootView];
        [self.tableView reloadData];
        NSLog(@"点击编辑");
    }else{
        sender.selected =NO;
        _isEditing = NO;
        [_edit_btn setTitle:@"编辑" forState:UIControlStateNormal];
        
        if (self.couponFootView.superview) {
            [self.couponFootView removeFromSuperview];
        }
        [self.tableView reloadData];
        NSLog(@"点击完成");
        
    }
}
#pragma mark - 点击删除的方法 (暂时没有处理，删除事件没有写好)
-(void)didClickDeleteCoupon
{
    NSMutableArray * tempCellArray = [NSMutableArray array];
    switch (_couponType) {
        case SelectCouponTypeDefault://未使用
         
            for (Couponlist * list in self.outSideCouponList)
            {
                if (list.isChoosedCoupon)
                {
                    [tempCellArray addObject:list];
                }
            }
            [self.outSideCouponList removeObjectsInArray:tempCellArray];
            [self deleteCouponesPostRequstCouponId:_couponIdAppdding Andstatus:@"1"];
            [self.tableView reloadData];
          
            break;
        case SelectCouponTypeUsed://已使用
            
            for (Couponlist * list in self.outSideCouponList)
            {
                if (list.isChoosedCoupon)
                {
                    [tempCellArray addObject:list];
                }
            }
            [self.outSideCouponList removeObjectsInArray:tempCellArray];
            [self deleteCouponesPostRequstCouponId:_couponIdAppdding Andstatus:@"2"];
            [self.tableView reloadData];
            
            break;
        case SelectCouponTypeOverDate://已过期
            for (Couponlist * list in self.outSideCouponList)
            {
                if (list.isChoosedCoupon)
                {
                    [tempCellArray addObject:list];
                }
            }
            [self.outSideCouponList removeObjectsInArray:tempCellArray];
            [self deleteCouponesPostRequstCouponId:_couponIdAppdding Andstatus:@"3"];
            [self.tableView reloadData];
            
            break;
        default:
            break;
    }
}

#pragma mark-  CouponFooterViewDelegate - 优惠券foot代理
//取消删除-取消编辑状态
-(void)didClickCancle
{
    for (Couponlist * lists in self.outSideCouponList) {
        lists.isChoosedCoupon = NO;
    }
    self.couponFootView.selectBtn.selected = NO;
    
}
///批量删除
-(void)didClickDeleteSelectCouponCell
{
    JXTAlertController * alertVC = [JXTAlertController alertControllerWithTitle:@"确认删除？" message:nil preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction * cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    UIAlertAction * sure = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
       
        [self didClickDeleteCoupon];
    }];
    
    [alertVC addAction:cancel];
    [alertVC addAction:sure];
    [self presentViewController:alertVC animated:YES completion:nil];
}
///全选
-(void)didClickSelectAll:(UIButton *)sender
{
    sender.selected = !sender.selected;
    NSMutableArray * chooseArray = [NSMutableArray array];
    for (Couponlist * list in self.outSideCouponList) {
        list.isChoosedCoupon = sender.selected;
        //如果为选中
        if (list.isChoosedCoupon) {
        
            [chooseArray addObject:[NSString stringWithFormat:@"%ld",list.couponId]];
        }
    }
    _couponIdAppdding = [chooseArray componentsJoinedByString:@","];
    NSLog(@"选中全部的 id --- %@",_couponIdAppdding);
    [self.tableView reloadData];
    self.couponFootView.selectBtn.selected = [self isAllChoosed];

}
#pragma mark - <CouponCellDelegate>未使用 选择单个优惠券代理
-(void)selectCouponCell:(CouponCell *)couponCell;
{
    NSIndexPath * indexPath = [self.tableView indexPathForCell:couponCell];
    NSLog(@"%@ --- couponCell",indexPath);
    Couponlist * list     = self.outSideCouponList[indexPath.row];
    list.isChoosedCoupon = !list.isChoosedCoupon;
    
    NSMutableArray * couponIdArray = [NSMutableArray array];
    for (Couponlist * lists in self.outSideCouponList) {
        if (lists.isChoosedCoupon) {
            NSString *couponId = [NSString stringWithFormat:@"%ld",lists.couponId];
            [couponIdArray addObject:couponId];
        }
    }
    _couponIdAppdding = [couponIdArray componentsJoinedByString:@","];
    NSLog(@"选中之后的操作 -- %@",_couponIdAppdding);
    [self.tableView reloadData];
    self.couponFootView.selectBtn.selected = [self isAllChoosed];
    
}
#pragma mark - CouponUsedCellDelegate 已使用优惠券的代理
-(void)didUnsedCouponCell:(CouponUsedCell *)cell
{
    NSIndexPath * indexPath = [self.tableView indexPathForCell:cell];
    Couponlist * list     = self.outSideCouponList[indexPath.row];
    list.isChoosedCoupon = !list.isChoosedCoupon;
    NSMutableArray * couponIdArray = [NSMutableArray array];
    for (Couponlist * lists in self.outSideCouponList) {
        if (lists.isChoosedCoupon) {
            NSString *couponId = [NSString stringWithFormat:@"%ld",lists.couponId];
            [couponIdArray addObject:couponId];
        }
    }
    _couponIdAppdding = [couponIdArray componentsJoinedByString:@","];
    NSLog(@"选中之后的操作 -- %@",_couponIdAppdding);
    [self.tableView reloadData];
    self.couponFootView.selectBtn.selected = [self isAllChoosed];
}
#pragma mark - CouponOverDateCellDelegate 已过期优惠券的代理
-(void)didCouponOverDateCell:(CouponOverDateCell *)cell
{
    NSIndexPath * indexPath = [self.tableView indexPathForCell:cell];
    Couponlist * list     = self.outSideCouponList[indexPath.row];
    list.isChoosedCoupon = !list.isChoosedCoupon;
    NSMutableArray * couponIdArray = [NSMutableArray array];
    for (Couponlist * lists in self.outSideCouponList) {
        if (lists.isChoosedCoupon) {
            NSString *couponId = [NSString stringWithFormat:@"%ld",lists.couponId];
            [couponIdArray addObject:couponId];
        }
    }
    _couponIdAppdding = [couponIdArray componentsJoinedByString:@","];
    NSLog(@"选中之后的操作 -- %@",_couponIdAppdding);
    [self.tableView reloadData];
    self.couponFootView.selectBtn.selected = [self isAllChoosed];
}
#pragma mark - footiew 判断是否全部选中了
- (BOOL)isAllChoosed
{
    if ([self isEmptyArray:self.outSideCouponList] ) {
        return NO;
    }
    
    NSInteger count = 0;
    for (Couponlist * list in self.outSideCouponList) {
        
        if (list.isChoosedCoupon) {
            count ++;
        }
    }
    return (count == self.outSideCouponList.count);
}


-(void)dealloc
{
    self.popCouponView = nil;
}
-(void)viewWillAppear:(BOOL)animated{
    
    [self settingNavBarBgName:@"nav64_gray"];
    
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


