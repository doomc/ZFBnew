//
//  ZFAllStoreViewController.m
//  ZFB
//
//  Created by  展富宝  on 2017/5/19.
//  Copyright © 2017年 com.zfb. All rights reserved.
//  全部门店

#import "ZFAllStoreViewController.h"
#import "AllStoreCell.h"
#import "SDCycleScrollView.h"

#import "DetailStoreViewController.h"
#import "AllStoreModel.h"
//map
#import <CoreLocation/CoreLocation.h>

//view
#import "ZspMenu.h"
@interface ZFAllStoreViewController ()<UITableViewDelegate,UITableViewDataSource,SDCycleScrollViewDelegate,CLLocationManagerDelegate,ZspMenuDataSource, ZspMenuDelegate>
{
    NSInteger _pageSize;//每页显示条数
    NSInteger _pageIndex;//当前页码;
    NSInteger _starNum;//星星个数;
    NSString * _storeTypeInfo;//门店类型
    BOOL _isChanged;//切换距离最近
    CGFloat tableViewHeight ;
    
    NSString *currentCityAndStreet;//当前城市
    NSString *latitudestr;//经度
    NSString *longitudestr;//纬度
    
  
    
}
@property (nonatomic,strong) NSMutableArray * allStoreArray;//全部门店数据源
@property (nonatomic,strong) NSMutableArray * farawayStoreArray;//距离最近数据源
@property (nonatomic,strong) NSMutableArray * listArray;//弹框数据源
@property (nonatomic,strong) NSArray        * imgArray;//轮播图
@property (nonatomic,strong) NSArray        * titlelistArray;//门店列表选项

@property (nonatomic,strong) UITableView * all_tableview;
@property (nonatomic,strong) UITableView * select_tableview;
@property (nonatomic,strong) UIView      * sectionView;
@property (nonatomic,strong) UIButton    * farway_btn;
@property (nonatomic,strong) UIButton    * all_btn;
@property (nonatomic,weak  ) UIButton    * selectedBtn;

//高德api
@property (nonatomic,strong) CLLocationManager * locationManager;

@property (nonatomic, strong) ZspMenu *menu;
@property (nonatomic, strong) NSArray *sort;
@property (nonatomic, strong) NSArray *choose;

@end

@implementation ZFAllStoreViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title =@"全部门店";
    
    self.sort = @[@"全部", @"离我最近", @"好评优先", @"人气最高"];
    self.choose = @[@"距离最近", @"折扣商品", @"进店领券", @"下单返券"];
 
    
    //默认一个页码 和 页数
    _pageSize  = 6;
    _isChanged = YES;//默认切换全部 （No?yes : 距离最近 /全部）
    
    _imgArray = [NSArray array];
    
    [self.view addSubview:self.all_tableview];
    [self.all_tableview registerNib:[UINib nibWithNibName:@"AllStoreCell" bundle:nil]
             forCellReuseIdentifier:@"AllStoreCell"];
    [self.select_tableview registerNib:[UINib nibWithNibName:@"SelectTableviewCell" bundle:nil]forCellReuseIdentifier:@"SelectTableviewCell"];
    
    
    [self LocationMapManagerInit];

    
//    [self creatButtonWithDouble];
    [self CDsyceleSettingRunningPaintWithArray:self.imgArray];
    [self refreshAuto];
 
}


-(void)refreshAuto
{
    weakSelf(weakSelf);
    //上拉加载
    _all_tableview.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        
        _pageIndex ++ ;
        [weakSelf allStorePostRequstAndbusinessType:@"" orderBydisc:@"" orderbylikeNum:@"" nearBydisc:@""];//默认全部
        
    }];
    
    //下拉刷新
    _all_tableview.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        //需要将页码设置为1
        _pageIndex = 1;
        [weakSelf allStorePostRequstAndbusinessType:@"" orderBydisc:@"" orderbylikeNum:@"" nearBydisc:@""];//默认全部
    }];
    
}

