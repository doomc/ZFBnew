//
//  StoreRemonedViewController.m
//  ZFB
//
//  Created by  展富宝  on 2017/11/20.
//  Copyright © 2017年 com.zfb. All rights reserved.
//  门店详情的新品推荐

#define rowHeight 292

#import "StoreRemonedViewController.h"
#import "DuplicationStoreCell.h"
#import "TimeCollectionReusableView.h"
#import "StoreNewRecommentModel.h"

#import "GoodsDeltailViewController.h"
@interface StoreRemonedViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>

@property (nonatomic , strong) NSMutableArray * dataArray;

@end

@implementation StoreRemonedViewController
-(NSMutableArray *)dataArray{
    if (!_dataArray) {
        _dataArray =[ NSMutableArray array];
    }
    return _dataArray;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self initCollectView];
    [self goodsListPostRequest];
}
-(void)initCollectView{
    self.view.backgroundColor =   HEXCOLOR(0xf7f7f7);
    UICollectionViewFlowLayout * layout = [[UICollectionViewFlowLayout alloc]init];
    layout.headerReferenceSize = CGSizeMake(KScreenW, 40);
    layout.minimumInteritemSpacing = 10;   //列距
    layout.minimumLineSpacing = 10;    //行距
    layout.itemSize = CGSizeMake( KScreenW *0.5- 15, rowHeight);
    layout.sectionInset = UIEdgeInsetsMake(0, 10, 10, 10);
    layout.scrollDirection              = UICollectionViewScrollDirectionVertical;
    
    self.ScollectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, KScreenW,  KScreenH -64 -40 -49 ) collectionViewLayout:layout];
    self.ScollectionView.backgroundColor = self.view.backgroundColor;
    self.ScollectionView.delegate = self;
    self.ScollectionView.dataSource = self;
    [self.ScollectionView registerNib:[UINib nibWithNibName:@"DuplicationStoreCell" bundle:nil] forCellWithReuseIdentifier:@"DuplicationStoreCell"];
    [self.ScollectionView  registerNib:[UINib nibWithNibName:@"TimeCollectionReusableView" bundle:nil]
            forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"header"];
    
    [self.view addSubview:self.ScollectionView];
}
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return self.dataArray.count;
}
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    StoreRecommentList * storeList = self.dataArray[section];
     return storeList.goodsList.count;
}

-(UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    
    UICollectionReusableView *view = nil;
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
        
        TimeCollectionReusableView * headview  = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"header" forIndexPath:indexPath];
        if (self.dataArray.count > 0) {
            StoreRecommentList * storeList = self.dataArray[indexPath.section];
            headview.lb_date.text = storeList.createTime;
        }
        return  headview;
        
    }
    return view;
}
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    return CGSizeMake(KScreenW, 40);
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    DuplicationStoreCell * itemCell = [self.ScollectionView dequeueReusableCellWithReuseIdentifier:@"DuplicationStoreCell" forIndexPath:indexPath];
    if (self.dataArray.count > 0) {
        StoreRecommentList * storeList = self.dataArray[indexPath.section];
        NSMutableArray * goodsArray = [NSMutableArray array];
        for (StoreRecommentGoodsList *goods in storeList.goodsList) {
            [goodsArray addObject:goods];
        }
        StoreRecommentGoodsList * goods = goodsArray[indexPath.item];
        itemCell.anewGoods = goods;
    }
    return itemCell;
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    GoodsDeltailViewController * goodVC = [ GoodsDeltailViewController new];
    if (self.dataArray.count > 0) {
        StoreRecommentList * storeList = self.dataArray[indexPath.section];
        NSMutableArray * goodsArray = [NSMutableArray array];
        for (StoreRecommentGoodsList *goods in storeList.goodsList) {
            [goodsArray addObject:goods];
        }
        StoreRecommentGoodsList * goods = goodsArray[indexPath.item];
        goodVC.goodsId = [NSString stringWithFormat:@"%ld",goods.goodsId];
        goodVC.headerImage = goods.coverImgUrl;
    }
    [self.navigationController pushViewController:goodVC animated: NO];
    
}
#pragma mark - 全部商品列表
-(void)goodsListPostRequest
{
    
    NSDictionary * parma = @{
                             @"storeId":_storeId,
                             };
    [MENetWorkManager post:[NSString stringWithFormat:@"%@/getNewRecommentListByStoreId",zfb_baseUrl] params:parma success:^(id response) {
        StoreNewRecommentModel * store = [StoreNewRecommentModel mj_objectWithKeyValues:response];
        if ([store.resultCode isEqualToString:@"0"]) {
                if (self.dataArray.count > 0) {
                    [self.dataArray removeAllObjects];
                }
            for (StoreRecommentList * storeList in store.data.recommentList) {
                [self.dataArray addObject:storeList];
            }
            [self.ScollectionView reloadData];
        }
    } progress:^(NSProgress *progeress) {
    } failure:^(NSError *error) {
        NSLog(@"error=====%@",error);
        [self.view makeToast:@"网络错误" duration:2 position:@"center"];
    }];
    
}


- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if (self.DidScrollBlock) {
        self.DidScrollBlock(scrollView.contentOffset.y);
    }
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
