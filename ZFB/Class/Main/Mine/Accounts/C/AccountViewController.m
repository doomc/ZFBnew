//
//  AccountViewController.m
//  ZFB
//
//  Created by  展富宝  on 2017/10/9.
//  Copyright © 2017年 com.zfb. All rights reserved.
//

#import "AccountViewController.h"
#import "AccountListCell.h"
#import "AccountModel.h"
#import "DetailAccountViewController.h"
#import "ScreenTypeView.h"
#import "CQPlaceholderView.h"

typedef NS_ENUM(NSUInteger, CheckType) {
    CheckTypeAll = 0 ,//全部
    CheckTypeTurnCash  ,//转账
    CheckTypeBackCash  ,//退款
    CheckTypeRecharge  ,//充值
    CheckTypeOrder  ,//订单
    CheckTypeWithDraw  ,//提现
    CheckTypeCommission ,//佣金
 
};
@interface AccountViewController ()<UITableViewDelegate,UITableViewDataSource,ScreenTypeViewDelegete,UIGestureRecognizerDelegate,CQPlaceholderViewDelegate>
{
    BOOL _isCreat;//yes 已经创建了
}
@property (nonatomic , strong) NSMutableArray * accountList;
@property (nonatomic , strong) UIButton * screenbtn;
@property (nonatomic , strong) UIView * coverView;
@property (nonatomic , strong) ScreenTypeView * typeView;
@property (nonatomic , strong) CQPlaceholderView *placeholderView;
@property (nonatomic , assign) CheckType  checkType;

@end

@implementation AccountViewController
-(NSMutableArray *)accountList
{
    if (!_accountList) {
        _accountList = [NSMutableArray array];
    }return _accountList;
}
-(UIButton *)set_rightButton
{
    _screenbtn          = [UIButton buttonWithType:UIButtonTypeCustom];
    _screenbtn.frame = CGRectMake(0, 10, 24, 24);
    [_screenbtn setImage :[UIImage imageNamed:@"screen"]  forState:UIControlStateNormal];
    [_screenbtn addTarget:self action:@selector(clickAction:) forControlEvents:UIControlEventTouchUpInside];
    return  _screenbtn;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"查看明细";
    _isCreat = NO;
    _checkType = CheckTypeAll;//默认全部

    [self initWithInterface];
}
-(void)headerRefresh
{
    [super headerRefresh];
    switch (_checkType) {
        case CheckTypeAll:
            [self accountListPostRequstAtPayType:@"0"];
            break;
        case CheckTypeTurnCash: //转账
            [self accountListPostRequstAtPayType:@"1"];
            break;
        case CheckTypeBackCash: //退款
            [self accountListPostRequstAtPayType:@"2"];
            break;
        case CheckTypeRecharge://充值
            [self accountListPostRequstAtPayType:@"3"];
            break;
        case CheckTypeOrder://订单
            [self accountListPostRequstAtPayType:@"4"];
            break;
        case CheckTypeWithDraw://提现
            [self accountListPostRequstAtPayType:@"5"];
            break;
        case CheckTypeCommission://佣金
            [self accountListPostRequstAtPayType:@"6"];
            break;
 
    }
}
-(void)footerRefresh
{
    [super footerRefresh];
    switch (_checkType) {
        case CheckTypeAll:
            [self accountListPostRequstAtPayType:@"0"];
            break;
        case CheckTypeTurnCash: //转账
            [self accountListPostRequstAtPayType:@"1"];
            break;
        case CheckTypeBackCash: //退款
            [self accountListPostRequstAtPayType:@"2"];
            break;
        case CheckTypeRecharge://充值
            [self accountListPostRequstAtPayType:@"3"];
            break;
        case CheckTypeOrder://订单
            [self accountListPostRequstAtPayType:@"4"];
            break;
        case CheckTypeWithDraw://提现
            [self accountListPostRequstAtPayType:@"5"];
            break;
        case CheckTypeCommission://佣金
            [self accountListPostRequstAtPayType:@"6"];
            break;
            
    }
}
-(void)coverViewSetting
{
    _coverView = [[UIView alloc]initWithFrame:CGRectMake(0, 64, KScreenW, KScreenH)];
    _coverView.backgroundColor = RGBA(0, 0, 0, 0.2);
    _coverView.userInteractionEnabled = YES;
    UITapGestureRecognizer * tapCoverView =[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapCoverView:)];
    tapCoverView.delegate = self;
    tapCoverView.numberOfTapsRequired = 1;
    [_coverView addGestureRecognizer:tapCoverView];
    [self.view addSubview:_coverView];
    [self.coverView bringSubviewToFront:self.zfb_tableView];
    
    
    _typeView = [[ScreenTypeView alloc ]initWithFrame:CGRectMake(0, 0, KScreenW, 150)];
    _typeView.delegate = self;
    [_coverView addSubview:_typeView];
    [self.view addSubview:_typeView];
    _isCreat = YES;

}

