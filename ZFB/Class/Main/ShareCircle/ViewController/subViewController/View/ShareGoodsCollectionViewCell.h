//
//  ShareGoodsCollectionViewCell.h
//  ZFB
//
//  Created by  展富宝  on 2017/9/12.
//  Copyright © 2017年 com.zfb. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ShareWaterFullModel.h"

@protocol ShareGoodsCollectionViewCellDelegate <NSObject>

@required
/**
 点赞代理

 @param indexItem 当前下标
 @param isThumbsStatus  0未点赞 1点赞了
 */
-(void)didClickZanAtIndexItem:(NSInteger)indexItem AndisThumbsStatus:(NSString *)isThumbsStatus;

/**
 点击图片进入详情

 @param indexItem 当前下标
 */
-(void)didClickgGoodsImageViewAtIndexItem:(NSInteger)indexItem;


@end
@interface ShareGoodsCollectionViewCell : UICollectionViewCell


@property (weak, nonatomic) IBOutlet UIImageView *waterPullImageView;

@property (weak, nonatomic) IBOutlet UILabel *lb_title;

@property (weak, nonatomic) IBOutlet UILabel *lb_description;

@property (weak, nonatomic) IBOutlet UILabel *lb_nickname;

@property (weak, nonatomic) IBOutlet UIImageView *headImg;//用户头像

@property (weak, nonatomic) IBOutlet UILabel *lb_zanNum;

@property (weak, nonatomic) IBOutlet UIButton *zan_btn;//点赞

/** 0为点赞 1.点赞 */
@property (copy,nonatomic) NSString * isThumbsStatus;

@property (nonatomic, strong) ShareGoodsData * fullList;

@property (nonatomic, assign) id <ShareGoodsCollectionViewCellDelegate> shareDelegate;

@property (nonatomic, assign) NSInteger indexItem;




@end
