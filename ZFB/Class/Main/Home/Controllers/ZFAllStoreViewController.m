//
//  ZFAllStoreViewController.m
//  ZFB
//
//  Created by  展富宝  on 2017/5/19.
//  Copyright © 2017年 com.zfb. All rights reserved.
//

#import "ZFAllStoreViewController.h"
#import "AllStoreCell.h"
#import "SDCycleScrollView.h"

#import "DetailStoreViewController.h"
#import "AllStoreModel.h"
#import <AMapLocationKit/AMapLocationKit.h>

@interface ZFAllStoreViewController ()<UITableViewDelegate,UITableViewDataSource,SDCycleScrollViewDelegate,AMapLocationManagerDelegate,XHStarRateViewDelegate>
{
    NSInteger _pageSize;//每页显示条数
    NSInteger _pageIndex;//当前页码;
    NSInteger _starNum;//星星个数;
    BOOL _isChanged;//切换距离最近

}
@property (nonatomic,strong) NSMutableArray * allStoreArray;//全部门店数据源
@property (nonatomic,strong) NSMutableArray * farawayStoreArray;//距离最近数据源
@property (nonatomic,strong) UITableView * all_tableview;
@property (nonatomic,strong) UIView * sectionView;
@property (nonatomic,strong) UIButton * farway_btn;
@property (nonatomic,strong) UIButton * all_btn;
@property (nonatomic,weak  ) UIButton *selectedBtn;


//高德api
@property (nonatomic,strong) AMapLocationManager * locationManager;
@property (nonatomic,strong) AMapLocationReGeocode * reGeocode;//地理编码
@property (nonatomic,strong) CLLocation *  currentLocation;
/**
 *  持续定位是否返回逆地理信息，默认NO。
 */
@property (nonatomic, assign) BOOL locatingWithReGeocode;
@end

@implementation ZFAllStoreViewController
-(NSMutableArray *)allStoreArray{
    if (!_allStoreArray) {
        _allStoreArray =[NSMutableArray array];
    }
    return _allStoreArray;
}
-(NSMutableArray *)farawayStoreArray{
    if (!_farawayStoreArray) {
        _farawayStoreArray = [NSMutableArray array];
    }
    return _farawayStoreArray;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //默认一个页码 和 页数
    _pageSize = 10;
    _pageIndex = 1;
    _isChanged = NO;//默认切换到距离最近 （No?yes : 距离最近 /全部）

    [self initAll_tableviewInterface];
    [self CDsyceleSettingRunningPaint];
    [self creatButtonWithDouble];
    [self LocationMapManagerInit];
  //  [self FarawayStorePostRequst];//默认展示距离最近

}

-(void)initAll_tableviewInterface
{
    
    self.title =@"全部门店";
    self.all_tableview = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, KScreenW, KScreenH - 64) style:UITableViewStylePlain];
    [self.view addSubview:self.all_tableview];
    self.all_tableview.delegate = self;
    self.all_tableview.dataSource= self;
    [self.all_tableview registerNib:[UINib nibWithNibName:@"AllStoreCell" bundle:nil] forCellReuseIdentifier:@"AllStoreCell"];
    
}

/**初始化轮播 */
-(void)CDsyceleSettingRunningPaint
{
    // 情景二：采用网络图片实现
    NSArray *imagesURLStrings = @[
                                  @"https://ss2.baidu.com/-vo3dSag_xI4khGko9WTAnF6hhy/super/whfpf%3D425%2C260%2C50/sign=a4b3d7085dee3d6d2293d48b252b5910/0e2442a7d933c89524cd5cd4d51373f0830200ea.jpg",
                                  @"https://ss0.baidu.com/-Po3dSag_xI4khGko9WTAnF6hhy/super/whfpf%3D425%2C260%2C50/sign=a41eb338dd33c895a62bcb3bb72e47c2/5fdf8db1cb134954a2192ccb524e9258d1094a1e.jpg",
                                  @"http://c.hiphotos.baidu.com/image/w%3D400/sign=c2318ff84334970a4773112fa5c8d1c0/b7fd5266d0160924c1fae5ccd60735fae7cd340d.jpg"
                                  ];
    
    // 网络加载 --- 创建自定义图片的pageControlDot的图片轮播器
    SDCycleScrollView *  _cycleScrollView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, KScreenW, 150) delegate:self placeholderImage:[UIImage imageNamed:@"placeholder"]];
    _cycleScrollView.imageURLStringsGroup = imagesURLStrings;
    _cycleScrollView.pageControlAliment = SDCycleScrollViewPageContolAlimentCenter;
    _cycleScrollView.delegate = self;
    
    //自定义dot 大小和图案pageControlCurrentDot
    _cycleScrollView.currentPageDotImage = [UIImage imageNamed:@"dot_normal"];
    _cycleScrollView.pageDotImage = [UIImage imageNamed:@"dot_selected"];
    _cycleScrollView.currentPageDotColor = [UIColor whiteColor]; // 自定义分页控件小圆标颜色
    self.all_tableview.tableHeaderView = _cycleScrollView;
    
}

