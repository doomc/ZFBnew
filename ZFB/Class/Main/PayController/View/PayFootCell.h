//
//  PayFootCell.h
//  ZFB
//
//  Created by  展富宝  on 2017/10/10.
//  Copyright © 2017年 com.zfb. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol PayFootCellDelegate <NSObject>


//选择支付方式--确定支付
-(void)didClickSurePay;

@end
@interface PayFootCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIButton *paySure_btn;

@property (nonatomic , assign) id <PayFootCellDelegate> delegate;


@end
