//
//  BackCell.h
//  ZFB
//
//  Created by  展富宝  on 2017/10/18.
//  Copyright © 2017年 com.zfb. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BankCardListModel.h"
@interface BackCell : UITableViewCell

//卡图
@property (weak, nonatomic) IBOutlet UIImageView *backImg;
//银行卡
@property (weak, nonatomic) IBOutlet UILabel *backName;
//尾号
@property (weak, nonatomic) IBOutlet UILabel *backNo;

@property (strong, nonatomic)  BankList *  bankList;

@property (weak, nonatomic) IBOutlet UIView *NOBankCardView;

@end
