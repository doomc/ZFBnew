//
//  AllStoreCell.h
//  ZFB
//
//  Created by  展富宝  on 2017/5/19.
//  Copyright © 2017年 com.zfb. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AllStoreModel.h"

@interface AllStoreCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *img_allStoreView;

@property (weak, nonatomic) IBOutlet UILabel *lb_title;

@property (weak, nonatomic) IBOutlet UILabel *lb_distance;

@property (weak, nonatomic) IBOutlet UIView *starView;

@property (strong, nonatomic) Findgoodslists *  storelist;


@end
