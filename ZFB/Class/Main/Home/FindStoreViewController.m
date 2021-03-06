

//
//  FindStoreViewController.m
//  ZFB
//
//  Created by  展富宝  on 2017/5/15.
//  Copyright © 2017年 com.zfb. All rights reserved.
//

#import "FindStoreViewController.h"
#import "HP_LocationViewController.h"
//#import "ZFDetailsStoreViewController.h"
#import "ZFAllStoreViewController.h"
//#import "StoreDetailViewController.h"//新的门店详情
#import "MainStoreViewController.h"

//cell
//#import "FindStoreCell.h" (原来的)
#import "HomePageStoreCell.h"
#import "XHStarRateView.h"
//model
#import "HomeStoreListModel.h"
//map
#import "CLLocation+MPLocation.h"//火星坐标

static NSString * cellIdentifier = @"HomePageStoreCell";

@interface FindStoreViewController ()<UITableViewDataSource,UITableViewDelegate ,CLLocationManagerDelegate>
{
    NSString *currentCityAndStreet;//当前城市
    NSString *latitudestr;//经度
    NSString *longitudestr;//纬度
    NSInteger totalCount;//总条数
    NSString * _currentCity;//当前城市
    MAUserLocation * _currentLocation;
    
}
@property (strong,nonatomic) UITableView * home_tableView;
@property (strong,nonatomic) UIView * sectionView;
@property (nonatomic,strong) NSMutableArray * storeListArr;//数据源
@property (nonatomic,strong) UIButton * location_btn ;

//高德api
@property (nonatomic,strong) CLLocationManager * locationManager;

@end
@implementation FindStoreViewController

-(NSMutableArray *)storeListArr
{
    if (!_storeListArr) {
        _storeListArr = [NSMutableArray array];
    }
    return _storeListArr;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    [self initWithHome_Tableview];
    
    [self initInTerfaceView];
 
    [self setupRefresh];

    [self PostRequst];
   
    [self LocationMapManagerInit];
    
}

#pragma mark -数据请求

-(void)headerRefresh {
    [super headerRefresh];
    [self PostRequst];
    if ([latitudestr isEqualToString:@""] || latitudestr.length == 0 || latitudestr == nil) {
        
        [self LocationMapManagerInit];
    }
}
-(void)footerRefresh {
    
    [super footerRefresh];
    [self PostRequst];
  
}

-(UIButton *)location_btn
{
    if (!_location_btn) {
        _location_btn  = [UIButton buttonWithType:UIButtonTypeCustom];//定位按钮
        [_location_btn addTarget:self action:@selector(pushToLocationView:) forControlEvents:UIControlEventTouchUpInside];
        [_location_btn setTitleColor: HEXCOLOR(0xf95a70) forState:UIControlStateNormal];
        
        UIFont * font = [UIFont systemFontOfSize:13];
        _location_btn.titleLabel.font = font ;
        [_location_btn setTitle:currentCityAndStreet forState:UIControlStateNormal];
        [_location_btn.titleLabel  sizeToFit];
        _location_btn.titleLabel.adjustsFontSizeToFitWidth = YES;
        
        _location_btn.frame = CGRectMake(25, 0, KScreenW - 50, 40);
        _location_btn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        _location_btn.titleEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0);
    }
    return _location_btn;
}
-(void)initInTerfaceView{
    
    UIView * loc_view =[[ UIView alloc]initWithFrame:CGRectMake(0, 0, KScreenW, 40+20)];//背景图
    loc_view.backgroundColor = [UIColor whiteColor];
    UIView * bg_view =[[UIView alloc]initWithFrame:CGRectMake(15, 5, KScreenW - 15 -15, 40)];
    [loc_view addSubview:bg_view];
    
    bg_view.layer.borderWidth = 1.0;
    bg_view.layer.cornerRadius = 4.0;
    bg_view.layer.borderColor = HEXCOLOR(0xf95a70).CGColor;
 
    //定位icon
    UIImageView * icon_locationView = [[UIImageView alloc]initWithFrame:CGRectMake(5, 10, 20, 20) ];
    icon_locationView.image =  [UIImage imageNamed:@"location"];
    
    [bg_view addSubview:self.location_btn];
    [bg_view addSubview: icon_locationView ];
    self.home_tableView.tableHeaderView = loc_view;
    
    //占位背景图
    UIView * bgView= [[UIView alloc]initWithFrame:CGRectMake(0, 50, KScreenW, 10)];
    bgView.backgroundColor = HEXCOLOR(0xf7f7f7);
    [loc_view addSubview:bgView];
}


