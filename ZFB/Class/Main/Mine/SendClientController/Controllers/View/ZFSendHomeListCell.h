//
//  ZFSendHomeListCell.h
//  ZFB
//
//  Created by  展富宝  on 2017/5/26.
//  Copyright © 2017年 com.zfb. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol ZFSendHomeListCellDelegate <NSObject>

@required
///查看订单详情
-(void)todayOrderDetial;

///查看订单详情
-(void)weekOrderDetial;

///查看订单详情
-(void)monthOrderDetial;

@end
@interface ZFSendHomeListCell : UITableViewCell

@property (assign , nonatomic) id <ZFSendHomeListCellDelegate> delegate;

///今日
@property (weak, nonatomic) IBOutlet UIView *todaybgView;
//订单数
@property (weak, nonatomic) IBOutlet UILabel *lb_todayOrderNum;
//配送费
@property (weak, nonatomic) IBOutlet UILabel *lb_todayPriceFree;
//创建订单时间
@property (weak, nonatomic) IBOutlet UILabel *lb_todayCreatTime;



///一星期
@property (weak, nonatomic) IBOutlet UIView *sendingbgView;
//订单数
@property (weak, nonatomic) IBOutlet UILabel *lb_weekOrderNum;
//配送费
@property (weak, nonatomic) IBOutlet UILabel *lb_weekPriceFree;
//创建订单时间
@property (weak, nonatomic) IBOutlet UILabel *lb_weekCreatTime;



///一个月
@property (weak, nonatomic) IBOutlet UIView *sendedbgView;
//订单数
@property (weak, nonatomic) IBOutlet UILabel *lb_monthOrderNum;
//配送费
@property (weak, nonatomic) IBOutlet UILabel *lb_monthPriceFree;
//创建订单时间
@property (weak, nonatomic) IBOutlet UILabel *lb_monthCreatTime;


@end
