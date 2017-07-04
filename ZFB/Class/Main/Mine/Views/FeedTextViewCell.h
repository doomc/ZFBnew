//
//  FeedTextViewCell.h
//  ZFB
//
//  Created by  展富宝  on 2017/7/4.
//  Copyright © 2017年 com.zfb. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FSTextView.h"
#import "UITextView+ZWLimitCounter.h"



@interface FeedTextViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet FSTextView *textView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *textViewlayoutHeight;

//记录文字个数
@property (weak, nonatomic) IBOutlet UILabel *lb_textCount;

@property (copy, nonatomic) NSString *textViewValues;

@end
