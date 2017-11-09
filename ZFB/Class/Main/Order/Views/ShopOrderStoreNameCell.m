//
//  ShopOrderStoreNameCell.m
//  ZFB
//
//  Created by  展富宝  on 2017/6/29.
//  Copyright © 2017年 com.zfb. All rights reserved.
//

#import "ShopOrderStoreNameCell.h"

@implementation ShopOrderStoreNameCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}
-(void)setStoreList:(BussnissUserStoreList *)storeList
{
    _storeList = storeList;
    self.lb_type.text = storeList.deliveryTypeName;
    self.lb_storeName.text = storeList.storeName;

    
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
