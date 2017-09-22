//
//  ZFAppraiseCell.m
//  ZFB
//
//  Created by  展富宝  on 2017/5/19.
//  Copyright © 2017年 com.zfb. All rights reserved.
//  评论

#import "ZFAppraiseCell.h"
#import "ApprariseCollectionViewCell.h"

@interface ZFAppraiseCell ()<UICollectionViewDataSource,UICollectionViewDelegate>

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *collectionLayoutHeight;

@end
@implementation ZFAppraiseCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.selectionStyle = UITableViewCellSelectionStyleNone;

    self.img_appraiseView.clipsToBounds = YES;
    self.img_appraiseView.layer.borderWidth = 0.5;
    self.img_appraiseView.layer.borderColor = HEXCOLOR(0xffcccc).CGColor;
    self.img_appraiseView.layer.cornerRadius =  25;

    self.lb_message.preferredMaxLayoutWidth = KScreenW - 30 - 60;
    self.lb_detailtext.preferredMaxLayoutWidth = 120;
    
    [self setup];
   
}

#pragma mark - setter
-(void)setInfoList:(Findlistreviews *)infoList
{
    _infoList = infoList;
//    self.imgurl = _infoList.attachImgUrl;
    self.lb_nickName.text = _infoList.userName;
    self.lb_message.text = _infoList.reviewsText;
    self.lb_detailtext.text = [NSString stringWithFormat:@"%@之前,来自%@",_infoList.createDate,_infoList.equip];
    [self.img_appraiseView sd_setImageWithURL:[NSURL URLWithString:_infoList.userAvatarImg] placeholderImage:nil];

    [self reloadlayout];
}

-(void)setup{
    
    [self.appriseCollectionView registerNib:[UINib nibWithNibName:@"ApprariseCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"ApprariseCollectionViewCellid"];
    self.appriseCollectionView.delegate = self;
    self.appriseCollectionView.dataSource = self;
    [self.appriseCollectionView reloadData];

}

-(void)setMutImgArray:(NSMutableArray *)mutImgArray{
    
    _mutImgArray  = mutImgArray;
    

}
-(void)reloadlayout{
    
//    if (_mutImgArray.count == 0 || _mutImgArray== nil) {
//        _collectionLayoutHeight.constant  = 0.0;
//    }

    NSMutableArray * urlArr =[NSMutableArray array];
    for (NSString * BigjsonUrl in _mutImgArray) {
        NSArray * tempImgArray = [BigjsonUrl componentsSeparatedByString:@","];
        for (NSString * url in tempImgArray) {
            
            [urlArr addObject:url];
        }
    }
    if (urlArr.count > 3) {
       
        _collectionLayoutHeight.constant = (((KScreenW - 90 )/3.0 )*2 );
    }
    else{
        _collectionLayoutHeight.constant = ((KScreenW - 90 )/3.0 );
    }
    [self.appriseCollectionView reloadData];

}
#pragma  mark - UICollectionViewDelegate
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    NSMutableArray * urlArr =[NSMutableArray array];
    
    for (NSString * BigjsonUrl in _mutImgArray) {
        NSArray * tempImgArray = [BigjsonUrl componentsSeparatedByString:@","];
        for (NSString * url in tempImgArray) {
          
            [urlArr addObject:url];
        }
    }
    NSLog(@"urlArr ------- %@",urlArr);

    return urlArr.count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
   
    ApprariseCollectionViewCell *cell = [self.appriseCollectionView dequeueReusableCellWithReuseIdentifier:@"ApprariseCollectionViewCellid" forIndexPath:indexPath];
    
    for (NSString * BigjsonUrl in _mutImgArray) {
        NSLog(@"jsonUrl ------- %@",BigjsonUrl);
        NSArray * tempImgArray = [BigjsonUrl componentsSeparatedByString:@","];
        NSLog(@"tempImgArray ------- %@",tempImgArray);
        for (NSString * url in tempImgArray) {
            NSLog(@"最后的URL ------- %@",url);
            [cell.img_CollectionView  sd_setImageWithURL:[NSURL URLWithString:url] placeholderImage:[UIImage imageNamed:@"170x170"]];
 
        }
    }
    
//    NSString * url = _mutImgArray[indexPath.row];
//    NSArray * urlArr = [url componentsSeparatedByString:@","];
//    for (NSString  * imgUrl in urlArr) {
//        [cell.img_CollectionView  sd_setImageWithURL:[NSURL URLWithString:imgUrl] placeholderImage:[UIImage imageNamed:@"170x170"]];
//    }
// 
    
    return cell;
    
}

 
#pragma mark - UICollectionViewDelegateFlowLayout
//每个cell的大小，因为有indexPath，所以可以判断哪一组，或者哪一个item，可一个给特定的大小，等同于layout的itemSize属性
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    CGFloat itemH = ((KScreenW - 90 )/3.0 - 10);
    return  CGSizeMake(itemH,itemH);
    
}
// 设置整个组的缩进量是多少
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    
    return UIEdgeInsetsZero;
    
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"%ld",indexPath.item);
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
