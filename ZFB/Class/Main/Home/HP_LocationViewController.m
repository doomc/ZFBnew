//
//  HP_LocationViewController.m
//  ZFB
//
//  Created by  展富宝  on 2017/5/17.
//  Copyright © 2017年 com.zfb. All rights reserved.
//  首页定位


#import "HP_LocationViewController.h"
//cell
#import "SearchCell.h"
#import "HPLocationCell.h"
//view
#import "MapPoiTableView.h"

#import "MJRefresh.h"
//高德api
#import <AMapLocationKit/AMapLocationKit.h>

@interface HP_LocationViewController ()<UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate,AMapLocationManagerDelegate,AMapSearchDelegate>
{
    NSIndexPath *  _selectedIndexPath;
    NSInteger      _pageIndex;
}

//poi
@property (nonatomic,strong) AMapSearchAPI *  searchAPI;
@property (nonatomic,strong) NSMutableArray *  addressList;
@property (nonatomic,strong) NSMutableArray *  searchPoiArray;

@property (nonatomic,assign) BOOL           needInsertOldAddress;
@property (nonatomic,assign) BOOL           isSelectCity;

//end
@property (nonatomic,strong) UITableView * location_TableView;
@property (nonatomic,strong) UISearchBar * searchBar;
@property (nonatomic,strong) UIView * bgView;

//高德api
@property (nonatomic,strong) AMapLocationManager * locationManager;
@property (nonatomic,strong) AMapLocationReGeocode * reGeocode;//地理编码
@property (nonatomic,strong) CLLocation *  currentLocation;

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
   
    [self LocationMapManagerInit];

    UIView *superView = self.searchBar.subviews.lastObject;
    for (UIView *view in superView.subviews) {
        if ([view isKindOfClass:[UITextField class]]) {
            view.backgroundColor = HEXCOLOR(0xdedede);
        }else if ([NSStringFromClass([view class]) isEqualToString:@"UISearchBarBackground"]) {
            [view removeFromSuperview];
        }
    }


}
-(void)creatTableViewInterface
{
    self.title = @"选择地址";
    
    //创建bgView
    self.bgView = [[UIView alloc]initWithFrame:CGRectMake(0, 64, KScreenW,50 )];
    [self.view addSubview:_bgView];

    [_bgView addSubview:self.searchBar];
    
    
    //tableView的创建
    self.location_TableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 114, KScreenW, KScreenH - 114) style:UITableViewStyleGrouped];
    [self.view addSubview:self.location_TableView];
    
    self.location_TableView.dataSource = self;
    self.location_TableView.delegate = self;
    

 
    [self.location_TableView registerNib:[UINib nibWithNibName:@"SearchCell" bundle:nil] forCellReuseIdentifier:@"SearchCellid"];
    [self.location_TableView registerNib:[UINib nibWithNibName:@"HPLocationCell" bundle:nil] forCellReuseIdentifier:@"HPLocationCellid"];
 
    

    weakSelf(weakSelf);
    //上拉加载
    _location_TableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        
        [weakSelf loadMorePOI];
        
    }];
    
    //下拉刷新
    _location_TableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        //需要将页码设置为1
        _pageIndex = 1;
        
        //        [weakSelf PostRequst];
    }];
    
    
}
-(void)viewWillAppear:(BOOL)animated
{
    [self.location_TableView.mj_header beginRefreshing];
    
}
#pragma mark  - 高德POI设置  搜索
-(void)settingPOI{
 
    if (self.oldPoi) {
        AMapPOI *poi                = self.oldPoi;
        self.needInsertOldAddress   = poi.address.length > 0;
        self.isSelectCity           = poi.address.length == 0;
    }
    
    [self headRefreshing];
}
#pragma mark - getData
- (void)headRefreshing{
    _pageIndex = 0;
 
    [self footRefreshing];
}

- (void)footRefreshing{
    [self searchApISetting];
}
#pragma mark  - 高德POI设置 AMapSearchDelegate
-(void)searchApISetting
{
    _pageIndex += 1;

    self.searchAPI = [[AMapSearchAPI alloc] init];
    self.searchAPI.delegate = self;
    
    AMapPOIAroundSearchRequest *request = [[AMapPOIAroundSearchRequest alloc] init];
    request.location = [AMapGeoPoint locationWithLatitude:_currentLocation.coordinate.latitude longitude:_currentLocation.coordinate.longitude];
    NSLog(@" lat:%f; lon:%f ",_currentLocation.coordinate.latitude,_currentLocation.coordinate.longitude);
    request.requireExtension = YES;
    request.requireSubPOIs  = YES;
    request.keywords = @"";
    request.radius   = 1000;
    request.sortrule   = 0;///排序规则, 0-距离排序；1-综合排序, 默认1
    request.page     = _pageIndex;//页数
    request.types    = @"050000|060000|070000|080000|090000|100000|110000|120000|130000|140000|150000|160000|170000";
    [self.searchAPI AMapPOIAroundSearch:request];
    
}
#pragma mark - AMapSearchDelegate
//检索失败
-(void)AMapSearchRequest:(id)request didFailWithError:(NSError *)error{
   
    NSLog(@"%@",error);
}
/* POI 搜索回调. */
- (void)onPOISearchDone:(AMapPOISearchBaseRequest *)request response:(AMapPOISearchResponse *)response{
   
    if (response.pois.count == 0){
        return;
    }
    [self.addressList removeAllObjects];
    
    [SVProgressHUD showWithStatus:@"检索成功"];
  

    for(AMapPOI *poi in response.pois){
        
        NSLog(@"%@",[NSString stringWithFormat:@"%@\nPOI: %@,%@", poi.description,poi.name,poi.address]);
     
        [self.addressList addObject:poi];
    }

    // 刷新POI后默认第一行为打勾状态
    _selectedIndexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    // 刷新完成,没有数据时不显示footer
    self.location_TableView.mj_footer.hidden = response.pois.count != _pageIndex;
    
    [self.location_TableView.mj_footer endRefreshing];
    [self.location_TableView.mj_header endRefreshing];
    
    [SVProgressHUD  dismiss];
    
    [self.location_TableView reloadData];
 
    
}
#pragma mark - MapPoiTableViewDelegate
- (void)loadMorePOI
{
    _pageIndex++;
    AMapGeoPoint *point = [AMapGeoPoint locationWithLatitude:_currentLocation.coordinate.latitude longitude:_currentLocation.coordinate.longitude];
    [self searchPoiByAMapGeoPoint:point];
}
// 搜索中心点坐标周围的POI-AMapGeoPoint
- (void)searchPoiByAMapGeoPoint:(AMapGeoPoint *)location
{
    AMapPOIAroundSearchRequest *request = [[AMapPOIAroundSearchRequest alloc] init];
    request.location = location;
    // 搜索半径
    request.radius = 1000;
    // 搜索结果排序
    request.sortrule = 1;
    // 当前页数
    request.page = _pageIndex;
    [_searchAPI AMapPOIAroundSearch:request];
}


