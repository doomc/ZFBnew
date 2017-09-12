//
//  ShareGoodsViewController.m
//  ZFB
//
//  Created by  展富宝  on 2017/9/12.
//  Copyright © 2017年 com.zfb. All rights reserved.
//  好货共享

#import "ShareGoodsViewController.h"
#import "ShareGoodsCollectionViewCell.h"
#import "LMHWaterFallLayout.h"
#import "ShareWaterFullModel.h"
@interface ShareGoodsViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,LMHWaterFallLayoutDeleaget>

@property (nonatomic, strong) UICollectionView *collectionView;
/** 所有的商品数据 */
@property (nonatomic, strong) NSMutableArray  * shareArray;
/** 列数 */
@property (nonatomic, assign) NSUInteger columnCount;

@end

@implementation ShareGoodsViewController
#pragma mark - 懒加载
- (NSMutableArray *)shareArray{
    if (!_shareArray) {
        _shareArray = [NSMutableArray array];
    }
    return _shareArray;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // 创建布局
    LMHWaterFallLayout * waterFallLayout = [[LMHWaterFallLayout alloc]init];
    waterFallLayout.delegate = self;
    
    // 创建collectionView
    self.collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, KScreenW, KScreenH -64-50 -44) collectionViewLayout:waterFallLayout];
    self.collectionView.backgroundColor = RGBA(244, 244, 244, 1);
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    [self.view addSubview:self.collectionView];

    // 注册
    [self.collectionView registerNib:[UINib nibWithNibName:@"ShareGoodsCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"ShareGoodsCollectionViewCellid"];
 
    [self loadDatas];
}

/**
 * 加载新的商品
 */
- (void)loadDatas{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        NSArray * shops = [ShareWaterFullModel mj_objectArrayWithFilename:@"shop.plist"];
        
        [self.shareArray removeAllObjects];
        
        [self.shareArray addObjectsFromArray:shops];
        
        // 刷新表格
        [self.collectionView reloadData];
        
        [self.collectionView.mj_header endRefreshing];
    });
}

#pragma mark  - <LMHWaterFallLayoutDeleaget>
- (CGFloat)waterFallLayout:(LMHWaterFallLayout *)waterFallLayout heightForItemAtIndexPath:(NSUInteger)indexPath itemWidth:(CGFloat)itemWidth{
    
    ShareWaterFullModel * fullmodel = self.shareArray[indexPath];
    
    NSLog(@"当前 ---高度 %f",itemWidth * fullmodel.h / fullmodel.w);
    
    return itemWidth * fullmodel.h / fullmodel.w + 150;
}

- (CGFloat)rowMarginInWaterFallLayout:(LMHWaterFallLayout *)waterFallLayout{
    
    return 10;
}

- (NSUInteger)columnCountInWaterFallLayout:(LMHWaterFallLayout *)waterFallLayout{
    return 2;
}


#pragma mark  - <UICollectionViewDataSource>
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    return self.shareArray.count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    ShareGoodsCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ShareGoodsCollectionViewCellid" forIndexPath:indexPath];
    cell.fullModel = self.shareArray[indexPath.item];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"%ld",indexPath.item);
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
