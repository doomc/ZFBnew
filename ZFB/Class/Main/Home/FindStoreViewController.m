

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

@interface FindStoreViewController ()<UITableViewDataSource,UITableViewDelegate ,AMapLocationManagerDelegate,AMapSearchDelegate>
{
    NSInteger _pageCount;//每页显示条数
    NSInteger _page;//当前页码;
    NSString * _loactionAddress;
    AMapSearchAPI *_search;
    
    
}
@property (strong,nonatomic) UITableView * home_tableView;
@property (strong,nonatomic) UIView * sectionView;
@property (nonatomic,strong) NSMutableArray * storeListArr;//数据源
@property (nonatomic,strong) UIButton * location_btn ;

//高德api
@property (nonatomic,strong) AMapLocationManager * locationManager;
@property (nonatomic,strong) AMapLocationReGeocode * reGeocode;//地理编码
@property (nonatomic,strong) CLLocation *  currentLocation;
@property (nonatomic,strong) AMapPOI *selectedPoi;

/**
 *  持续定位是否返回逆地理信息，默认NO。
 */
@property (nonatomic, assign) BOOL locatingWithReGeocode;

@end
@implementation FindStoreViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //默认一个页码 和 页数
    _pageCount = 8;
    
    [self LocationMapManagerInit];
    
    [self initWithHome_Tableview];
    
    [self initInTerfaceView];
    
    
    weakSelf(weakSelf);
    //上拉加载
    _home_tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        
        _page ++ ;
        [weakSelf PostRequst];
        
    }];
    
    //下拉刷新
    _home_tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        //需要将页码设置为1
        _page = 1;
        [weakSelf PostRequst];
    }];
    
}

-(UIButton *)location_btn
{
    if (!_location_btn) {
        _location_btn  = [UIButton buttonWithType:UIButtonTypeCustom];//定位按钮
        [_location_btn addTarget:self action:@selector(pushToLocationView:) forControlEvents:UIControlEventTouchUpInside];
        [_location_btn setTitleColor: HEXCOLOR(0xfa6d6a) forState:UIControlStateNormal];
        
        UIFont * font = [UIFont systemFontOfSize:13];
        _location_btn.titleLabel.font = font ;
        [_location_btn setTitle:_loactionAddress forState:UIControlStateNormal];
        [_location_btn.titleLabel  sizeToFit];
        _location_btn.titleLabel.adjustsFontSizeToFitWidth = YES;
        
        _location_btn.frame = CGRectMake(25, 0, KScreenW - 60, 30);
#pragma mark - button内文字居左
        //  _location_btn.titleLabel.textAlignment = NSTextAlignmentLeft; 无效
        _location_btn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        _location_btn.titleEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0);
    }
    return _location_btn;
}
-(void)initInTerfaceView{
    //    NSString * LoactionAddress = @"龙湖水晶国际 >";
    UIView * loc_view =[[ UIView alloc]initWithFrame:CGRectMake(0, 0, KScreenW, 40)];//背景图
    UIView * bg_view =[[UIView alloc]initWithFrame:CGRectMake(15, 5, KScreenW-15-15, 30)];
    [loc_view addSubview:bg_view];
    
    bg_view.layer.borderWidth = 1.0;
    bg_view.layer.cornerRadius = 4.0;
    bg_view.layer.borderColor = HEXCOLOR(0xfa6d6a).CGColor;
    
    //定位icon
    UIImageView * icon_locationView = [[UIImageView alloc]initWithFrame:CGRectMake(5, 5, 18, 20) ];
    icon_locationView.image =  [UIImage imageNamed:@"location_find2"];
    
    
    [bg_view addSubview:self.location_btn];
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
    [self.view addSubview:_home_tableView];
    self.home_tableView.separatorStyle =UITableViewCellSeparatorStyleNone;
    
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
  
    FindStoreCell *storeCell = [self.home_tableView  dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    storeCell.selectionStyle = UITableViewCellSelectionStyleNone;
   
    if (self.storeListArr.count > 0) {
        
        FindStoreGoodslist * listModel =  [self.storeListArr objectAtIndex:indexPath.row];
        storeCell.findgoodslist = listModel;
    }

    return storeCell;
    
}
#pragma tableViewDataSource
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@" section --- %ld ,row -----%ld",indexPath.section ,indexPath.row);    
    if (self.storeListArr.count > 0) {
        
        DetailStoreViewController * vc = [[DetailStoreViewController alloc]init];
        FindStoreGoodslist * listModel = self.storeListArr[indexPath.row];
        vc.storeId =[NSString stringWithFormat:@"%ld",listModel.storeId];
        [self.navigationController pushViewController:vc animated:YES];
    }
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

- (void)amapLocationManager:(AMapLocationManager *)manager didFailWithError:(NSError *)error
{
    NSLog(@"%@",error);
}


#pragma mark  -AMapLocationManagerDelegate
-(void)amapLocationManager:(AMapLocationManager *)manager didUpdateLocation:(CLLocation *)location
{
    // 赋值给全局变量
    _currentLocation = location;
    
    NSLog(@" lat:%f; lon:%f ",_currentLocation.coordinate.latitude,_currentLocation.coordinate.longitude);
    
    // 停止定位
    [self.locationManager stopUpdatingLocation];
    
    [self reGeoAction];
    
}

