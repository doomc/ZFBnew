//
//  ZFMyOpinionCell.m
//  ZFB
//
//  Created by  展富宝  on 2017/6/8.
//  Copyright © 2017年 com.zfb. All rights reserved.
//

#import "ZFMyOpinionCell.h"
#import "FeedCollectionViewCell.h"

@interface ZFMyOpinionCell ()< UICollectionViewDelegate,UICollectionViewDataSource >

@end

@implementation ZFMyOpinionCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.selectionStyle = UITableViewCellSelectionStyleNone;

    //多行必须写
    [self.lb_title setPreferredMaxLayoutWidth:(KScreenW - 30)];
    
    self.lb_status.textColor = HEXCOLOR(0xf95a70);
    
    _imagerray = [NSMutableArray array];
    
    [self setup];
 
}

-(void)setup{
    
    [self.feedCollectionView registerNib:[UINib nibWithNibName:@"FeedCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"FeedCollectionViewCellid"];
    self.feedCollectionView.delegate = self;
    self.feedCollectionView.dataSource =self;
    [self.feedCollectionView reloadData];
    
}



//意见反馈列表数据
-(void)setFeedList:(Feedbacklist *)feedList
{
    _feedList = feedList;
    //时间
    NSTimeInterval time = [feedList.feedbackTime doubleValue];
    NSDate * detaildate=[NSDate dateWithTimeIntervalSince1970:time / 1000];
    NSString*  timeSt = [dateTimeHelper TimeToLocationStr:detaildate];
    self.lb_time.text = timeSt;
    //描述
    self.lb_title.text = feedList.feedbackContent;
    
    //图片
    _imagerray =  feedList.images;
 
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
    
    [self reloadlayout];
}

-(void)reloadlayout{
    
    if ([_feedList.feedbackUrl isEqualToString:@""] || _feedList == nil) {
       
        _feedcollectViewLayoutheight.constant = 0;

    }else{
        
        if (_imagerray.count > 3) {
            
            _feedcollectViewLayoutheight.constant = ((KScreenW - 30 )/3.0  *2 ) ;
        }
        else{
            _feedcollectViewLayoutheight.constant = ((KScreenW - 30 )/3.0);

        }
  
    }
    
    [self.feedCollectionView reloadData];
    
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
        NSString * imgUrl = _imagerray[indexPath.item];
        [cell.feedImgeView sd_setImageWithURL:[NSURL URLWithString:imgUrl] placeholderImage:[UIImage imageNamed:@"230x235"]];
    }
    return cell;
    
}
 

#pragma mark - UICollectionViewDelegateFlowLayout
//每个cell的大小，因为有indexPath，所以可以判断哪一组，或者哪一个item，可一个给特定的大小，等同于layout的itemSize属性
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    return  CGSizeMake( (KScreenW - 30 )/3.0 - 15, (KScreenW - 30  )/3.0-15) ;
    
}
// 设置整个组的缩进量是多少
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(5, 5, 5, 5);
}



- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
