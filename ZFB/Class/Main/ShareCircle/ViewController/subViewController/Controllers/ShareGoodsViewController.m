//
//  ShareGoodsViewController.m
//  ZFB
//
//  Created by  展富宝  on 2017/9/12.
//  Copyright © 2017年 com.zfb. All rights reserved.
//  好货共享

#import "ShareGoodsViewController.h"
#import "ShareGoodsCollectionViewCell.h"
#import "WaterFlowLayout.h"
#import "ShareWaterFullModel.h"
#import "ShareGoodsSubDetailViewController.h"
#import "NSString+YYAdd.h"

#import "PPBadgeView.h"
#define itemWidth ((KScreenW-30)/2)

@interface ShareGoodsViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,WaterFlowLayoutDelegate,ShareGoodsCollectionViewCellDelegate>

{
    ShareGoodsData * goodsdata;
}
@property (nonatomic, strong) UICollectionView *collectionView;
/** 所有的商品数据 */
@property (nonatomic, strong) NSMutableArray  * shareArray;


@end

@implementation ShareGoodsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self initCollectionView];
    // 第一次刷新手动调用
 
    [self setupCollectionViewRefresh];
    
   [self.tabBarItem pp_hiddenBadge];
    
}
-(void)footerRefresh
{
    [super footerRefresh];
    [self shareGoodsPost];
}
-(void)headerRefresh
{
    [super headerRefresh];
    [self shareGoodsPost];
}

