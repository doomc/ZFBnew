//
//  ZFAppraiseSectionCell.m
//  ZFB
//
//  Created by  展富宝  on 2017/6/27.
//  Copyright © 2017年 com.zfb. All rights reserved.
//

#import "ZFAppraiseSectionCell.h"

@implementation ZFAppraiseSectionCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.all_btn.clipsToBounds = YES;
    self.all_btn.layer.cornerRadius = 4;
   
    self.goodAppraise_btn.clipsToBounds = YES;
    self.goodAppraise_btn.layer.cornerRadius = 4;
    
    self.bad_btn.clipsToBounds = YES;
    self.bad_btn.layer.cornerRadius = 4;
    
    self.haveImage_btn.clipsToBounds = YES;
    self.haveImage_btn.layer.cornerRadius = 4;
    

}

/**
 *  查看全部评论
 *
 *  @param sender sender
 */
- (IBAction)didClickAllAction:(id)sender {
  
    if ([self.delegate respondsToSelector:@selector(allbuttonSelect:)] ) {
        [self.delegate allbuttonSelect:sender];
    }
   
}
/**
 *  查看好评
 *
 *  @param sender sender
 */
- (IBAction)didClickGoodAction:(id)sender {
 
    if ([self.delegate respondsToSelector:@selector(goodPrisebuttonSelect:)] ) {
        [self.delegate goodPrisebuttonSelect:sender];
    }
}

/**
 *  差评
 *
 *  @param sender  sender
 */
- (IBAction)didClickBadAction:(id)sender {
    if ([self.delegate respondsToSelector:@selector(badPrisebuttonSelect:)] ) {
        [self.delegate badPrisebuttonSelect:sender];
    }
}

/**
 *  查看有图
 *
 *  @param sender sender
 */
- (IBAction)didClickCheakImgAction:(id)sender {
 
    if ([self.delegate respondsToSelector:@selector(haveImgbuttonSelect:)] ) {
        [self.delegate haveImgbuttonSelect:sender];
    }
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
