//
//  BusinessSendoOrderCell.m
//  ZFB
//
//  Created by 熊维东 on 2017/7/30.
//  Copyright © 2017年 com.zfb. All rights reserved.
//

#import "BusinessSendoOrderCell.h"

@implementation BusinessSendoOrderCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
-(void)setListmodel:(Deliverylist *)listmodel
{
    _listmodel =listmodel;
    self.lb_name.text = listmodel.deliveryName;
    self.lb_distence.text = listmodel.deliveryDist;
    
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
    if (selected) {
        self.contentView.backgroundColor = HEXCOLOR(0xffcccc);
    }
    else{
        
        self.contentView.backgroundColor = HEXCOLOR(0xffffff);
 
    }
}

@end