#pragma mark  - 高德定位
-(void)LocationMapManagerInit{
    
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

#pragma mark  -AMapLocationManagerDelegate
- (void)amapLocationManager:(AMapLocationManager *)manager didUpdateLocation:(CLLocation *)location reGeocode:(AMapLocationReGeocode *)reGeocode
{
    // 赋值给全局变量
    _currentLocation = location;

    NSLog(@" lat:%f; lon:%f ",_currentLocation.coordinate.latitude,_currentLocation.coordinate.longitude);
    
    // 发起周边搜索
    [self settingPOI];
    
    // 停止定位
    [self.locationManager stopUpdatingLocation];
    

}


#pragma mark -  UITableViewDelegate    UITableViewDataSource
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
    return 50;
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
    
    if (indexPath.section == 0) {
        
        SearchCell * searchCell = [self.location_TableView
                                   dequeueReusableCellWithIdentifier:@"SearchCellid" forIndexPath:indexPath];
        return searchCell;
    }
    if (indexPath.section == 1 ) {
        
        HPLocationCell * cell = [self.location_TableView
                                 dequeueReusableCellWithIdentifier:@"HPLocationCellid" forIndexPath:indexPath];
        AMapPOI *info         = self.addressList[indexPath.row];
        cell.lb_title.text    = info.name.length > 0 ? info.name : info.city;
        cell.lb_detail.text   = info.address;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.accessoryType = (_selectedIndexPath.row == indexPath.row) ? UITableViewCellAccessoryCheckmark : UITableViewCellAccessoryNone;

        return cell;
        
    }
    return nil;
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        
        [self LocationMapManagerInit];

    }
    if (indexPath.section == 1) {
        // 单选打勾
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        NSInteger newRow = indexPath.row;
        NSInteger oldRow = _selectedIndexPath != nil ? _selectedIndexPath.row : -1;
        if (newRow != oldRow) {
            UITableViewCell *currentCell = [tableView cellForRowAtIndexPath:indexPath];
            currentCell.accessoryType = UITableViewCellAccessoryCheckmark;
            UITableViewCell *lastCell = [tableView cellForRowAtIndexPath:_selectedIndexPath];
            lastCell.accessoryType = UITableViewCellAccessoryNone;
        }
        _selectedIndexPath = indexPath;
        
        AMapPOI *info = self.addressList[indexPath.row];
        NSLog(@"%@",info.city);
        if (self.successBlock) {
            [self.navigationController popViewControllerAnimated:YES];
        }
 
    }
   
}


- (void)setSuccessBlock:(SelectLocationSuccessBlock)successBlock{
    
    _successBlock = successBlock;
    
}

-(NSMutableArray *)addressList
{
    if (!_addressList) {
        _addressList = [NSMutableArray array];
    }
    return _addressList;
}
-(NSMutableArray *)searchPoiArray
{
    if (!_searchPoiArray) {
        _searchPoiArray = [NSMutableArray array];
    }
    return _searchPoiArray;
}

-(UISearchBar *)searchBar
{
    if (!_searchBar) {
        _searchBar = [[UISearchBar alloc]initWithFrame:CGRectMake(10, 0, KScreenW - 2*10, 44)];
        _searchBar.delegate = self;
        _searchBar.backgroundImage = [self imageWithColor:[UIColor clearColor] size:_searchBar.bounds.size];
        _searchBar.placeholder = @"搜索商品或门店";
    }
    return _searchBar;
}


//以下的两个方法必须设置.searchBar.delegate 才可以
-(BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar{
    NSLog(@"开始编辑");
    return YES;
}

-(BOOL)searchBarShouldEndEditing:(UISearchBar *)searchBar{
    NSLog(@"结束编辑");
    return YES;
}
//当搜索框中的内容发生改变时会自动进行搜索,这个是经常用的
-(void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    NSLog(@"结束编辑 %@",searchText);
    
}
-(BOOL)searchBar:(UISearchBar *)searchBar shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    
    NSLog(@"正在编辑--- %@",text);
    
    return YES;
}


//在键盘中的搜索按钮的点击事件
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    NSLog(@"点击了搜索");

}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