/**
 初始化home_tableView
 */
-(void)initWithHome_Tableview
{

    self.home_tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, KScreenW, KScreenH -49- 50- 64) style:UITableViewStylePlain];
    self.home_tableView.delegate = self;
    self.home_tableView.dataSource = self;
    self.home_tableView.estimatedRowHeight = 0;

    [self.view addSubview:_home_tableView];

    [self.home_tableView registerNib:[UINib nibWithNibName:@"HomePageStoreCell" bundle:nil] forCellReuseIdentifier:cellIdentifier];
    self.zfb_tableView = self.home_tableView;
}

-(UIView *)sectionView
{
    if (!_sectionView) {
        _sectionView =[[UIView alloc] initWithFrame:CGRectMake(30, 0,KScreenW, 50)];
        _sectionView.backgroundColor= [UIColor whiteColor];
        UIButton * more_btn = [UIButton buttonWithType:UIButtonTypeSystem];
        [more_btn addTarget:self action:@selector(more_btnAction:) forControlEvents:UIControlEventTouchUpInside];
        more_btn.frame =CGRectMake( KScreenW - 40-10, 10, 40, 40);
        [more_btn setTitle:@"更多>" forState:UIControlStateNormal];
        more_btn.titleLabel.font = [UIFont systemFontOfSize:14];
        [more_btn setTitleColor: HEXCOLOR(0X8d8d8d) forState:UIControlStateNormal];
        [_sectionView addSubview:more_btn];
        
        UIImageView * icon_locationView = [[UIImageView alloc]init ];//定位icon
        icon_locationView.frame =CGRectMake(0,10, 105, 30);
        icon_locationView.image = [UIImage imageNamed:@"arroundStore"];
        
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
    return self.storeListArr.count;

}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    
    return 40;
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
    return 120/375.0 *KScreenW ;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    HomePageStoreCell * storeCell = [self.home_tableView  dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    if (self.storeListArr.count > 0) {
        Findgoodslist * listModel =  self.storeListArr[indexPath.row];
        storeCell.findgoodslist = listModel;
        
        XHStarRateView * _wdStarView;
        //初始化五星好评控件
        if (!storeCell.xh_starView) {
            _wdStarView = [[XHStarRateView alloc]initWithFrame:CGRectMake(0, 0, 70, 20) numberOfStars:5 rateStyle:WholeStar isAnination:YES delegate:self WithtouchEnable:NO littleStar:@"0"];//da星星
            _wdStarView.currentScore =  listModel.starLevel;
            [storeCell.starView  addSubview:_wdStarView];
            storeCell.xh_starView = _wdStarView;
 
        }
        return storeCell;

    }
    return storeCell;
}
#pragma tableViewDataSource
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@" section --- %ld ,row -----%ld",indexPath.section ,indexPath.row);    
//    ZFDetailsStoreViewController * vc = [[ZFDetailsStoreViewController alloc]init];
//    StoreDetailViewController * vc = [[StoreDetailViewController alloc]init];
    MainStoreViewController * vc =[MainStoreViewController new];
    Findgoodslist * listModel = self.storeListArr[indexPath.row];
    vc.storeId =[NSString stringWithFormat:@"%ld",listModel.storeId];
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
    
    locationVC.currentCity = _currentCity;
    locationVC.currentLocation = _currentLocation;
    locationVC.searchStr = currentCityAndStreet;
    locationVC.moveBlock = ^(AMapPOI *poi) {
        [self.location_btn setTitle:poi.name forState:UIControlStateNormal];
        NSLog(@"latitude:%f === longitude:%f",poi.location.latitude,poi.location.longitude);
        BBUserDefault.latitude = latitudestr = [NSString stringWithFormat:@"%.6f",poi.location.latitude];
        BBUserDefault.longitude = longitudestr = [NSString stringWithFormat:@"%.6f",poi.location.longitude];

    };
    [self.navigationController pushViewController: locationVC animated:YES];
    
}
#pragma mark  - 定位当前
/**定位当前 */
-(void)LocationMapManagerInit
{
    //判断定位功能是否打开
    if ([CLLocationManager locationServicesEnabled]) {
        
        _locationManager = [[CLLocationManager alloc]init];
        _locationManager.distanceFilter = 100;
        [_locationManager setDistanceFilter:kCLDistanceFilterNone];
        _locationManager.delegate = self;
        [_locationManager requestWhenInUseAuthorization];
        
        //设置寻址精度
        _locationManager.desiredAccuracy = kCLLocationAccuracyBest;
        [_locationManager startUpdatingLocation];
    }
    
}
#pragma mark CoreLocation delegate (定位失败)
//定位失败后调用此代理方法
-(void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    [self.view makeToast:@"定位失败" duration:2 position:@"center"];

}

