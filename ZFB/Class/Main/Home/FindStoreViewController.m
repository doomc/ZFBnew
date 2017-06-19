

//
//  FindStoreViewController.m
//  ZFB
//
//  Created by  展富宝  on 2017/5/15.
//  Copyright © 2017年 com.zfb. All rights reserved.
//

#import "FindStoreViewController.h"
#import "FindStoreCell.h"
#import "HP_LocationViewController.h"
#import "DetailStoreViewController.h"
#import "ZFAllStoreViewController.h"
#import "HomeStoreListModel.h"
#import <AMapLocationKit/AMapLocationKit.h>

static NSString *CellIdentifier = @"FindStoreCellid";

@interface FindStoreViewController ()<UITableViewDataSource,UITableViewDelegate ,AMapLocationManagerDelegate>
{
    NSInteger _pageSize;//每页显示条数
    NSInteger _pageIndex;//当前页码;

}
@property (strong,nonatomic) UITableView * home_tableView;
@property (strong,nonatomic) UIView * sectionView;
@property (nonatomic,strong) NSMutableArray * storeListArr;//数据源

//高德api
@property (nonatomic,strong) AMapLocationManager * locationManager;
@property (nonatomic,strong) AMapLocationReGeocode * reGeocode;//地理编码
@property (nonatomic,strong) CLLocation *  currentLocation;
/**
 *  持续定位是否返回逆地理信息，默认NO。
 */
@property (nonatomic, assign) BOOL locatingWithReGeocode;

@end
@implementation FindStoreViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initWithHome_Tableview];
 
    [self initInTerfaceView];
    
    //默认一个页码 和 页数
    _pageSize = 10;
    _pageIndex = 1;
    
    [self LocationMapManagerInit];
    [self PostRequst];

    
}
-(NSMutableArray *)storeListArr
{
    if (!_storeListArr) {
        _storeListArr = [NSMutableArray array];
    }
    return _storeListArr;
}
-(void)initInTerfaceView{
   
    UIView * loc_view =[[ UIView alloc]initWithFrame:CGRectMake(0, 0, KScreenW, 40)];//背景图
    UIView * bg_view =[[UIView alloc]initWithFrame:CGRectMake(15, 5, KScreenW-15-15, 30)];
    [loc_view addSubview:bg_view];
   
    bg_view.layer.borderWidth = 1.0;
    bg_view.layer.cornerRadius = 4.0;
    bg_view.layer.borderColor = HEXCOLOR(0xfa6d6a).CGColor;
    
    //定位icon
    UIImageView * icon_locationView = [[UIImageView alloc]initWithFrame:CGRectMake(5, 5, 18, 20) ];
    icon_locationView.image =  [UIImage imageNamed:@"location_find2"];
    UIButton * location_btn  = [UIButton buttonWithType:UIButtonTypeCustom];//定位按钮
    location_btn.frame = CGRectMake(25, 0, 100, 30);
    [location_btn addTarget:self action:@selector(pushToLocationView:) forControlEvents:UIControlEventTouchUpInside];
    
    [location_btn setTitle:@"龙湖水晶国际 >" forState:UIControlStateNormal];
    [location_btn setTitleColor: HEXCOLOR(0xfa6d6a) forState:UIControlStateNormal];
    location_btn.titleLabel.font = [UIFont systemFontOfSize:12];
    location_btn.titleLabel.textAlignment = NSTextAlignmentLeft;
    
    
    [bg_view addSubview:location_btn];
    [bg_view addSubview: icon_locationView ];
    self.home_tableView.tableHeaderView = loc_view;
}


/**
 初始化home_tableView
 */
