//
//  AllStoreCell.m
//  ZFB
//
//  Created by  展富宝  on 2017/5/19.
//  Copyright © 2017年 com.zfb. All rights reserved.
//

#import "AllStoreCell.h"
@interface AllStoreCell ()

@end
@implementation AllStoreCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code

    self.img_allStoreView.clipsToBounds = YES;
    self.img_allStoreView.layer.borderWidth = 0.5;
    self.img_allStoreView.layer.borderColor = HEXCOLOR(0xffcccc).CGColor;

 
 
}
-(void)setStorelist:(Findgoodslists *)storelist
{

    self.lb_distance.text = [NSString stringWithFormat:@"%@km",storelist.storeDist];
    self.lb_title.text = storelist.storeName;
    [self.img_allStoreView sd_setImageWithURL:[NSURL URLWithString:storelist.coverUrl] placeholderImage:nil];

}



- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
