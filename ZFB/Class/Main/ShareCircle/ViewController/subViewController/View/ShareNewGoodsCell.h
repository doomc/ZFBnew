//
//  ShareNewGoodsCell.h
//  ZFB
//
//  Created by  展富宝  on 2017/9/12.
//  Copyright © 2017年 com.zfb. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ShareCommendModel.h"

@interface ShareNewGoodsCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *contentImgView;
@property (weak, nonatomic) IBOutlet UILabel *lb_goodsName;

///标签
@property (weak, nonatomic) IBOutlet UILabel *lb_tags;
///描述
@property (weak, nonatomic) IBOutlet UILabel *lb_description;

///点赞数量
@property (weak, nonatomic) IBOutlet UIButton *zan_btn;
@property (weak, nonatomic) IBOutlet UILabel *lb_zanNum;
@property (weak, nonatomic) IBOutlet UILabel *lb_buyNum;


@property (strong,nonatomic) Recommentlist * recommend;
/**
 0未点赞 1已点赞
 */
@property (copy,nonatomic) NSString * isThumbed;

/**
 推荐新品编号
 */
@property (copy,nonatomic) NSString * recommentId;


@end
