
//
//  ZFSaleAfterSearchCell.m
//  ZFB
//
//  Created by  展富宝  on 2017/5/26.
//  Copyright © 2017年 com.zfb. All rights reserved.
//

#import "ZFSaleAfterSearchCell.h"
@interface ZFSaleAfterSearchCell ()<UITextFieldDelegate>
{
    NSString * searchText;
}
@end
@implementation ZFSaleAfterSearchCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.selectionStyle          = UITableViewCellSelectionStyleNone;
    
    self.bgViewCorner.clipsToBounds = YES;
    self.bgViewCorner.layer.cornerRadius = 8;
    self.bgViewCorner.layer.borderWidth =1;
    self.bgViewCorner.layer.borderColor = HEXCOLOR(0xfe6d6a).CGColor;
    
    self.tf_search.delegate = self;
    self.tf_search.clearButtonMode = UITextFieldViewModeWhileEditing;
    [self.tf_search addTarget:self action:@selector(textChange) forControlEvents:UIControlEventEditingChanged];
}
///点击搜索按钮
- (IBAction)searchBtnAction:(id)sender {
    
    if ([self.delegate respondsToSelector:@selector(didClickSearchButtonSearchText:)]) {
        [self.delegate didClickSearchButtonSearchText:searchText];
    }
    
}
//当文本内容改变时调用
- (void)textChange
{
    searchText = self.tf_search.text;
    NSLog(@"searchText ==  %@",searchText);
}

-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    return  YES;
}

-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    NSLog(@"开始编辑");
}

-(void)textFieldDidEndEditing:(UITextField *)textField
{
    searchText = textField.text;

    NSLog(@"编辑结束 ---- %@",textField.text);
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self.tf_search resignFirstResponder];
    return YES;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
