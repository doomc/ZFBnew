//
//  EditCommetCell.m
//  ZFB
//
//  Created by  展富宝  on 2017/11/30.
//  Copyright © 2017年 com.zfb. All rights reserved.
//

#import "EditCommetCell.h"

@implementation EditCommetCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.lb_content.preferredMaxLayoutWidth = KScreenW - 15- 60;
    self.headImg.layer.masksToBounds = YES;
    self.headImg.layer.cornerRadius = 20;
    
}
-(void)setCommentlist:(EditCommentList *)commentlist
{
    _commentlist = commentlist;
    self.lb_content.text = commentlist.content;
    self.lb_creatTime.text = commentlist.comment_date;
    self.lb_name.text = commentlist.nickname;
    self.lb_zanNum.text = [NSString stringWithFormat:@"%ld",commentlist.like_num];
    [self.headImg sd_setImageWithURL:[NSURL URLWithString:commentlist.thumb_img] placeholderImage:[UIImage imageNamed:@"head"]];
    
    //commentlist.ifLike 是否点赞 1没有点赞 2 已点赞
    if (commentlist.ifLike == 2) {
        [self.zan_btn setImage:[UIImage imageNamed:@"sharezan_selected"] forState:UIControlStateNormal];
    }else{
        [self.zan_btn setImage:[UIImage imageNamed:@"praise_off"] forState:UIControlStateNormal];
    }
}
//点赞
- (IBAction)didZanAction:(id)sender {
    
    if ([self.delegate respondsToSelector:@selector(didClickZanWithIndex:)]) {
    
        [self.delegate didClickZanWithIndex:_index];
        
    };
 
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
