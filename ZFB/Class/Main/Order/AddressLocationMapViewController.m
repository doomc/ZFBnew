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

#import "SearchResultTableVC.h"

#import "Reachability.h"

@interface AddressLocationMapViewController ()
<
MAMapViewDelegate,
AMapSearchDelegate,
AMapLocationManagerDelegate,//定位代理
SearchResultTableVCDelegate,//搜索代理
UISearchBarDelegate,
UITableViewDataSource,
UITableViewDelegate>
{
    AMapSearchAPI * _search;  //获取周边api
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
    //地图中心点POI列表
    MBProgressHUD * _HUD;
    NSString * addressPoi ;
}
//定位
@property (nonatomic, strong) MAMapView           *mapView;
@property (nonatomic, strong) AMapLocationManager *locationManager;
@property (nonatomic, strong) MAPointAnnotation   *pointAnnotaiton;
//搜索框
@property (nonatomic, strong) SearchResultTableVC *searchResultTableVC;
@property (nonatomic, strong) UISearchController  *searchController       ;

@property (nonatomic, strong) NSMutableArray<AMapPOI *> *dataList;
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
    [self initSearchBar]; //搜索框
    
 
    [self searchAround];
}

//初始化地图
- (void)initMapView {
    
    _mapView           = [[MAMapView alloc] initWithFrame:CGRectMake(0, 0, KScreenW, 300)];
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

//mark 图标 固定位置
- (void)initCenterMarker
{
    UIImage *image      = [UIImage imageNamed:@"icon_location"];
    _centerMaker        = [[UIImageView alloc] initWithImage:image];
    _centerMaker.frame  = CGRectMake(self.view.frame.size.width/2-image.size.width/2, _mapView.bounds.size.height/2-image.size.height, image.size.width, image.size.height);
    _centerMaker.center = CGPointMake(self.view.frame.size.width / 2, (CGRectGetHeight(_mapView.bounds) -  _centerMaker.frame.size.height - 64) * 0.5);
    
    [self.view addSubview:_centerMaker];
}
//初始化atableview
- (void)initTableView
{
    self.zfb_tableView          = [[UITableView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_mapView.frame)-64 , KScreenW, 6 * 55 + 64) style:UITableViewStylePlain];
    self.zfb_tableView.delegate = self;
    self.zfb_tableView.dataSource = self;
    [self.view addSubview:self.zfb_tableView];
    
    [self.zfb_tableView registerNib:[UINib nibWithNibName:@"HPLocationCell" bundle:nil] forCellReuseIdentifier:@"HPLocationCellId"];
}


 #pragma mark - 自定义定位按钮
- (void)initLocationButton
{
    _imageLocated                   = [UIImage imageNamed:@"gpsselected"];
    _imageNotLocate                 = [UIImage imageNamed:@"gpsnormal"];
    _locationBtn                    = [[UIButton alloc] initWithFrame:CGRectMake(10, CGRectGetHeight(_mapView.bounds)-50, 40, 40)];
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


#pragma mark - 搜索框------
-(void)initSearchBar
{
    searchPage          = 1;
    
    _searchResultTableVC                   = [[SearchResultTableVC alloc] init];
    _searchResultTableVC.delegate          = self;
    _searchController                      = [[UISearchController alloc] initWithSearchResultsController:_searchResultTableVC];
    _searchController.searchResultsUpdater = _searchResultTableVC;
    _searchController.searchBar.placeholder = @"搜索";
    _searchController.searchBar.barTintColor = HEXCOLOR(0xefefef);

    int SearchBarStyle = 0;
    switch (SearchBarStyle) {
        case 0:  // 放在NavigationBar底部
            [self.view addSubview:_searchController.searchBar];
            self.edgesForExtendedLayout = UIRectEdgeNone;
            break;
        case 1:  // 点击搜索按钮显示SearchBar
            self.navigationItem.leftBarButtonItem  = [[UIBarButtonItem alloc] initWithTitle:@"搜索" style:UIBarButtonItemStylePlain target:self action:@selector(searchAction)];
            self.navigationItem.rightBarButtonItem = nil;
            _searchController.searchBar.delegate   = self;
            break;
        case 2:  // 放在NavigationBar内部
            _searchController.searchBar.searchBarStyle             = UISearchBarStyleMinimal;
            _searchController.hidesNavigationBarDuringPresentation = NO;
            self.navigationItem.titleView                          = _searchController.searchBar;
            self.definesPresentationContext                        = YES;
        default:
            break;
    }
    
    
}

- (void)searchAction
{
    [self.navigationController.navigationBar addSubview:_searchController.searchBar];
    _searchController.searchBar.showsCancelButton = YES;
    _searchController.hidesNavigationBarDuringPresentation = NO;
    
}
// 设置当前位置所在城市
- (void)setCurrentCity:(NSString *)city
{
    [_searchResultTableVC setSearchCity:city];
}

#pragma mark - SearchResultTableVCDelegate
- (void)setSelectedLocationWithLocation:(AMapPOI *)poi
{
 
    
    [_mapView setCenterCoordinate:CLLocationCoordinate2DMake(poi.location.latitude,poi.location.longitude) animated:NO];
    _searchController.searchBar.text = @"";
}


#pragma mark - UISearchBarDelegate
- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    if (_searchController.searchBar) {
        [_searchController.searchBar removeFromSuperview];
    }
}


