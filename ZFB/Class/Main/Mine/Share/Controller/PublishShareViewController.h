//
//  PublishShareViewController.h
//  ZFB
//
//  Created by  展富宝  on 2017/9/14.
//  Copyright © 2017年 com.zfb. All rights reserved.
//

#import "BaseViewController.h"

@interface PublishShareViewController : BaseViewController

@property (weak, nonatomic) IBOutlet UIButton *commitBtn;

@property (weak, nonatomic) IBOutlet UITextField *tf_title;

@property (weak, nonatomic) IBOutlet UITextView *textView;

- (IBAction)commitAction:(id)sender;

@end