#pragma mark 定位成功后则执行此代理方法
-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations
{
 
    //旧址
    CLLocation *currentLocation = [locations lastObject];
    CLGeocoder *geoCoder = [[CLGeocoder alloc]init];
    
    currentLocation  = [currentLocation locationMarsFromEarth];
    _currentLocation =(MAUserLocation *) currentLocation  ;

    //打印当前的经度与纬度
    latitudestr = [NSString stringWithFormat:@"%f",currentLocation.coordinate.latitude];
    longitudestr = [NSString stringWithFormat:@"%f",currentLocation.coordinate.longitude];
    BBUserDefault.latitude = latitudestr;
    BBUserDefault.longitude = longitudestr;


    //反地理编码
    [geoCoder reverseGeocodeLocation:currentLocation completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
        if (placemarks.count > 0) {
            CLPlacemark *placeMark = placemarks[0];
            _currentCity =   placeMark.locality ;
            
            if (!_currentCity) {
                _currentCity = @"无法定位当前城市";
            }
            /*看需求定义一个全局变量来接收赋值*/
            NSLog(@"%@",currentCityAndStreet);//当前的城市
            currentCityAndStreet = [NSString stringWithFormat:@"%@%@",placeMark.subLocality,placeMark.name];
            [self.location_btn setTitle:currentCityAndStreet forState:UIControlStateNormal];
        }
    }];
    
    if ([latitudestr isEqualToString:@""] || latitudestr == nil) {
        NSLog(@"无法定位当前城市");

    }else{
        [self PostRequst];

    }
    [_locationManager stopUpdatingLocation];

}

#pragma mark - 首页网络请求 getCmStoreInfo
-(void)PostRequst
{
    NSDictionary * parma = @{

//                             @"longitude":longitudestr,//经度
//                             @"latitude":latitudestr ,//纬度
                             @"longitude":BBUserDefault.longitude,//经度
                             @"latitude":BBUserDefault.latitude ,//纬度
                             @"size":[NSNumber numberWithInteger:kPageCount],
                             @"page":[NSNumber numberWithInteger:self.currentPage],
                             @"businessType":@"",
                             @"payType":@"",
                             @"orderBydisc":@"1",
                             @"orderbylikeNum":@"",
                             @"nearBydisc":@"0",
                             @"sercahText":@"",
                             @"serviceType" : @"",//商品1级类别id
                       
                             };

    [MENetWorkManager post:[NSString stringWithFormat:@"%@/getCmStoreInfo",zfb_baseUrl] params:parma success:^(id response) {

        NSString * code = [NSString stringWithFormat:@"%@", response[@"resultCode"] ];
        if ([code isEqualToString:@"0"]) {
            if (self.refreshType == RefreshTypeHeader) {
                if (self.storeListArr.count > 0) {
                    [self.storeListArr  removeAllObjects];
                }
            }
            HomeStoreListModel * homeStore = [HomeStoreListModel mj_objectWithKeyValues:response];
            totalCount = homeStore.storeInfoList.totalCount;
            NSLog(@"%ld -----page = %ld",totalCount,self.currentPage);
            for (Findgoodslist  * goodlist in homeStore.storeInfoList.findGoodsList) {
                [self.storeListArr addObject:goodlist];
            }
            [self.home_tableView reloadData];
        }
        [self endRefresh];
    } progress:^(NSProgress *progeress) {
    } failure:^(NSError *error) {

        [self endRefresh];
        [self.view makeToast:@"网络错误" duration:2 position:@"center"];
        NSLog(@"error=====%@",error);
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