- (BOOL)searchBarShouldEndEditing:(UISearchBar *)searchBar
{
    if (_searchController.searchBar) {
        [_searchController.searchBar removeFromSuperview];
    }
    return YES;
}
#pragma - mark - 搜索
-(void)searchAround {
    //初始化检索对象
    _search = [[AMapSearchAPI alloc] init];
    _search.delegate = self;
    
    //构造AMapPOIAroundSearchRequest对象，设置周边请求参数
    AMapPOIAroundSearchRequest *request = [[AMapPOIAroundSearchRequest alloc] init];
    
    //当前位置
    request.location = [AMapGeoPoint locationWithLatitude:[BBUserDefault.latitude floatValue]longitude:[BBUserDefault.longitude floatValue]];

    //关键字
    request.keywords = _searchController.searchBar.text;
    NSLog(@"%@",_searchController.searchBar.text);
    // types属性表示限定搜索POI的类别，默认为：餐饮服务|商务住宅|生活服务
    // POI的类型共分为20种大类别，分别为：
//     汽车服务|汽车销售|汽车维修|摩托车服务|餐饮服务|购物服务|生活服务|体育休闲服务|
//     医疗保健服务|住宿服务|风景名胜|商务住宅|政府机构及社会团体|科教文化服务|
//     交通设施服务|金融保险服务|公司企业|道路附属设施|地名地址信息|公共设施
    request.types = @"汽车服务|汽车销售|汽车维修|摩托车服务|餐饮服务|购物服务|生活服务|体育休闲服务|医疗保健服务|住宿服务|风景名胜|商务住宅|政府机构及社会团体|科教文化服务|交通设施服务|金融保险服务|公司企业|道路附属设施|地名地址信息|公共设施";
    request.radius =  500;//<! 查询半径，范围：0-50000，单位：米 [default = 3000]
    request.sortrule = 0;
    request.requireExtension = YES;
    
    //发起周边搜索
    [_search AMapPOIAroundSearch:request];
}
//实现POI搜索对应的回调函数
- (void)onPOISearchDone:(AMapPOISearchBaseRequest *)request response:(AMapPOISearchResponse *)response
{
    if(response.pois.count == 0)
    {
        return;
    }
    
    //通过 AMapPOISearchResponse 对象处理搜索结果
    
    [self.dataList removeAllObjects];
    for (AMapPOI *p in response.pois) {
        NSLog(@"%@",[NSString stringWithFormat:@"%@\nPOI: %@,%@", p.description,p.name,p.address]);
        
        //搜索结果存在数组
        [self.dataList addObject:p];
    }
 
    [self.zfb_tableView reloadData];
}
- (NSMutableArray<AMapPOI *> *)dataList
{
    if (!_dataList) {
        _dataList = [NSMutableArray<AMapPOI *> array];
    }
    return _dataList;
}
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
 
    return [self.dataList count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    HPLocationCell *locationCell = [tableView dequeueReusableCellWithIdentifier:@"HPLocationCellId" forIndexPath:indexPath];
    AMapPOI *poi = _dataList[indexPath.row];
    
    locationCell.lb_title.text = poi.name;
    locationCell.lb_detail.text = poi.address;
    return locationCell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 50.0;
}
//点击cell
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    AMapPOI *poi = self.dataList[indexPath.row];
    NSString * address =[NSString stringWithFormat:@"%@%@%@",poi.city,poi.district,poi.name];
  
    if (_searchReturnBlock) {
        _searchReturnBlock(address, poi.location.latitude, poi.location.longitude, poi.postcode);
    }
    [self.navigationController popViewControllerAnimated:YES];
}



@end
