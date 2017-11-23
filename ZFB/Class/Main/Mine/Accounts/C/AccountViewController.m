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

@interface AccountViewController ()<UITableViewDelegate,UITableViewDataSource,ScreenTypeViewDelegete,UIGestureRecognizerDelegate,CYLTableViewPlaceHolderDelegate,WeChatStylePlaceHolderDelegate>
{
    BOOL _isCreat;//yes 已经创建了
    NSInteger _selectType;
}
@property (nonatomic , strong) NSMutableArray * accountList;
@property (nonatomic , strong) UIButton * screenbtn;
@property (nonatomic , strong) UIView * coverView;
@property (nonatomic , strong) ScreenTypeView * typeView;

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
    _selectType = 0;

    [self initWithInterface];
    
    [self setupRefresh];

    NSString * type = [NSString stringWithFormat:@"%ld",_selectType];
    [self accountListPostRequstAtPayType:type];
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
    _selectType = index;
    // 0 全部 1 转账 2 退款 3 充值 4 订单 5 提现 6佣金
    NSString * type = [NSString stringWithFormat:@"%ld",_selectType];
    [self accountListPostRequstAtPayType:type];

    [UIView animateWithDuration:0.5 animations:^{
        [_typeView removeFromSuperview];
        [_coverView removeFromSuperview];
        _isCreat = NO;
        
    }];
   

}

-(void)viewWillAppear:(BOOL)animated
{
    [self settingNavBarBgName:@"nav64_gray"];
}
-(void)footerRefresh
{
    [super footerRefresh];
    NSString * type = [NSString stringWithFormat:@"%ld",_selectType];
    [self accountListPostRequstAtPayType:type];

}
-(void)headerRefresh
{
    [super headerRefresh];
    NSString * type = [NSString stringWithFormat:@"%ld",_selectType];
    [self accountListPostRequstAtPayType:type];
}

-(void)initWithInterface
{
    self.zfb_tableView = [[UITableView alloc]initWithFrame:CGRectMake(0,0, KScreenW, KScreenH -64) style:UITableViewStylePlain];
    self.zfb_tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.zfb_tableView.delegate = self;
    self.zfb_tableView.dataSource = self;

    [self.view addSubview:self.zfb_tableView];
    [self.zfb_tableView registerNib:[UINib nibWithNibName:@"AccountListCell" bundle:nil] forCellReuseIdentifier:@"AccountListCell"];
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
    Cashflowlist * cashlist = self.accountList[indexPath.row];
    AccountListCell * cell = [self.zfb_tableView dequeueReusableCellWithIdentifier:@"AccountListCell" forIndexPath:indexPath];
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
            [[self makePlaceHolderView] removeFromSuperview];
            [self.zfb_tableView reloadData];
            
            if ([self isEmptyArray:self.accountList]) {
                [self.zfb_tableView cyl_reloadData];
            }
        }
        [self endRefresh];
    } progress:^(NSProgress *progeress) {
        
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
        [SVProgressHUD dismiss];
        [self endRefresh];
    }];
}


#pragma mark - CYLTableViewPlaceHolderDelegate Method
- (UIView *)makePlaceHolderView {
    
    UIView *weChatStyle = [self weChatStylePlaceHolder];
    return weChatStyle;
}

//暂无数据
- (UIView *)weChatStylePlaceHolder {
    WeChatStylePlaceHolder *weChatStylePlaceHolder = [[WeChatStylePlaceHolder alloc] initWithFrame:self.zfb_tableView.frame];
    weChatStylePlaceHolder.delegate = self;
    return weChatStylePlaceHolder;
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