-(void)initWithHome_Tableview
{

    self.home_tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, KScreenW, KScreenH -49-64-44) style:UITableViewStylePlain];
    self.home_tableView.delegate = self;
    self.home_tableView.dataSource = self;
    self.home_tableView.separatorStyle =UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_home_tableView];
    [self.home_tableView registerNib:[UINib nibWithNibName:@"FindStoreCell" bundle:nil] forCellReuseIdentifier:CellIdentifier];
}
-(UIView *)sectionView
{
    if (!_sectionView) {
        _sectionView =[[UIView alloc] initWithFrame:CGRectMake(30, 0,KScreenW, 40)];
        UILabel *labelTitle = [[UILabel alloc] initWithFrame:CGRectMake(35, 0, 100, 35)];
        _sectionView.backgroundColor = HEXCOLOR(0xffcccc);
        labelTitle.textAlignment = NSTextAlignmentLeft;
        labelTitle.text = @"附近门店";
        labelTitle.textColor = HEXCOLOR(0x363636);
        labelTitle.font =[ UIFont systemFontOfSize:12];
        [_sectionView addSubview:labelTitle];
        
        UIButton * more_btn = [UIButton buttonWithType:UIButtonTypeSystem];
        [more_btn addTarget:self action:@selector(more_btnAction:) forControlEvents:UIControlEventTouchUpInside];
        more_btn.frame =CGRectMake( KScreenW - 40 , 0, 40, 35);
        [more_btn setTitle:@"更多" forState:UIControlStateNormal];
        more_btn.titleLabel.font = [UIFont systemFontOfSize:12];
        [more_btn setTitleColor: HEXCOLOR(0xfa6d6a) forState:UIControlStateNormal];
        [_sectionView addSubview:more_btn];
        
        UIImageView * icon_locationView = [[UIImageView alloc]init ];//定位icon
        icon_locationView.frame =CGRectMake(15,5, 20, 25);
        icon_locationView.image = [UIImage imageNamed:@"location_find"];
        
        [_sectionView addSubview:icon_locationView];
        
    }
    return _sectionView;
}
#pragma mark - datasoruce  代理实现
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.storeListArr.count > 0) {
       
        return self.storeListArr.count;
    }
    return 3;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{

    return 35;
}

-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = nil;
    if (section == 0) {
        
        view = self.sectionView ;
    }

    return view;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 145;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    HomeStoreListModel * listModel =  [HomeStoreListModel new];
    
    if (indexPath.row < [self.storeListArr count]) {
        
        listModel  = [self.storeListArr objectAtIndex:indexPath.row];
    }
 
    FindStoreCell *storeCell = [self.home_tableView  dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    storeCell.selectionStyle = UITableViewCellSelectionStyleNone;
    CGFloat juli = [listModel.juli floatValue]*0.001;
    storeCell.lb_distence.text = [NSString stringWithFormat:@"%.2f公里",juli];
    storeCell.lb_collectNum.text = listModel.likeNum;
    storeCell.store_listTitle.text = listModel.storeName;
    [storeCell.store_listView sd_setImageWithURL:[NSURL URLWithString:listModel.urls] placeholderImage:nil];
    
    
    return storeCell;

}
#pragma tableViewDataSource
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    DetailStoreViewController * vc = [[DetailStoreViewController alloc]init];
    HomeStoreListModel * listModel = self.storeListArr[indexPath.row];
    vc.storeId =listModel.storeId;
    [self.navigationController pushViewController:vc animated:YES];
}

/**
  更多门店

 @param sender  跳转到更多门店
 */
-(void)more_btnAction:(UIButton*)sender
{
    NSLog(@"更多门店");
    
    ZFAllStoreViewController * allVC =[[ ZFAllStoreViewController alloc]init];
    [self.navigationController pushViewController:allVC animated:YES];
}
/**
 定位
 @param sender 跳转到定位
 */