-(UITableView *)all_tableview
{
    if (!_all_tableview) {
        _all_tableview            = [[UITableView alloc]initWithFrame:CGRectMake(0, 64+150+44, KScreenW, KScreenH - 64-44-150) style:UITableViewStylePlain];
        _all_tableview.delegate   = self;
        _all_tableview.dataSource = self;
    }
    return _all_tableview;
}

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
/**初始化轮播 */
-(void)CDsyceleSettingRunningPaintWithArray:(NSArray *)imgArray
{
    // 网络加载 --- 创建自定义图片的pageControlDot的图片轮播器
    SDCycleScrollView *  _cycleScrollView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 64, KScreenW, 150) delegate:self placeholderImage:[UIImage imageNamed:@"placeholder"]];
    _cycleScrollView.imageURLStringsGroup = imgArray;
    _cycleScrollView.pageControlAliment   = SDCycleScrollViewPageContolAlimentCenter;
    _cycleScrollView.delegate             = self;
    
    //自定义dot 大小和图案pageControlCurrentDot
    _cycleScrollView.currentPageDotImage = [UIImage imageNamed:@"dot_normal"];
    _cycleScrollView.pageDotImage        = [UIImage imageNamed:@"dot_selected"];
    _cycleScrollView.currentPageDotColor = [UIColor whiteColor];// 自定义分页控件小圆标颜色
    [self.view addSubview:_cycleScrollView];
    
    _menu = [[ZspMenu alloc] initWithOrigin:CGPointMake(0, 64+150) andHeight:44];
    _menu.delegate = self;
    _menu.dataSource = self;
    [_menu selectDeafultIndexPath];
    [self.view addSubview:_menu];

    
}

#pragma mark - SDCycleScrollViewDelegate
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index
{
    NSLog(@"---点击了第%ld张图片", (long)index);
    
    //  [self.navigationController pushViewController:[NSClassFromString(@"DemoVCWithXib") new] animated:YES];
}


#pragma mark -  tableViewDelegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger count = 2 ;
//    
//    if (_isChanged == NO ) {
//        return self.farawayStoreArray.count;
//    }
//    else{
//        return self.allStoreArray.count;
//    }
//    
    
    return count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat height = 88;
    return height;
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    AllStoreCell *all_cell = [self.all_tableview
                              dequeueReusableCellWithIdentifier:@"AllStoreCell" forIndexPath:indexPath];
    
    all_cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    Findgoodslists * goodlist = [self.allStoreArray objectAtIndex:indexPath.row];
    Findgoodslists * farlist = [self.farawayStoreArray objectAtIndex:indexPath.row];
    all_cell.Storelist        = goodlist;
    all_cell.Storelist        = farlist;
    
    if (_isChanged == NO) {
        
        //初始化五星好评控件
        all_cell.starView .needIntValue = YES;//是否整数显示，默认整数显示
        all_cell.starView .canTouch     = NO;//是否可以点击，默认为NO
        NSNumber *number                = [NSNumber numberWithFloat:farlist.starLevel];
        all_cell.starView .scoreNum     = number;//星星显示个数
        all_cell.starView .normalColorChain(HEXCOLOR(0xdedede));
        all_cell.starView .highlightColorChian(HEXCOLOR(0xfe6d6a));
       
        return all_cell;
        
    }else{
        //初始化五星好评控件
        all_cell.starView .needIntValue = NO;//是否整数显示，默认整数显示
        all_cell.starView .canTouch     = NO;//是否可以点击，默认为NO
        NSNumber *number                = [NSNumber numberWithFloat:goodlist.starLevel];
        all_cell.starView .scoreNum     = number;//星星显示个数
        all_cell.starView .normalColorChain(HEXCOLOR(0xdedede));
        all_cell.starView .highlightColorChian(HEXCOLOR(0xfe6d6a));
        
        return all_cell;
    }
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    NSLog(@" section1==== %ld ,row1 ====  %ld",indexPath.section ,indexPath.row);
    
    DetailStoreViewController * detailStroeVC =[[ DetailStoreViewController alloc]init];
    Findgoodslists * goodlist    = self.allStoreArray[indexPath.row];
    Findgoodslists * farawaylist = self.farawayStoreArray[indexPath.row];
    
    if (_isChanged == YES) {
        //跳转到门店详情
        detailStroeVC.storeId = [NSString stringWithFormat:@"%ld",goodlist.storeId];
        [self.navigationController pushViewController:detailStroeVC animated:YES];
    }else{
        //跳转到门店详情
        detailStroeVC.storeId = [NSString stringWithFormat:@"%ld",farawaylist.storeId];
        [self.navigationController pushViewController:detailStroeVC animated:YES];
    }
    
}

