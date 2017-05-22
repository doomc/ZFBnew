//
//  ZFMainSendViewController.h
//  ZFB
//
//  Created by  展富宝  on 2017/5/22.
//  Copyright © 2017年 com.zfb. All rights reserved.
//

#import "BaseViewController.h"

@interface ZFMainSendViewController : BaseViewController

/**收货人*/
@property (weak, nonatomic) IBOutlet UIView *lb_receiveName;

/**收货电话*/
@property (weak, nonatomic) IBOutlet UILabel *lb_receivePhone;

/**收货地址*/
@property (weak, nonatomic) IBOutlet UILabel *lb_receiveAddress;

/**取货地址*/
@property (weak, nonatomic) IBOutlet UILabel *lb_getAddress;

/**配送订单*/
@property (weak, nonatomic) IBOutlet UILabel *lb_sendOrderNum;


/**首页页面*/
@property (weak, nonatomic) IBOutlet UIView *HomePageView;

/** 没有数据隐藏该View */
@property (weak, nonatomic) IBOutlet UIView *NOdataView;

@property (weak, nonatomic) IBOutlet UIImageView *img_sendHome;
@property (weak, nonatomic) IBOutlet UIImageView *img_sendOrder;
@property (weak, nonatomic) IBOutlet UILabel *lb_sendHomeTitle;
@property (weak, nonatomic) IBOutlet UILabel *lb_sendOrderTitle;

@property (weak, nonatomic) IBOutlet UIView *bgView1;
@property (weak, nonatomic) IBOutlet UIView *bgView2;
@property (weak, nonatomic) IBOutlet UIView *bgView3;

@end
