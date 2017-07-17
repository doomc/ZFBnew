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
    NSInteger _pageCount;//每页显示条数
    NSInteger _page;//当前页码;
    
}
@property(strong,nonatomic)UIView * CircleHeadView;
@property(strong,nonatomic)UITableView * findGoods_TableView;
@property(strong,nonatomic)SDCycleScrollView *cycleScrollView ;

@property(strong,nonatomic)NSMutableArray * adArray;//广告轮播
@property(strong,nonatomic)NSMutableArray * likeListArray;//喜欢列表


@end

@implementation FinGoodsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _pageCount = 8;
    _page = 1;
    
    [self initWithFindGoodsTableView];
    
    [self ADpagePostRequst];
    
    [self guessYouLikePostRequst];

    weakSelf(weakSelf);
    //上拉加载
    _findGoods_TableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        
        _page ++ ;
        [weakSelf guessYouLikePostRequst];
        
    }];
    
    //下拉刷新
    _findGoods_TableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        //需要将页码设置为1
        _page = 1;
        [weakSelf guessYouLikePostRequst];
    }];
    
    
}
#pragma mark - FuncListTableViewCellDeleagte
///全部分类
-(void)seleteItemCell:(FuncListTableViewCell *)cell withIndex:(NSIndexPath *)indexPath
{
    FuncListTableViewCell * funcCell = [self.findGoods_TableView cellForRowAtIndexPath:indexPath];
    
    NSLog(@"全部分类全部分类");
    ZFClassifyCollectionViewController * classifyVC = [[ZFClassifyCollectionViewController alloc]init];
    [self.navigationController pushViewController:classifyVC animated:NO];
    
    //        [self FuncListPostRequst];
    //        [self HotsalesPostRequst];
    
    
    
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

        return 2;
//        return self.likeListArray.count;
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
        return 180;
    }
    if (indexPath.section == 1 ) {
        
        return 140;
    }
    return  100;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
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
        if (self.likeListArray.count > 0 ) {
            
            Guessgoodslist *goodlist  = self.likeListArray[indexPath.row];
            
            guessCell.goodlist = goodlist;
        }
        
        return guessCell;
    }
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"section=%ld  ,row =%ld",indexPath.section , indexPath.row);
   
    DetailFindGoodsViewController * findVCgoods =[[DetailFindGoodsViewController alloc]init];

    if (self.likeListArray.count > 0) {
        Guessgoodslist *goodlist  = self.likeListArray[indexPath.row];
        findVCgoods.goodsId  = [NSString stringWithFormat:@"%ld",goodlist.goodsId];
    }
    NSLog(@" push goodsId  = %@",findVCgoods.goodsId);
    [self.navigationController pushViewController:findVCgoods animated:YES];
    
}

#pragma mark - 广告轮播-getAdImageInfo网络请求
-(void)ADpagePostRequst
{
    [MENetWorkManager post:[NSString stringWithFormat:@"%@/getAdImageInfo",zfb_baseUrl] params:nil success:^(id response) {
        
        if ([response[@"resultCode"] isEqualToString:@"0"]) {
            if (self.adArray.count >0) {
                [self.adArray  removeAllObjects];
                
            }else{
            
                HomeADModel * homeAd = [HomeADModel mj_objectWithKeyValues:response];
               
                for (Cmadvertimglist * adList in homeAd.data.cmAdvertImgList) {
                    
                    [self.adArray addObject:adList.imgUrl];
                }
            }
            NSLog(@"广告页 =adArray = %@",self.adArray);
            [self.findGoods_TableView reloadData];
            [self CDsyceleSettingRunningPaint];
        }
        
    } progress:^(NSProgress *progeress) {
        
    } failure:^(NSError *error) {
        
        NSLog(@"error=====%@",error);
        [self.view makeToast:@"网络错误" duration:2 position:@"center"];
    }];
    
}

#pragma mark - 猜你喜欢- getYouWillLike网络请求
-(void)guessYouLikePostRequst
{    
    NSString * pageSize= [NSString stringWithFormat:@"%ld",_pageCount];
    NSString * pageIndex= [NSString stringWithFormat:@"%ld",_page];
    
    NSDictionary * parma = @{
                            
                             @"latitude" : BBUserDefault.latitude ,
                             @"longitude": BBUserDefault.longitude,
                             @"svcName":@"",
                             @"pageSize":pageSize,//每页显示条数
                             @"pageIndex":pageIndex,//当前页码
                             @"cmUserId":BBUserDefault.cmUserId,
                             
                             };
    
    [MENetWorkManager post:[NSString stringWithFormat:@"%@/getYouWillLike",zfb_baseUrl] params:parma success:^(id response) {
        
        if ([response[@"resultCode"]isEqualToString:@"0"]) {
            
            if (_page == 1) {
                
                if (self.likeListArray.count > 0) {
                    
                    [self.likeListArray removeAllObjects];

                }
  
            }
            HomeGuessModel * guess  = [HomeGuessModel  mj_objectWithKeyValues:response];
            
            for (Cmgoodsbrowselist * guesslist in guess.data.cmGoodsBrowseList.findGoodsList) {
             
                [self.likeListArray addObject:guesslist];
                
            }
            NSLog(@"猜你喜欢 =likeListArray = %@",  self.likeListArray);
            [self.findGoods_TableView reloadData];
        }
        [self.findGoods_TableView.mj_header endRefreshing];
        [self.findGoods_TableView.mj_footer endRefreshing];
    } progress:^(NSProgress *progeress) {
        
        
    } failure:^(NSError *error) {
        
        [self.view makeToast:@"网络错误" duration:2 position:@"center"];
        [self.findGoods_TableView.mj_header endRefreshing];
        [self.findGoods_TableView.mj_footer endRefreshing];
        NSLog(@"error=====%@",error);
        
    }];
    
}

-(void)viewWillAppear:(BOOL)animated
{
    [self.findGoods_TableView.mj_header beginRefreshing];
    
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
