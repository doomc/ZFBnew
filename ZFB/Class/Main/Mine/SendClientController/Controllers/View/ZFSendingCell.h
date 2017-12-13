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
#import "BussnissListModel.h"

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
@property (weak, nonatomic) IBOutlet UILabel *lb_progrop;


//共享
@property (weak, nonatomic) IBOutlet UIButton *share_btn;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *leadingLayoutWidth;

//晒单
@property (weak, nonatomic) IBOutlet UIButton *sunnyOrder_btn;
@property (strong,nonatomic) NSIndexPath * indexpath ;

@property (assign,nonatomic) id < ZFSendingCellDelegate > delegate ;

@property (strong,nonatomic) Ordergoods * goods ;//全部订单
@property (strong,nonatomic) BusinessOrdergoods * businesGoods ;//商户端
@property (strong,nonatomic) SendServiceOrdergoodslist * sendGoods ;//配送端
@property (strong,nonatomic) List * progressModel ;//进度查询模型
@property (strong,nonatomic) BussnissGoodsInfoList * goodlist ;//商家清单


@end
