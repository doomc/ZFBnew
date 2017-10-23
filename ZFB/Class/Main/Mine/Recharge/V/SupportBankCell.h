//
//  SupportBankCell.h
//  ZFB
//
//  Created by  展富宝  on 2017/10/20.
//  Copyright © 2017年 com.zfb. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SupportBankModel.h"
@interface SupportBankCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *bankIMG;

@property (weak, nonatomic) IBOutlet UILabel *bankName;

@property (strong ,nonatomic) Base_Bank_List * bankList;

@end
