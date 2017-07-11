//
//  FinGoodsViewController.m
//  ZFB
//
//  Created by  展富宝  on 2017/5/15.
//  Copyright © 2017年 com.zfb. All rights reserved.
//

#import "FinGoodsViewController.h"
#import "DetailFindGoodsViewController.h"
#import "ZFClassifyCollectionViewController.h"

#import "FindStoreCell.h"
#import "FuncListTableViewCell.h"
#import "HotTableViewCell.h"
#import "HotCollectionViewCell.h"
#import "GuessCell.h"

#import "HomeADModel.h"
#import "HomeGuessModel.h"



static NSString * cell_guessID = @"GuessCellid";
static NSString * cell_listID = @"FuncListTableViewCellid";
static NSString * cell_hotID = @"HotTableViewCellid";


typedef NS_ENUM(NSUInteger, CellType) {
    
    CellTypeWithMainListCell,//功能cell 0
    CellTypeWithHotTableViewCell,
    CellTypeWithGuessCell,
    
};
@interface FinGoodsViewController ()<SDCycleScrollViewDelegate,UITableViewDataSource,UITableViewDelegate,FuncListTableViewCellDeleagte>
{
    NSInteger _pageSize;//每页显示条数
    NSInteger _pageIndex;//当前页码;
    
}
@property(strong,nonatomic)UIView * CircleHeadView;
@property(strong,nonatomic)UITableView * findGoods_TableView;
@property(strong,nonatomic)SDCycleScrollView *cycleScrollView ;
@property(strong,nonatomic)UICollectionView *collectView ;

@property(strong,nonatomic)NSMutableArray * adArray;//广告轮播
@property(strong,nonatomic)NSMutableArray * likeListArray;//喜欢列表


@end

@implementation FinGoodsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    [self initWithFindGoodsTableView];
    
    //    [self ADpagePostRequst];
    //    [self guessYouLikePostRequst];

    _pageSize = 10;
    _pageIndex = 1;
    

}

///全部分类
-(void)seleteItemCell:(FuncListTableViewCell *)cell withIndex:(NSIndexPath *)indexPath
{
    FuncListTableViewCell * funcCell = [self.findGoods_TableView cellForRowAtIndexPath:indexPath];
 
    NSLog(@"进来?");
    ZFClassifyCollectionViewController * classifyVC = [[ZFClassifyCollectionViewController alloc]init];
    [self.navigationController pushViewController:classifyVC animated:NO];
    
//        [self FuncListPostRequst];
    //    [self HotsalesPostRequst];

    
    
}
/**
 初始化home_tableView
 */
-(void)initWithFindGoodsTableView
{
    
    self.findGoods_TableView = [[UITableView alloc]initWithFrame:
                                CGRectMake(0, 0, KScreenW, KScreenH -48-64-44) style:UITableViewStylePlain];
    self.findGoods_TableView.delegate = self;
    self.findGoods_TableView.dataSource = self;
    [self.view addSubview:_findGoods_TableView];
    
    [self.findGoods_TableView registerNib:[UINib nibWithNibName:@"GuessCell" bundle:nil]
                   forCellReuseIdentifier:cell_guessID];
    [self.findGoods_TableView registerNib:[UINib nibWithNibName:@"FuncListTableViewCell" bundle:nil]
                   forCellReuseIdentifier:cell_listID];
    [self.findGoods_TableView registerNib:[UINib nibWithNibName:@"HotTableViewCell" bundle:nil]
                   forCellReuseIdentifier:cell_hotID];
}

/**
 初始化功能板块
 */
-(void)initFunctionWithInterface
{
    
}

