//
//  BusinessSendoOrderCell.h
//  ZFB
//
//  Created by 熊维东 on 2017/7/30.
//  Copyright © 2017年 com.zfb. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DeliveryModel.h"

@interface BusinessSendoOrderCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *lb_name;

@property (weak, nonatomic) IBOutlet UILabel *lb_distence;

@property (strong, nonatomic) Deliverylist * listmodel;


@end