//进行逆地理编码请求
- (void)reGeoAction{
    
    if (_currentLocation) {
        AMapReGeocodeSearchRequest *request = [[AMapReGeocodeSearchRequest alloc] init];
        request.location = [AMapGeoPoint locationWithLatitude:_currentLocation.coordinate.latitude longitude:_currentLocation.coordinate.longitude];
        request.requireExtension =YES;
        
        //逆地理编码搜索请求
        _search = [[AMapSearchAPI alloc] init ];
        _search.delegate = self;
        [_search AMapReGoecodeSearch:request];
    }
    
}
#pragma mark - AMapSearchDelegate 反地理编码
//实现逆地理编码的回调函数
- (void)onReGeocodeSearchDone:(AMapReGeocodeSearchRequest *)request response:(AMapReGeocodeSearchResponse *)response
{
    if(response.regeocode != nil)
    {
        NSLog(@"反向地理编码回调:%@",response.regeocode.addressComponent.township);
        NSLog(@"反向地理编码回调:%@",response.regeocode.addressComponent.district);
        NSLog(@"反向地理编码回调:%@",response.regeocode.addressComponent.city);
        NSLog(@"反向地理编码回调:%@",response.regeocode.addressComponent.neighborhood);
        
        NSArray * addressArr = response.regeocode.pois;
        
        if (addressArr && addressArr.count >0) {
            AMapPOI *poiTemp = addressArr[0];
            
            NSLog(@"----反向地理编码回调:%@",poiTemp.name);
            NSLog(@"----反向地理编码回调:%@",poiTemp.address);
            _loactionAddress = [NSString stringWithFormat:@"%@%@",poiTemp.name ,poiTemp.address];
        }
        
        [self.location_btn setTitle:_loactionAddress forState:UIControlStateNormal];
        //通过AMapReGeocodeSearchResponse对象处理搜索结果
        NSString *result = [NSString stringWithFormat:@"ReGeocode: %@", response.regeocode];
        NSLog(@"ReGeo: %@", result);
    }
    
}

- (void)AMapSearchRequest:(id)request didFailWithError:(NSError *)error
{
    NSLog(@"xxxxxxxxxxxx--------%@---------xxxxxxxxxxx" ,error);
}

#pragma mark - 首页网络请求 getCmStoreInfo
-(void)PostRequst
{
    [self.home_tableView.mj_header endRefreshing];
    
    NSLog(@"    lat:%f; lon:%f ",_currentLocation.coordinate.latitude,_currentLocation.coordinate.longitude);
    NSString * longitude = [NSString stringWithFormat:@"%.6f",_currentLocation.coordinate.longitude];
    NSString * latitude = [NSString stringWithFormat:@"%.6f",_currentLocation.coordinate.latitude];
    NSString * pageSize= [NSString stringWithFormat:@"%ld",_pageCount];
    NSString * pageIndex= [NSString stringWithFormat:@"%ld",_page];
    
    BBUserDefault.longitude = longitude;
    BBUserDefault.latitude = latitude;
    
    
    if (kStringIsEmpty(BBUserDefault.cmUserId)) {
        BBUserDefault.cmUserId =@"";
    }
    NSDictionary * parma = @{
                             
                             //                             @"userId":BBUserDefault.cmUserId,
                             @"svcname":@"",
                             @"longitude":longitude,//经度
                             @"latitude":latitude ,//纬度
                             @"pageSize":pageSize,//每页显示条数
                             @"pageIndex":pageIndex,//当前页码
                             @"businessType":@"",
                             @"payType":@"",
                             @"orderBydisc":@"",
                             @"orderbylikeNum":@"",
                             @"nearBydisc":@"",
                             @"sercahText":@"",
                             
                             };
    
    NSLog(@" 参与加密的参数  ----------- %@ ======parma" ,parma);
    
    [MENetWorkManager post:[NSString stringWithFormat:@"%@/getCmStoreInfo",zfb_baseUrl] params:parma success:^(id response) {
        
        if (_page == 1) {
            
            if (self.storeListArr.count > 0) {
                
                [self.storeListArr removeAllObjects];
                
            }
        }
        HomeStoreListModel  * homeStore = [HomeStoreListModel mj_objectWithKeyValues:response];
        for (Storeinfolist * storelist in homeStore.storeInfoList.findGoodsList) {
            
            [self.storeListArr addObject:storelist];
        }
        
        NSLog(@"门店列表 = %@",   self.storeListArr);
        [self.home_tableView reloadData];
        [self.home_tableView.mj_header endRefreshing];
        [self.home_tableView.mj_footer endRefreshing];
        
        
    } progress:^(NSProgress *progeress) {
        
        NSLog(@"progeress=====%@",progeress);
        
    } failure:^(NSError *error) {
        
        [self.home_tableView.mj_header endRefreshing];
        [self.home_tableView.mj_footer endRefreshing];
        [self.view makeToast:@"网络错误" duration:2 position:@"center"];
        NSLog(@"error=====%@",error);
        
    }];
 
}


-(void)viewWillAppear:(BOOL)animated
{
    [self.home_tableView.mj_header beginRefreshing];
    
}

-(NSMutableArray *)storeListArr
{
    if (!_storeListArr) {
        _storeListArr = [NSMutableArray array];
    }
    return _storeListArr;
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
