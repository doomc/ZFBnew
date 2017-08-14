//
//  ZFMyOpinionCell.m
//  ZFB
//
//  Created by  展富宝  on 2017/6/8.
//  Copyright © 2017年 com.zfb. All rights reserved.
//

#import "ZFMyOpinionCell.h"
#import "FeedCollectionViewCell.h"
@interface ZFMyOpinionCell ()<UICollectionViewDelegate,UICollectionViewDataSource>



@end

@implementation ZFMyOpinionCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    //多行必须写
    [self.lb_title setPreferredMaxLayoutWidth:(KScreenW - 30)];
    
    [self.feedCollectionView registerNib:[UINib nibWithNibName:@"FeedCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"FeedCollectionViewCellid"];
   
    self.feedCollectionView.delegate = self;
    self.feedCollectionView.dataSource =self;
    self.lb_status.textColor = HEXCOLOR(0xfe6d6a);
    _imagerray = [NSMutableArray array];
 
}

//意见反馈列表数据
-(void)setFeedList:(Feedbacklist *)feedList
{
    _feedList = feedList;
    self.lb_title.text = feedList.feedbackContent;
    
    NSTimeInterval time = [feedList.feedbackTime doubleValue];
    NSDate * detaildate=[NSDate dateWithTimeIntervalSince1970:time / 1000];
    NSString*  timeSt = [dateTimeHelper TimeToLocationStr:detaildate];
    self.lb_time.text = timeSt;
    

    NSArray * imgArray= [feedList.feedbackUrl componentsSeparatedByString:@","];//图片是多张
    NSLog(@"%@",imgArray);
    [_imagerray addObjectsFromArray:imgArray];
    
    //isTreat 处理状态	否	1.未采纳 2.已采纳 3.已处理
    if ([feedList.isTreat isEqualToString:@"1"]) {
        self.lb_status.text =@"未采纳";
    }
    else if ([feedList.isTreat isEqualToString:@"2"]) {
        self.lb_status.text =@"已采纳";
    }
    else {
        self.lb_status.text =@"已处理";
    }
}
#pragma  mark - UICollectionViewDelegate
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    
    return _imagerray.count;
    
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
  
    FeedCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"FeedCollectionViewCellid" forIndexPath:indexPath];
    
    if (_imagerray.count > 0) {
        
        for (NSString * imgurl in _imagerray) {
//            NSLog(@"imgurl ====== %@ =====",imgurl);
            [cell.feedImgeView sd_setImageWithURL:[NSURL URLWithString:imgurl] placeholderImage:nil];
            _feedcollectViewLayoutheight.constant = self.colletionviewLayoutFlow.collectionViewContentSize.height;
            cell.feedImgeView.hidden = NO;
 
        }
   
    }else{

        _feedcollectViewLayoutheight.constant = 0;
        cell.feedImgeView.hidden = YES;
        _collcetionlayoutTop.constant = 5;
    }
    
    return cell;
    
}
 

#pragma mark - UICollectionViewDelegateFlowLayout
//每个cell的大小，因为有indexPath，所以可以判断哪一组，或者哪一个item，可一个给特定的大小，等同于layout的itemSize属性
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    return  CGSizeMake( 50, 50);
    
}
// 设置整个组的缩进量是多少
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(5, 5, 5, 5);
}

// 设置最小行间距，也就是前一行与后一行的中间最小间隔
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 10;
}

// 设置最小列间距，也就是左行与右一行的中间最小间隔
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 10;
}



- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
 
    NSLog(@"%ld ==== section =%ld ==== item",indexPath.section,indexPath.item);
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
