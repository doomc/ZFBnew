//
//  AddressLocationMapViewController.m
//  ZFB
//
//  Created by  展富宝  on 2017/7/6.
//  Copyright © 2017年 com.zfb. All rights reserved.
//  ma

#import "AddressLocationMapViewController.h"
//cell
#import "HPLocationCell.h"
//高德map
#import <AMapFoundationKit/AMapFoundationKit.h>
#import <AMapSearchKit/AMapSearchKit.h>
#import <AMapLocationKit/AMapLocationKit.h>
#import <MAMapKit/MAMapKit.h>
//自定义View
#import "MapPoiTableView.h"
#import "SearchResultTableVC.h"

#import "Reachability.h"

@interface AddressLocationMapViewController ()
<
MAMapViewDelegate,
AMapSearchDelegate,
AMapGeoFenceManagerDelegate,//地理围栏
AMapLocationManagerDelegate,//定位代理
MapPoiTableViewDelegate,//自定义代理
UISearchBarDelegate>
{
    AMapSearchAPI * _searchAPI;//获取周边api
    UIImageView   * _centerMaker;//固定中间的图
    // 第一次定位标记
    BOOL isFirstLocated;
    // 禁止连续点击两次
    BOOL _isMapViewRegionChangedFromTableView;
    //页码
    NSInteger searchPage;
    // 高德API不支持定位开关，需要自己设置
    UIButton * _locationBtn;
    UIImage  * _imageLocated;
    UIImage  * _imageNotLocate;
    // 地图中心点POI列表
    MapPoiTableView *_tableView;
    SearchResultTableVC *_searchResultTableVC;
    MBProgressHUD * _HUD;
}
//定位
@property (nonatomic, strong) MAMapView           *mapView;
@property (nonatomic, strong) AMapLocationManager *locationManager;
@property (nonatomic, strong) MAPointAnnotation   *pointAnnotaiton;

//围栏
@property (nonatomic, strong) AMapGeoFenceManager *geoFenceManager;



@end

@implementation AddressLocationMapViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title =@"选择地址";
    
    [self initMapView];
    [self initCenterMarker];
    [self initLocationButton];//自定义定位按钮回到当前
    [self initTableView];
    [self initSearch];
    
    // 使用通知中心监听kReachabilityChangedNotification通知
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(reachabilityChanged:)
                                                 name:kReachabilityChangedNotification object:nil];
    // 获取访问指定站点的Reachability对象
    Reachability *reach = [Reachability reachabilityWithHostname:@"www.baidu.com"];
    // 让Reachability对象开启被监听状态
    [reach startNotifier];
    
}

//初始化地图
- (void)initMapView {
    
    _mapView           = [[MAMapView alloc] initWithFrame:CGRectMake(0, 64, KScreenW, 200)];
    _mapView.delegate  = self;
    _mapView.zoomLevel = 15.2;
    // 不显示罗盘
    _mapView.showsCompass = NO;
    // 不显示比例尺
    _mapView.showsScale = NO;
    
    ///如果您需要进入地图就显示定位小蓝点，则需要下面两行代码
    _mapView.showsUserLocation = YES;
    _mapView.userTrackingMode  = MAUserTrackingModeFollow;
    
    [AMapServices sharedServices].enableHTTPS = YES;
    [self.view addSubview:_mapView];
    
    
}

- (void)initSearch
{
    searchPage          = 1;
    _searchAPI          = [[AMapSearchAPI alloc] init];
    _searchAPI.delegate = _tableView;
    
    //    _searchResultTableVC = [[SearchResultTableVC alloc] init];
    //    _searchResultTableVC.delegate = self;
    //    _searchController = [[UISearchController alloc] initWithSearchResultsController:_searchResultTableVC];
}
//mark 图标 固定位置
- (void)initCenterMarker
{
    UIImage *image      = [UIImage imageNamed:@"icon_location"];
    _centerMaker        = [[UIImageView alloc] initWithImage:image];
    _centerMaker.frame  = CGRectMake(self.view.frame.size.width/2-image.size.width/2, _mapView.bounds.size.height/2-image.size.height, image.size.width, image.size.height);
    _centerMaker.center = CGPointMake(KScreenW/ 2,  (200 + 64+ image.size.height) * 0.5);
    [self.view addSubview:_centerMaker];
}
//初始化atableview
- (void)initTableView
{
    _tableView          = [[MapPoiTableView alloc] initWithFrame:CGRectMake(0, 200+64, KScreenW, KScreenH-64-200)];
    _tableView.delegate = self;
    [self.view addSubview:_tableView];
}

