//
//  ZFAppraiseCell.m
//  ZFB
//
//  Created by  展富宝  on 2017/5/19.
//  Copyright © 2017年 com.zfb. All rights reserved.
//  评论

#import "ZFAppraiseCell.h"
#import "ApprariseCollectionViewCell.h"

@interface ZFAppraiseCell ()<UICollectionViewDataSource,UICollectionViewDelegate,ZFAppraiseCellDelegate>

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *collectionLayoutHeight;
@property (weak, nonatomic) IBOutlet UICollectionViewFlowLayout *collectionViewFlowLayout;
@property (nonatomic ,strong) NSMutableArray * itemArray;
@end
@implementation ZFAppraiseCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.img_appraiseView.clipsToBounds = YES;
    self.img_appraiseView.layer.borderWidth = 0.5;
    self.img_appraiseView.layer.borderColor = HEXCOLOR(0xffcccc).CGColor;
  
    [self setup];
   
}

#pragma mark - setter
-(void)setInfoList:(Findlistreviews *)infoList
{
    _infoList = infoList;
    
    self.imgurl = _infoList.reviewsImgUrl;
    self.lb_nickName.text = _infoList.userName;
    self.lb_message.text = _infoList.reviewsText;
    self.lb_detailtext.text = [NSString stringWithFormat:@"%@之前,来自%@",_infoList.createDate,_infoList.equip];
    [self.img_appraiseView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",_infoList.userAvatarImg]] placeholderImage:nil];
    
    self.itemArray = [NSMutableArray array];
    
    NSArray * imgArr = [self.imgurl componentsSeparatedByString:@","];
    
    for (NSString * urlstr  in imgArr) {
        
        [self.itemArray addObject:urlstr];
    }
    NSLog(@" +++++++++itemArray %@+++++++++++", _itemArray);

}

-(void)setup{
 
 
    [self.appriseCollectionView registerNib:[UINib nibWithNibName:@"ApprariseCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"ApprariseCollectionViewCellid"];
    self.appriseCollectionView.delegate = self;
    self.appriseCollectionView.dataSource = self;

    [self reloadCell];

}
- (void)reloadCell{
    
    [self.appriseCollectionView reloadData];
    self.collectionLayoutHeight.constant = self.collectionViewFlowLayout.collectionViewContentSize.height;
    [self updateConstraintsIfNeeded];
    [self.Adelegate shouldReloadData];
}


#pragma  mark - UICollectionViewDelegate
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.itemArray.count;
    
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
   
    ApprariseCollectionViewCell *cell = [self.appriseCollectionView dequeueReusableCellWithReuseIdentifier:@"ApprariseCollectionViewCellid" forIndexPath:indexPath];
     //  解析需要的数据
     for (NSString * urlStr in self.itemArray) {
         
         NSLog(@"-----aaaaaaaaa-------%@",urlStr);
         [cell.img_CollectionView  sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",urlStr]] placeholderImage:nil ];
     
     }
    
    return cell;
    
}

 
#pragma mark - UICollectionViewDelegateFlowLayout
//每个cell的大小，因为有indexPath，所以可以判断哪一组，或者哪一个item，可一个给特定的大小，等同于layout的itemSize属性
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    return  CGSizeMake(self.bounds.size.width/3- 120, self.bounds.size.width /3 - 120);
    
}
 //设置整个组的缩进量是多少
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(5, 5, 5, 5);
}

// 设置最小行间距，也就是前一行与后一行的中间最小间隔
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 5;
}

// 设置最小列间距，也就是左行与右一行的中间最小间隔
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 10;
}


- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
   
    NSLog(@"------%ld-------",indexPath.item);
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
