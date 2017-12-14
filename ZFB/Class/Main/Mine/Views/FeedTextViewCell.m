
//
//  FeedTextViewCell.m
//  ZFB
//
//  Created by  展富宝  on 2017/7/4.
//  Copyright © 2017年 com.zfb. All rights reserved.
//

#import "FeedTextViewCell.h" 
@interface FeedTextViewCell ()<UITextViewDelegate>


@end
@implementation FeedTextViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    [self resetTextStyle];

    self.textView.zw_limitCount = 150;//个数显示
    self.textView.zw_labHeight = 20;//高度
    self.textView.placeholder = @"此处为投诉建议入口，如您在购物中遇到困难,请使用在线客服，谢谢。";
    self.textView.delegate = self;
    // 添加输入改变Block回调.
    [self.textView addTextDidChangeHandler:^(FSTextView *textView) {
        
        // 文本改变后的相应操作.
        _textViewValues = [textView.text encodedString];
        [self.delegate textView:_textViewValues];
    }];
    // 添加到达最大限制Block回调.
    [self.textView addTextLengthDidMaxHandler:^(FSTextView *textView) {
        // 达到最大限制数后的相应操作.
    }];
 
}

-(void)textViewDidBeginEditing:(UITextView *)textView
{
    [self insertEmoji];
}

- (void)resetTextStyle {
    //After changing text selection, should reset style.
    NSRange wholeRange = NSMakeRange(0, _textView.textStorage.length);
    [_textView.textStorage removeAttribute:NSFontAttributeName range:wholeRange];
    [_textView.textStorage addAttribute:NSFontAttributeName value:_textView.font range:wholeRange];
}
-(void)insertEmoji
{
    //Create emoji attachment
    EmojiTextAttachment *emojiTextAttachment = [EmojiTextAttachment new];
    
    NSAttributedString *str = [NSAttributedString attributedStringWithAttachment:emojiTextAttachment];
    NSRange selectedRange = _textView.selectedRange;
    if (selectedRange.length > 0) {
        [_textView.textStorage deleteCharactersInRange:selectedRange];
    }
    //Insert emoji image
    [_textView.textStorage insertAttributedString:str atIndex:_textView.selectedRange.location];
    
    _textView.selectedRange = NSMakeRange(_textView.selectedRange.location+1, 0); // self.textView.selectedRange.length
    
    //Move selection location
    //_textView.selectedRange = NSMakeRange(_textView.selectedRange.location + 1, _textView.selectedRange.length);
    
    //Reset text style
    [self resetTextStyle];
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