#pragma mark -  筛选事件
-(void)clickAction:(UIButton *)sender
{
    if (_isCreat  == YES) {
        return;
    }
    [self coverViewSetting];
}
#pragma mark - 关闭弹框视图
-(void)tapCoverView:(UITapGestureRecognizer* )tapView
{
    [UIView animateWithDuration:0.5 animations:^{
        [_typeView removeFromSuperview];
        [_coverView removeFromSuperview];
        _isCreat = NO;
        
    }];
}
#pragma mark -  ScreenTypeView 选择代理
-(void)didClickIndex:(NSInteger)index
{
    _checkType = index;
    [self.accountList removeAllObjects];
    self.currentPage = 1;
 
    [UIView animateWithDuration:0.5 animations:^{
        [_typeView removeFromSuperview];
        [_coverView removeFromSuperview];
        _isCreat = NO;
        
    }];
    // 0 全部 1 转账 2 退款 3 充值 4 订单 5 提现 6佣金
    [self headerRefresh];

}

-(void)viewWillAppear:(BOOL)animated
{
    [self settingNavBarBgName:@"nav64_gray"];
 
    [self headerRefresh];
}

-(void)initWithInterface
{
    self.zfb_tableView = [[UITableView alloc]initWithFrame:CGRectMake(0,0, KScreenW, KScreenH -64) style:UITableViewStylePlain];
    self.zfb_tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.zfb_tableView.delegate = self;
    self.zfb_tableView.dataSource = self;
    [self.view addSubview:self.zfb_tableView];
    [self.zfb_tableView registerNib:[UINib nibWithNibName:@"AccountListCell" bundle:nil] forCellReuseIdentifier:@"AccountListCell"];

    [self setupRefresh];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.accountList.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 70;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    AccountListCell * cell = [self.zfb_tableView dequeueReusableCellWithIdentifier:@"AccountListCell" forIndexPath:indexPath];
    Cashflowlist * cashlist = self.accountList[indexPath.row];
    cell.cashlist = cashlist;
    return cell;
    
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"row == %ld",indexPath.row);
    Cashflowlist * cashlist = self.accountList[indexPath.row];
    DetailAccountViewController * detailVC = [[DetailAccountViewController alloc]init];
    detailVC.flowId = [NSString stringWithFormat:@"%ld",cashlist.flowId];
    [self.navigationController pushViewController:detailVC animated:NO];
 
}

/**
 流水列表

 @param payType 0.全部 1 转账 2 退款 3 充值 4 订单 5 提现 6佣金

 */
-(void)accountListPostRequstAtPayType:(NSString *)payType
{
    NSDictionary * param  = @{
                              @"operationAccount":BBUserDefault.userPhoneNumber,
                              @"page":[NSNumber numberWithInteger:self.currentPage],
                              @"size":[NSNumber numberWithInteger:kPageCount],
                              @"payType":payType,
                              };
    [SVProgressHUD show];
    [MENetWorkManager post:[NSString stringWithFormat:@"%@/flow/getFlowList",zfb_baseUrl] params:param success:^(id response) {
    
        if ([response[@"resultCode"] isEqualToString:@"0"]) {
            if (self.refreshType == RefreshTypeHeader) {
                [self.accountList removeAllObjects];
            }
            AccountModel * account  = [AccountModel mj_objectWithKeyValues:response];
        
            for (Cashflowlist * list in account.data.cashFlowList) {
                [self.accountList addObject:list];
            }
            [SVProgressHUD dismiss];
            
            [_placeholderView removeFromSuperview];
            if ([self isEmptyArray:self.accountList]) {
                _placeholderView = [[CQPlaceholderView alloc]initWithFrame:self.zfb_tableView.bounds type:CQPlaceholderViewTypeNoGoods delegate:self];
                [self.zfb_tableView addSubview:_placeholderView];
            }
            [self.zfb_tableView reloadData];

        }
        [self endRefresh];
    } progress:^(NSProgress *progeress) {
        
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
        [SVProgressHUD dismiss];
        [self endRefresh];
    }];
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
