//
//  GoodsEvaluateCell.m
//  ZFB
//
//  Created by  展富宝  on 2017/11/16.
//  Copyright © 2017年 com.zfb. All rights reserved.
//

#import "GoodsEvaluateCell.h"

@implementation GoodsEvaluateCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.lb_content.preferredMaxLayoutWidth = KScreenW - 30;
    
    _headImg.layer.masksToBounds = YES;
    _headImg.layer.cornerRadius =  20;
    
}

-(void)setInfoList:(Findlistreviews *)infoList
{
    _infoList  = infoList;
    _lb_name.text  = infoList.userName;
    _lb_content.text = infoList.reviewsText;
    _lb_time.text = infoList.createDate;
    [_headImg sd_setImageWithURL:[NSURL URLWithString:infoList.userAvatarImg] placeholderImage:[UIImage imageNamed:@"head"]];
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
