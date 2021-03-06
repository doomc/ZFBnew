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
    self.selectionStyle  = UITableViewCellSelectionStyleNone;
    self.selectedButton.enabled = YES;

}
///点击编辑
- (IBAction)didEdit:(id)sender {

    if ([self.delegate respondsToSelector:@selector(editAction:)]) {
        [self.delegate editAction:self.indexPath];
    }
}
///点击删除
- (IBAction)didDelete:(id)sender {
 
    if ([self.delegate respondsToSelector:@selector(deleteAddress:)]) {
        [self.delegate deleteAddress:self.indexPath];
    }
}


-(void)setList:(Useraddresslist *)list
{
    _list = list;
    self.lb_detailArress.text = list.postAddress;
    self.lb_name.text = list.contactUserName;
    self.lb_phoneNum.text = list.contactMobilePhone;
    _defaultFlag = list.defaultFlag;
    if ( _defaultFlag == 1) {
        //设置默认
        [self.selectedButton setImage:[UIImage imageNamed:@"selected3"] forState:UIControlStateNormal];
    }else{
        //隐藏默认按钮
        [self.selectedButton setImage:[UIImage imageNamed:@"unchecked"] forState:UIControlStateNormal];
    }
 
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
}

- (IBAction)selectAction:(UIButton*)sender {

    //    NSLog(@"======%ld======",sender.selected);
    if ([self.delegate respondsToSelector:@selector(selecteStatus:AndIndexPath:)]) {
        [self.delegate selecteStatus:@"1" AndIndexPath:_indexPath];
    }
}

@end
