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
#import "SendServiceOrderModel.h"
#import "AllOrderProgress.h"

@protocol ZFSendingCellDelegate <NSObject>

//点击共享
-(void)didclickShareToFriendWithIndexPath:(NSIndexPath *)indexPath AndOrderId:(NSString *)orderId;

//点击晒单
-(void)shareOrderWithIndexPath:(NSIndexPath*)indexPath AndOrderId:(NSString *)orderId;

@end
@interface ZFSendingCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *lb_sendListTitle;
@property (weak, nonatomic) IBOutlet UIImageView *img_SenlistView;
@property (weak, nonatomic) IBOutlet UILabel *lb_Price;
@property (weak, nonatomic) IBOutlet UILabel *lb_num;

//共享
@property (weak, nonatomic) IBOutlet UIButton *share_btn;
//晒单
@property (weak, nonatomic) IBOutlet UIButton *sunnyOrder_btn;
@property (strong,nonatomic) NSIndexPath * indexpath ;

@property (assign,nonatomic) id < ZFSendingCellDelegate > delegate ;

@property (strong,nonatomic) Ordergoods * goods ;
@property (strong,nonatomic) BusinessOrdergoods * businesGoods ;
@property (strong,nonatomic) SendServiceOrdergoodslist * sendGoods ;
@property (strong,nonatomic) List * progressModel ;//进度查询模型


@end
