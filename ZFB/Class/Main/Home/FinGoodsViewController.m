//
//  FinGoodsViewController.m
//  ZFB
//
//  Created by  展富宝  on 2017/5/15.
//  Copyright © 2017年 com.zfb. All rights reserved.
//

#import "FinGoodsViewController.h"
#import "GoodsDeltailViewController.h"
//#import "DetailFindGoodsViewController.h"
#import "ZFClassifyCollectionViewController.h"
#import "HomeSearchResultViewController.h"

#import "FindStoreCell.h"
#import "FuncListTableViewCell.h"
#import "HotTableViewCell.h"
#import "HotCollectionViewCell.h"
#import "GuessCell.h"

#import "HomeADModel.h"
#import "HomeGuessModel.h"
#import "HomeFuncModel.h"
#import "HomeHotModel.h"

static NSString * cell_guessID = @"GuessCellid";
static NSString * cell_listID  = @"FuncListTableViewCellid";
static NSString * cell_hotID   = @"HotTableViewCellid";


typedef NS_ENUM(NSUInteger, CellType) {
    
    CellTypeWithMainListCell,//功能cell 0
    CellTypeWithHotTableViewCell,
    CellTypeWithGuessCell,
    
};
@interface FinGoodsViewController ()<SDCycleScrollViewDelegate,UITableViewDataSource,UITableViewDelegate,FuncListTableViewCellDeleagte,HotTableViewCellDelegate>

@property (strong,nonatomic) UIView          * CircleHeadView;
@property (strong,nonatomic) UITableView     * findGoods_TableView;
@property (strong,nonatomic) SDCycleScrollView *cycleScrollView ;

@property (strong,nonatomic) NSMutableArray * adArray;//广告轮播
@property (strong,nonatomic) NSMutableArray * likeListArray;//喜欢列表
@property (strong,nonatomic) NSMutableArray * hotArray;//热卖
@property (strong,nonatomic) NSMutableArray * funcArray;//功能


@end

@implementation FinGoodsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self initWithFindGoodsTableView];
    
    [self ADpagePostRequst];
    
    [self HotsalesPostRequst];
    
    [self guessYouLikePostRequst];
    
    [self FuncListPostRequst];

    [self setupRefresh];
    
//    [self CDsyceleSettingRunningPaintImageArr:self.adArray];

}
#pragma mark -数据请求
-(void)headerRefresh {
   
    [super headerRefresh];
    [self ADpagePostRequst];
    [self guessYouLikePostRequst];
    [self HotsalesPostRequst];
    [self FuncListPostRequst];

}
-(void)footerRefresh {

    [super footerRefresh];
    [self guessYouLikePostRequst];
 
}


#pragma mark - FuncListTableViewCellDeleagte 功能
///全部分类
-(void)seleteItemGoodsTypeId: (NSString *)goodsTypeId withIndexrow:(NSInteger )indexPathRow
{
    if (indexPathRow == 7) {
        NSLog(@"全部分类全部分类");
        ZFClassifyCollectionViewController * classifyVC = [[ZFClassifyCollectionViewController alloc]init];
        [self.navigationController pushViewController:classifyVC animated:NO];
    
    }else{

        HomeSearchResultViewController * searchVC= [HomeSearchResultViewController new];
        searchVC.goodsType = goodsTypeId;///商品类别
        searchVC.searchType = @"商品";
        [self.navigationController pushViewController:searchVC animated:NO];
    }
}
/**
 初始化home_tableView
 */
-(void)initWithFindGoodsTableView
{
    self.findGoods_TableView = [[UITableView alloc]initWithFrame:
                                CGRectMake(0, 0, KScreenW, KScreenH -49-44 -64) style:UITableViewStylePlain];
    self.findGoods_TableView.delegate   = self;
    self.findGoods_TableView.dataSource = self;
    self.findGoods_TableView.estimatedRowHeight = 0;

    [self.findGoods_TableView registerNib:[UINib nibWithNibName:@"GuessCell" bundle:nil]
                   forCellReuseIdentifier:cell_guessID];
    [self.findGoods_TableView registerNib:[UINib nibWithNibName:@"FuncListTableViewCell" bundle:nil]
                   forCellReuseIdentifier:cell_listID];
    [self.findGoods_TableView registerNib:[UINib nibWithNibName:@"HotTableViewCell" bundle:nil]
                   forCellReuseIdentifier:cell_hotID];
    
    self.zfb_tableView = self.findGoods_TableView;
    [self.view addSubview:self.findGoods_TableView];
    
}