#pragma mark - MapPoiTableViewDelegate
-(void)setSendButtonEnabledAfterLoadFinished
{
    NSLog(@"崩溃 nim");
}
// 加载更多列表数据
- (void)loadMorePOI
{
    searchPage++;
    AMapGeoPoint *point = [AMapGeoPoint locationWithLatitude:_mapView.centerCoordinate.latitude longitude:_mapView.centerCoordinate.longitude];
    [self searchPoiByAMapGeoPoint:point];
}
// 将地图中心移到所选的POI位置上
- (void)setMapCenterWithPOI:(AMapPOI *)point isLocateImageShouldChange:(BOOL)isLocateImageShouldChange
{
    //    if (_isMapViewRegionChangedFromTableView) {
    //        return;
    //    }
    // 切换定位图标
    if (isLocateImageShouldChange) {
        [_locationBtn setImage:_imageNotLocate forState:UIControlStateNormal];
    }
    _isMapViewRegionChangedFromTableView = YES;
    CLLocationCoordinate2D location      = CLLocationCoordinate2DMake(point.location.latitude, point.location.longitude);
    [_mapView setCenterCoordinate:location animated:YES];
}

// 设置当前位置所在城市
- (void)setCurrentCity:(NSString *)city
{
    [_searchResultTableVC setSearchCity:city];
}
#pragma mark -  开始定位
- (void)mapView:(MAMapView *)mapView didAddAnnotationViews:(NSArray *)views
{
    MAAnnotationView *view = views[0];
    
    // 放到该方法中用以保证userlocation的annotationView已经添加到地图上了。
    if ([view.annotation isKindOfClass:[MAUserLocation class]])
    {
        MAUserLocationRepresentation *pre = [[MAUserLocationRepresentation alloc] init];
        pre.showsAccuracyRing             = NO;
        //        pre.fillColor = [UIColor colorWithRed:0.9 green:0.1 blue:0.1 alpha:0.3];
        //        pre.strokeColor = [UIColor colorWithRed:0.1 green:0.1 blue:0.9 alpha:1.0];
        //        pre.image = [UIImage imageNamed:@"location.png"];
        //        pre.lineWidth = 3;
        //        pre.lineDashPattern = @[@6, @3];
        [_mapView updateUserLocationRepresentation:pre];
        
        view.calloutOffset = CGPointMake(0, 0);
    }
}

#pragma mark - MAMapViewDelegate
- (void)mapView:(MAMapView *)mapView didUpdateUserLocation:(MAUserLocation *)userLocation updatingLocation:(BOOL)updatingLocation
{
    // 首次定位
    if (updatingLocation && !isFirstLocated) {
        [_mapView setCenterCoordinate:CLLocationCoordinate2DMake(userLocation.location.coordinate.latitude, userLocation.location.coordinate.longitude)];
        isFirstLocated = YES;
    }
}
///地图区域改变完成后会调用此接口
- (void)mapView:(MAMapView *)mapView regionDidChangeAnimated:(BOOL)animated
{
    if (!_isMapViewRegionChangedFromTableView && isFirstLocated) {
        AMapGeoPoint *point = [AMapGeoPoint locationWithLatitude:_mapView.centerCoordinate.latitude longitude:_mapView.centerCoordinate.longitude];
        [self searchReGeocodeWithAMapGeoPoint:point];
        [self searchPoiByAMapGeoPoint:point];
        // 范围移动时当前页面数重置
        searchPage = 1;
        
        NSLog(@"%lf,%lf",_mapView.centerCoordinate.latitude,_mapView.centerCoordinate.longitude);
        NSLog(@"%lf,%lf",_mapView.userLocation.coordinate.latitude,_mapView.userLocation.coordinate.longitude);
        // 设置定位图标
        //        if (fabs(_mapView.centerCoordinate.latitude-_mapView.userLocation.coordinate.latitude) < 0.0001f && fabs(_mapView.centerCoordinate.longitude - _mapView.userLocation.coordinate.longitude) < 0.0001f) {
        //            [_locationBtn setImage:_imageLocated forState:UIControlStateNormal];
        //        }
        //        else {
        //            [_locationBtn setImage:_imageNotLocate forState:UIControlStateNormal];
        //        }
    }
    _isMapViewRegionChangedFromTableView = NO;
}
// 搜索逆向地理编码-AMapGeoPoint
- (void)searchReGeocodeWithAMapGeoPoint:(AMapGeoPoint *)location
{
    AMapReGeocodeSearchRequest *regeo = [[AMapReGeocodeSearchRequest alloc] init];
    regeo.location                    = location;
    // 返回扩展信息
    regeo.requireExtension = YES;
    [_searchAPI AMapReGoecodeSearch:regeo];
}

// 搜索中心点坐标周围的POI-AMapGeoPoint
- (void)searchPoiByAMapGeoPoint:(AMapGeoPoint *)location
{
    AMapPOIAroundSearchRequest *request = [[AMapPOIAroundSearchRequest alloc] init];
    request.location                    = location;
    // 搜索半径
    request.radius = 200;
    // 搜索结果排序
    request.sortrule = 0;
    // 当前页数
    request.page = searchPage;
    [_searchAPI AMapPOIAroundSearch:request];
}

