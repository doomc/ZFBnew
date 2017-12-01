//
//  EditCommentFootView.h
//  ZFB
//
//  Created by  展富宝  on 2017/11/30.
//  Copyright © 2017年 com.zfb. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol EditCommentFootViewDelegate <NSObject>

-(void)textViewHeight:(CGFloat )textViewHeight;

//发布评论
-(void)pushlishCommentWithContent:(NSString *)content;

@end

@interface EditCommentFootView : UIView

-(instancetype)initWithFootViewFrame:(CGRect)frame;
@property (nonatomic,copy) NSString *textViewPlacehold;
@property (weak, nonatomic) IBOutlet UITextView *comment;
@property (weak, nonatomic) IBOutlet UIButton *publish_btn;
@property (assign, nonatomic)  id <EditCommentFootViewDelegate> footDelegate;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *layoutConstarainHeight;

@end