-(void)creatButtonWithDouble
{
    
    self.sectionView =[[ UIView alloc]initWithFrame:CGRectMake(0, 0, KScreenW, 40)];
    
    _all_btn                 = [UIButton buttonWithType:UIButtonTypeCustom];
    _all_btn.frame           = CGRectMake( 0, 0, KScreenW*0.5, 40);
    _all_btn.titleLabel.font = [UIFont systemFontOfSize:14];
    _all_btn.backgroundColor = HEXCOLOR(0xffcccc);
    [_all_btn setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 20)];
    [_all_btn setImageEdgeInsets:UIEdgeInsetsMake(0, 120, 0, 0)];
    [_all_btn setTitle:@"全部" forState:UIControlStateNormal];
    [_all_btn addTarget:self action:@selector(buttonBtnClickAllStore:) forControlEvents:UIControlEventTouchUpInside];
    [_all_btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_all_btn setImage:[UIImage imageNamed:@"arrows_down_white"] forState:UIControlStateNormal];
    [self.sectionView  addSubview:_all_btn];
    
    
    _farway_btn       = [UIButton buttonWithType:UIButtonTypeCustom];
    _farway_btn.frame = CGRectMake(KScreenW *0.5 , 0, KScreenW*0.5, 40);
    [_farway_btn setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 20)];
    [_farway_btn setImageEdgeInsets:UIEdgeInsetsMake(0, 120, 0, 0)];
    [_farway_btn setTitle:@"距离最近" forState:UIControlStateNormal];
    [_farway_btn setTitleColor:HEXCOLOR(0x363636)forState:UIControlStateNormal];
    _farway_btn.backgroundColor = [UIColor whiteColor];
    [_farway_btn setImage:[UIImage imageNamed:@"arrows_down_black"] forState:UIControlStateNormal];
    _farway_btn.titleLabel.font = [UIFont systemFontOfSize:14];
    [_farway_btn addTarget:self action:@selector(buttonBtnClickFaraway:) forControlEvents:UIControlEventTouchUpInside];
    [self.sectionView  addSubview: _farway_btn];
    
    
}
#pragma mark - buttonBtnClickFaraway距离最近的门店
-(void)buttonBtnClickFaraway:(UIButton *)button
{
    _isChanged = NO;
    
    [self.farway_btn setTitleColor:[UIColor whiteColor]forState:UIControlStateNormal];
    [self.farway_btn setImage:[UIImage imageNamed:@"arrows_down_white"] forState:UIControlStateNormal];
    self.farway_btn.backgroundColor = HEXCOLOR(0xffcccc);
    
    [self.all_btn setTitleColor:HEXCOLOR(0x363636) forState:UIControlStateNormal];
    [self.all_btn setImage:[UIImage imageNamed:@"arrows_down_black"] forState:UIControlStateNormal];
    self.all_btn.backgroundColor = [UIColor whiteColor];
    
    [self.all_tableview reloadData];
    
        [self allStorePostRequstAndbusinessType:@"" orderBydisc:@"" orderbylikeNum:@"" nearBydisc:@""];
  
}

#pragma mark - buttonBtnClickAllStore全部门店
-(void)buttonBtnClickAllStore:(UIButton *)button
{
    _isChanged = YES;
    
    [self.farway_btn setImage:[UIImage imageNamed:@"arrows_down_black"] forState:UIControlStateNormal];
    [self.farway_btn setTitleColor:HEXCOLOR(0x363636) forState:UIControlStateNormal];
    self.farway_btn.backgroundColor =[UIColor whiteColor];
    
    [self.all_btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.all_btn setImage:[UIImage imageNamed:@"arrows_down_white"] forState:UIControlStateNormal];
    self.all_btn.backgroundColor = HEXCOLOR(0xffcccc);
    
    if (self.allStoreArray.count > 0 ) {
        
        [self.allStoreArray removeAllObjects];
    }
    [self.all_tableview reloadData];
    
    [self allStorePostRequstAndbusinessType:@"" orderBydisc:@"" orderbylikeNum:@"" nearBydisc:@""];
    
}

