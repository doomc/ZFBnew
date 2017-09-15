//
//  ShareGoodsCollectionViewCell.h
//  ZFB
//
//  Created by  展富宝  on 2017/9/12.
//  Copyright © 2017年 com.zfb. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ShareWaterFullModel.h"

@interface ShareGoodsCollectionViewCell : UICollectionViewCell


@property (weak, nonatomic) IBOutlet UIImageView *waterPullImageView;
@property (weak, nonatomic) IBOutlet UILabel *lb_title;
@property (weak, nonatomic) IBOutlet UILabel *lb_description;

@property (weak, nonatomic) IBOutlet UILabel *lb_nickname;
@property (weak, nonatomic) IBOutlet UIImageView *headImg;//用户头像

@property (weak, nonatomic) IBOutlet UILabel *lb_zanNum;
@property (weak, nonatomic) IBOutlet UIButton *zan_btn;//点赞

/** 0点赞 1.未点赞 */
@property (copy,nonatomic) NSString * isThumbsStatus;
@property (nonatomic, strong) ShareGoodsData * fullList;


@end
