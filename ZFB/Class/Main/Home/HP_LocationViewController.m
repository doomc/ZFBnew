//
//  HP_LocationViewController.m
//  ZFB
//
//  Created by  展富宝  on 2017/5/17.
//  Copyright © 2017年 com.zfb. All rights reserved.
//  首页定位
#define SelectLocation_Not_Show @"不显示位置"
const static NSString *ApiKey = @"fc306f20d58121a5168f017bc6bf39e4";

#import "HP_LocationViewController.h"
#import "SearchCell.h"
#import "MJRefresh.h"
//高德api
#import <AMapLocationKit/AMapLocationKit.h>
@interface HP_LocationViewController ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate,AMapLocationManagerDelegate,MAMapViewDelegate,AMapSearchDelegate>

//poi
@property (nonatomic,strong) AMapSearchAPI *  searchAPI;
@property (nonatomic,strong) NSMutableArray *  addressList;

@property (nonatomic,assign) BOOL           needInsertOldAddress;
@property (nonatomic,assign) BOOL           isSelectCity;

@property (nonatomic,assign) NSInteger      pageIndex;
@property (nonatomic,assign) NSInteger      pageCount;
//end
@property (nonatomic,strong) UITableView * location_TableView;
@property (nonatomic,strong) UITextField * tf_search;
@property (nonatomic,strong) UIView * bgView;

//高德api
@property (nonatomic,strong) AMapLocationManager * locationManager;
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
    
    [self locationinit];
    
    [self searchApISetting];
    
    [self settingPOI];
}
#warning ============= poi ===============
-(void)settingPOI{
    AMapPOI *first  = [[AMapPOI alloc] init];
    first.name      = SelectLocation_Not_Show;
    [self.addressList addObject:first];
    
    if (self.oldPoi) {
        AMapPOI *poi                = self.oldPoi;
        self.needInsertOldAddress   = poi.address.length > 0;
        self.isSelectCity           = poi.address.length == 0;
    }
    
    [self.view addSubview:self.location_TableView];
    [AMapServices sharedServices].apiKey = (NSString *)ApiKey;
    
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
#pragma mark  - 高德POI设置
-(void)searchApISetting
{
    
    AMapPOIAroundSearchRequest *request = [[AMapPOIAroundSearchRequest alloc] init];
    
    self.searchAPI = [[AMapSearchAPI alloc] init];
    self.searchAPI.delegate = self;
    
    request.location                    = [AMapGeoPoint locationWithLatitude:23.107307 longitude:113.384098];
    //request.location = [AMapGeoPoint locationWithLatitude:self.currentLocation.coordinate.latitude longitude:self.currentLocation.coordinate.longitude];
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
    
    if (self.addressList.count == 1) {
        AMapPOI *poi = [[AMapPOI alloc] init];
        poi.city     = ((AMapPOI *)response.pois.firstObject).city;
        [self.addressList addObject:poi];
    }
    
    [self.addressList addObjectsFromArray:response.pois];
    
    [self.location_TableView reloadData];
    
    self.location_TableView.mj_footer.hidden = response.pois.count != self.pageCount;
    
    [self.location_TableView.mj_header endRefreshing];
    [self.location_TableView.mj_footer endRefreshing];
    
    
    
}

#warning ============= poi ===============
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
    self.location_TableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 114, KScreenW, KScreenH - 114) style:UITableViewStyleGrouped];
    [self.view addSubview:self.location_TableView];
    
    self.location_TableView.dataSource = self;
    self.location_TableView.delegate = self;
    
    [self.location_TableView registerNib:[UINib nibWithNibName:@"SearchCell" bundle:nil] forCellReuseIdentifier:@"SearchCell"];
    
    self.location_TableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        //        __strong __typeof(weakSelf) strongSelf = weakSelf;
        [self headRefreshing];
    }];
    self.location_TableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        //        __strong __typeof(weakSelf) strongSelf = weakSelf;
        [self footRefreshing];
    }];
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
    UITableViewCell * cell = [self.location_TableView dequeueReusableCellWithIdentifier:@"cell"];
    
    if (indexPath.section == 0) {
        
        SearchCell * searchCell = [self.location_TableView dequeueReusableCellWithIdentifier:@"SearchCell" forIndexPath:indexPath];
        return searchCell;
    }
    if (indexPath.section == 1 ) {
        
        if (!cell) {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cell"];
        }
        cell.textLabel.font =[ UIFont systemFontOfSize:12];
        cell.textLabel.textColor = HEXCOLOR(0x363636);
        AMapPOI *info               = self.addressList[indexPath.row];
        cell.textLabel.text         = info.name.length > 0 ? info.name : info.city;
        cell.detailTextLabel.text   = info.address;
        
        cell.accessoryType  = UITableViewCellAccessoryNone;
        
        if (self.oldPoi && indexPath.row == 2) {
            if (self.isSelectCity) {
                cell.accessoryType  = UITableViewCellAccessoryNone;
            }else{
                cell.accessoryType  = UITableViewCellAccessoryCheckmark;
            }
        }else if (!self.oldPoi        && indexPath.row == 0) {
            cell.accessoryType      = UITableViewCellAccessoryCheckmark;
        }else if (self.isSelectCity   && indexPath.row == 1){
            cell.accessoryType      = UITableViewCellAccessoryCheckmark;
        }
        
        return cell;
        
    }
    return nil;
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 1) {
        AMapPOI *info = self.addressList[indexPath.row];
        if (self.successBlock) {
            self.successBlock([info.name isEqualToString:SelectLocation_Not_Show] ? nil : info);
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
