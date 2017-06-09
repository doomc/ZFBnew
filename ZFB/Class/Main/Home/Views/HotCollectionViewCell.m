//
//  HotCollectionViewCell.m
//  ZFB
//
//  Created by  展富宝  on 2017/5/15.
//  Copyright © 2017年 com.zfb. All rights reserved.
//

#import "HotCollectionViewCell.h"
#import "UIImageView+ZFCornerRadius.h"
@implementation HotCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    
    self.img_listImgView.clipsToBounds = YES;
    self.img_listImgView.layer.borderWidth = 0.5;
    self.img_listImgView.layer.borderColor = HEXCOLOR(0xffcccc).CGColor;
    [self.img_listImgView CreateImageViewWithFrame:CGRectMake(0, 0,( KScreenW-50) *0.3333, 95) andBackground:HEXCOLOR(0xffcccc).CGColor andRadius:2];

    
    // Initialization code
}

@end