#pragma mark - SDCycleScrollViewDelegate
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index
{
    NSLog(@"---点击了第%ld张图片", (long)index);
    
    //  [self.navigationController pushViewController:[NSClassFromString(@"DemoVCWithXib") new] animated:YES];
}

-(void)starRateView:(XHStarRateView *)starRateView currentScore:(CGFloat)currentScore
{
    
    NSLog(@"currentScore = %f",currentScore);
}
#pragma mark -  tableViewDelegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
//    if (_isChanged == NO ) {
//        return self.farawayStoreArray.count;
//    }
//    else{
//        return self.allStoreArray.count;
//    }
    return 3;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 88;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return 40;
    }
    return 0;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return self.sectionView;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    AllStoreCell *all_cell = [self.all_tableview dequeueReusableCellWithIdentifier:@"AllStoreCell" forIndexPath:indexPath];
    all_cell.selectionStyle = UITableViewCellSelectionStyleNone;

    if (_isChanged == NO) {
//        AllStoreModel * listModel =  [AllStoreModel new];
//
//        if (indexPath.row < [self.farawayStoreArray count]) {
//            listModel  = [self.farawayStoreArray objectAtIndex:indexPath.row];
//            
//        }
//        CGFloat juli = [listModel.juli floatValue]*0.001;
        all_cell.lb_distance.text = [NSString stringWithFormat:@"%.2fkm",9.001];
//        [all_cell.img_allStoreView sd_setImageWithURL:[NSURL URLWithString:listModel.urls] placeholderImage:nil];
        
        return all_cell;

    }else{
//        AllStoreModel * listModel =  [AllStoreModel new];
//        if (indexPath.row < [self.allStoreArray count]) {
//            
//            listModel  = [self.allStoreArray objectAtIndex:indexPath.row];
//        }
//        CGFloat juli = [listModel.juli floatValue]*0.001;
        all_cell.lb_distance.text = [NSString stringWithFormat:@"%.2f公里",3.04];
//        [all_cell.img_allStoreView sd_setImageWithURL:[NSURL URLWithString:listModel.urls] placeholderImage:nil];
        return all_cell;

    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@" section= %ld ,row =  %ld",indexPath.section ,indexPath.row);
    DetailStoreViewController * detailStroeVC =[[ DetailStoreViewController alloc]init];

    if (_isChanged == NO) {
        //跳转到门店详情
        AllStoreModel * listModel = self.farawayStoreArray[indexPath.row];
        detailStroeVC.storeId =listModel.storeId;
        [self.navigationController pushViewController:detailStroeVC animated:YES];
    }else{
        //跳转到门店详情
        AllStoreModel * listModel = self.allStoreArray[indexPath.row];
        detailStroeVC.storeId =listModel.storeId;
        [self.navigationController pushViewController:detailStroeVC animated:YES];
    }

}