#pragma mark - YBPopupMenuDelegate
- (void)ybPopupMenuDidSelectedAtIndex:(NSInteger)index ybPopupMenu:(YBPopupMenu *)ybPopupMenu
{
    NSString * str = _titlelistArray[index];
    
    NSLog(@"  我点了 -----%ld --str       = %@" ,index,str);
 
    [self FarawayStorePostRequstAndbusinessType:@"" orderBydisc:@"" orderbylikeNum:@"" nearBydisc:@""sercahText:str];
    
}
#pragma mark  - 高德定位
/**定位当前 */
-(void)LocationMapManagerInit
{
    //判断定位功能是否打开
    if ([CLLocationManager locationServicesEnabled]) {
        
        _locationManager = [[CLLocationManager alloc]init];
        _locationManager.distanceFilter = 200;
        _locationManager.delegate = self;
        [_locationManager requestAlwaysAuthorization];
        currentCityAndStreet = [NSString new];
        [_locationManager requestWhenInUseAuthorization];
        
        //设置寻址精度
        _locationManager.desiredAccuracy = kCLLocationAccuracyBest;
        _locationManager.distanceFilter = 5.0;
        [_locationManager startUpdatingLocation];
    }
    
}
#pragma mark CoreLocation delegate (定位失败)
//定位失败后调用此代理方法
-(void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    [self.view makeToast:[NSString stringWithFormat:@"%@",error] duration:2 position:@"center"];

//    //设置提示提醒用户打开定位服务
//    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"允许定位提示" message:@"请在设置中打开定位" preferredStyle:UIAlertControllerStyleAlert];
//    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"打开定位" style:UIAlertActionStyleDefault handler:nil];
//    
//    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
//    [alert addAction:okAction];
//    [alert addAction:cancelAction];
//    [self presentViewController:alert animated:YES completion:nil];
}

#pragma mark 定位成功后则执行此代理方法
-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations
{
    //旧址
    CLLocation *currentLocation = [locations lastObject];
 
    //打印当前的经度与纬度
    NSLog(@"%f,%f",currentLocation.coordinate.latitude,currentLocation.coordinate.longitude);
    latitudestr = [NSString stringWithFormat:@"%f",currentLocation.coordinate.latitude];
    longitudestr = [NSString stringWithFormat:@"%f",currentLocation.coordinate.longitude];
  
    [_locationManager stopUpdatingHeading];
    
}


#pragma mark - 全部门店网络请求
-(void)allStorePostRequstAndbusinessType:(NSString *)businessType
                             orderBydisc:(NSString *)orderBydisc
                         orderbylikeNum :(NSString *)orderbylikeNum
                              nearBydisc:(NSString *)nearBydisc
{
    
    NSString * pageSize  = [NSString stringWithFormat:@"%ld",_pageSize];
    NSString * pageIndex = [NSString stringWithFormat:@"%ld",_pageIndex];
    
    
    NSDictionary * parma = @{
                             
                             @"longitude":longitudestr,//经度
                             @"latitude":latitudestr ,//纬度
                             @"pageSize":pageSize,//每页显示条数
                             @"pageIndex":pageIndex,//当前页码
                             
                             @"businessType":businessType,//经营种类       如:服装，小吃等等
                             @"payType":@"",//是否支持到店付款    1支持  0不支持
                             @"orderBydisc":orderBydisc,//距离排序   1升   0降
                             @"orderbylikeNum":orderbylikeNum,//	人气排序   1升   0降
                             @"nearBydisc":nearBydisc,//获取附近门店    1  获取10公里以内的门店
                             @"sercahText":nearBydisc,//搜索关键词
                             };
    
    [MENetWorkManager post:[NSString stringWithFormat:@"%@/getCmStoreInfo",zfb_baseUrl] params:parma success:^(id response) {
        
        
        if ([response[@"resultCode"] intValue] == 0) {
            if (_pageIndex == 1) {
                
                if (self.allStoreArray.count > 0) {
                    
                    [self.allStoreArray removeAllObjects];
                    
                }
            }
            AllStoreModel  * homeStore = [AllStoreModel mj_objectWithKeyValues:response];
            
 
            for (Findgoodslists * goodlist in homeStore.storeInfoList.findGoodsList) {
                
                [self.allStoreArray addObject:goodlist];
             }
            
            [self.all_tableview reloadData];
//            _imgArray = [imgstr componentsSeparatedByString:@","];
//            [self CDsyceleSettingRunningPaintWithArray:_imgArray];

        }
        
        NSLog(@"门店列表         = %@",   self.allStoreArray);
        [self.all_tableview.mj_header endRefreshing];
        [self.all_tableview.mj_footer endRefreshing];
        
        
    } progress:^(NSProgress *progeress) {
        
        NSLog(@"progeress=====%@",progeress);
        
    } failure:^(NSError *error) {
        
        [self.all_tableview.mj_header endRefreshing];
        [self.all_tableview.mj_footer endRefreshing];
        [self.view makeToast:@"网络错误" duration:2 position:@"center"];
        NSLog(@"error=====%@",error);
        
    }];
    
}

#pragma mark - 距离最近门店网络请求

