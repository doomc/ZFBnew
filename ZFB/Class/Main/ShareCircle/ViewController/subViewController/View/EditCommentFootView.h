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
 

//发布评论
-(void)pushlishComment:(UIButton *)sender ;

@end

@interface EditCommentFootView : UIView

-(instancetype)initWithFootViewFrame:(CGRect)frame AndPlacehold:(NSString *)placehold;

@property (nonatomic,copy) NSString *textViewPlacehold;
@property (nonatomic, strong) UILabel * holdLabel;
@property (nonatomic, copy  ) NSString * ecodeStr;

@property (weak, nonatomic) IBOutlet UITextView *commentTextView;
@property (weak, nonatomic) IBOutlet UIButton *publish_btn;

@property (assign, nonatomic)  id <EditCommentFootViewDelegate> footDelegate;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *layoutConstarainHeight;


@end
