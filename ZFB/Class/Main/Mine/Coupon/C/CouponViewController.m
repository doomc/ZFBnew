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

typedef NS_ENUM(NSUInteger, SelectCouponType) {
    SelectCouponTypeDefault,//未使用
    SelectCouponTypeUsed,//已使用
    SelectCouponTypeOverDate,//已过期
};
@interface CouponViewController ()<MTSegmentedControlDelegate,UITableViewDataSource,UITableViewDelegate,CouponTableViewDelegate>

@property (strong, nonatomic)  MTSegmentedControl *segumentView;
@property (strong, nonatomic)  UITableView * tableView;
@property (assign, nonatomic)  SelectCouponType couponType;
@property (strong, nonatomic)  CouponTableView * popCouponView;
@property (strong, nonatomic)  UIView * popCouponBackgroundView;//背景图
@property (strong, nonatomic)  UIButton * edit_btn;

@end

@implementation CouponViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"优惠券";
    
    [self setupPageView];
    
    [self.view addSubview:self.tableView];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"SectionCouponCell" bundle:nil] forCellReuseIdentifier:@"SectionCouponCellid"];
    [self.tableView registerNib:[UINib nibWithNibName:@"CouponCell" bundle:nil] forCellReuseIdentifier:@"CouponCellid"];
    [self.tableView registerNib:[UINib nibWithNibName:@"CouponUsedCell" bundle:nil] forCellReuseIdentifier:@"CouponUsedCellid"];
    [self.tableView registerNib:[UINib nibWithNibName:@"CouponOverDateCell" bundle:nil] forCellReuseIdentifier:@"CouponOverDateCellid"];
    
}
#pragma mark - 懒加载
-(UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 108, KScreenW, KScreenH - 64 - 44 - 50) style:UITableViewStylePlain
                      ];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle =  UITableViewCellSelectionStyleNone;
    }
    return _tableView;
}

-(UIView *)popCouponBackgroundView
{
    if (!_popCouponBackgroundView) {
        _popCouponBackgroundView = [[UIView alloc]initWithFrame:self.view.bounds];
        _popCouponBackgroundView.backgroundColor = RGBA(0, 0, 0,  0.2);
        [_popCouponBackgroundView addSubview:self.popCouponView];
    }
    return _popCouponBackgroundView;
}

-(CouponTableView *)popCouponView{
    if (!_popCouponView) {
        _popCouponView  = [[CouponTableView alloc]initWithFrame:CGRectMake(0, 200, KScreenW, KScreenH - 200) style:UITableViewStylePlain];
        _popCouponView.popDelegate = self;
    }
    return _popCouponView;
}

 
//设置右边按键（如果没有右边 可以不重写）
-(UIButton*)set_rightButton
{
    NSString * saveStr = @"编辑";
     _edit_btn = [[UIButton alloc]init];
    [_edit_btn setTitle:saveStr forState:UIControlStateNormal];
    _edit_btn.titleLabel.font=SYSTEMFONT(14);
    [_edit_btn setTitleColor:HEXCOLOR(0xfe6d6a)  forState:UIControlStateNormal];
    _edit_btn.titleLabel.textAlignment = NSTextAlignmentRight;
    CGSize size = [saveStr sizeWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:SYSTEMFONT(14),NSFontAttributeName, nil]];
    CGFloat width = size.width ;
    _edit_btn.frame =CGRectMake(0, 0, width+10, 22);
    [_edit_btn addTarget:self action:@selector(didClickEditing:) forControlEvents:UIControlEventTouchUpInside];
    return _edit_btn;
}

- (void)setupPageView {
    NSString * unuserd = @"未使用(0)";
    NSString * used = @"已使用(0)";
    NSString * overdate = @"已过期(0)";
    NSArray *titleArr = @[unuserd,used,overdate];
    _segumentView = [[MTSegmentedControl alloc]initWithFrame:CGRectMake(0, 64, KScreenW, 44)];
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
            numSection = 2;
            break;
        case SelectCouponTypeUsed://已使用
            numSection = 1;
            break;
        case SelectCouponTypeOverDate://已过期
            numSection = 1;
            
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
                numRow = 3;//假数据
            }
            break;
        case SelectCouponTypeUsed://已使用
            numRow = 2;
            break;
        case SelectCouponTypeOverDate://已过期
            numRow = 2;
            
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
            return couponCell;
        }
            break;
        case SelectCouponTypeUsed:{
            
            CouponUsedCell * cell = [ self.tableView dequeueReusableCellWithIdentifier:@"CouponUsedCellid" forIndexPath:indexPath];
            return cell;
        }
            break;
        case SelectCouponTypeOverDate:
        {
            CouponOverDateCell * couponCell = [ self.tableView dequeueReusableCellWithIdentifier:@"CouponOverDateCellid" forIndexPath:indexPath];
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
            
                [self.view addSubview:self.popCouponBackgroundView];
                [self.tableView bringSubviewToFront:self.popCouponBackgroundView];

 
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