-(void)creatButtonWithDouble
{
    self.sectionView =[[ UIView alloc]initWithFrame:CGRectMake(0, 0, KScreenW, 40)];
    self.farway_btn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.farway_btn.frame =CGRectMake( 0, 0, KScreenW*0.5, 40);
    [self.farway_btn setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 20)];
    [self.farway_btn setImageEdgeInsets:UIEdgeInsetsMake(0, 120, 0, 0)];
    [self.farway_btn setTitle:@"距离最近" forState:UIControlStateNormal];
    
    self.farway_btn.backgroundColor = HEXCOLOR(0xffcccc);
    [ self.farway_btn setImage:[UIImage imageNamed:@"arrows_down_white"] forState:UIControlStateNormal];
    self.farway_btn.titleLabel.font = [UIFont systemFontOfSize:14];
    [ self.farway_btn addTarget:self action:@selector(buttonBtnClickFaraway:) forControlEvents:UIControlEventTouchUpInside];
    [self.sectionView  addSubview: _farway_btn];
    
    
    _all_btn = [UIButton buttonWithType:UIButtonTypeCustom];
    _all_btn.frame =CGRectMake(KScreenW *0.5 , 0, KScreenW*0.5, 40);
    _all_btn.titleLabel.font = [UIFont systemFontOfSize:14];
    [_all_btn setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 20)];
    [_all_btn setImageEdgeInsets:UIEdgeInsetsMake(0, 120, 0, 0)];
    [_all_btn setTitle:@"全部" forState:UIControlStateNormal];
    [_all_btn addTarget:self action:@selector(buttonBtnClickAllStore:) forControlEvents:UIControlEventTouchUpInside];
    _all_btn.backgroundColor = [UIColor whiteColor];
    
    [_all_btn setTitleColor:HEXCOLOR(0x363636) forState:UIControlStateNormal];
    [_all_btn setImage:[UIImage imageNamed:@"arrows_down_black"] forState:UIControlStateNormal];
    [self.sectionView  addSubview:_all_btn];
    
    
    
}
#pragma mark - buttonBtnClickFaraway距离最近的门店
-(void)buttonBtnClickFaraway:(UIButton *)button
{
    _isChanged = NO;
    [self.farway_btn setImage:[UIImage imageNamed:@"arrows_down_white"] forState:UIControlStateNormal];
    [self.farway_btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.farway_btn.backgroundColor = HEXCOLOR(0xffcccc);
    
    [self.all_btn setTitleColor:HEXCOLOR(0x363636) forState:UIControlStateNormal];
    [self.all_btn setImage:[UIImage imageNamed:@"arrows_down_black"] forState:UIControlStateNormal];
    self.all_btn.backgroundColor =  [UIColor whiteColor];
    
    [self.all_tableview reloadData];
    //[self FarawayStorePostRequst];
    
}
#pragma mark - buttonBtnClickAllStore全部门店
-(void)buttonBtnClickAllStore:(UIButton *)button
{
    
    _isChanged = YES;
    [self.farway_btn setTitleColor:HEXCOLOR(0x363636) forState:UIControlStateNormal];
    [self.farway_btn setImage:[UIImage imageNamed:@"arrows_down_black"] forState:UIControlStateNormal];
    self.farway_btn.backgroundColor =[UIColor whiteColor];
    
    
    [self.all_btn setImage:[UIImage imageNamed:@"arrows_down_white"] forState:UIControlStateNormal];
    [self.all_btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.all_btn.backgroundColor =  HEXCOLOR(0xffcccc);
    [self.all_tableview reloadData];
   /// [self allStorePostRequst];
    
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

#pragma mark - 全部门店网络请求
-(void)allStorePostRequst
{
    [SVProgressHUD show];

    NSString * pageSize= [NSString stringWithFormat:@"%ld",_pageSize];
    NSString * pageIndex= [NSString stringWithFormat:@"%ld",_pageIndex];
    
    NSDictionary * parma = @{
                             
                             @"svcName":@"getCmStoreInfo",
                             @"longitude":@"",//经度
                             @"latitude":@"" ,//纬度
                             @"pageSize":pageSize,//每页显示条数
                             @"pageIndex":pageIndex,//当前页码
                             @"cmUserId":BBUserDefault.cmUserId,
                             
                             };
    NSLog(@"    lat:%f; lon:%f ",_currentLocation.coordinate.latitude,_currentLocation.coordinate.longitude);

    NSDictionary *parmaDic=[NSDictionary dictionaryWithDictionary:parma];
    
    [PPNetworkHelper POST:ZFB_11SendMessageUrl parameters:parmaDic responseCache:^(id responseCache) {
        
    } success:^(id responseObject) {
        
        if ([responseObject[@"resultCode"] isEqualToString:@"0"]) {
            
            if (self.allStoreArray.count >0) {
                
                [self.allStoreArray  removeAllObjects];
                
            }else{
               
                NSString  * dataStr= [responseObject[@"data"] base64DecodedString];
                NSDictionary * jsondic = [NSString dictionaryWithJsonString:dataStr];
                NSArray * dictArray = jsondic [@"cmStoreList"];
                
                //mjextention 数组转模型
                NSArray *storArray = [AllStoreModel mj_objectArrayWithKeyValuesArray:dictArray];
                
                for (AllStoreModel *list in storArray) {
                    
                    [self.allStoreArray addObject:list];
                }
                NSLog(@"allStoreArray = %@",   self.allStoreArray);
                
                [self.all_tableview reloadData];
            }
             [SVProgressHUD dismiss];
 
        }

    } failure:^(NSError *error) {
        NSLog(@"%@",error);
        [self.view makeToast:@"网络错误" duration:2 position:@"center"];
        [SVProgressHUD dismiss];

    }];

}

#pragma mark - 距离最近门店网络请求
-(void)FarawayStorePostRequst
{
    
    [SVProgressHUD show];
    
    NSString * longitude = [NSString stringWithFormat:@"%.6f",_currentLocation.coordinate.longitude];
    NSString * latitude = [NSString stringWithFormat:@"%.6f",_currentLocation.coordinate.latitude];
    NSString * pageSize = [NSString stringWithFormat:@"%ld",_pageSize];
    NSString * pageIndex = [NSString stringWithFormat:@"%ld",_pageIndex];
    
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
        
        if ([responseObject[@"resultCode"] isEqualToString:@"0"]) {
            
            if (self.farawayStoreArray.count >0) {
                
                [self.farawayStoreArray  removeAllObjects];
                
            }else{
                
                NSString  * dataStr= [responseObject[@"data"] base64DecodedString];
                NSDictionary * jsondic = [NSString dictionaryWithJsonString:dataStr];
                NSArray * dictArray = jsondic [@"cmStoreList"];
                
                //mjextention 数组转模型
                NSArray *storArray = [AllStoreModel mj_objectArrayWithKeyValuesArray:dictArray];
                
                for (AllStoreModel *list in storArray) {
                    
                    [self.farawayStoreArray addObject:list];
                }
                NSLog(@"farawayStoreArray = %@",   self.farawayStoreArray);
                
                [self.all_tableview reloadData];
            }
             [SVProgressHUD dismiss];

        }
        
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
        [self.view makeToast:@"网络错误" duration:2 position:@"center"];
        [SVProgressHUD dismiss];

    }];
}
@end
