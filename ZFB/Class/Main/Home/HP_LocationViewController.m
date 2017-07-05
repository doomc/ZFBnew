//
//  HP_LocationViewController.m
//  ZFB
//
//  Created by  展富宝  on 2017/5/17.
//  Copyright © 2017年 com.zfb. All rights reserved.
//  首页定位


#import "HP_LocationViewController.h"
#import "SearchCell.h"
#import "HPLocationCell.h"

#import "MJRefresh.h"
//高德api
#import <AMapLocationKit/AMapLocationKit.h>

@interface HP_LocationViewController ()<UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate,AMapLocationManagerDelegate,AMapSearchDelegate>
{
    NSInteger _page;
}

//poi
@property (nonatomic,strong) AMapSearchAPI *  searchAPI;
@property (nonatomic,strong) NSMutableArray *  addressList;

@property (nonatomic,assign) BOOL           needInsertOldAddress;
@property (nonatomic,assign) BOOL           isSelectCity;

@property (nonatomic,assign) NSInteger      pageIndex;
@property (nonatomic,assign) NSInteger      pageCount;

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

-(UISearchBar *)searchBar {
    if (!_searchBar) {
        _searchBar = [UISearchBar new];
        
        _searchBar = [[UISearchBar alloc]initWithFrame:CGRectMake(35, 10, KScreenW-70, 35)];
        _searchBar.layer.borderColor = HEXCOLOR(0xfe6d6a).CGColor;
        _searchBar.layer.cornerRadius = 4;
        _searchBar.tintColor = HEXCOLOR(0xfe6d6a);
         //        _searchBar.translucent = NO;
        [_searchBar setImage:[UIImage imageNamed:@"index_searchi"] forSearchBarIcon:UISearchBarIconSearch state:UIControlStateNormal];
        _searchBar.placeholder = @"请输入商品或门店";
        _searchBar.delegate = self;
        UIView *superView = self.searchBar.subviews.lastObject;
        for (UIView *view in superView.subviews) {
            if ([view isKindOfClass:[UITextField class]]) {
                view.backgroundColor = RGBA(173, 200, 242, 0.4);
            }else if ([NSStringFromClass([view class]) isEqualToString:@"UISearchBarBackground"]) {
                [view removeFromSuperview];
            }
        }
        //取出textfield
        UITextField *searchField = [self.searchBar valueForKey:@"_searchField"];
        //改变searcher的textcolor
        searchField.textColor = RGB(144, 156, 192);
        //改变placeholder的颜色
        [searchField setValue:[UIColor whiteColor] forKeyPath:@"_placeholderLabel.textColor"];
        //改变placeholder的字体
        [searchField setValue:SYSTEMFONT(14) forKeyPath:@"_placeholderLabel.font"];
        
        searchField.layer.cornerRadius = 29/2;
        searchField.layer.masksToBounds = YES;
    }
    return _searchBar;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self creatTableViewInterface];
   
    [self LocationMapManagerInit];

    UIView *superView = self.searchBar.subviews.lastObject;
    for (UIView *view in superView.subviews) {
        if ([view isKindOfClass:[UITextField class]]) {
            view.backgroundColor = RGBA(173, 200, 242, 0.4);
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
 
    
    //[self searchApISetting];
    
    weakSelf(weakSelf);
    //上拉加载
    _location_TableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        
        _pageIndex ++ ;
        //        [weakSelf PostRequst];
        
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
    self.pageIndex = 0;
    self.pageCount = 10;
    [self footRefreshing];
}

- (void)footRefreshing{
    self.pageIndex += 1;
    [self searchApISetting];
}
#pragma mark  - 高德POI设置 AMapSearchDelegate
-(void)searchApISetting
{
 
    self.searchAPI = [[AMapSearchAPI alloc] init];
    self.searchAPI.delegate = self;
    
    AMapPOIAroundSearchRequest *request = [[AMapPOIAroundSearchRequest alloc] init];
    request.location = [AMapGeoPoint locationWithLatitude:_currentLocation.coordinate.latitude longitude:_currentLocation.coordinate.longitude];
    NSLog(@" lat:%f; lon:%f ",_currentLocation.coordinate.latitude,_currentLocation.coordinate.longitude);
    request.requireExtension = YES;
    request.requireSubPOIs  = YES;
    request.keywords = @"";
    request.radius   = 3000;
    request.sortrule   = 0;///排序规则, 0-距离排序；1-综合排序, 默认1
    request.page     = self.pageIndex;//页数
    request.offset   = self.pageCount;//当前页数
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
    [self.location_TableView reloadData];

    self.location_TableView.mj_footer.hidden = response.pois.count != self.pageIndex;
    
    [self.location_TableView.mj_header endRefreshing];
    [self.location_TableView.mj_footer endRefreshing];
    
    [SVProgressHUD  dismiss];

    
    
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
    
    // 发起周边搜索
    [self settingPOI];
    
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
                                 dequeueReusableCellWithIdentifier:@"HPLocationCellid"];
        AMapPOI *info         = self.addressList[indexPath.row];
        cell.lb_title.text    = info.name.length > 0 ? info.name : info.city;
        cell.lb_detail.text   = info.address;
        
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


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
