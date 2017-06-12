//
//  HP_LocationViewController.m
//  ZFB
//
//  Created by  展富宝  on 2017/5/17.
//  Copyright © 2017年 com.zfb. All rights reserved.
//  首页定位

#import "HP_LocationViewController.h"
#import "SearchCell.h"
#import <CoreLocation/CoreLocation.h>

//高德api
#import <MAMapKit/MAMapKit.h>
#import <AMapSearchKit/AMapSearchKit.h>
#import <AMapLocationKit/AMapLocationKit.h>
@interface HP_LocationViewController ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate,AMapGeoFenceManagerDelegate,AMapLocationManagerDelegate,CLLocationManagerDelegate,MAMapViewDelegate,AMapSearchDelegate>
{
//    CLLocationManager *locationManager;
    NSString * currentCity;
    NSString * Srrlatitude;
    NSString * Srrlongitdude;
    
}
@property(nonatomic,strong)UITableView * location_TableView;
@property(nonatomic,strong)UITextField * tf_search;
@property(nonatomic,strong)UIView * bgView;

//高德api
@property (nonatomic, strong) AMapPOI     *poi;
@property(nonatomic,strong)AMapLocationManager * locationManager;
@property(nonatomic,strong)MAMapView *  mapView;
@property(nonatomic,strong)AMapSearchAPI *  searchAPI;
@property(nonatomic,strong)CLLocation *  currentLocation;
@property(nonatomic,strong)NSMutableArray *  addressList;
/**
 *  持续定位是否返回逆地理信息，默认NO。
 */
@property (nonatomic, assign) BOOL locatingWithReGeocode;

@end

@implementation HP_LocationViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self creatTableViewInterface];
    
    [self locationinit];

    [self searchApISetting];
    
}
-(void)locationinit{
    self.locationManager = [[AMapLocationManager alloc] init];
    
    self.locationManager.delegate = self;
    
    // 带逆地理信息的一次定位（返回坐标和地址信息）
    [self.locationManager setDesiredAccuracy:kCLLocationAccuracyHundredMeters];
    
    //   定位超时时间，最低2s，此处设置为2s
    self.locationManager.locationTimeout =2;
    
    //   逆地理请求超时时间，最低2s，此处设置为2s
    self.locationManager.reGeocodeTimeout = 2;
    
    //开始定位
    [self.locationManager setLocatingWithReGeocode:YES];
    
    [self.locationManager startUpdatingLocation];
}
#pragma mark  - 高德POI设置
-(void)searchApISetting
{
    
    AMapPOIAroundSearchRequest *request = [[AMapPOIAroundSearchRequest alloc] init];

    self.searchAPI = [[AMapSearchAPI alloc] init];
    self.searchAPI.delegate = self;
    
    request.location = [AMapGeoPoint locationWithLatitude:self.currentLocation.coordinate.latitude longitude:self.currentLocation.coordinate.longitude];
    request.keywords                    = @"";
    request.sortrule                    = 0;
    request.requireExtension            = YES;
    request.radius                      = 1000;
//    request.page                        = self.pageIndex;
//    request.offset                      = self.pageCount;
    request.types                       = @"050000|060000|070000|080000|090000|100000|110000|120000|130000|140000|150000|160000|170000";
    
    [self.searchAPI AMapPOIAroundSearch:request];
    
}
#pragma mark - AMapSearchDelegate
/* POI 搜索回调. */
- (void)onPOISearchDone:(AMapPOISearchBaseRequest *)request response:(AMapPOISearchResponse *)response{
    if (response.pois.count == 0){
        return;
    }
    for(AMapPOI *poi in response.pois){
        NSLog(@"%@",poi.name);
    }
    self.addressList  = [NSMutableArray arrayWithArray:response.pois];
    [self.location_TableView reloadData];

}

#pragma mark  -高德api 定位

- (void)amapLocationManager:(AMapLocationManager *)manager didUpdateLocation:(CLLocation *)location reGeocode:(AMapLocationReGeocode *)reGeocode
{
    
    NSLog(@"location:{lat:%f; lon:%f; accuracy:%f}", location.coordinate.latitude, location.coordinate.longitude, location.horizontalAccuracy);
    if (reGeocode)
    {
        NSLog(@"reGeocode:%@", reGeocode);
    }
    // 赋值给全局变量
    _currentLocation = location;
    // 发起周边搜索
    // 停止定位
    [self.locationManager stopUpdatingLocation];
}


