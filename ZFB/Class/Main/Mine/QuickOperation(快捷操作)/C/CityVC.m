//
//  CityVC.m
//  ZFB
//
//  Created by  展富宝  on 2017/11/3.
//  Copyright © 2017年 com.zfb. All rights reserved.
//

#import "CityVC.h"
#import "AreaVC.h"
#import "AreaModel.h"
#import "AreaCell.h"

@interface CityVC ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic  ,strong) NSMutableArray * cityArray;
@property (nonatomic  ,strong) UITableView * tableView;

@end
@implementation CityVC

-(NSMutableArray *)cityArray{
    if (!_cityArray) {
        _cityArray = [NSMutableArray array];
    }
    return _cityArray;
    
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
    self.title = @"市区";
    [self.view addSubview: self.tableView];
    [self.tableView registerNib: [UINib nibWithNibName:@"AreaCell" bundle:nil] forCellReuseIdentifier:@"AreaCell"];
    [self scrollowCityCode:_areaCode];

}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return  self.cityArray.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    AreaCell * cell = [self.tableView dequeueReusableCellWithIdentifier:@"AreaCell" forIndexPath:indexPath];
    cell.provinceList = self.cityArray[indexPath.row];
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    AreaData * province  = self.cityArray[indexPath.row];
    AreaVC * areaVC = [AreaVC new];
    areaVC.areaCode = province.code;
    areaVC.areaName = [NSString stringWithFormat:@"%@ %@",_areaName,province.name];
    areaVC.addressBlock = ^(NSString *areaId, NSString *address) {
        NSLog(@"第3级：%@,%@",areaId,address);
        self.addressBlock(areaId, address);
    };
    [self.navigationController pushViewController:areaVC animated:NO];
    
}

#pragma mark - 获取市
-(void)scrollowCityCode:(NSString *)code
{
    NSDictionary * param = @{
                             @"code":code
                             };
    [SVProgressHUD show];

    [MENetWorkManager post:[NSString stringWithFormat:@"%@/getCityListApp",zfb_baseUrl] params:param success:^(id response) {
        
        NSString * code  = [NSString stringWithFormat:@"%@",response[@"resultCode"]];
        if ([code isEqualToString:@"0"]) {
            if (self.cityArray.count > 0) {
                [self.cityArray removeAllObjects];
            }
            AreaModel * area = [AreaModel mj_objectWithKeyValues:response];
            for (AreaData * city in area.data) {
                [self.cityArray addObject:city];
                
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
