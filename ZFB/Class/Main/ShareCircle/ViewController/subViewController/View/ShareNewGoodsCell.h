//
//  ShareNewGoodsCell.h
//  ZFB
//
//  Created by  展富宝  on 2017/9/12.
//  Copyright © 2017年 com.zfb. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ShareNewGoodsCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *headImage;
@property (weak, nonatomic) IBOutlet UILabel *lb_storeName;
@property (weak, nonatomic) IBOutlet UILabel *lb_creattime;

@property (weak, nonatomic) IBOutlet UIImageView *contentImgView;
@property (weak, nonatomic) IBOutlet UILabel *lb_goodsName;
@property (weak, nonatomic) IBOutlet UILabel *lb_tags;
@property (weak, nonatomic) IBOutlet UILabel *lb_description;
@property (weak, nonatomic) IBOutlet UILabel *lb_activeTime;

@property (weak, nonatomic) IBOutlet UIButton *zan_btn;
@property (weak, nonatomic) IBOutlet UILabel *lb_zanNum;


@end