-(void)FarawayStorePostRequstAndbusinessType:(NSString *)businessType
                                 orderBydisc:(NSString *)orderBydisc
                              orderbylikeNum:(NSString *)orderbylikeNum
                                  nearBydisc:(NSString *)nearBydisc
                                  sercahText:(NSString *)sercahText

{
 
    NSString * pageSize  = [NSString stringWithFormat:@"%ld",_pageSize];
    NSString * pageIndex = [NSString stringWithFormat:@"%ld",_pageIndex];
 
    
    NSDictionary * parma = @{
                             
                             @"longitude":longitudestr,//经度
                             @"latitude":latitudestr ,//纬度
                             @"pageSize":pageSize,//每页显示条数
                             @"pageIndex":pageIndex,//当前页码
                             
                             @"businessType":businessType,//经营种类       如:服装，小吃等等
                             @"payType":@"",//是否支持到店付款    1支持  0不支持
                             @"orderBydisc":orderBydisc,//距离排序   1升   0降
                             @"orderbylikeNum":orderbylikeNum,//	人气排序   1升   0降
                             @"nearBydisc":nearBydisc,//获取附近门店    1  获取10公里以内的门店
                             @"sercahText":sercahText,//搜索关键词
                             };
    
    [MENetWorkManager post:[NSString stringWithFormat:@"%@/getCmStoreInfo",zfb_baseUrl] params:parma success:^(id response) {
        
        if ([response[@"resultCode"] intValue] == 0) {
            
            if (_pageIndex == 1) {
                
                if (self.farawayStoreArray.count > 0) {
                    
                    [self.farawayStoreArray removeAllObjects];
                }
            }
            AllStoreModel  * homeStore = [AllStoreModel mj_objectWithKeyValues:response];
            
            for (Findgoodslists * goodlist in homeStore.storeInfoList.findGoodsList) {
                
                [self.farawayStoreArray addObject:goodlist];
                
            }
            NSLog(@"farawayStoreArray = %@",   self.farawayStoreArray);
            [self.all_tableview reloadData];
            
            [SVProgressHUD showSuccessWithStatus:@"加载成功！"];
            
        }
        [SVProgressHUD dismissWithDelay:2];
        
        [self.all_tableview.mj_header endRefreshing];
        [self.all_tableview.mj_footer endRefreshing];
        
    } progress:^(NSProgress *progeress) {
        
        NSLog(@"progeress=====%@",progeress);
        
    } failure:^(NSError *error) {
        
        [self.all_tableview.mj_header endRefreshing];
        [self.all_tableview.mj_footer endRefreshing];
        NSLog(@"error=====%@",error);
        
    }];
    
}


#pragma mark -  getStoreTypeInfo 查找商品列表
-(void)checkClassPostRequst
{
    
    [MENetWorkManager post:[NSString stringWithFormat:@"%@/getStoreTypeInfo",zfb_baseUrl] params:nil success:^(id response) {
        
        NSString * storeTypeInfo = response[@"storeTypeInfo"];
        _titlelistArray          = [NSArray array];
        _titlelistArray          = [storeTypeInfo componentsSeparatedByString:@","];
        
        NSLog(@"_titlelistArray  ==  %@",_titlelistArray);
        
    } progress:^(NSProgress *progeress) {
        
    } failure:^(NSError *error) {
        
        NSLog(@"error=====%@",error);
    }];
    
}

-(void)viewWillAppear:(BOOL)animated
{
    [self checkClassPostRequst];
    [self.all_tableview.mj_header beginRefreshing];
    
}

#pragma mark - ZspMenuDataSource, ZspMenuDelegate
- (NSInteger)numberOfColumnsInMenu:(ZspMenu *)menu {
    return 2;
}

- (NSInteger)menu:(ZspMenu *)menu numberOfRowsInColumn:(NSInteger)column {
    if (column == 0) {
        return self.sort.count;
    }
        else {
        return self.choose.count;
    }
}

- (NSString *)menu:(ZspMenu *)menu titleForRowAtIndexPath:(ZspIndexPath *)indexPath {
    if (indexPath.column == 0) {
        return self.sort[indexPath.row];
        
    }else{
        return self.choose[indexPath.row];
        
    }
}

- (void)menu:(ZspMenu *)menu didSelectRowAtIndexPath:(ZspIndexPath *)indexPath {
    if (indexPath.item >= 0) {
        NSLog(@"点击了 %ld - %ld - %ld",indexPath.column,indexPath.row,indexPath.item);
    }else {
        NSLog(@"点击了 %ld - %ld",indexPath.column,indexPath.row);
    }
}



@end
