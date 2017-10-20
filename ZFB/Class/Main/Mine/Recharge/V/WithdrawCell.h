//
//  WithdrawCell.h
//  ZFB
//
//  Created by  展富宝  on 2017/10/20.
//  Copyright © 2017年 com.zfb. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol WithdrawCellDelegate <NSObject>

//全部提现
-(void)didClickAllWithDraw;
//输入的金额
-(void)inputTextfiledText:(NSString *)resulet;


@end
@interface WithdrawCell : UITableViewCell

//输入金额
@property (weak, nonatomic) IBOutlet UITextField *tf_putInMoney;

//可提现的金额
@property (weak, nonatomic) IBOutlet UILabel *lb_CashAmount;

//全部提现
@property (weak, nonatomic) IBOutlet UIButton *btn_AllWithDraw;

@property (assign, nonatomic) id <WithdrawCellDelegate> delegate;




@end
