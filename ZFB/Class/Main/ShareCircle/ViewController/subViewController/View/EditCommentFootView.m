//
//  EditCommentFootView.m
//  ZFB
//
//  Created by  展富宝  on 2017/11/30.
//  Copyright © 2017年 com.zfb. All rights reserved.
//

#import "EditCommentFootView.h"

@interface  EditCommentFootView ()<UITextViewDelegate>
{
    CGRect myframe;
}

@end

@implementation EditCommentFootView

-(instancetype)initWithFootViewFrame:(CGRect)frame AndPlacehold:(NSString *)placehold
{
    self = [super initWithFrame:frame];
    if (self) {
        self = [[NSBundle mainBundle]loadNibNamed:@"EditCommentFootView" owner:nil options:nil].lastObject;
        self.frame  = frame;
        self.textViewPlacehold = placehold;
        [self creatUI];
 
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
    self.holdLabel.text = _textViewPlacehold;
    self.holdLabel.textColor = [UIColor colorWithRed:200/255.0 green:200/255.0 blue:205/255.0 alpha:1];
    [_commentTextView addSubview:self.holdLabel];
 
}

- (IBAction)publishBtn:(id)sender {

    [_commentTextView resignFirstResponder];
    if ([self.footDelegate respondsToSelector:@selector(pushlishComment:)]) {
        [self.footDelegate pushlishComment:sender ];
    }
}

 



@end
