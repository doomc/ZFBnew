//
//  EditCommentFootView.m
//  ZFB
//
//  Created by  展富宝  on 2017/11/30.
//  Copyright © 2017年 com.zfb. All rights reserved.
//

#import "EditCommentFootView.h"
#import "EmojiTextAttachment.h"
#import "NSAttributedString+EmojiExtension.h"
#import "NSString+EnCode.h"

@interface  EditCommentFootView ()<UITextViewDelegate>
{
    CGRect myframe;
}
@property (nonatomic,strong) UILabel * holdLabel;
@property (nonatomic,copy) NSString * ecodeStr;


@end

@implementation EditCommentFootView

-(instancetype)initWithFootViewFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self = [[NSBundle mainBundle]loadNibNamed:@"EditCommentFootView" owner:nil options:nil].lastObject;
        myframe = frame;
        [self creatUI];
        [self resetTextStyle];

    }
    return self;
}

-(void)creatUI{
    
    _commentTextView.delegate = self;
    _commentTextView.layer.masksToBounds = YES;
    _commentTextView.layer.cornerRadius = 4;
    _commentTextView.textContainerInset = UIEdgeInsetsMake(10,0, 10,15);

    self.holdLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 5, 150, 30)];
    self.holdLabel.font = _commentTextView.font;
    self.holdLabel.textColor = [UIColor colorWithRed:200/255.0 green:200/255.0 blue:205/255.0 alpha:1];
    [_commentTextView addSubview:self.holdLabel];
 
}

- (IBAction)publishBtn:(id)sender {

    [_commentTextView resignFirstResponder];
    if ([self.footDelegate respondsToSelector:@selector(pushlishComment:WithContent:)]) {
        [self.footDelegate pushlishComment:sender WithContent:_ecodeStr];
    }
}


-(void)textViewDidChange:(UITextView *)textView {
    //获得textView的初始尺寸
    [textView scrollRangeToVisible:NSMakeRange(0, 0)];
    CGFloat width = CGRectGetWidth(textView.frame);
    CGFloat height = CGRectGetHeight(textView.frame);
    CGSize newSize = [textView sizeThatFits:CGSizeMake(width,MAXFLOAT)];
    CGRect newFrame = textView.frame;
    newFrame.size = CGSizeMake(fmax(width, newSize.width), fmax(height, newSize.height));
    textView.frame= newFrame;
    if (textView.text.length == 0) {
        self.holdLabel.text = self.textViewPlacehold;
    }else{
        self.holdLabel.text = @"";
        _layoutConstarainHeight.constant  = newFrame.size.height +20;
        myframe = CGRectMake(0, 0, KScreenW, newFrame.size.height +20);
        CGFloat height2 = CGRectGetHeight(myframe);
        
        if ( height2 > 67 ) {
            if ([self.footDelegate respondsToSelector:@selector(textView:textHeight:)]) {
                [self.footDelegate textView:textView textHeight:height2];
            }
        }
        _ecodeStr= [textView.text encodedString];
 
    }
    
}
-(void)textViewDidBeginEditing:(UITextView *)textView
{
    [self insertEmoji];
}
- (void)resetTextStyle {
    //After changing text selection, should reset style.
    NSRange wholeRange = NSMakeRange(0, _commentTextView.textStorage.length);
    [_commentTextView.textStorage removeAttribute:NSFontAttributeName range:wholeRange];
    [_commentTextView.textStorage addAttribute:NSFontAttributeName value:_commentTextView.font range:wholeRange];
}
-(void)insertEmoji
{
    //Create emoji attachment
    EmojiTextAttachment *emojiTextAttachment = [EmojiTextAttachment new];
    
    NSAttributedString *str = [NSAttributedString attributedStringWithAttachment:emojiTextAttachment];
    NSRange selectedRange = _commentTextView.selectedRange;
    if (selectedRange.length > 0) {
        [_commentTextView.textStorage deleteCharactersInRange:selectedRange];
    }
    //Insert emoji image
    [_commentTextView.textStorage insertAttributedString:str atIndex:_commentTextView.selectedRange.location];
    
    _commentTextView.selectedRange = NSMakeRange(_commentTextView.selectedRange.location+1, 0); // self.textView.selectedRange.length
    
    //Move selection location
    //_textView.selectedRange = NSMakeRange(_textView.selectedRange.location + 1, _textView.selectedRange.length);
    
    //Reset text style
    [self resetTextStyle];
}

- (void)drawRect:(CGRect)rect {
    
    // Drawing code
    self.frame = myframe;
    [self textViewDidChange:_commentTextView];
    
}
@end