/**初始化轮播 */
-(void)CDsyceleSettingRunningPaintImageArr:(NSArray*)images
{
    if (images.count > 0) {
        _cycleScrollView                      = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, KScreenW, 160.0/375.0 * KScreenW) delegate:self placeholderImage:nil];
        _cycleScrollView.imageURLStringsGroup = images;
        _cycleScrollView.pageControlAliment   = SDCycleScrollViewPageContolAlimentCenter;
        
        //自定义dot 大小和图案pageControlCurrentDot
        _cycleScrollView.currentPageDotImage = [UIImage imageNamed:@"dot_normal"];
        _cycleScrollView.pageDotImage        = [UIImage imageNamed:@"dot_selected"];
        _cycleScrollView.currentPageDotColor = [UIColor whiteColor];// 自定义分页控件小圆标颜色
        
        self.findGoods_TableView.tableHeaderView = _cycleScrollView;
        [self.findGoods_TableView reloadData];
   
    }
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
    if (section == 1) {
        
        return self.hotArray.count > 0 ? 1 : 0;
    }
    if (section == 2 ) {

        return self.likeListArray.count;
        
    }
    return 1;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return 0;
    }
    if (section == 1) {
        
        return self.hotArray.count > 0 ? 40 : 0;
    }
    return 40;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
 
    return  0;
}
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView * footView  = nil;
    if (!footView) {
        if (section == 0) {
            return footView;
        }
        else{
            footView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, KScreenW, 10)];
            footView.backgroundColor = HEXCOLOR(0xf7f7f7);

        }
    }
    return footView;
}
-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *headView = nil;
    if (headView == nil) {
        if (section== 0)
        {
            return headView;
            
        } else  if (section == 1) {
          
            headView         = [[UIView alloc] initWithFrame:CGRectMake(0, 0, KScreenW, 40)];
            [headView setBackgroundColor:HEXCOLOR(0xffffff)];
            UIImageView * logo = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"hotImg"] ];
            logo.frame         = CGRectMake(0, 10, 105, 30);
            [headView addSubview:logo];
            return headView;
            
        } else {
            headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, KScreenW, 40)];
            [headView setBackgroundColor:HEXCOLOR(0xffffff)];
            UIImageView * logo2 = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"guessLike"] ]; 
            logo2.frame         = CGRectMake(0, 10, 105, 30);
            [headView addSubview:logo2];
            return headView;
            
        }
    }
    return headView;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0 ) {
        return 180 / 375.0 *KScreenW ;
    }
    if (indexPath.section == 1 ) {
        
        return KScreenW /3.0 ;//140 / 375.0 *KScreenW
    }
    return  130 /375.0* KScreenW;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (indexPath.section == CellTypeWithMainListCell ) {
        
        FuncListTableViewCell * listCell = [self.findGoods_TableView dequeueReusableCellWithIdentifier:cell_listID forIndexPath:indexPath];
        if (self.funcArray.count > 0) {
            listCell.funcDelegate            = self;
            listCell.dataArray               = self.funcArray;
            [listCell reloadColltionView];
        }
        return listCell;

    }else if(indexPath.section == CellTypeWithHotTableViewCell )
    {
        HotTableViewCell * hotCell = [self.findGoods_TableView dequeueReusableCellWithIdentifier:cell_hotID forIndexPath:indexPath];
        hotCell.hotArray           = self.hotArray;
        hotCell.delegate           = self;
        return hotCell;
        
    }else{
        
        GuessCell *guessCell = [self.findGoods_TableView  dequeueReusableCellWithIdentifier:cell_guessID forIndexPath:indexPath];
        if (self.likeListArray.count > 0 ) {
            if (KScreenW >= 375) {
                guessCell.kStoreNameWidth.constant = 120;
            }
            else{
                guessCell.kStoreNameWidth.constant = 50;

            }
            Guessgoodslist *goodlist = self.likeListArray[indexPath.row];
            guessCell.goodlist       = goodlist;
        }
        return guessCell;
    }
    
}

#pragma mark - HotTableViewCellDelegate  根据ID跳转
-(void)pushToDetailVCWithGoodsID :(NSString *) goodsId
{
 
        GoodsDeltailViewController *detailVCgoods = [[GoodsDeltailViewController alloc]init];
        detailVCgoods.goodsId                        = goodsId;
        [self.navigationController pushViewController:detailVCgoods animated:NO];
 
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"section=%ld  ,row =%ld",indexPath.section , indexPath.row);
    
