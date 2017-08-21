//
//  FeedCommitPhoneCell.m
//  ZFB
//
//  Created by  展富宝  on 2017/8/21.
//  Copyright © 2017年 com.zfb. All rights reserved.
//

#import "FeedCommitPhoneCell.h"
@interface FeedCommitPhoneCell ()<UITextFieldDelegate>

@end
@implementation FeedCommitPhoneCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.bgView.layer.cornerRadius = 3;
    self.bgView.layer.borderWidth = 0.5;
    self.bgView.layer.borderColor = HEXCOLOR(0xffcccc).CGColor;
    self.bgView.clipsToBounds = YES;
    
    self.commitButton.layer.cornerRadius = 3;
    self.commitButton.clipsToBounds = YES;
    
    self.tf_phoneNum.delegate = self;
    [self.tf_phoneNum addTarget:self action:@selector(changeTextFiled:) forControlEvents:UIControlEventEditingChanged];

}


#pragma mark - changeTextFiled 手机号
- (void)changeTextFiled:(UITextField *)textF {
    
    if ([self.commitDelegate respondsToSelector:@selector(phoneNum:)]) {
        
        [self.commitDelegate phoneNum:_tf_phoneNum.text];
    }
    
    NSLog(@"text = %@",_tf_phoneNum.text);
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
    
}
//收键盘
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [_tf_phoneNum resignFirstResponder];
    [self endEditing:YES];
}

#pragma mark - didCommitAction 点击提交
- (IBAction)didCommitAction:(id)sender {
    if ([self.commitDelegate respondsToSelector:@selector(didClickCommit)]) {
        
        [self.commitDelegate didClickCommit];
    }
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
