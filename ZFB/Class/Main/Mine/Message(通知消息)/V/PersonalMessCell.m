//
//  PersonalMessCell.m
//  ZFB
//
//  Created by 熊维东 on 2017/10/22.
//  Copyright © 2017年 com.zfb. All rights reserved.
//

#import "PersonalMessCell.h"

@implementation PersonalMessCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

-(void)setPushList:(PushMessageList *)pushList
{
    _pushList = pushList ;
    self.lb_title.text = pushList.title;
//    NSLog(@"createTime -- %@ , object - %@ ,- content_s = %@   isNew=  %ld",pushList.createTime,pushList.object,pushList.content_s,pushList.isNew);
//    self.lb_content.text = [NSString stringWithFormat:@"%@",pushList.content_s];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
