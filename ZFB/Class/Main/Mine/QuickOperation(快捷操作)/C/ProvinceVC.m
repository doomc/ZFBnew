
//
//  ProvinceVC.m
//  ZFB
//
//  Created by  展富宝  on 2017/11/3.
//  Copyright © 2017年 com.zfb. All rights reserved.
//

#import "ProvinceVC.h"
#import "AreaModel.h"
#import "AreaCell.h"
#import "CityVC.h"
@interface ProvinceVC () <UITableViewDelegate,UITableViewDataSource>

@property (nonatomic  ,strong) NSMutableArray * provinceArray;
@property (nonatomic  ,strong) UITableView * tableView;

@end

@implementation ProvinceVC
-(NSMutableArray *)provinceArray{
    if (!_provinceArray) {
        _provinceArray = [NSMutableArray array];
    }
    return _provinceArray;
    
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
    self.title = @"省、市";
    [self.view addSubview: self.tableView];
    [self.tableView registerNib: [UINib nibWithNibName:@"AreaCell" bundle:nil] forCellReuseIdentifier:@"AreaCell"];
    [self scrollowProvince];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return  self.provinceArray.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    AreaCell * cell = [self.tableView dequeueReusableCellWithIdentifier:@"AreaCell" forIndexPath:indexPath];
    cell.provinceList = self.provinceArray[indexPath.row];
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    AreaData * province  = self.provinceArray[indexPath.row];
    CityVC * cityVC = [CityVC new];
    cityVC.areaCode = province.code;
    cityVC.areaName = province.name;
    cityVC.addressBlock = ^(NSString *areaId, NSString *address) {
        NSLog(@"第2级：%@,%@",areaId,address);
        self.addressBlock(areaId, address);

    };
    [self.navigationController pushViewController:cityVC animated:NO];

}
#pragma mark - 获取省
-(void)scrollowProvince
{
    [SVProgressHUD show];

    [MENetWorkManager post:[NSString stringWithFormat:@"%@/getProvinceListApp",zfb_baseUrl] params:nil success:^(id response) {
        
        NSString * code  = [NSString stringWithFormat:@"%@",response[@"resultCode"]];
        if ([code isEqualToString:@"0"]) {
            if (self.provinceArray.count > 0) {
                [self.provinceArray removeAllObjects];
            }
            AreaModel * area = [AreaModel mj_objectWithKeyValues:response];
            for (AreaData * province in area.data) {
                [self.provinceArray addObject:province];
            }
            [SVProgressHUD dismiss];
            [self.tableView reloadData];
        }else {
            
            [SVProgressHUD dismiss];
            [self.view makeToast:response[@"resultMsg"]  duration:2 position:@"center"];
        }
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
