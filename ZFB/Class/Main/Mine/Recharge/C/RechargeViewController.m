//
//  RechargeViewController.m
//  ZFB
//
//  Created by  展富宝  on 2017/10/17.
//  Copyright © 2017年 com.zfb. All rights reserved.
//  充值

#import "RechargeViewController.h"
#import "AddBankCardViewController.h"//添加银行卡
#import "BankCardListModel.h"

@interface RechargeViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic , strong) UITableView * backTableView;
@property (nonatomic ,strong) NSMutableArray * backCardList;

@end

@implementation RechargeViewController
-(NSMutableArray *)backCardList
{
    if (!_backCardList) {
        _backCardList = [NSMutableArray array];
    }
    return  _backCardList;
}
//设置右边按键（如果没有右边 可以不重写）
-(UIButton*)set_rightButton
{
    NSString * saveStr = @"＋";
    UIButton *right_button = [[UIButton alloc]init];
    [right_button setTitle:saveStr forState:UIControlStateNormal];
    right_button.titleLabel.font = SYSTEMFONT(15);
    [right_button setTitleColor:HEXCOLOR(0xfe6d6a)  forState:UIControlStateNormal];
    right_button.titleLabel.textAlignment = NSTextAlignmentRight;
    CGSize size = [saveStr sizeWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:SYSTEMFONT(14),NSFontAttributeName, nil]];
    CGFloat width = size.width ;
    right_button.frame =CGRectMake(0, 0, width+10, 22);
    
    return right_button;
}
-(UITableView *)backTableView
{
    if (!_backTableView) {
        _backTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, KScreenW, KScreenH-64) style:UITableViewStylePlain];
        _backTableView.delegate = self;
        _backTableView.dataSource = self;
        _backTableView.separatorStyle =  UITableViewCellSeparatorStyleNone;
    }
    return  _backTableView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"银行卡列表";
}

//设置右边事件
-(void)right_button_event:(UIButton*)sender{
    
    NSLog(@"添加银行卡");
    AddBankCardViewController * addVC = [AddBankCardViewController new];
    [self.navigationController pushViewController:addVC animated:NO];
    
}

-(void)viewWillAppear:(BOOL)animated{
    
    [self backCardListPost];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.backCardList.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 55;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell * backCell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    
    return backCell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //银行卡详情
}

-(void)backCardListPost
{
    NSDictionary * param = @{
                             @"account":BBUserDefault.userPhoneNumber
                             };
    [MENetWorkManager post:[NSString stringWithFormat:@"%@/QRCode/getBaseBankList",zfb_baseUrl] params:param success:^(id response) {
        NSString * code = [NSString stringWithFormat:@"%@",response[@"resultCode"]];
        
        if ([code isEqualToString:@"0"]) {
            BankCardListModel  * bank = [BankCardListModel mj_objectWithKeyValues:response];
            for (Base_Bank_List * list in bank.base_bank_list) {
                [self.backCardList addObject:list];
            }
            
            [self.backTableView reloadData];
        }
    } progress:^(NSProgress *progeress) {
        
    } failure:^(NSError *error) {
        
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
