//
//  EditCommentFootView.m
//  ZFB
//
//  Created by  展富宝  on 2017/11/30.
//  Copyright © 2017年 com.zfb. All rights reserved.
//

#import "EditCommentFootView.h"
@interface  EditCommentFootView ()<UITextViewDelegate>

@property (nonatomic,strong) UILabel * holdLabel;
@property (nonatomic,copy) NSString * text;
@property (nonatomic,assign) CGFloat  k_height;

@end

@implementation EditCommentFootView

-(instancetype)initWithFootViewFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self = [[NSBundle mainBundle]loadNibNamed:@"EditCommentFootView" owner:nil options:nil].lastObject;
        self.frame = frame;
        [self creatUI];
    }
    return self;
}

-(void)creatUI{
    
    _comment.delegate = self;
    _comment.textContainerInset = UIEdgeInsetsMake(10,0, 10,15);

    self.holdLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 5, 150, 30)];
    self.holdLabel.font = _comment.font;
    self.holdLabel.textColor = [UIColor colorWithRed:200/255.0 green:200/255.0 blue:205/255.0 alpha:1];
    [_comment addSubview:self.holdLabel];
 
}

- (IBAction)publishBtn:(id)sender {

    if ([self.footDelegate respondsToSelector:@selector(pushlishCommentWithContent:)]) {
        [self.footDelegate pushlishCommentWithContent:_text];
    }
}

-(void)textViewDidChange:(UITextView *)textView {
    //获得textView的初始尺寸
    CGFloat width = CGRectGetWidth(textView.frame);
    CGFloat height = CGRectGetHeight(textView.frame);
    CGSize newSize = [textView sizeThatFits:CGSizeMake(width,MAXFLOAT)];
    CGRect newFrame = textView.frame;
    newFrame.size = CGSizeMake(fmax(width, newSize.width), fmax(height, newSize.height));
    textView.frame= newFrame;
    if (textView.text.length == 0) {
        
        self.holdLabel.text = self.textViewPlacehold;
    }else{
        _text = textView.text;
        self.holdLabel.text = @"";
       _layoutConstarainHeight.constant  = newFrame.size.height +20;
 
//        [self.footDelegate textViewHeight:_k_height + 20];
        NSLog(@"newFrame ===== %f", _k_height);
        self.frame = CGRectMake(0, 0, KScreenW, _k_height+20);

    }
    
}
- (void)drawRect:(CGRect)rect {
    
    // Drawing code
    
    [self textViewDidChange:_comment];
    
}
@end
