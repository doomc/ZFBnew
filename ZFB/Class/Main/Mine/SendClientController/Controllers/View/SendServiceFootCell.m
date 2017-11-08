
//
//  SendServiceFootCell.m
//  ZFB
//
//  Created by  展富宝  on 2017/7/31.
//  Copyright © 2017年 com.zfb. All rights reserved.
//

#import "SendServiceFootCell.h"

@implementation SendServiceFootCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}


-(void)setStoreList:(SendServiceStoreinfomap *)storeList
{
    _storeList = storeList;
    self.lb_orderPrice.text = [NSString stringWithFormat:@"¥%.2f",storeList.orderAmmount];
    self.lb_freePrice.text = [NSString stringWithFormat:@"¥%.2f",storeList.orderDeliveryFee];
    
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