-(void)pushToLocationView:(UIButton *)sender
{
    HP_LocationViewController * locationVC =[[ HP_LocationViewController alloc]init];
    [self.navigationController pushViewController: locationVC animated:YES];
    
}
#pragma mark  - 高德定位
/**定位当前 */
-(void)LocationMapManagerInit
{
    self.locationManager = [[AMapLocationManager alloc] init];
    
    self.locationManager.delegate = self;
    
    // 带逆地理信息的一次定位（返回坐标和地址信息）
    [self.locationManager setDesiredAccuracy:kCLLocationAccuracyHundredMeters];
    self.locationManager.distanceFilter = 200;
    
    //   定位超时时间，最低2s，此处设置为2s
    self.locationManager.locationTimeout =10;
    
    //   逆地理请求超时时间，最低2s，此处设置为2s
    self.locationManager.reGeocodeTimeout = 10;
    
    //开始定位
    [self.locationManager setLocatingWithReGeocode:YES];
    [self.locationManager startUpdatingLocation];

}



#pragma mark - 首页网络请求
-(void)PostRequst
{
    
    NSLog(@"    lat:%f; lon:%f ",_currentLocation.coordinate.latitude,_currentLocation.coordinate.longitude);
    
    NSString * longitude = [NSString stringWithFormat:@"%.6f",_currentLocation.coordinate.longitude];
    NSString * latitude = [NSString stringWithFormat:@"%.6f",_currentLocation.coordinate.latitude];
    NSString * pageSize= [NSString stringWithFormat:@"%ld",_pageSize];
    NSString * pageIndex= [NSString stringWithFormat:@"%ld",_pageIndex];
    
    NSDictionary * parma = @{
                             
                             @"svcName":@"getCmStoreInfo",
                             @"longitude":longitude,//经度
                             @"latitude":latitude ,//纬度
                             @"pageSize":pageSize,//每页显示条数
                             @"pageIndex":pageIndex,//当前页码
                             @"cmUserId":BBUserDefault.cmUserId,
                             
                             };
    
    NSDictionary *parmaDic=[NSDictionary dictionaryWithDictionary:parma];
    
    [PPNetworkHelper POST:ZFB_11SendMessageUrl parameters:parmaDic responseCache:^(id responseCache) {
        
    } success:^(id responseObject) {
        
        NSLog(@"  %@  = responseObject  " ,responseObject);
        
        if ([responseObject[@"resultCode"] isEqualToString:@"0"]) {
            
            if (self.storeListArr.count >0) {
            
                [self.storeListArr  removeAllObjects];

            }else{
               
                [self.view makeToast:@"请求成功" duration:2 position:@"center" ];
                NSString  * dataStr= [responseObject[@"data"] base64DecodedString];
                NSDictionary * jsondic = [NSString dictionaryWithJsonString:dataStr];
                NSArray * dictArray = jsondic [@"cmStoreList"];
                
                //mjextention 数组转模型
                NSArray *storArray = [HomeStoreListModel mj_objectArrayWithKeyValuesArray:dictArray];
                
                for (HomeStoreListModel *list in storArray) {
                    
                    [self.storeListArr addObject:list];
                }
                NSLog(@"storeListArr = %@",   self.storeListArr);

                [self.home_tableView reloadData];
            }
            
        }
        
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
        [self.view makeToast:@"网络错误" duration:2 position:@"center"];
    }];
}


#pragma mark  -AMapLocationManagerDelegate
- (void)amapLocationManager:(AMapLocationManager *)manager didUpdateLocation:(CLLocation *)location reGeocode:(AMapLocationReGeocode *)reGeocode
{
    NSLog(@"location:{  lat:%f; lon:%f; accuracy:%f  }", location.coordinate.latitude, location.coordinate.longitude, location.horizontalAccuracy);
    if (reGeocode)
    {
        NSLog(@"reGeocode:%@", reGeocode);
        self.reGeocode = reGeocode;
    }
    NSLog(@"reGeocode:%@", reGeocode.POIName);
    
    // 赋值给全局变量
    _currentLocation = location;
    
    NSLog(@" lat:%f; lon:%f ",_currentLocation.coordinate.latitude,_currentLocation.coordinate.longitude);
    
    // 停止定位
    [self.locationManager stopUpdatingLocation];
    
    
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    
 

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
