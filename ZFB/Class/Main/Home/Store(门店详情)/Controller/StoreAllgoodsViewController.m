//
//  StoreAllgoodsViewController.m
//  ZFB
//
//  Created by  展富宝  on 2017/11/20.
//  Copyright © 2017年 com.zfb. All rights reserved.
//  门店详情全部商品

#import "StoreAllgoodsViewController.h"
#import "DuplicationStoreCell.h"
#import "AllGoodsCollectionReusableView.h"
@interface StoreAllgoodsViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>


@end

@implementation StoreAllgoodsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    

//
//    UICollectionViewFlowLayout * layout = [[UICollectionViewFlowLayout alloc]init];
//    layout.headerReferenceSize =CGSizeMake(KScreenW, 50);
//    layout.minimumInteritemSpacing = 10;   //列距
//    layout.minimumLineSpacing = 20;    //行距
//    layout.itemSize = CGSizeMake( KScreenW *0.5-20, 280);
//    layout.scrollDirection              = UICollectionViewScrollDirectionVertical;
    
//    self.AcollectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, KScreenW, KScreenH - 130 - 49 - 44) collectionViewLayout:layout];
    
    self.AcollectionView.backgroundColor = self.view.backgroundColor;
    self.AcollectionView.delegate = self;
    self.AcollectionView.dataSource = self;
    self.AcollectionView.collectionViewLayout = [self customLayout];
    [self.AcollectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"cellId"];
    
    [self.view addSubview:self.AcollectionView];
    
    
    [self.AcollectionView registerNib:[UINib nibWithNibName:@"DuplicationStoreCell" bundle:nil] forCellWithReuseIdentifier:@"DuplicationStoreCell"];
    [self.AcollectionView  registerClass:[AllGoodsCollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"head"];

}
- (UICollectionViewLayout *)customLayout{
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.itemSize = CGSizeMake(self.view.frame.size.width / 2, self.view.frame.size.width / 2);
    layout.minimumLineSpacing = 0;
    layout.minimumInteritemSpacing = 0;
    return layout;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return 20;
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
   
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cellId" forIndexPath:indexPath];
    
    cell.backgroundColor = [UIColor colorWithRed:arc4random()%255 / 255.0 green:arc4random()%255 / 255.0 blue:arc4random()%255 / 255.0 alpha:1];
    return cell;
}

//-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
//{
//    return 2;
//}
//-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
//{
//    return 5;
//}
//-(UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
//
//    UICollectionReusableView *view = nil;
//    if (indexPath.section == 0) {
//        if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
//
//            AllGoodsCollectionReusableView * headview  = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"head" forIndexPath:indexPath];
////            view.delegate = self;
//          return  headview;
//        }
//    }
//    return view;
//}
//-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
//{
//    CGSize size = CGSizeZero;
//    if (section ==  0) {
//        size = CGSizeMake(KScreenW, 50);
//    }
//    return size;
//}
//-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
//{
//    DuplicationStoreCell * itemCell = [self.AcollectionView dequeueReusableCellWithReuseIdentifier:@"DuplicationStoreCell" forIndexPath:indexPath];
//    return itemCell;
//
//}
//
//-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
//{
//
//}

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
