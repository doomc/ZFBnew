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

@property (weak, nonatomic) IBOutlet UIImageView *headImage;
@property (weak, nonatomic) IBOutlet UILabel *lb_storeName;
@property (weak, nonatomic) IBOutlet UILabel *lb_creattime;

@property (weak, nonatomic) IBOutlet UIImageView *contentImgView;
@property (weak, nonatomic) IBOutlet UILabel *lb_goodsName;
///标签
@property (weak, nonatomic) IBOutlet UILabel *lb_tags;
///描述
@property (weak, nonatomic) IBOutlet UILabel *lb_description;
///活动时间
@property (weak, nonatomic) IBOutlet UILabel *lb_activeTime;

@property (weak, nonatomic) IBOutlet UIButton *zan_btn;
///点赞数量
@property (weak, nonatomic) IBOutlet UILabel *lb_zanNum;

@property (strong,nonatomic) Recommentlist * recommend;


@end
