//
//  SendStatisticsTitleCell.h
//  ZFB
//
//  Created by  展富宝  on 2017/11/30.
//  Copyright © 2017年 com.zfb. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SendStatisticsTitleView: UIView

@property (weak, nonatomic) IBOutlet UILabel *lb_orderCount;
@property (weak, nonatomic) IBOutlet UILabel *lb_orderPrice;

-(instancetype)initWithHeadViewFrame:(CGRect)frame;




@end
