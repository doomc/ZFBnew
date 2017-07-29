//
//  ZFSendingCell.h
//  ZFB
//
//  Created by  展富宝  on 2017/5/22.
//  Copyright © 2017年 com.zfb. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AllOrderModel.h"
#import "BusinessOrderModel.h"

@interface ZFSendingCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *lb_sendListTitle;
@property (weak, nonatomic) IBOutlet UIImageView *img_SenlistView;
@property (weak, nonatomic) IBOutlet UILabel *lb_Price;
@property (weak, nonatomic) IBOutlet UILabel *lb_num;
@property (weak, nonatomic) IBOutlet UILabel *lb_detailTime;

@property (strong,nonatomic) Orderlist * list ;
@property (strong,nonatomic) Ordergoods * goods ;
@property (strong,nonatomic) BusinessOrdergoods * businesGoods ;

@end
