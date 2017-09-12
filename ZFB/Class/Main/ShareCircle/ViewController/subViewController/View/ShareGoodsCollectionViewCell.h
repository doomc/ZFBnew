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
/** 商品模型 */
@property (nonatomic, strong) ShareWaterFullModel * fullModel;

@property (weak, nonatomic) IBOutlet UIImageView *waterPullImageView;
@property (weak, nonatomic) IBOutlet UILabel *lb_title;
@property (weak, nonatomic) IBOutlet UILabel *lb_description;

@property (weak, nonatomic) IBOutlet UILabel *lb_nickname;
@property (weak, nonatomic) IBOutlet UIImageView *headImg;//用户头像

@property (weak, nonatomic) IBOutlet UILabel *lb_zanNum;
@property (weak, nonatomic) IBOutlet UIButton *zan_btn;//点赞



@end
