//
//  ZFSettingRowCell.m
//  ZFB
//
//  Created by  展富宝  on 2017/6/1.
//  Copyright © 2017年 com.zfb. All rights reserved.
//

#import "ZFSettingRowCell.h"
@interface ZFSettingRowCell ()

@end
@implementation ZFSettingRowCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    
    self.tf_contentTextfiled.clearButtonMode = UITextFieldViewModeWhileEditing;

}




- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
