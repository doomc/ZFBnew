//
//  GuessCell.m
//  ZFB
//
//  Created by 熊维东 on 2017/5/15.
//  Copyright © 2017年 com.zfb. All rights reserved.
//

#import "GuessCell.h"
#import "UIImageView+ZFCornerRadius.h"
@implementation GuessCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
 
    
    [_guess_listView CreateImageViewWithFrame:self.frame andBackground:[UIColor redColor].CGColor andRadius:10];

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
