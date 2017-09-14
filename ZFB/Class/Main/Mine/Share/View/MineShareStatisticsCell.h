//
//  MineShareStatisticsCell.h
//  ZFB
//
//  Created by  展富宝  on 2017/9/14.
//  Copyright © 2017年 com.zfb. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol MineShareStatisticsCellDelegate <NSObject>

@required

-(void)didClickAllincomeView;
-(void)didClickgoodsNumView;
-(void)didClicktodayIncomeView;


@end
@interface MineShareStatisticsCell : UITableViewCell

//总收入
@property (weak, nonatomic) IBOutlet UIView *allIncomeView;
@property (weak, nonatomic) IBOutlet UILabel *lb_allIncome;
//商品数
@property (weak, nonatomic) IBOutlet UIView *goodsIncomeView;
@property (weak, nonatomic) IBOutlet UILabel *lb_goodsnum;
//今日收入
@property (weak, nonatomic) IBOutlet UIView *todayIncomeView;
@property (weak, nonatomic) IBOutlet UILabel *lb_todayIncome;

@property (assign ,nonatomic) id <MineShareStatisticsCellDelegate> shareDelegate;
@end
