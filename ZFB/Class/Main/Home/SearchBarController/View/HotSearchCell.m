//
//  HotSearchCell.m
//  ZFB
//
//  Created by  展富宝  on 2017/7/12.
//  Copyright © 2017年 com.zfb. All rights reserved.
//

#import "HotSearchCell.h"
#import "HotSearchCollectionViewCell.h"

@interface HotSearchCell ()<UICollectionViewDelegate,UICollectionViewDataSource>
@property (weak, nonatomic) IBOutlet UICollectionViewFlowLayout *collectionlayoutFlow;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *colltionLayoutHeight;


@end
@implementation HotSearchCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.hotArray  = [NSArray array];
 
    self.hotArray =  @[@"2123",@"裤子裤子",@"裤子裤子:",@"衣服服",@"衣服2:",@"裤子裤子:",@"衣服服",@"衣服2:"];
    
    [self setup ];
}
-(void)setup{
    
    
    [self.hotSearchCollectionView registerNib:[UINib nibWithNibName:@"HotSearchCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"HotSearchCollectionViewCellid"];
    self.hotSearchCollectionView.delegate = self;
    self.hotSearchCollectionView.dataSource = self;
    
#pragma mark — 视图控制器中使用:(关键)
    UICollectionViewFlowLayout  *layout = [[UICollectionViewFlowLayout alloc] init];

    layout.estimatedItemSize = CGSizeMake(20, 30);
    [self reloadCell];
    
}
- (void)reloadCell{
    
    [self.hotSearchCollectionView reloadData];
    self.colltionLayoutHeight.constant = self.collectionlayoutFlow.collectionViewContentSize.height;
    [self updateConstraintsIfNeeded];
//    [self.Adelegate shouldReloadData];
}



#pragma  mark - UICollectionViewDelegate
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return _hotArray.count;
//    return self.hotArray.count;
    
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    HotSearchCollectionViewCell *cell = [self.hotSearchCollectionView dequeueReusableCellWithReuseIdentifier:@"HotSearchCollectionViewCellid" forIndexPath:indexPath];
    //  解析需要的数据
//    for (NSString * urlStr in self.itemArray) {
//        
//        NSLog(@"-----aaaaaaaaa-------%@",urlStr);
//        [cell.img_CollectionView  sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",urlStr]] placeholderImage:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
//            
//        }];
//    }
    
    cell.hotTitle.text = [NSString stringWithFormat:@"%@",[_hotArray objectAtIndex:indexPath.item]];
    // make label width depend on text width
    [cell.hotTitle sizeToFit];
    
    //get the width and height of the label (CGSize contains two parameters: width and height)
    CGSize labelSize = cell.hotTitle.frame.size;
    
    NSLog(@"\n width  = %f height = %f", labelSize.width,labelSize.height);
    
    return cell;
    
}

#pragma mark - UICollectionViewDelegateFlowLayout
//每个cell的大小，因为有indexPath，所以可以判断哪一组，或者哪一个item，可一个给特定的大小，等同于layout的itemSize属性
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    
    return [(NSString*)[_hotArray objectAtIndex:indexPath.row] sizeWithAttributes:[NSDictionary dictionaryWithObject:NSFontAttributeName forKey:@""]];
//    return  CGSizeMake(self.bounds.size.width/4-20, 30);
    
}
//设置整个组的缩进量是多少
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(5, 5, 5, 5);
}

//// 设置最小行间距，也就是前一行与后一行的中间最小间隔
//- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
//    return 5;
//}

// 设置最小列间距，也就是左行与右一行的中间最小间隔
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 20;
}


- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    NSLog(@"------%ld-------",indexPath.item);
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