-(void)initCollectionView{
    
    //设置瀑布流布局
    WaterFlowLayout *layout = [WaterFlowLayout new];
    layout.columnCount = 2;
    layout.sectionInset = UIEdgeInsetsMake(0, 10, 0, 10);;
    layout.rowMargin = 10;
    layout.columnMargin = 10;
    layout.delegate = self;
    
    self.collectionView = [[UICollectionView alloc]initWithFrame: CGRectMake(0, 0, KScreenW, KScreenH - 49 -44-64) collectionViewLayout:layout];
    self.collectionView.backgroundColor = HEXCOLOR(0xf2f2f2);
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    [self.view addSubview:self.collectionView];
    self.zfb_collectionView =self.collectionView  ;
    
    // 注册
    [self.collectionView registerNib:[UINib nibWithNibName:@"ShareGoodsCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"ShareGoodsCollectionViewCellid"];
}

#pragma mark - 懒加载
- (NSMutableArray *)shareArray{
    if (!_shareArray) {
        _shareArray = [NSMutableArray array];
    }
    return _shareArray;
}

/// 刷新加载数据
- (void)setupRefresh{
    [self.collectionView.mj_footer endRefreshing];
    [self.collectionView.mj_header endRefreshing];
}

#pragma mark  - <UICollectionViewDataSource>
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    
    return 1;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    self.collectionView.mj_footer.hidden = self.shareArray.count == 0;
    return self.shareArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    ShareGoodsData * data  = self.shareArray[indexPath.item];
    ShareGoodsCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ShareGoodsCollectionViewCellid" forIndexPath:indexPath];
    cell.fullList = data;

    cell.indexItem = indexPath.item;
    cell.shareDelegate = self;
    
    return cell;
}


#pragma mark ————— layout 代理 —————
-(CGFloat)waterFlowLayout:(WaterFlowLayout *)WaterFlowLayout heightForWidth:(CGFloat)width andIndexPath:(NSIndexPath *)indexPath{
    ShareGoodsData * shareGoods = self.shareArray[indexPath.row];
    if (shareGoods.describe && shareGoods.describeHeight == 0) {
        //计算hobby的高度 并缓存
        CGFloat titleH = [shareGoods.title heightForFont:[UIFont systemFontOfSize:15] width:(KScreenW-30)/2-20];
        CGFloat descibeH = [shareGoods.describe heightForFont:[UIFont systemFontOfSize:15] width:(KScreenW-30)/2-20];
        if (descibeH > 43) {
            descibeH = 43;
        }
        shareGoods.titleHeight = titleH;
        shareGoods.describeHeight = descibeH;
    }
    CGFloat padding = 5;
    CGFloat imgH  = ((KScreenW -30 - 10) * 0.5 - 10) * 6/5 ;
    return imgH + 10 + 50 + 4 * padding + shareGoods.titleHeight + shareGoods.describeHeight;
}


#pragma  mark - ShareGoodsCollectionViewCellDelegate 好货共享的内部代理
/**
 点赞代理
 @param indexItem 当前下标
 */
-(void)didClickZanAtIndexItem:(NSInteger)indexItem AndisThumbsStatus:(NSString *)isThumbsStatus
{
    ShareGoodsData * shareGoods = self.shareArray[indexItem];
 
    NSLog(@"当前点赞 ---%ld ,我点赞了吗 ---%@",indexItem,shareGoods.thumbsStatus);
    // 1 未点赞   0已点赞
    if ([shareGoods.thumbsStatus isEqualToString:@"0"]) {
        
        //您已经点过赞了
        [self.view makeToast:@"您已经点过赞了" duration:2 position:@"center"];

    }else{
        
        [self didclickZanPostRequsetAtthumsId:shareGoods.shareId];
    }


}

/**
 点击图片进入详情
 @param indexItem 当前下标
 */
-(void)didClickgGoodsImageViewAtIndexItem:(NSInteger)indexItem
{
 
    ShareGoodsData * shareGoods = self.shareArray[indexItem];
    ShareGoodsSubDetailViewController * detailVC = [ShareGoodsSubDetailViewController new];
    detailVC.shareId = shareGoods.shareId;
    [self.navigationController pushViewController:detailVC animated:NO];
}


#pragma mark - 好货共享列表    toShareGoods/shareGoodsList
-(void)shareGoodsPost
{
    NSDictionary * parma = @{
                             @"userId":BBUserDefault.cmUserId,
                             @"pageIndex":[NSNumber numberWithInteger:self.currentPage],
                             @"pageSize":[NSNumber numberWithInteger:kPageCount],
                             };
    [SVProgressHUD show];
    [MENetWorkManager post:[zfb_baseUrl stringByAppendingString:@"/toShareGoods/shareGoodsList"] params:parma success:^(id response) {
        if ([response[@"resultCode"] isEqualToString:@"0"] ) {//
            if (self.refreshType == RefreshTypeHeader) {
                if ( self.shareArray.count > 0) {
                    [ self.shareArray removeAllObjects];
                }
            }

            ShareWaterFullModel * waterfull = [ShareWaterFullModel mj_objectWithKeyValues:response];
            for (ShareGoodsData * goodslist in waterfull.data) {
                [self.shareArray addObject:goodslist];
            }
            [self.collectionView reloadData];
            [SVProgressHUD dismiss];

        }
        [self endCollectionViewRefresh];
    } progress:^(NSProgress *progeress) {
    } failure:^(NSError *error) {

        [SVProgressHUD dismiss];
        NSLog(@"error=====%@",error);
        [self endCollectionViewRefresh];

        [self.view makeToast:@"网络错误" duration:2 position:@"center"];
    }];
    
}

#pragma mark  - 点赞请求 newrecomment/toLike
-(void)didclickZanPostRequsetAtthumsId:(NSString *)thumsId
{
    NSDictionary * parma = @{
                             @"userId":BBUserDefault.cmUserId,
                             @"thumsId":thumsId,//分享编号，新品推荐编号
                             @"type":@"1",//0 新品推荐 1 分享
                             };
    [MENetWorkManager post:[zfb_baseUrl stringByAppendingString:@"/newrecomment/toLike"] params:parma success:^(id response) {
        if ([response[@"resultCode"] isEqualToString:@"0"] ) {

            goodsdata.thumbsStatus = @"0";
            NSInteger  count = [goodsdata.thumbs integerValue];
            count ++;
            NSLog(@"点击后的数量 - %ld",count);
            [self shareGoodsPost];
        }
        
    } progress:^(NSProgress *progeress) {
        
    } failure:^(NSError *error) {
        
        [SVProgressHUD dismiss];
        NSLog(@"error=====%@",error);
        [self.view makeToast:@"网络错误" duration:2 position:@"center"];
    }];
}

#pragma mark  - 消息读取状态 messageInfo
-(void)MessageInfo
{
    NSDictionary * parma = @{
                             @"userId":BBUserDefault.cmUserId,
                             @"timestamp":@"",//分享编号，新品推荐编号

                             };
    [MENetWorkManager post:[zfb_baseUrl stringByAppendingString:@"/messageInfo"] params:parma success:^(id response) {
        if ([response[@"resultCode"] isEqualToString:@"0"] ) {
            
 
            [self.collectionView reloadData];
        }
        
    } progress:^(NSProgress *progeress) {
        
    } failure:^(NSError *error) {
        
        [SVProgressHUD dismiss];
        NSLog(@"error=====%@",error);
        [self.view makeToast:@"网络错误" duration:2 position:@"center"];
    }];
}

-(void)viewWillAppear:(BOOL)animated{
    
    [self shareGoodsPost];
    
    [self MessageInfo];

}
-(void)viewWillDisappear:(BOOL)animated{
    [SVProgressHUD dismiss];
    
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
