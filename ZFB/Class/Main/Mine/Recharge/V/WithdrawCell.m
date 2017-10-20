
//
//  WithdrawCell.m
//  ZFB
//
//  Created by  展富宝  on 2017/10/20.
//  Copyright © 2017年 com.zfb. All rights reserved.
//  提现cell

#import "WithdrawCell.h"
@interface WithdrawCell ()<UITextFieldDelegate>

@end
@implementation WithdrawCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.tf_putInMoney.delegate = self;
    [self.tf_putInMoney addTarget:self action:@selector(putInMoneyAction:) forControlEvents:UIControlEventEditingChanged];
    
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

//全部提现金额
- (IBAction)didClickAllCash:(id)sender {

    if ([self.delegate respondsToSelector:@selector(didClickAllWithDraw)]) {
        [self.delegate didClickAllWithDraw];
    }
}

//输入金额
-(void)putInMoneyAction:(UITextField *)textfield
{
    NSLog(@"%@",textfield.text);
    
    if ([self.delegate respondsToSelector:@selector(inputTextfiledText:)]) {
        [self.delegate inputTextfiledText:textfield.text];
    }
}

@end
