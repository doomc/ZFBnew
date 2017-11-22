//
//  StoreAllgoodsViewController.m
//  ZFB
//
//  Created by  展富宝  on 2017/11/20.
//  Copyright © 2017年 com.zfb. All rights reserved.
//  门店详情全部商品

#import "StoreAllgoodsViewController.h"
#import "DuplicationStoreCell.h"
#import "AllGoodsSelectTypeCollectionCell.h"
#import "StoreDetailHomeModel.h"
#import "GoodsDeltailViewController.h"//商品详情

#define rowHeight 292

typedef NS_ENUM(NSUInteger, SelectTypeSortBy) {
    SelectTypeSortByComprehensive = 0,//综合排序
    SelectTypeSortBySaleNum,
    SelectTypeSortByLatest,
    SelectTypeSortByPrice,
};

@interface StoreAllgoodsViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,SelectTypeCollectionCellDelegate>
{
    NSInteger _flag;
}
@property (nonatomic ,strong) NSMutableArray * collctionArray;
@property (nonatomic ,assign) SelectTypeSortBy selectType;

@end

@implementation StoreAllgoodsViewController
-(NSMutableArray *)collctionArray
{
    if (!_collctionArray) {
        _collctionArray = [NSMutableArray array];
    }
    return _collctionArray;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initCollectView];
    
    //默认为综合
    _selectType = SelectTypeSortByComprehensive;
    [self goodsListPostRequestAtOrderSort:@""];
    
}
-(void)footerRefresh
{
    [super footerRefresh];
    switch (_selectType) {
        case SelectTypeSortByComprehensive://综合
            [self goodsListPostRequestAtOrderSort:@""];

            break;
        case SelectTypeSortBySaleNum://销量
            [self goodsListPostRequestAtOrderSort:@"1"];

            break;
        case SelectTypeSortByLatest://最新
            [self goodsListPostRequestAtOrderSort:@"3"];

            break;
        case SelectTypeSortByPrice://价格
            if (_flag == 1) {//升序
                [self goodsListPostRequestAtOrderSort:@"6"];
                
            }else{
                [self goodsListPostRequestAtOrderSort:@"5"];
                
            }
            
            break;
    }
    
}
-(void)headerRefresh
{
    [super headerRefresh];
    switch (_selectType) {
        case SelectTypeSortByComprehensive://综合
            [self goodsListPostRequestAtOrderSort:@""];
            
            break;
        case SelectTypeSortBySaleNum://销量
            [self goodsListPostRequestAtOrderSort:@"1"];
            
            break;
        case SelectTypeSortByLatest://最新
            [self goodsListPostRequestAtOrderSort:@"3"];
            
            break;
        case SelectTypeSortByPrice://价格
            
            if (_flag == 1) {//升序
                [self goodsListPostRequestAtOrderSort:@"6"];
                
            }else{
                [self goodsListPostRequestAtOrderSort:@"5"];
                
            }
            
            break;
    }
}