/**初始化轮播 */
-(void)CDsyceleSettingRunningPaint
{
    self.title = @"轮播Demo";
    
    
    // 网络加载 --- 创建自定义图片的pageControlDot的图片轮播器
    _cycleScrollView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, KScreenW, 150) delegate:self placeholderImage:[UIImage imageNamed:@"placeholder"]];
    _cycleScrollView.imageURLStringsGroup = self.adArray;
    _cycleScrollView.pageControlAliment = SDCycleScrollViewPageContolAlimentCenter;
    _cycleScrollView.delegate = self;
    
    //自定义dot 大小和图案pageControlCurrentDot
    _cycleScrollView.currentPageDotImage = [UIImage imageNamed:@"dot_normal"];
    _cycleScrollView.pageDotImage = [UIImage imageNamed:@"dot_selected"];
    //    _cycleScrollView.titlesGroup = titles;
    
    _cycleScrollView.currentPageDotColor = [UIColor whiteColor]; // 自定义分页控件小圆标颜色
    _cycleScrollView.placeholderImage = [UIImage imageNamed:@"placeholder"];
    self.findGoods_TableView.tableHeaderView = _cycleScrollView;
    
}


#pragma mark - SDCycleScrollViewDelegate
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index
{
    NSLog(@"---点击了第%ld张图片", (long)index);
    
    //  [self.navigationController pushViewController:[NSClassFromString(@"DemoVCWithXib") new] animated:YES];
}



#pragma mark - datasoruce  代理实现
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 2 ) {
        return 3;
    }
    return 1;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return 0;
        
    }
    return 35;
}
-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *headView = nil;
    UIFont *font = [UIFont systemFontOfSize:14];
    if (section == 1) {
        headView = [[UIView alloc] initWithFrame:CGRectMake(30, 0, KScreenW, 35)];
        [headView setBackgroundColor:HEXCOLOR(0xffcccc)];
        
        UILabel *labelTitle = [[UILabel alloc] initWithFrame:CGRectMake(30.0f, 3, 200.0f, 30.0f)];
        labelTitle.textColor =HEXCOLOR(0x363636);
        labelTitle.textAlignment = NSTextAlignmentLeft;
        labelTitle.text = @"热卖推荐";
        labelTitle.font = font;
        [headView addSubview:labelTitle];
        
        
        UIImageView * logo = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"fire"] ];//定位icon
        logo.frame =CGRectMake(5, 5, 25, 25);
        [headView addSubview:logo];
        
        return headView;
        
    }
    else  if (section== 2) {
        headView = [[UIView alloc] initWithFrame:CGRectMake(30, 0, KScreenW, 35)];
        [headView setBackgroundColor:HEXCOLOR(0xffcccc)];
        
        UILabel * title = [[UILabel alloc] initWithFrame:CGRectMake(30.0f, 3.0f, 200.0f, 30.0f)];
        title.textColor =HEXCOLOR(0x363636);
        title.textAlignment = NSTextAlignmentLeft;
        title.text = @"猜你喜欢";
        title.font = font;
        [headView addSubview:title];
        
        UIImageView * logo2 = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"love"] ];//定位icon
        logo2.frame =CGRectMake(5, 5, 25, 25);
        [headView addSubview:logo2];
        return headView;
        
    }
    
    return headView;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0 ) {
        return 170;
    }
    if (indexPath.section == 1 ) {
        return 135;
    }
    return  100;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    HomeGuessModel *guesslist  =[HomeGuessModel new];
   
    if (indexPath.row < self.likeListArray.count) {
        
        guesslist = self.likeListArray[indexPath.row];
    }
    
    if (indexPath.section == CellTypeWithMainListCell ) {
        
        FuncListTableViewCell * listCell = [self.findGoods_TableView dequeueReusableCellWithIdentifier:cell_listID forIndexPath:indexPath];
        listCell.indexPath = indexPath;
        listCell.funcDelegate = self;

        
        return listCell;
        
    }else if(indexPath.section == CellTypeWithHotTableViewCell )
    {
        HotTableViewCell * hotCell = [self.findGoods_TableView dequeueReusableCellWithIdentifier:cell_hotID forIndexPath:indexPath];
        
        return hotCell;
    }else{
        
        GuessCell *guessCell = [self.findGoods_TableView  dequeueReusableCellWithIdentifier:cell_guessID forIndexPath:indexPath];
        
        NSURL * img_url = [NSURL URLWithString:[NSString stringWithFormat:@"%@",guesslist.coverImgUrl]];
        [guessCell.guess_listView sd_setImageWithURL:img_url completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            
        }];
        guessCell.lb_goodsName.text = guesslist.goodsName;
        guessCell.lb_price.text = [NSString stringWithFormat:@"促销价：¥%@",guesslist.netPurchasePrice];
        guessCell.lb_storeName.text = guesslist.storeName;
        guessCell.lb_collectNum.text = @"死数据";
        guessCell.lb_distence.text = @"死数据";
        
        return guessCell;
    }
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"section=%ld  ,row =%ld",indexPath.section , indexPath.row);
    
    DetailFindGoodsViewController * findVCgoods =[[DetailFindGoodsViewController alloc]init];
    [self.navigationController pushViewController:findVCgoods animated:YES];
    
}

