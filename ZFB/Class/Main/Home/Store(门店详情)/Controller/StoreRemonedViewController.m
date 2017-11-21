//
//  StoreRemonedViewController.m
//  ZFB
//
//  Created by  展富宝  on 2017/11/20.
//  Copyright © 2017年 com.zfb. All rights reserved.
//  门店详情的新品推荐

#import "StoreRemonedViewController.h"
#import "DuplicationStoreCell.h"
#import "TimeCollectionReusableView.h"
@interface StoreRemonedViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>


@end

@implementation StoreRemonedViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
//    [self.ScollectionView registerNib:[UINib nibWithNibName:@"DuplicationStoreCell" bundle:nil] forCellWithReuseIdentifier:@"DuplicationStoreCell"];
//    [self.ScollectionView registerNib:[UINib nibWithNibName:@"TimeCollectionReusableView" bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"header"];
//
//    UICollectionViewFlowLayout * layout = [[UICollectionViewFlowLayout alloc]init];
//    layout.headerReferenceSize =CGSizeMake(KScreenW, 50);
//    layout.minimumInteritemSpacing = 10;   //列距
//    layout.minimumLineSpacing = 20;    //行距
//    layout.itemSize = CGSizeMake( KScreenW *0.5-20, 55);
//    layout.scrollDirection              = UICollectionViewScrollDirectionVertical;
//
//    self.ScollectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, KScreenW, self.view.bounds.size.height) collectionViewLayout:layout];
//    self.ScollectionView.delegate = self;
//    self.ScollectionView.dataSource = self;
//    [self.view addSubview:self.ScollectionView];
//
 
    self.ScollectionView.backgroundColor = self.view.backgroundColor;
    self.ScollectionView.delegate = self;
    self.ScollectionView.dataSource = self;
    self.ScollectionView.collectionViewLayout = [self customLayout];
    [self.ScollectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"cellId"];
    
    [self.view addSubview:self.ScollectionView];



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
//
//-(UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
//
//    UICollectionReusableView *view = nil;
//    if (indexPath.section == 0) {
//        if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
//
//            TimeCollectionReusableView * headview  = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"header" forIndexPath:indexPath];
//            return  headview;
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
//    if (indexPath.section == 1) {
//        DuplicationStoreCell * itemCell = [self.ScollectionView dequeueReusableCellWithReuseIdentifier:@"DuplicationStoreCell" forIndexPath:indexPath];
//        return itemCell;
//    }
//    return nil;
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
