//
//  ZFSendHomeListCell.m
//  ZFB
//
//  Created by  展富宝  on 2017/5/26.
//  Copyright © 2017年 com.zfb. All rights reserved.
//

#import "ZFSendHomeListCell.h"

@implementation ZFSendHomeListCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    //多行必须写
    self.todaybgView.clipsToBounds = YES;
    self.todaybgView.layer.borderWidth = 0.5;
    self.todaybgView.layer.cornerRadius = 2;
    self.todaybgView.layer.borderColor = HEXCOLOR(0xffcccc).CGColor;
   
    self.sendingbgView.clipsToBounds = YES;
    self.sendingbgView.layer.borderWidth = 0.5;
    self.sendingbgView.layer.cornerRadius = 2;
    self.sendingbgView.layer.borderColor = HEXCOLOR(0xffcccc).CGColor;
    
    self.sendedbgView.clipsToBounds = YES;
    self.sendedbgView.layer.borderWidth = 0.5;
    self.sendedbgView.layer.cornerRadius = 2;
    self.sendedbgView.layer.borderColor = HEXCOLOR(0xffcccc).CGColor;
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
