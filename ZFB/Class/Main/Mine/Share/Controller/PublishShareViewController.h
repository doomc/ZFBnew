//
//  PublishShareViewController.h
//  ZFB
//
//  Created by  展富宝  on 2017/9/14.
//  Copyright © 2017年 com.zfb. All rights reserved.
//

#import "BaseViewController.h"
#import "FSTextView.h"
#import "UITextView+ZWLimitCounter.h"


@interface PublishShareViewController : BaseViewController

@property (weak, nonatomic) IBOutlet FSTextView *textView;

@property (copy, nonatomic) NSString * goodId;
@property (copy, nonatomic) NSString * goodsPrice;
@property (copy, nonatomic) NSString * goodsName;

@property (weak, nonatomic) IBOutlet UIButton *commitBtn;

@property (weak, nonatomic) IBOutlet UITextField *tf_title;


- (IBAction)commitAction:(id)sender;

@end