//    if (BBUserDefault.isLogin == 1) {
        GoodsDeltailViewController * findVCgoods =[[GoodsDeltailViewController alloc]init];
        if (self.likeListArray.count > 0) {
            Guessgoodslist *goodlist = self.likeListArray[indexPath.row];
            findVCgoods.headerImage = goodlist.coverImgUrl ;
            findVCgoods.goodsId      = [NSString stringWithFormat:@"%ld",goodlist.goodsId];
        }
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
//            NSLog(@"广告页       = adArray = %@",self.adArray);
            [self CDsyceleSettingRunningPaintImageArr:self.adArray];
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
    NSDictionary * parma = @{
                             @"latitude" : BBUserDefault.latitude ,
                             @"longitude": BBUserDefault.longitude,
                             @"pageSize": [NSNumber numberWithInteger:kPageCount],
                             @"pageIndex":[NSNumber numberWithInteger:self.currentPage],
                             @"cmUserId":BBUserDefault.cmUserId,
                             };
    
    [MENetWorkManager post:[NSString stringWithFormat:@"%@/getYouWillLike",zfb_baseUrl] params:parma success:^(id response) {
        
        if ([response[@"resultCode"]isEqualToString:@"0"]) {
            if (self.refreshType == RefreshTypeHeader) {
                if (self.likeListArray.count > 0) {
                    [self.likeListArray removeAllObjects];
                }
            }
            HomeGuessModel * guess = [HomeGuessModel  mj_objectWithKeyValues:response];
            for (Cmgoodsbrowselist * guesslist in guess.data.cmGoodsBrowseList.findGoodsList) {
                
                [self.likeListArray addObject:guesslist];
            }
            NSLog(@"猜你喜欢         = likeListArray = %@",  self.likeListArray);
            [self.findGoods_TableView reloadData];
        }
        [self endRefresh];
    } progress:^(NSProgress *progeress) {
        
        
    } failure:^(NSError *error) {
        
        [self.view makeToast:@"网络错误" duration:2 position:@"center"];
        [self endRefresh];
        NSLog(@"error=====%@",error);
        
    }];
    
}

#pragma mark - 热卖-getBestSellInfo网络请求
-(void)HotsalesPostRequst
{
    [MENetWorkManager post:[NSString stringWithFormat:@"%@/getBestSellInfo",zfb_baseUrl] params:nil success:^(id response) {
        if (self.hotArray.count > 0) {
            
            [self.hotArray removeAllObjects];
        }
        NSString * code = [NSString stringWithFormat:@"%@",response[@"resultCode"]] ;
        if ([code isEqualToString:@"0"]) {
            HomeHotModel * hotmodel = [HomeHotModel mj_objectWithKeyValues:response];
            for (hotFindgoodslist * hotlist in hotmodel.data.bestGoodsList.findGoodsList) {
                
                [self.hotArray addObject:hotlist];
            }
            NSLog(@"%@ ==== hote 热手",self.hotArray );
            [self.findGoods_TableView reloadData];
 
        }else{
            [self.view makeToast:@"网络错误" duration:2 position:@"center"];
        }
        
    } progress:^(NSProgress *progeress) {
    } failure:^(NSError *error) {
        NSLog(@"error=====%@",error);
    }];
}

#pragma mark - funcList-getGoodsTypeInfo 按钮图片和状态
-(void)FuncListPostRequst
{
    [MENetWorkManager post:[NSString stringWithFormat:@"%@/getGoodsTypeInfo",zfb_baseUrl] params:nil success:^(id response) {

        if ([response[@"resultCode"] isEqualToString:@"0"]) {
            if (self.funcArray.count > 0) {
                [self.funcArray removeAllObjects];
            }
            //mjextention 数组转模型
            HomeFuncModel *functype = [HomeFuncModel mj_objectWithKeyValues:response];
            for (CMgoodstypelist * typeList in functype.data.CmGoodsTypeList) {
                
                [self.funcArray addObject:typeList];
            }
   
            
            [self.findGoods_TableView reloadData];
        }
    } progress:^(NSProgress *progeress) {
    } failure:^(NSError *error) {
        
        NSLog(@"error=====%@",error);
        
    }];
    
}

-(NSMutableArray *)hotArray
{
    if (!_hotArray) {
        
        _hotArray =[NSMutableArray array];
    }
    return _hotArray;
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

-(NSMutableArray *)funcArray{
    if (!_funcArray) {
        _funcArray =[ NSMutableArray array];
    }
    return _funcArray;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