-(NSMutableArray *)addressList
{
    if (!_addressList) {
        _addressList = [NSMutableArray array];
    }
    return _addressList;
}
-(void)creatTableViewInterface
{
    self.title = @"选择地址";

    //创建bgView
    self.bgView = [[UIView alloc]initWithFrame:CGRectMake(0, 64, KScreenW,50 )];
    [self.view addSubview:_bgView];
    
    self.tf_search.clearButtonMode = UITextFieldViewModeAlways;
    self.tf_search = [[UITextField alloc]initWithFrame:CGRectMake(35, 10, KScreenW-70, 35)];
    self.tf_search.layer.borderWidth = 1;
    self.tf_search.layer.borderColor = HEXCOLOR(0xfe6d6a).CGColor;
    self.tf_search.layer.cornerRadius = 8;
    self.tf_search.textColor = HEXCOLOR(0xfe6d6a);
    _tf_search.font = [UIFont fontWithName:@"Arial" size:14.0f];
    [_bgView addSubview:_tf_search];
    
    self.tf_search.placeholder = @"请输入要搜索的地址";
    self.tf_search.delegate = self;

    
    //tableView的创建
    self.location_TableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 114, KScreenW, KScreenH-64) style:UITableViewStyleGrouped];
    [self.view addSubview:self.location_TableView];

    self.location_TableView.dataSource = self;
    self.location_TableView.delegate = self;

    [self.location_TableView registerNib:[UINib nibWithNibName:@"SearchCell" bundle:nil] forCellReuseIdentifier:@"SearchCell"];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 1) {
        return  self.addressList.count;
    }
    return 1;
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 1) {
        return 40;
    }
    return 5;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 5;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView * view = nil;
    if (section==1) {
        
        UIView * bgview =[[ UIView alloc]initWithFrame:CGRectMake(0, 0, KScreenW, 40)];
        bgview.backgroundColor =HEXCOLOR(0xffcccc);
        
        UILabel * _lb = [[UILabel alloc]initWithFrame:CGRectMake(15, 0, KScreenW, 40)];
        _lb.textColor = HEXCOLOR(0x363636);
        _lb.text = @"附近地址";
        _lb.font = [UIFont systemFontOfSize:15.0];
        [bgview addSubview:_lb];
        
        return bgview;
    }
    return view;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell * customCell = [self.location_TableView dequeueReusableCellWithIdentifier:@"cell"];
 
    if (indexPath.section == 0) {
        
        SearchCell * searchCell = [self.location_TableView dequeueReusableCellWithIdentifier:@"SearchCell" forIndexPath:indexPath];
        return searchCell;
    }
    if (indexPath.section == 1 ) {
      
        if (!customCell) {
            customCell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cell"];
        }
        customCell.textLabel.font =[ UIFont systemFontOfSize:12];
        customCell.textLabel.textColor = HEXCOLOR(0x363636);
        customCell.textLabel.text = self.addressList[indexPath.row];
        customCell.detailTextLabel.text = self.addressList[indexPath.row];

        return customCell;

    }
    return nil;
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}


//-(void)lcattemap{
//    if ([CLLocationManager locationServicesEnabled]) {
//        locationManager = [[CLLocationManager alloc]init];
//        locationManager.delegate = self;
//        currentCity= [[NSString alloc]init];
//        [locationManager requestWhenInUseAuthorization];
//        
//        locationManager.desiredAccuracy = kCLLocationAccuracyBest;
//        locationManager.distanceFilter = 5.0;
//        [locationManager startUpdatingLocation];
//        
//      }
//}
//-(void)locationManager:(CLLocationManager *)manager didFailWithError:(nonnull NSError *)error {
//    
//    NSLog(@"定位失败 %@",error);
//    [SVProgressHUD dismiss];
//
//    
//}
//-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations
//{
//    
//    [SVProgressHUD showWithStatus:@"正在定位"];
//    [locationManager stopUpdatingLocation];
//    CLLocation * currentLoction  = [locations lastObject];
//    CLGeocoder * geoCoder =[[CLGeocoder alloc]init];
//    NSLog(@"%f,%f",currentLoction.coordinate.latitude,currentLoction.coordinate.longitude);
//    
//    
//    [geoCoder reverseGeocodeLocation:currentLoction completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
//        if (placemarks.count >0) {
//            
//            CLPlacemark *palceMark = placemarks[0];
//            currentCity =palceMark.locality;
//            if (!currentCity) {
//                currentCity = @"我发定位当前城市";
//            }
//            NSLog(@"%@",palceMark.country);//当前国家
//            NSLog(@"%@",currentCity);//当前城市
//            NSLog(@"%@",palceMark.subLocality);//当前位置
//            NSLog(@"%@",palceMark.thoroughfare);//当前街道
//            NSLog(@"%@",palceMark.name);//具体地址
//            
//        }
//        
//    else if (error == nil && placemarks.count == 0)
//    {
//        NSLog(@" 灭有定位到");
//    }
//    else if (error){
//        
//        NSLog(@"%@",error);
//    }
//        
//    }];
//
//    [SVProgressHUD dismiss];
//
//}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

 
@end
