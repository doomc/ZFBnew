//
//  ZFCheckTheProgressCell.m
//  ZFB
//
//  Created by 熊维东 on 2017/5/26.
//  Copyright © 2017年 com.zfb. All rights reserved.
//

#import "ZFCheckTheProgressCell.h"

@implementation ZFCheckTheProgressCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    [self.checkProgress_btn addTarget:self action:@selector(actionTarget:) forControlEvents:UIControlEventTouchUpInside];
    
    self.checkProgress_btn.clipsToBounds = YES;
    self.checkProgress_btn.layer.cornerRadius = 3;
}
-(void)actionTarget:(UIButton*)sender{
    
    if (
        [self.deldegate respondsToSelector:@selector(progressWithCheckoutIndexPath:)]) {
        
        [self.deldegate progressWithCheckoutIndexPath:_indexpath];
        
    }
    
}
-(void)setProgressList:(List *)progressList
{
    _progressList = progressList;
    
    self.lb_serviceNum.text = [NSString stringWithFormat:@"服务单号:%@",progressList.serviceNum];
    self.lb_checkStatus.text =  progressList.status ;
    self.lb_title.text =  progressList.goodsName ;
    self.lb_applelyTime.text = [NSString stringWithFormat:@"申请时间:%@",progressList.createTime];
    [self.img_progressView sd_setImageWithURL:[NSURL URLWithString:progressList.coverImgUrl] placeholderImage:[UIImage imageNamed:@""]];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end
