//
//  ZFAddOfListCell.m
//  ZFB
//
//  Created by 熊维东 on 2017/5/24.
//  Copyright © 2017年 com.zfb. All rights reserved.
//

#import "ZFAddOfListCell.h"

@implementation ZFAddOfListCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
 
}
///点击编辑
- (IBAction)didEdit:(id)sender {

    if ([self.delegate respondsToSelector:@selector(editAction:)]) {
        [self.delegate editAction:self.indexPath];
    }
}
///点击删除
- (IBAction)didDelete:(id)sender {
    if ([self.delegate respondsToSelector:@selector(deleteAction:)]) {
        [self.delegate deleteAction:self];
    }
}


-(void)setList:(Useraddresslist *)list
{
    _list = list;
    self.lb_detailArress.text = list.postAddress;
    self.lb_name.text = list.contactUserName;
    self.lb_phoneNum.text = list.contactMobilePhone;
    
    if ( list.defaultFlag == 1) {
        //设置默认
        self.selectedButton.selected = YES;
    }else{
        //隐藏默认按钮
        self.selectedButton.selected = NO;

    }
    
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state

 
    if (selected) {
        self.selectedButton.selected = YES;
    }
    else{
        self.selectedButton.selected = NO;

    }

    if ([self.delegate respondsToSelector:@selector(selecteStatus:)]) {
        
        [self.delegate selecteStatus:selected];
        
    }
 
}

@end
