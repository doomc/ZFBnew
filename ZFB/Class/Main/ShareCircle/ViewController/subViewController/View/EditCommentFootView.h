//
//  EditCommentFootView.h
//  ZFB
//
//  Created by  展富宝  on 2017/11/30.
//  Copyright © 2017年 com.zfb. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol EditCommentFootViewDelegate <NSObject>
@required
-(void)textView:(UITextView *)textView textHeight:(CGFloat)height;

//发布评论
-(void)pushlishComment:(UIButton *)sender WithContent:(NSString *)content;

@end

@interface EditCommentFootView : UIView

-(instancetype)initWithFootViewFrame:(CGRect)frame;
@property (nonatomic,copy) NSString *textViewPlacehold;
@property (weak, nonatomic) IBOutlet UITextView *commentTextView;
@property (weak, nonatomic) IBOutlet UIButton *publish_btn;
@property (assign, nonatomic)  id <EditCommentFootViewDelegate> footDelegate;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *layoutConstarainHeight;

@end
