//
//  DetailAccountViewController.m
//  ZFB
//
//  Created by  展富宝  on 2017/10/9.
//  Copyright © 2017年 com.zfb. All rights reserved.
//

#import "DetailAccountViewController.h"
#import "DetailAcountTitleCell.h"
#import "DetailAcountHeaderCell.h"

@interface DetailAccountViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic , strong) UITableView * tableview;

@end

@implementation DetailAccountViewController
-(UITableView *)tableview
{
    if (!_tableview) {
        _tableview = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, KScreenW, KScreenH) style:UITableViewStylePlain];
        _tableview.delegate = self;
        _tableview.dataSource = self;
    }
    return _tableview;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self.tableview registerNib:[UINib nibWithNibName:@"DetailAcountHeaderCell" bundle:nil] forCellReuseIdentifier:@"DetailAcountHeaderCell"];
    [self.tableview registerNib:[UINib nibWithNibName:@"DetailAcountTitleCell" bundle:nil] forCellReuseIdentifier:@"DetailAcountTitleCell"];

    [self.view addSubview:self.tableview];
    
}

-(void)viewWillAppear:(BOOL)animated
{
    [self accountListPostRequst];
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return 1;
    }
    return 6;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return 120;
    }
    return 44;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        
        DetailAcountHeaderCell * headCell = [self.zfb_tableView dequeueReusableCellWithIdentifier:@"DetailAcountHeaderCell" forIndexPath:indexPath];
        return headCell;
        
    }else{
        DetailAcountTitleCell * titleCell = [self.zfb_tableView dequeueReusableCellWithIdentifier:@"DetailAcountTitleCell" forIndexPath:indexPath];
        return titleCell;

    }
    
}

-(void)accountListPostRequst
{
    NSDictionary * param  = @{
                              @"operationAccount":BBUserDefault.userPhoneNumber,
                              @"flowId":_flowId,
 
                              };
    [SVProgressHUD show];
    [MENetWorkManager post:[NSString stringWithFormat:@"%@/flow/getFlowList",zfb_baseUrl] params:param success:^(id response) {
        
        if ([response[@"resultCode"] isEqualToString:@"0"]) {
   
            [SVProgressHUD dismiss];
            [self.zfb_tableView reloadData];
            
        }
   
    } progress:^(NSProgress *progeress) {
        
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
        [SVProgressHUD dismiss];
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
