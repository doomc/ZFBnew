//
//  ZFShopListCell.m
//  ZFB
//
//  Created by 熊维东 on 2017/5/24.
//  Copyright © 2017年 com.zfb. All rights reserved.
//

#import "ZFShopListCell.h"
@interface ZFShopListCell ()<UITextFieldDelegate>

@end
@implementation ZFShopListCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    self.tf_message.delegate = self;
    self.tf_message.layer.masksToBounds = YES;
    self.tf_message.layer.cornerRadius = 4;
    self.tf_message.leftView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 10, 0)];
    [self.tf_message addTarget:self action:@selector(changeTextmessAge:) forControlEvents:UIControlEventEditingChanged];
}

-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    return YES;
}
-(void)textFieldDidEndEditing:(UITextField *)textField
{
    //编辑完成了
    NSLog(@"编辑完成了 ------ %@",textField.text);
}
-(void)changeTextmessAge:(UITextField *)tf
{
    NSLog(@"正在编辑 ------ %@",tf.text);

}

 




- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
