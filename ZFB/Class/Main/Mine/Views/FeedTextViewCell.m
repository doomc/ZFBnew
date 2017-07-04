
//
//  FeedTextViewCell.m
//  ZFB
//
//  Created by  展富宝  on 2017/7/4.
//  Copyright © 2017年 com.zfb. All rights reserved.
//

#import "FeedTextViewCell.h" 
@interface FeedTextViewCell ()


@end
@implementation FeedTextViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
   
    self.textView.zw_limitCount = 150;//个数显示
    self.textView.zw_labHeight = 20;//高度
    self.textView.placeholder = @"此处为投诉建议入口，如您在购物中遇到困难,请使用在线客服，谢谢。";
    
    // 添加输入改变Block回调.
    [self.textView addTextDidChangeHandler:^(FSTextView *textView) {
        // 文本改变后的相应操作.
        self.textViewValues = textView.text;
        NSLog(@"----%@-----",textView.text);
    }];
    // 添加到达最大限制Block回调.
    [self.textView addTextLengthDidMaxHandler:^(FSTextView *textView) {
        // 达到最大限制数后的相应操作.
    }];
 
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
