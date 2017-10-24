//
//  AddBackButtonCell.h
//  ZFB
//
//  Created by  展富宝  on 2017/10/20.
//  Copyright © 2017年 com.zfb. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol AddBackButtonCellDelegate <NSObject>
@optional
//添加银行卡
-(void)didClickAddBankCard;

//确认提现
-(void)didClickcashWithdraw;

@end
@interface AddBackButtonCell : UITableViewCell

//添加银行卡
@property (weak, nonatomic) IBOutlet UIButton *addBackBtn;
//确认提现
@property (weak, nonatomic) IBOutlet UIButton *sureWithdrawBtn;

@property (assign ,nonatomic) id <AddBackButtonCellDelegate> delegate;

@end