-(void)initCollectView{
    self.view.backgroundColor =   HEXCOLOR(0xf7f7f7);
    UICollectionViewFlowLayout * layout = [[UICollectionViewFlowLayout alloc]init];
    layout.minimumInteritemSpacing = 10;   //列距
    layout.minimumLineSpacing = 10;    //行距
    layout.sectionInset = UIEdgeInsetsMake(0, 10, 10, 10);
    layout.scrollDirection              = UICollectionViewScrollDirectionVertical;
    
    self.AcollectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, KScreenW,  KScreenH -64 -40 -49 ) collectionViewLayout:layout];
    self.AcollectionView.backgroundColor = self.view.backgroundColor;
    self.AcollectionView.delegate = self;
    self.AcollectionView.dataSource = self;
    [self.AcollectionView registerNib:[UINib nibWithNibName:@"DuplicationStoreCell" bundle:nil] forCellWithReuseIdentifier:@"DuplicationStoreCell"];
    [self.AcollectionView registerNib:[UINib nibWithNibName:@"AllGoodsSelectTypeCollectionCell" bundle:nil] forCellWithReuseIdentifier:@"AllGoodsSelectTypeCollectionCell"];

    
    [self.view addSubview:self.AcollectionView];
    
    self.zfb_collectionView = self.AcollectionView;
    [self setupCollectionViewRefresh];
}

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 2;
}
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if (section == 0) {
        return 1;
    }
    return self.collctionArray.count;
}
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return CGSizeMake( KScreenW, 40);

    }else{
        return CGSizeMake( KScreenW *0.5- 15, rowHeight);
    }
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
   
    if (indexPath.section == 0) {
        
        AllGoodsSelectTypeCollectionCell * typeCell = [self.AcollectionView dequeueReusableCellWithReuseIdentifier:@"AllGoodsSelectTypeCollectionCell" forIndexPath:indexPath];
        typeCell.delegate = self;
        return typeCell;
    }else{
        
        DuplicationStoreCell * itemCell = [self.AcollectionView dequeueReusableCellWithReuseIdentifier:@"DuplicationStoreCell" forIndexPath:indexPath];
        if (self.collctionArray.count >0 ) {
            GoodsExtendList * storelist  = self.collctionArray[indexPath.item];
            itemCell.goodslist = storelist;
        }
        
        return itemCell;
    }
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    GoodsDeltailViewController * goodVC = [ GoodsDeltailViewController new];
    if ( self.collctionArray.count > 0) {
        GoodsExtendList * storelist  = self.collctionArray[indexPath.item];
        goodVC.goodsId = [NSString stringWithFormat:@"%ld", storelist.goodsId];
        goodVC.headerImage = storelist.coverImgUrl;
    }
    [self.navigationController pushViewController:goodVC animated: NO];
    
}
#pragma mark - SelectTypeCollectionCellDelegate 排序的代理
-(void)selectStoreType:(StoreScreenType)type flag :(NSInteger)flag
{
    self.currentPage = 1;
    _flag = flag;
    
    switch (type) {
        case SelectTypeSortByComprehensive://综合

            _selectType = SelectTypeSortByComprehensive;
            [self goodsListPostRequestAtOrderSort:@""];

            NSLog(@"综合排序");

            break;
        case SelectTypeSortBySaleNum://销量

            _selectType = SelectTypeSortBySaleNum;
            [self goodsListPostRequestAtOrderSort:@"1"];
            [self headerRefresh];

            NSLog(@"销量排序--降序");

            break;
        case SelectTypeSortByLatest://最新

            _selectType = SelectTypeSortByLatest;
            [self goodsListPostRequestAtOrderSort:@"3"];

            NSLog(@"最新排序--降序");

            break;
        case SelectTypeSortByPrice://价格 // 5价格降   6价格升
            NSLog(@"价格排序");

            _selectType = SelectTypeSortByPrice;
            if (_flag == 1) {//升序
                [self goodsListPostRequestAtOrderSort:@"6"];

            }else{
                [self goodsListPostRequestAtOrderSort:@"5"];

            }

            break;
    }
}

#pragma mark - 全部商品列表
-(void)goodsListPostRequestAtOrderSort:(NSString *)orderSort
{
 
    NSDictionary * parma = @{
                             @"storeId":_storeId,
                             @"orderSort":orderSort,//1销量降 2销量升  3 最新降  4最新升   5价格降   6价格升（查询新品推荐的时候这个要传空字符串 ） 空综合
                             @"page":[NSNumber numberWithInteger:self.currentPage],
                             @"size":[NSNumber numberWithInteger:kPageCount],
                             };
    [MENetWorkManager post:[NSString stringWithFormat:@"%@/getGoodsExtendListApp",zfb_baseUrl] params:parma success:^(id response) {
        StoreDetailHomeModel * store = [StoreDetailHomeModel mj_objectWithKeyValues:response];
        if ([store.resultCode isEqualToString:@"0"]) {
            
            if (self.refreshType == RefreshTypeHeader) {
                if (self.collctionArray.count > 0) {
                    [self.collctionArray removeAllObjects];
                }
            }
            for (GoodsExtendList * storelist in store.data.goodsExtendList) {
                [self.collctionArray addObject:storelist];
            }
            [self.AcollectionView reloadData];
        }
        [self endCollectionViewRefresh];
    } progress:^(NSProgress *progeress) {
    } failure:^(NSError *error) {
        NSLog(@"error=====%@",error);
        [self endCollectionViewRefresh];
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
