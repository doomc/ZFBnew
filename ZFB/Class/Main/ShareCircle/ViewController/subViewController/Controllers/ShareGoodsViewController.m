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
#import "UIImage+ImageSize.h"
@interface ShareGoodsViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) UICollectionView *collectionView;
/** 所有的商品数据 */
@property (nonatomic, strong) NSMutableArray  * shareArray;


@end

@implementation ShareGoodsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self initCollectionView];
    [self setupRefresh];
    [self shareGoodsPost];
    // 第一次刷新手动调用
    [self.collectionView.mj_header beginRefreshing];
}

-(void)initCollectionView{
    
    //设置瀑布流布局
    UICollectionViewFlowLayout *flowLayout = [UICollectionViewFlowLayout new];
    flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
    //最小行间距(默认为10)
    flowLayout.minimumLineSpacing = 10;
    //最小item间距（默认为10）
    flowLayout.minimumInteritemSpacing = 10;
    
    self.collectionView = [[UICollectionView alloc]initWithFrame: CGRectMake(0, 0, KScreenW, KScreenH -64- 49 -44) collectionViewLayout:flowLayout];
    self.collectionView.backgroundColor = [UIColor whiteColor];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    [self.view addSubview:self.collectionView];
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
    
    ShareGoodsCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ShareGoodsCollectionViewCellid" forIndexPath:indexPath];
    ShareGoodsData * data  = self.shareArray[indexPath.item];
    cell.fullList = data;
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"section---- %ld ====== item----%ld",indexPath.section,indexPath.item);
    
    ShareGoodsSubDetailViewController * detailVC = [ShareGoodsSubDetailViewController new];
    [self.navigationController pushViewController:detailVC animated:NO];
    
}

//设置每个item的尺寸
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat itemHeight =  ((KScreenW -30 - 10 )*0.5 - 10 ) * 6/5 + 110;
    return CGSizeMake( (KScreenW -30 -10 )*0.5 , itemHeight);
}
#pragma mark - 获取新品推荐列表    toShareGoods/shareGoodsList
-(void)shareGoodsPost
{
    NSDictionary * parma = @{
                             @"userId":BBUserDefault.cmUserId,
                             @"pageIndex":@"1",
                             @"pageSize":@"10",
                             };
    [SVProgressHUD show];
    [MENetWorkManager post:[zfb_baseUrl stringByAppendingString:@"/toShareGoods/shareGoodsList"] params:parma success:^(id response) {
        if ([response[@"resultCode"] isEqualToString:@"0"] ) {//
            if ( self.shareArray.count > 0) {
                [ self.shareArray removeAllObjects];
            }
            ShareWaterFullModel * waterfull = [ShareWaterFullModel mj_objectWithKeyValues:response];
            for (ShareGoodsData * goodslist in waterfull.data) {
                [self.shareArray addObject:goodslist];
            }
            [SVProgressHUD dismiss];
            [self.collectionView reloadData];
        }
        
        [self.collectionView.mj_header endRefreshing];
        
    } progress:^(NSProgress *progeress) {
        
    } failure:^(NSError *error) {
        [self.collectionView.mj_header endRefreshing];
        [SVProgressHUD dismiss];
        NSLog(@"error=====%@",error);
        [self.view makeToast:@"网络错误" duration:2 position:@"center"];
    }];
    
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
