//
//  ShopListFooterView.m
//  ZFB
//
//  Created by  展富宝  on 2017/12/5.
//  Copyright © 2017年 com.zfb. All rights reserved.
//

#import "ShopListFooterView.h"
@interface ShopListFooterView ()<UITextFieldDelegate>

@end

@implementation ShopListFooterView

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier{
    
    self = [super initWithReuseIdentifier:reuseIdentifier];
    if (self) {
        [self initerfaceView];
    }
    return self;
}
-(void)initerfaceView
{
    self.tf_message = [[UITextField alloc]initWithFrame:CGRectMake(15, 10, KScreenW - 30, 44)];
    self.tf_message.delegate = self;
    self.tf_message.clearButtonMode =  UITextFieldViewModeWhileEditing;
    self.tf_message.placeholder = @"选填:给商家留言(50字以内)";
    self.tf_message.layer.masksToBounds = YES;
    self.tf_message.font = SYSTEMFONT(14);
    self.tf_message.layer.cornerRadius = 4;
    self.tf_message.leftView = [[UIView alloc]initWithFrame:CGRectMake(0, 10, 0, 0)];
    [self.tf_message addTarget:self action:@selector(changeTextField:) forControlEvents:UIControlEventEditingChanged];
    self.tf_message.backgroundColor=  HEXCOLOR( 0xf7f7f7);
    [self addSubview:self.tf_message];

    UILabel * line = [[UILabel alloc]initWithFrame:CGRectMake(0, 44+20, KScreenW, 10)];
    line.backgroundColor = HEXCOLOR( 0xf7f7f7);
    [self addSubview:line];
}

-(void)textFieldDidEndEditing:(UITextField *)textField
{
    //编辑完成了
    NSLog(@"编辑完成了 ------ %@",textField.text);
}
-(void)changeTextField:(UITextField *)textField
{
    //    NSLog(@"正在编辑 ------ %@",textField.text);
    
    if (self.footerBlock) {
        self.footerBlock(textField.text);
    }
}


@end