#pragma mark - 广告轮播-getAdImageInfo网络请求
-(void)ADpagePostRequst
{
    NSDictionary * parma = @{
                             
                             @"svcName":@"getAdImageInfo",
//                             @"cmUserId":BBUserDefault.cmUserId,
                             
                             };
    
    [PPNetworkHelper POST:zfb_url parameters:parma responseCache:^(id responseCache) {
        
    } success:^(id responseObject) {
        
        if ([responseObject[@"resultCode"] isEqualToString:@"0"]) {
            if (self.adArray.count >0) {
                
                [self.adArray  removeAllObjects];
                
            }else{
                
                NSString  * dataStr= [responseObject[@"data"] base64DecodedString];
                NSDictionary * jsondic = [NSString dictionaryWithJsonString:dataStr];
                NSArray * dictArray = jsondic [@"cmAdvertImgList"];
                
                //mjextention 数组转模型
                NSArray *storArray = [HomeADModel mj_objectArrayWithKeyValuesArray:dictArray];
                for (HomeADModel *adlist in storArray) {
                    
                    [self.adArray addObject:adlist.imgUrl];
                }
                NSLog(@"广告页 =adArray = %@",  self.adArray);
                [self.findGoods_TableView reloadData];
                
            }
            [self CDsyceleSettingRunningPaint];

            
        }
        
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
        [self.view makeToast:@"网络错误" duration:2 position:@"center"];
    }];
}

#pragma mark - 猜你喜欢- getYouWillLike网络请求
-(void)guessYouLikePostRequst
{
    NSString * pageSize= [NSString stringWithFormat:@"%ld",_pageSize];
    NSString * pageIndex= [NSString stringWithFormat:@"%ld",_pageIndex];
    
    NSDictionary * parma = @{
                             
                             @"svcName":@"getYouWillLike",
                             @"pageSize":pageSize,//每页显示条数
                             @"pageIndex":pageIndex,//当前页码
//                             @"cmUserId":BBUserDefault.cmUserId,
                             
                             };
    
    NSDictionary *parmaDic=[NSDictionary dictionaryWithDictionary:parma];
    
    [PPNetworkHelper POST:zfb_url parameters:parmaDic responseCache:^(id responseCache) {
        
    } success:^(id responseObject) {
        
        if ([responseObject[@"resultCode"] isEqualToString:@"0"]) {
            if (self.likeListArray.count >0) {
                
                [self.likeListArray  removeAllObjects];
                
            }else{
                NSString  * dataStr= [responseObject[@"data"] base64DecodedString];
                NSDictionary * jsondic = [NSString dictionaryWithJsonString:dataStr];
                NSArray * dictArray = jsondic [@"cmGoodsBrowseList"];
                
                //mjextention 数组转模型
                NSArray *storArray = [HomeGuessModel mj_objectArrayWithKeyValuesArray:dictArray];
                for (HomeGuessModel *guesslist in storArray) {
                    
                    [self.likeListArray addObject:guesslist];
                }
                NSLog(@"likeListArray = %@",  self.likeListArray);
                [self.findGoods_TableView reloadData];
                
            }
        }
        
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
        [self.view makeToast:@"网络错误" duration:2 position:@"center"];
    }];
}


-(NSMutableArray *)adArray{
    if (!_adArray) {
        _adArray =[ NSMutableArray array];
    }
    return _adArray;
}

-(NSMutableArray *)likeListArray{
    if (!_likeListArray) {
        _likeListArray =[ NSMutableArray array];
    }
    return _likeListArray;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