#pragma mark - MAMapView Delegate
// 自定义Marker
- (MAAnnotationView *)mapView:(MAMapView *)mapView viewForAnnotation:(id<MAAnnotation>)annotation
{
    if ([annotation isKindOfClass:[MAPointAnnotation class]]) {
        static NSString *reuseIndetifier = @"anntationReuseIndetifier";
        MAAnnotationView *annotationView = (MAAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:reuseIndetifier];
        if (!annotationView) {
            annotationView              = [[MAAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:reuseIndetifier];
            annotationView.image        = [UIImage imageNamed:@"location_find"];
            annotationView.centerOffset = CGPointMake(0, -18);
            annotationView.highlighted  = YES;
        }
        return annotationView;
    }
    return nil;
}

#pragma mark - AMapLocationManager Delegate
- (void)amapLocationManager:(AMapLocationManager *)manager didFailWithError:(NSError *)error
{
    NSLog(@"%s, amapLocationManager = %@, error = %@", __func__, [manager class], error);
}

- (void)amapLocationManager:(AMapLocationManager *)manager didUpdateLocation:(CLLocation *)location reGeocode:(AMapLocationReGeocode *)reGeocode
{
    NSLog(@"location:{lat:%f; lon:%f; accuracy:%f; reGeocode:%@}", location.coordinate.latitude, location.coordinate.longitude, location.horizontalAccuracy, reGeocode.formattedAddress);
    
    //获取到定位信息，更新annotation
    if (self.pointAnnotaiton == nil)
    {
        self.pointAnnotaiton = [[MAPointAnnotation alloc] init];
        [self.pointAnnotaiton setCoordinate:location.coordinate];
        
        [self.mapView addAnnotation:self.pointAnnotaiton];
    }
    
    [self.pointAnnotaiton setCoordinate:location.coordinate];
    
    [self.mapView setCenterCoordinate:location.coordinate];
    [self.mapView setZoomLevel:15.1 animated:NO];
}

#pragma mark - 自定义定位按钮
- (void)initLocationButton
{
    _imageLocated                   = [UIImage imageNamed:@"gpsselected"];
    _imageNotLocate                 = [UIImage imageNamed:@"gpsnormal"];
    _locationBtn                    = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetWidth(_mapView.bounds)-50, CGRectGetHeight(_mapView.bounds)-50, 40, 40)];
    _locationBtn.autoresizingMask   = UIViewAutoresizingFlexibleTopMargin;
    _locationBtn.backgroundColor    = [UIColor colorWithRed:239.0/255 green:239.0/255 blue:239.0/255 alpha:1];
    _locationBtn.layer.cornerRadius = 3;
    [_locationBtn addTarget:self action:@selector(actionLocation) forControlEvents:UIControlEventTouchUpInside];
    [_locationBtn setImage:_imageNotLocate forState:UIControlStateNormal];
    [self.view addSubview:_locationBtn];
}
#pragma mark - Action
- (void)actionLocation
{
    [_mapView setCenterCoordinate:_mapView.userLocation.coordinate animated:YES];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [self.locationManager startUpdatingLocation];
}

-(void)AMapSearchAPIIint
{
    _searchAPI.delegate = self;
    
}

#pragma mark - 网络环境监听
- (void)reachabilityChanged:(NSNotification *)note{
    // 通过通知对象获取被监听的Reachability对象
    Reachability *curReach = [note object];
    // 获取Reachability对象的网络状态
    NetworkStatus status = [curReach currentReachabilityStatus];
    if (status == ReachableViaWWAN || status == ReachableViaWiFi){
        NSLog(@"Reachable");
        if (isFirstLocated) {
            AMapGeoPoint *point = [AMapGeoPoint locationWithLatitude:_mapView.centerCoordinate.latitude longitude:_mapView.centerCoordinate.longitude];
            [self searchReGeocodeWithAMapGeoPoint:point];
            [self searchPoiByAMapGeoPoint:point];
            searchPage = 1;
        }
    }
    else if (status == NotReachable){
        NSLog(@"notReachable");
        [self showAllTextDialog:@"网络错误，请检查网络设置"];
        self.navigationItem.rightBarButtonItem.enabled = NO;
    }
}

// 显示文本对话框
-(void)showAllTextDialog:(NSString *)str
{
    _HUD = [[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:_HUD];
    _HUD.label.text = str;
    _HUD.mode       = MBProgressHUDModeText;
    
    //指定距离中心点的X轴和Y轴的位置，不指定则在屏幕中间显示
    _HUD.yOffset = 100.0f;
    //    _HUD.xOffset = 100.0f;
    
    [_HUD showAnimated:YES whileExecutingBlock:^{
        sleep(1);
    } completionBlock:^{
        [_HUD removeFromSuperview];
        _HUD = nil;
    }];
    
}

@end
