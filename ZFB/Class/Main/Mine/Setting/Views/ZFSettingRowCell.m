//
//  ZFSettingRowCell.m
//  ZFB
//
//  Created by  展富宝  on 2017/6/1.
//  Copyright © 2017年 com.zfb. All rights reserved.
//

#import "ZFSettingRowCell.h"
@interface ZFSettingRowCell ()<UITextFieldDelegate>

@end
@implementation ZFSettingRowCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    
    self.tf_contentTextfiled.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.tf_contentTextfiled.delegate = self;
    [self.tf_contentTextfiled addTarget:self action:@selector(textFieldEditing:) forControlEvents:UIControlEventEditingChanged];
 }


//cell UITextField 的text
-(void)textFieldEditing:(UITextField *)textField
{
    NSLog(@"%@",textField.text);
    
}
-(void)textFieldDidEndEditing:(UITextField *)textField
{
    _nickName = textField.text;
    NSLog(@"%@",textField.text);

}

//回收键盘
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self.tf_contentTextfiled resignFirstResponder];
    return YES;
}



- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
