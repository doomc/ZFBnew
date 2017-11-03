//
//  AreaVC.m
//  ZFB
//
//  Created by  展富宝  on 2017/11/3.
//  Copyright © 2017年 com.zfb. All rights reserved.
//

#import "AreaVC.h"
#import "AreaCell.h"

@interface AreaVC ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic  ,strong) NSMutableArray * areaArray;
@property (nonatomic  ,strong) UITableView * tableView;
@end

@implementation AreaVC

-(NSMutableArray *)areaArray{
    if (!_areaArray) {
        _areaArray = [NSMutableArray array];
    }
    return _areaArray;
    
}
-(UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, KScreenW, KScreenH -64)];
        _tableView.delegate = self;
        _tableView.dataSource = self;
    }
    return _tableView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
     self.title = @"区、县";
    [self.view addSubview: self.tableView];
    [self.tableView registerNib: [UINib nibWithNibName:@"AreaCell" bundle:nil] forCellReuseIdentifier:@"AreaCell"];
    [self scrollowAreaCode:_areaCode];

}


-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return  self.areaArray.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    AreaCell * cell = [self.tableView dequeueReusableCellWithIdentifier:@"AreaCell" forIndexPath:indexPath];
    cell.provinceList = self.areaArray[indexPath.row];
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    AreaData * areaData  = self.areaArray[indexPath.row];
    NSString * address = [NSString stringWithFormat:@"%@ %@",_areaName,areaData.name];

    if (_addressBlock) {
        _addressBlock(areaData.areaId,address);
        [self poptoUIViewControllerNibName:@"iWantOpenStoreViewController" AndObjectIndex:1];
    }
}

#pragma mark - 获取区getAreaListApp
-(void)scrollowAreaCode:(NSString *)code
{
    NSDictionary * param = @{
                             @"code":code
                             };
    
    [SVProgressHUD show];
    
    [MENetWorkManager post:[NSString stringWithFormat:@"%@/getAreaListApp",zfb_baseUrl] params:param success:^(id response) {
        
        NSString * code  = [NSString stringWithFormat:@"%@",response[@"resultCode"]];
        if ([code isEqualToString:@"0"]) {
            if (self.areaArray.count > 0) {
                [self.areaArray removeAllObjects];
            }
            AreaModel * area = [AreaModel mj_objectWithKeyValues:response];
            for (AreaData * areaData in area.data) {
                [self.areaArray addObject:areaData];
            }
            [self.tableView reloadData];
        }else {
            [self.view makeToast:response[@"resultMsg"]  duration:2 position:@"center"];
        }
        [SVProgressHUD dismiss];

    } progress:^(NSProgress *progeress) {
    } failure:^(NSError *error) {
        [SVProgressHUD dismiss];

    }];
}

-(void)viewWillAppear:(BOOL)animated
{
    [self settingNavBarBgName:@"nav64_gray"];
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
