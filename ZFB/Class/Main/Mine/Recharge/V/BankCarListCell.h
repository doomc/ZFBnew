//
//  BankCarListCell.h
//  ZFB
//
//  Created by  展富宝  on 2017/10/20.
//  Copyright © 2017年 com.zfb. All rights reserved.
//

#import <UIKit/UIKit.h>
 
#import "BankCardListModel.h"

@interface BankCarListCell : UITableViewCell
 
@property (weak, nonatomic) IBOutlet UIImageView *backgroundIMG;

@property (weak, nonatomic) IBOutlet UIImageView *bankIMG;

@property (weak, nonatomic) IBOutlet UILabel *bankName;

@property (weak, nonatomic) IBOutlet UILabel *bankType;

@property (weak, nonatomic) IBOutlet UILabel *cardNum;

@property (nonatomic , strong) BankList * banklist;

@end
