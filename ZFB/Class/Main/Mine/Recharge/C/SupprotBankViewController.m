//
//  SupprotBankViewController.m
//  ZFB
//
//  Created by  展富宝  on 2017/10/20.
//  Copyright © 2017年 com.zfb. All rights reserved.
//

#import "SupprotBankViewController.h"
#import "SupportBankCell.h"
@interface SupprotBankViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, strong) UITableView * tableView;
@property (nonatomic, strong) NSMutableArray * carlist;


@end

@implementation SupprotBankViewController

-(NSMutableArray *)carlist
{
    if (!_carlist) {
        _carlist = [NSMutableArray array];
    }
    return _carlist;
}
-(UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, KScreenW, KScreenH-64) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle =  UITableViewCellSeparatorStyleNone;
    }
    return  _tableView;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"支持银行";
    
    [self.view addSubview:self.tableView];
    [self.tableView registerNib:[UINib nibWithNibName:@"SupportBankCell" bundle:nil] forCellReuseIdentifier:@"SupportBankCell"];
    
}
-(void)viewWillAppear:(BOOL)animated
{
    [self supportCardPost];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return  self.carlist.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SupportBankCell  * listCell = [self.tableView dequeueReusableCellWithIdentifier:@"SupportBankCell" forIndexPath:indexPath];
    return listCell;
}

-(void)supportCardPost
{
    NSDictionary * param = @{
                             @"account":BBUserDefault.userPhoneNumber
                             };
    [MENetWorkManager post:[NSString stringWithFormat:@"%@/QRCode/",zfb_baseUrl] params:param success:^(id response) {
        NSString * code = [NSString stringWithFormat:@"%@",response[@"resultCode"]];
        
        if ([code isEqualToString:@"0"]) {
            
 
            [self.tableView reloadData];
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
